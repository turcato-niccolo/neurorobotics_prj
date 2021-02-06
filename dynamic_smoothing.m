function [accumulator] = dynamic_smoothing(post_probabilities, num_classes, feedback_starts, alpha, beta, conservative_amplitude)
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

    %reset accumulation to the base probability of this class = 1/num_classes
    reset_accumulation = 1./num_classes;
    %contains the accumulation evidence for the sample_i of the training set
    accumulator = nan(size(post_probabilities,1));
    
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
            %if the trial is not changed accumulate the next evidence
            new_evidence = alpha * f_free_val(conservative_amplitude, accumulator(sample_i-1));
            new_evidence = new_evidence + (1-alpha)*f_bmi_val(post_probabilities(sample_i,1));
            new_evidence  = beta * new_evidence;
            % delta_y = beta * (alpha * f_free(y_t-1) + (1-alpha) * f_bmi(x_t))
            state = accumulator(sample_i - 1);
            accumulator(sample_i) = state + max(min(new_evidence,1),0);
        end
    end
    
end

function [y] = f_free_val(conservative_amp, x)

    if (x <= 0.3)
        y = -sin(pi*x/0.3);
    else
        if (x >= 0.7)
            y = sin(pi*(x-0.7)/0.3);
        else
            y = conservative_amp * sin((1./0.2)*pi*(x-0.3));
        end
    end
        
end

function [y] = f_bmi_val(x)
    %y = (asin(2*x +0.5)./asin(1));
    y = (asin(2*(x -0.5))./asin(1)).*(0.5*(1+cos(2*pi*x)));
end