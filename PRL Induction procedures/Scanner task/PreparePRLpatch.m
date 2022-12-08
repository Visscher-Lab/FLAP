%PreparePRLpatch

%diagonal PRL
%PRLecc=[-5.3 -5.3 ]; %eccentricity of PRLs

PRLx= PRLecc(1);
PRLy=-PRLecc(2);
PRLxpix=PRLx*pix_deg*coeffAdj;
PRLypix=PRLy*pix_deg*coeffAdj;
PRLsize=5;
[sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);

radiusPRL=(PRLsize/2)*pix_deg;
circlePixelsPRL=sx.^2 + sy.^2 <= radiusPRL.^2;

imageRectcue = CenterRect([0, 0, [radiusPRL*2 ((radiusPRL/pix_deg)*pix_deg_vert)*2]], wRect);

% mask to cover the target when outside the TRL (if needed)
[img, sss, alpha] =imread('neutral21.png');
img(:, :, 4) = alpha;
Neutralface=Screen('MakeTexture', w, img);

mask_color= [170 170 170];