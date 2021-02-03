function [X, cue_type_labels, trial_labels, modality_labels, selected_freq_chan_index , fisher_score_run] = psd2features(PSD_data, num_features ,feature_weights)
% [X, cue_type_labels, trial_labels, modality_labels, selected_freq_chan_index , fisher_score_run] = psd2features(PSD_data, num_features ,feature_weights)
%
% The function extracts the data to be used to train the classifiers (remember to normalize the PSD e.g. with log())
%
% Input arguments:
%   - PSD_data                  cell array of [windows x frequences x channels] 
%   matrices containing the psd data [EVENT(POS DUR TYP conversion), frequences, sample_rate, PSD, modality]
%   - num_features              number of features to extract
%   - feature_weights           (optional) weight to modify the priority of
%   the features extracted with respect to their fisher's score
%
% Output arguments:
%   - X                         [windows x feature] matrix that is the
%   dataset to use in training
%   - cue_type_labels           [windows x 1] vector that associates a cue
%   action to each windows
%   - trial_labels              [windows x 1] vector that associates a
%   trial to each windows
%   - modality_labels           [windows x 1] vector that associates a 
%   modality to each windows
%   - selected_freq_chan_index  cell array containing the coordinates of all 
%   selected features     
%   - fisher_score_run          [freqences x channels x runs] atrix
%   containing one fisher's score matrix for each run

%mnemonic codes
code.fixation = 786;
code.cue_BH = 773;
code.cue_BF = 771;
code.cue_rest = 783;
code.feedback = 781;

%% concatenate files
[PSD, EVENT, run_labels, modality_labels] = concatenatePSD(PSD_data);

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

