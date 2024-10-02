if EyeTracker==0
    [posx posy]=GetMouse(0);
    newsamplex=posx;
    newsampley=posy;
    % newsamplex=wRect(3)/2;
    % newsampley=wRect(4)/2;
    
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
            end
        end
    elseif EyetrackerType==2
        eye_used=0;
      %  [xScreenRight, yScreenRight, xScreenLeft, yScreenLeft , ~, ~, ~, ~, ~] = Datapixx('GetEyePosition');
               [xScreenLeft, yScreenLeft, xScreenRight, yScreenRight, ~, ~, ~, ~, ~] = Datapixx('GetEyePosition');

               if whicheye==1
            pos = Datapixx('ConvertCoordSysToCustom', [xScreenLeft, yScreenLeft]);
         %   [~, ~, Left_Major, Left_Minor]= Datapixx('GetPupilSize');
                             [Left_Major, Left_Minor]= Datapixx('GetPupilSize');
            newpupil_maj=Left_Major;
            newpupil_min=Left_Minor;
        elseif whicheye==2
            pos = Datapixx('ConvertCoordSysToCustom', [xScreenRight, yScreenRight]);
        %    [Right_Major, Right_Minor]= Datapixx('GetPupilSize');
            [~, ~, Right_Major, Right_Minor]= Datapixx('GetPupilSize');

            newpupil_maj=Right_Major;
            newpupil_min=Right_Minor;
        end
        newsamplex=pos(1);
        newsampley=pos(2);
    end
end
occhi(1)=newsamplex;
occhi(2)=newsampley;

xeye=[xeye newsamplex];
yeye=[yeye newsampley];
if EyeTracker>0
pupilmaj=[pupilmaj newpupil_maj];
pupilmin=[pupilmin newpupil_min];
end
scotoma = [scotomarect(1)+(occhi(1)-wRect(3)/2), scotomarect(2)+(occhi(2)-wRect(4)/2), scotomarect(3)+(occhi(1)-wRect(3)/2), scotomarect(4)+(occhi(2)-wRect(4)/2)];

