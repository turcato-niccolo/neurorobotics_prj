function [fisher_scores] = fisherScore(PSD, run_labels, type_labels, run_codes, class_codes)
% [fisher_scores] = fisherScore(PSD, run_labels, type_labels, run_codes, class_codes)
%
% The function returns the fisher's score of each run for the PSD given in
% input
%
% Input arguments:
%   - PSD                   PSD matrix [windows x frequences x channels]
%   - run_labels            labelling vector (windows indexed) containing info on the run the
% windows is assigned to
%   - type_labels           labelling vector (windows indexed) containing info on the type of
% task the windows is assigned to
%   - run_codes             codes of the runs used in run_labels
%   - class_codes           class of tasks used in type_labels
%
% Output arguments:
%   - fisher_scores         fisher's score matrix for each run [frequences x channels x run]

num_classes = length(class_codes);
num_runs = length(run_codes);
num_freqs = size(PSD,2);
num_channels = size(PSD,3);

%we obtain one freqs x channels FisherScore matrix for each run
fisher_scores = nan(num_freqs, num_channels, num_runs);

for run_i = 1 : num_runs
    mask_run = (run_labels == run_codes(run_i));
    
    %vectors to accumulate expected values and standard deviations (freqs x channels x classes)
    expected_values    = nan(size(fisher_scores));
    standart_deviations = nan(size(fisher_scores));
    
    for class_i = 1 : num_classes
        mask_run_and_class = mask_run & (type_labels == class_codes(class_i));
        expected_values(:, :, class_i) = squeeze(mean(PSD(mask_run_and_class, :, :)));
        standart_deviations(:, :, class_i) = squeeze(std(PSD(mask_run_and_class, :, :)));
    end
    
    fisher_scores(:, :, run_i) = abs(expected_values(:, :, 2) - expected_values(:, :, 1)) ./ sqrt( ( standart_deviations(:, :, 1).^2 + standart_deviations(:, :, 2).^2 ) );
end
end

