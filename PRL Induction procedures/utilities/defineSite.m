%function [w, wRect]=defineSite(site)
%Screen('Preference', 'SkipSyncTests', 1);
PC=getComputerName();
AssertOpenGL;

if site==0  %UCR bits++
    %% psychtoobox settings
    screencm=[40.6 30];
    load gamma197sec;
    v_d=110; %viewing distance
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    screenNumber=max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
    PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
    PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
    PsychImaging('AddTask', 'FinalFormatting','DisplayColorCorrection','LookupTable');
    PsychColorCorrection('SetLookupTable', window, lookup);
    oldResolution=Screen( 'Resolution',screenNumber,1280,960);
    SetResolution(screenNumber, oldResolution);
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
    
elseif site==1  % UCR + bits
    crt=0; % if we use a CRT monitor
    
    %% psychtoobox settings
    if crt==1
        v_d=70; %viewing distance
        screenNumber=max(Screen('Screens'));
        PsychImaging('PrepareConfiguration');
        % PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
        oldResolution=Screen( 'Resolution',screenNumber,1280,1024);
        SetResolution(screenNumber, oldResolution);
        [w, wRect]=PsychImaging('OpenWindow',screenNumber, 0,[],32,2);
        screencm=[40.6 30];
        %debug window
        %    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
        %ScreenParameters=Screen('Resolution', screenNumber); %close all
        Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
    else
        screencm=[69.8, 40];
        v_d=70; %viewing distance
        oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
        screenNumber=max(Screen('Screens'));
        PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
        PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
        PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
        %     PsychImaging('AddTask', 'FinalFormatting','DisplayColorCorrection','LookupTable');
        %     oldResolution=Screen( 'Resolution',screenNumber,1920,1080);
        %     SetResolution(screenNumber, oldResolution);
        [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
    end
    
elseif site==2   %UAB
    s1=serial('com3');
    fopen(s1);
    fprintf(s1, ['$monoPlusPlus' 13])
    fclose(s1);
    clear s1;
    screencm=[69.8, 40];
    v_d=70; %viewing distance
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    screenNumber=max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
    PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
    oldResolution=Screen( 'Resolution',screenNumber,1920,1080);
    SetResolution(screenNumber, oldResolution);
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
    fixationlengthy=10;
    fixationlengthx=10;
elseif site==3   %UCR VPixx
    %% psychtoobox settings
    screenNumber=max(Screen('Screens'));
%     screenNumber=min(Screen('Screens'));
    if EyeTracker==1
        initRequired= calibration; %do we want vpixx calibration?
        if initRequired>0
            fprintf('\nInitialization required\n\nCalibrating the device...');
            %TPxTrackpixx3CalibrationTesting;
            TPxTrackpixx3CalibrationTestingMM(baseName, screenNumber)
        end
        
        %Connect to TRACKPixx3
        Datapixx('Open');
        Datapixx('SetTPxAwake');
        Datapixx('RegWrRd');
    end
   v_d=70; % viewing distance
    
    PsychImaging('PrepareConfiguration');
    %         PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
    PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
    %
   % oldResolution=Screen('Resolution',screenNumber,1920,1080);
    %SetResolution(screenNumber, oldResolution);
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
    
    screencm=[69.8, 40];
    %debug window
    %    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
    %ScreenParameters=Screen('Resolution', screenNumber); %close all
    Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
    Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
 elseif site==4   %padova eyelink
    %% psychtoobox settings

    v_d=70; % viewing distance
    screenNumber=max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');
    %         PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
    PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
    %
    oldResolution=Screen('Resolution',screenNumber,1920,1080);
    SetResolution(screenNumber, oldResolution);
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
    
    screencm=[69.8, 40];
    %debug window
    %    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
    %ScreenParameters=Screen('Resolution', screenNumber); %close all
    Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
    Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT  
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
ifi = Screen('GetFlipInterval', w); %refresh rate
% if ifi==0
%     ifi=1/120;
% end

%end

% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
%% Sound
InitializePsychSound(1); %'optionally providing
% the 'reallyneedlowlatency' flag set to one to push really hard for low
% latency'.
%   pahandle = PsychPortAudio('Open', [], 1, 0, 44100, 2);
% if site<3
%     pahandle1 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
%     pahandle2 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
% elseif site==3 % Windows
%     pahandle = PsychPortAudio('Open', 1, 1, 1, 44100, 2);
% %    pahandle2 = PsychPortAudio('Open', 1, 1, 1, 44100, 2);
% end
pahandle = PsychPortAudio('Open', 1, 1, 1, 44100, 2);
% feedback sounds
try
    [errorS freq] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
    [corrS freq] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
end

%pure tone sound (beef) if needed
bip_dur=0.15;
Fs = 44100;                                     % Sampling Frequency
t = (0:1/Fs:bip_dur-1/Fs);
wv = 2*pi*500;                                  % Radian Value To Create 1kHz Tone
s = sin(wv*t);                                   % Create Tone
bip_sound=[s' s'];
bip_sound_left= [s' zeros(length(bip_sound)',1)];
bip_sound_right= [zeros(length(bip_sound)',1) s'];
% pahandle2 = PsychPortAudio('Open', 1, 1, 1, 44100, 2);
% PsychPortAudio('FillBuffer', pahandle1, corrS' ); % loads data into buffer
% PsychPortAudio('FillBuffer', pahandle2, errorS'); % loads data into buffer


%% keyboard
    %% Keys definition/kb initialization
    
    KbName('UnifyKeyNames');
    
    RespType(1) = KbName('LeftArrow');
    RespType(2) = KbName('RightArrow');
    RespType(3) = KbName('UpArrow');
    RespType(4) = KbName('DownArrow');
    RespType(5) = KbName('c'); % continue with study
    RespType(6) = KbName('m'); %recalibrate
    escapeKey = KbName('ESCAPE');	% quit key
    
    % get keyboard for the key recording
    deviceIndex = -1; % reset to default keyboard
    [k_id, k_name] = GetKeyboardIndices();
    for i = 1:numel(k_id)
        if strcmp(k_name{i},'Dell Dell USB Keyboard') % unique for your deivce, check the [k_id, k_name]
            deviceIndex =  k_id(i);
        elseif  strcmp(k_name{i},'Apple Internal Keyboard / Trackpad')
            deviceIndex =  k_id(i);
        end
    end
    
    KbQueueCreate(deviceIndex);
    KbQueueStart(deviceIndex);
    
    if responsebox==1
 % Open Datapixx, and stop any schedules which might already be running
Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');   
% Synchronize DATAPixx registers to local register cache
 % Configure digital input system for monitoring button box
Datapixx('SetDinDataDirection', hex2dec('1F0000'));     % Drive 5 button lights
Datapixx('EnableDinDebounce');                          % Debounce button presses
Datapixx('SetDinLog');                                  % Log button presses to default address
Datapixx('StartDinLog');                                % Turn on logging
Datapixx('RegWrRd');

% Bit locations of button inputs, and colored LED drivers
dinRed      = hex2dec('0000FFFE');
dinGreen    = hex2dec('0000FFFB');
dinBlue=hex2dec('0000FFF7');
dinYellow=hex2dec('0000FFFD');
dinWhite=hex2dec('0000FFEF');
RespType=[dinGreen;
    dinRed;
    dinYellow;
    dinBlue]';
escapeKey=dinWhite;
        TargList = [1 2 3 4]; % 1=red (right), 2=yellow (up), 3=green (left), 4=blue (down)
    end
    