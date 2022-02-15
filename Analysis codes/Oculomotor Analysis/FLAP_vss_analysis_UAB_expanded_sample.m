%FLAP VSS Analysis
%VA		Acc
%		RT
%Crowding	radial	Acc
%		RT
%	tangential	Acc
%		RT
%Attention	short	Acc
%		RT
%	long	Acc
%		RT

% Overall scores
% VA
% cw_rad
% cw_tan
% attshortCueRT
% attshortUncueRT
% attshortCueperc
% attshortUncuePerc
% attlongCueRT
% attlongUncueRT
% attlongCueperc
% attlongUncuePerc
close all
clear all

load FLAP_updated_2022.mat
% theNames=['CC'
% 'CL'
% 'DB'
% 'JC'
% 'KP'
% 'AC'
% 'AK'
% 'AM'
% 'HM'
% 'JH'
% 'MG'
% 'GS'
% 'HF'
% 'JK'
% 'JO'
% 'JV'
% 'VH'
% 'AD'
% 'EC'
% 'KG'
% 'KMV'
% 'PS'
% 'RAC'];

VA_ovr=general_thresh(1,:);

CW_rad_ovr=general_thresh(2,:);
CW_tan_ovr=general_thresh(3,:);
short_cueRT=general_thresh(4,:)-general_thresh(5,:);
short_cueAC=general_thresh(6,:)-general_thresh(7,:);
long_cueRT=general_thresh(8,:)-general_thresh(9,:);
long_cueAC=general_thresh(10,:)-general_thresh(11,:);


VA_acc=overall_score_uab(1:10:end,:);
VA_RT=overall_score_uab(2:10:end,:);
CW_rad_acc=overall_score_uab(3:10:end,:);
CW_rad_RT=overall_score_uab(4:10:end,:);
CW_tan_acc=overall_score_uab(5:10:end,:);
CW_tan_RT=overall_score_uab(6:10:end,:);
Att_short_acc=overall_score_uab(7:10:end,:);
Att_short_RT=overall_score_uab(8:10:end,:);
Att_long_acc=overall_score_uab(9:10:end,:);
Att_long_RT=overall_score_uab(10:10:end,:);

totVA_acc=VA_acc(:);
totCW_rad_acc=CW_rad_acc(:);
totCW_tan_acc=CW_tan_acc(:);


% [r,p]=corrcoef(totVA_acc,totCW_rad_acc)
% [r,p]=corrcoef(totVA_acc,totCW_tan_acc)
% 
% [r,p]=corrcoef(totCW_tan_acc,totCW_rad_acc)
% 
% dedata=[totCW_tan_acc,totCW_rad_acc,totVA_acc];
% [r,p]=corrcoef(dedata)


%% non-PRL specific analysis
figure
subplot(2,2,1)
scatter(VA_ovr,CW_rad_ovr, 'filled')
title('VA x CW radial')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(VA_ovr,CW_rad_ovr);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(VA_ovr)*0.8,max(CW_rad_ovr)*0.8, ['R = ' erre(1:5)] ) ;
text(max(VA_ovr)*0.8,max(CW_rad_ovr)*0.75, ['p = ' pp(1:5)] ) ;

xlabel('VA dva')
ylabel('CW radial dva')

subplot(2,2,2)
scatter(VA_ovr,CW_tan_ovr, 'filled')
title('VA x CW tangential')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(VA_ovr,CW_tan_ovr);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(VA_ovr)*0.8,max(CW_tan_ovr)*0.8, ['R = ' erre(1:5)] ) ;
text(max(VA_ovr)*0.8,max(CW_tan_ovr)*0.75, ['p = ' pp(1:5)] ) ;
xlabel('VA dva')
ylabel('CW tangential dva')

subplot(2,2,3)
scatter(CW_rad_ovr,CW_tan_ovr, 'filled')
title('CW radial x CW tangential')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(CW_rad_ovr,CW_tan_ovr);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(CW_rad_ovr)*0.8,max(CW_tan_ovr)*0.8, ['R = ' erre(1:5)] ) ;
%text(max(CW_rad_ovr)*0.8,max(CW_tan_ovr)*0.7, ['p = ' pp(1:5)] ) ;
text(max(CW_rad_ovr)*0.8,max(CW_tan_ovr)*0.7, 'p < 0.001 ' ) ;

xlabel('CW radial dva')
ylabel('CW tangential dva')

print('Flap pilot VAxCrowdingUABupdated', '-dpng', '-r300'); %<-Save as PNG with 300 DPI


figure
subplot(2,2,3)
scatter(VA_ovr,short_cueRT, 'filled')
title('VA x short cue RT')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(VA_ovr,short_cueRT);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(VA_ovr)*0.8,max(short_cueRT)*0.8, ['R = ' erre(1:5)] ) ;
text(max(VA_ovr)*0.8,max(short_cueRT)*0.6, ['p = ' pp(1:5)] ) ;

xlabel('VA dva')
ylabel('Att RT (cued-uncued)')

subplot(2,2,4)
scatter(VA_ovr,long_cueRT, 'filled')
title('VA x long cue RT')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(VA_ovr,long_cueRT);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(VA_ovr)*0.8,max(long_cueRT)*0.8, ['R = ' erre(1:5)] ) ;
text(max(VA_ovr)*0.8,max(long_cueRT)*0.6, ['p = ' pp(1:5)] ) ;

xlabel('VA dva')
ylabel('Att RT (cued-uncued)')

subplot(2,2,1)
scatter(VA_ovr,short_cueAC, 'filled')
title('VA x short cue accuracy')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(VA_ovr,short_cueAC);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(VA_ovr)*0.8,max(short_cueAC)*0.8, ['R = ' erre(1:5)] ) ;
text(max(VA_ovr)*0.8,max(short_cueAC)*0.7, ['p = ' pp(1:5)] ) ;
%xlim([0 1])

xlabel('VA dva')
ylabel('Att accuracy (uncued-cued)')

subplot(2,2,2)
scatter(VA_ovr,long_cueAC, 'filled')
title('VA x long cue accuracy')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(VA_ovr,long_cueAC);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(VA_ovr)*0.8,max(long_cueAC)*0.8, ['R = ' erre(1:5)] ) ;
text(max(VA_ovr)*0.8,max(long_cueAC)*0.6, ['p = ' pp(1:5)] ) ;
%xlim([0 1])
xlabel('VA dva')
ylabel('Att accuracy (uncued-cued)')

print('Flap pilot VA-attUABupdated', '-dpng', '-r300'); %<-Save as PNG with 300 DPI


figure
subplot(2,2,3)
scatter(CW_rad_ovr,short_cueRT, 'filled')
title('CW rad x short cue RT')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(CW_rad_ovr,short_cueRT);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(CW_rad_ovr)*0.8,max(short_cueRT)*0.8, ['R = ' erre(1:5)] ) ;
text(max(CW_rad_ovr)*0.8,max(short_cueRT)*0.6, ['p = ' pp(1:5)] ) ;

xlabel('CW radial dva')
ylabel('Att RT (cued-uncued)')

subplot(2,2,4)
scatter(CW_rad_ovr,long_cueRT, 'filled')
title('CW rad x long cue RT')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(CW_rad_ovr,long_cueRT);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(CW_rad_ovr)*0.8,max(long_cueRT)*0.8, ['R = ' erre(1:5)] ) ;
text(max(CW_rad_ovr)*0.8,max(long_cueRT)*0.6, ['p = ' pp(1:5)] ) ;

xlabel('CW radial dva')
ylabel('Att RT (cued-uncued)')

subplot(2,2,1)
scatter(CW_rad_ovr,short_cueAC, 'filled')
title('CW rad x short cue accuracy')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(CW_rad_ovr,short_cueAC);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(CW_rad_ovr)*0.8,max(short_cueAC)*0.8, ['R = ' erre(1:5)] ) ;
text(max(CW_rad_ovr)*0.8,max(short_cueAC)*0.7, ['p = ' pp(1:5)] ) ;
%xlim([0 1])

xlabel('CW radial dva')
ylabel('Att accuracy (uncued-cued)')

subplot(2,2,2)
scatter(CW_rad_ovr,long_cueAC, 'filled')
title('CW rad x long cue accuracy')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(CW_rad_ovr,long_cueAC);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(CW_rad_ovr)*0.8,max(long_cueAC)*0.8, ['R = ' erre(1:5)] ) ;
text(max(CW_rad_ovr)*0.8,max(long_cueAC)*0.6, ['p = ' pp(1:5)] ) ;
%xlim([0 1])
xlabel('CW radial dva')
ylabel('Att accuracy (uncued-cued)')

print('Flap pilot CW rad-attAUBupdated', '-dpng', '-r300'); %<-Save as PNG with 300 DPI



figure
subplot(2,2,3)
scatter(CW_tan_ovr,short_cueRT, 'filled')
title('CW tan x short cue RT')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(CW_tan_ovr,short_cueRT);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(CW_tan_ovr)*0.8,max(short_cueRT)*0.8, ['R = ' erre(1:5)] ) ;
text(max(CW_tan_ovr)*0.8,max(short_cueRT)*0.6, ['p = ' pp(1:5)] ) ;

xlabel('CW tangential dva')
ylabel('Att RT (cued-uncued)')

subplot(2,2,4)
scatter(CW_tan_ovr,long_cueRT, 'filled')
title('CW tan x long cue RT')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(CW_tan_ovr,long_cueRT);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(CW_tan_ovr)*0.8,max(long_cueRT)*0.8, ['R = ' erre(1:5)] ) ;
text(max(CW_tan_ovr)*0.8,max(long_cueRT)*0.6, ['p = ' pp(1:5)] ) ;

xlabel('CW tangential dva')
ylabel('Att RT (cued-uncued)')

subplot(2,2,1)
scatter(CW_tan_ovr,short_cueAC, 'filled')
title('CW tan x short cue accuracy')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(CW_tan_ovr,short_cueAC);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(CW_tan_ovr)*0.8,max(short_cueAC)*0.8, ['R = ' erre(1:5)] ) ;
text(max(CW_tan_ovr)*0.8,max(short_cueAC)*0.7, ['p = ' pp(1:5)] ) ;
%xlim([0 1])

xlabel('CW tangential dva')
ylabel('Att accuracy (uncued-cued)')

subplot(2,2,2)
scatter(CW_tan_ovr,long_cueAC, 'filled')
title('CW rad x long cue accuracy')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(CW_tan_ovr,long_cueAC);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(CW_tan_ovr)*0.8,max(long_cueAC)*0.8, ['R = ' erre(1:5)] ) ;
text(max(CW_tan_ovr)*0.8,max(long_cueAC)*0.6, ['p = ' pp(1:5)] ) ;
%xlim([0 1])
xlabel('CW tangential dva')
ylabel('Att accuracy (uncued-cued)')

print('Flap pilot CW tan-attUABupdated', '-dpng', '-r300'); %<-Save as PNG with 300 DPI



crowding_ratio=CW_tan_ovr./CW_rad_ovr;

figure
subplot(2,2,3)

scatter(crowding_ratio,short_cueRT, 'filled')
title('CW ratio x short cue RT')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(crowding_ratio,short_cueRT);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(crowding_ratio)*0.8,max(short_cueRT)*0.8, ['R = ' erre(1:5)] ) ;
text(max(crowding_ratio)*0.8,max(short_cueRT)*0.6, ['p = ' pp(1:5)] ) ;

xlabel('CW ratio dva')
ylabel('Att RT (cued-uncued)')

subplot(2,2,4)
scatter(crowding_ratio,long_cueRT, 'filled')
title('CW ratio x long cue RT')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(crowding_ratio,long_cueRT);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(crowding_ratio)*0.8,max(long_cueRT)*0.8, ['R = ' erre(1:5)] ) ;
text(max(crowding_ratio)*0.8,max(long_cueRT)*0.6, ['p = ' pp(1:5)] ) ;

xlabel('CW ratio dva')
ylabel('Att RT (cued-uncued)')

subplot(2,2,1)
scatter(crowding_ratio,short_cueAC, 'filled')
title('CW ratio x short cue accuracy')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(crowding_ratio,short_cueAC);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(crowding_ratio)*0.8,max(short_cueAC)*0.8, ['R = ' erre(1:5)] ) ;
text(max(crowding_ratio)*0.8,max(short_cueAC)*0.7, ['p = ' pp(1:5)] ) ;
%xlim([0 1])

xlabel('CW ratio dva')
ylabel('Att accuracy (uncued-cued)')

subplot(2,2,2)
scatter(crowding_ratio,long_cueAC, 'filled')
title('CW ratio x long cue accuracy')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(crowding_ratio,long_cueAC);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(crowding_ratio)*0.8,max(long_cueAC)*0.8, ['R = ' erre(1:5)] ) ;
text(max(crowding_ratio)*0.8,max(long_cueAC)*0.6, ['p = ' pp(1:5)] ) ;
%xlim([0 1])
xlabel('CW ratio dva')
ylabel('Att accuracy (uncued-cued)')

print('Flap pilot CW ratio x AttUABupdated', '-dpng', '-r300'); %<-Save as PNG with 300 DPI


crowding_area=CW_tan_ovr.*CW_rad_ovr.*pi;


figure
subplot(2,2,3)

scatter(crowding_area,short_cueRT, 'filled')
title('CW area x short cue RT')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(crowding_area,short_cueRT);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(crowding_area)*0.8,max(short_cueRT)*0.8, ['R = ' erre(1:5)] ) ;
text(max(crowding_area)*0.8,max(short_cueRT)*0.6, ['p = ' pp(1:5)] ) ;

xlabel('CW area dva')
ylabel('Att RT (cued-uncued)')

subplot(2,2,4)
scatter(crowding_area,long_cueRT, 'filled')
title('CW area x long cue RT')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(crowding_area,long_cueRT);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(crowding_area)*0.8,max(long_cueRT)*0.8, ['R = ' erre(1:5)] ) ;
text(max(crowding_area)*0.8,max(long_cueRT)*0.6, ['p = ' pp(1:5)] ) ;

xlabel('CW area dva')
ylabel('Att RT (cued-uncued)')

subplot(2,2,1)
scatter(crowding_area,short_cueAC, 'filled')
title('CW area x short cue accuracy')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(crowding_area,short_cueAC);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(crowding_area)*0.8,max(short_cueAC)*0.8, ['R = ' erre(1:5)] ) ;
text(max(crowding_area)*0.8,max(short_cueAC)*0.7, ['p = ' pp(1:5)] ) ;
%xlim([0 1])

xlabel('CW area dva')
ylabel('Att accuracy (cue-uncue)')

subplot(2,2,2)
scatter(crowding_area,long_cueAC, 'filled')
title('CW area x long cue accuracy')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(crowding_area,long_cueAC);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(crowding_area)*0.8,max(long_cueAC)*0.8, ['R = ' erre(1:5)] ) ;
text(max(crowding_area)*0.8,max(long_cueAC)*0.6, ['p = ' pp(1:5)] ) ;
%xlim([0 1])
xlabel('CW area dva')
ylabel('Att accuracy (cue-uncue)')

print('Flap pilot CW area x AttUABupdated', '-dpng', '-r300'); %<-Save as PNG with 300 DPI


figure
%subplot(2,1,1)
scatter(VA_ovr, crowding_ratio, 'filled')
title('VA x CW ratio')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(VA_ovr, crowding_ratio);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(VA_ovr)*0.8,max(crowding_ratio)*0.8, ['R = ' erre(1:5)] ) ;
text(max(VA_ovr)*0.8,max(crowding_ratio)*0.6, ['p = ' pp(1:5)] ) ;
%xlim([0 1])
ylabel('CW ratio dva')
xlabel('VA dva')

print('Flap pilot CW ratio x VAUABupdated', '-dpng', '-r300'); %<-Save as PNG with 300 DPI


figure
%subplot(2,1,1)
scatter(VA_ovr, crowding_area, 'filled')
title('VA x CW area')
h1 = lsline;
h1.Color = 'r';
[r,p]=corrcoef(VA_ovr, crowding_area);
erre=num2str(r(2));
pp=num2str(p(2));
hold on
text(max(VA_ovr)*0.8,max(crowding_area)*0.8, ['R = ' erre(1:5)] ) ;
text(max(VA_ovr)*0.8,max(crowding_area)*0.6, ['p = ' pp(1:5)] ) ;
%xlim([0 1])
ylabel('CW area dva')
xlabel('VA dva')

print('Flap pilot CW area x VAUABupdated', '-dpng', '-r300'); %<-Save as PNG with 300 DPI


average_VA=mean(general_thresh(1,:));
Average_CW_rad=mean(general_thresh(2,:));
Average_CW_tan=mean(general_thresh(3,:));



%% PRL-specific analysis

%VA
%figure
figure
subplot(2,1,1)
boxplot(VA_acc)
title ('VA accuracy x PRL')
xlabel('PRL')
ylabel('VA % acc')

subplot(2,1,2)
boxplot(VA_RT)
title ('VA RT x PRL')
xlabel('PRL')
ylabel('VA RT')


print('Flap pilot VA_PRLUABupdated', '-dpng', '-r300'); %<-Save as PNG with 300 DPI



     figure
     ui=ones(length(VA_acc),1);
     subplot(2,1,1)
violin(VA_acc,'x',[1 2 3 4], 'facecolor',[.4 .4 .4],'edgecolor','k', 'mc','k','medc','r--')
hold on
scatter(ui, VA_acc(:,1), 'k', 'filled')
hold on
scatter(ui+1, VA_acc(:,2), 'k', 'filled')
hold on
scatter(ui+2, VA_acc(:,3), 'k', 'filled')
hold on
scatter(ui+3, VA_acc(:,4), 'k', 'filled')


ylim([0 1.1])
xlim([0.1 4.95])
%ylim([-130 220])
hFig=findall(0,'type','figure');
hLeg=findobj(hFig(1,1),'type','legend');
set(hLeg,'visible','off')
%set(gca,'FontSize',30)
title (['VA PRL Accuracy'], 'fontsize', 22)
 ylabel(['% accuracy'], 'fontsize', 20);
set(gca,'XTick',[]);


 subplot(2,1,2)
 
 
 
 mean(VA_RT)
 
 

violin(VA_RT,'x',[1 2 3 4], 'facecolor',[.4 .4 .4],'edgecolor','k', 'mc','k','medc','r--')
hold on
scatter(ui, VA_RT(:,1), 'k', 'filled')
hold on
scatter(ui+1, VA_RT(:,2), 'k', 'filled')
hold on
scatter(ui+2, VA_RT(:,3), 'k', 'filled')
hold on
scatter(ui+3, VA_RT(:,4), 'k', 'filled')


ylim([0.2 1.1])
xlim([0.1 4.95])
%ylim([-130 220])
hFig=findall(0,'type','figure');
hLeg=findobj(hFig(1,1),'type','legend');
set(hLeg,'visible','off')
%set(gca,'FontSize',30)
title (['VA PRL RT'], 'fontsize', 22)
set(gca,'XTick',[]);
 ylabel(['Reaction time (s)'], 'fontsize', 20);
 
print('Flap pilot VA_PRLUAB_violinRTupdated', '-dpng', '-r300'); %<-Save as PNG with 300 DPI





%CW
figure
subplot(2,2,1)
boxplot(CW_rad_acc)
title ('CW radial accuracy x PRL')
xlabel('PRL')
ylabel('CW radial % acc')

subplot(2,2,2)
boxplot(CW_tan_acc)
title ('CW tangential accuracy x PRL')
xlabel('PRL')
ylabel('CW tan % acc')

subplot(2,2,3)
boxplot(CW_rad_RT)
title ('CW radial RT x PRL')
xlabel('PRL')
ylabel('CW radial RT')

subplot(2,2,4)
boxplot(CW_tan_RT)
title ('CW tangential RT x PRL')
xlabel('PRL')
ylabel('CW tangential RT')


print('Flap pilot CW_PRLUABupdated', '-dpng', '-r300'); %<-Save as PNG with 300 DPI


%Att
figure
subplot(2,2,1)
boxplot(Att_short_acc)
title ('Att short cue acc x PRL')
xlabel('PRL')
ylabel('cue-uncue % acc')

subplot(2,2,2)
boxplot(Att_long_acc)
title ('Att long cue acc x PRL')
xlabel('PRL')
ylabel('cue-uncue % acc')

subplot(2,2,3)
boxplot(Att_short_RT)
title ('Att short cue RT x PRL')
xlabel('PRL')
ylabel('RT (cue-uncue)')

subplot(2,2,4)
boxplot(Att_long_RT)
title ('Att long cue RT x PRL')
xlabel('PRL')
ylabel('RT (cue-uncue)')


print('Flap pilot Att_PRLUABupdated', '-dpng', '-r300'); %<-Save as PNG with 300 DPI

