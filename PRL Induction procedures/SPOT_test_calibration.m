% SPOT test calibration


close all; clear; clc;
commandwindow



addpath([cd '/utilities']); %add folder with utilities files
prompt={'Participant Name', 'day', 'original parameters' };
name= 'Parameters';
numlines=1;
defaultanswer={'test','1', '0'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if isempty(answer)
    return;
end

SUBJECT = answer{1,:}; %Gets Subject Name
expDay=str2num(answer{2,:}); % test day
original=str2num(answer{3,:}); % test day

%create a data folder if it doesn't exist already
if exist('data')==0
    mkdir('data')
end
c = clock; %Current date and time as date vector. [year month day hour minute seconds]
filename='_SPOT_calibration';
TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
baseName=['./data/' SUBJECT  filename '_Day_' answer{2,:} '_' TimeStart]; %makes unique filename
site = 3; % training site (UAB vs UCR vs Vpixx)
pix_deg=34;

TPxTrackpixx3CalibrationTestingMMAMD(baseName, original,pix_deg)
