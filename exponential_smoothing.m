function [accumulator] = exponential_smoothing(post_probabilities, num_classes, feedback_starts, alpha)
%   [accumulator] = exponential_smoothing(post_probabilities, num_classes, accumulation_trial_labels, alpha)
%
%   Input arguments:
%       -post_probabilities [samples x num_classes]
%       -num_classes [1 x 1] 
%       -feedback_starts [num_feedback x 1]: associates each sample to
%        a trial, contains starting time of each trial
%       -alpha [1 x 1]: smoothing value of the algorithm
%
%   Output arguments:
%       -accumulator [samples x 1]: smoothed posterior probabilities in
%        according to the smoothing algorithm
%
%
    %reset accumulation to the base probability of this class = 1/num_classes
    reset_accumulation = 1./num_classes;
    %contains the accumulation evidence for the sample_i of the training set
    accumulator = nan(size(post_probabilities, 1));
    
    %used to check if the trial is changed
    last_sample_trial_label = nan;
    num_samples = length(post_probabilities);
    
    % init accumulator
    accumulator(1) = reset_accumulation;
    % actual evidence accumulation
    for sample_i = 2:num_samples
        %if the sample is a start of a feedbck period
        if  ismember(sample_i, feedback_starts)
            % reset accumulation
            accumulator(sample_i) = reset_accumulation;
        else
            new_evidence  = post_probabilities(sample_i, 1);% (,1) for selecting both feet
            state = accumulator(sample_i - 1);
            accumulator(sample_i) = state.*alpha + new_evidence.*(1-alpha);
        end
    end
end

