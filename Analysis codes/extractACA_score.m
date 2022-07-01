%extract ACA


clear all
addpath([cd '/AnalysisUtilities'])
nameOffile = dir(['./acapilotdata/' '*.mat']);

 
    for iui=1:length(nameOffile)
        newest = nameOffile(iui).name;
        load(['./acapilotdata/' newest]);
lenom{iui}=newest
ACA_analysisTimeOut


scoretable{iui}=zzzdio;
scoreothertable{iui}=zzzsummarytable;
clearvars -except  nameOffile scoretable scoreothertable

    end