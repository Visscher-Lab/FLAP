%fixation contingent tasks


inward=1;
 fixationlength = 40; 
widthWag=10;
 widthfix=7;
 squaresize=10;
  wsquaresize=20;
distWag=15;

     imageRectW = CenterRect([0, 0, round(squaresize*pix_deg) round(squaresize*pix_deg)], wRect);
     imageRectWW=CenterRect([0, 0, round(wsquaresize*pix_deg) round(wsquaresize*pix_deg)], wRect);
%imageRectW=imageRect(1)
%     p1x=-(scotomadeg/25+1);
%     p1y=-(scotomadeg/25+1);
%     p2x=(scotomadeg/25+1);
%     p2y=-(scotomadeg/25+1);
%     p3x=(scotomadeg/25+1);
%     p3y=(scotomadeg/25+1);
%     p4x=-(scotomadeg/25+1);
%     p4y=(scotomadeg/25+1);
%   

newyc=yc+(fixbox*pix_deg);

cornerDist=scotomadeg/2;

        p1x=-cornerDist;
    p1y=-cornerDist;
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
    
    color_w=0.65*white;
   
    if color_w>1
    color_w=round(color_w);
    end
    
    Screen('DrawLine', w, white, xc+punto1x, newyc+punto1y, xc+punto1x+fixationlength, newyc+punto1y, widthfix); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto1x, newyc+punto1y, xc+punto1x, newyc+punto1y+fixationlength, widthfix); % fissazione: orizzontale
    %aid up right
    Screen('DrawLine', w, white, xc+punto2x-fixationlength, newyc+punto2y, xc+punto2x, newyc+punto2y, widthfix); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto2x, newyc+punto2y, xc+punto2x, newyc+punto2y+fixationlength, widthfix); % fissazione: orizzontale
    %aid down right
    Screen('DrawLine', w, white, xc+punto3x-fixationlength, newyc+punto3y, xc+punto3x, newyc+punto3y, widthfix); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto3x, newyc+punto3y-fixationlength, xc+punto3x, newyc+punto3y, widthfix); % fissazione: orizzontale
    %aid down left
    Screen('DrawLine', w, white, xc+punto4x, newyc+punto4y, xc+punto4x+fixationlength, newyc+punto4y, widthfix); % fissazione: verticale
    Screen('DrawLine', w, white, xc+punto4x, newyc+punto4y-fixationlength, xc+punto4x, newyc+punto4y, widthfix); % fissazione: orizzontale
 %   vbl = Screen('Flip', w); % show fixation
 
%  if inward==1
%  Screen('FillArc',w,color_w,[],360-(widthWag/2),widthWag)
% %  Screen('FillArc',w,color_w,[],360-(widthWag/2)357.5,widthWag)
% Screen('FillArc',w,color_w,[],90-(widthWag/2),widthWag)
% Screen('FillArc',w,color_w,[],180-(widthWag/2),widthWag)
% Screen('FillArc',w,color_w,[],270-(widthWag/2),widthWag)
%  else
%     
%      imageRectLeft=[imageRectWW(1)-(round(distWag*pix_deg)) imageRectWW(2) imageRectWW(3)-(round(distWag*pix_deg)) imageRectWW(4) ];
%           imageRectDown=[imageRectWW(1) imageRectWW(2)+(round(distWag*pix_deg)) imageRectWW(3) imageRectWW(4)+(round(distWag*pix_deg)) ];
%           imageRectUp=[imageRectWW(1) imageRectWW(2)-(round(distWag*pix_deg)) imageRectWW(3) imageRectWW(4)-(round(distWag*pix_deg)) ];
%      imageRectRight=[imageRectWW(1)+(round(distWag*pix_deg)) imageRectWW(2) imageRectWW(3)+(round(distWag*pix_deg)) imageRectWW(4) ];
% 
% Screen('FillArc',w,color_w,imageRectDown,360-(widthWag/2),widthWag)
% Screen('FillArc',w,color_w,imageRectLeft,90-(widthWag/2),widthWag)
% Screen('FillArc',w,color_w,imageRectUp,180-(widthWag/2),widthWag)
% Screen('FillArc',w,color_w,imageRectRight,270-(widthWag/2),widthWag)
%  end
    % Screen('FillRect', w, [0 0 200],imageRectW);
%     Screen('FillRect', w, gray,imageRectW);
