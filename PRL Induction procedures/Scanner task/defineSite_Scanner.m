%function [w, wRect]=defineSite(site)
Screen('Preference', 'SkipSyncTests', 1);
%PC=getComputerName();
AssertOpenGL;


if site==1  % Windows @UAB Lab
    screencm=[69.8, 40];
    v_d=70;
    screenNumber=max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
    PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
    oldResolution=Screen( 'Resolution',screenNumber,1920,1080);
    SetResolution(screenNumber, oldResolution);
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
    Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
    Screen('LoadNormalizedGammaTable',w,Nlinear_lut);
    baseName=['.\data\' SUBJECT '_FLAP_ScannerVPixx_PrePost' num2str(prepost) '_RunNum' num2str(runnumber) '_' TimeStart '.mat'];
elseif site==2 %Pinar's Mac
    screencm=[70.8, 39.8];
    v_d=123;
    AssertOpenGL;
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    screenNumber=max(Screen('Screens'));
    rand('twister', sum(100*clock));
    PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
    %[w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
    baseName=['./data/' SUBJECT '_FLAP_ScannerVPixx_PrePost' num2str(prepost) '_RunNum' num2str(runnumber) '_' TimeStart '.mat'];
elseif site==3 %Dell laptop- UAB
    screencm=[70.8, 39.8];
    v_d=123;
    AssertOpenGL;
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    screenNumber=max(Screen('Screens'));
    resolution=Screen('Resolution',screenNumber);
    cueloc=(resolution.height/2)+14;
    xloc=(resolution.height/2)+10;
    rand('twister', sum(100*clock));
    PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
    baseName=['.\data\' SUBJECT '_FLAP_ScannerVPixx_PrePost' num2str(prepost) '_RunNum' num2str(runnumber) '_' TimeStart '.mat'];
end
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
struct.sz=[screencm(1), screencm(2)];

% pixels per degree
pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi));
pix_deg_vert = pi * wRect(4) / atan(screencm(2)/v_d/2) / 360;


% monitor color indexes
white=WhiteIndex(screenNumber);
black=BlackIndex(screenNumber);
gray=round((white+black)/2);
if gray == white
    gray=white / 2;
end

theseed=sum(100*clock);
rand('twister',theseed );

% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
%% Sound
InitializePsychSound(1); %'optionally providing
% the 'reallyneedlowlatency' flag set to one to push really hard for low
% latency'.
if site==1
    pahandle1 = PsychPortAudio('Open', 1, 1, 1, 44100, 2);
    pahandle2 = PsychPortAudio('Open', 1, 1, 1, 44100, 2);
elseif site==2
    pahandle1 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    pahandle2 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
elseif site==3
    pahandle1 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
    pahandle2 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
end
try
    [errorS freq] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
    [corrS freq] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
end

PsychPortAudio('FillBuffer', pahandle1, corrS' ); % loads data into buffer
PsychPortAudio('FillBuffer', pahandle2, errorS'); % loads data into buffer
%% Trigger Setup
if site==2
    a                               = cd;
    if a(1)=='/' % mac or linux
        a                           = PsychHID('Devices');
        for i = 1:length(a)
            d(i)                    = strcmp(a(i).usageName, 'Keyboard');
        end
        keybs                       = find(d);
    else % windows
        keybs                       = [];
    end
    tChar = {'t'};
    rChar = {'r' 'g' 'b' 'y'};
end