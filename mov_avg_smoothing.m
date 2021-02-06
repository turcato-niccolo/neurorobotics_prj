function [accumulator] = mov_avg_smoothing(post_probabilities, num_classes, feedback_starts, alpha)
%   [accumulator] = mov_avg_smoothing(post_probabilities, num_classes, feedback_starts)
%
%   Input arguments:
%       -post_probabilities [samples x num_classes]
%       -num_classes [1 x 1] 
%       -feedback_starts [num_feedback x 1]: associates each sample to
%        a trial, contains starting time of each trial
%
%       First class: values tending to 1
%       Second class: values tending to 0
%       Undecided: in the middle
%            
%       Note: the function will only consider the first class' posterior
%       probabilities, see the lessons' slides for details   
%
%
%

    %reset accumulation to the base probability of this class = 1/num_classes
    reset_accumulation = 1./num_classes;
    %contains the accumulation evidence for the sample_i of the training set
    accumulator = nan([size(post_probabilities,1) 1]);
    
    %used to check if the trial is changed
    num_samples = length(post_probabilities);
    
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

