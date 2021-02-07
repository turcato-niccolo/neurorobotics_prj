function [PSD_concatenated, EVENT_concatenated, run_k] = concatenatePSD(PSD_data)
% [EVENT_concatenated, run_labels, modality_labels, PSD_concatenated, sample_rate, freqs] = concatenatePSD(PSD_data)
%
% The function returns the concatenation of all psd passed in input.
%
% Input arguments:
%   - PSD_data              cell array with data structure of the psd
%   inside [windows x frequences x channels]
%   data structure accepred [EVENT.(POS,TYP,DUR), frequences, modality, sample_rate, PSD]
%
% Output arguments:
%   - PSD_concatenated      matrix concatenation of all PSD
%   - EVENT_concatenated    EVENT structure containing (POS, DUR, TYP, MOD) info about all
%   events in the concatenated PSD
%   - run_k                 assigns a label with the run index to all
%   windows of the concatenated PSD

EVENT_concatenated.POS = [];
EVENT_concatenated.TYP = [];
EVENT_concatenated.DUR = [];
run_k = [];
PSD_concatenated = [] ;

for run_i = 1 : length(PSD_data)
    
    data = PSD_data{run_i};
    
    %save reference to the relative zero position
    zero_reference = size(PSD_concatenated,1);
    
    %events indexed vectors
    %data locally dependent
    EVENT_concatenated.TYP = cat(1, EVENT_concatenated.TYP, data.EVENT.TYP);
    EVENT_concatenated.DUR = cat(1, EVENT_concatenated.DUR, data.EVENT.DUR);
    PSD_concatenated = cat(1, PSD_concatenated, data.PSD);
    %globaly dependent data
    EVENT_concatenated.POS = cat(1, EVENT_concatenated.POS, data.EVENT.POS + zero_reference);
    
    %windows indexed vectors
    num_windows = size(data.PSD, 1);
    
    run_k = cat(1, run_k, run_i .* ones(num_windows, 1));
    
end
end

