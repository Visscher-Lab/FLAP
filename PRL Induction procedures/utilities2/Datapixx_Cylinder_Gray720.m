function Datapixx_Cylinder_Gray720()

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

% Setup the PROPixx to be in Gray720.
Datapixx('Open');
if Datapixx('IsPropixx')
    Datapixx('SetPropixxDlpSequenceProgram', 10);
end
Datapixx('RegWr');

[windowPtr, windowRect]=PsychImaging('OpenWindow', scrnNum, [128 128 128], [], [], [], 0);

% Set up alpha-blending for stacking of colors.
Screen('BlendFunction', windowPtr, 'GL_ONE', 'GL_ONE');

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

while ~KbCheck


    % Draw Red (frame 1) stim:
    Screen('DrawDots', windowPtr, dots_screen,  dotSize, [255 0 0], [windowRect(3:4)/2], 1);
    
    % Rotate
    dots_h_theta(2,:) = dots_h_theta(2,:) + speed;
    dots_xyz(1,:) =  radi*cos(dots_h_theta(2,:));
    dots_xyz(3,:) =  radi*sin(dots_h_theta(2,:));
    
    dots_screen(1,:) = dots_xyz(1,:) + dots_xyz(3,:) .* ( (dots_xyz(1,:) - dis) / (view - dots_xyz(3,:)) );
    dots_screen(2,:) = dots_xyz(2,:) + dots_xyz(3,:) .* ( dots_xyz(2,:) / (view - dots_xyz(3,:)));

    % Draw Green frame 2 stim:
    Screen('DrawDots', windowPtr, dots_screen, dotSize, [0 255 0], [windowRect(3:4)/2], 1);

    % Rotate
    dots_h_theta(2,:) = dots_h_theta(2,:) + speed;
    dots_xyz(1,:) =  radi*cos(dots_h_theta(2,:));
    dots_xyz(3,:) =  radi*sin(dots_h_theta(2,:));
    
    dots_screen(1,:) = dots_xyz(1,:) + dots_xyz(3,:) .* ( (dots_xyz(1,:) - dis) / (view - dots_xyz(3,:)) );
    dots_screen(2,:) = dots_xyz(2,:) + dots_xyz(3,:) .* ( dots_xyz(2,:) / (view - dots_xyz(3,:)));
    
    % Draw Blue Frame 3 stim:
    Screen('DrawDots', windowPtr, dots_screen,  dotSize, [0 0 255], [windowRect(3:4)/2], 1);
    
    onset = Screen('Flip', windowPtr);
    
    % Rotate
    dots_h_theta(2,:) = dots_h_theta(2,:) + speed;
    dots_xyz(1,:) =  radi*cos(dots_h_theta(2,:));
    dots_xyz(3,:) =  radi*sin(dots_h_theta(2,:));
    
    dots_screen(1,:) = dots_xyz(1,:) + dots_xyz(3,:) .* ( (dots_xyz(1,:) - dis) / (view - dots_xyz(3,:)) );
    dots_screen(2,:) = dots_xyz(2,:) + dots_xyz(3,:) .* ( dots_xyz(2,:) / (view - dots_xyz(3,:)));

end 
KbWait;
sca;

end