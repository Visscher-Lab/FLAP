%PRL polar analysis

clear all
close all

%angle = [ 0 pi/4 pi/2 3*pi/4 pi -3*pi/4 3*pi/2 -pi/4];


angle = [ 0  pi/2  pi  3*pi/2];
%range = (0:45:315)*pi/180;
range = (0:90:315)*pi/180;

addpath(['/Users/marcellomaniglia/Downloads/VSS 2021/Polar analysis/CircStat2012a']);
addpath([cd '/github_repo']);

load FLAP_pilot.mat
thePRLs=[thePRLs(7:12,:);
    thePRLs(15:16,:); 
    thePRLs(19:20,:); 
    thePRLs(1:6,:); 
    thePRLs(13:14,:); 
    thePRLs(17:18,:); 
    thePRLs(21:22,:)];
thePRLs=-thePRLs;


  angle_deg = [0  90   180  180+90];
subjs=11;
for ui=1:length(thePRLs)
[theta,rho] = cart2pol(thePRLs(ui,1), thePRLs(ui,2));
PRL(ui,1)=theta;
PRL(ui,2)=rho;
end


PRL=PRL(2:2:end,:);
theNamesList=1:2:22;
  stops=1:10:(subjs*10);
stopsAcc=1:5:(subjs*5);
  for ui=1:subjs
subj{ui}=FLAP_pilot(stops(ui):stops(ui)+9,:);

  end

FLAP_pilot_ACC=FLAP_pilot(1:2:end,:);
FLAP_pilot_RT=FLAP_pilot(2:2:end,:);


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
  
%more 'normalization': now high is better (before low was better)  
  allsubjnormAtt=1-allsubjnormAtt;
normalizedshortAtt=allsubjnormAtt(1:2:end,:);
normalizedlongAtt=allsubjnormAtt(2:2:end,:);


%for ui=1:subjs
    for ui=1
    newanglesVA = [];
    newanglesCWrad = [];
       newanglesCWtan = [];
     newanglesshortAtt = [];
     newangleslongtAtt = [];

        score_VA = normalizedVA(ui,:);
    score_CWrad = normalizedCWrad(ui,:);   
        score_CWtan = normalizedCWtan(ui,:);  
score_attshort=normalizedshortAtt(ui,:);   
score_attlong=normalizedlongAtt(ui,:);   


for sie =1: length(score_VA)
    if sum(isnan(score_VA))==0
        newanglesVA=[newanglesVA ones(1,round(score_VA(sie)))*angle_deg(sie)];
        newanglesCWrad =[newanglesCWrad ones(1,round(score_CWrad(sie)))*angle_deg(sie)];
        newanglesCWtan =[newanglesCWtan ones(1,round(score_CWtan(sie)))*angle_deg(sie)];
        newanglesshortAtt =[newanglesshortAtt ones(1,round(score_attshort(sie)))*angle_deg(sie)];
        newangleslongtAtt =[newangleslongtAtt ones(1,round(score_attlong(sie)))*angle_deg(sie)];
        
    else
        newanglesVA=nan;
        newanglesCWrad = nan;
        newanglesCWtan = nan;
        newanglesshortAtt = nan;
        newangleslongtAtt = nan;
    end
end
  
alpha_rad_VA = circ_ang2rad(newanglesVA)'; 
alpha_rad_CWrad = circ_ang2rad(newanglesCWrad)'; 
alpha_rad_CWtan = circ_ang2rad(newanglesCWtan)'; 
alpha_rad_Attshort = circ_ang2rad(newanglesshortAtt)'; 
alpha_rad_Attlong = circ_ang2rad(newangleslongtAtt)'; 
nBins = 4; % number of bins, makes bin size of 10 deg


%figure
%crowding VA

bin_one=round(score_VA.*100);
%sDist= angle_deg.*bin_one

sDist= [];
for hi=1:length(angle_deg)
sDist=[sDist ones(1,bin_one(hi))*angle_deg(hi)'];
end
    
%Plot the circular histogram:
fH = figure;
ax = polaraxes(fH);
ax.ThetaDir= 'clockwise';
obj1 = CircHist(sDist, nBins, 'parent', ax,'edges', -45:90:315);
%obj1 = CircHist(sDist, nBins);
fH.Visible = 'on';
obj1.colorAvgAng= [.71 0 0];
obj1.colorBar=[.71 0 0 ];

%figure

bin_one=round(score_CWrad.*100);

sDist= [];
for hi=1:length(angle_deg)
sDist=[sDist ones(1,bin_one(hi))*angle_deg(hi)'];
end
    
hold on
%Plot the circular histogram:
%fH = figure;
%ax = polaraxes(fH);
%ax.ThetaDir= 'clockwise';
obj2 = CircHist(sDist, nBins, 'parent', ax,'edges', -45:90:315);
fH.Visible = 'on';
obj2.colorAvgAng= [0 .71 0];
obj2.colorBar=[0 0.71 0 ];


%att short
hold on
bin_one=round(score_attshort.*100);

sDist= [];
for hi=1:length(angle_deg)
sDist=[sDist ones(1,bin_one(hi))*angle_deg(hi)'];
end
    %Plot the circular histogram:
%fH = figure;
%ax = polaraxes(fH);
%ax.ThetaDir= 'clockwise';
obj3 = CircHist(sDist, nBins, 'parent', ax,'edges', -45:90:315);
fH.Visible = 'on';
obj3.colorAvgAng= [0 0 0.71];
obj3.colorBar=[0 0 0.71 ];

%att long
hold on


bin_one=round(score_attlong.*100);

sDist= [];
for hi=1:length(angle_deg)
sDist=[sDist ones(1,bin_one(hi))*angle_deg(hi)'];
end
    
%Plot the circular histogram:
%fH = figure;
%ax = polaraxes(fH);
%ax.ThetaDir= 'clockwise';
obj3 = CircHist(sDist, nBins, 'parent', ax,'edges', -45:90:315);
fH.Visible = 'on';
obj3.colorAvgAng= [0.1 0.1 0.1];
obj3.colorBar=[0.1 0.1 0.1 ];



hold on
ppp=polarplot(,subAx1,PRL(ui,1), 0.5,'ko', 'MarkerFaceColor', 'y')
ppp.MarkerSize = 12;

ax = gca;
d = ax.ThetaDir;
ax.ThetaDir = 'clockwise';
ax.ThetaZeroLocation = 'top';
name=theNames{theNamesList(ui)};
name=char(name);
name=name(1:2);
title([name ' Summary performance Accuracy '])
%rlim([0 60])
%rlim([0 60]) % to zoom in

%legend('VA','VA vector', 'CWrad', 'CWrad vector', 'CWtan', 'CWtan vector', 'short cue', 'short cue vector', 'long cue', 'long cue vector', 'PRL')

legend('VA', 'CWrad', 'CWtan', 'short cue',  'long cue', 'PRL')

print([name 'polar_summary_compare_norm'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%print([name 'polar_summary_compare_normzoom'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%    close all 
    
clear newanglesVA    newanglesCWrad  newanglesCWtan  newanglesshortAtt newangleslongtAtt    

end

