function DatapixxMicrophoneDemo(audioSource)
% DatapixxMicrophoneDemo([audioSource=1])
%
% Records audio from the microphone input,
% then plays back the recording on the audio outputs.
%
% Optional argument:
%
% audioSource = 1 to use a high-impedance microphone plugged into "MIC IN" jack
%               2 to use a line-level audio source plugged into "Audio IN" jack
%
% Also see: DatapixxAudioFeedbackDemo
%
% History:
%
% Nov 1, 2009  paa     Written
% Oct 29, 2014   dml     Revised

AssertOpenGL;   % We use PTB-3

% OS-independant keyCodes
KbName('UnifyKeyNames');
Escape = KbName('ESCAPE');

% Open Datapixx, and stop any schedules which might already be running
Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('InitAudio');
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

% Get audio source argument
if nargin < 1
    audioSource = [];
end
if isempty(audioSource)
    audioSource = 1;
end

% Configure audio acquisition
if (audioSource == 1)
    fprintf('\nEnsure microphone is plugged into DATAPixx "MIC IN" jack\n');
    gain = 100;    % For inexpensive high-impedance microphones
elseif (audioSource == 2)
    fprintf('\nEnsure audio source is plugged into DATAPixx "Audio IN" jack\n');
    gain = 1;      % For powered microphones, or other line-level audio
else
    fprintf('audioSource argument must be either 1 or 2\n');
    Datapixx('Close');
    return;
end
Datapixx('SetMicrophoneSource', audioSource, gain);
Datapixx('DisableAudioLoopback');
Datapixx('RegWrRd');

% We'll keep executing record/playback loop until user escapes
while (1)
    KbReleaseWait();    % Wait until no buttons are being pressed
    fprintf('\nHit any key to start recording, (or <escape> to exit)...\n');
    if (exist('OCTAVE_VERSION'))
        fflush(stdout);
    end
    [~, keyCode] = KbWait;      % Wait for the initiating keypress
    if keyCode(Escape)
        break;
    end

    % Start recording stereo audio input at 48 kHz.
    % We'll record into address 0, with a 5 million frame buffer (20MB) for up to 100 seconds of solid recording.
    Datapixx('SetMicrophoneSchedule', 0, 48000, 0, 3, 0, 5e6);
    Datapixx('StartMicrophoneSchedule');
    Datapixx('RegWrRd');
    fprintf('Recording...\n');
    if (exist('OCTAVE_VERSION'))
        fflush(stdout);
    end

    % A second keypress will stop the recording
    KbReleaseWait();
    fprintf('Hit any key to stop recording, and initiate playback...\n');
    if (exist('OCTAVE_VERSION'))
        fflush(stdout);
    end
    [~, keyCode] = KbWait;      % I guess we'll permit an escape here as well
    if keyCode(Escape)
        break;
    end
    Datapixx('StopMicrophoneSchedule');
    Datapixx('RegWrRd');

    % How many samples did we acquire?
    status = Datapixx('GetMicrophoneStatus');
    nFrames = status.newBufferFrames;
    
    % At this point, we could upload the data to the host with the following command:
    %   data = Datapixx('ReadMicrophoneBuffer', nFrames);
    % Instead, we are to tell the audio output system to playback directly from the acquisition buffer!
    Datapixx('SetAudioVolume', 0.25);    % Not too loud
    Datapixx('SetAudioSchedule', 0, 48000, nFrames, 3, 0);
    Datapixx('StartAudioSchedule');
    Datapixx('RegWrRd');
    fprintf('Now its PLAYBACK time...\n');
    if (exist('OCTAVE_VERSION'))
        fflush(stdout);
    end
    
    % We'll wait around until the playback has completed.
    endDemo = 0;
    while(1)
        Datapixx('RegWrRd');
        status = Datapixx('GetAudioStatus');
        if (~status.scheduleRunning)
            break;
        end
        
        % Let an escape during playback also terminate the demo
        [keyIsDown, ~, keyCode] = KbCheck;
        if (keyIsDown && keyCode(Escape))
            Datapixx('StopAudioSchedule');
            Datapixx('RegWrRd');
            endDemo = 1;
            break;
        end
    end
    if (endDemo)
        break;
    end
end

% Job done
Datapixx('Close');
fprintf('\n\nDemo completed\n\n');
