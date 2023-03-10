
%for ui=1:length(mixtr)
for ui=1
    
    mixtr(ui,:)
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
    %5: foil
    %6: cue
    %7: blank
    %8:post cue blank
    
    % timing of events:
    % 1:timing
    % 2: the ans (1-4: target ori, 5: foil, 6: cue, 7: blank, 8: post cue
    % blank)
    %3: identifier or stimulus item
    %4: stimulus identity
    
    %stim type
    %1: target stays on screen until response
    %2: foil
    %3: target
    %4: cue
    %5 blank
    %6: post cue blank
    
    %the ans
    %1-4: target
    %5: blank
    %6: cue
    %7: foil
    %6:post cue blank
    
    eventmat=[stim_start(ui,1:length(trialArray{ui}))' theans(ui,1:length(trialArray{ui}))' ones(length(stim_start(ui,1:length(trialArray{ui}))),1) trialArray{ui}'];
    stimulimat=eventmat(eventmat(:,2)<5,:);
    
    
    %[time - answer - event or resp - stimulus type]
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
   respFirstTarget= trialMax{ui}(trialMax{ui}(:,3)==0 & trialMax{ui}(:,1)<0.95,:);
   % find RT response to the first target (switch target)  
   respFirstTargetRT=respFirstTarget(1);

pointerResp=find(trialMax{ui}(:,1)==respFirstTargetRT);
%check if the response is correct
corrresp=trialMax{ui}(pointerResp,2)==trialMax{ui}(1,2);

%% sustained attention RT

    % responses to stimuli in the stream
%     for ii=1:
%     
% end
%analysis of button press x target number
TotalResp(ui)= length(respKeysT);
TotalTarget(ui)=sum(trialArray{ui}==3);
respratio(ui)=TotalResp(ui)/TotalTarget(ui);

% resp accuracy + RT 
targetarray(ui,:)=find(trialArray{ui}==3);
newtargetarray(ui,:)=targetarray(ui,targetarray(ui,:)>1)
%look for events around target presentation
for i=1:TotalTarget(i)
    %time stamp of the target
   timestamptarget(i,:)=trialMax{ui}(newtargetarray(ui,i),:);
  % candidate responses (events 'response' that took place after
  % target presentation)
trialMax{ui}(trialMax{ui}(:,1)>timestamptarget(i,1) & trialMax{ui}(:,3)==0, :)

%  trialMax{ui}(:,1)<timestamptarget(i,1) && trialMax{ui}(:,end)==3
end
end