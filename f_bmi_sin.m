function [y] = f_bmi_sin(x)
% [y] = f_bmi_sin(x)
%
% The function returns the value of the sine wave BMI function on the evidence x
%
% Input arguments:
%   - y         the value of the sine wave BMI function on the evidence x
%
% Output arguments:
%   - x         the evidence
    y = (asin(2*(x -0.5))./asin(1)).*(0.5*(1+cos(2*pi*x)));
end