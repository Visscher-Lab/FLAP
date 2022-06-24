%extract ACA


clear all
addpath([cd '/AnalysisUtilities'])
nameOffile = dir(['./acapilotdata/' '*.mat']);

 
    for iui=1:length(nameOffile)
        newest = nameOffile(iui).name;
        load(['./acapilotdata/' newest]);
lenom{iui}=newest
ACA_analysisTimeOut
clearvars -except  nameOffile

    end