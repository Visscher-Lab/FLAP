function TPxRawRecordAndPlot()
%
% This demo will start the required things to start the TPx schedule to record data
% and it will show points for 4 secs and record raw or calibrated data.
% After the four seconds, the data will be plotted.
%
%
% Dec 22, 2017  dml written

Screen('Preference', 'SkipSyncTests', 1);

%% Step 1 -- Open the screen and show the eye.
Datapixx('Open');
Datapixx('SetLedIntensity', 8); 
Datapixx('SetTPxAwake');
Datapixx('SetExpectedIrisSizeInPixels', 115)
Datapixx('RegWrRd');
image = Datapixx('GetEyeImage');
[windowPtr, windowRect]=PsychImaging('OpenWindow', 2, 0);
KbName('UnifyKeyNames');
t = Datapixx('GetTime');
t2 = Datapixx('GetTime');
Screen('TextSize', windowPtr, 24);
i = 0;
while (1)

    
if ((t2 - t) > 1/60) 
    Datapixx('RegWrRd');
    image = Datapixx('GetEyeImage');
    textureIndex=Screen('MakeTexture', windowPtr, image');
    Screen('DrawTexture', windowPtr, textureIndex);
    DrawFormattedText(windowPtr, 'Press Enter once the Eye are Focused', 'center', 700, 255); 
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
%% Step 2 -- Show screen squares
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
    %Screen('DrawDots', windowPtr, xy, size, color,[], 0);
    Screen('DrawDots', windowPtr, [xy(:,mod(i,4)+1) xy(:,mod(i,4)+1)], [30;10]', [255 255 255; 0 0 0]', [], 0);
    if ~recording
        DrawFormattedText(windowPtr, 'Press enter when ready to record', 'center', 80, 255); 
    end
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
            recording = 1;
            Datapixx('SetupTPxSchedule');
            Datapixx('RegWrRd');
            Datapixx('StartTPxSchedule');
            Datapixx('RegWrRd');
            start_time = Datapixx('GetTime');
        end
    end
    
    if (recording == 1)
        Datapixx('RegWrRd');
        curr_time = Datapixx('GetTime');
        if ((curr_time - start_time) > 5)
            Datapixx('StopTPxSchedule');
            Datapixx('RegWrRd');
            finish_time = Datapixx('GetTime');
            break;
        end
    end
end

% Screen('DrawDots', windowPtr, xy, size, color,[], 1);
% Screen('Flip', windowPtr);
    
WaitSecs(1.0);
%% Step 3 -- Recording

% Datapixx('SetupTPxSchedule');
% Datapixx('RegWrRd');
% 

DrawFormattedText(windowPtr, 'Analyzing Data...Please wait', 'center', 80, 255); 
Screen('Flip', windowPtr);


% Datapixx('GetTPxStatus')
% Datapixx('RegWrRd');
% 
% Datapixx('StartTPxSchedule');
% Datapixx('RegWrRd');
% start_time = Datapixx('GetTime');
% % fprintf('Recording started at %f', l);
% % Datapixx('GetTPxStatus')
% WaitSecs(4.0);
% % 
% Datapixx('StopTPxSchedule');
% Datapixx('RegWrRd');
% finish_time = Datapixx('GetTime');
fprintf('Recording lasted %f seconds', finish_time-start_time);
WaitSecs(2.0);
Datapixx('RegWrRd');
status = Datapixx('GetTPxStatus');
toRead = status.newBufferFrames;


%% Step 4 -- Get and Plot Data
[bufferData, underflow, overflow] = Datapixx('ReadTPxData', toRead);

figure;
hold on;
grid on;
title('Left Eye (Red: X, Blue: Y)');
xlabel('Timetags (seconds)');
ylabel('Gaze information (pixels)');
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,17), 'r')
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,18), 'b')

figure;
hold on;
grid on;
title('Right Eye (Red: X, Blue: Y)');
xlabel('Timetags (seconds)');
ylabel('Gaze information (pixels)');
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,19), 'r')
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,20), 'b')

figure;
hold on;
grid on;
title('Both Eyes (Red: Left X, Blue:  Left Y, Black: Right X, Magenta: Right Y)');
xlabel('Timetags (seconds)');
ylabel('Gaze information (pixels)');
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,17), 'r')
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,18), 'b')
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,19), 'c')
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,20), 'm')


%% Close all!
Screen('CloseAll');

Datapixx('Close');

end