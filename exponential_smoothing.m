function [accumulator] = exponential_smoothing(post_probabilities, num_classes, accumulation_trial_labels, alpha)
%   [accumulator] = exponential_smoothing(post_probabilities, num_classes, accumulation_trial_labels, alpha)
%
%   Input arguments:
%       -post_probabilities [samples x num_classes]
%       -num_classes [1 x 1] 
%       -accumulation_trial_labels [samples x 1]: associates each sample to
%        a trial
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
    accumulator = nan(size(accumulation_trial_labels));
    
    %used to check if the trial is changed
    last_sample_trial_label = nan;
    num_samples = length(post_probabilities);
    
    for sample_i = 1:num_samples
    
        if last_sample_trial_label ~= accumulation_trial_labels(sample_i)
            %if the trial is changed reset the probability
            accumulator(sample_i) = reset_accumulation;
        else
            %if the trial is not changed accumulate the next evidence
            new_evidence  = post_probabilities(sample_i, 1);% (,1) for selecting both feet
            state = accumulator(sample_i - 1);
            accumulator(sample_i) = state.*alpha + new_evidence.*(1-alpha);
        end
        %update the trial changed check
        last_sample_trial_label = accumulation_trial_labels(sample_i);
    end
end

