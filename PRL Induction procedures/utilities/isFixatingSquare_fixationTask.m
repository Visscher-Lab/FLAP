%function [fixating x y area_eye evt ]=IsFixating(el,eye_used,fixr,rect,driftoffsetx,driftoffsety)


if EyetrackerType == 1
    error=Eyelink('CheckRecording');
    evt=error;
    if(error~=0)
        error
        return;
    end
end
framecounter=framecounter+1;
if   framecounter>1 & round(imageRectWW(4)/2+(newsampley-(imageRectWW(4)/2)))>(imageRectWW(4)/2-fixwindowPix) && round(wRect(3)/2+(newsamplex-(wRect(3)/2))) >(wRect(3)/2-fixwindowPix) ...
        && round(imageRectWW(4)/2+(newsampley-(imageRectWW(4)/2)))<(imageRectWW(4)/2+fixwindowPix) && round(wRect(3)/2+(newsamplex-(wRect(3)/2)))<= (wRect(3)/2+fixwindowPix)
    
    % if eyes are within fixation window; we count the frame
    fixating=fixating+1;
    counter=counter+1;
else
    % if eyes are outside fixation window; reset fixating
    fixating=0;
    counter=counter+0;
end


if   framecounter>1 & round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y)))>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2))) >0 ...
             && round(wRect(4)/2+(newsampley-(wRect(4)/2+(startingfixationpoint(mixtr(trial,1)) * pix_deg)))<wRect(4) && round(wRect(3)/2+(newsamplex-(wRect(3)/2)))<= wRect(3)    
    % if eyes are within fixation window; we count the frame
    fixating=fixating+1;
    counter=counter+1;
else
    % if eyes are outside fixation window; reset fixating
    fixating=0;
    counter=counter+0;
end



