function TPxFixation(initRequired)
%
% This demo draws a target. Participants must fixate for 5 s. Eye position
% data is recorded, saved in .mat and .csv formats, and plotted.
%
% If initRequired is set to 1, the function first calls
% TPxTrackpixx3CalibrationTesting to connect to the TRACKPixx3 and
% calibrate the tracker. If you are calibrating your own setup, please
% check the calibration function to ensure your settings are correct.

% Made and tested with:
% -- TRACKPixx3 firmware revision 16 
% -- DATAPixx3 firmware revision 14
% -- MATLAB version 9.6.0.1150989 (R2019a) 
% -- Psychtoolbox verison 3.0.15 
% -- Datapixx Toolbox version 3.7.5735
% -- Windows 10 version 1903, 64bit

% Mar 19, 2020  lef     Written

%% Step 1 - Initialize (if needed)
if nargin==0
    initRequired=1;
end

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


%% Step 2 - Show target and record data

%open window
Screen('Preference', 'SkipSyncTests', 1 );
screenID = 2;                                              %change to switch display
[windowPtr, rect]=Screen('OpenWindow', screenID, [0,0,0]);
Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('Flip',windowPtr);
         
%show instructions to participant
text_to_draw = ['Stare at the dot in the middle of the screen.'...
                '\n\nPress any key to start.'];
DrawFormattedText(windowPtr, text_to_draw, 'center', 700, 255);
Screen('Flip', windowPtr);

%wait for participant to continue
[~, ~, ~] = KbPressWait;
Screen('Flip', windowPtr);
WaitSecs(1);

%draw our target
Screen('FillOval', windowPtr, [255,255,255], [rect(3)/2-10, rect(4)/2-10, rect(3)/2+10, rect(4)/2+10]);
Screen('Flip', windowPtr);
WaitSecs(1); %give participant time to react

%start logging eye data  
Datapixx('StartTPxSchedule');
Datapixx('RegWrRd');

%wait
WaitSecs(5);

%stop as soon as target disappears
Datapixx('StopTPxSchedule');
Datapixx('RegWrRdVideoSync');
Screen('Flip', windowPtr);



%% Step 3 - read in eye data
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
TPxData = array2table(bufferData, 'VariableNames', {'TimeTag', 'LeftEyeX', 'LeftEyeY', 'LeftPupilDiameter', 'RightEyeX', 'RightEyeY', 'RightPupilDiameter',...
                                'DigitalIn', 'LeftBlink', 'RightBlink', 'DigitalOut', 'LeftEyeFixationFlag', 'RightEyeFixationFlag', 'LeftEyeSaccadeFlag', 'RightEyeSaccadeFlag',...
                                'MessageCode', 'LeftEyeRawX', 'LeftEyeRawY', 'RightEyeRawX', 'RightEyeRawY'});
%interim save
save('TPxData');
writetable(TPxData, 'TPxData.csv');

%close
Datapixx('SetTPxSleep');
Datapixx('RegWrRd');
Datapixx('Close');
Screen('Closeall');
    
%% Step 4 - Plot

figure();
plot(TPxData.LeftEyeX(:), TPxData.LeftEyeY(:), '.b');
hold on
plot(TPxData.RightEyeX(:), TPxData.RightEyeY(:), '.r');

%plot target space
th = 0:pi/50:2*pi;
x = 10 * cos(th);
y = 10 * sin(th);
plot(x, y, '--k');

xlim([-100, 100]);
ylim([-100, 100]);
legend('Left Eye', 'Right Eye');
xlabel('X (pixels)');
ylabel('Y (pixels)');

title('Fixation data for a single target viewed for 5s');


end

