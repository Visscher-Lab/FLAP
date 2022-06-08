function DatapixxDacWaveStreamDemo(wavFilename)
% DatapixxDacWaveStreamDemo([wavFilename=funk.wav])
%
% Demonstrates how to continuously stream an audio waveform to the DATAPixx DAC
% (Digital to Analog Converter) subsystem.
%
% The precision DACs are capable of updating at up to 1 MHz, and can be used to
% generate arbitrary analog waveforms with an output swing of up to +-10V.
% One application of the DACs is for the generation of precise audio stimuli.
% The audio CODECs found in typical consumer electronics have serial interfaces.
% Internally, the CODEC processes the serial data with digital interpolation
% filters, a delta-sigma modulator, and an analog reconstruction filter.
% One result is that a single dataset played back on two different CODECs
% can result in slightly different analog waveforms. Using DACs eliminates this
% variation.
%
% A second issue is the CODEC group delay. CODECs introduce a delay between
% when they receive their serial data, and when their analog outputs update.
% This delay varies from one CODEC to another, and also varies within a single
% CODEC depending on waveform update rate. Using DACs eliminates this variation.
%
% Note that the DAC outputs are not intended to drive very heavy loads. It is
% possible to drive up to +-1V waveforms (like those used in PsychPortAudio)
% directly into 32 Ohm headphones, or up to +-10V waveforms into high impedance
% (eg: 400 Ohm) headphones like those used for studio quality sound. For higher
% power, or for driving 8 Ohm speaker loads, add an external headphone amplifier.
%
% Optional argument:
%
% wavFilename = Name of a .wav sound file to load and play.
%               Otherwise the funk.wav provided with PsychToolbox is used.
%
% Also see: DatapixxDacWaveDemo
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

% Open Datapixx, and stop any schedules which might already be running
Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

% Fill the buffer with as much of the data that fits.
% First write to DAC buffer must be in non-streaming mode.
Datapixx('WriteDacBuffer', waveData(:,1:nBufferFrames));

% Configure the DATAPixx to play the buffer at the correct frequency.
% If the .wav file has a single channel, it will play on DAC channel 0.
% Additional .wav channels will play on increasing DAC channel numbers. 
Datapixx('SetDacSchedule', 0, freq, nTotalFrames, [0: nChannels-1], 0, nBufferFrames);

% Start the playback
Datapixx('StartDacSchedule');
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
    Datapixx('RegWrRd');   % Update registers for GetDacStatus
    status = Datapixx('GetDacStatus');
    if status.freeBufferFrames >= minStreamFrames           % Do not waste CPU time doing millions of tiny buffer updates
        if status.freeBufferFrames >= nFramesLeft           % Stream buffer has room for remainder of the waveform?
            nStreamFrames = nFramesLeft;                    % This iteration will download the remainder of the waveform
        else
            nStreamFrames = status.freeBufferFrames;        % Top off stream buffer with a section of waveform
        end
        Datapixx('WriteDacBuffer', waveData(:, nextWriteFrame: nextWriteFrame+nStreamFrames-1), -1);    % Download waveData
        nextWriteFrame = nextWriteFrame + nStreamFrames;    % Update for next iteration
        nFramesLeft = nFramesLeft - nStreamFrames;
    end

    % A keypress will immediately abort the schedule
    if (KbCheck)
        Datapixx('StopDacSchedule');
        Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache
        break;
    end
end

% Show final status of DAC scheduler
fprintf('\nStatus information for DAC scheduler:\n');
Datapixx('RegWrRd');   % Update registers for GetDacStatus
disp(Datapixx('GetDacStatus'));

% Job done
Datapixx('Close');
fprintf('\nDemo completed\n\n');
