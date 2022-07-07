%extract ACA


clear all
addpath([cd '/AnalysisUtilities'])
nameOffile = dir(['./acapilotdata/' '*.mat']);

 
    for iui=1:length(nameOffile)
        newest = nameOffile(iui).name;
        load(['./acapilotdata/' newest]);
lenom{iui}=newest
ACA_analysisTimeOutOnlyAttention


scoretable{iui}=zzzdio;
scoreothertable{iui}=zzzsummarytable;
shortpvalue(iui)=p;
longpvalue(iui)=p2;

clearvars -except  longpvalue lenom nameOffile scoretable scoreothertable shortpvalue

    end
    
    newtable=[];
    for ui=1:length(scoretable)
        
        newtable=[newtable scoretable{1,ui}];
        
    end
        