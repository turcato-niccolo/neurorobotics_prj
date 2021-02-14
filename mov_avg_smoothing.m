function [accumulator] = mov_avg_smoothing(post_probabilities, num_classes, feedback_starts, alpha)
% [accumulator] = mov_avg_smoothing(post_probabilities, num_classes, feedback_starts, alpha)
%
%   The function returns the smoothed posterior probabilities with respect
%   to the moving average smoothing algorithm
%            
%  	Note: the function will only consider the first class' posterior
%  	probabilities 
%
% 	First class: values tending to 1
% 	Second class: values tending to 0
% 	Undecided: in the middle
%
% Input arguments:
%   -post_probabilities [samples x num_classes] post probabilities of the
%   class from the classifier
% 	-num_classes        number of classes
% 	-feedback_starts    [num_feedback x 1]: associates each sample to
%  	a trial, contains   starting time of each trial
%  	-alpha              smoothing value of the algorithm
%
% Output arguments:
%	-accumulator [samples x 1]: smoothed posterior probabilities in
% 	according to the smoothing algorithm


num_samples = length(post_probabilities);
%reset accumulation to the base probability of this class = 1/num_classes
reset_accumulation = 1./num_classes;
%contains the accumulation evidence for the sample_i of the training set
accumulator = nan(num_samples, 1);

% init accumulator
accumulator(1) = reset_accumulation;
% actual evidence accumulation
last_starting = 1;
for sample_i = 2:num_samples
    %if the sample is a start of a feedbck period
    if  ismember(sample_i, feedback_starts)
        % reset accumulation
        accumulator(sample_i) = reset_accumulation;
        last_starting = sample_i;
    else
        curr_values = [accumulator(last_starting:sample_i-1); post_probabilities(sample_i,1)];
        new_evidence = mean(curr_values);
        state = post_probabilities(sample_i,1);
        accumulator(sample_i) = alpha * state + (1-alpha) * new_evidence ;
    end
end
end

