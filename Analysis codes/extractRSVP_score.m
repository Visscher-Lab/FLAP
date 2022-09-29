%extract RSVP


clear all
addpath([cd '/AnalysisUtilities'])
      nameOffile = dir([ '*.mat']);

 
    for iui=1:length(nameOffile)
        newest = nameOffile(iui).name;
        load(['./' newest]);
lenom{iui}=newest
RSVP_analysis
clearvars -except  nameOffile

    end