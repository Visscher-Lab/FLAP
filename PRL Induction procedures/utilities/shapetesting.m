
close all


% input coordinates (before PTB)
yfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1 -2];
xfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  5 4 ];
orifoo= [    60   180   165    80   150    90    90   150    75   135   180   190    90    90    30   180   180   180   285];
Yoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0 1/4 ];
Xoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 -1/4 0];
Targx{11}= [xfoo; -xfoo];
Targy{11}= [yfoo; -yfoo];
Targori{11}=[orifoo; orifoo];
offsetx{11}= [Xoff; -Xoff];
offsety{11}=[Yoff; -Yoff];


%destination rectangles for Ci gabor based on grid coordinates
mao=imageRect_offsCI2(imageRect_offsCI2(:,1)~=0,:);

% coordinates from center of Gabor destination rect
mao(:,2)=mao(:,2)-wRect(4)/2;
mao(:,4)=mao(:,4)-wRect(4)/2;
mao(:,1)=mao(:,1)-theeccentricity_X-wRect(3)/2;
mao(:,3)=mao(:,3)-theeccentricity_X-wRect(3)/2;
theX=(mao(:,1)+mao(:,3))/2;
theY=(mao(:,2)+mao(:,4))/2;

%%
%offset for target location expressed in degree
maooffx=xJitLoc(imageRect_offsCI2(:,1)~=0)/pix_deg;
maooffy=yJitLoc(imageRect_offsCI2(:,1)~=0)/pix_deg;
figure
scatter(maooffx,maooffy, 'filled', 'g')
hold on
scatter(Xoff,Yoff, 'filled', 'r')

figure

scatter(theX/pix_deg,theY/pix_deg, 'filled', 'g');
hold on

scatter(Targx{11}(this,:),Targy{11}(this,:), 'filled', 'r');
title('actual vs input coordinates in deg')

%%










figure
scatter(theX,theY, 'filled'); xlim ([0 wRect(3)]); ylim([0 wRect(4)])
set(gca, 'YDir', 'reverse');
title('actual figure without offset')
adjust=imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc];
adjust2=adjust(:,imageRect_offsCI2(:,1)>0);
adjust3=adjust2';
adjustX=(adjust3(:,1)+adjust3(:,3))/2;
adjustY=(adjust3(:,2)+adjust3(:,4))/2;
figure
scatter(adjustX,adjustY, 'filled'); xlim ([0 wRect(3)]); ylim([0 wRect(4)])
title('actual figure with offset')
set(gca, 'YDir', 'reverse');


figure

% last trial's response will define which of the two configurations will be
% used
this=theans(end);
scatter(Targx{11}(this,:),Targy{11}(this,:), 'filled'); xlim ([-10 10]); ylim([-10 10])
title('input coordinates without offset')
set(gca, 'YDir', 'reverse');

newxfoo{11}=[Targx{11}(1,:)+offsetx{11}(1,:); Targx{11}(2,:)+offsetx{11}(2,:)];
newyfoo{11}=[Targy{11}(1,:)+offsety{11}(1,:); Targy{11}(2,:)+offsety{11}(2,:);];

figure

scatter(newxfoo{11}(this,:),newyfoo{11}(this,:), 'filled'); xlim ([-10 10]); ylim([-10 10])

title('coordinates with offset')

set(gca, 'YDir', 'reverse');


figure
scatter(theX/pix_deg,theY/pix_deg, 'filled');  xlim ([0 10]); ylim([0 10])
set(gca, 'YDir', 'reverse');
title('actual figure without offset divided by pixdeg')

figure
scatter(adjustX/pix_deg,adjustY/pix_deg, 'filled'); xlim ([0 10]); ylim([0 10])
title('actual figure with offset divided by pixdeg')
set(gca, 'YDir', 'reverse');

close all

figure
subplot(3,2,1)
% coordinates from center of Gabor destination rect
scatter(theX,theY, 'filled'); xlim ([0 wRect(3)]); ylim([0 wRect(4)])
set(gca, 'YDir', 'reverse');
title('actual figure without offset')
pbaspect([1 1 1]);
subplot(3,2,2)
% coordinates from center of Gabor destination rect + offset
scatter(adjustX,adjustY, 'filled');  xlim ([0 30*pix_deg]); ylim([0 30*pix_deg])
title('actual figure with offset')
set(gca, 'YDir', 'reverse');
pbaspect([1 1 1]);
subplot(3,2,4)
scatter(Targx{11}(this,:),Targy{11}(this,:), 'filled'); xlim ([-10 10]); ylim([-10 10])
title('coordinates without offset')
set(gca, 'YDir', 'reverse');
pbaspect([1 1 1]);
subplot(3,2,5)
scatter(newxfoo{11}(this,:)*pix_deg,newyfoo{11}(this,:)*pix_deg, 'filled'); xlim ([-10 10]); ylim([-10 10])

title('coordinates with offset')
pbaspect([1 1 1]);
set(gca, 'YDir', 'reverse');
subplot(3,2,3)
% coordinates from center of Gabor destination rect divided by pixel deg


actualdegx=theX/pix_deg;
actualdegy=theY/pix_deg;
scatter(actualdegx,actualdegy, 'filled'); xlim ([0 30]); ylim([0 30])
set(gca, 'YDir', 'reverse');
title('actual figure without offset divided by pixdeg')
pbaspect([1 1 1]);
subplot(3,2,6)
scatter(adjustX/pix_deg,adjustY/pix_deg, 'filled'); xlim ([0 30]); ylim([0 30])
title('actual figure with offset divided by pixdeg')
set(gca, 'YDir', 'reverse');
pbaspect([1 1 1]);

