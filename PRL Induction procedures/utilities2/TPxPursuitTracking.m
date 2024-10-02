function TPxPursuitTracking(initRequired)
%
% This demo draws a moving dot for 5 seconds, and tracks the smooth
% pursuit movement of the viewer. Data is plotted and saved.

% Most recently tested with:
% -- TRACKPixx3 firmware revision 18 
% -- DATAPixx3 firmware revision 19 
% -- MATLAB version 9.6.0.1150989 (R2019a) 
% -- Psychtoolbox verison 3.0.15 
% -- Datapixx Toolbox version 3.7.5735
% -- Windows 10 version 1903, 64bit

% Oct 22, 2019  lef     Written
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

%set our recording time
viewingTime = 5;
          
%open window
Screen('Preference', 'SkipSyncTests', 1 );
screenID = 2;                                              %change to switch display
[windowPtr, rect]=Screen('OpenWindow', screenID, [0,0,0]);
Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('Flip',windowPtr);

%determine a trajectory
radius = 300; %in pixels for now
targetSize = 20;
trajectory = 0 : 0.01 : 2*pi;

%show instructions to participant
text_to_draw = ['PURSUIT DEMO:\n\nFollow the target with your eyes.\n\nPress any key to start.'];
DrawFormattedText(windowPtr, text_to_draw, 'center', 700, 255);
Screen('Flip', windowPtr);

%wait for participant to continue
[~, ~, ~] = KbPressWait;
Screen('Flip', windowPtr);
WaitSecs(1);

% %set up recording to start on the same frame flip that shows the image.
% %We also get the time of the flip using a Marker which saves a time of the
% %frame flip on the DATAPixx clock
Datapixx('StartTPxSchedule');
Datapixx('SetMarker');
Datapixx('RegWrVideoSync');
    
startTime = NaN;
currentTime = NaN;
positionCounter = 0;

while ~((currentTime - startTime) >= viewingTime)

    positionCounter = positionCounter + 1;
    
    %if we get to the end of our trajectory, restart
    if positionCounter > numel(trajectory)
        positionCounter = 1;
    end
    
    %draw our image and flip
    centerX = rect(3)/2 + radius*(cos(trajectory(positionCounter)));
    centerY = rect(4)/2 + radius*(sin(trajectory(positionCounter)));
    
    Screen('FillOval', windowPtr, [255,50,50], [centerX-targetSize/2, centerY-targetSize/2, centerX+targetSize/2, centerY+targetSize/2 ]);
    Screen('Flip', windowPtr);
    
    Datapixx('RegWrRd');
    startTime = Datapixx('GetMarker');
    currentTime  = Datapixx('GetTime');
    
end
    
%stop recording
Datapixx('StopTPxSchedule');
Datapixx('RegWrRd');
endTime = Datapixx('GetTime');

%read in eye data
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
eyeData = array2table(bufferData, 'VariableNames', {'TimeTag', 'LeftEyeX', 'LeftEyeY', 'LeftPupilDiameter', 'RightEyeX', 'RightEyeY', 'RightPupilDiameter',...
                                'DigitalIn', 'LeftBlink', 'RightBlink', 'DigitalOut', 'LeftEyeFixationFlag', 'RightEyeFixationFlag', 'LeftEyeSaccadeFlag', 'RightEyeSaccadeFlag',...
                                'MessageCode', 'LeftEyeRawX', 'LeftEyeRawY', 'RightEyeRawX', 'RightEyeRawY'});
                            

%get some other trial data
pursuitTime = endTime - startTime;

%interim save
save(fileID, 'eyeData', 'pursuitTime');    

%Close everything
Screen('Closeall');
Datapixx('SetTPxSleep');
Datapixx('RegWrRd');
Datapixx('Close');


%% Step 4 - Plot some gaze paths

fprintf('\nRecording lasted %f seconds', pursuitTime);
figure();

plot(radius*(cos(trajectory)), radius*(sin(trajectory)), 'Color', [0.5, 0.5, 0.5], 'LineWidth', targetSize/2);
hold on

x = eyeData.LeftEyeX(:,:);
y = eyeData.LeftEyeY(:,:);
plot(x,y, 'ob', 'linewidth', 1, 'markersize', 1); 

x = eyeData.RightEyeX(:,:);
y = eyeData.RightEyeY(:,:);
plot(x,y, 'or', 'linewidth', 1, 'markersize', 1); 

xlim([-rect(3)/2, rect(3)/2]);
ylim([-rect(4)/2, rect(4)/2]);

legend({'Target path','Left eye', 'Right Eye'});
xlabel('X position (pixels)');
ylabel('Y position (pixels)');
title('Gaze path for 5s smooth pursuit');



%% Step 5 - Write data to csv for subsequent analysis

savefig(fileName);
csvFileID = [fileName '_Results.csv'];
writetable(eyeData, csvFileID);


end

    


