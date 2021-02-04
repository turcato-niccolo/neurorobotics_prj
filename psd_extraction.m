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
%       +data.PSD:              [windows x freqences x channels] matrix containing PSD data from input EEG
%
%       +data.events:           Events from EEG header
%           *events.TYP:        event codes (only starting codes)
%           *events.POS:        positions of the event in windows
%           *events.DUR:        durations of the event in windows
%           *events.conversion  conversion direction used in the PSD
%
%       +data.frequences:       frequences the PSd is based on
%       +data.smaple_rate:      sample rate of the data used in the psd
%       +data.modality          modality of acquisition for the data used to compute the PSD
%

channelLb  = {'Fz', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'C3', 'C1', 'Cz', 'C2', 'C4', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4'};
channelId  = 1:length(channelLb);

mlength    = 1;
wlength    = 0.5;
pshift     = 0.25;                  
wshift     = 0.0625;  
winconv = 'backward'; 

s = signal(:, channelId);
h = header;
sample_rate = header.SampleRate;

%% Spatial filters
disp('[proc] |- Applying CAR and Laplacian');
load('laplacian16.mat');
s_lap = s*lap;

%% Spectrogram
disp('[proc] |- Computing spectrogram');
[P, freqgrid] = proc_spectrogram(s_lap, wlength, wshift, pshift, sample_rate, mlength);  

%% Extracting events
disp('[proc] |- Extract and convert the events');
events.TYP = h.EVENT.TYP(1:2:end);
events.POS = h.EVENT.POS(1:2:end);

if(~isfield(h.EVENT, 'DUR')) %Often disappears
    DUR = h.EVENT.POS(2:2:end) - events.POS;
else
    DUR = h.EVENT.DUR;
end

events.POS = proc_pos2win(events.POS, wshift*h.SampleRate, winconv, mlength*h.SampleRate);
events.DUR = floor(DUR/(wshift*h.SampleRate)) + 1;

events.conversion = winconv;

%% SAVING DATA -> feature extraction
data = struct;
data.PSD = P;
data.EVENT = events;
data.frequences = freqgrid;
data.sample_rate = sample_rate;

end
