function [selected_features, fisher_score_run] = psd2features(PSD, run_k, cue_k, classes, num_features ,features_weight)
% [selected_features, fisher_score_run] = psd2features(PSD, run_k, cue_k, classes, num_features ,features_weight)
%
% The function extracts the data to be used to train the classifiers (remember to normalize the PSD e.g. with log())
%
% Input arguments:
%   - PSD_data                  [windows x frequences x channels] matrix
%   containing PSD data
%   - run_k                     [windows x 1] vector that associates a run
%   number to each windows 
%   - cue_k                     [windows x 1] vector that associates a cue
%   task to each windows
%   -classes                    vector containing one code for each class
%   - num_features              number of features to extract
%   - features_weight           (optional) weight to modify the priority of
%   the features extracted with respect to their fisher's score
%
% Output arguments:
%   - selected_frequences       cell array containing the coordinates of all 
%   selected features     
%   - fisher_score_run          [freqences x channels x runs] atrix
%   containing one Fisher's score matrix for each run

%% Computing fisher score (for each run)

run_codes = unique(run_k);
fisher_score_run = fisher_score(PSD, run_k, cue_k, run_codes, classes);
mean_fisher_score = mean(fisher_score_run, 3);

%% Features selection
if ~exist('features_weight','var')
    %default weights are a matrix of all ones
    features_weight = ones(size(mean_fisher_score));
end
filtered_mean_fisher = mean_fisher_score .* features_weight;
selected_features = best_features(filtered_mean_fisher, num_features);
    
end

