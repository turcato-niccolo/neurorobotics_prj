function [dataset] = extract_features(PSD, selected_freq_chan_index)
% [dataset] = extract_features(PSD, selected_freq_chan_index)
% The function returns the data extracted from the PSD with respect to the
% features given in input
%
% Input arguments:
%   - PSD                           PSD matix [windows x frequences x channels]
%   - selected_freq_chan_index      cell array with elements (frequence_index,
% channel_index) for the features to be selected from the whole PSD
%
% Output arguments:
%   - dataset                       [windows x features] matrix containing all and only the
%   selected fetaures

num_features = length(selected_freq_chan_index);
num_windows  = size(PSD, 1);

dataset = nan(num_windows, num_features);
for feature_i = 1 : num_features
    freq_index  = selected_freq_chan_index{feature_i}(1);
    channel_index = selected_freq_chan_index{feature_i}(2);
    dataset(:, feature_i) = PSD(:, freq_index, channel_index);
end
end

