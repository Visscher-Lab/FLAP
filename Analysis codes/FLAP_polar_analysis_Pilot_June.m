%PRL polar analysis

clear all
close all
range = (0:45:315)*pi/180;
%addpath([cd '/CircStat2012a']);
addpath('/Users/marcellomaniglia/Documents/GitHub/FLAP/Analysis codes/Oculomotor Analysis');
addpath('/Users/marcellomaniglia/Documents/GitHub/FLAP/Analysis codes/Oculomotor Analysis/CircStat2012a');


    angle_deg = [0 45 90  90+45 180 180+45 180+90 180+90+45];
angle = [ 0 pi/4 pi/2 3*pi/4 pi -3*pi/4 3*pi/2 -pi/4];

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
theNames=SubNum;

frameDistributionPRL=PRL_from_induction;
%theoriginalPRLs=[thePRLs(7:12,:);
%     thePRLs(15:16,:); 
%     thePRLs(19:20,:); 
%     thePRLs(1:6,:); 
%     thePRLs(13:14,:); 
%     thePRLs(17:18,:); 
%     thePRLs(21:22,:)];
    thePRLs=[-1.9754	1.2289
7.0598	0.4589
1.6723	-5.6088
6.653	-0.5334
-0.9822	2.0686
6.6071	-2.5054];

thePRLs=-thePRLs;
  angle_deg = [0  90   180  180+90];
subjs=6;
for ui=1:length(thePRLs)
[theta,rho] = cart2pol(thePRLs(ui,1), thePRLs(ui,2));
PRL(ui,1)=theta;
PRL(ui,2)=rho;
end


%PRL=PRL(2:2:end,:);
%theNamesList=1:2:22;
  stops=1:10:(subjs*10);
stopsAcc=1:5:(subjs*5);
  for ui=1:subjs
subj{ui}=fullmat(stops(ui):stops(ui)+9,:);

  end
 
FLAP_pilot_ACC=fullmat(1:2:end,:);
FLAP_pilot_RT=fullmat(2:2:end,:);


  for ui=1:subjs
subjAcc{ui}=FLAP_pilot_ACC(stopsAcc(ui):stopsAcc(ui)+4,:);

  end 

  for ui=1:subjs
subjRT{ui}=FLAP_pilot_RT(stopsAcc(ui):stopsAcc(ui)+4,:);
  end

  allsubjnorm=[];
  %remove the attention data because it's pre-processed (cued-uncued)
  for ui=1:subjs
%subjAccprenorm{ui}=subjAcc{ui}(1:3,:);
 %newsubj=subjAccprenorm{1};
 newsubj=subjAcc{ui}(1:3,:);
  allsubjnorm=[allsubjnorm ;newsubj];
  end 

  %normalize VA and crowding
  %newallsubjnorm=[allsubjnorm(1:9,:); allsubjnorm(13:end,:)];
  %newallsubjnormnorm=mat2gray(newallsubjnorm);
  allsubjnorm=mat2gray(allsubjnorm);
normalizedVA=allsubjnorm(1:3:end,:);
normalizedCWrad=allsubjnorm(2:3:end,:);
normalizedCWtan=allsubjnorm(3:3:end,:);

%normalize attention score
% extract attention data
allsubjprenormAtt=[];
  for ui=1:subjs
newsubj=subjAcc{ui}(4:5,:);
  allsubjprenormAtt=[allsubjprenormAtt ;newsubj];
  end 
  
  allsubjnormAtt=mat2gray(allsubjprenormAtt);
  
  
  %normalize PRL distribution
  
  NormframeDistributionPRL=mat2gray(frameDistributionPRL);
%more 'normalization': now high is better (before low was better)  
  allsubjnormAtt=1-allsubjnormAtt;
normalizedshortAtt=allsubjnormAtt(1:2:end,:);
normalizedlongAtt=allsubjnormAtt(2:2:end,:);


% relative score

for ui=1:length(normalizedVA)
    relativenormalizedVA(ui,:)=normalizedVA(ui,:)/sum(normalizedVA(ui,:));
end

for ui=1:length(normalizedCWrad)
    relativenormalizedCWrad(ui,:)=normalizedCWrad(ui,:)/sum(normalizedCWrad(ui,:));
end

for ui=1:length(normalizedCWtan)
    relativenormalizedCWtan(ui,:)=normalizedCWtan(ui,:)/sum(normalizedCWtan(ui,:));
end

for ui=1:length(NormframeDistributionPRL)
    relativeNormframeDistributionPRL(ui,:)=NormframeDistributionPRL(ui,:)/sum(NormframeDistributionPRL(ui,:));
end

for ui=1:length(normalizedlongAtt)
    relativenormalizedlongAtt(ui,:)=normalizedlongAtt(ui,:)/sum(normalizedlongAtt(ui,:));
end

for ui=1:length(normalizedshortAtt)
    relativenormalizedshortAtt(ui,:)=normalizedshortAtt(ui,:)/sum(normalizedshortAtt(ui,:));
end

commandwindow
subjs=6;
%subjs=1;

for ui=1:subjs
 %for   ui=4
    
   % for ui=1
    newanglesVA = [];
    newanglesCWrad = [];
       newanglesCWtan = [];
     newanglesshortAtt = [];
     newangleslongtAtt = [];
newanglesPRLdist = [];
        score_VA = relativenormalizedVA(ui,:);
    score_CWrad = relativenormalizedCWrad(ui,:);   
        score_CWtan = relativenormalizedCWtan(ui,:);  
score_attshort=relativenormalizedshortAtt(ui,:);   
score_attlong=relativenormalizedlongAtt(ui,:);   

score_PRLdist=relativeNormframeDistributionPRL(ui,:);


for sie =1: length(score_VA)
    if sum(isnan(score_attshort))==0
        newanglesVA=[newanglesVA ones(1,round(score_VA(sie)))*angle_deg(sie)];
        newanglesCWrad =[newanglesCWrad ones(1,round(score_CWrad(sie)))*angle_deg(sie)];
        newanglesCWtan =[newanglesCWtan ones(1,round(score_CWtan(sie)))*angle_deg(sie)];
        newanglesshortAtt =[newanglesshortAtt ones(1,round(score_attshort(sie)))*angle_deg(sie)];
        newangleslongtAtt =[newangleslongtAtt ones(1,round(score_attlong(sie)))*angle_deg(sie)];
        if isnan(score_PRLdist(sie))==0
        newanglesPRLdist =[newanglesPRLdist ones(1,round(score_PRLdist(sie)))*angle_deg(sie)];
        elseif isnan(score_PRLdist(sie))==1
                    newanglesPRLdist =[newanglesPRLdist ones(1,0*angle_deg(sie))];
        end

    else
        score_VA=[nan(length(score_VA),1)'];
        score_CWrad=score_VA;
        score_CWtan=score_VA;
        score_attlong=score_VA;
        newanglesVA=nan;
        newanglesCWrad = nan;
        newanglesCWtan = nan;
        newanglesshortAtt = nan;
        newangleslongtAtt = nan;
        newanglesPRLdist=nan;
    end
end
  
alpha_rad_VA = circ_ang2rad(newanglesVA)'; 
alpha_rad_CWrad = circ_ang2rad(newanglesCWrad)'; 
alpha_rad_CWtan = circ_ang2rad(newanglesCWtan)'; 
alpha_rad_Attshort = circ_ang2rad(newanglesshortAtt)'; 
alpha_rad_Attlong = circ_ang2rad(newangleslongtAtt)'; 
alpha_rad_PRLdist = circ_ang2rad(newanglesPRLdist)'; 


figure
%VA
polarplot([angle angle(1)], [score_VA score_VA(1)],'k-','LineWidth',2) %-o', 'MarkerFaceColor', 'b')

[t,r]=rose(alpha_rad_VA,range);
%[t2,r2]=polarhistogram(alpha_rad_VA)
mr = max(2*r/sum(r));
 r = circ_r(alpha_rad_VA) * mr;
      phiVA = circ_mean(alpha_rad_VA);
      hold on;
 if r*100>1
    newr=1;
else
    newr=r*100;
end
%polarplot([0 phiVA], [0 newr], 'r-o', 'lineWidth', 2)

%crowding rad
hold on
polarplot([angle angle(1)], [score_CWrad score_CWrad(1)],'r-', 'LineWidth',2) %-o', 'MarkerFaceColor', 'r')

[t,r]=rose(alpha_rad_CWrad,range);
mr = max(2*r/sum(r));
 r = circ_r(alpha_rad_CWrad) * mr;
      phi = circ_mean(alpha_rad_CWrad);
      hold on;

      if r*100>1
          newr=1;
      else
          newr=r*100;
      end
%polarplot([0 phi], [0 newr], 'g-o', 'lineWidth', 2)
%crowding tan
hold on
du=polarplot([angle angle(1)], [score_CWtan score_CWtan(1)], 'LineWidth',2) %, 'MarkerFaceColor', 'c')

du.Color=[0.9290 0.6940 0.1250];

hold on
%hold on
%polarfill7(Pax, [angler angler(1)], 0, [flipscore5 flipscore5(1)],'black', 0.15);

[t,r]=rose(alpha_rad_CWtan,range);
mr = max(2*r/sum(r));
 r = circ_r(alpha_rad_CWtan) * mr;
      phi = circ_mean(alpha_rad_CWtan);
      hold on;
if r*100>1
    newr=1;
else
    newr=r*100;
end
%polarplot([0 phi], [0 newr], 'k-o', 'lineWidth', 2)
%att short
hold on
dd=polarplot([angle angle(1)], [score_attshort score_attshort(1)], 'LineWidth',2) %, 'MarkerFaceColor', 'm')
dd.Color=[0.4940 0.1840 0.5560];

[t,r]=rose(alpha_rad_Attshort,range);
mr = max(2*r/sum(r));
 r = circ_r(alpha_rad_Attshort) * mr;
      phi = circ_mean(alpha_rad_Attshort);
      hold on;
if r*100>1
    newr=1;
else
    newr=r*100;
end
%polarplot([0 phi], [0 newr], 'y-o', 'lineWidth', 2)

%att long
hold on
polarplot([angle angle(1)], [score_attlong score_attlong(1)],'b-','LineWidth',2 ) % -o', 'MarkerFaceColor', 'b')

[t,r]=rose(alpha_rad_Attlong,range)
mr = max(2*r/sum(r));
 r = circ_r(alpha_rad_Attlong) * mr;
      phi = circ_mean(alpha_rad_Attlong);
      hold on;
if r*100>1
    newr=1;
else
    newr=r*100;
end
%polarplot([0 phi], [0 newr], 'b-o', 'lineWidth', 2)



%PRL dist long


clear ddd
hold on
%ddd=polarplot([angle angle(1)], [score_PRLdist score_PRLdist(1)],'g-o', 'MarkerFaceColor', 'g')
polarplot([angle angle(1)], [score_PRLdist score_PRLdist(1)],'g-', 'LineWidth',2) %-o', 'MarkerFaceColor', 'g')
%ddd.Color=[130/255 130/255 42/255 ];

[t,r]=rose(alpha_rad_PRLdist,range)
mr = max(2*r/sum(r));
 r = circ_r(alpha_rad_PRLdist) * mr;
      phi = circ_mean(alpha_rad_PRLdist);
      hold on;
if r*100>1
    newr=1;
else
    newr=r*100;
end
%polarplot([0 phi], [0 newr], 'b-o', 'lineWidth', 2)


hold on
%ppp=polarplot(PRL(ui,1), 0.5,'ko', 'MarkerFaceColor', 'y')

if PRL(ui,2)>0
%ppp=polarplot((PRL(ui,1)-deg2rad(270)), -0.5,'ko', 'MarkerFaceColor', 'y')
ppp=polarplot((PRL(ui,1)-deg2rad(90)), -0.5,'ko', 'MarkerFaceColor', 'y');

elseif PRL(ui,2)<0
%    ppp=polarplot((PRL(ui,1)-deg2rad(270)), 0.5,'ko', 'MarkerFaceColor', 'y')
    ppp=polarplot((PRL(ui,1)-deg2rad(90)), 0.5,'ko', 'MarkerFaceColor', 'y');

end


ppp.MarkerSize = 12;

ax = gca;
d = ax.ThetaDir;
ax.ThetaDir = 'clockwise';
ax.ThetaZeroLocation = 'top';
ax.RTickLabel = []; 
ax.LineWidth = 3;

%name=theNames{theNamesList(ui)};
name=theNames{(ui)};
name=char(name);
name=name(1:2);
%title([name ' Summary performance Accuracy '])
%title(['S' num2str(ui) ' Summary performance Accuracy '])
title([name ' Summary performance Accuracy '])

rlim([0 0.89])
%rlim([0 60]) % to zoom in

%legend('VA','VA vector', 'CWrad', 'CWrad vector', 'CWtan', 'CWtan vector', 'short cue', 'short cue vector', 'long cue', 'long cue vector', 'PRL')
set(gca,'FontSize',20)

legend('VA', 'CWrad', 'CWtan', 'exoAtt',  'sustAtt', 'PRLind', 'PRLfix')

%print([name 'polar_summary_compare_norm_2022Relative'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%print([name 'polar_summary_compare_normzoom'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
print([name 'polar_summary_FlapJunePilot'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%    close all 

close all
figure
   barmat=[     score_VA' score_CWrad' score_CWtan' score_attshort' score_attlong' score_PRLdist'];
   bar(barmat)
somenames={'0', '90', '180', '270'};
set(gca,'xticklabel',somenames);
legend('VA', 'CWrad', 'CWtan', 'exoAtt',  'sustAtt', 'PRLind', 'PRLfix')
ylabel('probability use')
set(gca,'FontSize',20);
title([name ' PRL use across tasks'])
print([name ' barplotPRLuse_FlapJunePilot'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

    clear newanglesVA    newanglesCWrad  newanglesCWtan  newanglesshortAtt newangleslongtAtt    
close all
end

close all

