

% PRL location (local)
%  cueconditions =[1:4]; %1= cued exo, 2=uncued exo, 3=cued endo, 4=uncued endo


% matrix with conditions, reaction time and accuracy
fulltt=[mixtr time_stim' correx'];

name=baseName(8:9);

% remove timed out trials

tt=fulltt(fulltt(:,5)>0.0001,:);


%all endo
endo=tt(tt(:,3)==2,:);
%all exo
exo=tt(tt(:,3)==1,:);


% endo congruent
endocongr=endo(endo(:,4)==1,:);
% endo incongruent
endoincongr=endo(endo(:,4)==0,:);
% exo congruent
exocongr=exo(exo(:,4)==1,:);
% exo incongruent
exoincongr=exo(exo(:,4)==0,:);


%accuracy
exocongracc=sum(exocongr(:,end))/length(exocongr(:,end));
exoincongracc=sum(exoincongr(:,end))/length(exoincongr(:,end));

endocongracc=sum(endocongr(:,end))/length(endocongr(:,end));
endoincongracc=sum(endoincongr(:,end))/length(endoincongr(:,end));



%RT
exocongrRTmean=mean(exocongr(:,5));
exoincongrRTmean=mean(exoincongr(:,5));
exocongrRTste=std(exocongr(:,5))/sqrt(length(exocongr(:,5)));
exoincongrRTste=std(exoincongr(:,5))/sqrt(length(exoincongr(:,5)));

endocongrRTmean=mean(endocongr(:,5));
endoincongrRTmean=mean(endoincongr(:,5));
endocongrRTste=std(endocongr(:,5))/sqrt(length(endocongr(:,5)));
endoincongrRTste=std(endoincongr(:,5))/sqrt(length(endoincongr(:,5)));


figure
subplot(2,1,1)
graf=[endocongrRTmean endoincongrRTmean]
bar(graf)
hold on
errors=[endocongrRTste endoincongrRTste];
errorbar(graf, errors, 'k', 'linestyle','none')
ylim([0 1.1]);
ylabel('reaction time (sec)', 'fontsize', 14)
title([name ' Endo congruent vs incongruent'], 'fontsize', 19)

subplot(2,1,2)
graf=[exocongrRTmean exoincongrRTmean]
bar(graf)
hold on
errors=[exocongrRTste exoincongrRTste];
errorbar(graf, errors, 'k', 'linestyle','none')
ylim([0 1.1]);
ylabel('reaction time (sec)', 'fontsize', 14)
title([name ' Exo congruent vs incongruent'], 'fontsize', 19)

print([name ' carrasco RT'], '-dpng', '-r300')


figure
subplot(2,1,1)
graf=[endocongracc endoincongracc];
bar(graf)

ylim([0 1.1]);
ylabel('Accuracy', 'fontsize', 14)
title([name ' Endo congruent vs incongruent'], 'fontsize', 19)

subplot(2,1,2)
graf=[exocongracc exoincongracc];
bar(graf)
ylim([0 1.1]);
ylabel('Accuracy', 'fontsize', 14)
title( [name ' Exo congruent vs incongruent'], 'fontsize', 19)


print([name 'carrasco accuracy'], '-dpng', '-r300')


%% stats

[H,P,CI,STATS]=ttest2(exocongr(:,5),exoincongr(:,5));
[H,P,CI,STATS]=ttest2(endocongr(:,5),endoincongr(:,5));

