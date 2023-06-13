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
% ecccoeffCI=3; % grid separation
ecccoeffCI = 2;
% ecccoeffCI=1.8;
% ecccoeffCI=1.5;
% ecccoeffCI=1.3;
% ecccoeffCI=1;

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

%% 9 vs 6 19 elements ------------------------------------------------------------------
xfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1 -2];
yfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  5 4 ];
orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 120 150 ] ;
Xoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0 1/4 ];
Yoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 -1/4 0];


Targx{1}= [xfoo; -xfoo];
Targy{1}= [yfoo; -yfoo];

Targori{1}=[orifoo; orifoo];

offsetx{1}= [Xoff; -Xoff];
offsety{1}=[Yoff; -Yoff];
clear Xoff Yoff xfoo yfoo orifoo
%% 9 vs 6 18 elements ------------------------------------------------------------------
xfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1];
yfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  5];

orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 90] ;
Xoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0];
Yoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 -1/4];


Targx{2}= [xfoo; -xfoo];
Targy{2}= [yfoo; -yfoo];

Targori{2}=[orifoo; orifoo];

offsetx{2}= [Xoff; -Xoff];
offsety{2}=[Yoff; -Yoff];

clear Xoff Yoff xfoo yfoo orifoo
%% p and q ------------------------------------------------------------

Targx{3}= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1
    2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
Targy{3} =[-1	0	1	-2	2	-2	2	-2	2	0	1	-1	3	4	5
    -1	0	1	-2	2	-2	2	-2	0	-1	1	2	3	4	5];

Targori{3} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
    150     0       30     120      60     90      90      0       0       0       0       0       0       0       0];

Xoff=[-0.05   0.25   -0.05    0.125    0.125   0   0   -0.125   -0.125   -0.125   -0.125   -0.125 -0.125 -0.125 -0.125];
Yoff=-[-0.125	0	0.125	0.05 -0.05	-0.25	0.25	0.05 -0.05 zeros(1,6)];

offsetx{3}= [-Xoff; Xoff];
offsety{3}=[-Yoff; -Yoff];
clear Xoff Yoff xfoo yfoo orifoo
%% d and b ------------------------------------------------------------

Targx{4}= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1
    2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
Targy{4} =[-1	0	1	-2	2	-2	2	-2	2	0	1	-1	-3	-4	-5
    -1	0	1	-2	2	-2	2	-2	0	-1	1	2	-3	-4	-5];
Targori{4} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
    150     0       30     120      60     90      90      0       0       0       0       0       0       0       0];
Xoff= [  -0.05  0.25   -0.05   0.125  0.125  0  0  -0.125  -0.125  -0.125 -0.125 -0.125 -0.125 -0.125  -0.125];
Yoff=-[-0.125	0	0.125	0.05	-0.05	-0.25	0.25	0.05	-0.05 zeros(1,6)];
offsetx{4}= [-Xoff; Xoff];
offsety{4}=[-Yoff; -Yoff];

clear Xoff Yoff xfoo yfoo orifoo
%% eggs ---------------------------------------------------------------------

xfoo= [-4    -4    -4    -3    -3    -2    -2    -1    -1     0     0     1     1     2     2     2]+1;
yfoo = [-1     0     1    -1     1    -2     2    -2     2    -2     2    -2     2    -1     0 1];

orifoo=    [35     0   -35    50   -45    55   -55    65   -70    90    90   -55    55   -30     0 35];
twoorifoo= [ -35     0    35   -50    45   -55    55   -65    70    90    90    55   -55    30     0 -35];


% Xoff=[   -0.2198   -0.0122   -0.1954   -0.0855   -0.0488   -0.0122    0.0244         0    0.0367   0         0   -0.0611         0    0.1221    0.0122    0.1587];
% Yoff=[   -0.1832   -0.0367    0.0244    0.0977   -0.2320   -0.2198    0.1466   -0.0488   -0.0122    0         0   -0.1221    0.0855    0.0244    0.0122   -0.0732];


Xoff=[-0.2  0.2 -0.2 -0.05 -0.05 -0.02  0.02       0       0       0.05  0.05 0 0  0.2 0.0122  0.200];
Yoff= [0.05 0 -0.05  0.53  -0.53 -0.15  0.15  0.0500 -0.05 0 0 -0.1  0.1  0.1200  0 -0.1200];


Targx{5}= [xfoo; -xfoo];
Targy{5}= [yfoo; yfoo];
Targori{5}=[orifoo;twoorifoo];

offsetx{5}= [-Xoff; Xoff];
offsety{5}=[-Yoff; -Yoff];
clear Xoff Yoff xfoo yfoo orifoo
%% diagonal line -----------------------------------------------------------

xfoo=[-3  -2    -1     0     1     2  3];
yfoo= xfoo;
Xoff=[-0.085  -0.085   -0.085  0  0.085    0.085  0.085];
Yoff=Xoff;
orifoo=[45  45    45    45    45    45  45];
Targx{6}= [xfoo; -xfoo];
Targy{6}= [yfoo; yfoo];
Targori{6}=[-orifoo;orifoo];

offsetx{6}= [Xoff; Xoff];
offsety{6}=[Yoff; Yoff];

clear Xoff Yoff xfoo yfoo orifoo

%% horizontal vs vertical line (cardinal lines) ---------------------------------------------

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
%invert x and y
%invert ori
%add 90 deg to ori
% invert - and + from targx and targy
yfoo= [-4    -4    -4    -3    -3    -2    -2    -1    -1     0     0     1     1     2     2     2]+1;
xfoo = [-1     0     1    -1     1    -2     2    -2     2    -2     2    -2     2    -1     0 1];

twoorifoo=    [35     0   -35    50   -45    55   -55    65   -70    90    90   -55    55   -30     0 35];
orifoo= [ -35     0    35   -50    45   -55    55   -65    70    90    90    55   -55    30     0 -35];

twoorifoo=twoorifoo+90;
orifoo=orifoo+90;
%Xoff=[   -0.2198   -0.0122   -0.1954   -0.0855   -0.0488   -0.0122    0.0244         0    0.0367   0         0   -0.0611         0    0.1221    0.0122    0.1587];
%Yoff=[   -0.1832   -0.0367    0.0244    0.0977   -0.2320   -0.2198    0.1466   -0.0488   -0.0122    0         0   -0.1221    0.0855    0.0244    0.0122   -0.0732];


Xoff=[-0.2  0.2 -0.2 -0.05 -0.05 -0.02  0.02       0       0       0.05  0.05 0 0  0.2 0.0122  0.200];
Yoff= [0.05 0 -0.05  0.53  -0.53 -0.15  0.15  0.0500 -0.05 0 0 -0.1  0.1  0.1200  0 -0.1200];

Targx{8}= [xfoo; xfoo];
Targy{8}= [yfoo; -yfoo];
Targori{8}=[orifoo;twoorifoo];


offsetx{8}= [-Xoff; -Xoff];
offsety{8}=[-Yoff; Yoff];
clear Xoff Yoff xfoo yfoo orifoo

%% d and b more elements (Sloan Fonts)---------------------------------------------------------------------

% Targx{9}=    [3 3 3 2 2 1 1 -1 -1 -1 -1 -1 -1 -1 0 0
%     -3 -3 -3 -2 -2 -1 -1 1 1 1 1 1 1 1 0 0];
% Targy{9} =[-1 0 1 -2 2 -2 2 -2 0 1 -1 -3 -4 -5 -2 2
%     -1 0 1 -2 2 -2 2 -2 0 1 -1 -3 -4 -5 -2 2];

% first row corresponds to b and second corresponds to d
% Targx{9}=    [4 4 4 3 3 2 2 1 1 -1 -1 -1 -1 -1 -1 -1 0 0 
%     -4 -4 -4 -3 -3 -2 -2 -1 -1 1 1 1 1 1 1 1 0 0];

Targx{9}=[    -4    -4    -4    -3    -3    -2    -2    -1    -1     1     1     1     1     1     1     1     0     0
     4     4     4     3     3     2     2     1     1    -1    -1    -1    -1    -1    -1    -1     0     0];

Targy{9} =[    -1     0     1    -2     2    -2     2    -2     2    -2     0     1    -1    -3    -4    -5    -2     2
    -1     0     1    -2     2    -2     2    -2     2    -2     0     1    -1    -3    -4    -5    -2     2];

% Targy{9} =[-1 0 1 -2 2 -2 2 -2 2 -2 0 1 -1 -3 -4 -5 -2 2
%     -1 0 1 -2 2 -2 2 -2 2 -2 0 1 -1 -3 -4 -5 -2 2];
% Targori{9} = [150+180 0 30 120+180 60 90+180 90 90+180 90 0+180 0+180 150+180 30+180 0+180 0+180 0+180 60+180 120
%     30+180 0+180 150 60+180 120 90+180 90 90 90+180 0 0 30 150 0 0 0 120+180 60];

  Targori{9} = [ 210   180   150   240   120   270    90    90   270     0     0    30   150     0     0     0   300    60
   330     0    30   300    60   270    90   270    90   180   180   330   210   180   180   180   240   120];

Xoff = [-0.2 0 -0.2 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 0 0 0 0.05 0 0 0 -0.1 -0.1];
Yoff = -[-0.05 0 0.05 0.05 -0.05 -0.05 0.05 -0.05 0.05 0.05 0 0 0 0 0 0 0.1 -0.05];

% Original ----------------------------------------------------------------
% Targori{9} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0 90 90
%     150     0       30     120      60     90      90      0       0       0       0       0       0       0       0 90 90];
% Xoff=[-0.05 0.25 -0.05 0.125 0.125 0 0   0   0 0 0 0 0 0 0 0   0]; original
%Xoff=[-0.05 0.25 -0.05 0.125 0.125 0 0   -0.125   -0.125 -0.1250 -0.125  -0.125  -0.125 -0.125 -0.125 0  0];
% Yoff=-[-0.125	0	0.125	0.05	-0.05	0 0 	0.05	-0.05 zeros(1,8)]; original
% -------------------------------------------------------------------------
% 
% offsetx{9}= [Xoff; -Xoff];
% offsety{9}=[-Yoff; -Yoff];


offsetx{9}= [-Xoff; Xoff];
offsety{9}=[-Yoff; -Yoff];

clear Xoff Yoff xfoo yfoo orifoo

%% p and q more elements (Sloan Font) ---------------------------------------------------------------------

% Targx{10}= [3 3 3 2 2 1 1 -1 -1 -1 -1 -1 -1 -1 0 0
%     -3 -3 -3 -2 -2 -1 -1 1 1 1 1 1 1 1 0 0];
% Targy{10} =[-1 0 1 -2 2 -2 2 -1 1 2	0 3 4 5 -2 2
%     -1 0 1 -2 2 -2 2 -1 1 2 0 3 4 5 -2 2];
Targx{10} = [4 4 4 3 3 2 2 1 1 -1 -1 -1 -1 -1 -1 -1 0 0
    -4 -4 -4 -3 -3 -2 -2 -1 -1 1 1 1 1 1 1 1 0 0];
Targy{10} = [-1 0 1 -2 2 -2 2 -2 2 2 0 1 -1 3 4 5 -2 2
    -1 0 1 -2 2 -2 2 -2 2 2 0 1 -1 3 4 5 -2 2];
Targori{10} =[150+180 0 30 120+180 60 90+180 90 90+180 90 0+180 0+180 150+180 30+180 0+180 0+180 0+180 60+180 120
    30+180 0+180 150 60+180 120 90+180 90 90 90+180 0 0 30 150 0 0 0 120+180 60];

Xoff = [-0.2 0 -0.2 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 0 0 0 0 0 0 0 -0.1 -0.1];
Yoff = [0.05 0 -0.05 -0.05 0.05 0.05 -0.05 0.05 -0.05 -0.05 0 0 0 0 0 0 -0.05 0.1];

% Original ----------------------------------------------------------------
% Xoff = [-0.05 0.25   -0.05 0.125 0.125 0 0   -0.125 -0.125 -0.125  -0.125 -0.125 -0.125 -0.125  -0.125 0 0]; original
% Yoff = [0.125 0   -0.125 -0.05  0.05  0  0   -0.05  0.05 0  0  0  0  0 0 0 0]; original
% -------------------------------------------------------------------------

offsetx{10}= [Xoff; -Xoff];
offsety{10}=[-Yoff; -Yoff];
clear Xoff Yoff xfoo yfoo orifoo
%% rotated 6 vs 9 with 19 elements ---------------------------------------------------------------------
%invert x and y
%invert ori
%add 90 deg to ori
% invert - and + from targx and targy
yfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1 -2];
xfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  5 4 ];

%orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 90 150 ]+90 ;
orifoo= [    60   180   165    80   150    90    90   150    75   135   180   190    90    90    30   180   180   180   285];

% orifoo(10)=orifoo(10)+15;
% orifoo(15)=orifoo(15)+15;
% orifoo(16)=orifoo(16)+30;

Yoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0 1/4 ];
Xoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 -1/4 0];

Targx{11}= [xfoo; -xfoo];
Targy{11}= [yfoo; -yfoo];

Targori{11}=[orifoo; orifoo];

offsetx{11}= [Xoff; -Xoff];
offsety{11}=[Yoff; -Yoff];
clear Xoff Yoff xfoo yfoo orifoo




%1: 9 vs 6 19 elements
%2: 9 vs 6 18 elements
%3: p vs q
%4 d vs b
%5 eggs
%6: diagonal line
%7:horizontal vs vertical line
%8: rotated eggs
% 9: d and b more elements
%10: p and q more elements
%11: %% rotated 6 vs 9 with 19 elements
