function [logical_index] = labels_for_event(EVENT, type, num_points)
% [logical_index] = labels_for_event(EVENT, type, num_points)
%
% The function returns a logical index for extracting the desired type of
% event from the data
%
% Input arguments:
%   - EVENT                 structure with the following fields
%   (POS,TYP,DUR)for each event in the data
%   - type                	event the index is for
%   - num_points           	number of samples in the data
%
% Output arguments:
%   - logical_index         the logical index to extract the desired event

logical_index = false(num_points, 1);
num_events = length(EVENT.TYP);
for event_i = 1:num_events
    if EVENT.TYP(event_i) == type
        start = EVENT.POS(event_i);
        stop = start + EVENT.DUR(event_i) -1;
        logical_index(start:stop) = true;
    end
end
end

