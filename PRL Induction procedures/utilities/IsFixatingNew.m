function [fixating2 counter framecounter ]=IsFixatingNew(xeye,yeye,fixating2,counter,fixwindowPix)

% fixating=0;

% if EyetrackerType == 1
%     error=Eyelink('CheckRecording');
%     evt=error;
%     if(error~=0)
%         error
%         return;
%     end
% end


framecounter=framecounter+1;

if framecounter>1 & (xeye(end)-xeye(end-1))<fixwindowPix & (yeye(end)-yeye(end-1))<fixwindowPix %subject fixating?
    % if data is valid, draw a circle on the screen at current gaze position
    % using PsychToolbox's Screen function
    fixating2=fixating2+1;
    counter=counter+1;
else
    % if data is invalid (e.g. during a blink), clear display
    fixating2=0;
    counter=counter+0;
end
end
