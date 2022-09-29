function TRACKPixxSimpleDemo()
%
% A demo which plots raw coordinates for the TRACKPixx


% May 31, 2017  dml     Writte

%% Step 0 -- Open the screen
Datapixx('Open');
Datapixx('SetLedIntensity', 8); % SET TO MAX INTENSITY FOR MRI
Datapixx('SetExpectedIrisSizeInPixels', 150); % 150 for MRI
Datapixx('RegWrRd');

image = Datapixx('GetEyeImage'); % Initial eye image
scrnNum = max(Screen('Screens'));
[windowPtr, windowRect]=PsychImaging('OpenWindow', scrnNum, 0); % Open Window
KbName('UnifyKeyNames');
t = Datapixx('GetTime');
t2 = Datapixx('GetTime');
Screen('TextSize', windowPtr, 24);

%% Step 1 -- Show the eye, 
% Update the eye image every 16.67 ms or so just for focus.
% Press any key to go towards the right step, escape to exit.
while (1)
    
if ((t2 - t) > 1/60) 
    Datapixx('RegWrRd');
    image = Datapixx('GetEyeImage');
    textureIndex=Screen('MakeTexture', windowPtr, image');
    Screen('DrawTexture', windowPtr, textureIndex);
    DrawFormattedText(windowPtr, 'Press Enter once the Eyes are Focused', 'center', 700, 255); 
    Screen('Flip', windowPtr);
    t = t2;
else
    Datapixx('RegWrRd');
    t2 = Datapixx('GetTime');
end
    % Keypress goes to next step of demo
    [pressed dummy keycode] = KbCheck;
    if pressed
        if keycode(KbName('escape'))
            Screen('CloseAll')
            Datapixx('Close');
            return;
        else
            break;
        end
    end
end

WaitSecs(1);

%% Step 2 -- Show screen squares and record data
% We will now show alternating fixation point on the screen. Once the
% target is following the fixation, press any key other than escape to
% start recording.

cx = 1920/2;
cy = 1080/2;
dx = 400;
dy = 250;
xy = [cx+dx cy+dy; cx-dx cy+dy; cx-dx cy-dy; cx+dx cy-dy];
xy = [xy;xy]';
size = [30; 30; 30; 30; 10; 10; 10; 10]';
color = [255 255 255; 255 255 255; 255 255 255; 255 255 255; 0 0 0; 0 0 0; 0 0 0; 0 0 0]';
i = 0;
Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
recording = 0;
start_time = 0;
while (1)

    
if ((t2 - t) > 1) 
    Datapixx('RegWrRd');
    i = i + 1;
    %Screen('DrawDots', windowPtr, xy, size, color,[], 1);
    Screen('DrawDots', windowPtr, [xy(:,mod(i,4)+1) xy(:,mod(i,4)+1)], [30;10]', [255 255 255; 0 0 0]',[], 1);
    if ~recording
        DrawFormattedText(windowPtr, 'Press enter when ready to record', 'center', 80, 255); 
    end
    Screen('Flip', windowPtr);
    t = t2;
else
    Datapixx('RegWrRd');
    t2 = Datapixx('GetTime');
end
    % Keypress starts recording
    [pressed dummy keycode] = KbCheck;
    if pressed
        if keycode(KbName('escape'))
            Screen('CloseAll')
            Datapixx('Close');
            return;
        else
            recording = 1;
            Datapixx('SetupTPxSchedule'); % Set up recording
            Datapixx('RegWrRd');
            Datapixx('StartTPxSchedule'); % Start recording
            Datapixx('RegWrRd');
            start_time = Datapixx('GetTime');
        end
    end
    
    if (recording == 1)
        Datapixx('RegWrRd');
        curr_time = Datapixx('GetTime');
        if ((curr_time - start_time) > 5)
            Datapixx('StopTPxSchedule'); % Stop recording
            Datapixx('RegWrRd');
            finish_time = Datapixx('GetTime');
            break;
        end
    end
end

    
WaitSecs(1.0);
%% Step 3 -- Analyze the data


DrawFormattedText(windowPtr, 'Analyzing Data...Please wait', 'center', 80, 255); 
Screen('Flip', windowPtr);
fprintf('Recording lasted %f seconds', finish_time-start_time);
WaitSecs(2.0);
Datapixx('RegWrRd');
status = Datapixx('GetTPxStatus');
toRead = status.newBufferFrames;


%% Step 4 -- Get and Plot Data
% Data is as follow in the bufferData
% NOTE:  ADD 1 to the C defined index since Matlab is indexed from 1
%    RODI_TimeTag = 0,
%    RODI_LX,
%    RODI_LY,
%    RODI_LSZA,
%    RODI_RX,
%    RODI_RY,
%    RODI_RSZA,
%    RODI_DIN,
%    RODI_LBLINK,
%    RODI_RBLINK,
%    RODI_DOUT,
%    RODI_LFIXATION,
%    RODI_RFIXATION,
%    RODI_LSACCADE,
%    RODI_RSACCADE,
%    RODI_MSGCODE,
%    RODI_RAWLX,
%    RODI_RAWLY,
%    RODI_RAWRX,
%    RODI_RAWRY,

[bufferData, underflow, overflow] = Datapixx('ReadTPxData', toRead);

figure;
hold on;
title('Left Eye');
plot(bufferData(:,1), bufferData(:,17))
plot(bufferData(:,1), bufferData(:,18))

figure;
hold on;
title('Right Eye');
plot(bufferData(:,1), bufferData(:,19))
plot(bufferData(:,1), bufferData(:,20))


%% Close all!
Screen('CloseAll');

Datapixx('Close');

end

