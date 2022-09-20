%extract RSVP


clear all
addpath([cd '/AnalysisUtilities'])

nameOffile = dir(['./CIdata/' '*.mat']);

 
   for iui=1:length(nameOffile)
     %  for iui=1
        newest = nameOffile(iui).name;
        load(['./CIdata/' newest]);
CI_analysis
totalthresh{iui}=thresh

clearvars -except  nameOffile lenom newest iui totalthresh

    end