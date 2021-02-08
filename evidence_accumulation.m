function accumulated = evidence_accumulation(pp, feedback_starts, func)
% EVIDENCE_ACCUMULATION  Use a function to smooth data for evidence
% accumulation.
%
% The function smooths the values in pp according to func, resetting the
% probability to 0.5 at the start of each trial. This function is meant
% for binary classification. Accumulated values are computed based on the
% posterior probabilities for class 1 (pp(:, 1));
%
% Inputs:
%   pp - Posterior probabilities. [samples x 2]
%
%   feedback_starts - The index of all trial starts.
%
%   func - The function to use for accumulation. Must take the original
%          data, the accumulated data, the last feedback's start and the
%          desired sample index as inputs, and return the corresponding
%          accumulated value. Example for exponential smoothing:
%          @(x, a, f, i) a(i-1)*alpha + x(i).*(1-alpha);
%
% Outputs:
%   accumulated - The vector of accumulated values.

num_samples = size(pp, 1);
accumulated = nan(num_samples, 1);
accumulated(1) = 0.5;
last_feedback = 1;

for i = 2:num_samples
    % Sample is the start of a feedback
    if  ismember(i, feedback_starts)
        % Reset accumulation to 0.5
        accumulated(i) = 0.5;
        last_feedback = i;
    else
        % Compute the next sample.
        accumulated(i) = func(pp, accumulated, last_feedback, i);
    end
end

end

