 % induction PRL patch
 if  stimpresent>0
                    % here to force fixations with the PRL
                    for aux= 1:length(PRLxpix)
                        
                        for aup= 1:length(PRLxpix)
                            if round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aup))<=size(circlePixels,1) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix(aup))<=size(circlePixels,2) ...
                                    &&  round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aup))> 0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix(aup))> 0
                                
                                
                                codey(aup)=round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aup));
                                codex(aup)=round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix(aup));
                                activePRLT(aup) =1;
                            else
                                codey(aup)= 1; %round(1025/2); %
                                codex(aup)= 1; %round(1281/2);%
                                activePRLT(aup) = 0;
                                activePRLT(aup) = 0;
                                
                            end
                        end
                        if TRLnumber<4
                           codex(TRLnumber+1:4)=codex(1);
                           codey(TRLnumber+1:4)=codey(1);
                        end
                        if  stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux))<wRect(4) && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux))>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux)))<wRect(3) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux)))>0
                            
                            % if the stimulus should be present and the
                            % eye position is within the limits of the
                            % screen
                            if   circlePixels(codey(1), codex(1))<0.81 && circlePixels(codey(2), codex(2))<0.81 && circlePixels(codey(3), codex(3))<0.81 ...
                                    && circlePixels(codey(4), codex(4))<0.81
                                
                                
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
                                            showtarget=100;
                                            timeprevioustarget(countertarget)=GetSecs;
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
                            
                            
                        elseif stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux))>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux))<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux)))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux)))<0 %...
                            
                            
                            circlefix=0;
                            % If this texture is active it will make the target visible only if all the PRLs are within the screen. If one of themis outside the target won't be visible
                            %       Screen('DrawTexture', w, Neutralface, [], imageRect_offs);

                        end
                    end
                    for gg=1:totalelements-1
                        
                        for aux=1:length(PRLxpix)
                            for uso= 1:totalelements-1
                                for aup= 1:length(PRLxpix)
                                    if round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(uso)))+PRLypix(aup))<=size(circlePixels,1) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(uso)))+PRLxpix(aup))<=size(circlePixels,2) ...
                                            &&  round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(uso)))+PRLypix(aup))> 0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(uso)))+PRLxpix(aup))> 0;
                                        
                                        coodey(uso,aup)=round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(uso)))+PRLypix(aup));
                                        coodex(uso,aup)=round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(uso)))+PRLxpix(aup));
                                        activePRL(uso,aup) =1;
                                    else
                                        coodey(uso,aup)= 1; %round(1025/2);
                                        coodex(uso,aup)= 1; %round(1281/2);
                                        activePRL(uso,aup) = 0;                                   
                                    end
                                    if TRLnumber<4
                                        coodex(uso, TRLnumber+1:4)=coodex(uso,1);
                                        coodey(uso, TRLnumber+1:4)=coodey(uso,1);
                                    end
                                end                             
                            end

                            if stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux))<wRect(4) && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux))>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux)))<wRect(3) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux)))>0 %|| ...
                                if   circlePixels(coodey(gg,1), coodex(gg,1))<0.81 && circlePixels(coodey(gg,2), coodex(gg,2))<0.81 && circlePixels(coodey(gg,3), coodex(gg,3))<0.81 ...
                                        && circlePixels(coodey(gg,4), coodex(gg,4))<0.81

                                    circlefix2(gg)=0;
                                else
                                    if  exist('EyeCode','var')
                                        if length(EyeCode)>5 && circlefix2(gg)>5
                                            circlefix2(gg)=circlefix2(gg)+1;
                                            if sum(EyeCode(end-5:end))~=0
                                                circlefix2(gg)=circlefix2(gg)+1;

                                            elseif   sum(EyeCode(end-5:end))==0
                                                %show target
                                                countertargettt(aux,nn)=1;
                                            end
                                        elseif length(EyeCode)<5 && circlefix2(gg)<=5

                                            circlefix2(gg)=circlefix2(gg)+1;
                                        elseif length(EyeCode)>5 && circlefix2(gg)<=5
                                            circlefix2(gg)=circlefix2(gg)+1;

                                        end
                                    end
                                end
                            elseif stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux))>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux))<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux)))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux)))<0  %|| ...
                                %    round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux2))>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux2))<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux2)))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux2)))<0
                                
                                
                                circlefix2(gg)=0;
                                %                                 for iu=1:length(PRLx)
                                %                                     imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
                                %                                         imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
                                %                                     if visibleCircle ==1
                                %                                         Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
                                %                                     end
                                %                                 end
                            end
                        end
                    end       
                end