function [PSD_concatenated, EVENT_concatenated, run_labels, modality_labels, sample_rate, freqs] = concatenatePSD(PSD_data)
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
%   - run_labels            assigns a label with the run index to all
%   windows of the concatenated PSD
%   - modality_labels       assigns a label with the modality index to all
%   windows of the concatenated PSD
%   - sample_rate           sample rate of the PSD
%   - freqs                 frequences dimension of the PSD

EVENT_concatenated.POS = [];
EVENT_concatenated.TYP = [];
EVENT_concatenated.DUR = [];
EVENT_concatenated.MOD = [];
run_labels = [];
modality_labels = [];
PSD_concatenated = [] ;
sample_rate = nan;
freqs = nan;

for run_i = 1 : length(PSD_data)
    
    data = PSD_data{run_i};
    sample_rate = data.sample_rate;
    freqs = data.frequences;
    modality = data.modality;
    
    %save reference to the relative zero position
    zero_reference = size(PSD_concatenated,1);
    
    %events indexed vectors
    %data locally dependent
    EVENT_concatenated.TYP = cat(1, EVENT_concatenated.TYP, data.EVENT.TYP);
    EVENT_concatenated.DUR = cat(1, EVENT_concatenated.DUR, data.EVENT.DUR);
    EVENT_concatenated.MOD = cat(1, EVENT_concatenated.MOD, modality .* ones(length(data.EVENT.TYP), 1));
    PSD_concatenated = cat(1, PSD_concatenated, data.PSD);
    %globaly dependent data
    EVENT_concatenated.POS = cat(1, EVENT_concatenated.POS, data.EVENT.POS + zero_reference);
    
    %windows indexed vectors
    num_windows = size(data.PSD, 1);
    
    run_labels = cat(1, run_labels, run_i .* ones(num_windows, 1));
    
    modality_labels = cat(1, modality_labels, modality .* ones(num_windows, 1));
    
end
end

