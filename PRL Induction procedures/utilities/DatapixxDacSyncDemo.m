function DatapixxDacSyncDemo()
% DatapixxDacSyncDemo()
%
% Shows how to program DAC voltages in such a way that the updates are
% synchronized to either the video vertical sync pulse,
% or a specific pixel sequence in the stimulus.
%
% Also see: DatapixxDacBasicDemo, DatapixxDacWaveDemo, DatapixxDacWaveStreamDemo
%
% History:
%
% Oct 1, 2009  paa     Written
% Oct 29, 2014 dml     Revised 

AssertOpenGL;   % We use PTB-3

Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

try
    oldVerbosity = Screen('Preference', 'Verbosity', 1);   % Don't log the GL stuff
    screenNumber = max(Screen('Screens'));
    window = Screen('OpenWindow', screenNumber, 0, []);
    Screen('Preference', 'Verbosity', oldVerbosity);
    HideCursor;

    % Location of sync pixels
    syncRect1 = [0,   0, 1,   1];
    syncRect2 = [0, 100, 1, 101];
    syncRect3 = [0, 200, 1, 201];
    syncRect4 = [0, 300, 1, 301];

    % Colors of sync pixels we will draw into the frame buffer.
    syncPixel1 = [255,   0,   0];       % A red sync pixel
    syncPixel2 = [  0, 255,   0];       % A green sync pixel
    syncPixel3 = [  0,   0, 255];       % A blue sync pixel
    syncPixel4 = [255, 255, 255];       % A white sync pixel

    % PTB typically sets the display gamma to 1,
    % ensuring that the pixel colors we defined above are those which are really sent to the display.
    % We will do a test here just to see if the graphics board is doing some small manipulation
    % of the pixel values behind our backs.
    % If this is the case, we'll tell our pixelsync command to look for the _real_ values
    % being sent by the graphics board.
    Screen('FillRect', window, syncPixel1, syncRect1);
    Screen('Flip', window);
    realPixel1 = Datapixx('GetVideoLine', 1);
    Screen('FillRect', window, syncPixel2, syncRect1);
    Screen('Flip', window);
    realPixel2 = Datapixx('GetVideoLine', 1);
    Screen('FillRect', window, syncPixel3, syncRect1);
    Screen('Flip', window);
    realPixel3 = Datapixx('GetVideoLine', 1);
    Screen('FillRect', window, syncPixel4, syncRect1);
    Screen('Flip', window);
    realPixel4 = Datapixx('GetVideoLine', 1);
    if (realPixel1 ~= syncPixel1' |...
        realPixel2 ~= syncPixel2' |...
        realPixel3 ~= syncPixel3' |...
        realPixel4 ~= syncPixel4')
        fprintf('\n***Graphics board is transforming pixel data!***\n');
        fprintf('Pixel sync sequence is compensating\n');
    end

    fprintf('\nUpdating DAC0 output voltage synchronized with VSYNC and RGBW pixels\n');
    fprintf('Hit any key to terminate\n');
    if (exist('OCTAVE_VERSION'))
        fflush(stdout);
    end

    Screen('FillRect',window, [0 0 0]);         % Clear the display
    Screen('Flip', window);
    while 1
        Datapixx('SetDacVoltages', [0 -10]);    % New DAC voltage
        Datapixx('RegWrVideoSync');             % will update on next video vertical sync pulse
        Datapixx('SetDacVoltages', [0 -5]);     % This new DAC voltage
        Datapixx('RegWrPixelSync', realPixel1); % will update when this red pixel is displayed
        Datapixx('SetDacVoltages', [0 0]);      % Multiple pixelSync can occur in one video frame
        Datapixx('RegWrPixelSync', realPixel2);
        Datapixx('SetDacVoltages', [0 5]);
        Datapixx('RegWrPixelSync', realPixel3);
        Datapixx('SetDacVoltages', [0 10]);
        Datapixx('RegWrPixelSync', realPixel4);
        Screen('FillRect', window, syncPixel1, syncRect1);      % Now draw the pixelSync pixels
        Screen('FillRect', window, syncPixel2, syncRect2);
        Screen('FillRect', window, syncPixel3, syncRect3);
        Screen('FillRect', window, syncPixel4, syncRect4);
        Screen('Flip', window);                                 % Display the pixelSync pixels
        Screen('FillRect',window, [0 0 0]);                     % Erase the pixelSync pixels
        Screen('Flip', window);
        if (KbCheck)
            break;
        end
    end

    % Let's see if pixel sync timed out
    Datapixx('RegWrRd');
    disp(Datapixx('GetVideoStatus'));

    ShowCursor;
    Screen('CloseAll');
    Datapixx('Close');
catch
    ShowCursor;
    Screen('CloseAll');
    Datapixx('Close');
    psychrethrow(psychlasterror);
end;

 fprintf('\n\nDemo completed\n\n');
