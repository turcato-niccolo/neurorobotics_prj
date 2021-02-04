function [PSD_out, frequences] = extractFrequences(PSD_in , original_freqs, selected_freqs)
% [PSD_out, freqs] = extractFrequences(PSD_in , original_freqs, selected_freqs)
%
% The function returns a PSD which has as frequences the intersection of
% the original ones with the given in input
%
% Input arguments:
%   - PSD_in            PSD matrix [original_freqs x channels]
%   - original_freqs    frequences on wich the PSD is based on
%   - selected_freqs    subset of frequences we want to keep in the PSD
%
% Output arguments:
%   - PSD_out           PSD with subsampled frequences [frequences x channels]
%   - frequences        frequences the new PSD is based on
[frequences, freqs_index] = intersect(original_freqs, selected_freqs);
PSD_out = PSD_in(:, freqs_index, :);

end

