%extract ACA


clear all
      nameOffile = dir([ '*.mat']);

 
    for iui=1:length(nameOffile)
        newest = nameOffile(iui).name;
        load(['./' newest]);
lenom{iui}=newest
FLAP_fixation_distributionRSVP
clearvars -except  nameOffile

    end