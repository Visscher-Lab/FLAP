stimpresent=1;

if  stimpresent>0
    % here to force fixations with the PRL
    
    if round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)<=size(circlePixelsPRL,1) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix)<=size(circlePixelsPRL,2) ...
            &&  round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)> 0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix)> 0
        
        
        codey=round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix);
        codex=round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix);
        activePRLT =1;
    else
        codey= 1; %round(1025/2); %
        codex= 1; %round(1281/2);%
        activePRLT = 0;
        
    end
    %    end
    
    if  stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)<wRect(4) && round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)+PRLxpix))<wRect(3) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)+PRLxpix))>0
        % 1:the stimulus should be presented, 2:the eye position is within
        %the limits of the screen
        uncheckerframe(length(EyeData))=1;
        othercounter(length(EyeData))=1;
        if   circlePixelsPRL(codey, codex)<0.81
            % 1:the stimulus should be presented, 2:the eye position is within
            %the limits of the screen but the stimulus is outside the
            % PRL(s)
                    othercounter(length(EyeData))=1;

            blankcounter=blankcounter+1;
            if  blankcounter==1
                startBlankCounter=GetSecs;
            end
            if  blankcounter==blankframeallowed
                stopBlankCounter=GetSecs;
            end
            
            if blankcounter>blankframeallowed
                if trainingType==3
                    Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                elseif trainingType==4
                    Screen('FillOval', w, fixdotcolor2, imageRect_offs_dot);
                    
                end
                Fixationstatus(length(EyeData))=91;
                            checkerframe(length(EyeData))=1;
            elseif blankcounter<=blankframeallowed
                checkerframe(length(EyeData))=11;
                countertarget=countertarget+1;
                counterflicker=counterflicker+1;
                framefix(countertarget)=length(EyeData(:,1));
                timefix(countertarget)=GetSecs;
            end
            circlefix=0;
            
        else
            %if we have the EyeCode element, which
            %tracks the frames for which we have eye position recorded (even if the eye position is missing)
                    othercounter(length(EyeData))=1;
if  exist('EyeCode','var')
                if length(EyeCode)>6 %&& circlefix>6
                    circlefix=circlefix+1;
                    %if we have at least 6 frames
                    %within this trial
                    % if  EyeCode(end-1)~=0 && EyeCode(end)~=0
                    if sum(EyeCode(end-6:end))~=0
                        %if we don't have 6 consecutive frames with no eye movement (aka, with
                        %fixation)
                        
                        blankcounter=blankcounter+1;
                        
                        if blankcounter>blankframeallowed
                if trainingType==3
                    Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                elseif trainingType==4
                    Screen('FillOval', w, fixdotcolor2, imageRect_offs_dot);
                    
                end
                Fixationstatus(length(EyeData))=92;
                                                    checkerframe(length(EyeData))=2;
                        elseif blankcounter<=blankframeallowed
                            
                            checkerframe(length(EyeData))=21;
                            countertarget=countertarget+1;
                            counterflicker=counterflicker+1;
                            framefix(countertarget)=length(EyeData(:,1));
                            timefix(countertarget)=GetSecs;
                        end
                    elseif sum(EyeCode(end-flickerframeallowed:end))==0
                        %If we have at least 5
                        %consecutive frames with
                        %fixation
                        %HERE WE SHOW THE TARGET
                        checkerframe(length(EyeData))=3;
                        countertarget=countertarget+1;
                        counterflicker=counterflicker+1;
                        framefix(countertarget)=length(EyeData(:,1));
                        timefix(countertarget)=GetSecs;
                        if exist('FixIndex','var')
                            fixind(countertarget)=FixIndex(end,1);
                        end
                        showtarget=100;
                        blankcounter=0;
                        timeprevioustarget(countertarget)=GetSecs;
                        Fixationstatus(length(EyeData))=11;
                        
                        % circlefix=circlefix+1;
                    end
                elseif length(EyeCode)<=5 %&& circlefix<=6
                    %if we don't have at least 5 frames
                    %per trial
                    
                    blankcounter=blankcounter+1;
                    
                    if blankcounter>blankframeallowed
                if trainingType==3
                    Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                elseif trainingType==4
                    Screen('FillOval', w, fixdotcolor2, imageRect_offs_dot);
                    
                end
                Fixationstatus(length(EyeData))=93;
                                            checkerframe(length(EyeData))=4;
                    elseif blankcounter<=blankframeallowed
                        
                        checkerframe(length(EyeData))=31;
                        countertarget=countertarget+1;
                        counterflicker=counterflicker+1;
                        framefix(countertarget)=length(EyeData(:,1));
                        timefix(countertarget)=GetSecs;
                    end
                    circlefix=circlefix+1;
                    %                 elseif length(EyeCode)>5 %&& circlefix<=6
                    %                     checkerframe(length(EyeData))=6;
                    %
                    %                     blankcounter=blankcounter+1;
                    %
                    %                     if blankcounter>blankframeallowed
                    %                         Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                    %                         Fixationstatus(length(EyeData))=94;
                    %
                    %                     end
                    %                     circlefix=circlefix+1;
                end
            end
        end
        
        
    elseif stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)+PRLxpix))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)+PRLxpix))<0 %...
        % if eyes looking outside of the screen area
        checkerframe(length(EyeData))=5;
        blankcounter=blankcounter+1;
        uncheckerframe(length(EyeData))=2;
                othercounter(length(EyeData))=2;

        if blankcounter>blankframeallowed
                if trainingType==3
                    Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                elseif trainingType==4
                    Screen('FillOval', w, fixdotcolor2, imageRect_offs_dot);
                    
                end
                Fixationstatus(length(EyeData))=95;
        elseif blankcounter<=blankframeallowed
            
            checkerframe(length(EyeData))=41;
            countertarget=countertarget+1;
            counterflicker=counterflicker+1;
            framefix(countertarget)=length(EyeData(:,1));
            timefix(countertarget)=GetSecs;
        end
        circlefix=0;
        
    end
    
    if  blankcounter==1
        startBlankCounter=GetSecs;
    end
    if  blankcounter==blankframeallowed
        stopBlankCounter=GetSecs;
    end
    totalflickframe(length(EyeData))=5;
    
end


% test_time=[framefix' timefix']

% for ui=1:length(timefix)-1
%     
%     diff(ui)=timefix(ui+1)-timefix(ui)
% end