
clear all
close all
range = (0:45:315)*pi/180;
%addpath([cd '/CircStat2012a']);
addpath('/Users/marcellomaniglia/Documents/GitHub/FLAP/Analysis codes/Oculomotor Analysis');
addpath('/Users/marcellomaniglia/Documents/GitHub/FLAP/Analysis codes/Oculomotor Analysis/CircStat2012a');


    angle_deg = [0 45 90  90+45 180 180+45 180+90 180+90+45];
angle = [ 0 pi/4 pi/2 3*pi/4 pi -3*pi/4 3*pi/2 -pi/4];

angle = [ 0  pi/2  pi  3*pi/2 ];


%load FLAP_updated_2022_with_PRL.mat
%fullmat=overall_score_uab;


PRL_from_induction=[0.024012171	0.643721384	0.30096307	0.031303374
0.078252142	0.084955372	0.019858766	0.81693372
0.152125422	0.438436046	0.280065005	0.129373526];

SubNum=['MR',
'PD',
'SD'];


% PRL_ind=mat2gray(PRL_ind);
% 
% 
% PRL_ind_mean=mean(PRL_ind);



 % average angle (across participants) for this specific task
 % average angle of this participant across task 
 % angle of the participant for this specific task


for ui=1:length(PRL_from_induction(:,1)) %1:length(mnread_scores_pre_mean(1,:))
    
%  for ui=1

figure


%score_induction = PRL_ind_mean; %mnread_scores(:,ui)';%PRL_test_scores_post_mean_av;

score_induction=PRL_from_induction(ui,:);


Pax = polaraxes;

angler=angle-deg2rad(225);
angler=angle-deg2rad(180);

flipscore=fliplr(score_induction);

polarplot(Pax,[angle angle(1)], [score_induction score_induction(1)],'g-','LineWidth',2)
hold on
polarfill5(Pax, [angler angler(1)], 0, [flipscore flipscore(1)],'green', 0.15);

d = Pax.ThetaDir;
Pax.ThetaDir = 'clockwise';
Pax.ThetaZeroLocation = 'top';
%title(Pax,'Average PRL location per task', 'fontsize',16)
Pax.RTickLabel = []; 
%Pax.ThetaTickLabel = [];
set(Pax,'FontSize',20)

Pax.LineWidth = 3;
    axis square; 
    %set(Pax,'visible','off');

rlim(Pax, [0, 1]);
  %      ylim(Pax, [-40, 40]);
 %legend(Pax, 'task average','participant average', 'participant task average','location', 'Northeast')
%legend(Pax, '1','2','3','location', 'Northeast')
%legend(Pax, ['S' num2str(ui) ' MNRead'], ['S' num2str(ui) ' Search'],['S' num2str(ui) ' PRL test'],'location', 'Northeast')


lgt=legend(Pax, [SubNum(ui,:) ' PRL from Induction'],'location', 'Northeast');
lgt.FontSize=13;
%title(Pax,'Average PRL location per task', 'fontsize',16)

%title('Individual vs task-specific PRL', 'fontsize',16)

print([ SubNum(ui,:) 'pilotUAB' ], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

    end

    