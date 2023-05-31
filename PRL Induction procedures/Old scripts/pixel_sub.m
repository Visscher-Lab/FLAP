%% chatgpt pixel substitution

% Clear the workspace and the screen
sca;
close all;
clearvars;

% Set up Psychtoolbox screen
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
gray = white / 2;
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, gray);

% Set up Gabor target parameters
gaborDimPix = 256;
sigma = gaborDimPix / 8;
orientation = 90;
contrast = 1;
aspectRatio = 1.0;
phase = 0;
freq = 3;
backgroundOffset = [0.5 0.5 0.5 0.0];

% Create Gabor target texture
gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, 0, backgroundOffset, contrast);
gaborrect = [0 0 gaborDimPix gaborDimPix];

% Set up pixel substitution parameters
numPixels = gaborDimPix * gaborDimPix;
numSubstitutedPixels = round(numPixels * 0.15); % 50% substitution
pixelsToSubstitute = randperm(numPixels, numSubstitutedPixels);

% Show Gabor target with pixel substitution
for i = 1:100
    % Draw Gabor target
    Screen('DrawTexture', window, gabortex, [], gaborrect, orientation, [], [], [], [], kPsychUseTextureMatrixForRotation);
    % Perform pixel substitution
    noise = randi([0 1], gaborDimPix, gaborDimPix) * 255;
    noise(pixelsToSubstitute) = randi([0 255], numSubstitutedPixels, 1);
    % Draw noise
    Screen('PutImage', window, noise, windowRect);
    % Flip the screen
    Screen('Flip', window);
end

% Wait for a key press
KbWait;

% Close the screen
sca;