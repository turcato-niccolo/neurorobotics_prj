%Selection of k features
clearvars; clc;
selected_frequencies = (4:2:48)';
channel_labels  = {'Fz', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'C3', 'C1', 'Cz', 'C2', 'C4', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4'};
patients = find_patients('data');
classifiers_fold_root = '../classifiers/';

info.fixation_code = 786;
info.cue_BH = 773;
info.cue_BF = 771;
info.cue_rest = 783;
info.feedback_code = 781;
info.offline_mode = 0;
info.online_mode = 1;


% Weights for channels and frequencies.
features_weight = load('features_filter.mat').features_filter';

min_features_n = 1;
max_features_n = 10;

patients_best_acc = zeros(length(patients),1);
patients_best_n_features = zeros(length(patients),1);;

for i=1:length(patients)
    %% Load offline data
    patient = patients{i};
    PSD_data_off = cell(size(patient.offline_files));
    for f = 1:length(patient.offline_files)
        % Raw EEG
        [s, h] = sload(patient.offline_files{f});

        % Apply Lap and compute PSD
        PSD_data_off{f} = psd_extraction(s, h);
    end
    info.frequencies = PSD_data_off{1}.frequencies;
    
    [PSD_off, EVENT_off, run_k_off] = concatenatePSD(PSD_data_off);
    [cue_k_off, trial_k_off] = label_data(EVENT_off, length(PSD_off));
    [PSD_off, info.frequencies]= extract_frequencies(PSD_off, info.frequencies, selected_frequencies);
    PSD_off = log(PSD_off); 
    classes = [info.cue_BF, info.cue_BH];
    
        
    %try with different number of features
    
    accuracies = zeros(max_features_n-min_features_n+1,1);
    
    for n_features = min_features_n:max_features_n
        [selected_features , fisher_score_run] = psd2features(PSD_off, run_k_off, cue_k_off, classes, n_features, features_weight);
        dataset_offline = extract_features(PSD_off, selected_features);
        
        bh_index_offline = (cue_k_off== info.cue_BH);
        bf_index_offline = (cue_k_off== info.cue_BF);

        dataset_offline = dataset_offline(bh_index_offline | bf_index_offline, :);
        true_labels = cue_k_off(bh_index_offline | bf_index_offline);
        
        num_samples = size(dataset_offline, 1);
        train_samples = floor((num_samples * 2) / 3);
        % 2/3 af data to train, 1/3 to validate
        
        train_set = dataset_offline(1:train_samples, :);
        train_labels = true_labels(1:train_samples, :);
        
        val_set = dataset_offline(train_samples+1:end, :);
        val_labels = true_labels(train_samples+1:end, :);
        
        model = train_binary_model(train_set, train_labels);
        %predicted_labels = predict(model, train_set);
        
        %Validate on val data
        predicted_labels_val = predict(model, val_set);
        [accuracy, accuracy_per_class] = evaluate_classifier(val_labels, predicted_labels_val, classes)
        
        accuracies(n_features) = accuracy;
    end 
    
    best_n_features_for_patient = find(accuracies == max(accuracies));
    patients_best_acc(i,1) = accuracies(accuracies == max(accuracies));
    patients_best_n_features(i,1) = best_n_features_for_patient;
end

best_best_n_features = sum(patients_best_acc .* patients_best_n_features)./sum(patients_best_acc)
%curr best = 3.7
std_n_features = std(patients_best_n_features, patients_best_acc)
%curr best = 1.4

