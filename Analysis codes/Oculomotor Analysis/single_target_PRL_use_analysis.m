


%single target analysis

clear all
addpath('/Users/marcellomaniglia/Documents/GitHub/FLAP/PRL Induction procedures/data')
load ('PD_DAY_1_PRL_induction_SingleTarget_Assigned_10 deg 22_2_9_11_11.mat')

subNum=['Sub ' baseName(8:10) ' Sess ' baseName(16) ' ' ];

name=['single target PRL use analysis' subNum ];


%PRLxpix
%PRLypix
firsttrial=1;
totaltrial=str2num(TrialNum(6:end));

totaltrial=1;

for i=firsttrial:totaltrial
    TrialNum = strcat('Trial',num2str(i));
        
    TargetCoordX(i)=EyeSummary.(TrialNum).TargetX;
    TargetCoordY(i)=EyeSummary.(TrialNum).TargetY;
    
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
            
            array{i,ii,io}=[X{ii,io}, Y{ii,io}; coordinatesEyeWhenTargetVisibleX{i, iuo} coordinatesEyeWhenTargetVisibleY{i, iuo}];
            
            
                        array{i,ii,io}=[X{ii,io}, Y{ii,io}; TargetCoordX(i) TargetCoordY(i)];

            
            
            
            d{i,ii,io} = pdist(array{i,ii,io},'euclidean');
            
            %PRLcoordinates{i,iuo,io}= [coordinatesEyeWhenTargetVisibleX{i, iuo}+PRLxpix(io) coordinatesEyeWhenTargetVisibleY{i, iuo}+PRLypix(io)];
        end
    end
    
       
    durationFixation{i}=fixationIndexesWithTargetEnd{i}-fixationIndexesWithTarget{i};
end
