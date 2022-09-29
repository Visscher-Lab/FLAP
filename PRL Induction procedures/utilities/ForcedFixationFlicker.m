
function  [countgt framecont countblank blankcounter counterflicker ]=  ForcedFixationFlicker(countgt,countblank, framecont, w, theCircles, imageRect_offs, imageRect_offs_dot,fixdotcolor2, newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,theeccentricity_X,theeccentricity_Y,blankcounter,framesbeforeflicker,blankframeallowed, circlefix, EyeData, counterflicker,trainingType,eyetime2,EyeCode)
   % function to count the frames that satisfy the fixation request
   % (fixation within the TRL). It is called during Training type 3. 
   %When fixation is outside the TRL, the flickering O will stop. During
   %Training type 4, the fixation dot turns black. There is a leeway for
   %both the start and the end of the flickering, as defined by the
   %variables framesbeforeflicker and blankframeallowed
   
   
    % here to check whether target is within the PRL
    
    if round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)<=size(circlePixelsPRL,1) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix)<=size(circlePixelsPRL,2) ...
            &&  round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)> 0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix)> 0
        
        codey=round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix);
        codex=round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix);
        activePRLT =1;
    else
        codey= 1;
        codex= 1;
        activePRLT = 0;
        
    end
    
    if   round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)<wRect(4) && round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)+PRLxpix))<wRect(3) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)+PRLxpix))>0
        % 1:the stimulus should be presented, 2:the eye position is within
        %the limits of the screen
        uncheckerframe(length(EyeData))=1;
        othercounter(length(EyeData))=1;
        if   circlePixelsPRL(codey, codex)<0.81
            % 1:the stimulus should be presented, 2:the eye position is within
            %the limits of the screen, but the stimulus is outside the
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
            elseif blankcounter<=blankframeallowed % eyes away from target but target still visible
                checkerframe(length(EyeData))=11;
                counterflicker=counterflicker+1;
                framefix(counterflicker)=length(EyeData(:,1));
                timefix(counterflicker)=GetSecs;
            end
            circlefix=0;
            
        else
            %if we have the EyeCode element, which
            %tracks the frames for which we have eye position recorded (even if the eye position is missing)
            othercounter(length(EyeData))=1;
            if  exist('EyeCode','var')
                if length(EyeCode)>6
                    circlefix=circlefix+1;
                    if sum(EyeCode(end-framesbeforeflicker:end))~=0
                        %if we don't have xx consecutive frames with no eye movement (aka, with
                        %fixation)
                        
                        blankcounter=blankcounter+1;
                        
                        if blankcounter>blankframeallowed
                            if trainingType==3
                                Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                            elseif trainingType==4
                                Screen('FillOval', w, fixdotcolor2, imageRect_offs_dot);
                            end
                            Fixationstatus(length(EyeData))=92;
                            checkerframe(length(EyeData))=27;
                        elseif blankcounter<=blankframeallowed % eyes away from target but target still visible
                            
                            checkerframe(length(EyeData))=71;
                            counterflicker=counterflicker+1;
                            framefix(counterflicker)=length(EyeData(:,1));
                            timefix(counterflicker)=GetSecs;
                        end
                    elseif sum(EyeCode(end-framesbeforeflicker:end))==0
                        %If we have at least xx
                        %consecutive frames with
                        %fixation
                        %HERE WE SHOW THE TARGET
                        blankcounter=0;
                        checkerframe(length(EyeData))=3;
                        counterflicker=counterflicker+1;
                        framefix(counterflicker)=length(EyeData(:,1));
                        timefix(counterflicker)=GetSecs;
                        if exist('FixIndex','var')
                            fixind(counterflicker)=FixIndex(end,1);
                        end
                        showtarget=100;
                        timeprevioustarget(counterflicker)=GetSecs;
                        Fixationstatus(length(EyeData))=11;
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
                    elseif blankcounter<=blankframeallowed % eyes away from target but target still visible
                        
                        checkerframe(length(EyeData))=31;
                        counterflicker=counterflicker+1;
                        framefix(counterflicker)=length(EyeData(:,1));
                        timefix(counterflicker)=GetSecs;
                    end
                    circlefix=circlefix+1;
                end
            end
        end
                
    elseif round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)+PRLxpix))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)+PRLxpix))<0 %...
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
        elseif blankcounter<=blankframeallowed % eyes away from target but target still visible
            
            checkerframe(length(EyeData))=41;
            counterflicker=counterflicker+1;
            framefix(counterflicker)=length(EyeData(:,1));
            timefix(counterflicker)=GetSecs;
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
countgt(length(EyeData))=counterflicker;
countblank(length(EyeData))=blankcounter;
framecont(length(EyeData))=eyetime2;
end
% test_time=[framefix' timefix']

% for ui=1:length(timefix)-1
%
%     diff(ui)=timefix(ui+1)-timefix(ui)
% end