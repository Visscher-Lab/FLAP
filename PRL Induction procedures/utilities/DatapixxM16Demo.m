function DatapixxM16Demo()
% DatapixxM16Demo()
%
% A demonstration of the DATAPixx M16 (16-bit monochrome) video mode using the PsychToolbox imaging pipeline.
%
% History:
%
% July 21, 2010  paa     Written
% Oct 29, 2014   dml     Revised

AssertOpenGL;
% Screen('Preference', 'SkipSyncTests', 1);

% Configure PsychToolbox imaging pipeline to use 32-bit floating point numbers.
% Our pipeline will also implement an inverse gamma mapping to correct for display gamma.
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
PsychImaging('AddTask', 'General', 'EnableDataPixxM16OutputWithOverlay');
PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');

% Open our window.
% We are assuming that the DATAPixx is connected to the highest number screen.
% If it isn't, then assign screenNumber explicitly here.
screenNumber=max(Screen('Screens'));
oldVerbosity = Screen('Preference', 'Verbosity', 1);   % Don't log the GL stuff
[win, winRect] = PsychImaging('OpenWindow', screenNumber);
Screen('Preference', 'Verbosity', oldVerbosity);
winWidth = RectWidth(winRect);
winHeight = RectHeight(winRect);

% Specify the window's inverse gamma value to be applied in the imaging pipeline
gamma = 2.2;
PsychColorCorrection('SetEncodingGamma', win, 1/gamma);

% Ensure that the graphics board's gamma table does not transform our pixels
Screen('LoadNormalizedGammaTable', win, linspace(0, 1, 256)' * [1, 1, 1]);

% define a 2D plaid with 100% contrast and 256 pixel period, with value in the range 0-1.
% Make a 32-bit floating point monochrome texture out of it.
[wx,wy] = meshgrid(1:winWidth, 1:winHeight);

plaidMatrix = (sin(wx*pi/128) + sin(wy*pi/128)) / 4 + 0.5;
plaidTexture = Screen('MakeTexture', win, plaidMatrix, [], [], 2);

% Draw the floating point texture.
% Specify filter mode = 0 (nearest neighbour), to ensure that GL doesn't interpolate pixel values.
Screen('DrawTexture', win, plaidTexture, [], [], [], 0);

% DATAPixx overlay window can hold a seperate 255-colour image.  We'll use a blue ramp.
overlay = PsychImaging('GetOverlayWindow', win);
% Screen('LoadNormalizedGammaTable', win, linspace(0, 1, 256)' * [0, 0, 1], 2);

% We'll arbitrarily use full green as a CLUT's "transparent" color
transparencyColor = [0, 1, 0];
Datapixx('Open');
Datapixx('SetVideoClutTransparencyColor', transparencyColor);
Datapixx('EnableVideoClutTransparencyColorMode');
Datapixx('RegWr');

% On some systems (Win?) LoadNormalizedGammaTable doesn't support 512 CLUT entries,
% so we'll use our own CLUT load function.
clutTestDisplay = repmat(transparencyColor, [256,1]);   % By default, all overlays are transparent
clutConsoleDisplay = repmat(transparencyColor, [256,1]);   % By default, all overlays are transparent

% ! ON WINDOWS, DrawFormattedText scales the color by 255/256, therefore
% the color is off by 1 for the upper half of the CLUT 
% On OS-X, DrawFormattedText seems to apply a grossly non-linear mapping
% between the argument intensity and the actual draw intensity.
% Other draw commands like DrawRect do not seem to show this bug.
% For the purposes of this demo, we will draw the text in the center of a
% 5-colour span, at the top of the 256-entry CLUT.
% This seems to work for all systems tested so far.
clutTestDisplay(242:246,:) = repmat([1, 0, 0], [5,1]);   % Items drawn with 255 show on test display as blue % FOR MAC
clutTestDisplay(252:256,:) = repmat([0, 0, 1], [5,1]);   % Items drawn with 255 show on test display as blue % FOR MAC

clutConsoleDisplay(247:251,:) = repmat([1, 1, 0], [5,1]);   % Items drawn with 255 show on test display as blue % FOR MAC
clutConsoleDisplay(252:256,:) = repmat([0, 0, 1], [5,1]);   % Items drawn with 255 show on test display as blue % FOR MAC

Datapixx('SetVideoClut', [clutTestDisplay;clutConsoleDisplay]);

% Draw some text onto overlay window
Screen('FillRect', overlay, 0);
Screen('TextSize', overlay, 36);
Screen('Preference', 'TextAntiAliasing', 0);    % Overlay looks best w/o antialiasing
%DrawFormattedText(overlay, 'Test Display', 'center', 40, 252);      % Overlay only visible on test display
%DrawFormattedText(overlay, 'Console Display', 'center', 80, 253);   % Overlay only visible on console display
%DrawFormattedText(overlay, 'DATAPixx 16-bit monochrome demo\nHit any key to exit.', 'center', 'center', 255);

DrawFormattedText(overlay, 'Test Display', 'center', 40, 243);      % Overlay only visible on test display
DrawFormattedText(overlay, 'Console Display', 'center', 80, 248);   % Overlay only visible on console display
DrawFormattedText(overlay, 'DATAPixx 16-bit monochrome demo\nHit any key to exit.', 'center', 'center', 253);

% Show resulting image, wait for keystroke, then terminate demo
Screen('Flip', win);
KbStrokeWait;
RestoreCluts;       % Restore any system gamma tables we modified
Datapixx('DisableVideoClutTransparencyColorMode');
Datapixx('RegWr');
Screen('CloseAll');
return;
