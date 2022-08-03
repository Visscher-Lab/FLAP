function [counterannulus framecounter ]=IsFixatingPRL3(newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,EyetrackerType,theeccentricity_X,theeccentricity_Y,framecounter,counterannulus)
%this function counts frames in which the target is seeing through the assigned TRL
if EyetrackerType == 1
    error=Eyelink('CheckRecording');
    evt=error;
    if(error~=0)
        error
        return;
    end
end
framecounter=framecounter+1; % counts frames during which this function was active
if framecounter>1 & round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix) >0 ...
        && round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)<wRect(4) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix)<= wRect(3)
    %count frames within the PRL or annulus created in the main script (annulus around the scotoma)        
        if   framecounter>1 & circlePixelsPRL(round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix), round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix))>0.81
            counterannulus=counterannulus+1;
        else
            % if fixation puts the target outside the TRL
            counterannulus=counterannulus+0; 
        end
else % if fixation is outside the limits of the screen
    counterannulus=counterannulus+0;    
end
end
