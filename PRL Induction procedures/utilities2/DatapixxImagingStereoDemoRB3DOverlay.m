 function DatapixxImagingStereoDemoRB3DOverlay()
%
% Taken from the iconic PTB ImagingStereoDemo,
% slightly modified to drive PROPixx in RB3D mode.
%
% Press any key to exit demo.
%
% June 6, 2017  dml     Written
% Mar 20, 2018	dml		Revised

AssertOpenGL;

% Define response key mappings, unify the names of keys across operating
% systems:
KbName('UnifyKeyNames');
space = KbName('space');
escape = KbName('ESCAPE');

% Get the list of Screens and choose the one with the highest screen number.
% Screen 0 is, by definition, the display with the menu bar. Often when
% two monitors are connected the one without the menu bar is used as
% the stimulus display.  Choosing the display with the highest display number is
% a best guess about where you want the stimulus displayed.
scrnNum = max(Screen('Screens'));

% Prepare pipeline for configuration. This marks the start of a list of
% requirements/tasks to be met/executed in the pipeline:
PsychImaging('PrepareConfiguration');

% Tell PTB we want to display on a DataPixx device:
PsychImaging('AddTask', 'General', 'UseDataPixx');

% Enable PROPixx RB3D Sequencer
Datapixx('Open');


% You can modify the per eye crosstalk here.
Datapixx('SetPropixx3DCrosstalkLR', 0);
Datapixx('SetPropixx3DCrosstalkRL', 0);
Datapixx('RegWrRd')

% Open the window
[windowPtr, windowRect]=PsychImaging('OpenWindow', scrnNum, 0);


Datapixx('SetVideoMode', 9); % Enable the overlay on the PPX CTRL
Datapixx('RegWrRd');
Datapixx('SetPropixxDlpSequenceProgram', 1);
Datapixx('RegWr');

% Stimulus settings:
numDots = 1000;
vel = 1;   % pix/frames
dotSize = 8;
dots = zeros(3, numDots);

xmax = RectWidth(windowRect)/2;
ymax = RectHeight(windowRect)/2;
xmax = min(xmax, ymax) / 2;
ymax = xmax;

f = 4*pi/xmax;
amp = 16;

dots(1, :) = 2*(xmax)*rand(1, numDots) - xmax;
dots(2, :) = 2*(ymax)*rand(1, numDots) - ymax;
%Set up the CLUTs
defaultColorConsole = [1, 0, 1];
defaultColorTest = [0, 0, 0];
clutTestDisplay = repmat(defaultColorTest, [256,1]);   % By default, all overlays are Magenta
clutConsoleDisplay = repmat(defaultColorConsole, [256,1]);   % By default, all overlays are Magenta


clutConsoleDisplay(1:150,:) = repmat([1, 0, 0], [150,1]);   % Items drawn with 242:246 show on console display in red
clutConsoleDisplay(151:199,:) = repmat([0, 1, 0], [49,1]);   % Items drawn with 247:251 show on console display as green % 
clutConsoleDisplay(200:256,:) = repmat([0, 0, 1], [57,1]);   % Items drawn with 252:256 show on console display as blue % FOR MAC

%Send the CLUT
Datapixx('SetVideoClut', [clutTestDisplay;clutConsoleDisplay]);
Datapixx('RegWrRd');

% Initially fill left- and right-eye image buffer with black background
% color:
Screen('FillRect', windowPtr, BlackIndex(scrnNum));
Screen('Flip', windowPtr);


% Set up alpha-blending for smooth (anti-aliased) drawing of dots, as well
% as blending of the colors!
Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_DST_ALPHA');

col1 = [255 0 0];
col2 = [0 0 255];
i = 1;
keyIsDown = 0;
center = [0 0];
sigma = 50;
xvel = 2*vel*rand(1,1)-vel;
yvel = 2*vel*rand(1,1)-vel;

Screen('Flip', windowPtr);

% Maximum number of animation frames to show:
nmax = 100000;

% Perform a flip to sync us to vbl and take start-timestamp in t:
t = Screen('Flip', windowPtr);

% Run until a key is pressed:
while length(t) < nmax


    % Draw left stim:
    Screen('DrawDots', windowPtr, dots(1:2, :) + [dots(3, :)/2; zeros(1, numDots)], dotSize, col1, [windowRect(3:4)/2], 1);

    % Draw right stim:
    Screen('DrawDots', windowPtr, dots(1:2, :) - [dots(3, :)/2; zeros(1, numDots)], dotSize, col2, [windowRect(3:4)/2], 1);
    
    DrawFormattedText(windowPtr, 'Should be in red', 'center', 40, [0 128 0]);      % Overlay only visible on test display
    DrawFormattedText(windowPtr, 'Should be in green', 'center', 80, [0 192 0]);   % Overlay only visible on console display
    DrawFormattedText(windowPtr, 'Should be in blue', 'center', 'center', [0 253 0]);
    % Draw borders
    Screen('FrameRect', windowPtr, [255 0 255], [], 15);
    Screen('FrameRect', windowPtr, [255 0 0], [], 10);
    Screen('FrameRect', windowPtr, [0 0 255], [], 5);
    
    % Flip stim to display and take timestamp of stimulus-onset after
    % displaying the new stimulus and record it in vector t:
    onset = Screen('Flip', windowPtr);
    t = [t onset];

    % Now all non-drawing tasks:

    % Compute dot positions and offsets for next frame:
    center = center + [xvel yvel];
    if center(1) > xmax | center(1) < -xmax
        xvel = -xvel;
    end

    if center(2) > ymax | center(2) < -ymax
        yvel = -yvel;
    end

    dots(3, :) = -amp.*exp(-(dots(1, :) - center(1)).^2 / (2*sigma*sigma)).*exp(-(dots(2, :) - center(2)).^2 / (2*sigma*sigma));

    % Keypress ends demo
    [pressed dummy keycode] = KbCheck;
    if pressed
        break;
    end
end 

% Last Flip:
Screen('Flip', windowPtr);

% Set the PROPixx back to normal sequencer
Datapixx('SetVideoMode', 0);
Datapixx('SetPropixxDlpSequenceProgram', 0);
Datapixx('RegWrRd');
Datapixx('GetError')

% Done. Close the onscreen window:
Screen('CloseAll')
Datapixx('Close');

% Compute and show timing statistics:
dt = t(2:end) - t(1:end-1);
disp(sprintf('N.Dots\tMean (s)\tMax (s)\t%%>20ms\t%%>30ms\n'));
disp(sprintf('%d\t%5.3f\t%5.3f\t%5.2f\t%5.2f\n', numDots, mean(dt), max(dt), sum(dt > 0.020)/length(dt), sum(dt > 0.030)/length(dt)));

% We're done.
return;

