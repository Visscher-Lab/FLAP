       if EyetrackerType == 1
           error=Eyelink('CheckRecording');
           evt=error;
           if(error~=0)
               error
               return;
           end
       end
    framecounter=framecounter+1;

        if framecounter>1 & round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix) >0 ...
             && round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix)<wRect(4) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix)<= wRect(3)
          %count frames within the annulus created in the main script (annulus around the scotoma)  
    if   framecounter>1 & circlePixelsPRL(round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix), round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix))>0.81
       % fixating=fixating+1;
        counterannulus=counterannulus+1;
    else
        % if data is invalid (e.g. during a blink), clear display
      %  fixating=0;
        counterannulus=counterannulus+0;

    end
        else 
     counterannulus=counterannulus+0;

end
%end
