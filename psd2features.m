function [X, cue_type_labels, trial_labels, modality_labels, selected_freq_chan_index , fisher_score_run, freqs, sample_rate] = psd2features(PSD_data, selected_frequences, num_features ,feature_weights)
%[X, cue_type_labels, trial_labels, modality_labels, selected_freq_chan_index , fisher_score_run, freqs] = psd2features(PSD_data, selected_frequences, num_features ,feature_weights)
%   The function extracts the data to be used to train the models
%
% Input arguments:
%   - PSD                   PSD matrix [windows x frequences x channels]
%   - run_labels            labelling vector (window indexed) containing info on the run the
% window is assigned to
%   - type_labels           labelling vector (window indexed) containing info on the type of
% task the window is assigned to
%   - run_codes             codes of the runs used in run_labels
%   - class_codes           class of tasks used in type_labels
%
% Output arguments:
%   - fisher_scores         fisher's score matrix for each run [frequences x channels x run]

%mnemonic codes
code.fixation = 786;
code.cue_BH = 773;
code.cue_BF = 771;
code.cue_rest = 783;
code.feedback = 781;

%% concatenate files
[PSD, EVENT, run_labels, modality_labels, sample_rate, freqs] = concatenatePSD(PSD_data);

%% log and sub-frequences extraction
%psd is windows x freq x channels
%extract selected subfrequences
[PSD,freqs] = extractFrequences(PSD, freqs, selected_frequences);
%apply log to normalize the distribution
PSD = log(PSD);

%% masks to extract desired data from psd
num_windows  = size(PSD, 1);
run_codes = unique(run_labels);

[cue_type_labels, trial_labels] = labelData(EVENT, num_windows);

%% Computing fisher score (for each run)
classes = [code.cue_BF code.cue_BH];
fisher_score_run = fisherScore(PSD, run_labels, cue_type_labels, run_codes, classes);
mean_fisher_score = mean(fisher_score_run, 3);

%% Features selection
if ~exist('feature_weights','var')
    % third parameter does not exist, so default it to something
    feature_weights = ones(size(mean_fisher_score));
end
filtered_mean_fisher = mean_fisher_score .* feature_weights';
selected_freq_chan_index = bestFeatures(filtered_mean_fisher, num_features);

%% Features extraction
X = extractFeatures(PSD , selected_freq_chan_index);
    
end

