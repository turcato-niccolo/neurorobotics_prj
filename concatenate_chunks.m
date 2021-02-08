function [data_concatenated, EVENT_concatenated, run_k] = concatenate_chunks(chuncks)
% [data_concatenated, EVENT_concatenated, run_k] = concatenate_chunks(chuncks)
%
% The function returns the concatenation of all psd passed in input.
%
% Input arguments:
%   - chuncks               cell array with the following structure
%       + data              data to concatenate
%       + EVENT             vector of events
%           .POS            position of the event in the data
%           .TYP            type of the event
%           .DUR            duration of the event
%
% Output arguments:
%   - data_concatenated     matrix concatenation of all chunks
%   - EVENT_concatenated    EVENT structure containing (POS, DUR, TYP) info about all
%   events in the data_concatenated
%   - run_k                 assigns a label with the index of the chunk in
%   which the sample_i is

EVENT_concatenated.POS = [];
EVENT_concatenated.TYP = [];
EVENT_concatenated.DUR = [];
run_k = [];
data_concatenated = [] ;

for chunk_i = 1 : length(chuncks)
    
    chunck = chuncks{chunk_i};
    %save reference to the relative zero position
    zero_reference = size(data_concatenated, 1);
    
    %events indexed vectors
    %data locally dependent
    EVENT_concatenated.TYP = cat(1, EVENT_concatenated.TYP, chunck.EVENT.TYP);
    EVENT_concatenated.DUR = cat(1, EVENT_concatenated.DUR, chunck.EVENT.DUR);
    data_concatenated = cat(1, data_concatenated, chunck.data);
    %globaly dependent data
    EVENT_concatenated.POS = cat(1, EVENT_concatenated.POS, chunck.EVENT.POS + zero_reference);
    
    %windows indexed vectors
    num_windows = size(chunck.data, 1);
    
    run_k = cat(1, run_k, chunk_i .* ones(num_windows, 1));
    
end
end

