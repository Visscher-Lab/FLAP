function DatapixxAdcBasicDemo(internalLoopback)
% DatapixxAdcBasicDemo([internalLoopback=1])
%
% Demonstrates the basic functions of the Datapixx analog to digital converters.
% Prints the input voltage range, and current input voltage, for all channels.
%
% Optional argument:
%
% internalLoopback = 1 if DAC outputs should be internally looped back to ADC inputs
%                  Otherwise the ADC converts the actual voltages on the db-25 pins
%
% Also see: DatapixxAdcAcquireDemo, DatapixxAdcStreamDemo
%
% History:
%
% Oct 1, 2009  paa     Written
% Oct 29, 2014 dml     Revised 

AssertOpenGL;   % We use PTB-3

% Get internal loopback argument
if nargin < 1
    internalLoopback = [];
end
if isempty(internalLoopback)
    internalLoopback = 1;
end

% Open Datapixx, and stop any schedules which might already be running
Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');    % Synchronize Datapixx registers to local register cache

% DAC outputs can be looped back to ADC inputs inside the DATAPixx.
% There are 4 DAC channels, and 16 ADC channels, plus 2 ADC reference channels,
% so the internal loopback maps DAC outputs to multiple ADC inputs:
%   DAC0 => ADC0/2/4/6/8/10/12/14
%   DAC1 => ADC1/3/5/7/9/11/13/15
%   DAC2 => REF0
%   DAC3 => REF1
% Even if we are not doing an internal loopback, we'll still program the DAC outputs.
% This allows us to do an _external_ loopback;
% ie: wire the DAC outputs to the ADC inputs right on the db-25 connector.
% We'll arbitrarily program the 4 DAC channels to 5V, 2.5V, -2.5V, -5V
if (internalLoopback == 1)
    Datapixx('EnableDacAdcLoopback');   % We'll read back what's on the DAC outputs
else
    Datapixx('DisableDacAdcLoopback');  % We'll read what's really on the input db-25
end
Datapixx('SetDacVoltages', [0:3 ; 5 2.5 -2.5 -5]);
Datapixx('EnableAdcFreeRunning');       % ADC's convert continuously
Datapixx('RegWrRd');    % Write local register cache to hardware
Datapixx('RegWrRd');    % Give time for ADCs to convert, then read back data to local cache

% Show how many ADC channels are in the Datapixx
nChannels = Datapixx('GetAdcNumChannels');
fprintf('\nDatapixx has %d ADC channels\n\n', nChannels);

% Show the input voltage range, and current value, for each ADC channel
adcRanges = Datapixx('GetAdcRanges');
adcDataVoltages = Datapixx('GetAdcVoltages');
for channel = 0:nChannels-1
    fprintf('Channel %d input range is %g to %g Volts, current value is %g Volts\n',...
        channel, adcRanges(1, channel+1), adcRanges(2, channel+1), adcDataVoltages(channel+1));
end

% Job done
Datapixx('Close');
fprintf('\n\nDemo completed\n\n');
