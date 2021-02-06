function [accumulator] = dynamic_smoothing(post_probabilities, num_classes, feedback_starts, alpha, beta, free_force_function, bmi_force_function)
%   [accumulator] = exponential_smoothing(post_probabilities, num_classes, accumulation_trial_labels, alpha)
%
%   Input arguments:
%       -post_probabilities [samples x num_classes]
%       -num_classes [1 x 1] 
%       -feedback_starts [num_feedback x 1]: associates each sample to
%        a trial, contains starting time of each trial
%       -alpha [1 x 1]: smoothing value of the algorithm
%       -beta [1 x 1]:  smoothing value of the algorithm
%       -conservative_amplitude [1 x 1]: amplitude of the conservative
%        "zone" of f_free function (see dynamic control paradigm for full
%        details)
%
%       First class: values tending to 1
%       Second class: values tending to 0
%       Undecided: in the middle
%            
%       Note: the function will only consider the first class' posterior
%       probabilities, see the lessons' slides for details   

    num_samples = length(post_probabilities);
    %reset accumulation to the base probability of this class = 1/num_classes
    reset_accumulation = 1./num_classes;
    %contains the accumulation evidence for the sample_i of the training set
    accumulator = nan(num_samples, 1);
    
    % init accumulator
    accumulator(1) = reset_accumulation;
    % actual evidence accumulation
    for sample_i = 2:num_samples
        %if the sample is a start of a feedbck period
        if  ismember(sample_i, feedback_starts)
            % reset accumulation
            accumulator(sample_i) = reset_accumulation;
        else
            state = accumulator(sample_i -1);
            new_evidence  = post_probabilities(sample_i, 1);% (,1) for selecting both feet
            %if the trial is not changed accumulate the next evidence
            delta_y = beta .* (alpha .* free_force_function(state) + (1-alpha) .* bmi_force_function(new_evidence));
            accumulator(sample_i) = max(min(state + delta_y,1),0);
        end
    end
    
end