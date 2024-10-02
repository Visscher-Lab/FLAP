function bars_retinotopy(saveInfo,stimParams,TR,scanDur,display,tChar,rChar)

%% Retinotopy Bar stimuli
%
%   Usage:
%   play_pRF(saveInfo,stimParams,TR,scanDur,display,tChar,rChar)
%
%   Required inputs:
%   saveInfo.subjectName    - subject name
%   saveInfo.fileName       - full path and name of output file
%
%   Defaults:
%   stimParams              - loads structure of stimulus parameters created using 'make_bars';
%   TR                      - 1.5; % TR (seconds)
%   scanDur                 - 375: % scan duration (seconds)
%   display.distance        - 106.5; % distance from screen (cm) - (UPenn - SC3T);
%   display.width           - 69.7347; % width of screen (cm) - (UPenn - SC3T);
%   display.height          - 39.2257; % height of screen (cm) - (UPenn - SC3T);
%   tChar                   - {'t'}; % character(s) to signal a scanner trigger
%   rChar                   - {'r' 'g' 'b' 'y'}; % character(s) to signal a button response
%
%   Written by Pinar Demirayak

%% Set defaults
% Get git repository information
fCheck                          = which('GetGitInfo');
if ~isempty(fCheck)
    thePath                     = fileparts(mfilename('fullpath'));
    gitInfo                     = GetGITInfo(thePath);
else
    gitInfo                     = 'function ''GetGITInfo'' not found';
end
% Get user name
[~, tmpName]                    = system('whoami');
userName                        = strtrim(tmpName);

imagesFull                  = stimParams.imagesFull;
switches                    = stimParams.switches;
clear tmp;

% TR
if ~exist('TR','var') || isempty(TR)
    TR                          = 1.5;
end
% scan duration
if ~exist('scanDur','var') || isempty(scanDur)
    scanDur                     = 375; % seconds
end
% dispaly parameters
if ~exist('display','var') || isempty(display)
    display.distance            = 106.5; % distance from screen (cm);
    display.width               = 69.7347; % width of screen (cm);
    display.height              = 39.2257; % height of screen (cm);
end
% scanner trigger
if ~exist('tChar','var') || isempty(tChar)
    tChar                       = {'t'};
end
% scanner trigger
if ~exist('rChar','var') || isempty(rChar)
    rChar                       = {'r' 'g' 'b' 'y'};
end
% Save input variables
params.functionName             = mfilename;
params.gitInfo                  = gitInfo;
params.userName                 = userName;
params.subjectName              = saveInfo.subjectName;
params.TR                       = TR;
params.scanDur                  = scanDur;
%% For Trigger
a                               = cd;
if a(1)=='/' % mac or linux
    a                           = PsychHID('Devices');
    for i = 1:length(a)
        d(i)                    = strcmp(a(i).usageName, 'Keyboard');
    end
    keybs                       = find(d);
else % windows
    keybs                       = [];
end

%% Initial settings
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 2); % Skip sync tests
screens                         = Screen('Screens'); % get the number of screens
screenid                        = max(screens); % draw to the external screen
%% Define black and white
white                           = WhiteIndex(screenid);
black                           = BlackIndex(screenid);
grey                            = white/2;
%% Screen params
res                             = Screen('Resolution',max(Screen('screens')));
display.resolution              = [res.width res.height];
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'UseRetinaResolution');
[winPtr, windowRect]            = PsychImaging('OpenWindow', screenid, grey);
[mint,~,~]                      = Screen('GetFlipInterval',winPtr,100);
display.frameRate               = 1/mint; % 1/monitor flip interval = framerate (Hz)
display.screenAngle             = pix2angle( display, display.resolution );
[screenXpix, screenYpix]        = Screen('WindowSize', winPtr);% Get the size of the on screen window
%[center(1), center(2)]          = RectCenter(windowRect); % Get the center coordinate of the window
fix_mask                        = angle2pix(display,0.75); % For fixation mask (0.75 degree)
fix_dot                         = angle2pix(display,0.25); % For fixation dot (0.25 degree)

green = [0 1 0];
red = [1 0 0];

%% Dot stimulus params
% Set the blend function so that we get nice antialised edges
Screen('BlendFunction', winPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
%% stimulus specific params
for i = 1:size(imagesFull,3)
    tmp = imagesFull(:,:,i);
    Texture(i) = Screen('MakeTexture', winPtr, tmp);
end
%% Set to command window
commandwindow;
%% Run try/catch
try
    %% Display Text, wait for Trigger
    Screen('FillRect',winPtr, grey);

    Screen('FillOval',winPtr,grey,[screenXpix/2-fix_mask/2, ...
        screenYpix/2-fix_mask/2,screenXpix/2+fix_mask/2,screenYpix/2+fix_mask/2]);
    Screen('FillOval',winPtr,red,[screenXpix/2-fix_dot/2, ...
        screenYpix/2-fix_dot/2,screenXpix/2+fix_dot/2,screenYpix/2+fix_dot/2]);

    Screen('Flip',winPtr);
    ListenChar(2);
    HideCursor;
    soundsc(sin(1:.5:1000)); % play 'ready' tone
    disp('Ready, waiting for trigger...');
    startTime = wait4T(tChar);  %wait for 't' from scanner.
    %% Drawing Loop
    breakIt                     = 0;
    Keyct                       = 0;
    curFrame                    = 1;
    params.startDateTime        = datestr(now);
    params.endDateTime          = datestr(now); % this is updated below
    params.FlickerTimes         = switches;
    disp(['Trigger received - ' params.startDateTime]);
    while GetSecs-startTime < scanDur && ~breakIt  %loop until 'esc' pressed or time runs out
        % update timers
        elapsedTime = GetSecs-startTime;
        % check to see if the "esc" button was pressed
        breakIt = escPressed(keybs);
        % log button responses
        if CharAvail
            ch = GetChar;
            if sum(strcmp(ch,rChar))
                Keyct = Keyct+1;
                params.RT(Keyct) = GetSecs;
                disp(['Response ' num2str(Keyct) ' received']);
            end
            FlushEvents;
        end
        % Display 13 frames / TR
        if abs((elapsedTime / (TR / 13 )) - curFrame) > 0
            curFrame = ceil( elapsedTime / (TR / 13 ));
        end

        % carrier
        Screen( 'DrawTexture', winPtr, Texture(curFrame)); % current frame

        % Fixation Mask
        Screen('FillOval',winPtr,grey,[screenXpix/2-fix_mask/2, ...
            screenYpix/2-fix_mask/2,screenXpix/2+fix_mask/2,screenYpix/2+fix_mask/2]);
        if any(curFrame == switches)
            Screen('FillOval',winPtr,green,[screenXpix/2-fix_dot/2, ...
                screenYpix/2-fix_dot/2,screenXpix/2+fix_dot/2,screenYpix/2+fix_dot/2]);
        else
            Screen('FillOval',winPtr,red,[screenXpix/2-fix_dot/2, ...
                screenYpix/2-fix_dot/2,screenXpix/2+fix_dot/2,screenYpix/2+fix_dot/2]);
        end
        % Flip to the screen
        Screen('Flip', winPtr);
        params.endDateTime      = datestr(now);
        WaitSecs(0.001);
    end
    sca;
    disp(['elapsedTime = ' num2str(elapsedTime)]);
    ListenChar(1);
    ShowCursor;
    Screen('CloseAll');
    %% Save params
    params.display              = display;
    params.stimParams           = stimParams;
    save(saveInfo.fileName,'params','-v7.3');
catch ME
    Screen('CloseAll');
    ListenChar(1);
    ShowCursor;
    rethrow(ME);
end