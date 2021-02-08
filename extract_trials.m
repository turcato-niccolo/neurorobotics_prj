function [trials, trial_run_k, trial_cue_k] = extract_trials(data, selected_data_index, trial_k, cue_k, run_k)
%EXTRACT_TRIALS Summary of this function goes here
%   Detailed explanation goes here
num_trials = length(nonzeros(unique(trial_k)));
trials_cell = cell(num_trials,1);

if isempty(cue_k)
    trial_cue_k = [];
else
    trial_cue_k = nan(size(trials_cell));
end

if isempty(run_k)
    trial_run_k = [];
else
    trial_run_k = nan(size(trials_cell));
end

min_trial_dur = nan;

for t = 1:num_trials
    index = selected_data_index & trial_k==t;
    trials_cell{t} = data(index, :);
    %update min_trial_dur
    min_trial_dur = min(min_trial_dur, size(trials_cell{t},1));
    if ~isempty(cue_k) 
        trial_cue_k(t) = unique(cue_k(index));
    end
    if ~isempty(run_k)  
        trial_run_k(t) = unique(run_k(index));
    end
end
% cut at the same length

trials = nan(min_trial_dur, size(data,2), num_trials);

for t = 1:num_trials
    trials(:,:,t) = trials_cell{t}(1:min_trial_dur,:);
end

end

