function DatapixxDinBasicDemo()
% DatapixxDinBasicDemo()
%
% Demonstrates the basic functions of the DATAPixx TTL digital inputs.
% Prints the number of TTL inputs in the system,
% then logs button presses until user hits a key.
%
% Also see: DatapixxSimonGame
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

% Show how many TTL input bits are in the Datapixx
nBits = Datapixx('GetDinNumBits');
fprintf('\nDATAPixx has %d TTL input bits\n', nBits);

% RESPONSEPixx has 5 illuminated buttons.
% We drive those button lights by turning around 5 DIN bits to outputs.
% Test paradigms could illuminate only the buttons which are valid in context.
% (eg: 1 button when waiting for subject to initiate a trial,
% 2 other buttons when waiting for 2-alternative forced-choice response).
Datapixx('SetDinDataDirection', hex2dec('1F0000'));
Datapixx('SetDinDataOut', hex2dec('1F0000'));
Datapixx('SetDinDataOutStrength', 1);   % Set brightness of buttons

% We'll say that we want to calculate response times
% from a stimulus appearing at the next vertical sync.
Datapixx('SetMarker');
Datapixx('RegWrRdVideoSync');
stimulusOnsetTime = Datapixx('GetMarker');

% Fire up the logger
Datapixx('EnableDinDebounce');      % Filter out button bounce
%Datapixx('DisableDinDebounce');    % Uncomment this line to log gruesome details of button bounce
Datapixx('SetDinLog');              % Configure logging with default values
Datapixx('StartDinLog');
Datapixx('RegWrRd');

% Show initial state of all the digital input bits
fprintf('Initial digital input states = ');
initialValues = Datapixx('GetDinValues');
for bit = nBits-1:-1:0               % Easier to understand if we show in binary
    if (bitand(initialValues, 2^bit) > 0)
        fprintf('1');
    else
        fprintf('0');
    end
end
fprintf('\n');

% Report logged button activity until keyboard is pressed
fprintf('\nPlug button box into Digital IN db-25\n');
fprintf('Press buttons to see new log entries\n');
fprintf('Hit any key to stop...\n');
if (exist('OCTAVE_VERSION'))
    fflush(stdout);
end
while ~KbCheck
    Datapixx('RegWrRd');
    status = Datapixx('GetDinStatus');
    if (status.newLogFrames > 0)
        [data tt] = Datapixx('ReadDinLog');
        for i = 1:status.newLogFrames
            fprintf('responseTime = %f', tt(i)-stimulusOnsetTime);
            fprintf(', button states = ');
            for bit = 15:-1:0               % Easier to understand if we show in binary
                if (bitand(data(i), 2^bit) > 0)
                    fprintf('1');
                else
                    fprintf('0');
                end
            end
            fprintf('\n');
        end
        if (exist('OCTAVE_VERSION'))
            fflush(stdout);
        end
    end
end

% Show final status of digital input logger
fprintf('\nStatus information for digital input logger:\n');
disp(Datapixx('GetDinStatus'));

% Job done
Datapixx('StopDinLog');
Datapixx('RegWrRd');
Datapixx('Close');
fprintf('\n\nDemo completed\n\n');
