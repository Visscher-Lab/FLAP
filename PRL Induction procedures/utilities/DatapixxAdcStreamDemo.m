function DatapixxAdcStreamDemo()
% DatapixxAdcStreamDemo()
%
% Demonstrates how to continuously acquire streaming ADC data from the DATAPixx.
% For demonstration purposes we use the DAC0/1 outputs to generate waveforms,
% which we then acquire on ADC0/1 using internal loopback between DACs and ADCs.
% We'll also plot the last 100 ms of acquired data.
%
% Also see: DatapixxAdcBasicDemo, DatapixxAdcAcquireDemo
%
% History:
%
% Oct 1, 2009  paa     Written
% Oct 29, 2014 dml     Revised 

AssertOpenGL;   % We use PTB-3

Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

% Fill up a DAC buffer with 2 channels of 1000 samples of sin/cos functions.
% We'll generate a single period of the waveforms, and play them repeatedly.
nDacSamples = 1000;
dacData = [sin([0:nDacSamples-1]/nDacSamples*2*pi) ; cos([0:nDacSamples-1]/nDacSamples*2*pi)];
Datapixx('WriteDacBuffer', dacData);

% Play the downloaded DAC waveform buffers continuously at 100 kSPS,
% resulting in 100 Hz sin/cos waves being output onto DAC0/1.
dacRate = 1e5;
dacBuffBaseAddr = 0;
Datapixx('SetDacSchedule', 0, dacRate, 0, [0 1], dacBuffBaseAddr, nDacSamples);
Datapixx('StartDacSchedule');
Datapixx('RegWrRd');

% Start acquiring ADC data.
% This streaming demo stores collected ADC data in a 1 second circular buffer within the DATAPixx.
% This circular buffer is then uploaded to a large local matrix at regular intervals.
adcRate = 10000;                            % Acquire ADC data at 10 kSPS
nAdcLocalBuffFrames = adcRate*100;          % Preallocate a local buffer for 100 seconds of data
adcDataset = zeros(2, nAdcLocalBuffFrames); % We'll acquire 2 ADC channels into 2 matrix rows
nAdcBuffFrames = adcRate;                   % Streaming will use 1 second circular buffer in DATAPixx
adcBuffBaseAddr = 4e6;                      % DATAPixx internal buffer address
minStreamFrames = floor(adcRate / 100);     % Limit streaming reads to 100 times per second
Datapixx('SetAdcSchedule', 0, adcRate, 0, [0 1], adcBuffBaseAddr, nAdcBuffFrames);
Datapixx('EnableDacAdcLoopback');           % Replace this with DisableDacAdcLoopback to collect real data
Datapixx('DisableAdcFreeRunning');          % For microsecond-precise sample windows
Datapixx('StartAdcSchedule');
Datapixx('RegWrRd');                        % This will cause the acquisition to start

% Continuously acquire ADC data until we've filled our local buffer,
% or until a key is pressed.
fprintf('\nADC acquisition started, press any key to stop.\n');
if (exist('OCTAVE_VERSION'))
    fflush(stdout);
end
nAcquiredFrames = 0;
while (nAcquiredFrames < nAdcLocalBuffFrames)
    if (KbCheck)    % A keypress will immediately abort the acquisition
        break;
    end

    % How much data is available to read?
    Datapixx('RegWrRd');                    % Update registers for GetAdcStatus
    status = Datapixx('GetAdcStatus');
    nReadFrames = status.newBufferFrames;   % How many frames can we read?

    % It's not really necessary to limit the dataset to its preallocated size,
    % but we'll do it anyways, just for elegance.
    if (nReadFrames > nAdcLocalBuffFrames - nAcquiredFrames)
        nReadFrames = nAdcLocalBuffFrames - nAcquiredFrames;
        
    % Do not waste CPU time doing millions of tiny buffer reads    
    elseif (nReadFrames < minStreamFrames)
        continue;
    end
    
    % Upload the acquired ADC data
    adcDataset(:, nAcquiredFrames+1: nAcquiredFrames+nReadFrames) = Datapixx('ReadAdcBuffer', nReadFrames, -1);
    nAcquiredFrames = nAcquiredFrames + nReadFrames;
end

% Stop the DAC and ADC schedules, and show ADC status
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');
fprintf('\nStatus information for ADC scheduler:\n');
disp(Datapixx('GetAdcStatus'));

% OK, the dog caught the car.  Now what do we do with it?
% We'll plot the last 100 milliseconds of data.
fprintf('\nAcquired %d data\nPlotting last 100ms of data\n', nAcquiredFrames);
startPlotFrame = nAcquiredFrames - floor(adcRate/10);
if (startPlotFrame < 1)
    startPlotFrame = 1;
end
plot(startPlotFrame:nAcquiredFrames, adcDataset(:,startPlotFrame:nAcquiredFrames)');

% Job done
Datapixx('Close');
fprintf('\nDemo completed\n\n');
