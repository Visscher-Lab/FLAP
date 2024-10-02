        %create noise patch
        noise_level= 0.75;
        %m bewlow comes from createGabors
        if  noisestop==0
        noisemat=rand(length(m), length(m))*noise_level+0.5;
        noisemat(noisemat>1)=1;
        noisemat(noisemat<1)=0;
        noisetex=Screen('MakeTexture', w, noisemat, [], [],2); 
        end
        
        maskRect=[0, 0, length(m), length(m)];
        dstRect=CenterRectOnPoint(maskRect, wRect(3)/2, wRect(4)/2);       
        aperture= Screen ('OpenOffscreenwindow', w, 0.5, maskRect);