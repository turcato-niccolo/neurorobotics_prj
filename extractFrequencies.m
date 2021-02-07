function [PSD_out, frequencies] = extractFrequencies(PSD_in , original_freqs, selected_freqs)
% [PSD_out, freqs] = extractFrequencies(PSD_in , original_freqs, selected_freqs)
%
% The function returns a PSD which has as frequencies the intersection of
% the original ones with the given in input
%
% Input arguments:
%   - PSD_in            PSD matrix [original_freqs x channels]
%   - original_freqs    frequencies on wich the PSD is based on
%   - selected_freqs    subset of frequencies we want to keep in the PSD
%
% Output arguments:
%   - PSD_out           PSD with subsampled frequencies [frequencies x channels]
%   - frequencies        frequencies the new PSD is based on
[frequencies, freqs_index] = intersect(original_freqs, selected_freqs);
PSD_out = PSD_in(:, freqs_index, :);

end

