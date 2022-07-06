% script for analyzing results from
% FLAP_acuity_crowding_attention_newsquare.m
% Written by Marcello Maniglia, 2021

close all
%uab=0;
newdir= [cd '\PilotFigures\'];
if length(baseName)>55
    subj=baseName(51:53);
    subj=baseName(70:71)
else
    subj=baseName(8:9);

end

%subj=baseName(51:58);

time_stim(time_stim<0)=nan;

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
AttshortCuedTotal=length(testmatAtt(testmatAtt(:,2)==1));
AttshortUncuedTotal=length(testmatAtt(testmatAtt(:,2)==2));
AttlongCuedTotal=length(testmatAtt(testmatAtt(:,2)==3));
AttlongUncuedTotal=length(testmatAtt(testmatAtt(:,2)==4));
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
scatter(1:length(ThreshlistCW_radial), ThreshlistCW_radial+0.031,50, 'r','filled')
hold on
scatter(1:length(ThreshlistCW_tan), ThreshlistCW_tan-0.031,50, 'k','filled')

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

[h p] = ttest2(cleanAttCorrshortCued, cleanAttCorrshortUncued,'tail','left'); % 1 tailed because we expect cued to be smaller than uncued

[h2 p2] = ttest2(cleanAttCorrlongCued, cleanAttCorrlongUncued,'tail','left'); % 1 tailed because we expect cued to be smaller than uncued




%% PRL-specific analysis


%listOfThreshVA=[mixtrVA ThreshlistVA' time_stim(1:length(mixtrVA))' rispo(1:length(mixtrVA))'];

listOfThreshVA=[mixtrVA nan(length(mixtrVA),1) time_stim(1:length(mixtrVA))' rispo(1:length(mixtrVA))' ];


testmatAtt= [mixtrAtt rispo(length(mixtrVA)+length(mixtrCW)+1:(length(mixtrVA)+length(mixtrCW)+length(mixtrAtt)))' time_stim(length(mixtrVA)+length(mixtrCW)+1:(length(mixtrVA)+length(mixtrCW)+length(mixtrAtt)))'];





for iu=1:length(xlocs)
    listOfThreshVAPRL(:,:,iu)=listOfThreshVA(listOfThreshVA(:,1)==iu,:);
end


%cleanup VA RT
for iu=1:length(xlocs)
    %listOfThreshVAPRL(:,4,1) (all trials, rt column, PRL number)

    cleanlistOfThreshVAPRL{:,:,iu}=listOfThreshVAPRL(listOfThreshVAPRL(:,4,iu)<(nanmean(listOfThreshVAPRL(:,4,iu)+3*nanstd(listOfThreshVAPRL(:,4,iu)))),:,iu);

end

for iu=1:length(xlocs)
    CorrVAPRL(iu)=sum(listOfThreshVAPRL(:,5,iu))/length(listOfThreshVAPRL(:,5,iu));
    
   % RTVAPRL(iu)=nanmean(cleanlistOfThreshVAPRL(:,4,iu));
    RTVAPRL(iu)=nanmean(cleanlistOfThreshVAPRL{iu}(:,4,1));
end


listOfThreshCW=[mixtrCW separation(length(mixtrVA)+1:(length(mixtrVA)+length(mixtrCW)))' time_stim(length(mixtrVA)+1:(length(mixtrVA)+length(mixtrCW)))' rispo(length(mixtrVA)+1:(length(mixtrVA)+length(mixtrCW)))'];



%testmatCW=[mixtrCW rispo(length(mixtrVA)+1:(length(mixtrVA)+length(mixtrCW)))' time_stim(length(mixtrVA)+1:(length(mixtrVA)+length(mixtrCW)))'];



listOfThreshCWradial=listOfThreshCW(listOfThreshCW(:,2)==1,:);
listOfThreshCWtangential=listOfThreshCW(listOfThreshCW(:,2)==2,:);

for iu=1:length(xlocs)
    %1:PRL
    %2:radial/tangential
    %3: sc1/sc2
    %4:critical space
    %5:RT
    %6:corr resp
    listOfThreshCWradialPRL(:,:,iu)=listOfThreshCWradial(listOfThreshCWradial(:,1)==iu,:);
    listOfThreshCWtangentialPRL(:,:,iu)=listOfThreshCWtangential(listOfThreshCWtangential(:,1)==iu,:);
end

for iu=1:length(xlocs)
    CorrCWtangentialPRL(iu)=sum(listOfThreshCWtangentialPRL(:,6,iu))/length(listOfThreshCWtangentialPRL(:,6,iu));
    RTCWtangentialPRL(iu)=nanmean(listOfThreshCWtangentialPRL(:,5,iu));
end

for iu=1:length(xlocs)
    CorrCWradialPRL(iu)=sum(listOfThreshCWradialPRL(:,6,iu))/length(listOfThreshCWradialPRL(:,6,iu));
    RTCWradialPRL(iu)=nanmean(listOfThreshCWradialPRL(:,5,iu));
end



listOfThreshAtt=[mixtrAtt time_stim(length(mixtrVA)+1+length(mixtrCW):(length(mixtrVA)+length(mixtrCW))+length(mixtrAtt))' rispo(length(mixtrVA)+1+length(mixtrCW):(length(mixtrVA)+length(mixtrCW))+length(mixtrAtt))'];


listOfThreshAttshortcued=listOfThreshAtt(listOfThreshAtt(:,2)==1,:);
listOfThreshAttshortuncued=listOfThreshAtt(listOfThreshAtt(:,2)==2,:);
listOfThreshAttlongcued=listOfThreshAtt(listOfThreshAtt(:,2)==3,:);
listOfThreshAttlonguncued=listOfThreshAtt(listOfThreshAtt(:,2)==4,:);

for iu=1:length(xlocs)
    %column 1: location
    %column 2: cue type (1:short cued, 2: short uncued, 3: long cued, 4: long
    %uncued)
    %column 3: RT
    %column 4: corr resp
    %listOfThreshAttshortcuedPRL(:,:,iu)=listOfThreshAttshortcued(listOfThreshAttshortcued(:,1)==iu,:);
    %listOfThreshAttshortuncuedPRL(:,:,iu)=listOfThreshAttshortuncued(listOfThreshAttshortuncued(:,1)==iu,:);
    %listOfThreshAttlongcuedPRL(:,:,iu)=listOfThreshAttlongcued(listOfThreshAttlongcued(:,1)==iu,:);
    %listOfThreshAttlonguncuedPRL(:,:,iu)=listOfThreshAttlonguncued(listOfThreshAttlonguncued(:,1)==iu,:);
    
    
    
    listOfThreshAttshortcuedPRL{iu}=listOfThreshAttshortcued(listOfThreshAttshortcued(:,1)==iu,:);
    listOfThreshAttshortuncuedPRL{iu}=listOfThreshAttshortuncued(listOfThreshAttshortuncued(:,1)==iu,:);
    listOfThreshAttlongcuedPRL{iu}=listOfThreshAttlongcued(listOfThreshAttlongcued(:,1)==iu,:);
    listOfThreshAttlonguncuedPRL{iu}=listOfThreshAttlonguncued(listOfThreshAttlonguncued(:,1)==iu,:);
    
end
%listOfThreshCW=[mixtrCW ThreshlistCW time_stim(1:length(mixtrVA))']






for iu=1:length(xlocs)
    CorrAttPRLshortcued(iu)=sum(listOfThreshAttshortcuedPRL{iu}(:,4))/length(listOfThreshAttshortcuedPRL{iu}(:,4));
    RTAttPRLshortcued(iu)=nanmean(listOfThreshAttshortcuedPRL{iu}(:,3));
    STDAttPRLshortcued(iu)=nanstd(listOfThreshAttshortcuedPRL{iu}(:,3));
    
    %outlier removal
        clear upperborder lowerborder

    upperborder=RTAttPRLshortcued(iu)+2*STDAttPRLshortcued(iu);
    lowerborder=RTAttPRLshortcued(iu)-2*STDAttPRLshortcued(iu);
    
    for ui=1:length(listOfThreshAttshortcuedPRL{iu}(:,3))
        if listOfThreshAttshortcuedPRL{iu}(ui,3)> upperborder | listOfThreshAttshortcuedPRL{iu}(ui,3)< lowerborder
            
            listOfThreshAttshortcuedPRL{iu}(ui,3)=NaN;
            
            shortcuedoutlier=1;
        end
    end
    if exist('shortcuedoutlier')
        RTAttPRLshortcued(iu)=nanmean(listOfThreshAttshortcuedPRL{iu}(:,3));
    end
    
    CorrAttPRLshortuncued(iu)=sum(listOfThreshAttshortuncuedPRL{iu}(:,4))/length(listOfThreshAttshortuncuedPRL{iu}(:,4));
    RTAttPRLshortuncued(iu)=nanmean(listOfThreshAttshortuncuedPRL{iu}(:,3));
    STDAttPRLshortuncued(iu)=nanstd(listOfThreshAttshortuncuedPRL{iu}(:,3));
    
    %outlier removal
        clear upperborder lowerborder

    upperborder=RTAttPRLshortuncued(iu)+2*STDAttPRLshortuncued(iu);
    lowerborder=RTAttPRLshortuncued(iu)-2*STDAttPRLshortuncued(iu);
    
    for ui=1:length(listOfThreshAttshortuncuedPRL{iu}(:,3))
        if listOfThreshAttshortuncuedPRL{iu}(ui,3)> upperborder | listOfThreshAttshortuncuedPRL{iu}(ui,3)< lowerborder
            
            listOfThreshAttshortuncuedPRL{iu}(ui,3)=NaN;
            
            shortuncuedoutlier=1;
        end
    end
    if exist('shortuncuedoutlier')
        RTAttPRLshortuncued(iu)=nanmean(listOfThreshAttshortuncuedPRL{iu}(:,3));
    end
    
    
    
    
    CorrAttPRLlongcued(iu)=sum(listOfThreshAttlongcuedPRL{iu}(:,4))/length(listOfThreshAttlongcuedPRL{iu}(:,4));
    RTAttPRLlongcued(iu)=nanmean(listOfThreshAttlongcuedPRL{iu}(:,3));
    STDAttPRLlongcued(iu)=nanstd(listOfThreshAttlongcuedPRL{iu}(:,3));
    
    %outlier removal
        clear upperborder lowerborder

    upperborder=RTAttPRLlongcued(iu)+2*STDAttPRLlongcued(iu);
    lowerborder=RTAttPRLlongcued(iu)-2*STDAttPRLlongcued(iu);
    
    for ui=1:length(listOfThreshAttlongcuedPRL{iu}(:,3))
        if listOfThreshAttlongcuedPRL{iu}(ui,3)> upperborder | listOfThreshAttlongcuedPRL{iu}(ui,3)< lowerborder
            
            listOfThreshAttlongcuedPRL{iu}(ui,3)=NaN;
            
            longcuedoutlier=1;
        end
    end
    if exist('longcuedoutlier')
        RTAttPRLlongcued(iu)=nanmean(listOfThreshAttlongcuedPRL{iu}(:,3));
    end
    
    CorrAttPRLlonguncued(iu)=sum(listOfThreshAttlonguncuedPRL{iu}(:,4))/length(listOfThreshAttlonguncuedPRL{iu}(:,4));
    RTAttPRLlonguncued(iu)=nanmean(listOfThreshAttlonguncuedPRL{iu}(:,3));
    STDAttPRLlonguncued(iu)=nanstd(listOfThreshAttlonguncuedPRL{iu}(:,3));
    
    %outlier removal
    clear upperborder lowerborder
    upperborder=RTAttPRLlonguncued(iu)+2*STDAttPRLlonguncued(iu);
    lowerborder=RTAttPRLlonguncued(iu)-2*STDAttPRLlonguncued(iu);
    
    for ui=1:length(listOfThreshAttlonguncuedPRL{iu}(:,3))
        if listOfThreshAttlonguncuedPRL{iu}(ui,3)> upperborder | listOfThreshAttlonguncuedPRL{iu}(ui,3)< lowerborder
            
            listOfThreshAttlonguncuedPRL{iu}(ui,3)=NaN;
            
            longcuedoutlier=1;
        end
    end
    if exist('longuncuedoutlier')
        RTAttPRLlonguncued(iu)=nanmean(listOfThreshAttlonguncuedPRL{iu}(:,3));
    end
    
    
end


figure
subplot(2,1,1)
scatter(0,0, 'r', 'filled')

for ui=1:length(xlocs)
    hold on
    score=num2str(CorrVAPRL(ui));
    if length(score)>4
        score=score(1:4);
    end
        VAAcc(ui)=str2num(score);
    text(xlocs(ui),ylocs(ui), score)
    hold on
end
xlim([-20 20])
ylim([-15 15])
title('VA corr')
set (gca,'YDir','reverse');

subplot(2,1,2)
scatter(0,0, 'r', 'filled')

for ui=1:length(xlocs)
    hold on
    score=num2str(RTVAPRL(ui));
    if length(score)>4
        score=score(1:4);
    end
    VART(ui)=str2num(score);
    text(xlocs(ui),ylocs(ui), score)
    
    hold on
end
xlim([-20 20])
ylim([-15 15])
title('VA RT')
set (gca,'YDir','reverse');
print([newdir subj 'PRLspec_va'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


figure

subplot(2,2,1)
scatter(0,0, 'r', 'filled')

for ui=1:length(xlocs)
    hold on
    score=num2str(CorrCWradialPRL(ui));
    if length(score)>4
        score=score(1:4);
    end
                crowdingradialAcc(ui)=str2num(score);
    text(xlocs(ui),ylocs(ui), score)
    hold on
end
xlim([-20 20])
ylim([-15 15])
title('CW radial corr')
set (gca,'YDir','reverse');

subplot(2,2,2)
scatter(0,0, 'r', 'filled')

for ui=1:length(xlocs)
    hold on
    score=num2str(RTCWradialPRL(ui));
    if length(score)>4
        score=score(1:4);
    end
            crowdingradialRT(ui)=str2num(score);
    text(xlocs(ui),ylocs(ui), score)
    hold on
end
xlim([-20 20])
ylim([-15 15])
title('CW radial RT')
set (gca,'YDir','reverse');

subplot(2,2,3)
scatter(0,0, 'r', 'filled')

for ui=1:length(xlocs)
    hold on
        score=num2str(CorrCWtangentialPRL(ui));
    text(xlocs(ui),ylocs(ui), score)
        crowdingtangentialAcc(ui)=str2num(score);
    hold on
end
xlim([-20 20])
ylim([-15 15])
title('CW tangential corr')
set (gca,'YDir','reverse');

subplot(2,2,4)
scatter(0,0, 'r', 'filled')
for ui=1:length(xlocs)
    %scatter(xlocs(ui),ylocs(ui))
    hold on
    score=num2str(RTCWtangentialPRL(ui));
    crowdingtangentialRT(ui)=str2num(score);
    if length(score)>4
        score=score(1:4);
    end
    text(xlocs(ui),ylocs(ui), score)
    hold on
end
xlim([-20 20])
ylim([-15 15])
title('CW tangential RT')
set (gca,'YDir','reverse');
print([newdir subj 'PRLspec_crow'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI



figure
subplot(2,2,1)
scatter(0,0, 'r', 'filled')
for ui=1:length(xlocs)
    hold on
    %score=num2str(CorrAttPRL(ui));
    score=num2str(CorrAttPRLshortuncued(ui)-CorrAttPRLshortcued(ui));
        shortcueAcc(ui)=str2num(score);
    % if length(score)>4
    %     score=score(1:4);
    % end
    text(xlocs(ui),ylocs(ui), score)
    hold on
end
xlim([-20 20])
ylim([-15 15])
title('short cue corr (%uncued-%cued)')
set (gca,'YDir','reverse');

subplot(2,2,2)

scatter(0,0, 'r', 'filled')
for ui=1:length(xlocs)
    hold on
    score=num2str(RTAttPRLshortcued(ui)-RTAttPRLshortuncued(ui));
    shortcueRT(ui)=str2num(score);
    % if length(score)>4
    %     score=score(1:4);
    % end
    text(xlocs(ui),ylocs(ui), score)
    hold on
end
xlim([-20 20])
ylim([-15 15])
title('short cue RT (cued-uncued)')
set (gca,'YDir','reverse');


subplot(2,2,3)


scatter(0,0, 'r', 'filled')
for ui=1:length(xlocs)
    hold on
    score=num2str(CorrAttPRLlonguncued(ui)-CorrAttPRLlongcued(ui));
    longcueAcc(ui)=str2num(score);
    % if length(score)>4
    %     score=score(1:4);
    % end
    text(xlocs(ui),ylocs(ui), score)
    hold on
end
xlim([-20 20])
ylim([-15 15])
title('long cued Acc (%uncued-%cued)')
set (gca,'YDir','reverse');


subplot(2,2,4)

scatter(0,0, 'r', 'filled')
for ui=1:length(xlocs)
    hold on
    score=num2str(RTAttPRLlongcued(ui)-RTAttPRLlonguncued(ui));
    longcueRT(ui)=str2num(score);
    % if length(score)>4
    %     score=score(1:4);
    % end
    text(xlocs(ui),ylocs(ui), score)
    hold on
end
xlim([-20 20])
ylim([-15 15])
title('long cue RT (cued-uncued)')
set (gca,'YDir','reverse');
print([newdir subj 'PRLspec_cue'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

              
zzzsummarytable=[VAAcc;
VART;
crowdingradialAcc;
crowdingradialRT;
crowdingtangentialAcc;
crowdingtangentialRT;
shortcueAcc;
shortcueRT
longcueAcc;
longcueRT;
]
for ui=1:2
if ThreshlistCW(ui,end)==0
    
    ThreshlistCW(ui,end)=ThreshlistCW(ui,end-1)
    
    if ThreshlistCW(ui,end)==0
    
    ThreshlistCW(ui,end)=ThreshlistCW(ui,end-2)
end
end



end
zzzdio=[ThreshlistVA(:,end); 
    ThreshlistCW(:,end); 
    AttCorrshortCuedRT;
AttCorrshortUncuedRT;
AttCorrshortCuedPerc;
AttCorrshortUncuedPerc;
AttCorrlongCuedRT;
AttCorrlongUncuedRT;
AttCorrlongCuedPerc;
AttCorrlongUncuedPerc;]