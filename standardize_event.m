function [standardized_EVENT] = standardize_event(EVENT)
%[standardized_EVENT] = standardize_event(EVENT)
%
% This function standardize the EVENT structure to (POS,DUR,TYP) with only
%
%   Input arguments:
%   -EVENT                  EVENT structure to standardize
%
%   Output arguments:
%   -standardized_EVENT     EVENT structure standardized

if(~isfield(EVENT, 'DUR')) %Often disappears
    standardized_EVENT.TYP = EVENT.TYP(1:2:end);
    standardized_EVENT.POS = EVENT.POS(1:2:end);
    standardized_EVENT.DUR = EVENT.POS(2:2:end) - standardized_EVENT.POS;
else
    standardized_EVENT = EVENT;
end
end

