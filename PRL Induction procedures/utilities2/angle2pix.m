function pix = angle2pix(display,ang,dim)
%   Converts Visual Angle (degrees) to Pixels
%
%	Usage:
%   pix = angle2pix(display,ang,dim)
%   
%   Required:
%   display.distance (distance from screen (cm))
%   display.resolution (number of pixels of display) - [width height]
%   display.width (width of screen (cm)) 
%   display.height (height of screen (cm))
%
%   Inputs:
%   display - structure (above)
%   ang - visual angle (in degrees)
%
%   Optional:
%   dim - dimention, either 'width' <default> or 'height'
%
%Written 11/1/07 gmb zre
% Updated 11/21/14 ASB - I added the 'dim' input for height or width

%% defaults
if ~exist('dim','var')
    dim = 'width';
end
%Calculate pixel size
if strcmp(dim,'width')
    pixSize = display.width/display.resolution(1);   %cm/pix
else
    pixSize = display.height/display.resolution(2);   %cm/pix
end
sz = 2*display.distance*tan(deg2rad(ang)/2);  %cm
pix = round(sz/pixSize);   %pix
return

%test code
display.distance = 60; %cm
display.height = 44.5; %cm
display.resolution = [1680,1050];
ang = 2.529;
angle2pix(display,ang)