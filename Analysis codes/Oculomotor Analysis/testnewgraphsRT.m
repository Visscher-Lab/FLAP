% %rng default
% sDist = mod(rad2deg(circ_vmrnd(pi/2, 2, 100)), 360); % generate sample, convert to deg
% 
% 
% angle_deg = [0  90   180  180+90];
% score_VA=[0.5000    0.1000    0.9000    0.5000];
% bin_one=round(score_VA.*100);
% %sDist= angle_deg.*bin_one
% 
% sDist= [];
% for hi=1:length(angle_deg)
% sDist=[sDist ones(1,bin_one(hi))*angle_deg(hi)'];
% end
% 
% 
% nBins = 4; % number of bins, makes bin size of 10 deg
% %Plot the circular histogram:
% fH = figure;
% ax = polaraxes(fH);
% ax.ThetaDir= 'clockwise';
% obj1 = CircHist(sDist, nBins, 'parent', ax,'edges', -45:90:315);
% %obj1 = CircHist(sDist, nBins, 'parent', ax,'edges', -45:90:360);
% 
% fH.Visible = 'on';
close all
clear all
addpath([cd '/github_repo']);

load FLAP_pilot.mat

theoriginalPRLs=thePRLs;
    thePRLs=-theoriginalPRLs;

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
 newsubj=subjRT{ui}(1:3,:);
  allsubjnorm=[allsubjnorm ;newsubj];
  end 

  %normalize VA and crowding
  allsubjnorm=mat2gray(allsubjnorm);
    allsubjnorm=1-allsubjnorm;
normalizedVA=allsubjnorm(1:3:end,:);
normalizedCWrad=allsubjnorm(2:3:end,:);
normalizedCWtan=allsubjnorm(3:3:end,:);

%normalize attention score
% extract attention data
allsubjprenormAtt=[];
  for ui=1:subjs
newsubj=subjRT{ui}(4:5,:);
  allsubjprenormAtt=[allsubjprenormAtt ;newsubj];
  end 
  
  allsubjnormAtt=mat2gray(allsubjprenormAtt);
  
%more 'normalization': now high is better (before low was better)  
  allsubjnormAtt=1-allsubjnormAtt;
normalizedshortAtt=allsubjnormAtt(1:2:end,:);
normalizedlongAtt=allsubjnormAtt(2:2:end,:);


for ui=1:subjs

%    for ui=1

        
        lenom=theNames{theNamesList(ui)};
        lenom=cell2mat(lenom);
    lenom=lenom(1:3);
    score_VA = normalizedVA(ui,:);
    score_CWrad = normalizedCWrad(ui,:);   
        score_CWtan = normalizedCWtan(ui,:);  
score_attshort=normalizedshortAtt(ui,:);   
score_attlong=normalizedlongAtt(ui,:);   

% bin_one=score_VA;
% bin_two=score_CWrad;
% bin_three=score_CWtan;
% bin_four=score_attshort;
% bin_five=score_attshort;

nBins = 4; % Use different number of bins, resulting in 20 deg bins
fH = figure('Visible', 'on');
subAx1 = subplot(1, 2, 1, polaraxes);
if ui== 3  %|| ui== 6 %|| 
obj1 = CircHist(score_VA, nBins, 'parent', subAx1,'edges', -45:90:315,'areAxialData', true, 'dataType', 'histogram');
else
    obj1 = CircHist(score_VA, nBins, 'parent', subAx1,'edges', -45:90:315,'areAxialData', false, 'dataType', 'histogram');
end
obj1.colorAvgAng= [.71 0.4 0.4];
obj1.colorBar=[.71 0 0 ];
obj1.baseLineOffset=10;

thetaticks(obj1.polarAxs, 0:90:360);
obj1.polarAxs.ThetaAxis.MinorTickValues = [];

% Make rho-axes equal for both diagrams
maxRho=1;

%maxRho = max([max(rlim(subAx1))])%, max(rlim(subAx3)), max(rlim(subAx4))]);
newLimits = [min(rlim(subAx1)), maxRho];
obj1.setRLim(newLimits);

if PRL(ui,2)>0
dio=polarplot(subAx1,(PRL(ui,1)-deg2rad(90)), -0.5,'ko', 'MarkerFaceColor', 'y')
elseif PRL(ui,2)<0
    dio=polarplot(subAx1,(PRL(ui,1)-deg2rad(90)), 0.5,'ko', 'MarkerFaceColor', 'y')
end

if obj1.avgAng>0
title(subAx1, ['Visual acuity avgAng = ' num2str(obj1.avgAng)])
elseif obj1.avgAng>0
title(subAx1, ['Visual acuity avgAng = ' num2str(360-obj1.avgAng)])  
end
subAx1.ThetaDir= 'clockwise';
 subAx1.ThetaZeroLocation = 'top'; 
 
% Adjust figure-window size
drawnow
%fH.Position([3,4]) = [16*70,9*70]; % Figure dimensions

fH.Position([3,4]) = [850,500]; % Figure dimensions


print([ lenom 'VA_polar_angle_rt'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

 
 fH2 = figure('Visible', 'on');

subAx2 = subplot(1, 2, 1, polaraxes);
subAx3 = subplot(1, 2, 2, polaraxes);
if ui== 1 || ui ==2 || ui ==3 || ui ==5 || ui ==7 || ui ==8
obj2 = CircHist(score_CWrad, nBins, 'parent', subAx2, 'edges', -45:90:315,'areAxialData', true, 'dataType', 'histogram');
else
    obj2 = CircHist(score_CWrad, nBins, 'parent', subAx2, 'edges', -45:90:315,'areAxialData', false, 'dataType', 'histogram');
end

if ui== 3 || ui ==7
obj3 = CircHist(score_CWtan, nBins, 'parent', subAx3, 'edges', -45:90:315,'areAxialData', true, 'dataType', 'histogram');
else
obj3 = CircHist(score_CWtan, nBins, 'parent', subAx3, 'edges', -45:90:315,'areAxialData', false, 'dataType', 'histogram');
end

obj2.colorAvgAng= [0.3 0.73 0.3];
obj2.colorBar=[0 0.73 0 ];
obj2.baseLineOffset=10;


obj3.colorAvgAng= [0.532 0.532 .532];
obj3.colorBar=[0.32 0.32 .32 ];
obj3.baseLineOffset=10;

thetaticks(obj2.polarAxs, 0:90:360);
obj2.polarAxs.ThetaAxis.MinorTickValues = [];
thetaticks(obj3.polarAxs, 0:90:360);
obj3.polarAxs.ThetaAxis.MinorTickValues = [];


% Make rho-axes equal for both diagrams
%maxRho = max([max(rlim(subAx2)), max(rlim(subAx3))])%, max(rlim(subAx3)), max(rlim(subAx4))]);
newLimits = [min(rlim(subAx2)), maxRho];

obj2.setRLim(newLimits);
obj3.setRLim(newLimits);

if PRL(ui,2)>0
dio=polarplot(subAx3,(PRL(ui,1)-deg2rad(90)), -0.5,'ko', 'MarkerFaceColor', 'y')
dio=polarplot(subAx2,(PRL(ui,1)-deg2rad(90)), -0.5,'ko', 'MarkerFaceColor', 'y')
elseif PRL(ui,2)<0
    dio=polarplot(subAx3,(PRL(ui,1)-deg2rad(90)), 0.5,'ko', 'MarkerFaceColor', 'y')
    dio=polarplot(subAx2,(PRL(ui,1)-deg2rad(90)), 0.5,'ko', 'MarkerFaceColor', 'y')
end

if obj2.avgAng>0
title(subAx2, ['Crowding rad avgAng = ' num2str(obj2.avgAng)])
elseif obj2.avgAng<0
    title(subAx2, ['Crowding rad avgAng = ' num2str(360-obj2.avgAng)])

end

if obj3.avgAng>0
title(subAx3, ['Crowding tan avgAng = ' num2str(obj3.avgAng)])
elseif obj3.avgAng<0
title(subAx3, ['Crowding tan avgAng = ' num2str(360-obj3.avgAng)])
end

subAx2.ThetaDir= 'clockwise';
subAx3.ThetaDir= 'clockwise';

 subAx2.ThetaZeroLocation = 'top';
 subAx3.ThetaZeroLocation = 'top';
 
 fH2.Position([3,4]) = [850,500]; % Figure dimensions

%polarplot(PRL(ui,1), subAx1)
%obj1.MarkerSize = 12;
% dio=polarplot(subAx1,PRL(ui,1), subAx1)
%dio.MarkerSize = 12;
 %dio.Marker= 'o';
 %dio.MarkerFaceColor= 'y';
  %dio.MarkerColor= 'k'
% dio.MarkerFaceColor= 'k';

print([ lenom 'Crowding_polar_angle_rt'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI



 fH3 = figure('Visible', 'on');

subAx4 = subplot(1, 2, 1, polaraxes);
subAx5 = subplot(1, 2, 2, polaraxes);

if ui ==4  %|| ui ==
obj4 = CircHist(score_attshort, nBins, 'parent', subAx4, 'edges', -45:90:315,'areAxialData', true, 'dataType', 'histogram');
else
    obj4 = CircHist(score_attshort, nBins, 'parent', subAx4, 'edges', -45:90:315,'areAxialData', false, 'dataType', 'histogram');
end

if ui == 8 || ui == 9
obj5 = CircHist(score_attlong, nBins, 'parent', subAx5, 'edges', -45:90:315,'areAxialData', true, 'dataType', 'histogram');
else
    obj5 = CircHist(score_attlong, nBins, 'parent', subAx5, 'edges', -45:90:315,'areAxialData', false, 'dataType', 'histogram');
end

obj4.colorAvgAng= [235/255,10/255,27/255];
obj4.colorBar=[1,20/255,147/255];
obj4.baseLineOffset=10;


obj5.colorAvgAng= [0.4 0.4 .71];
obj5.colorBar=[0 0 .71 ];
obj5.baseLineOffset=10;

thetaticks(obj4.polarAxs, 0:90:360);
obj4.polarAxs.ThetaAxis.MinorTickValues = [];
thetaticks(obj5.polarAxs, 0:90:360);
obj5.polarAxs.ThetaAxis.MinorTickValues = [];


% Make rho-axes equal for both diagrams
%maxRho = max([max(rlim(subAx4)), max(rlim(subAx5))])%, max(rlim(subAx3)), max(rlim(subAx4))]);
newLimits = [min(rlim(subAx4)), maxRho];

obj4.setRLim(newLimits);
obj5.setRLim(newLimits);

if PRL(ui,2)>0
dio=polarplot(subAx4,(PRL(ui,1)-deg2rad(90)), -0.5,'ko', 'MarkerFaceColor', 'y')
dio=polarplot(subAx5,(PRL(ui,1)-deg2rad(90)), -0.5,'ko', 'MarkerFaceColor', 'y')
elseif PRL(ui,2)<0
    dio=polarplot(subAx4,(PRL(ui,1)-deg2rad(90)), 0.5,'ko', 'MarkerFaceColor', 'y')
    dio=polarplot(subAx5,(PRL(ui,1)-deg2rad(90)), 0.5,'ko', 'MarkerFaceColor', 'y')
end

title(subAx4, ['Short cue avgAng = ' num2str(obj4.avgAng)])
title(subAx5, ['Long cue avgAng = ' num2str(obj5.avgAng)])
subAx4.ThetaDir= 'clockwise';
subAx5.ThetaDir= 'clockwise';

 subAx4.ThetaZeroLocation = 'top';
 subAx5.ThetaZeroLocation = 'top';
 
 fH3.Position([3,4]) = [850,500]; % Figure dimensions

%polarplot(PRL(ui,1), subAx1)
%obj1.MarkerSize = 12;
% dio=polarplot(subAx1,PRL(ui,1), subAx1)
%dio.MarkerSize = 12;
 %dio.Marker= 'o';
 %dio.MarkerFaceColor= 'y';
  %dio.MarkerColor= 'k'
% dio.MarkerFaceColor= 'k';

print([ lenom 'Attention_polar_angle_rt'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

PRL_avAng(ui)=rad2deg(PRL(ui,1)-deg2rad(90));
VA_avgAngAcc(ui)=obj1.avgAng;
CW_rad_avAngAcc(ui)=obj2.avgAng;
CW_tan_avAngAcc(ui)=obj3.avgAng;
Att_short_avAngAcc(ui)=obj4.avgAng;
Att_long_avAngAcc(ui)=obj5.avgAng;


close all
end
    

summary_results=[
    PRL_avAng;
VA_avgAngAcc;
CW_rad_avAngAcc;
CW_tan_avAngAcc;
Att_short_avAngAcc;
Att_long_avAngAcc
]';