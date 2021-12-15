function TPxSaccadeToTarget(initRequired)
%
% This demo flashes a sequence of 8 targets and tracks saccades to their
% position. 

% On a given trial, a fixation cross appears. When participants are
% fixating on the cross, a target appears in one of four locations (above,
% below, left, or right). Participants must saccade to the target as
% quickly as possible. When the saccade is complete, a 500ms mask is
% presented, and the next trial begins.

% Targets are circles with high or low luminance (high or low). Each luminance x
% position combination is repeated once, leading to 8 trials. After
% data is collected, data is plotted and output to a .csv file with headers
% for futher analysis 
%
% If initRequired is set to 1, the function first calls
% TPxTrackpixx3CalibrationTesting to connect to the TRACKPixx3 and
% calibrate the tracker. If you are calibrating your own setup, please
% check the calibration function to ensure your settings are correct.

% Made and tested with:
% -- TRACKPixx3 firmware revision 18 
% -- DATAPixx3 firmware revision 19 
% -- MATLAB version 9.6.0.1150989 (R2019a) 
% -- Psychtoolbox verison 3.0.15 
% -- Datapixx Toolbox version 3.7.5735
% -- Windows 10 version 1903, 64bit

% Sep 19, 2019  lef     Written
% Oct 17, 2019  lef     Revised
% Feb 24, 2020  lef     Revised, removes conversion NaN, now automated

%% Step 1 - Initialize (if needed)
if nargin==0
    initRequired=1;
end

% Get some user input
fileName= input('Enter participant name: ', 's');
fileID = [fileName '.mat'];

displayWidth = input('Enter width, in cm, of display monitor: ', 's');
displayWidth = str2double(displayWidth);

displayDistance = input('Enter distance, in cm, of participant to display monitor: ', 's');
displayDistance = str2double(displayDistance);

%If a calibration is needed, call the calibration script
if initRequired
    fprintf('\nInitialization required\n\nCalibrating the device...');
    TPxTrackpixx3CalibrationTesting;
end

%Connect to TRACKPixx3
Datapixx('Open');
Datapixx('SetTPxAwake');
Datapixx('SetupTPxSchedule');
Datapixx('RegWrRd');

%Set some flag settings. These values are the default settings but we
%specify them anyway.
fixationThreshold = 2500;               %pixels/s
framesForFixationFlag = 25;             %how many consecutive frames have to be below threshold for fixation flag to raise
saccadeThreshold = 10000;               %pixels/s
framesForSaccadeFlag = 10;              %how many consecutive frames have to be above threshold for saccade flag to raise

Datapixx('SetFixationThresholds' , fixationThreshold, framesForFixationFlag);
Datapixx('SetSaccadeThresholds' , saccadeThreshold, framesForSaccadeFlag);
Datapixx('RegWrRd');

%% Step 2 - Saccade to target task

%Set experiment parameters
maskPresentationTime = 0.5;
fixationPresentationTime = 0.5;
margin = 35;                                                % +/- margin of error, in pixels, within which the eyes can be considered in position

%open window
Screen('Preference', 'SkipSyncTests', 1 );
screenID = 2;                                              %change to switch display
[windowPtr, rect]=Screen('OpenWindow', screenID, [0,0,0]);
pixelSize = displayWidth/rect(4);
Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('Flip',windowPtr);

%describe targets and target locations
dotRadius = 20;
luminances = [1, 25,25,25;...                              %dark
              2, 250, 250, 250];                           %light
radius = 300;
center = rect(3:4)/2;
locations = [1, center(1), center(2)-radius;...            %top (in screen coordinates) 
             2, center(1)+radius, center(2);...            %right
             3, center(1), center(2)+radius;...            %bottom
             4, center(1)-radius, center(2)];              %left
         
%generate a stimuli list with target characteristics for each trial, and
%shuffle the order
numTargets = size(luminances(:,1),1);
numLocations = size(locations(:,1),1);
numReps = 1;
numTrials = numTargets*numLocations*numReps;
stimuli = [];

for s = 1:numTargets
    for k = 1:numLocations
        for m = 1:numReps
            stimuli = [stimuli; luminances(s,:), locations(k, :)]; 
        end
    end
end

stimuli=stimuli(randperm(size(stimuli,1)),:);           %shuffle

%create a structure to hold our trial data
trials = struct('Trial', [],...
                'Target', [],...
                'TargetLocation', [],...
                'TrialStart', [],...
                'TargetOnset', [],...
                'SaccadeOnset', [],...
                'SaccadeEnd', [],...
                'SaccadeReactionTime', [],...
                'SaccadeDuration', [],...
                'EyeData', []);


%show instructions to participant
Screen('DrawLine', windowPtr, [255,255,255], center(1) + 8, center(2), center(1)-8, center(2), 2);
Screen('DrawLine', windowPtr, [255,255,255], center(1), center(2)+8, center(1), center(2)-8, 2);
text_to_draw = ['SACCADE TO TARGET EXPERIMENT:\n\nStare at the cross in the middle of the screen.'...
                '\nAs soon as you see a dot appear, move your eyes to look at it as quickly as possible!\n\nPress any key to start.'];
DrawFormattedText(windowPtr, text_to_draw, 'center', 700, 255);
Screen('Flip', windowPtr);

%wait for participant to continue
[~, ~, ~] = KbPressWait;
Screen('Flip', windowPtr);
WaitSecs(1);

start_time = Datapixx('GetTime');

for k=1:numTrials
    
    trials(k).Trial = k;
    trials(k).Target = stimuli(k,1:4);
    trials(k).TargetLocation = stimuli(k,5:7);

    %draw fixation cross
    Screen('DrawLine', windowPtr, [255,255,255], center(1) + 8, center(2), center(1)-8, center(2), 2);
    Screen('DrawLine', windowPtr, [255,255,255], center(1), center(2)+8, center(1), center(2)-8, 2);
    Screen('Flip', windowPtr);
    trials(k).TrialStart = Datapixx('GetTime');
    WaitSecs(fixationPresentationTime); 
    
    %start logging eye data
    Datapixx('StartTPxSchedule');
    Datapixx('RegWrRd');
    
    %wait until subject is fixating on fixation cross
    while 1
        
        %get new eye data
        Datapixx('RegWrRd');
 
        %check for a fixation
        [lFlag, rFlag] = Datapixx('IsSubjectFixating');
        if lFlag && rFlag
            %if fixating, get eye position
            [xScreenRight, yScreenRight, xScreenLeft, yScreenLeft, ~, ~, ~, ~, ~] = Datapixx('GetEyePosition');
            
            %convert screen coordinates in VPixx coordinates (origin in middle of
            %screen) to Psychtoolbox Screen coordinates (origin in top left)
            fixationLocs = Datapixx('ConvertCoordSysToCustom', [xScreenRight, yScreenRight; xScreenLeft, yScreenLeft]);
            
            %confirm fixation is on cross in Psychtoolbox Screen coordinates 
            if inpolygon(fixationLocs(1,1), fixationLocs(1,2), [center(1)-margin, center(1)+margin] , [center(2)-margin, center(2)+margin])...
               && inpolygon(fixationLocs(2,1), fixationLocs(2,2), [center(1)-margin, center(1)+margin] , [center(2)-margin, center(2)+margin])                
                break;
            end
        end
    end
    
    %draw target
    colour = trials(k).Target(2:4);
    x = trials(k).TargetLocation(2);
    y = trials(k).TargetLocation(3);
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    %set a marker to get the exact time the screen flips
    Datapixx('SetMarker');
    Datapixx('RegWrVideoSync');
    Screen('Flip', windowPtr);
    
    %collect marker data
    Datapixx('RegWrRd');
    trials(k).TargetOnset = Datapixx('GetMarker');
    
    %Now that the target has been shown, start a while loop to repeatedly
    %check to see if participant is fixating on the target
    while 1
        
        %get new eye data
        Datapixx('RegWrRd');

        %check for a fixation
        [lFlag, rFlag] = Datapixx('IsSubjectFixating');
        if lFlag && rFlag
            [xScreenRight, yScreenRight, xScreenLeft, yScreenLeft, ~, ~, ~, ~, ~] = Datapixx('GetEyePosition');
            
            %convert screen coordinates in VPixx coordinates (origin in middle of
            %screen) to Psychtoolbox Screen coordinates (origin in top left)
            fixationLocs = Datapixx('ConvertCoordSysToCustom', [xScreenRight, yScreenRight; xScreenLeft, yScreenLeft]);
            
            %confirm fixation is on target in Psychtoolbox Screen coordinates 
            if inpolygon(fixationLocs(1,1), fixationLocs(1,2), [x-margin, x+margin] , [y-margin, y+margin])...
               && inpolygon(fixationLocs(2,1), fixationLocs(2,2),[x-margin, x+margin] , [y-margin, y+margin])
                
                %Stop recording
                Datapixx('StopTPxSchedule');
                Datapixx('RegWrRd');
                break;
            end
        end
    end
    
    %create and show visual mask - mask is a full-screen display of 5 pixel wide squares
    %with a random grayscale value.
    squaresize = 5; 
    numsquares=[rect(4)/squaresize, rect(3)/squaresize];
    pattern = rand([numsquares, 1])*128;                    
    mask = imresize(pattern, squaresize, 'nearest');
    textureIndex=Screen('MakeTexture', windowPtr, mask);
    Screen('DrawTexture', windowPtr, textureIndex); 
    Screen('Flip', windowPtr);
    WaitSecs(maskPresentationTime);
    
    %read in eye data
    Datapixx('RegWrRd');
    status = Datapixx('GetTPxStatus');
    toRead = status.newBufferFrames;
    [bufferData, ~, ~] = Datapixx('ReadTPxData', toRead);
    
    %bufferData is formatted as follows:
    %1      --- Timetag (in seconds)
    %2      --- Left Eye X (in pixels)
    %3      --- Left Eye Y (in pixels)
    %4      --- Left Pupil Diameter (in pixels)
    %5      --- Right Eye X (in pixels)
    %6      --- Right Eye Y (in pixels)
    %7      --- Right Pupil Diameter (in pixels)
    %8      --- Digital Input Values (24 bits)
    %9      --- Left Blink Detection (0=no, 1=yes)
    %10     --- Right Blink Detection (0=no, 1=yes) 
    %11     --- Digital Output Values (24 bits)
    %12     --- Left Eye Fixation Flag (0=no, 1=yes) 
    %13     --- Right Eye Fixation Flag (0=no, 1=yes)  
    %14     --- Left Eye Saccade Flag (0=no, 1=yes) 
    %15     --- Right Eye Saccade Flag (0=no, 1=yes)  
    %16     --- Message code (integer) 
    %17     --- Left Eye Raw X (in pixels) 
    %18     --- Left Eye Raw Y (in pixels)  
    %19     --- Right Eye Raw X (in pixels)  
    %20     --- Right Eye Raw Y (in pixels)
    
    %IMPORTANT: "RIGHT" and "LEFT" refer to the right and left eyes shown
    %in the console overlay. In tabletop and MEG setups, this view is
    %inverted. This means "RIGHT" in our labelling convention corresponds
    %to the participant's left eye. Similarly "LEFT" in our convention
    %refers to left on the screen, which corresponds to the participant's
    %right eye.

    %If you are using an MRI setup with an inverting mirror, "RIGHT" will
    %correspond to the participant's right eye.
    
    %save eye data from trial as a table in the trial structure
    trials(k).EyeData = array2table(bufferData, 'VariableNames', {'TimeTag', 'LeftEyeX', 'LeftEyeY', 'LeftPupilDiameter', 'RightEyeX', 'RightEyeY', 'RightPupilDiameter',...
                                    'DigitalIn', 'LeftBlink', 'RightBlink', 'DigitalOut', 'LeftEyeFixationFlag', 'RightEyeFixationFlag', 'LeftEyeSaccadeFlag', 'RightEyeSaccadeFlag',...
                                    'MessageCode', 'LeftEyeRawX', 'LeftEyeRawY', 'RightEyeRawX', 'RightEyeRawY'});
    %interim save
    save(fileID, 'trials');
end

%Finish presentation
Screen('Closeall');
Datapixx('StopTPxSchedule');
Datapixx('RegWrRd');
finish_time = Datapixx('GetTime');


%% Step 3 - Read and process data
fprintf('\nRecording lasted %f seconds', finish_time-start_time);
fprintf('\nProcessing... this will take a while...');

%Data processing steps
% 1  - Adjust eye movement flags. The flags require calculating velocity
% over several frames and are therefore offset in a deterministic way, and
% need to be shifted to align with true event onset
% 2 - Get some saccade details - onset, reaction time, duration, end
% 3 - Convert x, y positions into degrees of visual angle
% 4 - Calculate Velocity (and filter) in degrees of visual angle
% 5 - Calculate Acceleration (and filter) in degrees of visual angle
% 6 - Create a "proportionOfTrial" variable for plotting purposes


% 1 - Loop throught and create adjusted eye movement flags that are
% correctly aligned with movement onset/end. This has three discrete steps:

% a) Both types of eye movement flags are based on the 4 previous frames,
% and the 4 subsequent frames. As a result, velocity for frame j is not
% calculated until frame j+5. All flags must be moved back 5 frames to
% account for this.

% b) The arguments framesForFixationFlag and framesForSaccadeFlag specify
% how many consecutive frames a velocity has to be above/below threshold
% for an eye movement flag to raise. This reduces noise but creates an
% offset of the flag onset, corresponding to the number of frames
% specified. We correct for this by adding flags to this number of frames
% prior to flag onset.

% c) For a saccade flag to drop, the previous 2 frames must be
% below/above the threshold. We can remove these last 2 flags to get true
% movement end.
for k = 1:numel(trials) 
    trials(k).EyeData = addvars(trials(k).EyeData, nan(height(trials(k).EyeData), 1),...
                                            nan(height(trials(k).EyeData), 1),...
                                            nan(height(trials(k).EyeData), 1),...
                                            nan(height(trials(k).EyeData), 1),...
                                            'NewVariableNames', {'LeftEyeFixationAdjusted', 'RightEyeFixationAdjusted', 'LeftEyeSaccadeAdjusted', 'RightEyeSaccadeAdjusted'});
    
    % a) correct for velocity calculation offset                                    
    for s = 1: height(trials(k).EyeData)
        if height(trials(k).EyeData)-s >=5
            if trials(k).EyeData.LeftEyeFixationFlag(s+5) ==1
                trials(k).EyeData.LeftEyeFixationAdjusted(s)=trials(k).EyeData.LeftEyeFixationFlag(s+5);
            end
            if trials(k).EyeData.RightEyeFixationFlag(s+5) ==1
                trials(k).EyeData.RightEyeFixationAdjusted(s)=trials(k).EyeData.RightEyeFixationFlag(s+5);
            end
            if trials(k).EyeData.LeftEyeSaccadeFlag(s+5) ==1
                trials(k).EyeData.LeftEyeSaccadeAdjusted(s)=trials(k).EyeData.LeftEyeSaccadeFlag(s+5);
            end
            if trials(k).EyeData.RightEyeSaccadeFlag(s+5)
                trials(k).EyeData.RightEyeSaccadeAdjusted(s)=trials(k).EyeData.RightEyeSaccadeFlag(s+5);
            end
        end
    end
    
    %b) correct for flag onset offset
    for s = 1: height(trials(k).EyeData)
        if height(trials(k).EyeData)-s >= framesForFixationFlag
            %check for an onset a specficied number of frames ahead
            onset = s+framesForFixationFlag;
            if isnan(trials(k).EyeData.LeftEyeFixationAdjusted(onset-1)) && ~isnan(trials(k).EyeData.LeftEyeFixationAdjusted(onset))
                trials(k).EyeData.LeftEyeFixationAdjusted(s:onset)=1;
            end
            
            if isnan(trials(k).EyeData.RightEyeFixationAdjusted(onset-1)) && ~isnan(trials(k).EyeData.RightEyeFixationAdjusted(onset))
                trials(k).EyeData.RightEyeFixationAdjusted(s:onset)=1;
            end
        end
        
        if height(trials(k).EyeData)-s >= framesForSaccadeFlag
            %check for an onset a specficied number of frames ahead
            onset = s+framesForSaccadeFlag;
            if isnan(trials(k).EyeData.LeftEyeSaccadeAdjusted(onset-1)) && ~isnan(trials(k).EyeData.LeftEyeSaccadeAdjusted(onset))
                trials(k).EyeData.LeftEyeSaccadeAdjusted(s:onset)=1;
            end
            
            if isnan(trials(k).EyeData.RightEyeSaccadeAdjusted(onset-1)) && ~isnan(trials(k).EyeData.RightEyeSaccadeAdjusted(onset))
                trials(k).EyeData.RightEyeSaccadeAdjusted(s:onset)=1;
            end
        end
    end 
    
    % c) correct for flag end offset
    for s = 4: height(trials(k).EyeData)
        %check for a flag drop and clear last 2 flags
        if isnan(trials(k).EyeData.LeftEyeFixationAdjusted(s)) && ~isnan(trials(k).EyeData.LeftEyeFixationAdjusted(s-1))
            trials(k).EyeData.LeftEyeFixationAdjusted(s-2:s)=NaN;
        end
        
        if isnan(trials(k).EyeData.RightEyeFixationAdjusted(s)) && ~isnan(trials(k).EyeData.RightEyeFixationAdjusted(s-1))
            trials(k).EyeData.RightEyeFixationAdjusted(s-2:s)=NaN;
        end
        
        if isnan(trials(k).EyeData.LeftEyeSaccadeAdjusted(s)) && ~isnan(trials(k).EyeData.LeftEyeSaccadeAdjusted(s-1))
            trials(k).EyeData.LeftEyeSaccadeAdjusted(s-2:s)=NaN;
        end

        if isnan(trials(k).EyeData.RightEyeSaccadeAdjusted(s)) && ~isnan(trials(k).EyeData.RightEyeSaccadeAdjusted(s-1))
            trials(k).EyeData.RightEyeSaccadeAdjusted(s-2:s)=NaN;
        end
    end
end
    

% 2 - Get some saccade details - onset, reaction time, duration, end
for k = 1:numel(trials)
    saccadeStarted = NaN;
    saccadeEnded = NaN;
    
    for s = 1:height(trials(k).EyeData) 
       %If saccade flag is up for both eyes, log this as saccade start
       if isnan(saccadeStarted) && isnan(saccadeEnded) && ~isnan(trials(k).EyeData.LeftEyeSaccadeAdjusted(s)) && ~isnan(trials(k).EyeData.RightEyeSaccadeAdjusted(s))
           saccadeStarted = trials(k).EyeData.TimeTag(s);
       end

       %If saccade flag drops for both eyes, then saccade ended
       if ~isnan(saccadeStarted) && isnan(saccadeEnded) && isnan(trials(k).EyeData.LeftEyeSaccadeAdjusted(s)) && isnan(trials(k).EyeData.RightEyeSaccadeAdjusted(s))
           saccadeEnded = trials(k).EyeData.TimeTag(s);
       end
    end
    
    %get some saccade data 
    reactionTime = saccadeStarted - trials(k).TargetOnset;
    duration = saccadeEnded - saccadeStarted;
   
    trials(k).SaccadeOnset = saccadeStarted;
    trials(k).SaccadeEnd = saccadeEnded;
    trials(k).SaccadeReactionTime = reactionTime;
    trials(k).SaccadeDuration = duration;
end
       

% 3 - Convert x, y positions into degrees of visual angle
for k = 1:numel(trials)    
    trials(k).EyeData = addvars(trials(k).EyeData, nan(height(trials(k).EyeData), 1),...
                                        nan(height(trials(k).EyeData), 1),...
                                        nan(height(trials(k).EyeData), 1),...
                                        nan(height(trials(k).EyeData), 1),...
                                        'NewVariableNames', {'LeftEyeXDegrees', 'LeftEyeYDegrees', 'RightEyeXDegrees', 'RightEyeYDegrees'});

    for s = 1:height(trials(k).EyeData)
        xL = trials(k).EyeData.LeftEyeX(s) * pixelSize;
        trials(k).EyeData.LeftEyeXDegrees(s) = 2*atand(xL/(2*displayDistance));
        
        yL = trials(k).EyeData.LeftEyeY(s) * pixelSize;
        trials(k).EyeData.LeftEyeYDegrees(s) = 2*atand(yL/(2*displayDistance));

        xR = trials(k).EyeData.RightEyeX(s) * pixelSize;
        trials(k).EyeData.RightEyeXDegrees(s) = 2*atand(xR/(2*displayDistance));
        
        yR = trials(k).EyeData.RightEyeY(s) * pixelSize;
        trials(k).EyeData.RightEyeYDegrees(s) = 2*atand(yR/(2*displayDistance));
    end
end



% 4 - Calculate velocity
for k = 1:numel(trials)
    trials(k).EyeData = addvars(trials(k).EyeData, nan(height(trials(k).EyeData), 1),...
                                        nan(height(trials(k).EyeData), 1),...
                                        nan(height(trials(k).EyeData), 1),...
                                        nan(height(trials(k).EyeData), 1),...
                                        'NewVariableNames', {'LeftEyeVelocityRaw', 'RightEyeVelocityRaw', 'LeftEyeVelocity', 'RightEyeVelocity'});

    for s = 5:height(trials(k).EyeData)

        %Formula for velocity (as the tracker calulates it)
        %where i is the current frame 
        %deltaX = (sum(x(i+1):x(i+4)) - sum(x(i-4):x(i-1))) / 0.01;
        %deltaY = (sum(y(i+1):y(i+4)) - sum(y(i-4):y(i-1))) / 0.01;
        %velocity = sqrt(deltaX^2 + deltaY^2) 
        
        if height(trials(k).EyeData)-s >= 4
            
            leftX1 = sum(trials(k).EyeData.LeftEyeXDegrees(s-4:s-1));
            leftX2 = sum(trials(k).EyeData.LeftEyeXDegrees(s+1:s+4));
            
            leftY1 = sum(trials(k).EyeData.LeftEyeYDegrees(s-4:s-1));
            leftY2 = sum(trials(k).EyeData.LeftEyeYDegrees(s+1:s+4));
            
            trials(k).EyeData.LeftEyeVelocityRaw(s)= sqrt(((leftX2 - leftX1)/0.01)^2 + ((leftY2 - leftY1)/0.01)^2); 
            
            rightX1 = sum(trials(k).EyeData.RightEyeXDegrees(s-4:s-1));
            rightX2 = sum(trials(k).EyeData.RightEyeXDegrees(s+1:s+4));
            
            rightY1 = sum(trials(k).EyeData.RightEyeYDegrees(s-4:s-1));
            rightY2 = sum(trials(k).EyeData.RightEyeYDegrees(s+1:s+4));
            
            trials(k).EyeData.RightEyeVelocityRaw(s) = sqrt(((rightX2 - rightX1)/0.01)^2 + ((rightY2 - rightY1)/0.01)^2); 
        end

    end

    %Do some filtering on our data using a moving window average. Reverse
    %and forward filter to remove any phase-shift.
    windowSize = 25; 
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;

    leftEye = trials(k).EyeData.LeftEyeVelocityRaw(:);
    rightEye = trials(k).EyeData.RightEyeVelocityRaw(:);

    %reverse filter
    leftEye = filter(b, a, flip(leftEye));
    rightEye = filter(b, a, flip(rightEye));

    %forward filter
    leftEye = filter(b, a, flip(leftEye));
    rightEye = filter(b, a, flip(rightEye));

    %assign to table
    trials(k).EyeData.LeftEyeVelocity = leftEye;
    trials(k).EyeData.RightEyeVelocity = rightEye;

end


%5 - Derive acceleration from velocity data. Acceleration is the change in
%velocity across a frame, which has a fixed duration of 1/2000th of a
%second
for k = 1:numel(trials)
    trials(k).EyeData = addvars(trials(k).EyeData, nan(height(trials(k).EyeData), 1),...
                                        nan(height(trials(k).EyeData), 1),...
                                        nan(height(trials(k).EyeData), 1),...
                                        nan(height(trials(k).EyeData), 1),...
                                        'NewVariableNames', {'LeftEyeAccelerationRaw', 'RightEyeAccelerationRaw', 'LeftEyeAcceleration', 'RightEyeAcceleration'});

    for s = 2:height(trials(k).EyeData)
        trials(k).EyeData.LeftEyeAccelerationRaw(s) = (trials(k).EyeData.LeftEyeVelocityRaw(s) - trials(k).EyeData.LeftEyeVelocityRaw(s-1))/(1/2000);
        trials(k).EyeData.RightEyeAccelerationRaw(s) = (trials(k).EyeData.RightEyeVelocityRaw(s) - trials(k).EyeData.RightEyeVelocityRaw(s-1))/(1/2000);
    end

    %Do some filtering on our data using a moving window average. Reverse
    %and forward filter to remove any phase-shift.
    windowSize = 25; 
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;

    leftEye = trials(k).EyeData.LeftEyeAccelerationRaw(:);
    rightEye = trials(k).EyeData.RightEyeAccelerationRaw(:);

    %reverse filter
    leftEye = filter(b, a, flip(leftEye));
    rightEye = filter(b, a, flip(rightEye));

    %forward filter
    leftEye = filter(b, a, flip(leftEye));
    rightEye = filter(b, a, flip(rightEye));

    %assign to table
    trials(k).EyeData.LeftEyeAcceleration = leftEye;
    trials(k).EyeData.RightEyeAcceleration = rightEye;

end

% 6 Finally, for plotting purposes, create a column with proportion of trial time
for k = 1:numel(trials)
    trials(k).EyeData = addvars(trials(k).EyeData, nan(height(trials(k).EyeData), 1),...
                                        'NewVariableNames', 'ProportionTrial', 'After', 'TimeTag');

    trialStart = trials(k).EyeData.TimeTag(1);
    trialDuration = trials(k).EyeData.TimeTag(end)- trialStart;
    for s = 1:height(trials(k).EyeData)
        trials(k).EyeData.ProportionTrial(s) = (trials(k).EyeData.TimeTag(s)- trialStart)/trialDuration;
    end
end

save(fileID, 'trials');


%% Step 4 - Plot results

%Figure 1 - Saccade Reaction Time
%Figure 2 - Saccade Duration
%Figure 3 - X,Y screen position over time for target 1
%Figure 4 - X,Y screen position over time for target 2
%Figure 5 - Filtered velocity (degrees/second) for target 1
%Figure 6 - Filtered velocity (degrees/second) for target 2
%Figure 7 - Filtered acceleration (degrees/second^2) for target 1
%Figure 8 - Filtered acceleration (degrees/second^2) for target 2
%Figure 9 - Pupil dilation for target 1
%Figure 10 - Pupil dilation for target 2

lineColours = rand(numLocations, 3);

%Figure 1 - plot saccade reaction time
figure();
for k = 1:numTargets
    for s = 1:numLocations
        temp = [];
        for h= 1:numel(trials)
            if trials(h).Target(1) == k &&  trials(h).TargetLocation(1) == s
                temp = [temp; trials(h).SaccadeReactionTime];
            end
        end
        
    average = mean(temp);
    sterr = std(temp)/sqrt(numel(temp));
    subplot(1,2,k)
    hold on
    errorbar(s, average, sterr, 'Color', lineColours(s, :), 'MarkerFaceColor', lineColours(s, :), 'Marker', 'o');
    end
    
    xticks(1:numLocations);
    xticklabels({'Up', 'Right', 'Down', 'Left'});
    titleText=['Saccade Reaction times for target ' int2str(k)];
    title(titleText);
    ylabel('Reaction time (s)');
    xlabel('Saccade direction');
    xlim([0,numLocations+1]);
    ylim([0,1]);
end


%Figure 2 - plot saccade duration
figure();
for k = 1:numTargets
    for s = 1:numLocations
        temp = [];
        for h = 1:numel(trials)
            if trials(h).Target(1) == k &&  trials(h).TargetLocation(1) == s
                temp = [temp; trials(h).SaccadeDuration];
            end
        end
        
    average = mean(temp);
    sterr = std(temp)/sqrt(numel(temp));
    subplot(1,2,k)
    hold on
    errorbar(s, average, sterr, 'Color', lineColours(s, :), 'MarkerFaceColor', lineColours(s, :), 'Marker', 'o');
    end
    
    xticks(1:numLocations);
    xticklabels({'Up', 'Right', 'Down', 'Left'});
    titleText=['Saccade duration for target ' int2str(k)];
    title(titleText);
    ylabel('Duration (s)');
    xlabel('Saccade direction');
    xlim([0,numLocations+1]);
    ylim([0,0.05]);
end


%Figure 3 & 4 - Plot x and y position on each trial, by location, for each
%target type. If you have a lot of reps this graph will get very messy. Consider
%creating multiple figures to handle large datasets.
numRows = 2;
numCols = 2;

for m = 1:numTargets
    figure();
    for k = 1:numel(trials)
        if trials(k).Target(1) == m
            subplot(numRows, numCols,  trials(k).TargetLocation(1));
            plot3(trials(k).EyeData.ProportionTrial, trials(k).EyeData.LeftEyeXDegrees, trials(k).EyeData.LeftEyeYDegrees, 'b');
            hold on
            plot3(trials(k).EyeData.ProportionTrial, trials(k).EyeData.RightEyeXDegrees, trials(k).EyeData.RightEyeYDegrees, 'r');
            
            %plot target position at onset
            trialDuration = trials(k).EyeData.TimeTag(end)- trials(k).EyeData.TimeTag(1);
            targetx = (trials(k).TargetOnset- trials(k).EyeData.TimeTag(1))/trialDuration;
            targety = (trials(k).TargetLocation(2)-rect(3)/2) * pixelSize;
            targety =  2*atand(targety/(2*displayDistance));
            targetz = -(trials(k).TargetLocation(3)-rect(4)/2) * pixelSize;
            targetz =  2*atand(targetz/(2*displayDistance));
            plot3(targetx, targety, targetz, 'ok'); 
            
            zlabel('Y (degrees)');
            ylabel('X (degrees)');
            xlabel('Proportion of Trial');
            zlim([-15, 15]);
            ylim([-15, 15]);

            titleText=['Position of target ' int2str(trials(k).Target(1)) ' location ' int2str(trials(k).TargetLocation(1))];
            title(titleText);
            legend({'Left eye', 'Right eye', 'Target onset'});
        end
    end
end


%Figure 6 & 7- Velocity on each trial, by location, for each target type.
%If you have a lot of reps this graph will get very messy. Consider
%creating multiple figures to handle large datasets.
numCols = numLocations;
numRows = numReps;

for m = 1:numTargets
    figure();
    repCount= zeros(1,numLocations);
    for k = 1:numel(trials)
        if trials(k).Target(1) == m
            
            %get which iteration this is
            location = trials(k).TargetLocation(1);
            repCount(location)= repCount(location)+1;
            iteration = repCount(location);
            plotPosition = location+(numLocations*(iteration-1));
            
            subplot(numRows, numCols, plotPosition);
            plot(trials(k).EyeData.ProportionTrial, trials(k).EyeData.LeftEyeVelocity, 'b');
            hold on     
            plot(trials(k).EyeData.ProportionTrial, trials(k).EyeData.RightEyeVelocity, 'r');

            %Put some markers to delineate saccade when the participant was
            %saccading or fixating. Lift them up over data.
            statusL = 470; 
            statusR = 490;

            plot(trials(k).EyeData.ProportionTrial, (trials(k).EyeData.LeftEyeFixationAdjusted*statusL), ':b');
            plot(trials(k).EyeData.ProportionTrial, (trials(k).EyeData.RightEyeFixationAdjusted*statusR), ':r');
            plot(trials(k).EyeData.ProportionTrial, (trials(k).EyeData.LeftEyeSaccadeAdjusted*statusL), 'b', 'LineWidth', 5);
            plot(trials(k).EyeData.ProportionTrial, (trials(k).EyeData.RightEyeSaccadeAdjusted*statusR), 'r',  'LineWidth', 5);
            
            %plot target onset as a vertical line
            trialDuration = trials(k).EyeData.TimeTag(end)- trials(k).EyeData.TimeTag(1);
            targetx = (trials(k).TargetOnset- trials(k).EyeData.TimeTag(1))/trialDuration;
            line([targetx, targetx], [0, 500]); 

            %add peak velocity values to plot
            [mL,iL]=max(trials(k).EyeData.LeftEyeVelocity);
            xL = trials(k).EyeData.ProportionTrial(iL);
            plot(xL, mL, 'ob');
            txtL = ['Peak left eye: ' num2str(mL) ' degrees/s'];
            text(0.1, 100, {txtL}, 'FontSize', 8, 'Color', 'b');
            
            [mR,iR]=max(trials(k).EyeData.RightEyeVelocity);
            xR = trials(k).EyeData.ProportionTrial(iR);
            plot(xR, mR, 'or');
            txtR = ['Peak right eye: ' num2str(mR) ' degrees/s'];
            text(0.1, 80, {txtR}, 'FontSize', 8, 'Color', 'r');
            
            ylabel('Velocity (degrees/s)');
            xlabel('Proportion Trial');
            xlim([0,1]);
            ylim([0, 500]);
            if iteration == 1
                legend({'Left eye velocity', 'Right eye velocity', 'Left eye fixation', 'Right eye fixation', 'Left eye saccade', 'Right eye saccade', 'Target onset'}, 'Location', 'southoutside' );
            end

            titleText=['Trial velocity for target ' int2str(trials(k).Target(1)) ' location ' int2str(trials(k).TargetLocation(1))];
            title(titleText);
            
            txt = {'**Data forward and reverse filtered with';'a 10-frame moving window average**'};
            text(.1, 50,txt, 'FontSize', 8, 'Color', [.5, .5, .5])
        end
    end
end


%Figure 7 & 8- Acceleration on each trial, by location, for each target
numCols = numLocations;
numRows = numReps;

for m = 1:numTargets
    figure();
    repCount= zeros(1,numLocations);
    for k = 1:numel(trials)
        if trials(k).Target(1) == m
            
            %get which iteration this is
            location = trials(k).TargetLocation(1);
            repCount(location)= repCount(location)+1;
            iteration = repCount(location);
            plotPosition = location+(numLocations*(iteration-1));
            
            subplot(numRows, numCols, plotPosition);
            plot(trials(k).EyeData.ProportionTrial, trials(k).EyeData.LeftEyeAcceleration, 'b');   
            hold on     
            plot(trials(k).EyeData.ProportionTrial, trials(k).EyeData.RightEyeAcceleration, 'r');
         
            %Put some markers to delineate saccade when the participant was
            %saccading or fixating. Lift them up over data.
            statusL = 32000; 
            statusR = 30000;

            plot(trials(k).EyeData.ProportionTrial, (trials(k).EyeData.LeftEyeFixationAdjusted*statusL), ':b');
            plot(trials(k).EyeData.ProportionTrial, (trials(k).EyeData.RightEyeFixationAdjusted*statusR), ':r');

            plot(trials(k).EyeData.ProportionTrial, (trials(k).EyeData.LeftEyeSaccadeAdjusted*statusL), 'b', 'LineWidth', 5);
            plot(trials(k).EyeData.ProportionTrial, (trials(k).EyeData.RightEyeSaccadeAdjusted*statusR), 'r',  'LineWidth', 5);
            
            %plot target onset as a vertical line
            trialDuration = trials(k).EyeData.TimeTag(end)- trials(k).EyeData.TimeTag(1);
            targetx = (trials(k).TargetOnset- trials(k).EyeData.TimeTag(1))/trialDuration;
            line([targetx, targetx], [-35000,35000]); 

            ylabel('Acceleration (degrees/s^2)');
            xlabel('Proportion Trial');
            xlim([0,1]);
            ylim([-35000,35000]);
            if iteration ==1
                legend({'Left eye acceleration', 'Right eye acceleration', 'Left eye fixation', 'Right eye fixation', 'Left eye saccade', 'Right eye saccade', 'Target onset'}, 'Location', 'southoutside' );
            end
            titleText=['Trial Acceleration for target ' int2str(trials(k).Target(1)) ' location ' int2str(trials(k).TargetLocation(1))];
            title(titleText);
            
            txt = {'**Data forward and reverse filtered with';'a 10-frame moving window average**'};
            text(.1,-20000,txt, 'FontSize', 8, 'Color', [.5, .5, .5])
        end
    end
end



%Figure 9 & 10 - Dilation on each trial, by location, for each target type
numCols = numLocations;
numRows = numReps;

for m = 1:numTargets
    figure();
    repCount= zeros(1,numLocations);
    for k = 1:numel(trials)
        if trials(k).Target(1) == m
            
            %get which iteration this is
            location = trials(k).TargetLocation(1);
            repCount(location)= repCount(location)+1;
            iteration = repCount(location);
            plotPosition = location+(numLocations*(iteration-1));
            
            subplot(numRows, numCols, plotPosition);
            plot(trials(k).EyeData.ProportionTrial, trials(k).EyeData.LeftPupilDiameter, 'b');
            hold on     
            plot(trials(k).EyeData.ProportionTrial, trials(k).EyeData.RightPupilDiameter, 'r');
            
            %Put some markers to delineate saccade when the participant was
            %saccading or fixating. Lift them up over data.
            statusL = 70; 
            statusR = 75;

            plot(trials(k).EyeData.ProportionTrial, (trials(k).EyeData.LeftEyeFixationAdjusted*statusL), ':b');
            plot(trials(k).EyeData.ProportionTrial, (trials(k).EyeData.RightEyeFixationAdjusted*statusR), ':r');

            plot(trials(k).EyeData.ProportionTrial, (trials(k).EyeData.LeftEyeSaccadeAdjusted*statusL), 'b', 'LineWidth', 5);
            plot(trials(k).EyeData.ProportionTrial, (trials(k).EyeData.RightEyeSaccadeAdjusted*statusR), 'r',  'LineWidth', 5);

            ylabel('Dilation (pixels)');
            xlabel('Proportion Trial');
            xlim([0,1]);
            ylim([0,80]);
            if iteration ==1
                legend({'Left pupil diameter', 'Right pupil diameter', 'Left eye fixation', 'Right eye fixation', 'Left eye saccade', 'Right eye saccade'}, 'Location', 'southoutside' );
            end
            titleText=['Pupil dilation for target ' int2str(trials(k).Target(1)) ' location ' int2str(trials(k).TargetLocation(1))];
            title(titleText);
        end
    end
end




%% Step 5 - Write data to csv

rawResults = table();
for k = 1:numel(trials)
    newTrial = trials(k).EyeData;
    newTrial.TrialNumber = repmat(trials(k).Trial, [height(newTrial), 1]);
    newTrial.Target = repmat(trials(k).Target(1), [height(newTrial), 1]);
    newTrial.TargetLocation = repmat(trials(k).TargetLocation(1), [height(newTrial), 1]);
    newTrial.TrialStart = repmat(trials(k).TrialStart, [height(newTrial), 1]);
    newTrial.TargetOnset = repmat(trials(k).TargetOnset, [height(newTrial), 1]);
    newTrial.SaccadeOnset = repmat(trials(k).SaccadeOnset, [height(newTrial), 1]);
    newTrial.SaccadeEnd = repmat(trials(k).SaccadeEnd, [height(newTrial), 1]);
    newTrial.SaccadeReactionTime = repmat(trials(k).SaccadeReactionTime, [height(newTrial), 1]);
    newTrial.SaccadeDuration = repmat(trials(k).SaccadeDuration, [height(newTrial), 1]);
    newTrial = newTrial(:, [40:end, 1:37]);
    rawResults = [rawResults; newTrial];
end

csvFileID = [fileName '_Results.csv'];
writetable(rawResults, csvFileID);

%% Step 6 - Finish up

Datapixx('SetTPxSleep');
Datapixx('RegWrRd');
Datapixx('Close');

end

