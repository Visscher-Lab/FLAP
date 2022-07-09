
clear all
close all
range = (0:45:315)*pi/180;
addpath([cd '/CircStat2012a']);
addpath('/Users/marcellomaniglia/Documents/GitHub/FLAP/Analysis codes/Oculomotor Analysis');
addpath('/Users/marcellomaniglia/Documents/GitHub/FLAP/Analysis codes/Oculomotor Analysis/CircStat2012a');


angle = [ 0  pi/2  pi  3*pi/2 ];

load JunePilots2022.mat
fullmat=JunePilots2022;


PRL_from_induction=[0.152125422	0.438436046	0.280065005	0.129373526
0.090839784	0.070079756	0.104093361	0.734987098
0.024012171	0.643721384	0.30096307	0.031303374
0.078252142	0.084955372	0.019858766	0.81693372
0.080956478	0.13324459	0.365692115	0.420106816
0.283270159	0.025702269	0.062308531	0.62871904];

SubNum={'SD',
'RC',
'MR',
'PD', 
'PT', 
'DJ'};



%find best PRL from induction


for oe=1:length(PRL_from_induction)
bestPRL(oe,:)=(PRL_from_induction(oe,:))==max(PRL_from_induction(oe,:))  ;  
end


sturing=[1 2 3 4];
for oe=1:length(PRL_from_induction)
    
    dis=sturing(bestPRL(oe,:)==1)
    if length(dis)>1
        dis=NaN;
    end
thebestPRL(oe)=dis;
clear dis
end

%PRL_from_induction=PRL_from_induction(1:11,:);
% 
% 
% for ui=1:length(fullmat)    
%     relativefullmat(ui,:)=fullmat(ui,:)/sum(fullmat(ui,:));
% end


normalizedfullmat=mat2gray(fullmat);
relativefullmat=normalizedfullmat;


normalizedPRL_from_induction=mat2gray(PRL_from_induction);

for ui=1:length(normalizedPRL_from_induction)    
    relativePRL_from_induction(ui,:)=normalizedPRL_from_induction(ui,:)/sum(normalizedPRL_from_induction(ui,:));
end

for ui=1:length(relativefullmat)    
    newrelativefullmat(ui,:)=relativefullmat(ui,:)/sum(relativefullmat(ui,:));
end


for ui=1:length(newrelativefullmat)    
    newnewrelativefullmat(ui,:)=relativefullmat(ui,:)-min(relativefullmat(ui,:));
end




for ui=1:length(newnewrelativefullmat)    
    morenewnewrelativefullmat(ui,:)=newnewrelativefullmat(ui,:)/sum(newnewrelativefullmat(ui,:));
end
relativefullmat=newrelativefullmat;
VAAcc=relativefullmat(1:10:end,:);
VART=relativefullmat(2:10:end,:);
CWRAcc=relativefullmat(3:10:end,:);
CWRART=relativefullmat(4:10:end,:);
CWTAcc=relativefullmat(5:10:end,:);
CWTRT=relativefullmat(6:10:end,:);
AttSAcc=relativefullmat(7:10:end,:);
AttSRT=relativefullmat(8:10:end,:);
AttLAcc=relativefullmat(9:10:end,:);
AttLRT=relativefullmat(10:10:end,:);
PRL_ind=relativePRL_from_induction;

% VAAcc=mat2gray(VAAcc);
% VART=mat2gray(VART);
% VART=1-VART;
% CWRAcc=mat2gray(CWRAcc);
% CWRART=mat2gray(CWRART);
% CWRART=1-CWRART;
% CWTAcc=mat2gray(CWTAcc);
% CWTRT=mat2gray(CWTRT);
% CWTRT=1-CWTRT;
% AttSAcc=mat2gray(AttSAcc);
% AttSRT=mat2gray(AttSRT);
% AttSRT=1-AttSRT;
% AttLAcc=mat2gray(AttLAcc);
% AttLRT=mat2gray(AttLRT);
% AttLRT=1-AttLRT;
% PRL_ind=mat2gray(PRL_ind);


VAAcc_mean=mean(VAAcc(1:12,:));
VART_mean=mean(VART(1:12,:));
CWRAcc_mean=mean(CWRAcc(1:12,:));
CWRART_mean=mean(CWRART(1:12,:));
CWTAcc_mean=mean(CWTAcc(1:12,:));
CWTRT_mean=mean(CWTRT(1:12,:));
AttSAcc_mean=mean(AttSAcc(1:12,:));
AttSRT_mean=mean(AttSRT(1:12,:));
AttLAcc_mean=mean(AttLAcc(1:12,:));
AttLRT_mean=mean(AttLRT(1:12,:));
PRL_ind_mean=mean(relativePRL_from_induction(1:12,:));



 % average angle (across participants) for this specific task
 % average angle of this participant across task 
 % angle of the participant for this specific task


for ui=1:length(PRL_from_induction) %1:length(mnread_scores_pre_mean(1,:))
    
%  for ui=1

figure


 % average angle (across participants) for this specific task
score_induction = PRL_ind_mean; %mnread_scores(:,ui)';%PRL_test_scores_post_mean_av;
score_induction = PRL_ind_mean; %mnread_scores(:,ui)';%PRL_test_scores_post_mean_av;

 % average angle of this participant across task 
score_VA = VAAcc_mean; %search_scores(:,ui)'; %cell2mat(average_post(:,ui))';
 % angle of the participant for this specific task
score_crowdingR=CWRAcc_mean;
score_crowdingT=CWTAcc_mean;
scoreAttS=AttSAcc_mean;
scoreAttL=AttLAcc_mean;


%score_MNreadSEM=mnread_scores_post_std_av/sqrt(length(mnread_scores_pre_mean(1,:))-1);
%score_searchSEM=search_scores_post_std_av/sqrt(length(mnread_scores_pre_mean(1,:))-1);
%score_prl_testSEM=PRL_test_scores_post_std_av/sqrt(length(mnread_scores_pre_mean(1,:))-1);


Pax = polaraxes;

angler=angle-deg2rad(225);
angler=angle-deg2rad(180);

flipscore=fliplr(score_induction);
flipscore2=fliplr(score_VA);
flipscore3=fliplr(score_crowdingR);
flipscore4=fliplr(score_crowdingT);
flipscore5=fliplr(scoreAttS);
flipscore6=fliplr(scoreAttL);


polarplot(Pax,[angle angle(1)], [score_induction score_induction(1)],'g-','LineWidth',2)
%hold on
%polarfill7(Pax, [angler angler(1)], 0, [flipscore flipscore(1)],'green', 0.15);
hold on
% for uui=1: length(angle)+1
%     if uui==length(angle)+1        
%                 polarplot(Pax,angle(1)*ones(1,2),[score_search(1) - score_searchSEM(1), score_search(1) + score_searchSEM(1)],' - g','LineWidth',3);
%     else
%                 polarplot(Pax,angle(uui)*ones(1,2),[score_search(uui) - score_searchSEM(uui), score_search(uui) + score_searchSEM(uui)],' - g','LineWidth',3);
%     end
%     hold on
% end

polarplot(Pax,[angle angle(1)], [score_VA score_VA(1)],'k-','LineWidth',2)
%hold on
%polarfill7(Pax, [angler angler(1)], 0, [flipscore2 flipscore2(1)],'blue', 0.15);
% 
% for uui=1: length(angle)+1
%     if uui==length(angle)+1        
%                 polarplot(Pax,angle(1)*ones(1,2),[score_prl_test(1) - score_prl_testSEM(1), score_prl_test(1) + score_prl_testSEM(1)],' -b','LineWidth',3);
%     else
%                 polarplot(Pax,angle(uui)*ones(1,2),[score_prl_test(uui) - score_prl_testSEM(uui), score_prl_test(uui) + score_prl_testSEM(uui)],' - b', 'LineWidth',3);
%     end
%     hold on
% end

hold on
polarplot(Pax,[angle angle(1)], [score_crowdingR score_crowdingR(1)],'r-','LineWidth',2)
%hold on
%polarfill7(Pax, [angler angler(1)], 0, [flipscore3 flipscore3(1)],'red', 0.15);
% 
% for uui=1: length(angle)+1
%     if uui==length(angle)+1        
%                 polarplot(Pax,angle(1)*ones(1,2),[score_MNread(1) - score_MNreadSEM(1), score_MNread(1) + score_MNreadSEM(1)],' - r','LineWidth',3);
%     else
%                 polarplot(Pax,angle(uui)*ones(1,2),[score_MNread(uui) - score_searchSEM(uui), score_MNread(uui) + score_MNreadSEM(uui)],' - r','LineWidth',3);
%     end
% 
%     hold on
% end

hold on
du=polarplot(Pax,[angle angle(1)], [score_crowdingT score_crowdingT(1)],'y-','LineWidth',2)
%hold on
%polarfill7(Pax, [angler angler(1)], 0, [flipscore4 flipscore4(1)],'cyan', 0.15);
du.Color=[0.9290 0.6940 0.1250];

hold on
dd=polarplot(Pax,[angle angle(1)], [scoreAttS scoreAttS(1)],'m-','LineWidth',2)
%hold on
%polarfill7(Pax, [angler angler(1)], 0, [flipscore5 flipscore5(1)],'black', 0.15);
dd.Color=[0.4940 0.1840 0.5560];


hold on
polarplot(Pax,[angle angle(1)], [scoreAttL scoreAttL(1)],'b-','LineWidth',2)
%hold on
%polarfill7(Pax, [angler angler(1)], 0, [flipscore6 flipscore6(1)],'yellow', 0.15);

d = Pax.ThetaDir;
Pax.ThetaDir = 'clockwise';
Pax.ThetaZeroLocation = 'top';
%title(Pax,'Average PRL location per task', 'fontsize',16)
Pax.RTickLabel = []; 
%Pax.ThetaTickLabel = [];
set(Pax,'FontSize',20)

Pax.LineWidth = 3;
%    axis square; 
    %set(Pax,'visible','off');

rlim(Pax, [0, 0.45]);
  %      ylim(Pax, [-40, 40]);
 %legend(Pax, 'task average','participant average', 'participant task average','location', 'Northeast')
%legend(Pax, '1','2','3','location', 'Northeast')
%legend(Pax, ['S' num2str(ui) ' MNRead'], ['S' num2str(ui) ' Search'],['S' num2str(ui) ' PRL test'],'location', 'Northeast')


lgt=legend(Pax, ['PRL'],['VA'], ['CWrad'],['CWtan'], ['ExoAtt'], ['SustAtt'],'location', 'Northeast')
lgt.FontSize=13;
%title(Pax,'Average PRL location per task', 'fontsize',16)

%title('Individual vs task-specific PRL', 'fontsize',16)

print([ SubNum{ui} 'relativetotALsummary_VSS2022Accc' ], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

    end

    