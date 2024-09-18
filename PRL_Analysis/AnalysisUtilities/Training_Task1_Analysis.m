%% Training Task 1 Analysis Script
% This script is written by Samyukta Jayakumar. ...


clear all
close all
clc

%% Loading the data file

cd('..\..\..\datafolder') % enter the path to datafolder for future analyses
% load('CS_FLAPtraining_type_1_Day_1_23_8_10_14_21.mat')
% load('CS_FLAPtraining_type_1_Day_2_23_8_10_14_25.mat')
% load('DA_FLAPtraining_type_1_Day_1_23_8_10_13_23.mat')
load('DA_FLAPtraining_type_1_Day_2_23_8_10_13_27.mat')
cd('..\FLAP\Analysis codes\AnalysisUtilities')

name = strcat(baseName(83:84), baseName(90:97), baseName(99:102), baseName(104));
sess = baseName(110);

%% Plotting trajectory for each session
figure(1)
for i = 1:length(Threshlist) % no.of shapes and location for assessment
    if rispo(1,i) == 1
        plot(i,log10(Threshlist(1,1,i)), '.b','MarkerSize',14) % correct responses
        hold on
    else
        plot(i,log10(Threshlist(1,1,i)), '*k','MarkerSize',4.5) % incorrect responses (not looking at timedout trials)
        hold on
    end
    hold on
end
xlabel('Trials','FontSize',12)
ylabel('log(Contrast)','FontSize',14)
ylim([-3 0])
str1 = strcat(name,{' '},'Day',sess);
title(str1, 'FontSize',15)
cd('..\..\..\datafolder\Figures')
print([name 'Day' sess 'tracks'],'-dpng', '-r300'); %<-Save as PNG with 300 DPI
cd('..\..\FLAP\Analysis codes\AnalysisUtilities')
