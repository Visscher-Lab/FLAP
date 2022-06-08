function DatapixxShowGabor(frames, nbr_of_Gabor, win)
% function DatapixxShowGabor(frames = 4800, nbr_of_Gabor = 200, win)
%
% This has been inspired by GaboriumDemo.m from Psychtoolbox.
%
% This demo constructs a gabor aquarium at 480 Hz. It displays the Gabor
% for a set amount of frames given by the frames argument. The number of gabor
% is determined by nbr_of_Gabor and the max amount depends on the speed
% of your computer. 
%
% frames --         Number of frames to animate the stimuli for (optional, 
%                   default is 4800)
% nbr_of_Gabor --   Number of Gabor to be in the stimuli (optional, default
%                   is 200)
% win --            Handle to the win (optional, default is full screen)
%
% Oct 29, 2014      dml     Written
% Mar 23, 2018      dml     Updated

% Initialize the PROPixx to 480 Hz

Datapixx('Open');
Datapixx('SetPropixxDlpSequenceProgram', 2); % 2 for 480, 5 for 1440 Hz, 0 for normal
Datapixx('RegWrRd');


if nargin < 3 || isempty(win)
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
    screenid = max(Screen('Screens'));
    [win win_rect] = PsychImaging('OpenWindow', screenid, 128);
end

if nargin < 2 || isempty(nbr_of_Gabor)
    nbr_of_Gabor = 100;
end

if nargin < 1 || isempty(frames)
    frames = 4800;
end


% Set the transparency for gabor patch
Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE);
% Get refresh rate
ifi = Screen('GetFlipInterval', win);

%Generate a Gabor patch (from GaboriumDemo.m)
s = 32;
res = 2*[s s];
phase = 0;
sc = 5;
freq = 0.05;
tilt = 0;
contrast = 5;
x=res(1)/2;
y=res(2)/2;
sf = freq;
[gab_x gab_y] = meshgrid(0:(res(1)-1), 0:(res(2)-1));
a=cos(deg2rad(tilt))*sf*360;
b=sin(deg2rad(tilt))*sf*360;
multConst=1/(sqrt(2*pi)*sc);
x_factor=-1*(gab_x-x).^2;
y_factor=-1*(gab_y-y).^2;
sinWave=sin(deg2rad(a*(gab_x - x) + b*(gab_y - y)+phase));
varScale=2*sc^2;
m=contrast*(multConst*exp(x_factor/varScale+y_factor/varScale).*sinWave)';

%Transform the gabors into texture
gabortex=Screen('MakeTexture', win, m, [], [], 2);
texrect = Screen('Rect', gabortex);
inrect = repmat(texrect', 1, nbr_of_Gabor);

% Create the array for the 4 quadrants gabor
dstRects = zeros(4, nbr_of_Gabor);
dstRects_q2 = zeros(4, nbr_of_Gabor);
dstRects_q3 = zeros(4, nbr_of_Gabor);
dstRects_q4 = zeros(4, nbr_of_Gabor);
srcRects = [];
rotAngles = rand(1, nbr_of_Gabor) * 360;

% Create the right amount of gabors, and scale them randomly
for i=1:nbr_of_Gabor
    scale(i) = 2*(0.1 + 0.9 * randn);
    dstRects(:, i) = CenterRectOnPoint(texrect * scale(i), rand * 1920/2, rand * 1080/2)';
end

% Initial flip
vbl = Screen('Flip', win);
number_of_frames = 1;

% Stimulus
while number_of_frames < frames

    % FRAME 1
    if number_of_frames > frames
        vbl = Screen('Flip', win, vbl + 0.5 * ifi);
        break;
    end
    Screen('DrawTextures', win, gabortex, srcRects, dstRects, rotAngles, [], 0.5, [], [], 0);
    number_of_frames = number_of_frames + 1;
    
    % Animate
    rotAngles = rotAngles + 1 * randn(1, nbr_of_Gabor);
    [x y] = RectCenterd(dstRects);
    x = mod(x + cos(rotAngles/360*2*pi), 1920/2);
    y = mod(y + sin(rotAngles/360*2*pi), 1080/2);
    dstRects_q2 = CenterRectOnPointd(inrect .*  repmat(scale,4,1), x, y);

    % Move to Q2
    dstRects_q2(1,:) = dstRects_q2(1,:) + 1920/2;
    dstRects_q2(3,:) = dstRects_q2(3,:) + 1920/2;

    % FRAME 2
    if number_of_frames > frames
        vbl = Screen('Flip', win, vbl + 0.5 * ifi);
        break;
    end
    Screen('DrawTextures', win, gabortex, srcRects, dstRects_q2, rotAngles, [], 0.5, [], [], 0);
    number_of_frames = number_of_frames + 1;
    
    % animate
    rotAngles = rotAngles + 1 * randn(1, nbr_of_Gabor);
    [x y] = RectCenterd(dstRects_q2);
    x = mod(x + cos(rotAngles/360*2*pi), 1920/2);
    y = mod(y + sin(rotAngles/360*2*pi), 1080/2);
    dstRects_q3 = CenterRectOnPointd(inrect .* repmat(scale,4,1), x, y);

    % Move to Q3
    dstRects_q3(2,:) = dstRects_q3(2,:) + 1080/2;
    dstRects_q3(4,:) = dstRects_q3(4,:) + 1080/2;

    % FRAME 3
    if number_of_frames > frames
        vbl = Screen('Flip', win, vbl + 0.5 * ifi);
        break;
    end
    Screen('DrawTextures', win, gabortex, srcRects, dstRects_q3, rotAngles, [], 0.5, [], [], 0);
    number_of_frames = number_of_frames + 1;

    % Animate
    rotAngles = rotAngles + 1 * randn(1, nbr_of_Gabor);
    [x y] = RectCenterd(dstRects_q3);
    x = mod(x + cos(rotAngles/360*2*pi), 1920/2);
    y = mod(y + sin(rotAngles/360*2*pi), 1080/2);
    dstRects_q4 = CenterRectOnPointd(inrect .* repmat(scale,4,1), x, y);

    % Move to Q4
    dstRects_q4(1,:) = dstRects_q4(1,:) + 1920/2;
    dstRects_q4(2,:) = dstRects_q4(2,:) + 1080/2;
    dstRects_q4(3,:) = dstRects_q4(3,:) + 1920/2;
    dstRects_q4(4,:) = dstRects_q4(4,:) + 1080/2;

    % FRAME 4
    if number_of_frames > frames
        vbl = Screen('Flip', win, vbl + 0.5 * ifi);
        break;
    end
    Screen('DrawTextures', win, gabortex, srcRects, dstRects_q4, rotAngles, [], 0.5, [], [], 0);
    number_of_frames = number_of_frames + 1;

    % animate for next frame
    rotAngles = rotAngles + 1 * randn(1, nbr_of_Gabor);
    [x y] = RectCenterd(dstRects_q4);
    x = mod(x + cos(rotAngles/360*2*pi), 1920/2);
    y = mod(y + sin(rotAngles/360*2*pi), 1080/2);
    dstRects = CenterRectOnPointd(inrect .* repmat(scale,4,1), x, y);

    % Update the four Qudrants
    vbl = Screen('Flip', win, vbl + 0.5 * ifi);

    [pressed dummy keycode] = KbCheck;
    if pressed
        break;
    end
    
end

% Blank screen
Screen('Flip', win);

% Exit on escape
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
while 1
 % Check the state of the keyboard.
    [ keyIsDown, ~, keyCode ] = KbCheck;
 if keyIsDown
    if keyCode(escapeKey)
        Screen('CloseAll')
        break;
    end
 end
end

%Restore PROPixx State
Datapixx('SetPropixxDlpSequenceProgram', 0);
Datapixx('RegWrRd');
Datapixx('close');
clear all;


