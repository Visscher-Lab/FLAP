if  stimpresent>0
    % here to force fixations with the PRL
    
    if round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix)<=size(circlePixels,1) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix)<=size(circlePixels,2) ...
            &&  round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix)> 0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix)> 0;
        
        
        codey=round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix);
        codex=round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix);
        activePRLT =1;
    else
        codey= 1; %round(1025/2); %
        codex= 1; %round(1281/2);%
        activePRLT = 0;
        activePRLT = 0;
        
    end
    %    end
    
    if  stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix)<wRect(4) && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix)>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix))<wRect(3) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix))>0
        
        % if the stimulus should be present and the
        % eye position is within the limits of the
        % screen
        if   circlePixels(codey, codex)<0.81
            
            
            % if the stimulus should be present and the
            % eye position is within the limits of the
            % screen but the stimulus is outside the
            % PRL(s)
            
            Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
            circlefix=0;
            
        else
            %if we have the EyeCode element, which
            %tracks the frames for which we have eye position recorded (even if the eye position is missing)
            if  exist('EyeCode','var')
                if length(EyeCode)>6 %&& circlefix>6
                    circlefix=circlefix+1;
                    %if we have at least 6 frames
                    %within this trial
                    % if  EyeCode(end-1)~=0 && EyeCode(end)~=0
                    if sum(EyeCode(end-6:end))~=0
                        %if we don't have 6 consecutive frames with no eye movement (aka, with
                        %fixation)
                        Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                        
                    elseif sum(EyeCode(end-5:end))==0
                        %If we have at least 5
                        %consecutive frames with
                        %fixation
                        %HERE WE SHOW THE TARGET
                        countertarget=countertarget+1;
                        framefix(countertarget)=length(EyeData(:,1));
                        if exist('FixIndex','var')
                            fixind(countertarget)=FixIndex(end,1);
                        end
                        mostratarget=100;
                        timeprevioustarget(countertarget)=GetSecs;
                        % circlefix=circlefix+1;
                    end
                elseif length(EyeCode)<=5 %&& circlefix<=6
                    %if we don't have at least 5 frames
                    %per trial
                    Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                    
                    circlefix=circlefix+1;
                elseif length(EyeCode)>5 %&& circlefix<=6
                    Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                    
                    circlefix=circlefix+1;
                end
            end
        end
        
        
    elseif stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix)>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix)<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix))<0 %...
        
        
        circlefix=0;
        % If this texture is active it will make the target visible only if all the PRLs are within the screen. If one of themis outside the target won't be visible
        %       Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
        %                             for iu=1:length(PRLx)
        %                                 imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        %                                     imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
        %                                 if visibleCircle ==1
        %                                     Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
        %                                 end
        %                             end
    end
    
    
    
end