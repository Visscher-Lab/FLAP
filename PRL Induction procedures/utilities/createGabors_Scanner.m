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

gaborcontrast=0.35;
theoris =[-45 45]; % whether right or left oriented gabor