%PreparePRLpatch
        oval_thick=10; %thickness of oval

    PRLecc=[7.5 0 ]; %eccentricity of PRLs

     PRLx= PRLecc(1);
        PRLy=-PRLecc(2);
    PRLxpix=PRLx*pix_deg;
    PRLypix=PRLy*pix_deg_vert;
PRLsize=5;
    [sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);

        radiusPRL=(PRLsize/2)*pix_deg;
        circlePixelsPRL=sx.^2 + sy.^2 <= radiusPRL.^2;
        
                        imageRectcue = CenterRect([0, 0, [radiusPRL*2 ((radiusPRL/pix_deg)*pix_deg_vert)*2]], wRect);
    [img, sss, alpha] =imread('neutral21.png');
    img(:, :, 4) = alpha;
    Neutralface=Screen('MakeTexture', w, img);