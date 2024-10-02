function ang = pix2angle(display,pix,dim)
%   Converts pixels to visual angle in degrees
%
%	Usage:
%   pix = pix2angle(display,pix,dim)
%
%   Required:
%   display.distance (distance from screen (cm))
%   display.resolution (number of pixels of display in horizontal direction)
%   display.width (width of screen (cm)) OR display.height (height of screen (cm))
%
%   Inputs:
%   display - structure (above)
%   pix - number of pixels
%
%   Optional:
%   dim - dimention, either 'height' or 'width' <default>, in case
%   rectangular pixels
%
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
sz = pix*pixSize;  %cm (duh)
ang = rad2deg(2*atan(sz/(2*display.distance)));
return

%test code
display.dist = 60; %cm
display.width = 44.5; %cm
display.resolution = [1680,1050];
pix = 100;
ang = pix2angle(display,pix)
