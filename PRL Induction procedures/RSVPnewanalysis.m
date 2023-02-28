
%for ui=1:length(mixtr)
    for ui=1:1

 mixtr(trial,:)
% RT of responses
respTimeT=respTime(trial,1:totalresptrial(trial))
respKeysT=respKeys(trial,1:totalresptrial(trial))


respmat=[respTimeT' respKeysT' zeros(length(respTime(trial,:)),2)]
% strimluis identityy
theans(trial,:)';

% triming of events
stim_start(trial,:)';
eventmat=[stim_start(trial,:)' theans(trial,:)' ones(length(stim_start(trial,:)),1) trialArray{trial}'];
stimulimat=eventmat(eventmat(:,2)<5,:);


%[time - answer - event or resp - stimulus type]
%
matt=[ eventmat; respmat];
matt2=sortrows(matt)
matt3=matt2;

for i=2:length(matt2)
    matt2(i,1)=(matt2(i,1)-matt2(1,1))

end
matt2(1,1)=0;

    end