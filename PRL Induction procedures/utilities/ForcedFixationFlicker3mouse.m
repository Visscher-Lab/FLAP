%function [countgt framecont countblank blankcounter counterflicker turnFlickerOn eyerunner]=  ForcedFixationFlicker3mouse(w,countgt,countblank, framecont, newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,theeccentricity_X,theeccentricity_Y,blankcounter,framesbeforeflicker,blankframeallowed, xeye, counterflicker,eyetime2,turnFlickerOn)
% function to count the frames that satisfy the fixation request
% (fixation within the TRL). It is called during Training type 3.
%When fixation is outside the TRL, the flickering O will stop. During
%Training type 4, the fixation dot turns black. There is a leeway for
%both the start and the end of the flickering, as defined by the
%variables framesbeforeflicker and blankframeallowed

turnFlickerOn(length(xeye))=1; % by default flicker is active, unless something happens below
eyerunner=zeros(length(xeye),1)';
% distance target-PRL
codey=round(wRect(4)/2+(newsampley-(wRect(4)/2+theeccentricity_Y))+PRLypix);
codex=round(wRect(3)/2+(newsamplex-(wRect(3)/2+theeccentricity_X))+PRLxpix);

% is the PRL within the limits of the screen?
if   codey<wRect(4) && codey>0 && codex<wRect(3) && codex>0
    %is the target outside the PRL?
    if   circlePixelsPRL(codey, codex)<0.81
        blankcounter=blankcounter+1;
        if  blankcounter==1
            startBlankCounter=GetSecs;
        end
        if  blankcounter==blankframeallowed
            stopBlankCounter=GetSecs;
        end
        
        if blankcounter>blankframeallowed
            turnFlickerOn(length(xeye))=0;
        elseif blankcounter<=blankframeallowed % eyes away from target but target still visible
            counterflicker=counterflicker+1;
      %      framefix(counterflicker)=length(xeye(:,1));
      %      timefix(counterflicker)=GetSecs;
        end        
    else         %is the target inside the PRL?
        
        %if we have the eyerunner element, which
        %tracks the frames for which we have eye position recorded (even if the eye position is missing)
     eyerunner=zeros(length(xeye),1)';
   if sum(eyerunner(end-round(framesbeforeflicker):end))~=0
            %if we don't have xx consecutive frames with no eye movement (aka, with
            %fixation)
            blankcounter=blankcounter+1;
            if blankcounter>blankframeallowed
                turnFlickerOn(length(xeye))=0;
            elseif blankcounter<=blankframeallowed % eyes away from target but target still visible
                counterflicker=counterflicker+1;
            end
        elseif sum(eyerunner(end-framesbeforeflicker:end))==0
            %If we have at least xx
            %consecutive frames with
            %fixation
            %HERE WE SHOW THE TARGET
            blankcounter=0;
            counterflicker=counterflicker+1;
            showtarget=100;
        end 
    end    
elseif codey>wRect(4) || codey<0 || codex>wRect(3) || codex<0 %...
    % if eyes looking outside of the screen area
    blankcounter=blankcounter+1;
    if blankcounter>blankframeallowed
        turnFlickerOn(length(xeye))=0;
    elseif blankcounter<=blankframeallowed % eyes away from target but target still visible
        counterflicker=counterflicker+1;
    end
end
totalflickframe(length(xeye))=5;
countgt(length(xeye))=counterflicker;
countblank(length(xeye))=blankcounter;
framecont(length(xeye))=eyetime2;
%end
