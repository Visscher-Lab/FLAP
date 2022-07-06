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
clearvars -except  lenom nameOffile scoretable scoreothertable

    end
    
    newtable=[];
    for ui=1:length(scoretable)
        
        newtable=[newtable scoretable{1,ui}];
        
    end
        