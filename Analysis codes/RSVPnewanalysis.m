
%for ui=1:length(mixtr)

%load ('C:\Users\BrainGameCenter\Documents\FLAP\PRL Induction procedures\data\testRSVPPixx_2_123_4_5_10_38.mat')
subj= baseName(71:72);
congone=setdiff(onef,ddd(1,:));
congtwo=setdiff(twof,ddd(2,:));
congthree=setdiff(threef,ddd(3,:));
congfour=setdiff(fourf,ddd(4,:));
congfive=setdiff(fivef,ddd(5,:));
congsix=setdiff(sixf,ddd(6,:));
incongone=ddd(1,:);
incongtwo=ddd(2,:);
incongthree=ddd(3,:);
incongfour=ddd(4,:);
incongfive=ddd(5,:);
incongsix=ddd(6,:);

% we need to add a +1 because the effect of the switch will be observed in
% the following trial (each trial has a 'current location index' in
% mixtr(trial,1) and a 'cued location index' in mixtr(trial, 2). Thus, the
% effect of the cue is on the following trial

targetarray=nan(length(mixtr),10);
for ui=1:length(respTime)
   % for ui=6
    
%     1: time
%     2: button pressed (if third column is 0) OR stimulus identity (if
%     third column is 1)
%     3: timing identifier (0 = button press; 1 = timing stimulus) 
%     4: stim type (1-4: stimulus ori, 5 blank, 6 cue)
    mixtr(ui,:);
    % RT of key press (responses)
    respTimeT=respTime(ui,1:totalresptrial(ui));
    % keys pressed
    respKeysT=respKeys(ui,1:totalresptrial(ui));
    
    % RT, key pressed, identified of response item
    respmat=[respTimeT' respKeysT' zeros(length(respTimeT),2)];
    % stimluis identity
    theans(ui,:)';
    %the ans
    %1-4: target
    %5: blank
    %6: cue
    %7: foil
    %8:post cue blank
    
    % timing of events:
    % 1:stim_start
    % 2: the ans (1-4: target ori, 5: foil, 6: cue, 7: blank, 8: post cue
    % blank)
    %3: identifier or stimulus item
    %4: stimulus identity (4: cue, 6: post cue interval)
    
        
    
    %stim type
    %1: target stays on screen until response
    %2: foil
    %3: target
    %4: cue
    %5 blank
    %6: post cue blank
    
    
    %stim_start: timing of the events
    % the ans: identity
    eventmat=[stim_start(ui,1:length(trialArray{ui}))' theans(ui,1:length(trialArray{ui}))' ones(length(stim_start(ui,1:length(trialArray{ui}))),1) trialArray{ui}'];
    stimulimat=eventmat(eventmat(:,2)<5,:);
   
    
The_event_mat{ui}=eventmat;
    %eventmat = [time - answer (type of response ) - event(1) or resp (0) - stimulus type]
    %
    matt=[ eventmat; respmat];
    matt2=sortrows(matt);
   % matt3=matt2;
    
    for i=2:length(matt2)
        matt2(i,1)=(matt2(i,1)-matt2(1,1));  
    end
    matt2(1,1)=0;
    trialMax{ui}=matt2;
    clear matt matt2 
 %% switch cost
 % find response to the first target (switch target)
  % respFirstTarget= trialMax{ui}(trialMax{ui}(:,3)==0 & trialMax{ui}(:,1)<0.95,:);
   respFirstTarget= trialMax{ui}(trialMax{ui}(:,3)==0 & trialMax{ui}(:,1)<0.95 & trialMax{ui}(:,1)>0,:);
 cheattrick{ui}= trialMax{ui}(trialMax{ui}(:,3)==0 & trialMax{ui}(:,1)== 0, :);

   % sus=trialMax{ui}
  % sus(sus(:,3)==0 & sus(:,1) < 0.95,:)
   % find RT response to the first target (switch target)  
  if isempty(respFirstTarget)==0
      respFirstTargetRT(ui)=respFirstTarget(1);
 % if the response is below 50ms, try next one
if respFirstTargetRT(ui)<0.08
          respFirstTargetRT(ui)=respFirstTarget(2);
end
pointerResp(ui)=find(trialMax{ui}(:,1)==respFirstTargetRT(ui));
%check if the response is correct
corrresp(ui)=trialMax{ui}(pointerResp(ui),2)==trialMax{ui}(1,2);
  else
           respFirstTargetRT(ui)=NaN; 
  end
%% sustained attention RT

    % responses to stimuli in the stream
%     for ii=1:
%     
% end
%analysis of button press x target number
TotalResp(ui)= length(respKeysT);
TotalTarget(ui)=nansum(trialArray{ui}==3)-1;
respratio(ui)=TotalResp(ui)/TotalTarget(ui);

% resp accuracy + RT 


foun=find(trialArray{ui}==3);
targetarray(ui,1:length(foun))=foun;
newtargetarray(ui,1:length(foun)-1)=targetarray(ui,targetarray(ui,:)>1);
%look for events around target presentation
for i=1:TotalTarget(ui)
    %time stamp of the target
   timestamptarget(i,:)=trialMax{ui}(newtargetarray(ui,i),:);
  % candidate responses (events 'response' that took place after
  % target presentation)
sustained_resp{ui,i}=trialMax{ui}(trialMax{ui}(:,1)>timestamptarget(i,1) & trialMax{ui}(:,3)==0, :);

%  trialMax{ui}(:,1)<timestamptarget(i,1) && trialMax{ui}(:,end)==3
end
end


if length(respFirstTargetRT)<length(mixtr)
    diffrnc=length(mixtr)-length(respFirstTargetRT);
respFirstTargetRT(length(respFirstTargetRT)+1:length(respFirstTargetRT)+diffrnc)=nan;
end


corrresp = double(corrresp);

if length(corrresp)<length(mixtr)
    diffrnc=length(mixtr)-length(corrresp);
corrresp(length(corrresp):length(corrresp)+diffrnc)=nan;
end

analysisMat=[mixtr corrresp' respFirstTargetRT'];



%% extract info per switch


%congruent
% 1 to 2
corrcongruentone=nansum(analysisMat(congone,4))/length(analysisMat(congone,:));
corrcongruentoneRT=nanmean(analysisMat(congone(analysisMat(congone,5)>0 & analysisMat(congone,4)>0),end));
% 1 to 3
corrcongruenttwo=nansum(analysisMat(congtwo,4))/length(analysisMat(congtwo,:));
corrcongruenttwoRT=nanmean(analysisMat(congtwo(analysisMat(congtwo,5)>0 & analysisMat(congtwo,4)>0),end));
% 2 to 1
corrcongruentthree=nansum(analysisMat(congthree,4))/length(analysisMat(congthree,:));
corrcongruentthreeRT=nanmean(analysisMat(congthree(analysisMat(congthree,5)>0 & analysisMat(congthree,4)>0),end));
% 2 to 3
corrcongruentfour=nansum(analysisMat(congfour,4))/length(analysisMat(congfour,:));
corrcongruentfourRT=nanmean(analysisMat(congfour(analysisMat(congfour,5)>0 & analysisMat(congfour,4)>0),end));
% 3 to 1
corrcongruentfive=nansum(analysisMat(congfive,4))/length(analysisMat(congfive,:));
corrcongruentfiveRT=nanmean(analysisMat(congfive(analysisMat(congfive,5)>0 & analysisMat(congfive,4)>0),end));
 % 3 to 2
corrcongruentsix=nansum(analysisMat(congsix,4))/length(analysisMat(congsix,:));
corrcongruentsixRT=nanmean(analysisMat(congsix(analysisMat(congsix,5)>0 & analysisMat(congsix,4)>0),end));


%incongruent

% 1 to 2 the stream is on 1, the target goes to 2 but the cue is on 3)
corrincongruentone=nansum(analysisMat(incongone,4))/length(analysisMat(incongone,:));
corrincongruentoneRT=nanmean(analysisMat(incongone(analysisMat(incongone,5)>0 & analysisMat(incongone,4)>0),end));
% 1 to 3 the stream is on 1, the target goes to 3 but the cue is on 2)
corrincongruenttwo=nansum(analysisMat(incongtwo,4))/length(analysisMat(incongtwo,:));
corrincongruenttwoRT=nanmean(analysisMat(incongtwo(analysisMat(incongtwo,5)>0 & analysisMat(incongtwo,4)>0),end));
% 2 to 1 (the stream is on 2, the target goes to 1 but the cue is on 3)
corrincongruentthree=nansum(analysisMat(incongthree,4))/length(analysisMat(incongthree,:));
corrincongruentthreeRT=nanmean(analysisMat(incongthree(analysisMat(incongthree,5)>0 & analysisMat(incongthree,4)>0),end));
% 2 to 3
corrincongruentfour=nansum(analysisMat(incongfour,4))/length(analysisMat(incongfour,:));
corrincongruentfourRT=nanmean(analysisMat(incongfour(analysisMat(incongfour,5)>0 & analysisMat(incongfour,4)>0),end));
% 3 to 1
corrincongruentfive=nansum(analysisMat(incongfive,4))/length(analysisMat(incongfive,:));
corrincongruentfiveRT=nanmean(analysisMat(incongfive(analysisMat(incongfive,5)>0 & analysisMat(incongfive,4)>0),end));
 % 3 to 2
corrincongruentsix=nansum(analysisMat(incongsix,4))/length(analysisMat(incongsix,:));
corrincongruentsixRT=nanmean(analysisMat(incongsix(analysisMat(incongsix,5)>0 & analysisMat(incongsix,4)>0),end));


p1=[-7.5 0];
p2=[ 7.5 0];
p3=[0 7.5];

dp = p2-p1;                         
dp2= p3-p1;
dp3= p3-p2;
figure
scatter(p1(1), p1(2))
hold on
scatter(p2(1), p2(2))
hold on
scatter(p3(1), p3(2))
xlim([-10 10])
ylim([-10 10])
set (gca,'YDir','reverse');

quiver(p1(1),p1(2),dp(1),dp(2),0)
hold on
quiver(p2(1)+1,p2(2),-7.5,+7.5,0)
hold on
quiver(p2(1),p2(2),dp3(1),dp3(2),0)
hold on
quiver(dp3(1)+1,dp3(2)-8,p2(1)+5,p2(2),0)
hold on
quiver(p3(1),p3(2),-dp2(1),-dp2(2),0)
hold on
quiver(p1(1)-1,p1(2),dp2(2),dp2(1),0)

hold on 
text(p1(1), p1(2)-1, '1', 'fontsize',20)
hold on 
text(p2(1), p2(2)-1, '2', 'fontsize',20)
hold on 
text(p3(1), p3(2)-1, '3', 'fontsize',20)

% results

textone=num2str(corrcongruentone);
texttwo=num2str(corrcongruenttwo);
textthree=num2str(corrcongruentthree);
textfour=num2str(corrcongruentfour);
textfive=num2str(corrcongruentfive);
textsix=num2str(corrcongruentsix);

text(-7, -7, ['1 to 2: ' textone(1:4) ' prop'], 'fontsize',20)
text(-7, -6, ['1 to 3: ' texttwo(1:4) ' prop'], 'fontsize',20)
text(-7, -5, ['2 to 1: ' textthree(1:4) ' prop'], 'fontsize',20)
text(-7, -4, ['2 to 3: ' textfour(1:4) ' prop'], 'fontsize',20)
text(-7, -3, ['3 to 1: ' textfive(1:4) ' prop'], 'fontsize',20)
text(-7, -2, ['3 to 2: ' textsix(1:4) ' prop'], 'fontsize',20)
title('RSVP congruent proportion')
print( [subj 'RSVP_percent'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

figure
scatter(p1(1), p1(2))
hold on
scatter(p2(1), p2(2))
hold on
scatter(p3(1), p3(2))
xlim([-10 10])
ylim([-10 10])
set (gca,'YDir','reverse');

quiver(p1(1),p1(2),dp(1),dp(2),0)
hold on
quiver(p2(1)+1,p2(2),-7.5,+7.5,0)
hold on
quiver(p2(1),p2(2),dp3(1),dp3(2),0)
hold on
quiver(dp3(1)+1,dp3(2)-8,p2(1)+5,p2(2),0)
hold on
quiver(p3(1),p3(2),-dp2(1),-dp2(2),0)
hold on
quiver(p1(1)-1,p1(2),dp2(2),dp2(1),0)

hold on 
text(p1(1), p1(2)-1, '1', 'fontsize',20)
hold on 
text(p2(1), p2(2)-1, '2', 'fontsize',20)
hold on 
text(p3(1), p3(2)-1, '3', 'fontsize',20)

% results
textone=num2str(corrcongruentoneRT);
texttwo=num2str(corrcongruenttwoRT);
textthree=num2str(corrcongruentthreeRT);
textfour=num2str(corrcongruentfourRT);
textfive=num2str(corrcongruentfiveRT);
textsix=num2str(corrcongruentsixRT);

text(-7, -7, ['1 to 2: ' textone(1:4) ' sec'], 'fontsize',20)
text(-7, -6, ['1 to 3: ' texttwo(1:4) ' sec'], 'fontsize',20)
text(-7, -5, ['2 to 1: ' textthree(1:4) ' sec'], 'fontsize',20)
text(-7, -4, ['2 to 3: ' textfour(1:4) ' sec'], 'fontsize',20)
text(-7, -3, ['3 to 1: ' textfive(1:4) ' sec'], 'fontsize',20)
text(-7, -2, ['3 to 2: ' textsix(1:4) ' sec'], 'fontsize',20)
title('RSVP congruent RT')

print( [subj 'RSVP_rt'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI




% difference

figure
scatter(p1(1), p1(2))
hold on
scatter(p2(1), p2(2))
hold on
scatter(p3(1), p3(2))
xlim([-10 10])
ylim([-10 10])
set (gca,'YDir','reverse');

quiver(p1(1),p1(2),dp(1),dp(2),0)
hold on
quiver(p2(1)+1,p2(2),-7.5,+7.5,0)
hold on
quiver(p2(1),p2(2),dp3(1),dp3(2),0)
hold on
quiver(dp3(1)+1,dp3(2)-8,p2(1)+5,p2(2),0)
hold on
quiver(p3(1),p3(2),-dp2(1),-dp2(2),0)
hold on
quiver(p1(1)-1,p1(2),dp2(2),dp2(1),0)

hold on 
text(p1(1), p1(2)-1, '1', 'fontsize',20)
hold on 
text(p2(1), p2(2)-1, '2', 'fontsize',20)
hold on 
text(p3(1), p3(2)-1, '3', 'fontsize',20)

% results

textone=num2str(corrincongruentone-corrcongruentone);
texttwo=num2str(corrincongruenttwo-corrcongruenttwo);
textthree=num2str(corrincongruentthree-corrcongruentthree);
textfour=num2str(corrincongruentfour-corrcongruentfour);
textfive=num2str(corrincongruentfive-corrcongruentfive);
textsix=num2str(corrincongruentsix-corrcongruentsix);

text(-7, -7, ['1 to 2: ' textone(1:4) ' prop diff'], 'fontsize',20)
text(-7, -6, ['1 to 3: ' texttwo(1:4) ' prop diff'], 'fontsize',20)
text(-7, -5, ['2 to 1: ' textthree(1:4) ' prop diff'], 'fontsize',20)
text(-7, -4, ['2 to 3: ' textfour(1:4) ' prop diff'], 'fontsize',20)
text(-7, -3, ['3 to 1: ' textfive(1:4) ' prop diff'], 'fontsize',20)
text(-7, -2, ['3 to 2: ' textsix(1:4) ' prop diff'], 'fontsize',20)
title('RSVP congruent proportion difference')

print( [subj 'RSVP_percent_diff'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

figure
scatter(p1(1), p1(2))
hold on
scatter(p2(1), p2(2))
hold on
scatter(p3(1), p3(2))
xlim([-10 10])
ylim([-10 10])
set (gca,'YDir','reverse');

quiver(p1(1),p1(2),dp(1),dp(2),0)
hold on
quiver(p2(1)+1,p2(2),-7.5,+7.5,0)
hold on
quiver(p2(1),p2(2),dp3(1),dp3(2),0)
hold on
quiver(dp3(1)+1,dp3(2)-8,p2(1)+5,p2(2),0)
hold on
quiver(p3(1),p3(2),-dp2(1),-dp2(2),0)
hold on
quiver(p1(1)-1,p1(2),dp2(2),dp2(1),0)

hold on 
text(p1(1), p1(2)-1, '1', 'fontsize',20)
hold on 
text(p2(1), p2(2)-1, '2', 'fontsize',20)
hold on 
text(p3(1), p3(2)-1, '3', 'fontsize',20)

% results
textone=num2str(corrcongruentoneRT-corrincongruentoneRT);
texttwo=num2str(corrcongruenttwoRT-corrincongruenttwoRT);
textthree=num2str(corrcongruentthreeRT-corrincongruentthreeRT);
textfour=num2str(corrcongruentfourRT-corrincongruentfourRT);
textfive=num2str(corrcongruentfiveRT-corrincongruentfiveRT);
textsix=num2str(corrcongruentsixRT-corrincongruentsixRT);

text(-7, -7, ['1 to 2: ' textone(1:4) ' sec diff'], 'fontsize',20)
text(-7, -6, ['1 to 3: ' texttwo(1:4) ' sec diff'], 'fontsize',20)
text(-7, -5, ['2 to 1: ' textthree(1:4) ' sec diff'], 'fontsize',20)
text(-7, -4, ['2 to 3: ' textfour(1:4) ' sec diff'], 'fontsize',20)
text(-7, -3, ['3 to 1: ' textfive(1:4) ' sec diff'], 'fontsize',20)
text(-7, -2, ['3 to 2: ' textsix(1:4) ' sec diff'], 'fontsize',20)
title('RSVP congruent RT difference')

print( [subj 'RSVP_rt_diff'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
