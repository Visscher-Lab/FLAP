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

f_gabor=(sfs/pix_deg)*2*pi;
a=cos(rot)*f_gabor;
b=sin(rot)*f_gabor;
m=maxcontrast*sin(a*x0Small+b*y0Small+pi).*G;
TheGaborsSmall=Screen('MakeTexture', w, midgray+inc*m,[],[],2);

%set the limit for stimuli position along x and y axis
xLim=((wRect(3)-(2*imsize))/pix_deg)/2; %bpk: this is in degrees
yLim=((wRect(4)-(2*imsize))/pix_deg_vert)/2;
imageRectSmall = CenterRect([0, 0, size(x0Small)], wRect);


% size of the grid for the contour task
xs=7;
ys=7;

[x1,y1]=meshgrid(-xs:xs,-ys:ys); %possible positions of Gabors within grid; in degrees of visual angle

JitRat=2; % amount of jit ratio (the larger the value the less jitter)
Oscat= 0.5;

xlocsCI=x1(:)';
ylocsCI=y1(:)';
%ecccoeffCI=3; %original
ecccoeffCI=1.8; %marcello changed it to 1.8
%generate visual cue

eccentricity_XCI=xlocsCI*pix_deg/ecccoeffCI;
eccentricity_YCI=ylocsCI*pix_deg/ecccoeffCI;

coeffCI=ecccoeffCI/2;


Tcontr=0.938;         %target contrast
%Dcontr=0.38;        %distractor contrast
Dcontr=0.938;

ssf=1;
% texture(trial)=TheGabors(sf);
Tscat=0; %but we will define the jitter threshold later
GoodBlock=0;
Tc=1;
xmax=2*xs+1; %total number of squares in grid, along x direction (17)
ymax=2*ys+1; %total number of squares in grid, along x direction (13)

xTrans=round(xmax/2); %Translate target left/right or up/down within grid
yTrans=round(ymax/2);


clear Targori Targx Targy offsetx offsety

% % eggs ------------------------------------------------------------------
% xfoo= [-4    -4    -4    -3    -3    -2    -2    -1    -1     0     0     1     1     2     2     2];
% yfoo = [-1     0     1    -1     1    -2     2    -2     2    -2     2    -2     2    -1     0 1];
%
% orifoo=    [35     0   -35    50   -45    55   -55    65   -70    90    90   -55    55   -30     0 35];
% twoorifoo= [ -35     0    35   -50    45   -55    55   -65    70    90    90    55   -55    30     0 -35];
%
%
% Xoff=[   -0.2198   -0.0122   -0.1954   -0.0855   -0.0488   -0.0122    0.0244         0    0.0367   0         0   -0.0611         0    0.1221    0.0122    0.1587];
% Yoff=[   -0.1832   -0.0367    0.0244    0.0977   -0.2320   -0.2198    0.1466   -0.0488   -0.0122    0         0   -0.1221    0.0855    0.0244    0.0122   -0.0732];
%
% Targx= [xfoo; -xfoo];
% Targy= [yfoo; yfoo];
% Targori=[orifoo;twoorifoo];
%
% offsetx= [-Xoff; Xoff];
% offsety=[-Yoff; -Yoff];
% % 9 vs 6 ------------------------------------------------------------------
% xfoonum= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1];
% yfoonum= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  4];
% orifoonum=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 150] ;
%
%
% Xoffnum= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0];
% Yoffnum= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 1/4];
%
% Targxnum= [xfoonum; -xfoonum];
% Targynum= [yfoonum; -yfoonum];
%
% Targorinum=[orifoonum; orifoonum];
%
% offsetxnum= [Xoffnum; -Xoffnum];
% offsetynum=[Yoffnum; -Yoffnum];


%     yfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  4];
%     xfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1];
%     orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 150] ;
%
%
%     Xoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0];
%     Yoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 1/4];
%     Targx= [xfoo; -xfoo];
%     Targy= [yfoo; -yfoo];
%
%     Targori=[orifoo; orifoo];
%
%     offsetx= [Xoff; -Xoff];
%     offsety=[Yoff; -Yoff];
% %d/b
% Targx= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1
%     2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
% Targy=[-1      0       1       -2      2       -2      2       -2      -1      0       1       2       -3       -4       -5
%     -1      0       1       -2      2       -2      2       -2       2      -1       1       0       -3       -4       -5];
% 
% Targori =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
%     150     0       30     120      60     90      90      0       0       0       0       0       0       0       0];
% 
% Xoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0];
% Yoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0];
% 
% offsetx= [Xoff; -Xoff];
% offsety=[Yoff; -Yoff];
% %q and p
% Targx= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1
%     2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
% Targy=[-1      0       1       -2      2       -2      2       -2      -1      0       1       2       3       4       5
%     -1      0       1       -2      2       -2      2       -2       2      -1       1       0       3       4       5];
% 
% Targori =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
%     150     0       30     120      60     90      90      0       0       0       0       0       0       0       0];
% 
% Xoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0];
% Yoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0];
% 
% offsetx= [-Xoff; Xoff];
% offsety=[-Yoff; -Yoff];


%d/p
Targx= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1
    2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
Targy=[-1      0       1       -2      2       -2      2       -2      -1      0       1       2       -3       -4       -5
     -1      0       1       -2      2       -2      2       -2       2      -1       1       0       3       4       5];

Targori =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
    150     0       30     120      60     90      90      0       0       0       0       0       0       0       0];

Xoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0];
Yoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0];

offsetx= [Xoff; -Xoff];
offsety=[Yoff; -Yoff];