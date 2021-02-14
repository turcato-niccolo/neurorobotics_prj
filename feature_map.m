function [map] = feature_map(selected_freq_chan_index, map_size)
% [map] = feature_map(selected_freq_chan_index, map_size)
%
% The function returns a map of the selected features (1 selected, 0 not selected)
%
% Input arguments:
%   -selected_freq_chan_index   a cell array conatining pairs of index only
%   for the selected features
% 	-map_size                   the size of the matrix of all the possible features     
%
% Output arguments:
%	-map                        the map of all features (1 selected, 0 not selected)

map = zeros(map_size);

for k = 1 : length(selected_freq_chan_index)
    feature_index = selected_freq_chan_index{k};
    map(feature_index(1), feature_index(2)) = 1;
end
end

