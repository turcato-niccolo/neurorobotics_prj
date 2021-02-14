clearvars; clc;
selected_frequencies = (4:2:48)';
channel_labels  = {'Fz', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'C3', 'C1', 'Cz', 'C2', 'C4', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4'};
patients = find_patients('data');
classifiers_fold_root = '../classifiers/';

out_filename = 'patients_offline_results.xlsx';

%% AVG of selected features
patients_features_matrices = nan(length(selected_frequencies), length(channel_labels), length(patients));
for i=1:length(patients)
    patient = patients{i}.name;
    patients_features_matrices(:, :, i) = load(strcat(classifiers_fold_root, patient, '_feature_mask')).features_matrix;    
end
avg_feature_matrices = mean(patients_features_matrices(:,:,2:5), 3);
imagesc(squeeze(avg_feature_matrices)');
colorbar
axis square;
set(gca, 'XTick', 1:length(selected_frequencies));
set(gca, 'XTickLabel', selected_frequencies);
set(gca, 'YTick', 1:length(channel_labels));
set(gca, 'YTickLabel', channel_labels);


patients_train_ssa = zeros(length(patients),1);

patients_train_ssa_classes = zeros(length(patients), 2);
patients_train_ssa_confusion_matrix = zeros(length(patients), 2, 2);

%% Single-sample accuracy on training data (avg, classes, confusion matrix)
for i=1:length(patients)
    patient = patients{i}.name;
    patients_train_ssa(i) = load(strcat(classifiers_fold_root, patient, '_results_train')).accuracy;    
    patients_train_ssa_classes(i,:) = load(strcat(classifiers_fold_root, patient, '_results_train')).accuracy_per_class;
    patients_train_ssa_confusion_matrix(i, :, :) = load(strcat(classifiers_fold_root, patient, '_results_train')).confusion_matrix;
end

patients_train_ssa_avg = mean(patients_train_ssa);
patients_train_ssa_classes_avg = mean(patients_train_ssa_classes);

writematrix(patients_train_ssa, out_filename,'Sheet',1, 'Range', 'B2');
writematrix(patients_train_ssa_classes, out_filename,'Sheet',1, 'Range', 'C2');
writematrix(patients_train_ssa_avg, out_filename,'Sheet',1, 'Range', 'B10');
writematrix(patients_train_ssa_classes_avg, out_filename,'Sheet',1, 'Range', 'C10');


%% Evidence accumulation train results on tuning (after tuning on offline data)
patients_exp_performances_offline_tuning_train = zeros(length(patients), 3);
patients_dyn_performances_offline_tuning_train = zeros(length(patients), 3);
patients_mov_performances_offline_tuning_train = zeros(length(patients), 3);

for i=1:length(patients)
    patient = patients{i}.name;
    load(strcat(classifiers_fold_root, patient, '_off_tuning_ev_acc'))
    
    patients_exp_performances_offline_tuning_train(i, :) = [perf_active_ex, perf_resting_ex, perf_active_rej_ex];
    
    patients_dyn_performances_offline_tuning_train(i, :) = [perf_active_dyn, perf_resting_dyn, perf_active_rej_dyn];
    
    patients_mov_performances_offline_tuning_train(i, :) = [perf_active_mov, perf_resting_mov, perf_active_rej_mov];
end

writematrix(patients_exp_performances_offline_tuning_train, out_filename, 'Sheet',1, 'Range', 'F2');
writematrix(patients_dyn_performances_offline_tuning_train, out_filename, 'Sheet',1, 'Range', 'J2');
writematrix(patients_mov_performances_offline_tuning_train, out_filename, 'Sheet',1, 'Range', 'N2');

patients_exp_performances_offline_tuning_train_avg = mean(patients_exp_performances_offline_tuning_train);
writematrix(patients_exp_performances_offline_tuning_train_avg, out_filename, 'Sheet',1, 'Range', 'F10');

patients_dyn_performances_offline_tuning_train_avg = mean(patients_dyn_performances_offline_tuning_train);
writematrix(patients_dyn_performances_offline_tuning_train_avg, out_filename, 'Sheet',1, 'Range', 'J10');

patients_mov_performances_offline_tuning_train_avg = mean(patients_mov_performances_offline_tuning_train);
writematrix(patients_mov_performances_offline_tuning_train_avg, out_filename, 'Sheet',1, 'Range', 'N10');










