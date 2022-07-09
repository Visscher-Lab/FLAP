% script for analyzing results from
% FLAP_acuity_crowding_attention_newsquare.m
% Written by Marcello Maniglia, 2021

close all
uab=0
newdir= [cd '\PilotFigures\'];
if uab==1
    subj=baseName(51:53);
else
    subj=baseName(8:9);

end

%subj=baseName(51:58);

testmatVA=[mixtrVA rispo(1:length(mixtrVA))' time_stim(1:length(mixtrVA))'];

testmatCW=[mixtrCW rispo(length(mixtrVA)+1:(length(mixtrVA)+length(mixtrCW)))' time_stim(length(mixtrVA)+1:(length(mixtrVA)+length(mixtrCW)))'];

% this variable has all the information for the Attention task
% mixtrAtt = something to do with stimulus type; 2 columns
%       apparently if the second column is ==1, it is a cued trial; if 2 it
%       is uncued.
% rispo = response is correct (1) or incorrect (2)
% time_stim seems to be a reaction time measurement in s


%testmatAtt= [mixtrAtt rispo(length(mixtrVA)+length(mixtrCW)+1:(length(mixtrVA)+length(mixtrCW)+length(mixtrAtt)))' time_stim(length(mixtrVA)+length(mixtrCW)+1:(length(mixtrVA)+length(mixtrCW)+length(mixtrAtt)))'];


totale_trials=totale_trials

onlyAtt=[mixtrAtt(1:totale_trials(end),:) rispo(length(mixtrVA)+length(mixtrCW)+1:length(rispo))' time_stim(length(mixtrVA)+length(mixtrCW)+1:length(rispo))']
AttCorr=onlyAtt(onlyAtt(:,3)==1,:);
AttshortCuedTotal=length(onlyAtt(onlyAtt(:,2)==1));
AttshortUncuedTotal=length(onlyAtt(onlyAtt(:,2)==2));
AttlongCuedTotal=length(onlyAtt(onlyAtt(:,2)==3));
AttlongUncuedTotal=length(onlyAtt(onlyAtt(:,2)==4));
AttCorrshortCued=AttCorr(AttCorr(:,2)==1,:);
AttCorrshortUncued=AttCorr(AttCorr(:,2)==2,:);
AttCorrlongCued=AttCorr(AttCorr(:,2)==3,:);
AttCorrlongUncued=AttCorr(AttCorr(:,2)==4,:);

cleanAttCorrshortCued=AttCorrshortCued(AttCorrshortCued(:,4)<(nanmean(AttCorrshortCued(:,4)+3*nanstd(AttCorrshortCued(:,4)))),4);
cleanAttCorrshortUncued=AttCorrshortUncued(AttCorrshortUncued(:,4)<(nanmean(AttCorrshortUncued(:,4)+3*nanstd(AttCorrshortUncued(:,4)))),4);


cleanAttCorrlongCued=AttCorrlongCued(AttCorrlongCued(:,4)<(nanmean(AttCorrlongCued(:,4)+3*nanstd(AttCorrlongCued(:,4)))),4);
cleanAttCorrlongUncued=AttCorrlongUncued(AttCorrlongUncued(:,4)<(nanmean(AttCorrlongUncued(:,4)+3*nanstd(AttCorrlongUncued(:,4)))),4);


AttCorrshortCuedRT=nanmean(cleanAttCorrshortCued);
AttCorrshortUncuedRT=nanmean(cleanAttCorrshortUncued);


AttCorrlongCuedRT=nanmean(cleanAttCorrlongCued);
AttCorrlongUncuedRT=nanmean(cleanAttCorrlongUncued);

AttCorrshortCuedPerc=length(AttCorrshortCued)/AttshortCuedTotal*100;
AttCorrshortUncuedPerc=length(AttCorrshortUncued)/AttshortUncuedTotal*100;

AttCorrlongCuedPerc=length(AttCorrlongCued)/AttlongCuedTotal*100;
AttCorrlongUncuedPerc=length(AttCorrlongUncued)/AttlongUncuedTotal*100;



CWradial=testmatCW(testmatCW(:,1)==2,:);
CWtangential=testmatCW(testmatCW(:,2)==2,:);



ThreshlistCW_radial=ThreshlistCW(1,:)';
ThreshlistCW_tan=ThreshlistCW(2,:)';

figure
scatter(1:length(ThreshlistVA), ThreshlistVA,50, 'filled')

%title([  subj titles{ui} ' acuity'])
title([  subj ' acuity'])
xlabel('trials')
ylabel('dva')
%ylim([0 2])
set(gca,'FontSize',17)

print([newdir subj 'ACAacuity'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%print('-dpng', '-r300');
%print(test, '-dpng', '-r300');
%print([dir subj 'acitynew'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


figure
scatter(1:length(ThreshlistVA), ThreshlistCW_radial+0.031,50, 'r','filled')
hold on
scatter(1:length(ThreshlistVA), ThreshlistCW_tan-0.031,50, 'k','filled')

legend ('radial', 'tangential')
%title([  subj titles{ui} ' acuity'])
title([  subj ' crowding'])
xlabel('trials')
ylabel('dva')
%ylim([0 2])
set(gca,'FontSize',17)

print([newdir subj 'ACAcrowding'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%print('crowdingTask','-dpng')
%print(theName, '-dpng', '-r300'); %<-Save as PNG with 300 DPI

figure
subplot(2,1,1)
bar(1, AttCorrshortCuedPerc, 'g')
hold on
bar(2, AttCorrshortUncuedPerc, 'r')
hold on
legend ('cued', 'uncued')
ylabel('Percentage correct')
title([  subj ' short ISI Attention %'])
limits2=max([AttCorrshortCuedPerc AttCorrshortUncuedPerc]);
limithigh=limits2*1.2;

if limithigh>100
    limithigh=100;
end
%ylim([limits2*0.8 limithigh])

%            print([dir subj 'att_new_corr'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI



%figure

[h p] = ttest2(cleanAttCorrshortCued, cleanAttCorrshortUncued,'tail','left'); % 1 tailed because we expect cued to be smaller than uncued

[h2 p2] = ttest2(cleanAttCorrlongCued, cleanAttCorrlongUncued,'tail','left'); % 1 tailed because we expect cued to be smaller than uncued


subplot(2,1,2)

bar(1, AttCorrshortCuedRT, 'g')
hold on
bar(2, AttCorrshortUncuedRT, 'r')
hold on
legend ('cued', 'uncued')
ylabel('Reaction time (s)')
title([  subj ' short ISI Attention RT'])
limits=max([AttCorrshortCuedRT AttCorrshortUncuedRT]);
text(1,0.5, ['p = ' num2str(p)]);
%ylim([limits*0.8 limits*1.2])
print([newdir subj 'ACAattentionshort'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%print([subj 'crowdingTask'],'-dpng')
%print([dir subj 'short_att_new_Results'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI





figure
subplot(2,1,1)
bar(1, AttCorrlongCuedPerc, 'g')
hold on
bar(2, AttCorrlongUncuedPerc, 'r')
hold on
legend ('cued', 'uncued')
ylabel('Percentage correct')
title([  subj ' long ISI Attention %'])
limits2=max([AttCorrlongCuedPerc AttCorrlongUncuedPerc]);
limithigh=limits2*1.2;

if limithigh>100
    limithigh=100;
end
%ylim([limits2*0.8 limithigh])

%print([newdir subj 'ACAattentionlong'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%            print([dir subj 'att_new_corr'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI



%figure
subplot(2,1,2)

bar(1, AttCorrlongCuedRT, 'g')
hold on
bar(2, AttCorrlongUncuedRT, 'r')
hold on
legend ('cued', 'uncued')
ylabel('Reaction time (s)')
title([  subj ' long ISI Attention RT'])
limits=max([AttCorrlongCuedRT AttCorrlongUncuedRT]);
text(1,0.5, ['p = ' num2str(p2)]);

%ylim([limits*0.8 limits*1.2])
%print([dir subj 'long_att_new_Results'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
print([newdir subj 'ACAattentionlong'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%% Analyze reaction times for Attention task
% AttCorrCued has 4 columns:1)?? 2)was it cued (1) or uncued (2)  3) correct(1) or incorrect (0)  4) RT in s
% plot cued and uncued trials
figure
subplot(2,2,1)
hist(cleanAttCorrshortCued)
ylabel('Reaction time (s)')
legend ('short cued')


subplot(2,2,2)
hist(cleanAttCorrshortUncued)
ylabel('Reaction time (s)')
legend ('short uncued')

subplot(2,2,3)
hist(cleanAttCorrlongCued)
ylabel('Reaction time (s)')
legend ('long cued')

subplot(2,2,4)
hist(cleanAttCorrlongUncued)
ylabel('Reaction time (s)')
legend ('long uncued')


subplot(2,2,1)
hist(cleanAttCorrshortCued)
title('ACA Data Analysis: Short Cued')
xlabel('Reaction time (s)')
ylabel('Frequency')
% axis([0.2 1 0 25])
hold on
subplot(2,2,2)
hist(cleanAttCorrshortUncued)
title('ACA Data Analysis: Short Uncued')
xlabel('Reaction time (s)')
ylabel('Frequency')
% axis([0.2 1 0 25])

subplot(2,2,3)
hist(cleanAttCorrlongCued)
xlabel('Reaction time (s)')
ylabel('Frequency')
title('ACA Data Analysis: Long Cued')
% axis([0.2 1 0 25])
hold on
subplot(2,2,4)
hist(cleanAttCorrlongUncued)
xlabel('Reaction time (s)')
ylabel('Frequency')
title('ACA Data Analysis: Long Uncued')

print([newdir subj 'PRL_Attan'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

% axis([0.2 1 0 25])

% Is RT different for cued vs. uncued?
% Plot histogram
% [h p] = ttest2(AttCorrCued(:,4), AttCorrUncued(:,4),'tail','left'); % 1 tailed because we expect cued to be smaller than uncued

% histogram(AttCorrCued(:,4))
% hold on
% histogram(AttCorrUncued(:,4))
% title('ACA Data Analysis')
% xlabel('Reaction Time (s)')
% ylabel('Frequency')
% txt = ['p = ' num2str(p)]
% gtext(txt)
% legend('Cued','Uncued')
% print([dir subj 'att_new_Results'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

% [h p] = ttest2(AttCorrCued(:,2), AttCorrUncued(:,2),'tail','left');
% histogram(AttCorrCued(:,2))
% hold on
% histogram(AttCorrUncued(:,2))
% title('ACA Data Analysis: Short')
% xlabel('Reaction Time (s)')
% ylabel('Frequency')
% txt = ['p = ' num2str(p)]
% gtext(txt)
% legend('Cued','Uncued')
% print([dir subj 'att_new_Results'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

% [h p] = ttest2(AttCorrCued(3,:), AttCorrUncued(3,:),'tail','left');
% histogram(AttCorrCued(3,:))
% hold on
% histogram(AttCorrUncued(3,:))
% title('ACA Data Analysis: Long')
% xlabel('Reaction Time (s)')
% ylabel('Frequency')
% txt = ['p = ' num2str(p)]
% gtext(txt)
% legend('Cued','Uncued')
% print([dir subj 'att_new_Results'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

% to do:
% write in the figure: x and y axes and axis labels.
% write text in the figure giving the p value of a ttest comparing the  2
% conditions
% write text in the figure giving the difference in means


