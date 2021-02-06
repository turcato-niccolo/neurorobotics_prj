function [y] = f_free(x, conservative_amp, w)
% [y] = f_free(x, conservative_amp, w)
%
% The function returns the value of the free force function on the state x
%
% Input arguments:
%   - y         the value of the free force function on the state x
%
% Output arguments:
%   - x         the state
    if (x < 0.5 - w)
        y = -sin(pi .* x ./ (0.5-w));
    elseif (x > 0.5 + w)
            y = sin(pi ./(0.5 -w) .*(x -0.5 - w));
    else
            y = -conservative_amp * sin(pi ./ w .* (x - 0.5));
    end
        
end