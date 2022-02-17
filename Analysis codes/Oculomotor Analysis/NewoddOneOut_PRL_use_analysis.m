

%MM 2/17/2022
%single target and odd one out analysis from PRL induction with 4 possible
%PRL locations



clear all

addpath('/Users/marcellomaniglia/Documents/GitHub/FLAP/PRL Induction procedures/data')

nameOffile = dir(['*.mat']);

load ('PD_DAY_1_PRL_induction_SingleTarget_Assigned_10 deg 22_2_9_11_11.mat')

load ('PD_DAY_1_PRL_induction_OddOneOutAssigned_10 deg 22_2_8_13_30.mat')

subNum=['Sub ' baseName(8:10) ' Sess ' baseName(16) ' ' ];

if baseName(31:33)== 'Odd'
    
    OddOrSingle=1;
    name=['odd one out PRL use analysis' subNum ];
    
elseif baseName(31:33)== 'Sin'
    OddOrSingle=2;
    name=['single target PRL use analysis' subNum ];
    
end





%PRLxpix
%PRLypix
firsttrial=1;
totaltrial=str2num(TrialNum(6:end))-1;
%totaltrial=2;
%totaltrial=1;

for i=firsttrial:totaltrial
    
    counterValidFixation=0;
    countlongfixation=0;
    TrialNum = strcat('Trial',num2str(i));
    if exist('EyeSummary.(TrialNum).FixationIndices(end,2)')==0
        EyeSummary.(TrialNum).FixationIndices(end,2)=length(EyeSummary.(TrialNum).EyeData);
    end
    TargetCoordX(i)=(wRect(3)/2)+EyeSummary.(TrialNum).TargetX;
    TargetCoordY(i)=(wRect(4)/2)+EyeSummary.(TrialNum).TargetY;
    
    
    if OddOrSingle==1
        DistoneCoordX(i)=(EyeSummary.(TrialNum).Elements{1}(3)+EyeSummary.(TrialNum).Elements{1}(1))/2;
        DistoneCoordY(i)=(EyeSummary.(TrialNum).Elements{1}(4)+EyeSummary.(TrialNum).Elements{1}(2))/2;
        
        DisttwoCoordX(i)=(EyeSummary.(TrialNum).Elements{2}(3)+EyeSummary.(TrialNum).Elements{2}(1))/2;
        DisttwoCoordY(i)=(EyeSummary.(TrialNum).Elements{2}(4)+EyeSummary.(TrialNum).Elements{2}(2))/2;
    end
    finalTargetFrame(i)=EyeSummary.(TrialNum).Target.counter;
    %  score_all_fix{i}=EyeSummary.(TrialNum).Target.FixInd;
    
    score_all_fix{i}=EyeSummary.(TrialNum).Target.FixInd(EyeSummary.(TrialNum).Target.FixInd>0);
    
    %     tempscorefix=score_all_fix{i};
    %     score_all_fix_end{i}=tempscorefix(1:finalTargetFrame(i));
    %     score_fix(i)=length(score_all_fix_end{i})/4;
    %     fixationIndexesWithTarget{i}=unique(score_all_fix_end{i});
    ffixationIndexesWithTarget{i}=unique(score_all_fix{i});
    
    fixationIndexesWithTarget{i}=ffixationIndexesWithTarget{i};
    % fixationIndexesWithTarget{i}=fixationIndexesWithTarget{i}(ffixationIndexesWithTarget{i}<=score_all_fix{i}(end));
    fixationIndexesWithTarget{i}=fixationIndexesWithTarget{i}(ffixationIndexesWithTarget{i}<=EyeSummary.(TrialNum).FixationIndices(end));
    
    for oy=1:length(fixationIndexesWithTarget{i})
        if sum(sum((EyeSummary.(TrialNum).FixationIndices(:,1)==fixationIndexesWithTarget{i}(oy))))>0
            counterValidFixation=counterValidFixation+1;
            tempfirstFix=EyeSummary.(TrialNum).FixationIndices(EyeSummary.(TrialNum).FixationIndices(:,1)==fixationIndexesWithTarget{i}(oy),1);
            fixationIndexesWithTargetUpdated{i}(counterValidFixation)=tempfirstFix(1);
            clear tempfirstFix
            templastFix=EyeSummary.(TrialNum).FixationIndices(EyeSummary.(TrialNum).FixationIndices(:,1)==fixationIndexesWithTarget{i}(oy),2);
            
            fixationIndexesWithTargetEnd{i}(counterValidFixation)=templastFix(templastFix>0);
            clear templastFix
            
        end
    end
    
    
    for iuo=1:length(fixationIndexesWithTargetEnd{i})
        
        if fixationIndexesWithTargetEnd{i}(iuo)-fixationIndexesWithTargetUpdated{i}(iuo)>5
            countlongfixation= countlongfixation+1;
            
            fixationIndexesWithTargetUpdated_long{i}(countlongfixation)=fixationIndexesWithTargetUpdated{i}(iuo);
            fixationIndexesWithTargetEnd_long{i}(countlongfixation)=fixationIndexesWithTargetEnd{i}(iuo);
        end
        
    end
    
    
    
    if countlongfixation>0
        for iuo=1:length(fixationIndexesWithTargetUpdated_long{i})
            
            coordinatesEyeWhenTargetVisible{i, iuo}=EyeSummary.(TrialNum).EyeData(fixationIndexesWithTargetEnd_long{i}(iuo),:);
            coordinatesEyeWhenTargetVisibleX{i, iuo}=coordinatesEyeWhenTargetVisible{i, iuo}(1);
            coordinatesEyeWhenTargetVisibleY{i, iuo}=coordinatesEyeWhenTargetVisible{i, iuo}(2);
            
            for io=1:length(PRLxpix)
                PRLcoordinates{i,iuo,io}= [coordinatesEyeWhenTargetVisibleX{i, iuo}+PRLxpix(io) coordinatesEyeWhenTargetVisibleY{i, iuo}+PRLypix(io)];
            end
        end
        
        %compare distances from PRL to target
        for ii=1:length(fixationIndexesWithTargetUpdated_long{i})
            for io=1:length(PRLxpix)
                X{ii, io}=PRLcoordinates{i,ii,io}(1);
                Y{ii, io}=PRLcoordinates{i,ii,io}(2);
                %    array{i,ii,io}=[X{ii,io}, Y{ii,io}; coordinatesEyeWhenTargetVisibleX{i, iuo} coordinatesEyeWhenTargetVisibleY{i, iuo}];
                array{i,ii,io}=[X{ii,io}, Y{ii,io}; TargetCoordX(i) TargetCoordY(i)];
                d{i,ii,io} = pdist(array{i,ii,io},'euclidean');
                %distractor
                if OddOrSingle==1
                    array2{i,ii,io}=[X{ii,io}, Y{ii,io}; DistoneCoordX(i) DistoneCoordY(i)];
                    d2{i,ii,io} = pdist(array2{i,ii,io},'euclidean');
                    
                    array3{i,ii,io}=[X{ii,io}, Y{ii,io}; DisttwoCoordX(i) DisttwoCoordY(i)];
                    
                    d3{i,ii,io} = pdist(array3{i,ii,io},'euclidean');
                    
                end
                
                %PRLcoordinates{i,iuo,io}= [coordinatesEyeWhenTargetVisibleX{i, iuo}+PRLxpix(io) coordinatesEyeWhenTargetVisibleY{i, iuo}+PRLypix(io)];
            end
        end
        
        durationFixation{i}=fixationIndexesWithTargetEnd_long{i}-fixationIndexesWithTargetUpdated_long{i};
    end
    
    for ii=1:length(fixationIndexesWithTargetUpdated_long{i})
        
        duration_for_fixation(ii)=durationFixation{i}(ii);
        
        targetNearest(1,ii,:)=[d{i,ii,:}]==min([d{i,ii,:}]);
        
        if OddOrSingle==1
            distoneNearest(1,ii,:)=[d2{i,ii,:}]==min([d2{i,ii,:}]);
            disttwoNearest(1,ii,:)=[d3{i,ii,:}]==min([d3{i,ii,:}]);
        end
        
        
        
    end
    
    tgtnear{i}=targetNearest;
    drts{i}=duration_for_fixation;
    framePerPRLtgt{i}=sum(targetNearest.*duration_for_fixation);
    framePerPRLDistone{i}=sum(distoneNearest.*duration_for_fixation);
    framePerPRLDisttwo{i}=sum(disttwoNearest.*duration_for_fixation);
    
    
    clear targetNearest distoneNearest disttwoNearest duration_for_fixation
end
