function TPxScotomaDemo(initRequired)
%
% This is a simple demonstration of a gaze-contingent display. A
% static image is shown and a binocular scotoma follows the participant's
% gaze. Participants can move the position of the scotoma with respect to
% gaze via the arrows on the keyboard. Size can be adjusted using 'q' and 'a' 
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


% Oct 16, 2019  lef     Written

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
Datapixx('RegWrRd');


%% Step 2 - Show our image and record eye position

AssertOpenGL;                                             
KbName('UnifyKeyNames');

%set our max viewing time
viewingTime = 600;

%set our scotoma refresh rate - 60 Hz for now
refreshRate = 1/60;

%open window
Screen('Preference', 'SkipSyncTests', 1 );
screenID = 2;                                              %change to switch display
[windowPtr, rect]=Screen('OpenWindow', screenID, [0,0,0]);
Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%load our image 
im = imread('Renoir_PontNeuf.jpg');
imTexture = Screen('MakeTexture', windowPtr, im); 

%set some initial scotoma characteristics
diameter = 100;
offsetX = 25;
offsetY = 10;

startTime = Datapixx('GetTime');
time2 = startTime;

while (time2 - startTime) < viewingTime
    
    Datapixx('RegWrRd');
    time1 = Datapixx('GetTime');
    time2 = time1 ;
    
    %Draw image 
    Screen('DrawTexture', windowPtr, imTexture, [], rect);   
    
    %Draw scotoma. For ease we'll say the scotoma follows the participant's
    %left eye. In the TRACKPix output, "RIGHT" and "LEFT" refer to the
    %right and left eyes shown in the console overlay. In tabletop and MEG
    %setups, this view is typically inverted. So in a tabletop or MEG
    %setup, 'ScreenRight' is the viewer's left eye.

    %If you are using an MRI setup with an inverting mirror, "RIGHT" will
    %correspond to the participant's right eye.
    [xScreenRight, yScreenRight, ~, ~, ~, ~, ~, ~, ~] = Datapixx('GetEyePosition');
    pos = Datapixx('ConvertCoordSysToCustom', [xScreenRight, yScreenRight]);
    Screen('FillOval', windowPtr, [128, 128, 128], [(pos(1)-offsetX)-diameter/2, (pos(2)-offsetY)-diameter/2, (pos(1)-offsetX)+diameter/2, (pos(2)-offsetY)+diameter/2]);
    
    %Some instructions at the top of the screen
    text_to_draw = 'Use the arrow keys to change the offset of the blind spot. Use Q and A keys to increase/decrease size. Press Escape to exit demo';
    Screen('DrawText', windowPtr, text_to_draw, 50, 10, [255, 255, 255], [0,0,0]);
    Screen('Flip', windowPtr);
    
    %Check for keys down
    [keyIsDown, ~, keyCode, ~] = KbCheck;
    if keyIsDown
        if keyCode(KbName('UpArrow'))
            offsetY = offsetY - 5;
        elseif keyCode(KbName('DownArrow'))
            offsetY = offsetY + 5;
        elseif keyCode(KbName('LeftArrow'))
            offsetX = offsetX - 5;
        elseif keyCode(KbName('RightArrow'))
            offsetX = offsetX + 5;
        elseif keyCode(KbName('a'))
            diameter = diameter + 10;
        elseif keyCode(KbName('q'))
            diameter = diameter - 10; 
            if diameter < 0
                diameter = 10;
            end
        elseif keyCode(KbName('escape'))
            break
        end
    end
            
    while (time2 - time1) < refreshRate
        Datapixx('RegWrRd');
        time2 = Datapixx('GetTime');
    end
end

%Close everything
Screen('Closeall');
Datapixx('SetTPxSleep');
Datapixx('RegWrRd');
Datapixx('Close');

end

    


