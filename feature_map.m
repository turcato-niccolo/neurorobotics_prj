function [map] = feature_map(selected_freq_chan_index, map_size)
%FEATURE_MAP Summary of this function goes here
%   Detailed explanation goes here
map = zeros(map_size);

for k = 1 : length(selected_freq_chan_index)
    feature_index = selected_freq_chan_index{k};
    map(feature_index(1), feature_index(2)) = 1;
end
end

