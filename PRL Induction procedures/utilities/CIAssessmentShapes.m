clear a b m f_gabor
%contour integration gabor dimensions
sigma_degSmall=0.1; % CI Gabor size in deg
sfs=3; % spatial frequency CI Gabor
sigma_pixSmall = sigma_degSmall*pix_deg;
imsizeSmall=sigma_pixSmall*2.5;
[x0Small,y0Small]=meshgrid(-imsizeSmall:imsizeSmall,-imsizeSmall:imsizeSmall);
G = exp(-((x0Small/sigma_pixSmall).^2)-((y0Small/sigma_pixSmall).^2));
[r, c] = size(G);
midgray=0.5;
%creating gabor images
rot=0*pi/180; %redundant but theoretically correct
maxcontrast=1; %0.15; %same
inc=1;
for i=1:(length(sfs))  %bpk: note that sfs has only one element
    f_gabor=(sfs(i)/pix_deg)*2*pi;
    a=cos(rot)*f_gabor;
    b=sin(rot)*f_gabor;
    m=maxcontrast*sin(a*x0Small+b*y0Small+pi).*G;
    TheGaborsSmall(i)=Screen('MakeTexture', w, midgray+inc*m,[],[],2);
end
%set the limit for stimuli position along x and y axis
xLim=((wRect(3)-(2*imsize))/pix_deg)/2; %bpk: this is in degrees
yLim=((wRect(4)-(2*imsize))/pix_deg_vert)/2;
imageRectSmall = CenterRect([0, 0, size(x0Small)], wRect);
% size of the grid for the contour task
xs=7;%60; 12;
ys=7; %45;9;
[x1,y1]=meshgrid(-xs:xs,-ys:ys); %possible positions of Gabors within grid; in degrees of visual angle
JitRat=1; % amount of jit ratio (the larger the value the less jitter)
JitRat=4; % amount of jit ratio (the larger the value the less jitter)
Oscat= 0.5; %JitList(thresh(Ts,Tc));
xlocsCI=x1(:)';
ylocsCI=y1(:)';
ecccoeffCI=3;

%generate visual cue
eccentricity_XCI=xlocsCI*pix_deg/ecccoeffCI;
eccentricity_YCI=ylocsCI*pix_deg/ecccoeffCI;
coeffCI=ecccoeffCI/2;
Tcontr=0.938;         %target contrast
Dcontr=0.38;        %distractor contrast
ssf=1;
Tscat=0; %but we will define the jitter threshold later
GoodBlock=0;
Tc=1;
xmax=2*xs+1; %total number of squares in grid, along x direction (17)
ymax=2*ys+1; %total number of squares in grid, along x direction (13)
xTrans=round(xmax/2); %Translate target left/right or up/down within grid
yTrans=round(ymax/2);
clear Targori Targx Targy offsetx offsety
shapeMatrix=[];

% 2 vs 5 snakes
xfoo=[-1    -1    -1    -1     0     0     0     1     1     1     1];
yfoo=[-2     0     1     2    -2     0     2    -2    -1     0     2];
Xoff= [-0.1063  -0.0850      0   -0.1700       0       0       0    0.1700       0    0.1913    0.1700];
Yoff= [-0.1488  -0.1700      0    0.1488       0       0       0   -0.1275       0    0.2126    0.0850];
Targx{2}= [xfoo; -xfoo];
Targy{2}= [yfoo; yfoo];
Targori{2}=[  60   225   180   135    90    90    90   135   180   225    70
             -60  -225   180  -135    90    90    90  -135   180  -225   -70 ];
offsetx{2}= [-Xoff; Xoff];
offsety{2}=[-Yoff; -Yoff];

% d vs p
Targx{3}= [ -2    -2    -2    -1    -1     0     0     1     1     2     2     2      2      2     2
            -2    -2    -2    -1    -1     0     0     1     1     2     2     2     -2     -2     -2];
Targy{3} = [-1     0     1    -2     2    -2     2    -2     2    -1     0     1     -2     -3     -4
            -1     0     1    -2     2    -2     2    -2     2    -1     0     1     2     3     4];
Targori{3} =[30     0   150    60   120    90    90   120    60   150     0    30     0     0     0
             30     0   150    60   120    90    90   120    60   150     0    30     0     0     0];
Xoff=[0    0.2193         0         0         0         0         0         0         0   0   -0.1462      0      0      0      0];
Yoff=[0         0         0         0         0    0.1096   -0.1827         0         0   0         0      0      0      0      0];
offsetx{3}= [-Xoff; -Xoff];
offsety{3}=[-Yoff; -Yoff];

