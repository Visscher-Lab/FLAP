%fixation contingent tasks

CardinalOrdiagonal=1;

inward=1;
fixationlength = 30;
widthWag=10;
widthfix=7;
squaresize=10;
wsquaresize=20;
distWag=0;

imageRectW = CenterRect([0, 0, round(squaresize*pix_deg) round(squaresize*pix_deg)], wRect);
imageRectWW=CenterRect([0, 0, round(wsquaresize*pix_deg) round(wsquaresize*pix_deg)], wRect);

cornerDist=scotomadeg/2*1; % to make the fixation brackets smaller or larger. >1 - larger, <1 - smaller
p1x=-cornerDist;
p1y=  - cornerDist ;
p2x=cornerDist;
p2y=-cornerDist;
p3x=cornerDist;
p3y=cornerDist;
p4x=-cornerDist;
p4y=cornerDist;

punto1x=p1x*pix_deg;
punto1y=p1y*pix_deg;
punto2x=p2x*pix_deg;
punto2y=p2y*pix_deg;
punto3x=p3x*pix_deg;
punto3y=p3y*pix_deg;
punto4x=p4x*pix_deg;
punto4y=p4y*pix_deg;

%aid up left

color_w=0.3*white; % color of the wedges
if CardinalOrdiagonal==1
    diagon=45;
else
    diagon=0;
end
if color_w>1
    color_w=round(color_w);
end


imageRectLeft=[imageRectWW(1)-(round(distWag*pix_deg)) imageRectWW(2) imageRectWW(3)-(round(distWag*pix_deg)) imageRectWW(4) ];
imageRectRight=[imageRectWW(1)+(round(distWag*pix_deg)) imageRectWW(2) imageRectWW(3)+(round(distWag*pix_deg)) imageRectWW(4) ];
imageRectDown=[imageRectWW(1) imageRectWW(2)+(round(distWag*pix_deg)) imageRectWW(3) imageRectWW(4)+(round(distWag*pix_deg)) ];
imageRectUp=[imageRectWW(1) imageRectWW(2)-(round(distWag*pix_deg)) imageRectWW(3) imageRectWW(4)-(round(distWag*pix_deg)) ];



if inward==1
    
    
    Screen('FillArc',w,color_w,imageRectDown,360-(widthWag/2)-180-diagon,widthWag)
    Screen('FillArc',w,color_w,imageRectLeft,90-(widthWag/2)-180-diagon,widthWag)
    Screen('FillArc',w,color_w,imageRectUp,180-(widthWag/2)-180-diagon,widthWag)
    Screen('FillArc',w,color_w,imageRectRight,270-(widthWag/2)-180-diagon,widthWag)
    
    
else
    Screen('FillArc',w,color_w,imageRectDown,360-(widthWag/2)-diagon,widthWag)
    Screen('FillArc',w,color_w,imageRectLeft,90-(widthWag/2)-diagon,widthWag)
    Screen('FillArc',w,color_w,imageRectUp,180-(widthWag/2)-diagon,widthWag)
    Screen('FillArc',w,color_w,imageRectRight,270-(widthWag/2)-diagon,widthWag)
end

Screen('DrawLine', w, white, xc+punto1x, yc+punto1y, xc+punto1x+fixationlength, yc+punto1y, widthfix); % fixation: verticale
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
