function [perf_active, perf_resting, perf_active_rej] = evaluate_accumulation(up_threshold, down_threshold, true_class, accumulator, feedback_index_scaled, trial_label_scaled)
% [perf_active, perf_resting, perf_active_rej] = evaluate_accumulation(up_threshold, down_threshold, true_class, accumulator, feedback_index_scaled, trial_label_scaled)
%
% The function evaluates the performance of the evidence accumulation framework
%
% Input arguments:
%   - up_threshold   
%   - down_threshold   
%   - true_class   
%   - accumulator   
%   - feedback_index_scaled
%   - trial_label_scaled
%
% Output arguments:
%   - perf_active               the performance on right classification of the active task
%   - perf_resting              the performance on right classification of the resting task
%   - perf_active_rej           the performance on not classify as rest an active task


% name for the trials
trial_names = nonzeros(unique(trial_label_scaled));
predicted_class = nan(size(trial_names));

for trial_i = 1:length(trial_names)
    % name of this trial
    this_trial = trial_names(trial_i);
    % index for extracting only the feedback data in this trial
    this_trial_feedback_index = feedback_index_scaled & (trial_label_scaled==this_trial);
    % evidences accumulated for this trial
    trial_accumulation = accumulator(this_trial_feedback_index);
    
    %find the critical samle that exceeds any threshold
    critial_sample = find( (trial_accumulation >= up_threshold) | (trial_accumulation <= down_threshold), 1, 'first' );
    
    %analysis on the critical sample to determine the predicted class to assign
    if(isempty(critial_sample))
        % no threshold exceded so this trial is predicted as rest
        predicted_class(trial_i) = 783;
        continue;
    end
    
    if(trial_accumulation(critial_sample) >= up_threshold)
        % beeing based on both feet posterior probability if the upper
        % threshold is exceeded this trial is calssified as both feet
        predicted_class(trial_i) = 771;
    elseif (trial_accumulation(critial_sample) <= up_threshold)
        predicted_class(trial_i) = 773;
    end
end

% index for the trials that are not of resting in the true label
active_trials_index = true_class ~= 783;
% index for the trials that are of resting  in the true label
rest_trials_index = true_class == 783;

perf_active  = 100 * (sum(true_class(active_trials_index) == predicted_class(active_trials_index))./sum(active_trials_index));
perf_resting = 100 * (sum(true_class(rest_trials_index) == predicted_class(rest_trials_index))./sum(rest_trials_index));

rejected_trials = predicted_class == 783;

perf_active_rej = 100 * (sum(true_class(active_trials_index & ~rejected_trials) == predicted_class(active_trials_index & ~rejected_trials))./sum(active_trials_index & ~rejected_trials));

end

