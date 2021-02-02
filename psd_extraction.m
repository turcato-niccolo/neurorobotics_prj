function [data] = psd_extraction(signal, header)
%PSD_EXTRACTION: creates a psd matrix from given data
%   Spatial filters: CAR and Laplacian
%
%   Input arguments:
%   -signal:    EEG raw signal
%   -header:    EEG data header
%
%   Output arguments:
%   -data
%       +data.psd:          3-dim matrix containing PSD data from input EEG
%       +data.events:       Events from EEG header
%       +data.freqs:        Selected frequencies
%       +data.SampleRate:   SampleRate
%

channelLb  = {'Fz', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'C3', 'C1', 'Cz', 'C2', 'C4', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4'};
channelId  = 1:length(channelLb);

mlength    = 1;
wlength    = 0.5;
pshift     = 0.25;                  
wshift     = 0.0625;  
selfreqs   = 4:2:96;
winconv = 'backward'; 

s = signal(:, channelId);
h = header;
SampleRate = header.SampleRate;

%% Spatial filters
disp('[proc] |- Applying CAR and Laplacian');
load('laplacian16.mat');
s_lap = s*lap;

%% Spectrogram
disp('[proc] |- Computing spectrogram');
[P, freqgrid] = proc_spectrogram(s_lap, wlength, wshift, pshift, SampleRate, mlength);  

%% Selecting desired frequencies
[freqs, idfreqs] = intersect(freqgrid, selfreqs);
P = P(:, idfreqs, :);

%% Extracting events
disp('[proc] |- Extract and convert the events');
events.TYP = h.EVENT.TYP;
events.POS = proc_pos2win(h.EVENT.POS, wshift*h.SampleRate, winconv, mlength*h.SampleRate);
if(isfield(h.EVENT, 'DUR')) %Often disappears
    events.DUR = floor(h.EVENT.DUR/(wshift*h.SampleRate)) + 1;
else
    %events.DUR = events.POS(2:2:end) - events.POS(1:2:end-1);
    events.DUR = events.POS(2:end) - events.POS(1:end-1);
    events.DUR = floor(events.DUR/(wshift*h.SampleRate)) + 1;
end
events.conversion = winconv;

%% SAVING DATA -> feature extraction
data = struct;
data.psd = P;
data.events = events;
data.freqs = freqs;
data.SampleRate = SampleRate;

end

