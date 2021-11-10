function DatapixxImagingStereoDots_cylinder_VPxGreyscale()
% THIS DEMO IS MADE FOR FOR VIEWPIXX3D ONLY
% ***********
AssertOpenGL;

% Define response key mappings, unify the names of keys across operating
% systems:
KbName('UnifyKeyNames');
space = KbName('space');
escape = KbName('ESCAPE');

scrnNum = max(Screen('Screens'));
InitializeMatlabOpenGL;
PsychImaging('PrepareConfiguration');

% Tell PTB we want to display on a DataPixx device:
PsychImaging('AddTask', 'General', 'UseDataPixx');

% Setup the VIEWPixx to be in Grayscale.

Datapixx('Open');
Datapixx('SelectDevice', 4, 'LEFT'); 	% SELECTS THE LEFT VIEWPIXX MONITOR
Datapixx('SetVideoGreyscaleMode', 1);	% TURNS ON THE NEW FEATURE ON LEFT MONITOR (USE RED)
Datapixx('SelectDevice', 4, 'RIGHT');	% SELECTS THE RIGHT VIEWPIXX MONITOR
Datapixx('SetVideoGreyscaleMode', 2);	% TURNS ON THE NEW FEATURE ON RIGHT MONITOR (USE GREEN)
Datapixx('SelectDevice', -1); 		% Return to automatic device selection 
Datapixx('RegWr');


[windowPtr, windowRect]=PsychImaging('OpenWindow', scrnNum, [128 128 128], [], [], [], 0);

% !!!!!CRITICAL FUNCTION FOR STIMULI TO ADD COLORS TOGETHER!!!!
% Set up alpha-blending for stacking of colors. 
Screen('BlendFunction', windowPtr, 'GL_ONE', 'GL_ONE');
% CRITICAL CALL ^^^

[screenXpix, screenYpix] = Screen('WindowSize', windowPtr);
Screen('Flip', windowPtr);

%Cylinder set-up
col1 = WhiteIndex(scrnNum);
col2 = col1;
dotSize = 8;
numDots = 1000;
radi = 200;
dis = 0;%100;
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

oldTextSize=Screen('TextSize', windowPtr, 48);
Screen('DrawText', windowPtr, 'VIEWPixx Left', 400, 150, [255 128 0]);
Screen('DrawText', windowPtr, 'VIEWPixx Right', 400, 250, [128 255 0]);
Screen('DrawText', windowPtr, 'Press enter to start stim', 400, 350, [255 255 255]);
onset = Screen('Flip', windowPtr);

KbWait;
onset = Screen('Flip', windowPtr);
WaitSecs(0.5);
while ~KbCheck


    % Draw Red (VIEWPixx LEFT) stim:
    Screen('DrawDots', windowPtr, dots_screen,  dotSize, [255 0 0], [windowRect(3:4)/2], 1);
    
    % Rotate
    dots_h_theta(2,:) = dots_h_theta(2,:) + speed;
    dots_xyz(1,:) =  radi*cos(dots_h_theta(2,:));
    dots_xyz(3,:) =  radi*sin(dots_h_theta(2,:));
    
    dots_screen(1,:) = dots_xyz(1,:) + dots_xyz(3,:) .* ( (dots_xyz(1,:) - dis) / (view - dots_xyz(3,:)) );
    dots_screen(2,:) = dots_xyz(2,:) + dots_xyz(3,:) .* ( dots_xyz(2,:) / (view - dots_xyz(3,:)));

    % Draw Green (VIEWPixx RIGHT) stim:
    Screen('DrawDots', windowPtr, dots_screen, dotSize, [0 255 0], [windowRect(3:4)/2], 1);

    % Rotate
    dots_h_theta(2,:) = dots_h_theta(2,:) + speed;
    dots_xyz(1,:) =  radi*cos(dots_h_theta(2,:));
    dots_xyz(3,:) =  radi*sin(dots_h_theta(2,:));
    
    dots_screen(1,:) = dots_xyz(1,:) + dots_xyz(3,:) .* ( (dots_xyz(1,:) - dis) / (view - dots_xyz(3,:)) );
    dots_screen(2,:) = dots_xyz(2,:) + dots_xyz(3,:) .* ( dots_xyz(2,:) / (view - dots_xyz(3,:)));
    
    onset = Screen('Flip', windowPtr); % Has both LEFT and RIGHT (RED and GREEN)
    

end 
KbWait;

% Turn it off!
Datapixx('SelectDevice', 4, 'LEFT'); 	% SELECTS THE LEFT VIEWPIXX MONITOR
Datapixx('SetVideoGreyscaleMode', 0);	% TURNS OFF THE NEW FEATURE ON LEFT MONITOR (USE RED)
Datapixx('SelectDevice', 4, 'RIGHT');	% SELECTS THE RIGHT VIEWPIXX MONITOR
Datapixx('SetVideoGreyscaleMode', 0);	% TURNS OFF THE NEW FEATURE ON RIGHT MONITOR (USE GREEN)
Datapixx('SelectDevice', -1); 		% Return to automatic device selection 
Datapixx('RegWr');


sca;


end