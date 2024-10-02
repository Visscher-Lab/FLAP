function DatapixxDacBasicDemo()
% DatapixxDacBasicDemo()
%
% Demonstrates basic function of the DATAPixx digital to analogue converters.
% Prints the output voltage range of all channels, then waits for keypresses to
% set all channels to their minimum, then maximum, then 0V settings.
%
% Also see: DatapixxDacWaveDemo, DatapixxDacWaveStreamDemo, DatapixxDacWaveDemo
%
% History:
%
% Oct 1, 2009  paa     Written
% Oct 29, 2014 dml     Revised 

AssertOpenGL;   % We use PTB-3

% Open Datapixx, and stop any schedules which might already be running
Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

% Show how many DAC channels are in the Datapixx
nChannels = Datapixx('GetDacNumChannels');
fprintf('\nDATAPixx has %d DAC channels\n\n', nChannels);

% Show the output voltage range for each DAC channel
dacRanges = Datapixx('GetDacRanges');
for channel = 0:nChannels-1
    fprintf('Channel %d output range is %g to %g Volts\n',...
        channel, dacRanges(1, channel+1), dacRanges(2, channel+1));
end

HitKeyToContinue('\nHit any key to set all channels to their minimum output voltages:');
for channel = 0:nChannels-1
    channelVoltages(1,channel+1) = channel;
    channelVoltages(2,channel+1) = dacRanges(1, channel+1);
end
Datapixx('SetDacVoltages', channelVoltages);
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

HitKeyToContinue('\nHit any key to set all channels to their maximum output voltages:');
for channel = 0:nChannels-1
    channelVoltages(2,channel+1) = dacRanges(2, channel+1);
end
Datapixx('SetDacVoltages', channelVoltages);
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

HitKeyToContinue('\nHit any key to set all channels to 0 Volts:');
for channel = 0:nChannels-1
    channelVoltages(2,channel+1) = 0;
end
Datapixx('SetDacVoltages', channelVoltages);
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

% Job done
Datapixx('Close');
fprintf('\n\nDemo completed\n\n');
