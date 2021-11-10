function DatapixxGazeContingentDemo(mode)
% DatapixxGazeContingentDemo(mode)
%
% A simple gaze-contingent display using DATAPixx.
% The DATAPixx is able to treat the left/right halves of a video image as two
% independent background/foreground images which should be combined, or blended.
% The region over which the two images should be combined is the overlay bounds.
% The function which combines the two images is the overlay gamma.
% When a new overlay bounds is sent to the DATAPixx, the output image updates
% immediately, which improves the gaze-contingent latency by up to one full
% refresh period!
%
% This demo uses mouse position to simulate eye position.
%
% Optional argument:
%
% value of mode indicates how to combine images:
%   1) Scotoma mode: shows a black gaussian overlaying cute rabbits
%   2) Blur mode:    shows blurred rabbits overlaying cute rabbits
%
% History:
%
% Apr 19, 2010  paa     Written
% Oct 29, 2014  dml     Revised

AssertOpenGL;

if nargin < 1
    mode = [];
end
if isempty(mode)
    mode = 1;
end


try
    % We are assuming that the DATAPixx is connected to the highest number screen.
    % If it isn't, then assign screenNumber explicitly here.
    screenNumber=max(Screen('Screens'));
    [w, wRect]=Screen('OpenWindow',screenNumber);

    % Put my startup text here, so that it shows up after the PTB Screen init messages
    fprintf('\nDATAPixx Gaze Contingent Demo\n');
    fprintf('Moving mouse will move \"gaze contingent\" overlay\n');
    fprintf('Press a key to stop demo.\n');
    if (exist('OCTAVE_VERSION'))
        fflush(stdout);
    end;
    while KbCheck; WaitSecs(0.1); end;

    % The background image is drawn onto the left half of the display.
    % For all modes, we'll draw cute furry rabbits as the background image.
    leftrect = [wRect(1) wRect(2) wRect(3)/2 wRect(4)];
    rabbitfile= [PsychtoolboxRoot 'PsychDemos' filesep 'konijntjes1024x768.jpg'];
    rabbitdata=imread(rabbitfile);
    rabbittexture=Screen('MakeTexture', w, rabbitdata);
    Screen('DrawTexture', w, rabbittexture, [], leftrect);

    % The forground (or "overlay") image is drawn onto the right half of the display.
    rightrect = [wRect(3)/2 wRect(2) wRect(3) wRect(4)];

    switch (mode)
        case 1  % Scotoma mode overlays a black spot onto rabbits
            Screen('FillRect', w, BlackIndex(screenNumber), rightrect);
        case 2  % Blur mode overlays fuzzy rabbits onto furry rabbits :-)
            blurryrabbitfile= [PsychtoolboxRoot 'PsychDemos' filesep 'konijntjes1024x768blur.jpg'];
            blurryrabbitdata=imread(blurryrabbitfile);
            blurryrabbittexture=Screen('MakeTexture', w, blurryrabbitdata);
            Screen('DrawTexture', w, blurryrabbittexture, [], rightrect);
        otherwise
            fprintf('Invalid mode provided!');
            toast
    end;
    Screen('Flip', w);

    % Enable DATAPixx overlay mode
    Datapixx('Open');
    Datapixx('EnableVideoHorizontalOverlay');
    
    % Specify a gaussian alpha function which combines the left/right images.
    % Independent X/Y functions are multiplied together at each pixel,
    % thus allowing us to generate any separable 2D function.
    % The maximum size of the alpha function is 512x512 pixels.
    % If we detect a "wide" resolution (eg: 2048x768),
    % we'll assume that the user has chosen a custom video mode
    % with a 2x horizontal resolution, in order to maintain square pixels;
    % otherwise, assume a "standard" resolution (eg: 1024x768),
    % in which case pixels will be stretched.
    xsd = 40;
    ysd = xsd;  % Assume custom wide resolution (eg: 2048x768) resulting in square pixels.
    if (wRect(3)/2 < wRect(4))  % Not a wide resolution
       xsd = xsd / 2;           % so adapt to stretched pixels
    end;
    Datapixx('SetVideoHorizontalOverlayAlpha', [exp(-((([0:511]-256)/xsd).^2)) exp(-((([0:511]-256)/ysd).^2))]);
    
    % start mouse off in center of left field
    [a,b]=RectCenter(leftrect);
    SetMouse(a,b,screenNumber); % set cursor and wait for it to take effect
    HideCursor;

    % Update location of overlay.
    % Note that the current location of the video raster will immediately show the updated overlay,
    % so it is beneficial to iterate through this loop as quickly as we can get new mouse (or eye) positions!
    while ~(KbCheck);
        [mx, my, buttons]=GetMouse(screenNumber);
        overlayBounds = [mx-256 my-256 mx+256 my+256];
        Datapixx('SetVideoHorizontalOverlayBounds', overlayBounds);
        Datapixx('RegWrRd');
        WaitSecs(0.001);
    end;
    
    % Close up shop
    Datapixx('DisableVideoHorizontalOverlay');
    Datapixx('RegWrRd');
    Datapixx('Close');
    Screen('CloseAll');
    ShowCursor;
	return;
catch
    if (Datapixx('IsReady'))
        Datapixx('DisableVideoHorizontalOverlay');
        Datapixx('RegWrRd');
        Datapixx('Close');
    end;
    Screen('CloseAll');
    ShowCursor;
    psychrethrow(psychlasterror);
end
