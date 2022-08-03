%function [fixating x y area_eye evt ]=IsFixating(el,eye_used,fixr,rect,driftoffsetx,driftoffsety)

       % fixating=0;
    
       if EyetrackerType == 1
           error=Eyelink('CheckRecording');
           evt=error;
           if(error~=0)
               error
               return;
           end
       end

% check for presence of a new sample update
%if Eyelink( 'NewFloatSampleAvailable') > 0
    % get the sample in the form of an event structure
%     evt = Eyelink( 'NewestFloatSample');
%     % if we do, get current gaze position from sample
%    % x = evt.gx(eye_used+1)-centx; % +1 as we're accessing MATLAB array
%    % y = evt.gy(eye_used+1)-centy;
%     newsamplex=evt.gx(eye_used+1);
%     newsampley=evt.gy(eye_used+1);
  %  xeye=[xeye x];
  %  yeye=[yeye y];
%     xeye2=[xeye2 newsamplex];
%     yeye2=[yeye2 newsampley];
    framecounter=framecounter+1;
    %  area_eye = evt.pa(eye_used+1);
%     area_sticker = evt.pa(eye_used+1);
    % do we have valid data and is the pupil visible?
%    if x~=el.MISSING_DATA & y~=el.MISSING_DATA & evt.pa(eye_used+1)>0 & abs(x)<=fixr & abs(y)<=fixr %subject fixating?  
    %        if framecounter>1 & (xeye2(framecounter)-xeye2(framecounter-1))<fixwindowPix & (yeye2(framecounter)-yeye2(framecounter-1))<fixwindowPix %subject fixating?
        % if data is valid, draw a circle on the screen at current gaze position
        % using PsychToolbox's Screen function
        
        if framecounter>1 & round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y)))>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))) >0 ...
             && round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y)))<wRect(4) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X)))<= wRect(3)
          %count frames within the annulus created in the main script (annulus around the scotoma)  
    if   framecounter>1 & circlePixels(round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))), round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))))>0.81
       % fixating=fixating+1;
        counterannulus=counterannulus+1;
    else
        % if data is invalid (e.g. during a blink), clear display
      %  fixating=0;
        counterannulus=counterannulus+0;
%                                        Screen('DrawTexture', w, Neutralface, [], imageRect_offs);

    end
    
        else 
     counterannulus=counterannulus+0;
 %                                       Screen('DrawTexture', w, Neutralface, [], imageRect_offs);

end
%end
