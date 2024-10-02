function PROPixxGCDDemo()
% PROPixxGCDDemo()
%
% Loads images in the PROPixx memory and display them depending on the
% digital inputs or analogue inputs and other parameters.
%
% History:
%
% Aug 25, 2016  dml     Written
% Mar 20, 2018	dml		Revised

AssertOpenGL;   % We use PTB-3

Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');    % Synchronize Datapixx registers to local register cache

Datapixx('SelectDevice', 6);
firmwareRev = Datapixx('GetFirmwareRev');
Datapixx('SelectDevice', -1);
if (firmwareRev < 34)
    fprintf('\n***This Demo requires a PROPixx DLP Revision 34+.\n');
    Datapixx('Close');
    return;
end

WaitSecs(1);

screenid = max(Screen('Screens'));
[win win_rect] = PsychImaging('OpenWindow', screenid, 128);
Screen('Flip', win); % Start by emptying the screen
TextSize=Screen('TextSize', win, 418/2);
xo = 250;
yo = 150;
% 1- FILL IN THE DRAM

Datapixx('EnablePropixxSoftwareTestPatternLoad'); % Enable the filling of the ram 
for i=0:4:508
    Datapixx('SetPropixxSoftwareTestPatternLoadPage', i / 4); % Change page before we present
    Datapixx('RegWr');    % Change the page before we change the pattern
    for j=0:3
        Screen('DrawText', win, num2str(i), win_rect(1)+xo, win_rect(2)+yo, [255 255 255]);
        Screen('DrawText', win, num2str(i+1), win_rect(3)/2+xo, win_rect(2)+yo, [255 255 255]);
        Screen('DrawText', win, num2str(i+2), win_rect(1)+xo, win_rect(4)/2+yo, [255 255 255]);
        Screen('DrawText', win, num2str(i+3), win_rect(3)/2+xo, win_rect(4)/2+yo, [255 255 255]);
        Screen('Flip', win);
    end
end
Screen('Flip', win);
Datapixx('DisablePropixxSoftwareTestPatternLoad'); % Done filling the ram 

% 2- Create a schedule + internal loopback for testing purposes
Datapixx('RegWr');
dac_data = [-1.25 -1.25; -1.25 1.25; 1.25 1.25; 1.25 -1.25]';
Datapixx('WriteDacBuffer', dac_data, 0);
Datapixx('SetDacSchedule', 0, 4, 0, [0:1], 0, 4);
Datapixx('EnableDacAdcLoopback');
Datapixx('EnableAdcFreeRunning');
Datapixx('StartDacSchedule');
Datapixx('RegWrRd');

% 3- Set-up the PPx Ctrl to be in hardware bridge mode, sending ADC to PPx

Datapixx('GetPropixxLedCurrent', 0), Datapixx('GetPropixxLedCurrent', 1), Datapixx('GetPropixxLedCurrent', 2)
Datapixx('EnableGcdShiftHardwareBridge');
Datapixx('SetGcdShiftHardwareMode', 1);
Datapixx('SetGcdShiftHardwareTransform', 512, 100, 512, 50);
Datapixx('RegWrRd');

% 4- Set-up the special propixx program
program2 = zeros(1024,2);
for l=0:1023
    frame = mod(l, 32);
    program2(l+1, 1) = floor(frame/4)*256+mod(frame,4);
    
end
program2(1024, 1) = 0;
program2(:, 2) = 60;
Datapixx('SetPropixxTScopeProgram', program2); 
Datapixx('RegWrRd');


% 5- Set up the scope schedule
Datapixx('SetPropixxTScopeSchedule', 0, 120, 0, 1, 2);
Datapixx('StartPropixxTScopeSchedule');
Datapixx('RegWrRd');


Datapixx('SetPropixxTScopeProgramAddress', 0);
Datapixx('SetPropixxTScopeProgramOffsetPage', 0);
Datapixx('SetPropixxTScopeMode', 2);

if (firmwareRev < 38)
    % Bug before revision 38 that requires TScope to be in mode 0 before
    % being enabled.
    Datapixx('SetPropixxTScopeMode', 0); 
end
Datapixx('EnablePropixxTScope'); % Tscope to subject doesnt some stimuli
Datapixx('RegWrRd');

if (firmwareRev < 38)
    % Bug before revision 38 that requires TScope to be in mode 0 before
    % being enabled.
    Datapixx('SetPropixxTScopeMode', 2); 
end

% 6-Set up the proper new gaze contigent modes

Datapixx('EnablePropixxTScopeQuad');
Datapixx('EnablePropixxGcdShift');
Datapixx('EnablePropixxGcdShiftSubframe');
Datapixx('EnablePropixxGcdShiftHardware');
Datapixx('RegWrRd');


% 7 - Offset changing
offset = 0;

while 1
    
    % If a is pressed, decrement offset (-8) (min: 0);
    % If s is pressed, increment offset (+8) (max: 120);
    [pressed dummy keyCode] = KbCheck;

    if KbName(keyCode) == 'q'
            break;
    end
    
    if KbName(keyCode) == 'a'
        offset = offset - 8;
        fprintf('Decreasing offset %d', offset*256);
    end
    
    if KbName(keyCode) == 's'
        offset = offset + 8;
        fprintf('Increasing offset %d\n', offset*256);
    end
    if offset >= 128
        offset = 120;
    end
    if offset < 0
        offset = 0;
    end
    Datapixx('SetPropixxTScopeProgramOffsetPage', offset*256);
    Datapixx('RegWrRd');
    
    while pressed
        [pressed dummy keyCode] = KbCheck;
    end
    
end


% 8- Disable everything

Datapixx('DisableDacAdcLoopback');
Datapixx('DisableAdcFreeRunning');

Datapixx('DisablePropixxTScope');
Datapixx('DisablePropixxTScopeQuad');
Datapixx('StopPropixxTScopeSchedule');
Datapixx('RegWrRd');

Datapixx('DisablePropixxGcdShift');
Datapixx('DisablePropixxGcdShiftSubframe');
Datapixx('RegWrRd');
Datapixx('DisableGcdShiftHardwareBridge');
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');

sca;
Datapixx('Close');
fprintf('\nDemo completed\n\n');


