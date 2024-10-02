function DatapixxTscopeDemo()
% DatapixxTscopeDemo()
%
% Shows how to use a digital output schedule to generate a tachistoscope stimulus
% by pulsing a VIEWPixx backlight.
%
% History:
%
% June 5, 2013  paa     Written
% Nov  3, 2014  dml     Revised

AssertOpenGL;   % We use PTB-3

Datapixx('Open');
Datapixx('SelectDevice', 4); % Selects the VIEWPixx for this.
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');    % Synchronize Datapixx registers to local register cache
startupVideoStatus =  Datapixx('GetVideoStatus');

% Begin by enabling the backlight pulse mode, and turning off the backlight
Datapixx('EnableDoutBacklightPulse');       % Now DOUT15 enables/disables backlight
Datapixx('SetDoutValues', 0);               % Set DOUT15 to 0, so backlight is off
Datapixx('DisableVideoScanningBacklight');  % So there is no interaction with scanning backlight
Datapixx('RegWrRd');

% Insert image generation code here.
% The VIEWPixx liquid crystal will be loaded with the generated image,
% but the display will remain perfectly black because the backlight is off.
% For the purpose of this demo, we'll just leave the existing desktop image.
% We'll show this black display for 1 second.
WaitSecs(1);

% Now run a DOUT schedule which drives DOUT15 high for 500 microseconds, then brings it back down.
% The image on the LCD will be flashed for exactly 500 microseconds.
% Any arbitrary multi-flash waveform could be programmed here, with microsecond precision.
doutWave = [0 32768 0];     % DOUT15 starts low, goes high, then back low
waveSamplePeriod = 0.0005;  % doutWave sampled every 500 microseconds
bufferAddress = 8e6;
Datapixx('WriteDoutBuffer', doutWave, bufferAddress);
samplesPerWave = size(doutWave,2);
Datapixx('SetDoutSchedule', 0, [waveSamplePeriod, 3], samplesPerWave, bufferAddress);
Datapixx('StartDoutSchedule');
Datapixx('RegWrRd');

% Wait here until DOUT tachistoscope schedule has run to completion
while 1
    Datapixx('RegWrRd');   % Update registers for GetDoutStatus
    status = Datapixx('GetDoutStatus');
    if ~status.scheduleRunning
        break;
    end
end

% Leave display black for another second, then restore screen
WaitSecs(1);
Datapixx('DisableDoutBacklightPulse');       % Now DOUT15 enables/disables backlight
if (startupVideoStatus.scanningBacklight)
    Datapixx('EnableVideoScanningBacklight');
end
Datapixx('RegWrRd');
Datapixx('SelectDevice', -1); % Back to the default behavior.
% Job done
Datapixx('Close');
fprintf('\nDemo completed\n\n');
