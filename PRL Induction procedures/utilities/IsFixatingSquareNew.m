%function [fixating x y area_eye evt ]=IsFixating(el,eye_used,fixr,rect,driftoffsetx,driftoffsety)
function [fixating counter framecounter ]=IsFixatingSquareNew(wRect,xeye,yeye,fixating,framecounter,counter,fixwindowPix)


% if EyetrackerType == 1
%     error=Eyelink('CheckRecording');
%     evt=error;
%     if(error~=0)
%         error
%         return;
%     end
% end
framecounter=framecounter+1;
if   framecounter>1 & round(wRect(4)/2+(yeye(end)-(wRect(4)/2)))>(wRect(4)/2-fixwindowPix) && round(wRect(3)/2+(xeye(end)-(wRect(3)/2))) >(wRect(3)/2-fixwindowPix) ...
        && round(wRect(4)/2+(yeye(end)-(wRect(4)/2)))<(wRect(4)/2+fixwindowPix) && round(wRect(3)/2+(xeye(end)-(wRect(3)/2)))<= (wRect(3)/2+fixwindowPix)
    
    % if eyes are within fixation window; we count the frame
    fixating=fixating+1;
    counter=counter+1;
else
    % if eyes are outside fixation window; reset fixating
    fixating=0;
    counter=counter+0;
end
end