function TPxMiniRecordAndPlot()
%
% This demo will start the required things to start the TPx schedule to record data
% and it will show points for 4 secs and record raw or calibrated data.
% After the four seconds, the data will be plotted.
%
%
% Dec 22, 2017  dml written

Screen('Preference', 'SkipSyncTests', 1);

%% Step 1 -- Open the screen and show the eye.

        %Ensure that the TPx/m has no open session before using it.
        Datapixx('CloseTPxMini');

        %'Initialize' opens a TPx/m session and determines the
        %filter mode and screen margin to use for calibration.  We 
        %recommend using filter mode 0 (no filtering).
%-->    %It is mandatory to call 'Initialize' before using the 
        %TPx/m.
        Datapixx('OpenTPxMini', 80);
        %'GetEyeImageTPxMini' returns the image coming from the TPx/m
        image = Datapixx('GetEyeImageTPxMini');
        
[windowPtr, windowRect]=PsychImaging('OpenWindow', 1 , 0);
KbName('UnifyKeyNames');

Screen('TextSize', windowPtr, 24);
i = 0;
% Display camera live stream.
while (1)
    image = Datapixx('GetEyeImageTPxMini');
    textureIndex=Screen('MakeTexture', windowPtr, image');
    Screen('DrawTexture', windowPtr, textureIndex);
    DrawFormattedText(windowPtr, 'Press Enter once the Eye are Focused', 'center', 700, 255); 
    Screen('Flip', windowPtr);

    % Keypress goes to next step of demo
    [pressed dummy keycode] = KbCheck;
    if pressed
        if keycode(KbName('escape'))
            Screen('CloseAll');
            Datapixx('CloseTPxMini');
            return;
        else
            break;
        end
    end
end

WaitSecs(1);
%% Step 2 -- Show screen squares and record


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
u = 1;
start_rec = 0;
start_time = GetSecs;
bufferData = zeros(120*20, 8);
bufferSecs = zeros(120*20, 1);
while (1)

time_now = GetSecs;
if (((time_now - start_time) > 1))% && ~recording)
    i = i + 1;
    %Screen('DrawDots', windowPtr, xy, size, color,[], 0);
    Screen('DrawDots', windowPtr, [xy(:,mod(i,4)+1) xy(:,mod(i,4)+1)], [30;10]', [255 255 255; 0 0 0]', [], 0);
    if ~recording
        DrawFormattedText(windowPtr, 'Press enter when ready to record', 'center', 80, 255); 
    end
    Screen('Flip', windowPtr);
    start_time = time_now;   
end
    % Keypress goes to next step of demo
    [pressed dummy keycode] = KbCheck;
    if pressed
        fprintf('Recording Data now');
        if keycode(KbName('escape'))
            Screen('CloseAll')
            Datapixx('CloseTPxMini');
            return;
        else
            recording = 1;
            start_rec = GetSecs;
            %break;
        end
    end
    
    if (recording == 1)
        %break;
        [bufferData(u, :)] = Datapixx('ReadTPxMiniData');
        u = u + 1;
        curr_time = GetSecs;
        if ((curr_time - start_rec) > 4)
            finish_time = curr_time;
            break;
        end
    end
end
    
WaitSecs(1.0);
%% Step 3 -- Analysis


DrawFormattedText(windowPtr, 'Analyzing Data...Please wait', 'center', 80, 255); 
Screen('Flip', windowPtr);


fprintf('\nRecording lasted %f seconds\n I got %d frames (should have gotten: %d) \n', finish_time-start_rec, u-1, round((finish_time-start_rec)*120) );

% tt, leftx, lefty, leftpp, rightx, righty, rightpp, distance
bufferData = bufferData(1:(u-1),:);
figure;
hold on;
grid on;
title('Left Eye (Red: X, Blue: Y)');
xlabel('Timetags (seconds)');
ylabel('Gaze information (pixels)');
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,2), 'r')
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,3), 'b')

figure;
hold on;
grid on;
title('Right Eye (Red: X, Blue: Y)');
xlabel('Timetags (seconds)');
ylabel('Gaze information (pixels)');
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,5), 'r')
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,6), 'b')

figure;
hold on;
grid on;
title('Both Eyes (Red: Left X, Blue:  Left Y, Black: Right X, Magenta: Right Y)');
xlabel('Timetags (seconds)');
ylabel('Gaze information (pixels)');
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,2), 'r')
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,3), 'b')
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,5), 'c')
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,6), 'm')

figure;
hold on;
grid on;
title('Pupil over time (Red: Left, Blue: Right)');
xlabel('Timetags (seconds)');
ylabel('Pupil Size (pixels)');
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,4), 'r')
plot(bufferData(:,1)-bufferData(1,1), bufferData(:,7), 'b')
save bufferData

%% Close all!
Screen('CloseAll');

Datapixx('CloseTPxMini');

end