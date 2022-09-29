%   if eyetime>0
if EyeTracker==0
    %[posx posy]=GetMouse(0);
 %   occhi(1)=posx;
 %   occhi(2)=posy;
    %newsamplex=posx;
    %newsampley=posy;
    newsamplex=wRect(3)/2;
        newsampley=wRect(4)/2;
 %   xeye=[xeye posx];
  %  yeye=[yeye posy];
elseif EyeTracker==1
if EyetrackerType==1
    err=Eyelink('CheckRecording');
    if(err~=0)
        error('Eyelink not recording eye-position data');
    end
    % start recording eye-position data
    eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
    if Eyelink('NewFloatSampleAvailable') > 0
        elEvent = Eyelink('NewestFloatSample');
        if eye_used ~= -1 % do we know which eye to use yet?
            newsamplex=elEvent.gx(eye_used+1);
            newsampley=elEvent.gy(eye_used+1);
            %      pupil=elEvent.pa(eye_used+1);
            %      trackertime=elEvent.time;
%             occhi(1)=newsamplex;
%             occhi(2)=newsampley;
%             
%             xeye=[xeye newsamplex];
%             yeye=[yeye newsampley];
            %      pupils=[pupils pupil];
            %      tracktime=[tracktime trackertime];
            
            %                             trial(trial).X = [eyeX, newsamplex]; % +1 as we're accessing MATLAB array
            %                             trial(trial).Y = [eyey, newsampley]; % +1 as we're accessing MATLAB array
            %                             trial(trial).pupil=[pupils, elEvent.pa(eye_used+1)];
            %                             trial(trial).time=[eyetime, elEvent.time];
        end
    end
elseif EyetrackerType==2
    eye_used=0;
    [xScreenRight, yScreenRight, ~, ~, ~, ~, ~, ~, ~] = Datapixx('GetEyePosition');
    pos = Datapixx('ConvertCoordSysToCustom', [xScreenRight, yScreenRight]);
    %  Screen('FillOval', windowPtr, [128, 128, 128], [(pos(1)-offsetX)-diameter/2, (pos(2)-offsetY)-diameter/2, (pos(1)-offsetX)+diameter/2, (pos(2)-offsetY)+diameter/2]);
    
    % start recording eye-position data
    
   newsamplex=pos(1);
    newsampley=pos(2);

    %      pupils=[pupils pupil];
    %      tracktime=[tracktime trackertime];
    
    %                             trial(trial).X = [eyeX, newsamplex]; % +1 as we're accessing MATLAB array
    %                             trial(trial).Y = [eyey, newsampley]; % +1 as we're accessing MATLAB array
    %                             trial(trial).pupil=[pupils, elEvent.pa(eye_used+1)];
    %                             trial(trial).time=[eyetime, elEvent.time];
end
end
            occhi(1)=newsamplex;
            occhi(2)=newsampley;
            
            xeye=[xeye newsamplex];
            yeye=[yeye newsampley];
%end  
%  end
%  end
scotoma = [scotomarect(1)+(occhi(1)-wRect(3)/2), scotomarect(2)+(occhi(2)-wRect(4)/2), scotomarect(3)+(occhi(1)-wRect(3)/2), scotomarect(4)+(occhi(2)-wRect(4)/2)];


%    end

