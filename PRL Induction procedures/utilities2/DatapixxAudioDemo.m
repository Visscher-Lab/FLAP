function DatapixxAudioDemo(wavFilename, repetitions)
% DatapixxAudioDemo([wavFilename=funk.wav] [, repetitions=0])
%
% Demonstrates how to play an audio waveform using the Datapixx CODEC.
%
% Optional arguments:
%
% wavFilename = Name of a .wav sound file to load and play.
%               Otherwise the funk.wav provided with PsychToolbox is used.
%
% repetitions = Number of times to play the sound.
%               0 means play until the sun goes nova
%               (or a keypress, whichever comes first)
%
% Also see: DatapixxAudioStreamDemo
%
% History:
%
% Oct 1, 2009  paa     Written
% Oct 29, 2014 dml     Revised 

AssertOpenGL;   % We use PTB-3

% Get the .wav filename
if nargin < 1
    wavFilename = [];
end
if isempty(wavFilename)
    wavFilename = [PsychtoolboxRoot 'PsychDemos' filesep 'SoundFiles' filesep 'funk.wav'];
end

% Get the number of repetitions
if nargin < 2
    repetitions = [];
end
if isempty(repetitions)
    repetitions = 0;
end

% Load the .wav file
[waveData, freq] = audioread(wavFilename);
waveData = waveData';               % Transpose so that each row has 1 channel
nChannels = size(waveData, 1);
nTotalFrames = size(waveData, 2);

% Open Datapixx, and stop any schedules which might already be running
Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('InitAudio');
Datapixx('SetAudioVolume', 1.00);    % Not too loud
Datapixx('RegWrRd');    % Synchronize Datapixx registers to local register cache

% Download the entire waveform to address 0.
Datapixx('WriteAudioBuffer', waveData, 0);

% Configure the Datapixx to play the buffer at the correct frequency.
% If the .wav file has a single channel, it will play to both ears in mono mode,
% otherwise it will play in stereo mode.
if (nChannels == 1)
    lrMode = 0;
else
    lrMode = 3;
end
if (repetitions > 0)    % Play a fixed number of reps
    Datapixx('SetAudioSchedule', 0, freq, nTotalFrames*repetitions, lrMode, 0, nTotalFrames);
else                    % Play forever
    Datapixx('SetAudioSchedule', 0, freq, 0, lrMode, 0, nTotalFrames);
end

% Start the playback
Datapixx('StartAudioSchedule');
Datapixx('RegWrRd');    % Synchronize Datapixx registers to local register cache

% Wait until schedule stops, or until a key is pressed.
fprintf('\nWaveform playback starting, press any key to abort.\n');
if (exist('OCTAVE_VERSION'))
    fflush(stdout);
end
while 1
    Datapixx('RegWrRd');   % Update registers for GetAudioStatus
    status = Datapixx('GetAudioStatus');
    if ~status.scheduleRunning
        break;
    end
    if KbCheck
        Datapixx('StopAudioSchedule');
        Datapixx('RegWrRd');    % Synchronize Datapixx registers to local register cache
        break;
    end
end

% Show final status of audio scheduler
fprintf('\nStatus information for audio scheduler:\n');
Datapixx('RegWrRd');   % Update registers for GetAudioStatus
disp(Datapixx('GetAudioStatus'));

% Job done
Datapixx('Close');
fprintf('\nDemo completed\n\n');
