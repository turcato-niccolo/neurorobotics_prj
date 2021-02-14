function [accumulator] = dynamic_smoothing(post_probabilities, num_classes, feedback_starts, alpha, beta, free_force, bmi_force)
% [accumulator] = dynamic_smoothing(post_probabilities, num_classes, feedback_starts, alpha, beta, free_force, bmi_force)
%
%   The function returns the smoothed posterior probabilities with respect
%   to the dynamical smoothing algorithm
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
% 	-beta               smoothing value of the algorithm
% 	-free_force         function that takes in input the old state and
% 	returns the free force component for then system
% 	-bmi_force          function that takes in input the new evidence and
% 	returns the bmi force component for then system
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
    for sample_i = 2:num_samples
        %if the sample is a start of a feedbck period
        if  ismember(sample_i, feedback_starts)
            % reset accumulation
            accumulator(sample_i) = reset_accumulation;
        else
            state = accumulator(sample_i -1);
            new_evidence  = post_probabilities(sample_i, 1);% (,1) for selecting both feet
            %if the trial is not changed accumulate the next evidence
            delta_y = beta .* (alpha .* free_force(state) + (1-alpha) .* bmi_force(new_evidence));
            accumulator(sample_i) = max(min(state + delta_y,1),0);
        end
    end
    
end