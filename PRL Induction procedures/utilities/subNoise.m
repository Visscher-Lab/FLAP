        %create noise patch
       % noise_level= 0.3175;
        %m bewlow comes from createGabors
        if  noisestop==0
%         noisemat=rand(length(m), length(m))*noise_level+0.5;
%         noisemat(noisemat>1)=1;
%         noisemat(noisemat<1)=0;
%         noisetex=Screen('MakeTexture', w, noisemat, [], [],2); 
%         
        
  %                  sigma_pix = sigma_deg*pix_deg; % Gabor sigma
        max_contrast=contr;
     %   sflist=[1 2 3 4:2:18]; %cpd
     sflist=sf;
        G = exp(-((ax/sigma_pix).^2)-((ay/sigma_pix).^2));
        fixationlength = 10; % pixels
        [r, c] = size(G);
        phases= [pi, pi/2, 2/3*pi, 1/3*pi];
        phases= [rand rand rand]*pi;
        circle = ax.^2 + ay.^2 <= imsize^2;         %circular mask for Gabor patch
        rot=0*pi/180; %redundant but theoretically correct
                f_gabor=(sflist(1)/pix_deg)*2*pi;
                a=cos(rot)*f_gabor;
                b=sin(rot)*f_gabor;
                m=max_contrast*sin(a*ax+b*ay+phase(phases(3))).*G;
                m=m+midgray;
                m = double(circle) .* double(m)+midgray * ~double(circle);
         %create noise
         noisemat=rand(length(m));
 %       noisemat(noisemat>1)=1;
%        noisemat(noisemat<1)=0;
        
        % replace signal with noise
        idx=randperm(numel(noisemat));
        idx=idx(1:round(numel(noisemat)*(1-noise_level)));
        m(idx)=noisemat(idx);
                TheGabors=Screen('MakeTexture', w, m,[],[],2);
        
        TheNoise=Screen('MakeTexture', w, noisemat,[],[],2);
        end