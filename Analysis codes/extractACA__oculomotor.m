% Example of extraction of oculomotor metrics as described in Maniglia, 
%Visscher and Seitz (JOV, 2020)

clear all
addpath([cd '/AnalysisUtilities'])
nameOffile = dir(['./acapilotdata/' '*.mat']);



      nameOffile = dir([ '*.mat']);

 
    for iui=1:length(nameOffile)
        newest = nameOffile(iui).name;
        load(['./' newest]);
FLAP_fixation_distributionACA
close all
clearvars -except  nameOffile  PRLKDE_XXX PRLKDE_YYY


    end
    
    
   