stimpresent=1;

if  stimpresent>0
    % here to force fixations with the PRL
    
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
    %    end
    
    if  stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)<wRect(4) && round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)+PRLxpix))<wRect(3) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)+PRLxpix))>0
        % 1:the stimulus should be presented, 2:the eye position is within
        %the limits of the screen

        if   circlePixelsPRL(codey, codex)<0.81
            % 1:the stimulus should be presented, 2:the eye position is within
            %the limits of the screen but the stimulus is outside the
            % PRL(s)
            
            blankcounter2=blankcounter2+1;
            if  blankcounter2==1
                startBlankCounter2=GetSecs;
            end
            if  blankcounter2==blankframeallowed
                stopBlankCounter2=GetSecs;
            end
            
            if blankcounter2>blankframeallowed


            elseif blankcounter<=blankframeallowed % eyes away from target but target still visible
                checkerframe(length(EyeData))=11;
                counterflicker2=counterflicker2+1;

            end
            circlefix2=0;
            
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
%                     if sum(EyeCode(end-6:end))~=0
%                         %if we don't have 6 consecutive frames with no eye movement (aka, with
%                         %fixation)
%                         
%                         blankcounter=blankcounter+1;
%                         
%                         if blankcounter>blankframeallowed
%                             if trainingType==3
%                                 Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
%                             elseif trainingType==4
%                                 Screen('FillOval', w, fixdotcolor2, imageRect_offs_dot);
%                                 
%                             end
%                             Fixationstatus(length(EyeData))=92;
%                             checkerframe(length(EyeData))=2;
%                         elseif blankcounter<=blankframeallowed
%                             
%                             checkerframe(length(EyeData))=21;
%                             countertarget=countertarget+1;
%                             counterflicker=counterflicker+1;
%                             framefix(countertarget)=length(EyeData(:,1));
%                             timefix(countertarget)=GetSecs;
%                         end
                        
                    if sum(EyeCode(end-framesbeforeflicker:end))~=0
                        %if we don't have xx consecutive frames with no eye movement (aka, with
                        %fixation)
                        
                        blankcounter2=blankcounter2+1;
                        
                        if blankcounter2>blankframeallowed


                        elseif blankcounter2<=blankframeallowed % eyes away from target but target still visible
                            
                            checkerframe(length(EyeData))=71;
                            counterflicker2=counterflicker2+1;
                        end
                    elseif sum(EyeCode(end-framesbeforeflicker:end))==0
                        %If we have at least xx
                        %consecutive frames with
                        %fixation
                        %HERE WE SHOW THE TARGET
                        blankcounter2=0;
                        checkerframe(length(EyeData))=3;
                        counterflicker2=counterflicker2+1;

                        
                    end
                elseif length(EyeCode)<=5 %&& circlefix<=6
                    %if we don't have at least 5 frames
                    %per trial
                    
                    blankcounter2=blankcounter2+1;
                    
                    if blankcounter2>blankframeallowed

                    elseif blankcounter2<=blankframeallowed % eyes away from target but target still visible
                        
                        counterflicker2=counterflicker2+1;

                    end
                    circlefix2=circlefix2+1;

                end
            end
        end
        
        
    elseif stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)+PRLxpix))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)+PRLxpix))<0 %...
        % if eyes looking outside of the screen area
        blankcounter2=blankcounter2+1;
        if blankcounter2>blankframeallowed

        elseif blankcounter2<=blankframeallowed % eyes away from target but target still visible
            
            counterflicker2=counterflicker2+1;

        end
        circlefix2=0;
        
    end
    
    if  blankcounter2==1
        startBlankCounter2=GetSecs;
    end
    if  blankcounter2==blankframeallowed
        stopBlankCounter2=GetSecs;
    end
    
end

countblank2(length(EyeData))=blankcounter2;
framecont2(length(EyeData))=eyetime2;

% test_time=[framefix' timefix']

% for ui=1:length(timefix)-1
%     
%     diff(ui)=timefix(ui+1)-timefix(ui)
% end