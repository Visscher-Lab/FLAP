% MNRead analysis script: meant to plot duration of each trial against font
% size during the assessment



% assign subject name and decipher whether this is pre or post training:
% will probably comment this out after pilot

if c(2) == 10
    Directory = [cd '\PilotFigures\'];
    Subject = baseName(70:71);
    Post = 0;
    AnalysisName = [Directory Subject '_MNRead_PreTraining'];
elseif c(2) == 12
    Directory = [cd '\PostPilotFigures\'];
    Subject = baseName(70:71);
    Post = 1;
    AnalysisName = [Directory Subject '_MNRead_PostTraining'];
end


% pull both font size and response time variables, and plot against each
% other

%save images into folders denoting if they were pre or post training
if Post == 0
    ResponseTime = time_stim;
    FontSizes = sizes;
    i = 1:length(ResponseTime);
    plot(FontSizes(i),ResponseTime(i),'b-x',MarkerSize=9,LineWidth=1.5);
    set(gca,'XDir','reverse'); % axis must be reversed as font size decreases every trial
    hold on
    xlabel('Font Size')
    ylabel('Response Time')
    ylim([0 90])
    set(gca, 'FontSize',17)
    savefig([Directory Subject 'MNReadPreTraining.fig'])
else
    openfig(['./PilotFigures/' Subject 'MNReadPreTraining.fig'])
    hold on
    ResponseTime = time_stim;
    FontSizes = sizes;
    i = 1:length(ResponseTime);
    plot(FontSizes(i),ResponseTime(i),'r-x',MarkerSize=9,LineWidth=1.5);
    title([Subject ' MNRead'])
    legend('Pre-Training', 'Post-Training')
    print([Directory Subject 'MNReadPost'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
end

close all
clear
clc