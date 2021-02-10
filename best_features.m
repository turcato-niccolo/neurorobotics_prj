function [features] = best_features(fisher_score, num_features_to_select)
% [features] = best_features(fisher_score, num_features_to_select)
%
% The function returns the index of the best features with respect to the
% fisher score matrix.
%
% Input arguments:
%   - fisher_score              Fisher score matrix [samples x channels]
%   - num_features_to_select    Number of features to select
%
% Output arguments:
%   - features                  cell array with elements (frequence_index,
% channel_index) for the selected features

%sorting the elements of the fisher score matrix
[~,sortingIndex] = sort(fisher_score(:),'desc');
%select the first ones (the larger ones since is sorted) and convert
%their index with respect to the linear vector in the fisher matrix
[selected_freq, selected_channels] = ind2sub(size(fisher_score),sortingIndex(1:num_features_to_select));

%concatenate the two indexes in a cell
features = mat2cell(reshape([selected_freq, selected_channels], num_features_to_select, []), ones(1, num_features_to_select));
end

