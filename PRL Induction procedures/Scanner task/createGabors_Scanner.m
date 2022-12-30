%create Gabor

sigma_pix = sigma_deg*pix_deg; % Gabor sigma
max_contrast=1;
sf=3; %cpd
G = exp(-((ax/sigma_pix).^2)-((ay/sigma_pix).^2));
%fixationlength = 10; % pixels
[r, c] = size(G);
phase= 0;

circle = ax.^2 + ay.^2 <= imsize^2;         %circular mask for Gabor patch
rot=0*pi/180; %redundant but theoretically correct

f_gabor=(sf/pix_deg)*2*pi;
a=cos(rot)*f_gabor;
b=sin(rot)*f_gabor;
m=max_contrast*sin(a*ax+b*ay+phase).*G;
m=m+midgray;
m = double(circle) .* double(m)+midgray * ~double(circle);
TheGabors=Screen('MakeTexture', w, m,[],[],2);



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