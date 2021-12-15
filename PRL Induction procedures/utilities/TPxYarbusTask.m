function TPxYarbusTask(initRequired)
%
% This demo recreates the viewing task used by Yarbus, which demonstrated
% that the pattern of free-viewing of an image changes as a function of the
% task required of the viewer. 
%
% We present the same image three times, for 8 seconds each. Each time we
% pose a different question to the participant (question order is
% randomized). Gaze scan paths for the three trials are then plotted side
% by side for comparison.
%
% If initRequired is set to 1, the function first calls
% TPxTrackpixx3CalibrationTesting to connect to the TRACKPixx3 and
% calibrate the tracker.

% Most recently tested with:
% -- TRACKPixx3 firmware revision 18 
% -- DATAPixx3 firmware revision 19 
% -- MATLAB version 9.6.0.1150989 (R2019a) 
% -- Psychtoolbox verison 3.0.15 
% -- Datapixx Toolbox version 3.7.5735
% -- Windows 10 version 1903, 64bit

%References:
% DeAngelus, M., & Pelz, J. B. (2009). Top-down control of eye movements: Yarbus revisited. Visual Cognition, 17(6-7), 790-811.
% Yarbus, A. L. (1967). Eye movements during perception of complex objects. In Eye movements and vision (pp. 171-211). Springer, Boston, MA.

% Oct 15, 2019  lef     Written
% Mar 26  2020  lef     Updated


%% Step 1 - Initialize (if needed)

if nargin==0
    initRequired=1;
end

% Get some user input
fileName= input('Enter participant name: ', 's');
fileID = [fileName '.mat'];

%If a calibration is needed, call the calibration script
if initRequired
    fprintf('\nInitialization required\n\nCalibrating the device...');
    TPxTrackpixx3CalibrationTesting;
end

%Connect to TRACKPixx3
Datapixx('Open');
Datapixx('SetTPxAwake');
Datapixx('RegWrRd');


%% Step 2 - Set up the TRACKPixx recording schedule

Datapixx('SetupTPxSchedule');
%write all commands to the DATAPixx device register
Datapixx('RegWrRd');


%% Step 3 - Show our image and record eye position
AssertOpenGL;                                             

%set our ideal viewing time in seconds
viewingTime = 8;

%create a structure to store our data. This format allows us to easily add
%more trials and images if we want. For now we stick to 3
data = struct('Trial', [],...
              'Question', {'In the image, what time of day is it?',...
              'In the image, what is the average age of the group?',...
              'In the image, what is the overall mood of the event?'},...
              'Image', {'Renoir_Boating.jpg','Renoir_Boating.jpg', 'Renoir_Boating.jpg'},...
              'ViewingTime', [],...
              'EyeData', []);
          
%shuffle order of presentation
order = randperm(numel(data));

%open window
Screen('Preference', 'SkipSyncTests', 1 );
screenID = 2;                                              %change to switch display
[windowPtr, rect]=Screen('OpenWindow', screenID, [0,0,0]);
Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('Flip',windowPtr);

%show instructions to participant
text_to_draw = ['FREE VIEWING DEMO:\n\nYou will be asked a question about a painting. \nYou will have 8 seconds to view the painting and decide your answer.\n\nPress any key to start.'];
DrawFormattedText(windowPtr, text_to_draw, 'center', 700, 255);
Screen('Flip', windowPtr);

%wait for participant to continue
[~, ~, ~] = KbPressWait;
Screen('Flip', windowPtr);
WaitSecs(1);

start_time = Datapixx('GetTime');

for k = 1:numel(data)
    index = order(k);
    data(k).Trial = index;
    currentQuestion = data(index).Question;
    im = imread(data(index).Image);
    imTexture = Screen('MakeTexture', windowPtr, im); 
    
    text_to_draw = [currentQuestion '\n\nPress any key to start.'];
    DrawFormattedText(windowPtr, text_to_draw, 'center', 700, 255);
    Screen('Flip', windowPtr);
    
    %wait for a keypress
    [~, ~, ~] = KbPressWait;
    
    %set up recording to start on the same frame flip that shows the image.
    %We also get the time of the flip using a Marker which indcates the
    %frame flip on the DATAPixx clock
    Datapixx('StartTPxSchedule');
    Datapixx('SetMarker');
    Datapixx('RegWrRdVideoSync');
    
    %draw our image and flip
    Screen('DrawTexture', windowPtr, imTexture, [], rect);
    Screen('Flip', windowPtr);
    
    time1 = Datapixx('GetMarker');
    time2 = time1;
    
    %repeatedly check the device for current time, and break loop when our
    %8 seconds are done.
    while (time2 - time1) < viewingTime
        Datapixx('RegWrRd');
        time2 = Datapixx('GetTime');
    end
    
    %stop recording
    Datapixx('StopTPxSchedule');
    Datapixx('RegWrRd');
    
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
    data(index).EyeData = array2table(bufferData, 'VariableNames', {'TimeTag', 'LeftEyeX', 'LeftEyeY', 'LeftPupilDiameter', 'RightEyeX', 'RightEyeY', 'RightPupilDiameter',...
                                    'DigitalIn', 'LeftBlink', 'RightBlink', 'DigitalOut', 'LeftEyeFixationFlag', 'RightEyeFixationFlag', 'LeftEyeSaccadeFlag', 'RightEyeSaccadeFlag',...
                                    'MessageCode', 'LeftEyeRawX', 'LeftEyeRawY', 'RightEyeRawX', 'RightEyeRawY'});

    %get some other trial data
    data(index).ViewingTime = time2 - time1;
    
    %interim save
    save(fileID, 'data');    
end

%Close everything
finish_time = Datapixx('GetTime');
Screen('Closeall');
Datapixx('SetTPxSleep');
Datapixx('RegWrRd');
Datapixx('Close');


%% Step 4 - Plot some gaze paths

figure();
numCols = 3;
numRows = ceil(numel(data)/numCols); 

for k = 1:numel(data)
    
    subplot(numRows, numCols, k);
    x = data(k).EyeData.LeftEyeX;
    y = data(k).EyeData.LeftEyeY;
    plot(x,y, 'ob', 'linewidth', 1, 'markersize', 1); 
    hold on
    x = data(k).EyeData.RightEyeX;
    y = data(k).EyeData.RightEyeY;
    plot(x,y, 'or', 'linewidth', 1, 'markersize', 1); 
    
    xlim([-rect(3)/2, rect(3)/2]);
    ylim([-rect(4)/2, rect(4)/2]);
    
    im = imread(data(k).Image); 
    h = image(xlim, -ylim,im);
    set(h,'alphadata', .5);
    
    title(data(k).Question);
    legend({'Left eye', 'Right Eye'});
    xlabel('X position (pixels)');
    ylabel('Y position (pixels)');
    
end


%% Step 5 - Write data to csv for subsequent analysis

rawResults = table();
for k = 1:numel(data)
    newTrial = data(k).EyeData;
    newTrial.TrialNumber = repmat(data(k).Trial, [height(newTrial), 1]);
    newTrial.Question = repmat({data(k).Question}, [height(newTrial), 1]);
    newTrial.ViewingTime = repmat(data(k).ViewingTime, [height(newTrial), 1]);
    newTrial = newTrial(:, [21:end, 1:20]);
    rawResults = [rawResults; newTrial];
end

savefig(fileName);
csvFileID = [fileName '_Results.csv'];
writetable(rawResults, csvFileID);


end

    


