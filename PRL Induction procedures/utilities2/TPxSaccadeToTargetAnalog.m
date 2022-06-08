function TPxSaccadeToTargetAnalog(initRequired)
%
% This demo flashes a sequence of targets and tracks saccades to their
% position. It outputs eye position data as an analog signal. We read this
% back to the DATAPixx using the loopback feature and the ADC (analog to
% digital converter) schedule.

% TRIAL STRUCTURE:
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

% Most recently tested with:
% -- TRACKPixx3 firmware revision 18 
% -- DATAPixx3 firmware revision 19 
% -- MATLAB version 9.6.0.1150989 (R2019a) 
% -- Psychtoolbox verison 3.0.15 
% -- Datapixx Toolbox version 3.7.5735
% -- Windows 10 version 1903, 64bit

% Oct 07, 2019  lef     Written
% Mar 26  2020  lef     Revised and updated to reflect new analog outputs

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
Datapixx('RegWrRd');


%% Step 2 - Setting up analog output and recording

%For the purpose of this tutorial, we record a copy of the TRACKPixx analog
%output using the DATAPixx loopback feature. This feature allows the user
%to read the 4 DAC analog OUT channels (which are sending eye data) back in
%on the 16 ADC analog IN channels. We can record the ADC analog in using a
%schedule and save it to our trial data structure.
Datapixx('EnableDacAdcLoopback'); 

%We will record x, y positions for both eyes
Datapixx('EnableTPxAnalogOut' , 1,3,2,4)
%        1: Left eye screen X
%        2: Right eye screen X
% 	     3: Left eye screen Y
% 	     4: Right eye screen Y
% IMPORTANT: "RIGHT" and "LEFT" refer to the right and left eyes shown
% in the console overlay. In tabletop and MEG setups, this view is
% inverted. This means "RIGHT" in our labelling convention corresponds
% to the participant's left eye. Similarly "LEFT" in our convention
% refers to left on the screen, which corresponds to the participant's
% right eye.
% 
% If you are using an MRI setup with an inverting mirror, "RIGHT" will
% correspond to the participant's right eye.


%Next, we set up our analog input recording. We record using a schedule
%that stores analog data in a buffer on the DATAPixx. At the end of each
%trial we will copy this data over to our computer.

%The 4 DAC channel outputs are split across the 16 ADC input channels as follows:
%    -DAC0 drives ADC0/2/4/6/8/10/12/14
%    -DAC1 drives ADC1/3/5/7/9/11/13/15
%    -DAC2 drives REF0
%    -DAC3 drives REF1

%So we can record from ADC0 and ADC1 to get DAC0 (left eye X) and DAC1
%(left eye Y). To get DAC2 (right eye X), we record ADC2 in "differential"
%mode, where the input is subtracted from REF0. We can add the
%non-differential value of ADC0 to this data, to get the value of REF0. We
%do the same for and DAC3 (right eye Y) with ADC 3 and REF1. See the
%documentation of 'SetAdcSchedule' for more information about differential
%mode.
channelsToRecord = [0, 1, 2, 3];
modes = [0, 0, 2, 3];                           % 0 is no differential, 2 is with reference to REF0, 3 is with reference to REF1
channelData = [channelsToRecord; modes];

%set some other schedule settings
samplesPerSecond = 2000;                        %Tracker refresh rate is 2kHz
delay = 0;
maxScheduleFrames = 200000;                     % stop recording after 10 seconds. No trial should exceed this amount of time.

%set up our schedule
Datapixx('SetAdcSchedule', delay, samplesPerSecond, maxScheduleFrames, channelData);
Datapixx('DisableAdcFreeRunning');              % stops the schedule from continuously recording at its highest sampling rate; see documentation

%we will also record TRACKPixx output in a schedule so we can
%use it to check flags during a trial
Datapixx('SetupTPxSchedule');

%write all commands to the DATAPixx device register
Datapixx('RegWrRd');


%% Step 3 - Saccade to target task

AssertOpenGL;

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
    
    %start logging eye data from the TRACKPixx. We will use this to
    %determine when the target should be presented, and when the trial is
    %over.
    Datapixx('StartTPxSchedule');
    Datapixx('RegWrRd');
    
    %wait until subject is fixating on fixation cross
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
    
    %Start collecting analog data as soon as the target appears
    Datapixx('StartAdcSchedule');
    Datapixx('RegWrVideoSync');
    Screen('Flip', windowPtr);
   
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
                
                %Stop all recording
                Datapixx('StopAllSchedules');
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
    
    %read in analog eye data
    Datapixx('RegWrRd');
    status = Datapixx('GetAdcStatus');
    toRead = status.newBufferFrames;
    [adcData, adcTimetags] = Datapixx('ReadAdcBuffer', toRead);
    
    %save eye data from trial as a table in the trial structure
    trials(k).EyeData = array2table([adcTimetags', adcData'], 'VariableNames', {'TimeTag', 'LeftXRaw', 'LeftYRaw', 'RightXRawDiff', 'RightYRawDiff'});
    
    %reset the analog buffer
    Datapixx('SetAdcSchedule', delay, samplesPerSecond, maxScheduleFrames, channelData);
    
    %interim save
    save(fileID, 'trials');
end

%Finish presentation
Screen('Closeall');
Datapixx('StopAllSchedules');
Datapixx('DisableDacAdcLoopback'); 
Datapixx('DisableTPxAnalogOut');
Datapixx('SetTPxSleep');
Datapixx('RegWrRd');
finish_time = Datapixx('GetTime');
Datapixx('Close');

%% Step 4 - Process our data

fprintf('\nRecording lasted %f seconds', finish_time-start_time);
fprintf('\nProcessing... ');

%Data processing steps
% 1 - Calculate right eye x and y positions by isolating REF0 and REF1
% 2 - Convert x, y positions and diameter into degrees of visual angle
% 3 - Create a "proportionOfTrial" variable for plotting purposes

%1 - Caculate right X and right Y by isolating the value of REF0 and REF1 on each sample.
%We have saved output from 1) ADC0 and 2) REF0 - ADC2, so we can calculated REF0
%Similarly, we have 1) ADC3 and 2) REF1 - ADC3, so we can get REF1 
for k = 1:numel(trials)
    trials(k).EyeData = addvars(trials(k).EyeData, nan(height(trials(k).EyeData), 1), nan(height(trials(k).EyeData), 1), 'NewVariableNames', {'RightXRaw', 'RightYRaw'}, 'Before', 'RightXRawDiff');
    for s = 1:height(trials(k).EyeData)
        rightX =  trials(k).EyeData.LeftXRaw(s) + trials(k).EyeData.RightXRawDiff(s);
        trials(k).EyeData.RightXRaw(s) = rightX;
        
        rightY =  trials(k).EyeData.LeftYRaw(s) + trials(k).EyeData.RightYRawDiff(s);
        trials(k).EyeData.RightYRaw(s) = rightY;
    end
end

% 2 - Convert x, y positions into degrees of visual angle. 
% First, we convert the analog voltage into screen coordinates by
% multiplying the voltage by the number of pixels/volt. The ratio is 1V =
% 819.67 pixels for X coordinates, and 409.6 pixels for Y coordinates.

% Then we calculate the degrees of visual angle based on the pixel size (in
% cm) and the distance of the viewer to the display (in cm).
for k = 1:numel(trials)
    trials(k).EyeData = addvars(trials(k).EyeData, nan(height(trials(k).EyeData), 1),...
                                                   nan(height(trials(k).EyeData), 1),...
                                                   nan(height(trials(k).EyeData), 1),...
                                                   nan(height(trials(k).EyeData), 1),...
                                                   'NewVariableNames', {'LeftX', 'LeftY', 'RightX', 'RightY'});
    for s = 1:height(trials(k).EyeData)
        for m = 2:5
            voltage = trials(k).EyeData{s,m};
            %convert voltage to screen coordinates by multiplying by pixels/volt
            switch m
                case 2; screenCoordinates =  voltage * 819.67;   
                case 4; screenCoordinates =  voltage * 819.67;   
                case 3; screenCoordinates =  voltage * 409.575;   
                case 5; screenCoordinates =  voltage * 409.575;   
            end
            %convert screenCoordinates to degrees of visual angle
            degrees = 2 * atand((screenCoordinates*pixelSize)/(2*displayDistance));
            col = m+6;
            trials(k).EyeData{s,col} = degrees;
    
        end
    end
end


% 3 - For plotting purposes, create a column with proportion of trial time
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


%% Step 5 - Make some plots

% We create two figures, one for each target
% Each plots shows the X, Y and time as a 3-dimensional plot
numCols = 2;
numRows = 2;

for m = 1:numTargets
    figure();
    for k = 1:numel(trials)
        if trials(k).Target(1) == m
             
            subplot(numRows, numCols, trials(k).TargetLocation(1));
            plot3(trials(k).EyeData.ProportionTrial, trials(k).EyeData.LeftX, trials(k).EyeData.LeftY, 'm');
            hold on 
            plot3(trials(k).EyeData.ProportionTrial, trials(k).EyeData.RightX, trials(k).EyeData.RightY, 'c');
            
            zlim([-15,15]);
            zlabel('Y position (degrees)');
            ylim([-15, 15]);
            ylabel('X position (degrees)');
            set(gca,'Ydir','reverse')
            xlim([0,1]);
            xlabel('Proportion of trial');
            
            legend({'Left Eye', 'Right Eye'}, 'Location', 'southoutside' );

            titleText=['Trial ' int2str(k) 'Analog output for target ' int2str(trials(k).Target(1)) ' location ' int2str(trials(k).TargetLocation(1))];
            title(titleText);
            
        end
    end
end

%% Step 6 - Write data to csv for subsequent analysis

rawResults = table();
for k = 1:numel(trials)
    newTrial = trials(k).EyeData;
    newTrial.TrialNumber = repmat(trials(k).Trial, [height(newTrial), 1]);
    newTrial.Target = repmat(trials(k).Target(1), [height(newTrial), 1]);
    newTrial.TargetLocation = repmat(trials(k).TargetLocation(1), [height(newTrial), 1]);
    newTrial.TrialStart = repmat(trials(k).TrialStart, [height(newTrial), 1]);
    newTrial = newTrial(:, [5:end, 1:4]);
    rawResults = [rawResults; newTrial];
end

csvFileID = [fileName '_Results.csv'];
writetable(rawResults, csvFileID);


end

