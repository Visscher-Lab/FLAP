%function [w, wRect]=defineSite(site)
Screen('Preference', 'SkipSyncTests', 1);
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
        v_d=57; %viewing distance
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
        v_d=57; %viewing distance
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
    v_d=57; %viewing distance
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
    
    initRequired= calibration; %do we want vpixx calibration?
    if initRequired>0
        fprintf('\nInitialization required\n\nCalibrating the device...');
        TPxTrackpixx3CalibrationTestingskip;
    end
    
    %Connect to TRACKPixx3
    Datapixx('Open');
    Datapixx('SetTPxAwake');
    Datapixx('RegWrRd');
    v_d=80;
    screenNumber=max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');
    %         PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
    PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
    %
    oldResolution=Screen( 'Resolution',screenNumber,1920,1080);
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
if ifi==0
    ifi=1/100;
end

%end