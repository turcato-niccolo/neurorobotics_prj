function [y] = f_free(x, conservative_amp, w)
% [y] = f_free(x, conservative_amp, w)
%
% The function returns the value of the free force function on the state x
%
% Input arguments:
%   - x                 the state
%   - conservative_amp  the amplitude of the wave
%   - w                 the portion in both direction around 0.5 that is considered to mantain
%   stationary
%
% Output arguments:
%   - y                 the value of the free force function on the state x

    if (x < 0.5 - w)
        y = -sin(pi .* x ./ (0.5-w));
    elseif (x > 0.5 + w)
            y = sin(pi ./(0.5 -w) .*(x -0.5 - w));
    else
            y = -conservative_amp * sin(pi ./ w .* (x - 0.5));
    end
        
end