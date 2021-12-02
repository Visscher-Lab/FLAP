% Example of extraction of oculomotor metrics as described in Maniglia, 
%Visscher and Seitz (JOV, 2020)

clear all
      nameOffile = dir([ '*.mat']);

 
    for iui=1:length(nameOffile)
        newest = nameOffile(iui).name;
        load(['./' newest]);
lenom{iui}=newest
clearvars -except  lenom nameOffile
    end
    

clear all
      nameOffile = dir([ '*.mat']);

 
    for iui=1:length(nameOffile)
        newest = nameOffile(iui).name;
        load(['./' newest]);
FLAP_fixation_distribution
close all

PRLKDE_XXX(iui)=PRLKDE_X;
PRLKDE_YYY(iui)=PRLKDE_Y;
clearvars -except  nameOffile  PRLKDE_XXX PRLKDE_YYY


    end