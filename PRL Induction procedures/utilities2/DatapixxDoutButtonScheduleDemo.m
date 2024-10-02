function DatapixxDoutButtonScheduleDemo()
% DatapixxDoutButtonScheduleDemo()
%
% Demonstrates the use of automatic digital output schedules when user presses digital input buttons.
%
% History:
%
% Apr 30, 2012  paa     Written
% Oct 29, 2014  dml     Revised
% Mar 26, 2020  dml		Updated

AssertOpenGL;   % We use PTB-3

% Open Datapixx, and stop any schedules which might already be running
Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

% Upload some arbitrary digital output waveforms for the first 5 button
% inputs.  Note that the digital output waveforms must be stored at 4kB
% increments from the DOUT buffer base address.
% Also note that the last value in the digital output waveform will be
% almost immediately replaced with the original contents of the digital
% output port when the schedule terminates.

% The mode can be:
% 0 -- The schedules starts on a raising edge (normal behavior)
% 1 -- The schedules starts on a falling edge (normal behavior)
% 2 -- The schedules starts on a raising and on a falling edge (double-edge behavior)
% Please note that for the mode 2 we only set up the Din0 and Din1 in this demo.
% For mode 0 and 1, you put the schedule at baseAddr + 4096*DinValue
% For mode 2, you put the schedule of a push at baseAddr + 4096*DinValue + 2048*DinValue and a release at baseAddr + 4096*DinValue + 2048

doutBufferBaseAddr = 0;
doutButtonSchedulesMode  = 2;


doutWaveform = [ 1, 1, 0, 0, 0, 1, 1, 0];
Datapixx('WriteDoutBuffer', doutWaveform, doutBufferBaseAddr + 4096*0+2048*0); % RESPONSEPixx RED/Din0 Push 

if doutButtonSchedulesMode == 2
doutWaveform = [ 2, 2, 0, 0, 0, 2, 2, 0];
Datapixx('WriteDoutBuffer', doutWaveform, doutBufferBaseAddr + 4096*0+2048*1); % RESPONSEPixx RED/Din0 Release
end

doutWaveform = [ 3, 3, 0, 0, 0, 3, 3, 0];
Datapixx('WriteDoutBuffer', doutWaveform, doutBufferBaseAddr + 4096*1+2048*0); % RESPONSEPixx Yellow/Din1 Push

if doutButtonSchedulesMode == 2
doutWaveform = [ 1, 2, 1, 2, 0, 0, 0, 0];
Datapixx('WriteDoutBuffer', doutWaveform, doutBufferBaseAddr + 4096*1+2048*1); % RESPONSEPixx Yellow/Din1 Release
end

doutWaveform = [ 0, 0, 0, 0, 0, 1, 1, 1];
Datapixx('WriteDoutBuffer', doutWaveform, doutBufferBaseAddr + 4096*2); % RESPONSEPixx Green/Din2

doutWaveform = [ 0, 0, 0, 0, 1, 1, 1, 1];
Datapixx('WriteDoutBuffer', doutWaveform, doutBufferBaseAddr + 4096*3); % RESPONSEPixx Blue/Din3

doutWaveform = [ 0, 0, 0, 1, 1, 1, 1, 1];
Datapixx('WriteDoutBuffer', doutWaveform, doutBufferBaseAddr + 4096*4); % RESPONSEPixx White/Din4

Datapixx('SetDoutSchedule', 0, 1000, 9, doutBufferBaseAddr); 
% NOTE THE 9 instead of 8, this fixes the problem mentioned above.
Datapixx('SetDinDataDirection', 0);
Datapixx('EnableDinDebounce');      % Filter out button bounce
Datapixx('EnableDoutButtonSchedules', 2); % This starts the schedules
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache
Datapixx('Close');
fprintf('\n\nAutomatic buttons schedules running\n\n');


