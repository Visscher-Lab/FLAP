


%odd one out target analysis

clear all
addpath('/Users/marcellomaniglia/Documents/GitHub/FLAP/PRL Induction procedures/data')
load ('PD_DAY_1_PRL_induction_OddOneOutAssigned_10 deg 22_2_8_13_30.mat')

subNum=['Sub ' baseName(8:10) ' Sess ' baseName(16) ' ' ];

name=['odd one out PRL use analysis' subNum ];





%PRLxpix
%PRLypix
firsttrial=1;
totaltrial=str2num(TrialNum(6:end))-1;

%totaltrial=1;

coord=[PRLx' PRLy'];


for ui=1:length(PRLx)
text(PRLx(ui), PRLy(ui), num2str(ui))
end

xlim([-10 10]); ylim([-10 10])
                set (gca,'YDir','reverse')

                
for i=firsttrial:totaltrial
    TrialNum = strcat('Trial',num2str(i));
    
    % clear tempo tempo2
    targetFrameCounter(i)=EyeSummary.(TrialNum).Target.counter;
    tempo{i}=size(EyeSummary.(TrialNum).Target.visible);
    
    countTarget(i)=tempo{i}(2);
    
    tempo2{i}=size(EyeSummary.(TrialNum).Target.Disvisible);
    
    countDistr(i)=tempo2{i}(3);
    
    
    trialTarget{i}=EyeSummary.(TrialNum).Target.visible==1;
    
    PRLonetarget{i}=trialTarget{i}(1,:);
    PRLtwotarget{i}=trialTarget{i}(2,:);
    PRLthreetarget{i}=trialTarget{i}(3,:);
    PRLfourtarget{i}=trialTarget{i}(4,:);
    
    
    totalPRLonetarget{i}=sum(PRLonetarget{i});
    totalPRLtwotarget{i}=sum(PRLtwotarget{i});
    totalPRLthreetarget{i}=sum(PRLthreetarget{i});
    totalPRLfourtarget{i}=sum(PRLfourtarget{i});
    
    trialdistTarget{i}=EyeSummary.(TrialNum).Target.Disvisible==1;
    
    PRLoneDist{i}=trialdistTarget{1}(:,1,:);
    PRLtwoDist{i}=trialdistTarget{1}(:,2,:);
    PRLthreeDist{i}=trialdistTarget{1}(:,3,:);
    PRLfourDist{i}=trialdistTarget{1}(:,4,:);
    
    
    totalPRLoneDist{i}=sum(sum(PRLoneDist{i}));
        totalPRLtwoDist{i}=sum(sum(PRLtwoDist{i}));
        totalPRLthreeDist{i}=sum(sum(PRLthreeDist{i}));
            totalPRLfourDist{i}=sum(sum(PRLfourDist{i}));
end






matr=[targetFrameCounter' countTarget' countDistr'];

for i=firsttrial:totaltrial
    TrialNum = strcat('Trial',num2str(i));
        if exist('EyeSummary.(TrialNum).FixationIndices(end,2)')==0
        EyeSummary.(TrialNum).FixationIndices(end,2)=length(EyeSummary.(TrialNum).EyeData);
        end
    TargetCoordX(i)=(wRect(3)/2)+EyeSummary.(TrialNum).TargetX;
    TargetCoordY(i)=(wRect(4)/2)+EyeSummary.(TrialNum).TargetY;
    
    finalTargetFrame(i)=EyeSummary.(TrialNum).Target.counter;
    score_all_fix{i}=EyeSummary.(TrialNum).Target.FixInd;
    tempscorefix=score_all_fix{i};
    score_all_fix_end{i}=tempscorefix(1:finalTargetFrame(i));
    score_fix(i)=length(score_all_fix_end{i})/4;
    
    fixationIndexesWithTarget{i}=unique(score_all_fix_end{i});
    
    
    for oy=1:length(fixationIndexesWithTarget{i})
        fixationIndexesWithTargetEnd{i}(oy)=EyeSummary.(TrialNum).FixationIndices(EyeSummary.(TrialNum).FixationIndices(:,1)==fixationIndexesWithTarget{i}(oy),2);
    end
    
    for iuo=1:length(fixationIndexesWithTarget{i})
        
        coordinatesEyeWhenTargetVisible{i, iuo}=EyeSummary.(TrialNum).EyeData(fixationIndexesWithTarget{i}(iuo),:);
        coordinatesEyeWhenTargetVisibleX{i, iuo}=coordinatesEyeWhenTargetVisible{i, iuo}(1);
        coordinatesEyeWhenTargetVisibleY{i, iuo}=coordinatesEyeWhenTargetVisible{i, iuo}(2);
        
        for io=1:length(PRLxpix)
            PRLcoordinates{i,iuo,io}= [coordinatesEyeWhenTargetVisibleX{i, iuo}+PRLxpix(io) coordinatesEyeWhenTargetVisibleY{i, iuo}+PRLypix(io)];
        end
    end
    
    
    %compare distances from PRL to target
    for ii=1:length(fixationIndexesWithTarget{i})
        for io=1:length(PRLxpix)
            X{ii, io}=PRLcoordinates{i,ii,io}(1);
            Y{ii, io}=PRLcoordinates{i,ii,io}(2);
            %    array{i,ii,io}=[X{ii,io}, Y{ii,io}; coordinatesEyeWhenTargetVisibleX{i, iuo} coordinatesEyeWhenTargetVisibleY{i, iuo}];
            array{i,ii,io}=[X{ii,io}, Y{ii,io}; TargetCoordX(i) TargetCoordY(i)];
            d{i,ii,io} = pdist(array{i,ii,io},'euclidean');
            
            %PRLcoordinates{i,iuo,io}= [coordinatesEyeWhenTargetVisibleX{i, iuo}+PRLxpix(io) coordinatesEyeWhenTargetVisibleY{i, iuo}+PRLypix(io)];
        end
    end
    
    
    durationFixation{i}=fixationIndexesWithTargetEnd{i}-fixationIndexesWithTarget{i};
end


for i=firsttrial:totaltrial
for ii=1:length(fixationIndexesWithTarget{i})

   aaa(i,ii,:)=[d{i,ii,:}]==min([d{i,ii,:}]);
   
   duration_for_fixation(i,ii)=durationFixation{i}(ii)

end

end
