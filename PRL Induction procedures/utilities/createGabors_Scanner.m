        %create Gabor
        
            sigma_pix = sigma_deg*pix_deg; % Gabor sigma
        max_contrast=1;
        sflist=[1 2 3 4:2:18]; %cpd
        G = exp(-((ax/sigma_pix).^2)-((ay/sigma_pix).^2));
        fixationlength = 10; % pixels
        [r, c] = size(G);
        phases= [pi, pi/2, 2/3*pi, 1/3*pi];
        
        circle = ax.^2 + ay.^2 <= imsize^2;         %circular mask for Gabor patch
        rot=0*pi/180; %redundant but theoretically correct
        for i=1:(length(sflist))
            for g=1:length(phases)
                f_gabor=(sflist(i)/pix_deg)*2*pi;
                a=cos(rot)*f_gabor;
                b=sin(rot)*f_gabor;
                m=max_contrast*sin(a*ax+b*ay+phase(phases(g))).*G;
                m=m+midgray;
                m = double(circle) .* double(m)+midgray * ~double(circle);
                TheGabors(i,g)=Screen('MakeTexture', w, m,[],[],2);
            end;
        end;

    %     imsizeBig=sigma_pixBig*2.5;
    %     [x0Big,y0Big]=meshgrid(-imsizeBig:imsizeBig,-imsizeBig:imsizeBig);
    %     G = exp(-((x0Big/sigma_pixBig).^2)-((y0Big/sigma_pixBig).^2));
    %     for i=1:(length(sfs))  %bpk: note that sfs has only one element
    %         f_gabor=(sfs(i)/pix_deg)*2*pi;
    %         a=cos(rot)*f_gabor;
    %         b=sin(rot)*f_gabor;
    %         m=maxcontrast*sin(a*x0Big+b*y0Big+pi).*G;
    %         TheGaborsBig(i)=Screen('MakeTexture', w, midgray+inc*m,[],[],2);
    %     end