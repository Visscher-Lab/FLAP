function DatapixxDacWaveDemo(wavFilename, repetitions)
% DatapixxDacWaveDemo([wavFilename=funk.wav] [, repetitions=0])
%
% Demonstrates how to play an audio waveform using the DATAPixx DAC
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
% Optional arguments:
%
% wavFilename = Name of a .wav sound file to load and play.
%               Otherwise the funk.wav provided with PsychToolbox is used.
%
% repetitions = Number of times to play the sound.
%               0 means play until the sun goes nova
%               (or a keypress, whichever comes first)
%
% Also see: DatapixxDacWaveStreamDemo
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
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

% Download the entire waveform to the DATAPixx default DAC address of 0.
Datapixx('WriteDacBuffer', waveData, 0);

% Configure the DATAPixx to play the buffer at the correct frequency.
% If the .wav file has a single channel, it will play on DAC channel 0.
% Additional .wav channels will play on increasing DAC channel numbers.
if (repetitions > 0)    % Play a fixed number of reps
    Datapixx('SetDacSchedule', 0, freq, nTotalFrames*repetitions, [0: nChannels-1], 0, nTotalFrames);
else                    % Play forever
    Datapixx('SetDacSchedule', 0, freq, 0, [0: nChannels-1], 0, nTotalFrames);
end

% Start the playback
Datapixx('StartDacSchedule');
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

% Wait until schedule stops, or until a key is pressed.
fprintf('\nWaveform playback starting, press any key to abort.\n');
if (exist('OCTAVE_VERSION'))
    fflush(stdout);
end
while 1
    Datapixx('RegWrRd');   % Update registers for GetDacStatus
    status = Datapixx('GetDacStatus');
    if ~status.scheduleRunning
        break;
    end
    if KbCheck
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
