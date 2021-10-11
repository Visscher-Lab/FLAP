% script for analyzing results from
% FLAP_acuity_crowding_attention_newsquare.m
% Written by Marcello Maniglia, 2021

close all
dir= ['.\PilotFigures\' ];
subj=baseName(8:9);
subj=baseName(51:58);

testmatVA=[mixtrVA rispo(1:length(mixtrVA))' time_stim(1:length(mixtrVA))'];

testmatCW=[mixtrCW rispo(length(mixtrVA)+1:(length(mixtrVA)+length(mixtrCW)))' time_stim(length(mixtrVA)+1:(length(mixtrVA)+length(mixtrCW)))'];

% this variable has all the information for the Attention task
% mixtrAtt = something to do with stimulus type; 2 columns
%       apparently if the second column is ==1, it is a cued trial; if 2 it
%       is uncued.
% rispo = response is correct (1) or incorrect (2)
% time_stim seems to be a reaction time measurement in s


testmatAtt= [mixtrAtt rispo(length(mixtrVA)+length(mixtrCW)+1:(length(mixtrVA)+length(mixtrCW)+length(mixtrAtt)))' time_stim(length(mixtrVA)+length(mixtrCW)+1:(length(mixtrVA)+length(mixtrCW)+length(mixtrAtt)))'];

AttCorr=testmatAtt(testmatAtt(:,3)==1,:);
AttCuedTotal=length(testmatAtt(testmatAtt(:,2)==1)); 
AttUncuedTotal=length(testmatAtt(testmatAtt(:,2)==2));
AttCorrCued=AttCorr(AttCorr(:,2)==1,:);
AttCorrUncued=AttCorr(AttCorr(:,2)==2,:);

AttCorrCuedRT=mean(AttCorrCued(:,4));
AttCorrUncuedRT=mean(AttCorrUncued(:,4));

AttCorrCuedPerc=length(AttCorrCued)/AttCuedTotal*100;
AttCorrUncuedPerc=length(AttCorrUncued)/AttUncuedTotal*100;



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

print([dir subj 'acitynew'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

figure
scatter(1:length(ThreshlistVA), ThreshlistCW_radial+0.1,50, 'r','filled')
hold on
scatter(1:length(ThreshlistVA), ThreshlistCW_tan-0.1,50, 'k','filled')

legend ('radial', 'tangential')
%title([  subj titles{ui} ' acuity'])
title([  subj ' crowding'])
xlabel('trials')
ylabel('dva')
%ylim([0 2])
set(gca,'FontSize',17)

print([dir subj 'crowdingnew'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
             
             
figure
subplot(2,1,1)
bar(1, AttCorrCuedPerc, 'g')
hold on
bar(2, AttCorrUncuedPerc, 'r')
hold on
legend ('cued', 'uncued')
ylabel('Percentage correct')
title([  subj ' Attention %'])
limits2=max([AttCorrCuedPerc AttCorrUncuedPerc])
limithigh=limits2*1.2;

if limithigh>100 
    limithigh=100;
end
ylim([limits2*0.8 limithigh])

 %            print([dir subj 'att_new_corr'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI



%figure
subplot(2,1,2)

bar(1, AttCorrCuedRT, 'g')
hold on
bar(2, AttCorrUncuedRT, 'r')
hold on
legend ('cued', 'uncued')
ylabel('Reaction time (s)')
title([  subj ' Attention RT'])
limits=max([AttCorrCuedRT AttCorrUncuedRT])

ylim([limits*0.8 limits*1.2])
print([dir subj 'att_new_Results'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


%% Analyze reaction times for Attention task
% AttCorrCued has 4 columns:1)?? 2)was it cued (1) or uncued (2)  3) correct(1) or incorrect (0)  4) RT in s
% plot cued and uncued trials
hist(AttCorrCued(:,4), AttCorrUncued(:,4))
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

[h p] = ttest2(AttCorrCued(:,4), AttCorrUncued(:,4),'tail','left'); % 1 tailed because we expect cued to be smaller than uncued



AttCorrCuedRT=mean(AttCorrCued(:,4));
AttCorrUncuedRT=mean(AttCorrUncued(:,4));


AttCorrCued(:,4), AttCorrUncued(:,4)
             
             