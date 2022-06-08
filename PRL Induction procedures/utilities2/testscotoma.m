%try TPxScotomaDemo(initRequired)
%
% This is a simple demonstration of a gaze-contingent display. A
% static image is shown and a binocular scotoma follows the participant's
% gaze. Participants can move  the position of the scotoma with respect to
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
eyeOrtrack=1;
initRequired=0;
counter=0;
eyetime2=0;
VBL_Timestamp=0;
screencm=[110 30];
v_d=57;
    scotoma_color=[200 200 200];

 xeye=[];
        yeye=[];
         scotomadeg=10;
    %If a calibration is needed, call the calibration script
if initRequired>0
    fprintf('\nInitialization required\n\nCalibrating the device...');
TPxTrackpixx3CalibrationTestingskip;
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
refreshRate = 1/120;

%open window
Screen('Preference', 'SkipSyncTests', 1 );
screenID = 2;                                              %change to switch display
[w, wRect]=Screen('OpenWindow', screenID, [0,0,0]);
Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
struct.sz=[screencm(1), screencm(2)];
    pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi)); %pixperdegree
    pix_deg_vert = pi * wRect(4) / atan(screencm(2)/v_d/2) / 360; %to calculate the limit of target position
scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg_vert];
scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];

    scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);

%load our image 
im = imread('Renoir_PontNeuf.jpg');
imTexture = Screen('MakeTexture', w, im); 

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
    Screen('DrawTexture', w, imTexture, [], wRect);   
    
    %Draw scotoma. For ease we'll say the scotoma follows the participant's
    %left eye. In the TRACKPix output, "RIGHT" and "LEFT" refer to the
    %right and left eyes shown in the console overlay. In tabletop and MEG
    %setups, this view is typically inverted. So in a tabletop or MEG
    %setup, 'ScreenRight' is the viewer's left eye.

    %If you are using an MRI setup with an inverting mirror, "RIGHT" will
    %correspond to the participant's right eye.
    [xScreenRight, yScreenRight, ~, ~, ~, ~, ~, ~, ~] = Datapixx('GetEyePosition');
    pos = Datapixx('ConvertCoordSysToCustom', [xScreenRight, yScreenRight]);
   % Screen('FillOval', w, [128, 128, 128], [(pos(1)-offsetX)-diameter/2, (pos(2)-offsetY)-diameter/2, (pos(1)-offsetX)+diameter/2, (pos(2)-offsetY)+diameter/2]);
        eyefixation3pixx
                Screen('FillOval', w, scotoma_color, scotoma);

    %Some instructions at the top of the screen
    text_to_draw = 'Use the arrow keys to change the offset of the blind spot. Use Q and A keys to increase/decrease size. Press Escape to exit demo';
    Screen('DrawText', w, text_to_draw, 50, 10, [255, 255, 255], [0,0,0]);
            
    [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip', w);
    VBL_Timestamp=[VBL_Timestamp eyetime2];
    
    counter=length(VBL_Timestamp);
        xxxeye(counter)=xScreenRight;
        yyyeye(counter)=yScreenRight;
        realxeye(counter)=pos(1);
        realyeye(counter)=pos(2);
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

%end

    


