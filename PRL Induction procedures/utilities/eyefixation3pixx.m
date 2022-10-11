           %   if eyetime>0
                if eyeOrtrack==0
                    pos=GetMouse(0);
                         occhi(1)=pos(1);
                            occhi(2)=pos(2);
                   xeye=[xeye pos(1)];
                            yeye=[yeye pos(2)];
                    

                elseif eyeOrtrack==1
[xScreenRight, yScreenRight, ~, ~, ~, ~, ~, ~, ~] = Datapixx('GetEyePosition');
    pos = Datapixx('ConvertCoordSysToCustom', [xScreenRight, yScreenRight]);
  %  Screen('FillOval', windowPtr, [128, 128, 128], [(pos(1)-offsetX)-diameter/2, (pos(2)-offsetY)-diameter/2, (pos(1)-offsetX)+diameter/2, (pos(2)-offsetY)+diameter/2]);
    
                    % start recording eye-position data

                            occhi(1)=pos(1);
                            occhi(2)=pos(2);
                            
                           xeye=[xeye pos(1)];
                            yeye=[yeye pos(2)];
                      %      pupils=[pupils pupil];
                      %      tracktime=[tracktime trackertime];
                            
%                             trial(trial).X = [eyeX, newsamplex]; % +1 as we're accessing MATLAB array
%                             trial(trial).Y = [eyey, newsampley]; % +1 as we're accessing MATLAB array
%                             trial(trial).pupil=[pupils, elEvent.pa(eye_used+1)];
%                             trial(trial).time=[eyetime, elEvent.time];
                        end
                  %  end
              %  end
                scotoma = [scotomarect(1)+(occhi(1)-wRect(3)/2), scotomarect(2)+(occhi(2)-wRect(4)/2), scotomarect(3)+(occhi(1)-wRect(3)/2), scotomarect(4)+(occhi(2)-wRect(4)/2)];
             
                      
          %    end
            
