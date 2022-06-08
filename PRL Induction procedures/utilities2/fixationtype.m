function fixationtype(w, wRect, fixat,fixationlength,white,pix_deg,AMD)




%fixat=0  no fixation
%fixat=1  contracting dot
%fixat=2 contracting cross
%fixat=3 dot
%fixat=4 cross
%fixat=5 visual aids only
%fixat=6 visual aids+cross
%fixat=7 visual aids+cross+dot contracting
%fixat=8 wedges
%fixat=9 low contrast wedges


waittime=0.4; %0.8 it was 0.4 
durationtime=1.0;
colorfixation=white;
LineWidth = ceil(.2*pix_deg);
FixDotSize = LineWidth*1.5;
[xc, yc] = RectCenter(wRect); % coordinate del centro schermo
FixAnimationDuration = 45; %frames parameter to be changed
FixCrossSize=25;
FixSizeTime = linspace(round(4*pix_deg),FixCrossSize,FixAnimationDuration);


if fixat==1;
    
    Screen('DrawDots', w, [xc;yc], FixDotSize, white,[],1);
    vbl = Screen('Flip', w); % show fixation
    WaitSecs(1);
    %[240 190 190]
    
    for ft = 1:FixAnimationDuration
        Screen('FillOval', w, white, [xc yc xc yc]+...
            [-FixSizeTime(ft)/2 -FixSizeTime(ft)/2 FixSizeTime(ft)/2 FixSizeTime(ft)/2]);
        Screen('DrawDots', w, [xc;yc], FixDotSize, white,[],1);
        %Screen('FrameRect', win, black, FrameRect, 2);
        Screen('Flip',w);
        pause(1/60);
    end
    Screen('Flip',w);
    pause(waittime)
    
elseif fixat==2
    
    
    Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    vbl = Screen('Flip', w); % show fixation
    WaitSecs(1);
    for ft = 1:FixAnimationDuration
        Screen('DrawLine', w, white, xc, yc-FixSizeTime(ft)/2, xc, yc+FixSizeTime(ft)/2,5); % fissazione: verticale
        Screen('DrawLine', w, white, xc-FixSizeTime(ft)/2, yc, xc+FixSizeTime(ft)/2, yc,5); % fissazione: orizzontale
        Screen('DrawLine', w, white, xc, yc-fixationlength, xc, yc+fixationlength,5); % fissazione: verticale
        Screen('DrawLine', w, white, xc-fixationlength, yc, xc+fixationlength, yc,5); % fissazione: orizzontale
        Screen('Flip',w);
        pause(1/60);
    end
    Screen('DrawLine', w, white, xc, yc-fixationlength, xc, yc+fixationlength,5); % fissazione: verticale
    Screen('DrawLine', w, white, xc-fixationlength, yc, xc+fixationlength, yc,5); % fissazione: orizzontale
    Screen('Flip',w);   
        pause(waittime)    
    
elseif fixat==3
    
    Screen('DrawDots', w, [xc;yc], FixDotSize, white,[],1);
    vbl = Screen('Flip', w); % show fixation
    pause(waittime)
    
    
elseif fixat==4
    Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    vbl = Screen('Flip', w); % show fixation
    pause(waittime)
    
elseif fixat==5
    
    fixationlength = 40; 

    p1x=-8;
    p1y=-8;
    p2x=8;
    p2y=-8;
    p3x=8;
    p3y=8;
    p4x=-8;
    p4y=8;
    
    punto1x=p1x*pix_deg;
    punto1y=p1y*pix_deg;
    punto2x=p2x*pix_deg;
    punto2y=p2y*pix_deg;
    punto3x=p3x*pix_deg;
    punto3y=p3y*pix_deg;
    punto4x=p4x*pix_deg;
    punto4y=p4y*pix_deg;
    %aid up left
    
    Screen('DrawLine', w, white, xc+punto1x, yc+punto1y, xc+punto1x+fixationlength, yc+punto1y); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto1x, yc+punto1y, xc+punto1x, yc+punto1y+fixationlength); % fissazione: orizzontale
    %aid up right
    Screen('DrawLine', w, white, xc+punto2x-fixationlength, yc+punto2y, xc+punto2x, yc+punto2y); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto2x, yc+punto2y, xc+punto2x, yc+punto2y+fixationlength); % fissazione: orizzontale
    %aid down right
    Screen('DrawLine', w, white, xc+punto3x-fixationlength, yc+punto3y, xc+punto3x, yc+punto3y); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto3x, yc+punto3y-fixationlength, xc+punto3x, yc+punto3y); % fissazione: orizzontale
    %aid down left
    Screen('DrawLine', w, white, xc+punto4x, yc+punto4y, xc+punto4x+fixationlength, yc+punto4y); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto4x, yc+punto4y-fixationlength, xc+punto4x, yc+punto4y); % fissazione: orizzontale
    vbl = Screen('Flip', w); % show fixation
    pause(waittime)    
    
elseif fixat==6
    p1x=-8;
    p1y=-8;
    p2x=8;
    p2y=-8;
    p3x=8;
    p3y=8;
    p4x=-8;
    p4y=8;
    
    punto1x=p1x*pix_deg;
    punto1y=p1y*pix_deg;
    punto2x=p2x*pix_deg;
    punto2y=p2y*pix_deg;
    punto3x=p3x*pix_deg;
    punto3y=p3y*pix_deg;
    punto4x=p4x*pix_deg;
    punto4y=p4y*pix_deg;
    
fixationlength = 40; 
fixationlengthx = wRect(3)/2;
fixationlengthy = wRect(4)/2;
    
    
    Screen('DrawLine', w, white, xc, yc-fixationlengthy, xc, yc+fixationlengthy); % fissazione: verticale
    Screen('DrawLine', w, white, xc-fixationlengthx, yc, xc+fixationlengthx, yc); % fissazione: orizzontale
    
    %aid up left
    Screen('DrawLine', w, white, xc+punto1x, yc+punto1y, xc+punto1x+fixationlength, yc+punto1y); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto1x, yc+punto1y, xc+punto1x, yc+punto1y+fixationlength); % fissazione: orizzontale
    %aid up right
    Screen('DrawLine', w, white, xc+punto2x-fixationlength, yc+punto2y, xc+punto2x, yc+punto2y); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto2x, yc+punto2y, xc+punto2x, yc+punto2y+fixationlength); % fissazione: orizzontale
    %aid down right
    Screen('DrawLine', w, white, xc+punto3x-fixationlength, yc+punto3y, xc+punto3x, yc+punto3y); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto3x, yc+punto3y-fixationlength, xc+punto3x, yc+punto3y); % fissazione: orizzontale
    %aid down left
    Screen('DrawLine', w, white, xc+punto4x, yc+punto4y, xc+punto4x+fixationlength, yc+punto4y); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto4x, yc+punto4y-fixationlength, xc+punto4x, yc+punto4y); % fissazione: orizzontale
    vbl = Screen('Flip', w); % show fixation
    pause(waittime)
elseif fixat==7
    
    
        p1x=-8;
    p1y=-8;
    p2x=8;
    p2y=-8;
    p3x=8;
    p3y=8;
    p4x=-8;
    p4y=8;
    
    punto1x=p1x*pix_deg;
    punto1y=p1y*pix_deg;
    punto2x=p2x*pix_deg;
    punto2y=p2y*pix_deg;
    punto3x=p3x*pix_deg;
    punto3y=p3y*pix_deg;
    punto4x=p4x*pix_deg;
    punto4y=p4y*pix_deg;
    
fixationlength = 40; 
fixationlengthx = wRect(3)/2;
fixationlengthy = wRect(4)/2;
    
    for ft = 1:FixAnimationDuration
        
            Screen('DrawLine', w, white, xc, yc-fixationlengthy, xc, yc+fixationlengthy); % fissazione: verticale
    Screen('DrawLine', w, white, xc-fixationlengthx, yc, xc+fixationlengthx, yc); % fissazione: orizzontale
    
    %aid up left
    Screen('DrawLine', w, white, xc+punto1x, yc+punto1y, xc+punto1x+fixationlength, yc+punto1y); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto1x, yc+punto1y, xc+punto1x, yc+punto1y+fixationlength); % fissazione: orizzontale
    %aid up right
    Screen('DrawLine', w, white, xc+punto2x-fixationlength, yc+punto2y, xc+punto2x, yc+punto2y); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto2x, yc+punto2y, xc+punto2x, yc+punto2y+fixationlength); % fissazione: orizzontale
    %aid down right
    Screen('DrawLine', w, white, xc+punto3x-fixationlength, yc+punto3y, xc+punto3x, yc+punto3y); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto3x, yc+punto3y-fixationlength, xc+punto3x, yc+punto3y); % fissazione: orizzontale
    %aid down left
    Screen('DrawLine', w, white, xc+punto4x, yc+punto4y, xc+punto4x+fixationlength, yc+punto4y); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto4x, yc+punto4y-fixationlength, xc+punto4x, yc+punto4y); % fissazione: orizzontale                  
        Screen('FillOval', w, white, [xc yc xc yc]+...
            [-FixSizeTime(ft)/2 -FixSizeTime(ft)/2 FixSizeTime(ft)/2 FixSizeTime(ft)/2]);
        Screen('DrawDots', w, [xc;yc], FixDotSize, white,[],1);
        %Screen('FrameRect', win, black, FrameRect, 2);
        Screen('Flip',w);
        pause(1/60);
    end
    Screen('Flip',w);
    pause(waittime)
    
    elseif fixat==8
        
        
      %  load AMD55.mat
        
%         AMD.p1x=-8;
%         AMD.p1y=-8;
%         AMD.p2x=8;
%         AMD.p2y=-8;
%         AMD.p3x=8;
%         AMD.p3y=8;
%         AMD.p4x=-8;
%         AMD.p4y=8;
    
    punto1x=AMD.p1x*pix_deg;
    punto1y=AMD.p1y*pix_deg;
    punto2x=AMD.p2x*pix_deg;
    punto2y=AMD.p2y*pix_deg;
    punto3x=AMD.p3x*pix_deg;
    punto3y=AMD.p3y*pix_deg;
    punto4x=AMD.p4x*pix_deg;
    punto4y=AMD.p4y*pix_deg;
    
fixationlength = 40; 
fixationlengthx = wRect(3)/2;
fixationlengthy = wRect(4)/2;
    

   
Screen('FillArc',w,white,[],357.5,5)
Screen('FillArc',w,white,[],85,8)
Screen('FillArc',w,white,[],177.5,5)
Screen('FillArc',w,white,[],265,8)

    
%    Screen('DrawLine', w, white, xc, yc-fixationlengthy, xc, yc+fixationlengthy); % fissazione: verticale
 %   Screen('DrawLine', w, white, xc-fixationlengthx, yc, xc+fixationlengthx, yc); % fissazione: orizzontale
    
    %aid up left
    Screen('DrawLine', w, white, xc+punto1x, yc+punto1y, xc+punto1x+fixationlength, yc+punto1y,AMD.thick); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto1x, yc+punto1y, xc+punto1x, yc+punto1y+fixationlength,AMD.thick); % fissazione: orizzontale
    %aid up right
    Screen('DrawLine', w, white, xc+punto2x-fixationlength, yc+punto2y, xc+punto2x, yc+punto2y,AMD.thick); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto2x, yc+punto2y, xc+punto2x, yc+punto2y+fixationlength,AMD.thick); % fissazione: orizzontale
    %aid down right
    Screen('DrawLine', w, white, xc+punto3x-fixationlength, yc+punto3y, xc+punto3x, yc+punto3y,AMD.thick); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto3x, yc+punto3y-fixationlength, xc+punto3x, yc+punto3y,AMD.thick); % fissazione: orizzontale
    %aid down left
    Screen('DrawLine', w, white, xc+punto4x, yc+punto4y, xc+punto4x+fixationlength, yc+punto4y,AMD.thick); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto4x, yc+punto4y-fixationlength, xc+punto4x, yc+punto4y,AMD.thick); % fissazione: orizzontale
    vbl = Screen('Flip', w); % show fixation
    pause(durationtime)
Screen('Flip', w);
    pause(waittime)
    
     elseif fixat==9
        
        
      %  load AMD55.mat
        
%         AMD.p1x=-8;
%         AMD.p1y=-8;
%         AMD.p2x=8;
%         AMD.p2y=-8;
%         AMD.p3x=8;
%         AMD.p3y=8;
%         AMD.p4x=-8;
%         AMD.p4y=8;
    
    punto1x=AMD.p1x*pix_deg;
    punto1y=AMD.p1y*pix_deg;
    punto2x=AMD.p2x*pix_deg;
    punto2y=AMD.p2y*pix_deg;
    punto3x=AMD.p3x*pix_deg;
    punto3y=AMD.p3y*pix_deg;
    punto4x=AMD.p4x*pix_deg;
    punto4y=AMD.p4y*pix_deg;
    
fixationlength = 40; 
fixationlengthx = wRect(3)/2;
fixationlengthy = wRect(4)/2;
    

   
Screen('FillArc',w,0.65,[],357.5,5)
Screen('FillArc',w,0.65,[],85,8)
Screen('FillArc',w,0.65,[],177.5,5)
Screen('FillArc',w,0.65,[],265,8)

    
%    Screen('DrawLine', w, white, xc, yc-fixationlengthy, xc, yc+fixationlengthy); % fissazione: verticale
 %   Screen('DrawLine', w, white, xc-fixationlengthx, yc, xc+fixationlengthx, yc); % fissazione: orizzontale
    
    %aid up left
    Screen('DrawLine', w, 0.65, xc+punto1x, yc+punto1y, xc+punto1x+fixationlength, yc+punto1y,AMD.thick); % fissazione: verticale
    Screen('DrawLine', w, 0.65, xc+punto1x, yc+punto1y, xc+punto1x, yc+punto1y+fixationlength,AMD.thick); % fissazione: orizzontale
    %aid up right
    Screen('DrawLine', w, 0.65, xc+punto2x-fixationlength, yc+punto2y, xc+punto2x, yc+punto2y,AMD.thick); % fissazione: verticale
    Screen('DrawLine', w, 0.65, xc+punto2x, yc+punto2y, xc+punto2x, yc+punto2y+fixationlength,AMD.thick); % fissazione: orizzontale
    %aid down right
    Screen('DrawLine', w, 0.65, xc+punto3x-fixationlength, yc+punto3y, xc+punto3x, yc+punto3y,AMD.thick); % fissazione: verticale
    Screen('DrawLine', w, 0.65, xc+punto3x, yc+punto3y-fixationlength, xc+punto3x, yc+punto3y,AMD.thick); % fissazione: orizzontale
    %aid down left
    Screen('DrawLine', w, 0.65, xc+punto4x, yc+punto4y, xc+punto4x+fixationlength, yc+punto4y,AMD.thick); % fissazione: verticale
    Screen('DrawLine', w, 0.65, xc+punto4x, yc+punto4y-fixationlength, xc+punto4x, yc+punto4y,AMD.thick); % fissazione: orizzontale
    vbl = Screen('Flip', w); % show fixation
    pause(durationtime)
% Screen('Flip', w);
   %  pause(waittime)
%     
elseif fixat==0;
    
    vbl = Screen('Flip', w); % show fixation
    
    pause(waittime)
end;
    return;