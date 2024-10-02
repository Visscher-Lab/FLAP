function stimulus = rings_retinotopy2(saveInfo,sparams,TR,scanDur,display,tChar,rChar)
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
images                  = sparams.rings;

clear tmp;
% TR
if ~exist('TR','var') || isempty(TR)
    TR                          = 1.5;
end
% scan duration
if ~exist('scanDur','var') || isempty(scanDur)
    scanDur                     = 270; % seconds
end
% dispaly parameters
if ~exist('display','var') || isempty(display)
    display.distance            = 106.5; % distance from screen (cm) - (UPenn - SC3T);
    display.width               = 69.7347; % width of screen (cm) - (UPenn - SC3T);
    display.height              = 39.2257; % height of screen (cm) - (UPenn - SC3T);
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
site=5;
responsebox=1;
countergreen=0; % counter for target appearance (fixation dot turns green)
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
if site == 5 %&& (~dpx_isReady)
    FlipInt=Screen('GetFlipInterval',winPtr); %Gets Flip Interval. PD moved it to here from the main scrip 8/15/23
    Fs = 44100;
    Datapixx('Open');
    audioGrpDelay=Datapixx('GetAudioGroupDelay',Fs);
    audioDelay=FlipInt-audioGrpDelay;
    Datapixx('StopAllSchedules');
    Datapixx('InitAudio');
    Datapixx('SetAudioVolume', [1,1]);
    Datapixx('SetDinLog');
    Datapixx('StartDinLog');
    Datapixx('EnableDinDebounce');
    Datapixx('RegWrRd');
    Screen('Preference', 'SkipSyncTests', 1);
    Datapixx('SetupTPxSchedule');
    Datapixx('RegWrRd');
    Datapixx('StartTPxSchedule');
    Datapixx('RegWrRdVideoSync'); % put VideoSync here, so that the eye tracking sync with the flipping
    EyeTrack_StartTime=Datapixx('GetTime');
end
%% Wandell's code
% outerRad=14;
% %outerRad     = 13.1027;
% innerRad     = 0;
% wedgeDeg=30;subWedgeDeg=5;
% wedgeWidth=1.5708;
% %wedgeWidth       =wedgeDeg * (pi/180);
% %wedgeWidth   = 0.7854;
% %ringWidth    = 6.5514;
% ringWidth=1.6378;
% numImages    = 128;
% numMotSteps  = 2;
% numSubRings=1;
% %numSubRings  = 6.5514;
% %numSubWedges = 1.5;
% numSubWedges     = wedgeDeg/(2*subWedgeDeg);
% bk = 128;
% stimRgbRange=[0:1:255];
% minCmapVal = min(stimRgbRange);
% maxCmapVal = max(stimRgbRange);
% if isfield(params, 'contrast')
%     c = 1;
%     bg = (minCmapVal + maxCmapVal)/2;
%     minCmapVal = round((1-c) * bg);
%     maxCmapVal = round((1+c) * bg);
% end
%
% %%% Initialize image template %%%
% m = 2 * angle2pix(display, outerRad);
% n = 2 * angle2pix(display, outerRad);
%
% % should really do something more intelligent, like outerRad-fix
%
% [x,y]=meshgrid(linspace(-outerRad,outerRad,n),linspace(outerRad,-outerRad,m));
% mask = makecircle(m);
% % r = eccentricity; theta = polar angle
% r = sqrt (x.^2  + y.^2);
% theta = atan2 (y, x);					% atan2 returns values between -pi and pi
% theta(theta<0) = theta(theta<0)+2*pi;	% correct range to be between 0 and 2*pi
%
% % Calculate checkerboard.
% % Wedges alternating between -1 and 1 within stimulus window.
% % The computational contortions are to avoid sign=0 for sin zero-crossings
% wedges = sign(2*round((sin(theta*numSubWedges*(2*pi/wedgeWidth))+1)/2)-1);
% posWedges = find(wedges==1);
% negWedges = find(wedges==-1);
%
% rings = sign(2*round((sin(r*numSubRings*(2*pi/ringWidth))+1)/2)-1);
%
% checks   = zeros(size(rings,1),size(rings,2),numMotSteps);
% for ii=1:numMotSteps,
%     tmprings1 = sign(2*round((sin(r*numSubRings*(2*pi/ringWidth)+(ii-1)/numMotSteps*2*pi)+1)/2)-1);
%     tmprings2 = sign(2*round((sin(r*numSubRings*(2*pi/ringWidth)-(ii-1)/numMotSteps*2*pi)+1)/2)-1);
%     rings(posWedges)=tmprings1(posWedges);
%     rings(negWedges)=tmprings2(negWedges);
%
%     checks(:,:,ii)=minCmapVal+ceil((maxCmapVal-minCmapVal) * (wedges.*rings+1)./2);
% end;
%
% % Loop that creates the final images
% %fprintf('[%s]:Creating %d images:',mfilename,numImages);
% images=zeros(m,n,numImages*numMotSteps,'uint8');
% for imgNum=1:numImages
%     loAngle = 0;
%     hiAngle = 2*pi;
%     loEcc = outerRad * (imgNum-1)/numImages;
%     hiEcc = loEcc+ringWidth;
%
%     % This isn't as bad as it looks
%     % Can fiddle with this to clip the edges of an expanding ring - want the ring to completely
%     % disappear from view before it re-appears again in the middle.
%
%     % Can we do this just be removing the second | from the window expression? so...
%     window = ( ((theta>=loAngle & theta<hiAngle) | ...
%         (hiAngle>2*pi & theta<mod(hiAngle,2*pi))) & ...
%         ((r>=loEcc & r<=hiEcc)) & ...
%         r<outerRad);
%
%     % yet another loop to be able to move the checks...
%     for ii=1:numMotSteps,
%         img = bk*ones(m,n);
%         tmpvar = checks(:,:,ii);
%         img(window) = tmpvar(window);
%         images(:,:,imgNum*numMotSteps-numMotSteps+ii) = uint8(img);
%     end;
%     fprintf('.');drawnow;
% end
% fprintf('Done.\n');
%
%
% temporal_freq=2;numCycles=1;
% cycle_duration=192%35;% 20 TR
% stimframe          = 1./temporal_freq./numMotSteps;
% scan_seconds       = numCycles*cycle_duration;
% scan_stimframes    = round(numCycles*cycle_duration./stimframe);
% cycle_seconds      = cycle_duration;
% cycle_stimframes   = round(cycle_seconds./stimframe);
%
% % make stimulus sequence
% % main wedges/rings
% sequence = ...
%     ones(1,cycle_stimframes./numImages)'*...
%     (1:numMotSteps:numMotSteps*numImages);
% sequence = repmat(sequence(:),numCycles,1);
%
%
%
% % motion frames within wedges/rings - lowpass
% nn=30; % this should be a less random choice, ie in seconds
% motionSeq = ones(nn,1)*round(rand(1,ceil(length(sequence)/nn)));
% motionSeq = motionSeq(:)-0.5;
% motionSeq = motionSeq(1:length(sequence));
% motionSeq = cumsum(sign(motionSeq));
%
% % wrap
% above = find(motionSeq>numMotSteps);
% while ~isempty(above),
%     motionSeq(above)=motionSeq(above)-numMotSteps;
%     above = find(motionSeq>numMotSteps);
% end;
% below = find(motionSeq<1);
% while ~isempty(below),
%     motionSeq(below)=motionSeq(below)+numMotSteps;
%     below = find(motionSeq<1);
% end;
% sequence=sequence+motionSeq-1;
%
% % fixation dot sequence
% fixSeq = ones(nn,1)*round(rand(1,ceil(length(sequence)/nn)));
% fixSeq = fixSeq(:)+1;
% fixSeq = fixSeq(1:length(sequence));
% % force binary
% fixSeq(fixSeq>2)=2;
% fixSeq(fixSeq<1)=1;
%
%
% % Insert the preappend images by copying some images from the
% % end of the seq and tacking them on at the beginning
% sequence = [sequence(length(sequence)+1:end); sequence];
% timing   = (0:length(sequence)-1)'.*stimframe;
% cmap     = load('/Users/pinardemirayak/Documents/MATLAB/cmap.mat');
% fixSeq   = [fixSeq(length(fixSeq)+1:end); fixSeq];
%%
green = [0 1 0];
red = [1 0 0];
%% Dot stimulus params
% Set the blend function so that we get nice antialised edges
Screen('BlendFunction', winPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
%% stimulus specific params
for i = 1:size(images,3)
    tmp = images(:,:,i);
    Texture(i) = Screen('MakeTexture', winPtr, tmp);
end
%% Set to command window
commandwindow;
if site==5
    TargList=[1 3]; % red=1; green=3.
    TheTrigger = 11;
end
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
if responsebox==0
    startTime = wait4T(tChar);  %wait for 't' from scanner.
else
        [Bpress timestamp1]=WaitForEvent_Jerry(500, TheTrigger); % waits for trigger
        Datapixx('SetMarker');
        Datapixx('RegWrVideoSync'); % time sync
        ExpStartTimeP=Screen('Flip',winPtr); %PTB-3
        Datapixx('RegWrRd');
        ExpStartTimeD=Datapixx('GetMarker');
        startTime=ExpStartTimeD; 
        startTime=GetSecs;
end
%% Drawing Loop
    breakIt                     = 0;
    Keyct                       = 0;
    curFrame                    = 1;
    params.startDateTime        = datestr(now);
    params.endDateTime          = datestr(now); % this is updated below
    params.FlickerTimes         = [256,400,550,710,1200,1320,1523,1810];
    disp(['Trigger received - ' params.startDateTime]);
    
     if responsebox==1
        Bpress=0;
        timestamp=-1;
        TheButtons=-1;
        inter_buttonpress{1}=[]; % added by Jason because matlab was throwing and error
        % saying that inter_buttonpress was not assigned.
        % 26 June 2018
        RespTime=[];
        PTBRespTime=[];
        binaryvals=[];
        bin_buttonpress{1}=[]; % Jerry:use array instead of cell
        inter_timestamp{1}=[]; % JERRY: NEVER USED, DO NOT UNDERSTAND WHAT IT STANDS FOR
        buttonpresscounter=0;
        if site==3 %PD: originally site~=5, changed to site==3. 8/15/23
            % Configure digital input system for monitoring button box
            Datapixx('SetDinDataDirection', hex2dec('1F0000'));     % Drive 5 button lights
            Datapixx('EnableDinDebounce');                          % Debounce button presses
            Datapixx('SetDinLog');                                  % Log button presses to default address
            Datapixx('StartDinLog');                                % Turn on logging
            Datapixx('RegWrRd');
            % Wait until all buttons are up
            while (bitand(Datapixx('GetDinValues'), hex2dec('FFFF')) ~= hex2dec('FFFF'))
                Datapixx('RegWrRd');
            end
            % Flush any past button presses
            Datapixx('SetDinLog');
            Datapixx('RegWrRd');
        elseif site ==5
            Datapixx('EnableDinDebounce');                          % Debounce button presses
            Datapixx('SetDinLog');                                  % Log button presses to default address
            Datapixx('StartDinLog');                                % Turn on logging
            Datapixx('RegWrRd');
            % Flush any past button presses
            Datapixx('SetDinLog');
            Datapixx('RegWrRd');
        end
        respgiven=0;
    end
    while GetSecs-startTime < scanDur && ~breakIt  %loop until 'esc' pressed or time runs out
        % update timers
        elapsedTime = GetSecs-startTime;
        % check to see if the "esc" button was pressed
     %   breakIt = escPressed(keybs);
     
     
             if responsebox==1
            if Bpress~=0 && respgiven==0
                buttonpresscounter=buttonpresscounter+1;
                if site ~=5
                    respoTime(buttonpresscounter)=secs;
                elseif site==5
                    respoTime(buttonpresscounter)=RespTime;
                    PTBrespoTime(buttonpresscounter)=PTBRespTime;
                    thekeys=TheButtons;
                end
                                    disp('Response received');
                respgiven=1;
            end
             end
            if respgiven==1
      if responsebox==1 && GetSecs-PTBrespoTime(end)>0.45 % to avoid long presses counting as multiple button presses
         % WaitSecs(0.5); 
        Bpress=0;
        timestamp=-1;
        TheButtons=-1;
        inter_buttonpress{1}=[]; % added by Jason because matlab was throwing and error
        % saying that inter_buttonpress was not assigned.
        % 26 June 2018
        RespTime=[];
        PTBRespTime=[];
        binaryvals=[];
        bin_buttonpress{1}=[]; % Jerry:use array instead of cell
        inter_timestamp{1}=[]; % JERRY: NEVER USED, DO NOT UNDERSTAND WHAT IT STANDS FOR
        
        if site==3 %PD: originally site~=5, changed to site==3. 8/15/23
            % Configure digital input system for monitoring button box
            Datapixx('SetDinDataDirection', hex2dec('1F0000'));     % Drive 5 button lights
            Datapixx('EnableDinDebounce');                          % Debounce button presses
            Datapixx('SetDinLog');                                  % Log button presses to default address
            Datapixx('StartDinLog');                                % Turn on logging
            Datapixx('RegWrRd');
            % Wait until all buttons are up
            while (bitand(Datapixx('GetDinValues'), hex2dec('FFFF')) ~= hex2dec('FFFF'))
                Datapixx('RegWrRd');
            end
            % Flush any past button presses
            Datapixx('SetDinLog');
            Datapixx('RegWrRd');
        elseif site ==5
            Datapixx('EnableDinDebounce');                          % Debounce button presses
            Datapixx('SetDinLog');                                  % Log button presses to default address
            Datapixx('StartDinLog');                                % Turn on logging
            Datapixx('RegWrRd');
            % Flush any past button presses
            Datapixx('SetDinLog');
            Datapixx('RegWrRd');
        end
        respgiven=0;
    end
      end
  % log button responses
        if responsebox==0
            if CharAvail
                ch = GetChar;
                if sum(strcmp(ch,rChar))
                    Keyct = Keyct+1;
                    params.RT(Keyct) = GetSecs;
                    disp(['Response ' num2str(Keyct) ' received']);
                end
                FlushEvents;
            end
        else
          %      [Bpress, RespTime, TheButtons] = DontWaitForEvent_Jerry3(TargList, Bpress, TheButtons, RespTime,timestamp, binaryvals,inter_buttonpress, bin_buttonpress, inter_timestamp);
      [Bpress, RespTime, TheButtons, ~, ~,PTBRespTime] = DontWaitForEvent_Jerry4(TargList, Bpress, TheButtons, RespTime,timestamp, binaryvals,inter_buttonpress, bin_buttonpress, inter_timestamp,PTBRespTime);
        end
        % Display 12 frames / TR
        if abs((elapsedTime / (TR / 12 )) - curFrame) > 0
            curFrame = ceil( elapsedTime / (TR / 12 ));
        end

        Screen( 'DrawTexture', winPtr, Texture(curFrame)); % current frame

        % Fixation Mask
        Screen('FillOval',winPtr,grey,[screenXpix/2-fix_mask/2, ...
            screenYpix/2-fix_mask/2,screenXpix/2+fix_mask/2,screenYpix/2+fix_mask/2]);
        if any(curFrame == params.FlickerTimes)
                  countergreen=countergreen+1;
          TargetTime(countergreen)=GetSecs;
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
    params.stimParams           = sparams;
    save(saveInfo.fileName,'params','-v7.3');
catch ME
    Screen('CloseAll');
    ListenChar(1);
    ShowCursor;
    rethrow(ME);
end