function DatapixxAudioFeedbackDemo(feedbackDelay)
% DatapixxAudioFeedbackDemo([feedbackDelay=1])
%
% Records audio from the microphone input,
% and simultaneously plays back the recording on the audio outputs.
% For ultimate precision, this demo takes into consideration both the audio input
% group delay, and the audio output group delay. The DATAPixx is capable of
% implementing mouth-to-ear feedback delays of under 1 millisecond at 48 kSPS,
% and under half a millisecond at 96 kSPS.
%
% Optional argument:
%
% feedbackDelay is the delay in seconds between when sound is recorded from the
% microphone, and when the same sound appears at the audio outputs.
%
% Also see: DatapixxMicrophoneDemo
%
% History:
%
% Nov 1, 2009  paa     Written
% Oct 29, 2014 dml     Revised 

AssertOpenGL;   % We use PTB-3

% OS-independant keyCodes
KbName('UnifyKeyNames');
Escape = KbName('ESCAPE');

% Open DATAPixx, and stop any schedules which might already be running
Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('InitAudio');
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

sampleRate = 96000;     % Use highest rate to permit smallest possible feedback delays

% Get feedback delay argument
if nargin < 1
    feedbackDelay = [];
end
if isempty(feedbackDelay)
    feedbackDelay = 1;
end

% We'll subtract out the CODEC input and output group delays to implement the "real-world" feedback delay.
inputDelay = Datapixx('GetMicrophoneGroupDelay', sampleRate);
outputDelay = Datapixx('GetAudioGroupDelay', sampleRate);
feedbackDelay = feedbackDelay - inputDelay - outputDelay;

% We'll require a minimum delay of 2 audio samples,
% just to ensure that the audio input schedule can write its datum to DRAM
% before the audio output schedule tries to read that location.
minimumDelay = 2 / sampleRate;
if (feedbackDelay < minimumDelay)
    feedbackDelay = minimumDelay;
    fprintf('Clamping feedback delay to minimum value of %d microseconds\n', (minimumDelay + inputDelay + outputDelay) * 1e6);
end;

% Configure audio acquisition
Datapixx('SetMicrophoneSource', 1, 100);    % Always record from microphone
Datapixx('DisableAudioLoopback');
Datapixx('RegWrRd');

% We'll record into address 0, with a 20 megabyte buffer for up to 100 seconds of feedbackDelay at 48kSPS.
Datapixx('SetMicrophoneSchedule', 0, sampleRate, 0, 3, 0, 20e6);
Datapixx('StartMicrophoneSchedule');

% We'll playback from the same buffer, but with a schedule onset delay.
Datapixx('SetAudioVolume', 0.25);    % Not too loud
Datapixx('SetAudioSchedule', feedbackDelay, sampleRate, 0, 3, 0, 20e6);
Datapixx('StartAudioSchedule');

% Start both schedules at exactly the same time.
% The microphone will record its first sample immediately,
% but the audio will only playback its first sample after feedbackDelay.
Datapixx('RegWrRd');

% When user hits a key, we'll stop the feedback.
% Note that this feedback is all being done in hardware.
% No realtime software overhead. No glitches. You could even quit MATLAB.
fprintf('\nAudio feedback has begun\n');

HitKeyToContinue('Hit any key to terminate...');
Datapixx('StopMicrophoneSchedule');
Datapixx('StopAudioSchedule');
Datapixx('RegWrRd');

% Job done
Datapixx('Close');
fprintf('\nDemo completed\n\n');
