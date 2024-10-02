function DatapixxSimonGame()
% DatapixxSimonGame()
%
% A microsecond-accurate audio-visual reaction time game using RESPONSEPixx.
%
% History:
%
% Oct 1, 2009  paa     Written

AssertOpenGL;   % We use PTB-3

% for igame = 0:1000

% User initiates test from keyboard
fprintf('\n\nDATAPixx response-time game.\n');
fprintf('-Connect RESPONSEPixx button box to \"Digital IN\" db-25.\n');
fprintf('-If a button lights up, and a beep sounds, press the button as fast as possible.\n');
fprintf('-If a button lights up, but no beep sounds, do not press any buttons.\n');
HitKeyToContinue('Hit any key on keyboard to begin...\n');

% Open Datapixx, and stop any schedules which might already be running
Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

% Initialize audio system
Datapixx('InitAudio');
Datapixx('SetAudioVolume', 0.25);  % If using headphones, 0.2 is a bit too loud

% Our audio cues and feedback beeps will all be sinewaves.
% Sample a single sinewave period,
% and download the waveform to the Datapixx's default audio address. 
nSinewaveSamples = 32;
audioWave = sin([1:nSinewaveSamples]/nSinewaveSamples*2*pi);
Datapixx('WriteAudioBuffer', audioWave);

% Configure digital input system for monitoring button box
Datapixx('SetDinDataDirection', hex2dec('1F0000'));     % Drive 5 button lights
Datapixx('EnableDinDebounce');                          % Debounce button presses
Datapixx('SetDinLog');                                  % Log button presses to default address
Datapixx('StartDinLog');                                % Turn on logging
Datapixx('RegWrRd');

% Bit locations of button inputs, and colored LED drivers
doutRed     = hex2dec('00010000');
doutGreen   = hex2dec('00040000');
dinRed      = hex2dec('0000FFFE');
dinGreen    = hex2dec('0000FFFB');

% Generate random list of 4 trial types
nReps = 16;
condList = bitand(randperm(nReps),3);

% Initialize response time statistics
nData = 0;
sumData = 0;

% Assume the best, and away we goooo....
winner = 1;
for iRep = 1:nReps

    % Turn off RESPONSEPixx button lights
    Datapixx('SetDinDataOut', 0);
    Datapixx('RegWrRd');

    % Wait until all buttons are up
    while (bitand(Datapixx('GetDinValues'), hex2dec('FFFF')) ~= hex2dec('FFFF'))
        Datapixx('RegWrRd');
    end

    % Flush any past button presses
    Datapixx('SetDinLog');
    Datapixx('RegWrRd');
    % Wait random 1-2 second trial onset delay, so player can't anticipate.
    % Any button press during this period is considered a wrong answer.
    trialStartTime = Datapixx('GetTime') + 1 + rand();
    while (Datapixx('GetTime') < trialStartTime)
        Datapixx('RegWrRd');
        buttonLogStatus = Datapixx('GetDinStatus');
        if (buttonLogStatus.newLogFrames > 0)
            fprintf('OOPS...You pressed a button before any lights came on!\n');
            winner = 0;
            break;
        end
    end
    if (winner == 0)
        break;
    end

    % Bit 0 of condition specifies whether the red or green button should light up
    if (bitand(condList(iRep), 1))
        Datapixx('SetDinDataOut', doutRed);
        correctResponse = dinRed;
    else
        Datapixx('SetDinDataOut', doutGreen);
        correctResponse = dinGreen;
    end

    % Bit 1 of condition indicates if we should beep.
    % 32-sample sinewave buffer playing at 40 kSPS gives a 1250 Hz tone.
    % Playing for 16000 samples gives a tone duration of 400 milliseconds.
    if (bitand(condList(iRep), 2))
        Datapixx('SetAudioSchedule', 0, 40000, 16000, 0, 16e6, nSinewaveSamples);
        Datapixx('StartAudioSchedule');
    end

    % The following 'RegWrRd' register cache update command will simultaneously:
    %   -Turn on the button light.
    %   -Start audio playback (if enabled above).
    %   -Latch all register values, including DATAPixx time at which the stimulus began.
    % Calling 'RegWrRdVideoSync' instead of 'RegWrRd' would synchronize all 3 with video refresh.
    Datapixx('RegWrRd');
    stimulusStartTime = Datapixx('GetTime');

    % Wait up to 1 second for a keypress
    while (Datapixx('GetTime') < stimulusStartTime + 1)
        Datapixx('RegWrRd');
        buttonLogStatus = Datapixx('GetDinStatus');
        if (buttonLogStatus.newLogFrames > 0)
            break;
        end
    end

    % First we'll handle the case where the audio tone was on.
    % In this case, player was supposed to hit the illuminated button.
    if (bitand(condList(iRep), 2))

        % If they didn't hit any button, it's a wrong answer
        if (buttonLogStatus.newLogFrames == 0)
            fprintf('OOPS...You were supposed to press the illuminated button!\n');
            winner = 0;
            break;
        end

        % Check if they hit the correct key
        [data timetags] = Datapixx('ReadDinLog');
        if (data(1) ~= correctResponse)
            fprintf('OOPS...You pressed the wrong button!\n');
            winner = 0;
            break;
        end

        % Accumulate their response time into the statistics
        reactionTime = timetags(1) - stimulusStartTime;
        fprintf('reactionTime = %f\n', reactionTime);
        if (exist('OCTAVE_VERSION'))
            fflush(stdout);
        end
        sumData = sumData + reactionTime;
        nData = nData + 1;

    % Second we'll handle the case where the audio tone was off.
    % In this case, player was not supposed to hit any button.
    elseif (buttonLogStatus.newLogFrames > 0)
        fprintf('OOPS...There was no beep, so do not press any buttons!\n');
        winner = 0;
        break;
    end
end

% Game is over, so turn off all button lights
Datapixx('SetDinDataOut', 0);
Datapixx('RegWrRd');

% If player made it through all trials without any errors, they win!
% Reward with a pleasant musical chirp, and print their stats.
if (winner)
    fprintf('\nSuccess!\n', sumData / nData * 1000);
    fprintf('Mean reactionTime = %d ms\n', sumData / nData * 1000);
    Datapixx('SetAudioSchedule', 0, 40000, 8000, 0, 16e6, nSinewaveSamples);
    Datapixx('StartAudioSchedule');
    Datapixx('RegWrRd');
    while 1
        Datapixx('RegWrRd');   % Update registers for GetAudioStatus
        status = Datapixx('GetAudioStatus');
        if (~status.scheduleRunning)
            break;
        end
    end
    Datapixx('SetAudioSchedule', 0, 80000, 16000, 0, 16e6, nSinewaveSamples);
    Datapixx('StartAudioSchedule');
    Datapixx('RegWrRd');
    while 1
        Datapixx('RegWrRd');   % Update registers for GetAudioStatus
        status = Datapixx('GetAudioStatus');
        if (~status.scheduleRunning)
            break;
        end
    end

% If player hit a key when they weren't supposed to,
% then taunt them with an unsavoury buzz.
else
    Datapixx('SetAudioSchedule', 0, 10000, 10000, 0, 16e6, nSinewaveSamples);
    Datapixx('StartAudioSchedule');
    Datapixx('RegWrRd');
    while 1
        Datapixx('RegWrRd');   % Update registers for GetAudioStatus
        status = Datapixx('GetAudioStatus');
        if (~status.scheduleRunning)
            break;
        end
    end
end

% Job done
Datapixx('Close');
fprintf('\nGame completed\n\n');

% end
