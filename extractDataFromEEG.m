data_folder = '.\eeg\';
% patient = 'ai6_micontinuous\';
% files{1} = 'ai6.20180316.153104.offline.mi.mi_bhbf.gdf';
% files{2} = 'ai6.20180316.154006.offline.mi.mi_bhbf.gdf';
% files{3} = 'ai6.20180316.154811.offline.mi.mi_bhbf.gdf';
% files{4} = 'ai6.20180316.160351.online.mi.mi_bhbf.ema.gdf';
% files{5} = 'ai6.20180316.161026.online.mi.mi_bhbf.dynamic.gdf';
% files{6} = 'ai6.20180417.164812.online.mi.mi_bhbf.ema.gdf';
% files{7} = 'ai6.20180417.165259.online.mi.mi_bhbf.dynamic.gdf';
% files{8} = 'ai6.20180529.151753.online.mi.mi_bhbf.ema.gdf';
% files{9} = 'ai6.20180529.152240.online.mi.mi_bhbf.dynamic.gdf';
patient = 'lezione\';
files{1} = 'ah7.20170613.161402.offline.mi.mi_bhbf.gdf';
files{2} = 'ah7.20170613.162331.offline.mi.mi_bhbf.gdf';
files{3} = 'ah7.20170613.162934.offline.mi.mi_bhbf.gdf';
files{4} = 'ah7.20170613.170929.online.mi.mi_bhbf.ema.gdf';
files{5} = 'ah7.20170613.171649.online.mi.mi_bhbf.dynamic.gdf';
files{6} = 'ah7.20170613.172356.online.mi.mi_bhbf.dynamic.gdf';
files{7} = 'ah7.20170613.173100.online.mi.mi_bhbf.ema.gdf';

%% load EEG
EEG_data = cell(size(files));

for file = 1 : length(files)
    [s,h] = sload(fullfile(data_folder, patient, files{file}));
    EEG_data{file}.signal = s;
    EEG_data{file}.header = h;
end

%% convert EEG into PSD
PSD_online = {};
online.frequences = nan;
online.sample_rate = nan;

PSD_offline = {};
offline.frequences = nan;
offline.sample_rate = nan;

for eeg_i = 1 : length(EEG_data)
    
    signal = EEG_data{eeg_i}.signal;
    header = EEG_data{eeg_i}.header;
    data = psd_extraction(signal, header);
    
    if contains(files{eeg_i},"offline")
        PSD_offline{end + 1} = data;
        offline.frequences = data.frequences;
        offline.sample_rate = data.sample_rate;
    elseif contains(files{eeg_i},"online")
        PSD_online{end + 1} = data;
        online.frequences = data.frequences;
        online.sample_rate = data.sample_rate;
    else
        error(['Unknown modality for file: ' eeg_i]);
    end
end

%% concatenate files and label data

[online.PSD, online.EVENT, online.run_labels] = concatenatePSD(PSD_online);
num_windows  = size(online.PSD, 1);
[online.cue_type_labels, online.trial_labels] = labelData(online.EVENT, num_windows);

[offline.PSD, offline.EVENT, offline.run_labels] = concatenatePSD(PSD_offline);
num_windows  = size(offline.PSD, 1);
[offline.cue_type_labels, offline.trial_labels] = labelData(offline.EVENT, num_windows);


save('./psd/lezione/ah7_psd.mat','online','offline');