function DatapixxImagingStereoDots_cylinder_GREY3X()
% This script draw a 3D cylinder in the Grey3X mode which is only for the 
% PROPixx projector. This uses 640x1080@360Hz RGB video to create
% 1920x1080@720Hz Grayscale video. One pixel RGB gives 3 pixels in
% Grayscale.

% This script uses a shader named gray3x.frag which should be located in
% the same folder as the demo. Can only be run on PROPixx
%
% Dec 1, 2015  dml     Written
AssertOpenGL;

% Define response key mappings, unify the names of keys across operating
% systems:
KbName('UnifyKeyNames');
space = KbName('space');
escape = KbName('ESCAPE');

% SYNC TEST FAILS AT 360 HZ!! %
Screen('Preference', 'SkipSyncTests', 1);


scrnNum = max(Screen('Screens'));
InitializeMatlabOpenGL;
PsychImaging('PrepareConfiguration');



%Open the connection to the PROPixx, enables the Grey3X Sequencer and the
% blue line mode.
Datapixx('Open');
if ~Datapixx('IsPropixx')
    Datapixx('Close');
    sca;
    return
end
Datapixx('SetVideoStereoVesaWaveform', 2);      % 3 for special PROPIXX + ACTIVE GLASSES
Datapixx('EnableVideoStereoBlueline');
if Datapixx('IsPropixx')
    Datapixx('SetPropixxDlpSequenceProgram', 9);
end
Datapixx('RegWr');

% Setup the main window (2nd screen) and two off screen windows 1920x1080.
[main_windowPtr, main_windowRect]=PsychImaging('OpenWindow', scrnNum, [128 128 128], [], [], [], 0);
[windowPtr,windowRect]=Screen('OpenOffscreenWindow',-1, [128 128 128], [0 0 1920 1080], [], 1);
[windowPtr_R,windowRect]=Screen('OpenOffscreenWindow',-1, [128 128 128], [0 0 1920 1080], [], 1);
blueRectLeftOn   = [0,                 windowRect(4)-1, 1,   windowRect(4)];
blueRectLeftOff  = [windowRect(3)/4,   windowRect(4)-1, windowRect(3),     windowRect(4)];
blueRectRightOn  = [852,                 windowRect(4)-1, 853, windowRect(4)];
blueRectRightOff = [windowRect(3)*3/4, windowRect(4)-1, windowRect(3),     windowRect(4)];

% Set up alpha-blending for smooth (anti-aliased) edges tour dots
Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('BlendFunction', main_windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

[screenXpix, screenYpix] = Screen('WindowSize', windowPtr);
Screen('Flip', main_windowPtr);

%Cylinder Parameter
col1 = WhiteIndex(scrnNum);
col2 = col1;
dotSize = 8;
numDots = 500;
radi = 200;
dis = 100;
view = 2000;
speed= pi/120/2;
dots_h_theta = zeros(2, numDots);
dots_xyz = zeros(3, numDots);
dots_screen = zeros(2, numDots);

xmax = RectWidth(windowRect);
ymax = RectHeight(windowRect);
xmax = min(xmax, ymax) / 4;
ymax = xmax;
% Calculate h and theta
dots_h_theta(1,:) = 2*(ymax)*rand(1, numDots) - ymax;
dots_h_theta(2,:) = (2*pi)*rand(1,numDots);
% Calculate x,y and z
dots_xyz(1,:) =  radi*cos(dots_h_theta(2,:));
dots_xyz(2,:) =  dots_h_theta(1,:);
dots_xyz(3,:) =  radi*sin(dots_h_theta(2,:));

%Left Eye 
dots_screen(1,:) = dots_xyz(1,:) + dots_xyz(3,:) .* ( (dots_xyz(1,:) - dis) / (view - dots_xyz(3,:)) );
dots_screen(2,:) = dots_xyz(2,:) + dots_xyz(3,:) .* ( dots_xyz(2,:) / (view - dots_xyz(3,:)));
%Right eye
dots_screen(1,:) = dots_xyz(1,:) + dots_xyz(3,:) .* ( (dots_xyz(1,:) + dis) / (view - dots_xyz(3,:)) ); 

% Rotate once, just because want to know it works.
dots_h_theta(2,:) = dots_h_theta(2,:) + 2*pi/120;
dots_xyz(1,:) =  radi*cos(dots_h_theta(2,:));
dots_xyz(3,:) =  radi*sin(dots_h_theta(2,:));


shaderpath = pwd;
% Load the grey 3X shader named grey3x.frag in the same folder.
glsl(1)=LoadGLSLProgramFromFiles([shaderpath '\grey3x'],2);
glUseProgram(0);

while ~KbCheck


    % Draw left stim:
    Screen('FillRect', windowPtr, [0 0 0]);
    Screen('DrawDots', windowPtr, dots_screen,  dotSize, col1, [windowRect(3:4)/2], 1);
    Screen('FrameRect', windowPtr, [100 0 0], [], 5);
    Screen('FillRect', windowPtr, [255, 0, 255], blueRectLeftOn);
    Screen('FillRect', windowPtr, [0, 0, 0], blueRectLeftOff);
    
    Screen('DrawingFinished', windowPtr);
    
    %Screen('DrawTexture', main_windowPtr, windowPtr, [], [], [], [], [], []);
    Screen('DrawTexture', main_windowPtr, windowPtr, [], [], [], [], [], [], glsl(1));
    Screen('Flip', main_windowPtr);
    
    % Draw right stim:
    dots_screen(1,:) = dots_xyz(1,:) + dots_xyz(3,:) .* ( (dots_xyz(1,:) + dis) / (view - dots_xyz(3,:)) );
    Screen('FillRect', windowPtr_R, [0 0 0]);
    Screen('DrawDots', windowPtr_R, dots_screen, dotSize, col2, [windowRect(3:4)/2], 1);
    Screen('FrameRect', windowPtr_R, [200 0 0], [], 5);
    Screen('FillRect', windowPtr_R, [255, 0, 255], blueRectRightOn);
    Screen('FillRect', windowPtr_R, [0, 0, 0], blueRectRightOff);

    % Flip stim to display and take timestamp of stimulus-onset after
    % displaying the new stimulus and record it in vector t:
    Screen('DrawingFinished', windowPtr_R);
    %onset = Screen('Flip', windowPtr);
    %Screen('DrawTexture', main_windowPtr, windowPtr, [], [], [], [], [], []);
    Screen('DrawTexture', main_windowPtr, windowPtr_R, [], [], [], [], [], [], glsl(1));
    Screen('Flip', main_windowPtr);

    %Left Eye 

 

    % Rotate
    dots_h_theta(2,:) = dots_h_theta(2,:) + speed;
    dots_xyz(1,:) =  radi*cos(dots_h_theta(2,:));
    dots_xyz(3,:) =  radi*sin(dots_h_theta(2,:));
    
    dots_screen(1,:) = dots_xyz(1,:) + dots_xyz(3,:) .* ( (dots_xyz(1,:) - dis) / (view - dots_xyz(3,:)) );
    dots_screen(2,:) = dots_xyz(2,:) + dots_xyz(3,:) .* ( dots_xyz(2,:) / (view - dots_xyz(3,:)));
    % Now all non-drawing tasks:

end 
KbCheck

if Datapixx('IsPropixx')
    Datapixx('SetPropixxDlpSequenceProgram', 0);
end
Datapixx('RegWr');
Datapixx('Close');
sca;

end