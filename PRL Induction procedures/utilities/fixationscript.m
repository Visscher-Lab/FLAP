%fixation contingent tasks



 fixationlength = 40; 

 widthfix=5;
    p1x=-4;
    p1y=-4;
    p2x=4;
    p2y=-4;
    p3x=4;
    p3y=4;
    p4x=-4;
    p4y=4;
    
    
    punto1x=p1x*pix_deg;
    punto1y=p1y*pix_deg;
    punto2x=p2x*pix_deg;
    punto2y=p2y*pix_deg;
    punto3x=p3x*pix_deg;
    punto3y=p3y*pix_deg;
    punto4x=p4x*pix_deg;
    punto4y=p4y*pix_deg;
    %aid up left
    
    Screen('DrawLine', w, white, xc+punto1x, yc+punto1y, xc+punto1x+fixationlength, yc+punto1y, widthfix); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto1x, yc+punto1y, xc+punto1x, yc+punto1y+fixationlength, widthfix); % fissazione: orizzontale
    %aid up right
    Screen('DrawLine', w, white, xc+punto2x-fixationlength, yc+punto2y, xc+punto2x, yc+punto2y, widthfix); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto2x, yc+punto2y, xc+punto2x, yc+punto2y+fixationlength, widthfix); % fissazione: orizzontale
    %aid down right
    Screen('DrawLine', w, white, xc+punto3x-fixationlength, yc+punto3y, xc+punto3x, yc+punto3y, widthfix); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto3x, yc+punto3y-fixationlength, xc+punto3x, yc+punto3y, widthfix); % fissazione: orizzontale
    %aid down left
    Screen('DrawLine', w, white, xc+punto4x, yc+punto4y, xc+punto4x+fixationlength, yc+punto4y, widthfix); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto4x, yc+punto4y-fixationlength, xc+punto4x, yc+punto4y, widthfix); % fissazione: orizzontale
 %   vbl = Screen('Flip', w); % show fixation