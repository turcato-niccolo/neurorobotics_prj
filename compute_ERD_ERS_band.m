function [ERD_ERS] = compute_ERD_ERS_band(signal, SampleRate, avg_window, in_filter, band, ref_start, ref_stop, interest_start, interest_stop)
%   [ERD_ERS] = compute_ERD_band(signal, SampleRate, avg_window, in_filter, band, ref_start, ref_stop, d_start, d_stop)
%   Function to compute ERD/ERS of the given signal on the specified band
%   Input arguments:
%       -signal: EEG data [samples x channels]: not normalized
%       -filter: filter [channel x channel]
%       -avg_window: smoothing window length to compute power
%       -band: selected band (e.g. mu or beta)
%       -ref_start: index of the starting point of reference data
%       -ref_stop: index of the ending point of reference data
%       -interest_start: index of the starting point of interesting data
%       -interest_stop: index of the ending point of interesting data
%   Output:
%       -ERD_ERS: event-related desynchronization/synchronization computed
%       on the indicated eeg data, with respect to the given reference
    
    signal = signal*in_filter;
    
    % Creating filters, a,b are transfer function coeff
    filtOrder = 4;
    [b, a] = butter(filtOrder, band*2/SampleRate);
    
    signal_filt = zeros(size(signal));
    n_channels = size(signal, 2);
    
    for chId = 1:n_channels
        %Zero-phase digital filtering
        signal_filt(:, chId) = filtfilt(b, a, signal(:, chId));
    end
    
    % Squaring
    signal_rect = power(signal_filt, 2);
    
    % Moving average 
    signal_movavg = zeros(size(signal));
    for chId = 1:n_channels
        signal_movavg(:, chId) = (filter(ones(1, avg_window*SampleRate)/avg_window/SampleRate, 1, signal_rect(:, chId)));
    end
    
    % Logarithmic transformation
    signal_logpower = log(signal_movavg);
    
    %% Baseline extraction (from reference, e.g.fixation)
    %ref_dur = ref_stop - ref_start;
    ref_data = signal_logpower(ref_start:ref_stop, :);
    interest_data = signal_logpower(interest_start:interest_stop, :);
    
    ref_data = repmat(mean(ref_data), [size(interest_data, 1) 1]);
    
    ERD_ERS = 100 * (interest_data - ref_data)./ ref_data;    
end

