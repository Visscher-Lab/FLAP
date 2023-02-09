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

Oscat= 0.5; %JitList(thresh(Ts,Tc));

xlocsCI=x1(:)';
ylocsCI=y1(:)';
ecccoeffCI=3; % grid separation
ecccoeffCI=1.8;

CIstimulussize=stimulusSize*2.6*pix_deg;
%generate visual cue

eccentricity_XCI=xlocsCI*pix_deg/ecccoeffCI;
eccentricity_YCI=ylocsCI*pix_deg/ecccoeffCI;

coeffCI=ecccoeffCI/2;


Tcontr=0.1938;         %target contrast
Dcontr=0.98;        %distractor contrast


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
shapeMatrix=[];

%% 9 vs 6 ------------------------------------------------------------------
xfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1];
yfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  4];
orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 150] ;


Xoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0];
Yoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 1/4];

Targx{1}= [xfoo; -xfoo];
Targy{1}= [yfoo; -yfoo];

Targori{1}=[orifoo; orifoo];

offsetx{1}= [Xoff; -Xoff];
offsety{1}=[Yoff; -Yoff];
clear Xoff Yoff xfoo yfoo orifoo
%% 2 vs 5 snakes -----------------------------------------------------------

Targx{2}= [2    2    2   1   1   0   0   -1  -1  -2  -2  -2     0   -1      1
          -2   -2   -2  -1  -1   0   0    1   1   2   2   2     0    1     -1];
Targy{2} =[-1   0   1   -2   2  -2   2    2   6   3   5   4     6   -2      6
           -1   0   1   -2   2  -2   2    2   6   3   5   4     6   -2      6];

Targori{2} =[150    0   30      120     60      90      90      60      120   30     150      0     90      60     60
             30     0   150     60      120     90      90      120     60   150      30      0     90     120      120];

Xoff=[0 0.2193  0 0 0   0        0      0       0 0 0 -0.2193   0       0   0];
Yoff=[0 0       0 0 0 0.1096 -0.1827 -0.1827    0 0 0   0    -0.1827    0   0];

offsetx{2}= [Xoff; -Xoff];
offsety{2}=[-Yoff; -Yoff];
clear Xoff Yoff

% Infinity and 8 ----------------------------------------------------------
% Targx{2}= [-1   0   1   -2   2  -2   2    2   6   3   5   4     6   -2      6       -1      5       0       4       1       3
%           -2   -2   -2  -1  -1   0   0    1   1   2   2   2     0    1     -1       2       -2      2       -2      2       -2];
% Targy{2} =[-2   -2   -2  -1  -1   0   0    1   1   2   2   2     0    1     -1       2       -2      2       -2      2       -2
%            -1   0   1   -2   2  -2   2    2   6   3   5   4     6   -2      6       -1      5       0       4       1       3];
% 
% Targori{2} =[60    90   120      30     30      0      0      30     30   60     120      90     0      30     30       60      60      90      90      60    60
%              30     0   150     60      120     90      90      120     60   150      30      0     90     120      120     150     150     0      0      30     30];
% 
% Xoff=[0 0.2193  0 0 0   0        0      0       0 0 0 -0.2193   0       0   0   0   0   -0.2193  0.2193     0   0];
% Yoff=[0 0       0 0 0 0.1096 -0.1827 -0.1827    0 0 0   0    -0.1827    0   0   0   0   0       0           0   0];
% 
% offsetx{2}= [Xoff; -Xoff];
% offsety{2}=[-Yoff; -Yoff];
% clear Xoff Yoff

% q vs p ------------------------------------------------------------------

% Targx{3}= [-2    -2    -2    -1    -1     0     0     1     1     2     2     2     2     2    2
%     -2    -2    -2    -1    -1     0     0     1     1     2     2     2     -2     -2     -2];
% Targy{3} = [-1     0     1    -2     2    -2     2    -2     2    -1     0     1     2     3     4
%     -1     0     1    -2     2    -2     2    -2     2    -1     0     1     2     3     4];
% 
% Targori{3} =[    30     0   150    60   120    90    90   120    60   150     0    30     0     0     0
%     30     0   150    60   120    90    90   120    60   150     0    30     0     0     0];
% 
% Xoff=[         0    0.2193         0         0         0         0         0         0         0   0   -0.1462         0         0         0         0];
% Yoff=[     0         0         0         0         0    0.1096   -0.1827         0         0  0         0         0         0         0         0];
% 
% offsetx{3}= [-Xoff; -Xoff];
% offsety{3}=[-Yoff; -Yoff];


%% d vs b ------------------------------------------------------------------
Targx{3}= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1   
            2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
Targy{3} =[-1      0       1       -2      2       -2      2       -2      -1      0       1       2       3       4       5 
           -1      0       1       -2      2       -2      2       -2       2      -1       1       0       3       4       5];

Targori{3} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
             150     0       30     120      60     90      90      0       0       0       0       0       0       0       0];

Xoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0];
Yoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0];

offsetx{3}= [-Xoff; Xoff];
offsety{3}=[-Yoff; -Yoff];
clear Xoff Yoff

%% p vs q ------------------------------------------------------------------

% Targx{4}= [-2    -2    -2    -1    -1     0     0     1     1     2     2     2     2     2    2
%     -2    -2    -2    -1    -1     0     0     1     1     2     2     2     -2     -2    -2];
% Targy{4} = [-1     0     1    -2     2    -2     2    -2     2    -1     0     1     -2     -3     -4
%     -1     0     1    -2     2    -2     2    -2     2    -1     0     1     -2     -3     -4];
% 
% Targori{4} =[    30     0   150    60   120    90    90   120    60   150     0    30     0     0     0
%     30     0   150    60   120    90    90   120    60   150     0    30     0     0     0];
% 
% 
% Xoff=[         0    0.2193         0         0         0         0         0         0         0   0   -0.1462         0         0         0         0];
% Yoff=[     0         0         0         0         0    0.1096   -0.1827         0         0  0         0         0         0         0         0];
% offsetx{4}= [-Xoff; -Xoff];
% offsety{4}=[-Yoff; -Yoff];
Targx{4}= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1   
            2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
Targy{4} =[-1      0       1       -2      2       -2      2       -2      -1      0       1       2       -3       -4       -5 
           -1      0       1       -2      2       -2      2       -2       2      -1       1       0       -3       -4       -5];

Targori{4} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
             150     0       30     120      60     90      90      0       0       0       0       0       0       0       0];

Xoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0];
Yoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0];

offsetx{4}= [-Xoff; Xoff];
offsety{4}=[-Yoff; -Yoff];
clear Xoff Yoff
%% eggs ---------------------------------------------------------------------

xfoo= [-4    -4    -4    -3    -3    -2    -2    -1    -1     0     0     1     1     2     2     2]+1;
yfoo = [-1     0     1    -1     1    -2     2    -2     2    -2     2    -2     2    -1     0 1];

orifoo=    [35     0   -35    50   -45    55   -55    65   -70    90    90   -55    55   -30     0 35];
twoorifoo= [ -35     0    35   -50    45   -55    55   -65    70    90    90    55   -55    30     0 -35];


Xoff=[   -0.2198   -0.0122   -0.1954   -0.0855   -0.0488   -0.0122    0.0244         0    0.0367   0         0   -0.0611         0    0.1221    0.0122    0.1587];
Yoff=[   -0.1832   -0.0367    0.0244    0.0977   -0.2320   -0.2198    0.1466   -0.0488   -0.0122    0         0   -0.1221    0.0855    0.0244    0.0122   -0.0732];

Targx{5}= [xfoo; -xfoo];
Targy{5}= [yfoo; yfoo];
Targori{5}=[orifoo;twoorifoo];

offsetx{5}= [-Xoff; Xoff];
offsety{5}=[-Yoff; -Yoff];
clear Xoff Yoff xfoo yfoo orifoo
%% diagonal line -----------------------------------------------------------

xfoo=[-3  -2    -1     0     1     2  3];
yfoo= xfoo;
Xoff=[-0.0850   -0.0850   -0.0850         0    0.0850    0.0850  0.0850];
Yoff=Xoff;
orifoo=[45  45    45    45    45    45  45];
Targx{6}= [xfoo; -xfoo];
Targy{6}= [yfoo; yfoo];
Targori{6}=[-orifoo;orifoo];

offsetx{6}= [Xoff; Xoff];
offsety{6}=[Yoff; Yoff];

clear Xoff Yoff xfoo yfoo orifoo

%% horizontal vs vertical line ---------------------------------------------


matr=[90  -3     0     0     0
    90    -2     0     0     0
    90    -1     0     0     0
    90     0     0     0     0
    90     1     0     0     0
    90     2     0     0     0
    90     3     0     0     0];

xfoo=matr(:,2);
yfoo=matr(:,3);
orifoo=matr(:,1);


Xoff=matr(:,4);
Yoff=matr(:,5);

orifoo= [ 90   90    90    90    90    90   90];
xfoo=[-3  -2    -1     0     1      2   3];
yfoo = [0     0     0     0     0  0   0];
Xoff=[ 0    0     0     0     0     0  0];
Yoff=Xoff;
Targx{7}= [xfoo; yfoo];
Targy{7}= [yfoo; xfoo];
Targori{7}=[orifoo;orifoo+90];

offsetx{7}= [Xoff; Xoff];
offsety{7}=[Yoff; Yoff];

clear Xoff Yoff xfoo yfoo orifoo


%% rotated eggs ---------------------------------------------------------------------

yfoo= [-4    -4    -4    -3    -3    -2    -2    -1    -1     0     0     1     1     2     2     2]+1;
xfoo = [-1     0     1    -1     1    -2     2    -2     2    -2     2    -2     2    -1     0 1];

twoorifoo=    [35     0   -35    50   -45    55   -55    65   -70    90    90   -55    55   -30     0 35];
orifoo= [ -35     0    35   -50    45   -55    55   -65    70    90    90    55   -55    30     0 -35];

twoorifoo=twoorifoo+90;
orifoo=orifoo+90;
Yoff=[   -0.2198   -0.0122   -0.1954   -0.0855   -0.0488   -0.0122    0.0244         0    0.0367   0         0   -0.0611         0    0.1221    0.0122    0.1587];
Xoff=[   -0.1832   -0.0367    0.0244    0.0977   -0.2320   -0.2198    0.1466   -0.0488   -0.0122    0         0   -0.1221    0.0855    0.0244    0.0122   -0.0732];

Targx{8}= [xfoo; xfoo];
Targy{8}= [yfoo; -yfoo];
Targori{8}=[orifoo;twoorifoo];


offsetx{8}= [-Xoff; -Xoff];
offsety{8}=[-Yoff; Yoff];
clear Xoff Yoff xfoo yfoo orifoo


%% rotated 6/9---------------------------------------------------------------------


yfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1];
xfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  4];
orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 150]+90 ;


Yoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0];
Xoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 1/4];

Targx{9}= [xfoo; -xfoo];
Targy{9}= [yfoo; -yfoo];

Targori{9}=[orifoo; orifoo];

offsetx{9}= [Xoff; -Xoff];
offsety{9}=[Yoff; -Yoff];

clear Xoff Yoff xfoo yfoo orifoo



%% rotated b and d
       
     Targy{10}= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1   
            2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
Targx{10} =[-1      0       1       -2      2       -2      2       -2      -1      0       1       2       3       4       5 
           -1      0       1       -2      2       -2      2       -2       2      -1       1       0       3       4       5];

Targori{10} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
             150     0       30     120      60     90      90      0       0       0       0       0       0       0       0]+90;

Yoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0];
Xoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0];


offsetx{10}= [-Xoff; -Xoff];
offsety{10}=[-Yoff; Yoff];

clear Xoff Yoff xfoo yfoo orifoo


%% rotated p and q
  
     Targy{11}= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1   
            2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
Targx{11} =[-1      0       1       -2      2       -2      2       -2      -1      0       1       2       -3       -4       -5 
           -1      0       1       -2      2       -2      2       -2       2      -1       1       0       -3       -4       -5];

Targori{11} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
             150     0       30     120      60     90      90      0       0       0       0       0       0       0       0]+90;

Yoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0];
Xoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0];

offsetx{11}= [-Xoff; -Xoff];
offsety{11}=[-Yoff; Yoff];