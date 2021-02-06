function [y] = f_bmi(x)
% [y] = f_bmi(x)
%
% The function returns the value of the cubic BMI function on the evidence x
%
% Input arguments:
%   - y         the value of the cubic BMI function on the evidence x
%
% Output arguments:
%   - x         the evidence

    y = 6.4 .* (x - 0.5).^3 + 0.4 .* (x - 0.5);
end