function [cue_k, trial_k] = label_data(EVENT, num_windows)
% [cue_k, trial_k] = label_data(EVENT, num_windows)
% The function returns the labelling vectors (zero outside cue-feedback) traslating event indexing
% to window indexing for cue and trial information of the PSD
%
% Input arguments:
%   - EVENT                 structure with the following fields
%   (POS,TYP,DUR) for each event in the PSD
%   - num_windows           number of windows in the data to label
%
% Output arguments:
%   - cue_k                 labelling vector for the type of event the
%   window is assigned to
%   - trial_k               labelling vector for the trial number the
%   window is assigned to

code.fixation = 786;
code.cue_BH = 773;
code.cue_BF = 771;
code.cue_rest = 783;
code.feedback = 781;

feedback_event.index = (EVENT.TYP == code.feedback);
feedback_event.POS = EVENT.POS(feedback_event.index);
feedback_event.DUR = EVENT.DUR(feedback_event.index);

%we can have three types of cue (both hand, both feet, rest)
cue_event.index = ((EVENT.TYP == code.cue_BF) | (EVENT.TYP == code.cue_BH) | (EVENT.TYP == code.cue_rest));
cue_event.POS = EVENT.POS(cue_event.index);
cue_event.DUR = EVENT.DUR(cue_event.index);
cue_event.TYP = EVENT.TYP(cue_event.index);

% each trial has one in (BH,BF,rest) and one feedback right after
num_trials = length(cue_event.TYP);

% We consider the intersting data as the one from Cue apperance to end of continuous feedback
% type_labels(window_i)= zero if not selected -- TYP of it's cue event if selected
cue_k = zeros(num_windows, 1);
%mask containing the trial of data_mask(window_i)
trial_k = zeros(num_windows, 1);

for trial_i = 1:num_trials
    start = cue_event.POS(trial_i);
    stop  = feedback_event.POS(trial_i) + feedback_event.DUR(trial_i) - 1;
    cue_k(start:stop) = cue_event.TYP(trial_i);
    trial_k(start:stop) = trial_i;
end
end

