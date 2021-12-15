function DatapixxAudioStreamDemo(wavFilename)
% DatapixxAudioStreamDemo([wavFilename=funk.wav])
%
% Demonstrates how to continuously stream an audio waveform to the DATAPixx CODEC.
%
% Optional argument:
%
% wavFilename = Name of a .wav sound file to load and play.
%               Otherwise the funk.wav provided with PsychToolbox is used.
%
% Also see: DatapixxAudioDemo
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

% Load the .wav file
[waveData, freq] = audioread(wavFilename);
waveData = waveData';               % Transpose so that each row has 1 channel
nChannels = size(waveData, 1);
nTotalFrames = size(waveData, 2);

% We'll demonstrate streaming with a 1 second buffer,
% and update the streaming buffer no faster than 100 times per second.
nBufferFrames = freq;
if (nBufferFrames > nTotalFrames)
    nBufferFrames = nTotalFrames;
end
minStreamFrames = floor(freq / 100);

% Open DATAPixx, and stop any schedules which might already be running
Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('InitAudio');
Datapixx('SetAudioVolume', 1.00);    % Not too loud
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

% Fill the buffer with as much of the data that fits.
Datapixx('WriteAudioBuffer', waveData(:,1:nBufferFrames), 0);

% Configure the DATAPixx to play the buffer at the correct frequency.
% If the .wav file has a single channel, it will play to both ears in mono mode,
% otherwise it will play in stereo mode.
if (nChannels == 1)
    lrMode = 0;
else
    lrMode = 3;
end
Datapixx('SetAudioSchedule', 0, freq, nTotalFrames, lrMode, 0, nBufferFrames);

% Start the playback
Datapixx('StartAudioSchedule');
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

% Continuously feed the streaming buffer until the entire waveform has been played,
% or until a key is pressed.
fprintf('\nWaveform playback starting, press any key to abort.\n');
if (exist('OCTAVE_VERSION'))
    fflush(stdout);
end
nextWriteFrame = nBufferFrames + 1;
nFramesLeft = nTotalFrames - nBufferFrames;
while nFramesLeft > 0
    Datapixx('RegWrRd');   % Update registers for GetAudioStatus
    status = Datapixx('GetAudioStatus');
    if status.freeBufferFrames >= minStreamFrames           % Do not waste CPU time doing millions of tiny buffer updates
        if status.freeBufferFrames >= nFramesLeft           % Stream buffer has room for remainder of the waveform?
            nStreamFrames = nFramesLeft;                    % This iteration will download the remainder of the waveform
        else
            nStreamFrames = status.freeBufferFrames;        % Top off stream buffer with a section of waveform
        end
        Datapixx('WriteAudioBuffer', waveData(:, nextWriteFrame: nextWriteFrame+nStreamFrames-1), -1);    % Download waveData
        nextWriteFrame = nextWriteFrame + nStreamFrames;    % Update for next iteration
        nFramesLeft = nFramesLeft - nStreamFrames;
    end

    % A keypress will immediately abort the schedule
    if (KbCheck)
        Datapixx('StopAudioSchedule');
        Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache
        break;
    end
end

% Show final status of DAC scheduler
fprintf('\nStatus information for audio scheduler:\n');
Datapixx('RegWrRd');   % Update registers for GetAudioStatus
disp(Datapixx('GetAudioStatus'));

% Job done
Datapixx('Close');
fprintf('\nDemo completed\n\n');
