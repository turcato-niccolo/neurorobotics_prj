clearvars; clc;
selected_frequencies = (4:2:48)';
channel_labels  = {'Fz', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'C3', 'C1', 'Cz', 'C2', 'C4', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4'};
patients = find_patients('data');
classifiers_fold_root = '../classifiers/';
results_fold_root = '../online-results/';

patients_test_ssa = zeros(length(patients), 1);
patients_test_ssa_classes = zeros(length(patients), 2);
patients_test_ssa_confusion_matrix = zeros(length(patients), 2, 2);

%% Single-sample accuracy on test data (avg, classes, confusion matrix)
for i=1:length(patients)
    patient = patients{i}.name;
    patients_test_ssa(i) = load(strcat(results_fold_root, patient, '_single_sample')).accuracy;    
    patients_test_ssa_classes(i,:) = load(strcat(results_fold_root, patient, '_single_sample')).accuracy_per_class;
    patients_test_ssa_confusion_matrix(i, :, :) = load(strcat(results_fold_root, patient, '_single_sample')).confusion_matrix;
end

%% Evidence accumulation test results for tuning on offline data

patients_exp_performances_offline_tuning_test = zeros(length(patients), 3);
patients_dyn_performances_offline_tuning_test = zeros(length(patients), 3);
patients_mov_performances_offline_tuning_test = zeros(length(patients), 3);

for i=1:length(patients)
    patient = patients{i}.name;
    load(strcat(results_fold_root, patient, '_off_tuning_test_ev_acc'))
    
    patients_exp_performances_offline_tuning_test(i, :) = [off_tun_perf_active_ex, off_tun_perf_resting_ex, off_tun_perf_active_rej_ex];
    
    patients_dyn_performances_offline_tuning_test(i, :) = [off_tun_perf_active_dyn, off_tun_perf_resting_dyn, off_tun_perf_active_rej_dyn];
    
    patients_mov_performances_offline_tuning_test(i, :) = [off_tun_perf_active_mov, off_tun_perf_resting_mov, off_tun_perf_active_rej_mov];
end

patients_exp_performances_offline_tuning_test_avg = mean(patients_exp_performances_offline_tuning_test);
patients_dyn_performances_offline_tuning_test_avg = mean(patients_dyn_performances_offline_tuning_test);
patients_mov_performances_offline_tuning_test_avg = mean(patients_mov_performances_offline_tuning_test);


%% Evidence accumulation train results for tuning on online data (tuning on first online run)
patients_exp_performances_online_tuning_train = zeros(length(patients), 3);
patients_dyn_performances_online_tuning_train = zeros(length(patients), 3);
patients_mov_performances_online_tuning_train = zeros(length(patients), 3);

for i=1:length(patients)
    patient = patients{i}.name;
    load(strcat(results_fold_root, patient, '_online_tuning_ev_acc'))
    
    patients_exp_performances_online_tuning_train(i, :) = [perf_active_ex, perf_resting_ex, perf_active_rej_ex];
    
    patients_dyn_performances_online_tuning_train(i, :) = [perf_active_dyn, perf_resting_dyn, perf_active_rej_dyn];
    
    patients_mov_performances_online_tuning_train(i, :) = [perf_active_mov, perf_resting_mov, perf_active_rej_mov];
end

patients_exp_performances_online_tuning_train_avg = mean(patients_exp_performances_online_tuning_train);
patients_dyn_performances_online_tuning_train_avg = mean(patients_dyn_performances_online_tuning_train);
patients_mov_performances_online_tuning_train_avg = mean(patients_mov_performances_online_tuning_train);


%% Evidence accumulation test results for tuning on online data (tuning on first online run)

patients_exp_performances_online_tuning_test = zeros(length(patients), 3);
patients_dyn_performances_online_tuning_test = zeros(length(patients), 3);
patients_mov_performances_online_tuning_test = zeros(length(patients), 3);

for i=1:length(patients)
    patient = patients{i}.name;
    load(strcat(results_fold_root, patient, '_online_tuning_test_ev_acc'))
    
    patients_exp_performances_online_tuning_test(i, :) = [perf_active_ex, perf_resting_ex, perf_active_rej_ex];
    
    patients_dyn_performances_online_tuning_test(i, :) = [perf_active_dyn, perf_resting_dyn, perf_active_rej_dyn];
    
    patients_mov_performances_online_tuning_test(i, :) = [perf_active_mov, perf_resting_mov, perf_active_rej_mov];
end

patients_exp_performances_online_tuning_test_avg = mean(patients_exp_performances_online_tuning_test);
patients_dyn_performances_online_tuning_test_avg = mean(patients_dyn_performances_online_tuning_test);
patients_mov_performances_online_tuning_test_avg = mean(patients_mov_performances_online_tuning_test);














