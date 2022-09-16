%extract RSVP


clear all
addpath([cd '/AnalysisUtilities'])

nameOffile = dir(['./trainingdatanew/' '*.mat']);

 
   for iui=1:length(nameOffile)
     %  for iui=1
        newest = nameOffile(iui).name;
        load(['./trainingdatanew/' newest]);
        lenom{iui}=newest;
        
        if str2num(newest(22))==1
            Training_type_1_analysis
        elseif str2num(newest(22))==2
            Training_type_2_analysis
        elseif str2num(newest(22))==3
            Training_type_3_analysis
        end
CI_analysisd
clearvars -except  nameOffile lenom newest

    end