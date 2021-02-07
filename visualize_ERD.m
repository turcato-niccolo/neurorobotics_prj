function [] = visualize_ERD(ERD_data, trial_dur, sample_rate, sel_channel, channel_name)
%   visualize_ERD(ERD_data, trial_dur, sample_rate, sel_channel, channel_name)
%   Input arguments:
%       -ERD_data: data to visualize (single trial or avg)
%       -trial_dur: duration of the trial (or avg)
%       -sample_rate: rate of samplign of the signal
%       -sel_channel; index of the channel to plot
%       -channel_name: name/label of the channel to plot
%

    %% Visualization 
    figure;
    t = linspace(0, trial_dur/sample_rate, trial_dur);
    
    colors = {'r', 'g'};
    nclasses = size(ERD_data, 2);
    
    y = ERD_data(:, sel_channel);
    plot(t, y, colors{1});
    
    title(['ERD | channel ' channel_name]);
    xlabel('Time [s]');
    ylabel('[%]');
    line([1 1],get(gca,'YLim'),'Color',[0 0 0])

end

