clearvars; clc;
load('chanlocs16.mat')
chanlocs64 = readlocs('BioSemi64.loc');
selected_frequencies = (4:2:48)';
channel_labels  = {'Fz', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'C3', 'C1', 'Cz', 'C2', 'C4', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4'};

channel_64_labels = {'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1','C3','C5','T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7','PO3','O1','Iz','Oz','POz','Pz','CPz','Fpz','Fp2','AF8','AF4','Afz','Fz','F2','F4','F6','F8','FT8','FC6','FC4','FC2','FCz','Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6','P8','P10','PO8','PO4','O2'};

patients = find_patients('data');
classifiers_fold_root = '../classifiers/';

color_map = [   0.5 0.9 1
                0.4660 0.6740 0.1880
                1 1 0
                0.9290 0.6940 0.1250
                0.8500 0.3250 0.0980
                0.4940 0.1840 0.5560];

out_filename = 'patients_offline_results.xlsx';

%% AVG of selected features
patients_features_matrices = nan(length(selected_frequencies), length(channel_labels), length(patients));
for i=1:length(patients)
    patient = patients{i}.name;
    patients_features_matrices(:, :, i) = load(strcat(classifiers_fold_root, patient, '_feature_mask')).features_matrix;    
end

mu_band_ind = (3:5); %indices
beta_band_ind = (6:14); %indices

avg_feature_matrices_mu = sum(patients_features_matrices(mu_band_ind,:, :), 3);
avg_feature_matrices_beta = sum(patients_features_matrices(beta_band_ind,:, :), 3);



%% TOPOPLOT mu beta of selected features
plot_beta = sum(avg_feature_matrices_beta, 1);
plot_mu = sum(avg_feature_matrices_mu, 1);

max_num_features = max([plot_beta, plot_mu]);

figure
title('Plots with 16 electrodes')
subplot(1,2,1);
title('Beta band features');
topoplot(plot_beta, chanlocs16, 'style', 'both', 'electrodes', 'labelpoint', 'maplimits', [0, max_num_features], 'colormap', color_map);
colorbar;
subplot(1,2,2);
title('Mu band features');
topoplot(plot_mu, chanlocs16, 'style', 'both', 'electrodes', 'labelpoint', 'maplimits', [0, max_num_features], 'colormap', color_map);
colorbar;

%% convert to 64 electrodes topoplot

plot_beta_64 = zeros(1, length(channel_64_labels));
plot_mu_64 = zeros(1, length(channel_64_labels));
for i = 1:length(channel_64_labels)
    ispresent = cellfun(@(s) strcmp(cell2mat(channel_64_labels(i)), s), channel_labels);
    if sum(ispresent) > 0
        plot_beta_64(i) = plot_beta(ispresent);
        plot_mu_64(i) = plot_mu(ispresent);
    end
end

figure
title('Plots with 64 electrodes')
subplot(1,2,1);
title('Beta band features');
topoplot(plot_beta_64, chanlocs64, 'style', 'both', 'electrodes', 'labelpoint', 'maplimits', [0, max_num_features], 'colormap', color_map);
colorbar;
subplot(1,2,2);
title('Mu band features');
topoplot(plot_mu_64, chanlocs64, 'style', 'both', 'electrodes', 'labelpoint', 'maplimits', [0, max_num_features], 'colormap', color_map);
colorbar;
