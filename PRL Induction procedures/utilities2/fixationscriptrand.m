%fixation contingent tasks



 fixationlength = 40; 

 widthfix=5;
    p1x=-(scotomadeg/2+1);
    p1y=-(scotomadeg/2+1);
    p2x=(scotomadeg/2+1);
    p2y=-(scotomadeg/2+1);
    p3x=(scotomadeg/2+1);
    p3y=(scotomadeg/2+1);
    p4x=-(scotomadeg/2+1);
    p4y=(scotomadeg/2+1);
    
    
    punto1x=p1x*pix_deg;
    punto1y=p1y*pix_deg;
    punto2x=p2x*pix_deg;
    punto2y=p2y*pix_deg;
    punto3x=p3x*pix_deg;
    punto3y=p3y*pix_deg;
    punto4x=p4x*pix_deg;
    punto4y=p4y*pix_deg;
    %aid up left
    
    Screen('DrawLine', w, white, xcrand+punto1x, ycrand+punto1y, xcrand+punto1x+fixationlength, ycrand+punto1y, widthfix); % fissazione: verticale
    Screen('DrawLine', w, white, xcrand+punto1x, ycrand+punto1y, xcrand+punto1x, ycrand+punto1y+fixationlength, widthfix); % fissazione: orizzontale
    %aid up right
    Screen('DrawLine', w, white, xcrand+punto2x-fixationlength, ycrand+punto2y, xcrand+punto2x, ycrand+punto2y, widthfix); % fissazione: verticale
    Screen('DrawLine', w, white, xcrand+punto2x, ycrand+punto2y, xcrand+punto2x, ycrand+punto2y+fixationlength, widthfix); % fissazione: orizzontale
    %aid down right
    Screen('DrawLine', w, white, xcrand+punto3x-fixationlength, ycrand+punto3y, xcrand+punto3x, ycrand+punto3y, widthfix); % fissazione: verticale
    Screen('DrawLine', w, white, xcrand+punto3x, ycrand+punto3y-fixationlength, xcrand+punto3x, ycrand+punto3y, widthfix); % fissazione: orizzontale
    %aid down left
    Screen('DrawLine', w, white, xcrand+punto4x, ycrand+punto4y, xcrand+punto4x+fixationlength, ycrand+punto4y, widthfix); % fissazione: verticale
    Screen('DrawLine', w, white, xcrand+punto4x, ycrand+punto4y-fixationlength, xcrand+punto4x, ycrand+punto4y, widthfix); % fissazione: orizzontale
 %   vbl = Screen('Flip', w); % show fixation