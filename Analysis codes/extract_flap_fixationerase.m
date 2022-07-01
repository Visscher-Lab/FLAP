% Example of extraction of oculomotor metrics as described in Maniglia, 
%Visscher and Seitz (JOV, 2020)

clear all
 %     nameOffile = dir([ '*.mat']);
nameOffile = dir(['./fixationpilotdata/' '*.mat']);
listz=[4 6];

 listz=[1 2 3 5];

   % for iui=1:length(nameOffile)
        
            for iui=1:length(listz)

        newest = nameOffile(listz(iui)).name;
        
                load(['./fixationpilotdata/' newest]);

      %  load(['./' newest]);
lenom{iui}=newest
Acc(iui)=sum(rispo)/length(rispo);
RT(iui)=mean(cueendToResp)

name=['Fixation task ' baseName(8:9)]
title([name ' accuracy'])
subplot(2,1,1)
bar(sum(rispo)/length(rispo))
ylabel('% accuracy')
ylim([0 1])
title([name ' accuracy'])

set(gca, 'fontsize',12)

subplot(2,1,2)
hist(cueendToResp)
xlabel('seconds')
title([name ' RT'])

set(gca, 'fontsize',12)
print([name], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
clearvars -except  RT Respt lenom nameOffile listz

    end
    

clearvars -except RT Respt lenom nameOffile listz
nameOffile = dir(['./fixationpilotdata/' '*.mat']);

 
    for iui=1:length(listz)
%        newest = nameOffile(iui).name;
                newest = nameOffile(listz(iui)).name;

                load(['./fixationpilotdata/' newest]);
FLAP_fixation_distribution
close all

PRLKDE_XXX(iui)=PRLKDE_X;
PRLKDE_YYY(iui)=PRLKDE_Y;
clearvars -except  nameOffile  PRLKDE_XXX PRLKDE_YYY listz


    end
    
    
   