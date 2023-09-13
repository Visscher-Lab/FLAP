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
ecccoeffCI = 2; % grid separation
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

%% 9 vs 6 19 elements -----------------------------------------------------
xfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1 -2];
yfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  5 4 ]+2;
orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 120 150 ] ;
Xoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0 1/4 ];
Yoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 -1/4 0];


Targx{1}= [xfoo; -xfoo];
Targy{1}= [yfoo; -yfoo];

Targori{1}=[orifoo; orifoo];

offsetx{1}= [Xoff; -Xoff];
offsety{1}=[Yoff; -Yoff];
clear Xoff Yoff xfoo yfoo orifoo

%% 2 and 5 ----------------------------------------------------------------
Targx{2} = [0 0 1 -1 2 -2 2 -2 2 -2 1 -1 0 1 -1 2 -2 % 5
    0 0 -1 1 -2 2 -2 2 -2 2 -1 1 0 -1 1 -2 2]; % 2
Targy{2} = [-4 4 -4 4 -3 3 -2 2 -1 1 0 0 0 4 -4 3 -3 % 5
    -4 4 -4 4 -3 3 -2 2 -1 1 0 0 0 4 -4 3 -3]; %2
Targori{2} = [90 90 120 120 150 150 0 0 30 30 60 60 90 60 60 30 30 % 5
    90 90 60 60 30 30 0 0 150 150 120 120 90 120 120 150 150]; % 2
Xoff = [0 0 0 0 0 0 0.2193 -0.2193 0 0 0 0 0 0 0 0 0];
Yoff = [0.1096 -0.1827 0 0 0 0 0 0 0 0 0 -0.1827 -0.1827 0 0 0 0];

offsetx{2}= [Xoff; -Xoff];
offsety{2}=[-Yoff; -Yoff];
clear Xoff Yoff 
clear Xoff Yoff xfoo yfoo orifoo

%% p and q more elements (Sloan Font) -------------------------------------

Targx{3} = [-3 -3 -3 -2 -2 -1 -1 0 0 2 2 2 2 2 2 2 1 1 % q
    3 3 3 2 2 1 1 0 0 -2 -2 -2 -2 -2 -2 -2 -1 -1];
Targy{3} = [-1 0 1 -2 2 -2 2 -2 2 2 0 1 -1 3 4 5 -2 2 % q
    -1 0 1 -2 2 -2 2 -2 2 2 0 1 -1 3 4 5 -2 2]-1;
Targori{3} =[30+180 0+180 150 60+180 120 90+180 90 90+180 90 0 0 30 150+180 0 0 0 120+180 60 % q
    150+180 0 30 120+180 60 90+180 90 90+180 90 0+180 0+180 150+180 30+180 0+180 0+180 0+180 60+180 120];

Xoff = [-0.2 0 -0.2 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 0 0 0 0 0 0 0 -0.1 -0.1];
Yoff = [0.05 0 -0.05 -0.05 0.05 0.05 -0.05 0.1 -0.1 -0.05 0 0 0 0 0 0 -0.05 0.1];

offsetx{3}= [-Xoff; Xoff]; %[q;p]
offsety{3}=[-Yoff; -Yoff]; %[q;p]
clear Xoff Yoff xfoo yfoo orifoo

%% d and b more elements (Sloan Fonts)-------------------------------------

Targx{4}=[-3 -3 -3 -2 -2 -1 -1 0 0 2 2 2 2 2 2 2 1 1 % d
     3 3 3 2 2 1 1 0 0 -2 -2 -2 -2 -2 -2 -2 -1 -1];

Targy{4} =[-1 0 1 -2 2 -2 2 -2 2 -2 0 1 -1 -3 -4 -5 -2 2 % d
    -1 0 1 -2 2 -2 2 -2 2 -2 0 1 -1 -3 -4 -5 -2 2]+2;

  Targori{4} = [210 180 150 240 120 270 90 90+180 270+180 0 0 30 150+180 0 0 0 300 60 %d
   330 0 30 300 60 270 90 270 90 180 180 330 210 180 180 180 240 120];

Xoff = [-0.2 0 -0.2 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 0 0 0 0.05 0 0 0 -0.1 -0.1];
Yoff = -[-0.05 0 0.05 0.05 -0.05 -0.05 0.05 -0.1 0.1 0.05 0 0 0 0 0 0 0.1 -0.05];

offsetx{4}= [-Xoff; Xoff]; %[d;b]
offsety{4}=[-Yoff; -Yoff]; %[d;b]

clear Xoff Yoff xfoo yfoo orifoo

%% eggs -------------------------------------------------------------------

xfoo= [-4 -4 -4 -3 -3 -2 -2 -1 -1 0 0 1 1 2 2 2]+1;
yfoo = [-1 0 1 -1 1 -2 2 -2 2 -2 2 -2 2 -1 0 1];

orifoo=    [35 0 -35 50 -45 55 -55 65 -70 90 90 -55 55 -30 0 35];
twoorifoo= [-35 0 35 -50 45 -55 55 -65 70 90 90 55 -55 30 0 -35];

% Xoff=[-0.2 0.2 -0.2 -0.05 -0.05 -0.02 0.02 0 0 0.05 0.05 0 0 0.2 0.0122 0.200];
% Yoff= [0.05 0 -0.05 0.53 -0.53 -0.15 0.15 0.0500 -0.05 0 0 -0.1  0.1 0.1200 0 -0.1200];
Xoff=[-0.2 -0.01 -0.2 -0.1 -0.05 -0.01 0.02 0 0.03 0 0 -0.06 0 0.1 0.01 0.15];
Yoff=[-0.2 -0.03 0.02 0.15 -0.25 -0.2 0.15 -0.05 -0.01 0 0 -0.1 0.09 0.02 0.01 -0.07];
Targx{5}= [xfoo; -xfoo];
Targy{5}= [yfoo; yfoo];
Targori{5}=[orifoo;twoorifoo];

offsetx{5}= [-Xoff; Xoff];
offsety{5}=[-Yoff; -Yoff];
clear Xoff Yoff xfoo yfoo orifoo

%% horizontal vs vertical line (cardinal lines) ---------------------------

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

orifoo= [90 90 90 90 90 90 90];
xfoo=[-3 -2 -1 0 1 2 3];
yfoo = [0 0 0 0 0 0 0];
Xoff=[0 0 0 0 0 0 0];
Yoff=Xoff;
Targx{6}= [xfoo; yfoo];
Targy{6}= [yfoo; xfoo];
Targori{6}=[orifoo;orifoo+90];

offsetx{6}= [Xoff; Xoff];
offsety{6}=[Yoff; Yoff];

clear Xoff Yoff xfoo yfoo orifoo

%% d and p more elements (scanner & CI assessment) ------------------------

Targx{7} = [-3 -3 -3 -2 -2 -1 -1 0 0 2 2 2 2 2 2 2 1 1 %d
    3 3 3 2 2 1 1 0 0 -2 -2 -2 -2 -2 -2 -2 -1 -1];
Targy{7} = [1 2 3 0 4 0 4 0 4 0 2 3 1 -1 -2 -3 0 4 %d
    -2 -1 0 -3 1 -3 1 -3 1 1 -1 0 -2 2 3 4 -3 1];
Targori{7} = [210 180 150 240 120 270 90 90+180 270+180 0 0 30 150+180 0 0 0 300 60
    150+180 0 30 120+180 60 90+180 90 90+180 90 0+180 0+180 150+180 30+180 0+180 0+180 0+180 60+180 120];
Xoff = [-0.2 0 -0.2 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 0 0 0 0 0 0 0 -0.1 -0.1];
Yoff= [0.05 0 -0.05 -0.05 0.05 0.05 -0.05 0.1 -0.1 -0.05 0 0 0 0 0 0 -0.05 0.1];

offsetx{7}= [-Xoff; Xoff];
offsety{7}=[-Yoff; -Yoff];
clear Xoff Yoff xfoo yfoo orifoo

%% q and b more elements --------------------------------------------------

Targx{8} = [-3 -3 -3 -2 -2 -1 -1 0 0 2 2 2 2 2 2 2 1 1 % q
    3 3 3 2 2 1 1 0 0 -2 -2 -2 -2 -2 -2 -2 -1 -1];
Targy{8} = [-2 -1 0 -3 1 -3 1 -3 1 1 -1 0 -2 2 3 4 -3 1 % q
    1 2 3 0 4 0 4 0 4 0 2 3 1 -1 -2 -3 0 4];
Targori{8} = [30+180 0+180 150 60+180 120 90+180 90 90+180 90 0 0 30 150+180 0 0 0 120+180 60 % q
    330 0 30 300 60 270 90 270 90 180 180 330 210 180 180 180 240 120];
Xoff = [-0.2 0 -0.2 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 0 0 0 0 0 0 0 -0.1 -0.1];
Yoff= [0.05 0 -0.05 -0.05 0.05 0.05 -0.05 0.1 -0.1 -0.05 0 0 0 0 0 0 -0.05 0.1];

offsetx{8} = [-Xoff; Xoff];
offsety{8} = [-Yoff; -Yoff];
clear Xoff Yoff xfoo yfoo orifoo

%% rotated 6 vs 9 with 19 elements ---------------------------------------------------------------------
%invert x and y
%invert ori
%add 90 deg to ori
% invert - and + from targx and targy
yfoo= [-1 0 1 -2 2 -2 2 -2 2 -1 0 1 2 2 2 1 0 -1 -2];
xfoo= [-2 -2 -2 -1 -1 0 0 1 1 2 2 2 2 3 4 5 5 5 4];

orifoo= [60 180 165 80 150 90 90 150 75 135 180 190 90 90 30 180 180 180 285];

Yoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0 0 0 -1/4 0 0 0 1/4];
Xoff= [1/4 0 1/4 0 0 0 0 0 0 -1/4 0 -1/4 0 0 0 -1/4 0 -1/4 0];

Targx{9}= [xfoo; -xfoo];
Targy{9}= [yfoo; -yfoo];

Targori{9}=[orifoo; orifoo];

offsetx{9}= [Xoff; -Xoff];
offsety{9}=[Yoff; -Yoff];
clear Xoff Yoff xfoo yfoo orifoo

%% rotated 2 and 5 elements -----------------------------------------------
% rotating shape counter clockwise by 45 deg

Targx{10} = [0 0 -1 1 -2 2 -3 3 -3 3 -2 2 -1 1 0
    -2 2 -3 3 -3 3 -2 2 -1 1 0 0 0 0 0];
Targy{10} = [2 -2 3 -3 3 -3 2 -2 1 -1 0 0 0 0 0
    0 0 1 -1 2 -2 3 -3 3 -3 2 -2 1 -1 0];
Targori{10} = [];

Xoff = [];
Yoff = [];


%% rotated q and p elements (Sloan font) ----------------------------------
% switch x and y coordinates
% add 90 deg to orientation

% Circle above line - q ; press green
% Circle below line - p; press red
Targx{11} = [-1 0 1 -2 2 -2 2 -2 2 2 0 1 -1 3 4 5 -2 2 % q
    -1 0 1 -2 2 -2 2 -2 2 2 0 1 -1 3 4 5 -2 2]-1;
Targy{11} = [3 3 3 2 2 1 1 0 0 -2 -2 -2 -2 -2 -2 -2 -1 -1 % q
    -3 -3 -3 -2 -2 -1 -1 0 0 2 2 2 2 2 2 2 1 1];
Targori{11} =[120 90 60 150 30 0 0 0 0 90 90 120 60 90 90 90 30 150 % q
    60 90 120 30 150 0 0 0 0 90 90 60 120 90 90 90 150 30]; % maybe have to interchange ori

Xoff = [-0.2 -0.1 0 0.05 -0.15 -0.1 -0.1 -0.1 -0.1 0 0 0 0 0 0 0 0.1 -0.2];
Yoff = [0.1 0 0.1 0.1 0.1 0.05 0.05 0.1 0.1 -0.05 0 0 0 0 0 0 0.1 0.1];


offsetx{11}= [Xoff; Xoff]; %[q;p]
offsety{11}=[Yoff; Yoff]; %[q;p]
clear Xoff Yoff xfoo yfoo orifoo

%% rotated d and b elements (Sloan font) ----------------------------------

% Circle above line - d ; press green
% Circle below line - b; press red
Targx{12}=[-1 0 1 -2 2 -2 2 -2 2 -2 0 1 -1 -3 -4 -5 -2 2 % d
    -1 0 1 -2 2 -2 2 -2 2 -2 0 1 -1 -3 -4 -5 -2 2]+2;

Targy{12} =[3 3 3 2 2 1 1 0 0 -2 -2 -2 -2 -2 -2 -2 -1 -1 % d
     -3 -3 -3 -2 -2 -1 -1 0 0 2 2 2 2 2 2 2 1 1];

  Targori{12} = [120 90 60 150 30 0 0 0 0 90 90 120 60 90 90 90 30 150
      60 90 120 30 150 0 0 0 0 90 90 60 120 90 90 90 150 30];

Xoff = [-0.2 -0.1 0 0.05 -0.15 -0.1 -0.1 -0.1 -0.1 0 0 0 0 0 0 0 0.1 -0.2];
Yoff = [0.1 0 0.1 0.1 0.1 0.05 0.05 0.1 0.1 -0.05 0 0 0 0 0 0 0.1 0.1];

offsetx{12}= [Xoff; Xoff];
offsety{12}=[Yoff; Yoff];

clear Xoff Yoff xfoo yfoo orifoo

%% rotated eggs -----------------------------------------------------------
%invert x and y
%invert ori
% add 90 deg to ori
% invert - and + from targx and targy
yfoo= [-4 -4 -4 -3 -3 -2 -2 -1 -1 0 0 1 1 2 2 2]+1;
xfoo = [-1 0 1 -1 1 -2 2 -2 2 -2 2 -2 2 -1 0 1];

twoorifoo=    [35 0 -35 50 -45 55 -55 65 -70 90 90 -55 55 -30 0 35];
orifoo= [-35 0 35 -50 45 -55 55 -65 70 90 90 55 -55 30 0 -35];

twoorifoo=twoorifoo+90;
orifoo=orifoo+90;

Xoff=[-0.2 0.2 -0.2 -0.05 -0.05 -0.02 0.02 0 0 0.05 0.05 0 0 0.2 0.0122 0.200];
Yoff= [0.05 0 -0.05 0.53 -0.53 -0.15 0.15 0.0500 -0.05 0 0 -0.1 0.1 0.1200 0 -0.1200];

Targx{13}= [xfoo; xfoo];
Targy{13}= [yfoo; -yfoo];
Targori{13}=[orifoo;twoorifoo];

offsetx{13}= [-Xoff; -Xoff];
offsety{13}=[-Yoff; Yoff];
clear Xoff Yoff xfoo yfoo orifoo

%% rotated lines (diagonal lines) -----------------------------------------

xfoo=[-3  -2    -1     0     1     2  3];
yfoo= xfoo;
Xoff=[-0.085  -0.085   -0.085  0  0.085    0.085  0.085];
Yoff=Xoff;
orifoo=[45  45    45    45    45    45  45];
Targx{14}= [xfoo; -xfoo];
Targy{14}= [yfoo; yfoo];
Targori{14}=[-orifoo;orifoo];

offsetx{14}= [Xoff; Xoff];
offsety{14}=[Yoff; Yoff];

clear Xoff Yoff xfoo yfoo orifoo

%% rotated q and b (Sloan font) -------------------------------------------

% Circle above line - b ; press red
% Circle below line - q; press green
Targx{16} = [-2 -1 0 -3 1 -3 1 -3 1 1 -1 0 -2 2 3 4 -3 1
    1 2 3 0 4 0 4 0 4 0 2 3 1 -1 -2 -3 0 4]; % b
Targy{16} = [3 3 3 2 2 1 1 0 0 -2 -2 -2 -2 -2 -2 -2 -1 -1
    -3 -3 -3 -2 -2 -1 -1 0 0 2 2 2 2 2 2 2 1 1];
Targori{16} = [120 90 60 150 30 0 0 0 0 90 90 120 60 90 90 90 30 150
    60 90 120 30 150 0 0 0 0 90 90 60 120 90 90 90 150 30];

Xoff = [-0.2 -0.1 0 0.05 -0.15 -0.1 -0.1 -0.1 -0.1 0 0 0 0 0 0 0 0.1 -0.2];
Yoff = [0.1 0 0.1 0.1 0.1 0.05 0.05 0.1 0.1 -0.05 0 0 0 0 0 0 0.1 0.1];

offsetx{16}= [Xoff; Xoff];
offsety{16}=[Yoff; Yoff];

clear Xoff Yoff xfoo yfoo orifoo

%% rotated d and p (Sloan font) -------------------------------------------

% Circle above line - p ; press red
% Circle below line - d; press green

Targx{15} = [1 2 3 0 4 0 4 0 4 0 2 3 1 -1 -2 -3 0 4
    -2 -1 0 -3 1 -3 1 -3 1 1 -1 0 -2 2 3 4 -3 1]; % p
Targy{15} = [3 3 3 2 2 1 1 0 0 -2 -2 -2 -2 -2 -2 -2 -1 -1
    -3 -3 -3 -2 -2 -1 -1 0 0 2 2 2 2 2 2 2 1 1]; % p
Targori{15} = [120 90 60 150 30 0 0 0 0 90 90 120 60 90 90 90 30 150 
    60 90 120 30 150 0 0 0 0 90 90 60 120 90 90 90 150 30]; % p

Xoff = [-0.2 -0.1 0 0.05 -0.15 -0.1 -0.1 -0.1 -0.1 0 0 0 0 0 0 0 0.1 -0.2];
Yoff = [0.1 0 0.1 0.1 0.1 0.05 0.05 0.1 0.1 -0.05 0 0 0 0 0 0 0.1 0.1];

offsetx{15}= [Xoff; Xoff];
offsety{15}=[Yoff; Yoff];

clear Xoff Yoff xfoo yfoo orifoo

%% Shape order
%1: 9 vs 6 19 elements
%2: 2 vs 5
%3: p vs q
%4 d vs b
%5 eggs
%6: horizontal vs vertical line
%7: d vs p (scanner & assessments)
%8: q vs b
%9: rotated 6 vs 9 with 19 elements
%10: rotated 2 vs 5
%11: rotated p vs q
%12: rotated d vs b
%13: rotated eggs
%14: rotated lines (diagonal)
%15: rotated d vs p
%16: rotated q vs b

