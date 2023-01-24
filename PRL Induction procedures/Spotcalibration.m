% Visual Acuity/Crowding/cued-uncued attention task
% written by Marcello A. Maniglia july 2021 %2017/2021
close all;
clear all;
clc;
commandwindow
%addpath('/Users/sll/Desktop/Flap/Flap_scripts/utilities')
  

addpath([cd '/utilities']);
try
    prompt={'Subject Name', 'day','site (UCR = 1; UAB = 2; UCR Vpixx = 3)','scotoma old mode active','scotoma Vpixx active', 'demo (0) or session (1)', 'calibrate vpixx?: no(0), yes(1)', 'viewing distance (20 or 24)' };
    
    name= 'Subject Name';
    numlines=1;
    defaultanswer={'test','1', '3', '1','0', '0', '0', '20' };
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    expdayeye=str2num(answer{2,:});
    site= str2num(answer{3,:});  %0; 1=bits++; 2=display++
      scotomaoldmode= str2num(answer{4,:}); 
scotomavpixx= str2num(answer{5,:});  
    Isdemo=str2num(answer{6,:});
vipixxcal=str2num(answer{7,:});
viewingdist=str2num(answer{8,:});
    %load (['../PRLocations/' name]);
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    %baseName=['./data/' SUBJECT '_FLAPcrowdingacuity4sc' expdayeye num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    
    
    if Isdemo==0
        filename='_FLAP_ACA_practice';
    elseif Isdemo==1
        filename='_FLAP_ACA';
    end
    
    
    
    if site==1
        baseName=['./data/' SUBJECT filename 'GoogleProject' expdayeye num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[cd '\data\' SUBJECT filename 'GoogleProject' num2str(expdayeye) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[cd '\data\' SUBJECT filename 'GoogleProjectPixx' num2str(expdayeye) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) ' ' num2str(viewingdist) '.mat'];
    end
    
    c=clock;
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    
    EyeTracker = 1; %0=mouse, 1=eyetracker
    
    %     if EyeTracker==1
    %         EyetrackerType=1; %1 = Eeyelink, 2 = Vpixx
    %         eTracker = 0; % set to 1 for UAB code testing
    %     end
    fixat=1;
    fixationlength = 10; % pixels
    
    red=[255 0 0];
    practicetrials=5;
    StartSize=2; %for VA
    cueSize=3;
    circleSize=4.5;
    oneOrfourCues=1; % 1= 1 cue, 4= 4 cue
    fixwindow=3;
    fixTime=100.5/3;
        trialTimeout=1800;

    PRLecc=7.5;         %7.5; %eccentricity of PRLs
    PRLecc=5.3;         %7.5; %eccentricity of PRLs

    %   PRLxx=[0 PRLecc 0 -PRLecc];
    %   PRLyy=[-PRLecc 0 PRLecc 0 ];
    %PRL_x_axis=-5;
    %PRL_y_axis=0;
    %NoPRL_x_axis=5;
    %NoPRL_y_axis=0;
    
    ContCirc= [200 200 200];
    
    oval_thick=6; %thickness of oval
    
    Screen('Preference', 'SkipSyncTests', 1);
    PC=getComputerName();
    n_blocks=1;
    
    
    closescript=0;
    kk=1;
    
    cueonset=0.55;
    cueduration=.05;
    cueISI=0.05;
    presentationtime=0.133;
    ScotomaPresent = scotomaoldmode; % 0 = no scotoma, 1 = scotoma
    
    cue_spatial_offset=2;
    
    
    if site==0  %UCR bits**
        %% psychtoobox settings
        screencm=[40.6 30];
        load gamma197sec;
        v_d=110;
        %load lut_12bits_pd; Disabled until display is calibrated
        AssertOpenGL;
        oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
        %PsychGPUControl('SetDitheringEnabled', 0); Not supported on OSX
        screenNumber=max(Screen('Screens'));
        rand('twister', sum(100*clock));
        PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
        PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
        PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
        PsychImaging('AddTask', 'FinalFormatting','DisplayColorCorrection','LookupTable');
        PsychColorCorrection('SetLookupTable', window, lookup);
        oldResolution=Screen( 'Resolution',screenNumber,1280,960);
        SetResolution(screenNumber, oldResolution);
        %lut_12bits= repmat((linspace(0,1,4096).^(1/2.2))',1,3);
        %PsychColorCorrection('SetLookupTable', w, lut_12bits); --Denton-Disabled until calibration is done, moved to before OpenWindow, if initialized afterwards it won't have any effect until after the first flip
        [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
        %if you want to open a small window for debug
        %   [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
        %    Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        %Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
    elseif site==1 %UCR with bits
        crt=0;
        %% psychtoobox settings
      if crt==1  
          v_d=57;
        AssertOpenGL;
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
        v_d=57;
        AssertOpenGL;
        oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
        %PsychGPUControl('SetDitheringEnabled', 0); Not supported on OSX
        screenNumber=max(Screen('Screens'));
        rand('twister', sum(100*clock));
        PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
        PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
     %   PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
        %     PsychImaging('AddTask', 'FinalFormatting','DisplayColorCorrection','LookupTable');
        oldResolution=Screen( 'Resolution',screenNumber,1920,1080);
        SetResolution(screenNumber, oldResolution);
        [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
        %       [w, wRect]=Screen('OpenWindow',whichScreen, 127, [], [], [], [],3);
        %     [w, wRect] = Screen('OpenWindow', screenNumber, 0.5,[],[],[],[],3);
          
      end
    elseif site==2   %UAB
        s1=serial('com3');
        fopen(s1);
        fprintf(s1, ['$monoPlusPlus' 13]);
        fclose(s1);
        clear s1
        screencm=[69.8, 35.5];
        v_d=57;
        AssertOpenGL;
        oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
        %PsychGPUControl('SetDitheringEnabled', 0); Not supported on OSX
        screenNumber=max(Screen('Screens'));
        rand('twister', sum(100*clock));
        PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
        PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
        PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
        %     PsychImaging('AddTask', 'FinalFormatting','DisplayColorCorrection','LookupTable');
        oldResolution=Screen( 'Resolution',screenNumber,1920,1080);
        SetResolution(screenNumber, oldResolution);
        [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
        %       [w, wRect]=Screen('OpenWindow',whichScreen, 127, [], [], [], [],3);
        %     [w, wRect] = Screen('OpenWindow', screenNumber, 0.5,[],[],[],[],3);
        fixationlengthy=10;
        fixationlengthx=10;
        
    elseif site==3   %UCR VPixx
        %% psychtoobox settings
        
        initRequired= vipixxcal;
        if initRequired>0
            fprintf('\nInitialization required\n\nCalibrating the device...');
            TPxTrackpixx3CalibrationTestingskipMM;
        end
        % elseif EyetrackerType==2
        
        %Connect to TRACKPixx3
        Datapixx('Open');
        Datapixx('SetTPxAwake');
        Datapixx('RegWrRd');
        v_d=viewingdist/2.54;
        AssertOpenGL;
        screenNumber=max(Screen('Screens'));
        PsychImaging('PrepareConfiguration');
        % PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
        
        oldResolution=Screen( 'Resolution',screenNumber,1280,1024);
        SetResolution(screenNumber, oldResolution);
        [w, wRect]=PsychImaging('OpenWindow',screenNumber, 0,[],32,2);
        
 screencm=[69.8, 39.5];
 %debug window
        %    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
        %ScreenParameters=Screen('Resolution', screenNumber); %close all
        Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
        
    end
    
    v_d=50.8;
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    struct.sz=[screencm(1), screencm(2)];
    'troubleshoot: defining pix_deg';
    pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi));
    %pix_deg = pi * wRect(3) / atan(screencm(1)/v_d/2) / 360; %pixperdegree
    pix_deg_vert = pi * wRect(4) / atan(screencm(2)/v_d/2) / 360; %to calculate the limit of target position
    PixelsPerDegree=pix_deg;
    white=WhiteIndex(screenNumber);
    black=BlackIndex(screenNumber);
    gray=round((white+black)/2);
    if gray == white
        gray=white / 2;
    end
    inc=1;
    theseed=sum(100*clock);
    rand('twister',theseed );
    ifi = Screen('GetFlipInterval', w);
    if ifi==0
        ifi=1/75;
    end
    
    if EyeTracker==1
        if site==3
            EyetrackerType=2; %1 = Eeyelink, 2 = Vpixx
        else
            EyetrackerType=1; %1 = Eeyelink, 2 = Vpixx
        end
        
        % eye_used
        ScreenHeightPix=screencm(2)*pix_deg_vert;
        ScreenWidthPix=screencm(1)*pix_deg;
        VelocityThreshs = [250 2000];      	% px/sec
        VelocityThreshs = [20*pix_deg 60*pix_deg];     % px/sec 	% px/sec

        ViewpointRefresh = 1;               % dummy variable
        driftoffsetx=0;                     % initial x offset for all eyetracker values
        driftoffsety=0;                     % initial y offset for all eyetracker values
        driftcorr=0.1;                      % how much to adjust drift correction each trial.
        % Parameters to identify fixations
        FixationDecisionThreshold = 0.3;    % sec; how long they have to fixate on a location for it to "count"
        FixationTimeThreshold = 0.033;      % sec; how long the eye has to be stationary before we begin to call it a fixation
        % note, the eye velocity is already low enough to be considered a "fixation"
        FixationLocThreshold = 1;           % degrees;  how far the eye can drift from a fixation location before we "call it" a new fixation
        
        
        % old variables
        [winCenter_x,winCenter_y]=RectCenter(wRect);
        backgroundEntry = [0.5 0.5 0.5];
        % height and width of the screen
        winWidth  = RectWidth(wRect);
        winHeight = RectHeight(wRect);
    end
    
    'troubleshoot: got just before sound';
    % SOUND
    InitializePsychSound;
    pahandle = PsychPortAudio('Open', [], 1, 0, 44100, 2);
    
    if site<3
        pahandle1 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
        pahandle2 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    elseif site==3
        
        pahandle1 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
        pahandle2 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
    end
    
    try
        [errorS freq  ] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
        [corrS freq  ] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
    end
    
    %     try
    %         [errorS freq  ] = wavread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
    %         [corrS freq  ] = wavread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
    %     end;
    
    PsychPortAudio('FillBuffer', pahandle1, corrS' ); % loads data into buffer
    PsychPortAudio('FillBuffer', pahandle2, errorS'); % loads data into buffer
    bg_index =round(gray*255); %background color
    
    %
    imsize=StartSize*pix_deg;
    
    %imsize=StartSize*pix_deg;
    [x,y]=meshgrid(-imsize/2:imsize/2,-imsize/2:imsize/2);
    %circular mask
    xylim = imsize; %radius of circular mask
    circle = x.^2 + y.^2 <= xylim^2;
    [nrw, ncl]=size(x);
    
    %theLetter=imread('letter_c2.tiff');
    theLetter=imread('newletterc22.tiff');
    theLetter=theLetter(:,:,1);
    
    [sizx sizy]= size(theLetter);
    
    theLetter=imresize(theLetter,[nrw nrw],'bicubic');
    theCircles=theLetter;
    
    theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
    theLetter=Screen('MakeTexture', w, theLetter);
    
    
    if  mod(length(theCircles)/2,2)==0
        theCircles(1:nrw, round(nrw/2):nrw)=theCircles(nrw:-1:1, round(nrw/2):-1:1);
    elseif  mod(length(theCircles)/2,2)>0
        theCircles(1:nrw, nrw/2:nrw)=theCircles(nrw:-1:1, (nrw/2+1):-1:1);
    end
    
    
    %    theCircles(1:nrw, round(nrw/2):nrw)=theCircles(nrw:-1:1, round(nrw/2):-1:1);
    theCircles = double(circle) .* double(theCircles)+bg_index * ~double(circle);
    theCircles=Screen('MakeTexture', w, theCircles);
    'troubleshoot: got to defining circles';
    
    
    theDot=imread('thedot2.tiff');
    theDot=theDot(:,:,1);
    
    
    theDot=imresize(theDot,[nrw nrw],'bicubic');
    
    theDot = double(circle) .* double(theDot)+bg_index * ~double(circle);
    theDot=Screen('MakeTexture', w, theDot);
    
    
    % corrS=zeros(size(errorS));
    load('S096_marl-nyu');
    
    
    %% STAIRCASES:
    
    % Acuity sc1
    %cndt=4;
    %ca=1;
    threshVA=19;
    reversalsVA=0;
    %reversalcounterVA
    isreversalsVA=0;
    staircounterVA=0;
    corrcounterVA=0;
    
    % Threshold -> 79%
    sc.up = 1;                          % # of incorrect answers to go one step up
    sc.down = 3;                        % # of correct answers to go one step down
    
    Sizelist=log_unit_down(StartSize, 0.01, 90);
    
    % stepsizesVA=[8 4 3 2 1];
    stepsizesVA=[4 4 4 4 4];
    
    % Acuity sc2
    
    
    'troubleshoot: staircase'
    % Crowding
    cndt=4;
    ca=2;
    threshCW(1, 1:ca)=33; %25;
    reversalsCW(1, 1:ca)=0;
    isreversalsCW(1, 1:ca)=0;
    staircounterCW(1, 1:ca)=0;
    corrcounterCW(1, 1:ca)=0;
    
    max_separation=8; %15
    %min_separation=2.5;
    
    %Separationtlist=log_unit_up(StartSize, 0.01, 64);
    
    %  Separationtlist=log_unit_down(max_separation, 0.01, 64);
    Separationtlist=log_unit_down(max_separation, 0.015, 90);
    %Sizelist=log_unit_down(StartSize, 0.0135, 64)
    
    %  Separationtlist=fliplr(Separationtlist);
    
    %    stepsizesCW=[8 4 3 2 1];
    
    stepsizesCW=[4 4 4 4 4];
    
    'troubleshoot: twister??'
    rand('twister', sum(100*clock));
    
    %% response
    
    KbName('UnifyKeyNames');
    
    RespType(1) = KbName('c');

    
    
    %if ispc
    %    escapeKey = KbName('esc');	% quit key
    %elseif ismac
    escapeKey = KbName('ESCAPE');	% quit key
    %end
    
    'troubleshoot got to keyboard'
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    KbQueueCreate(deviceIndex);
    KbQueueStart(deviceIndex);
    
    if EyetrackerType==1
        useEyeTracker = 0; % otherwise will throw error if not UAB run
        
        %eyeTrackerBaseName=[SUBJECT '_DAY_' num2str(expday) '_CAT_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
        %eyeTrackerBaseName = 's00';
        eyeTrackerBaseName =[SUBJECT expdayeye];
        
        %  save_dir= 'C:\Users\labadmin\Desktop\marcello AMD assessment\7.Training\test_eyetracker_files';
        
        if exist('dataeyet')==0
            mkdir('dataeyet')
        end
        save_dir=[cd './dataeyet/'];
        
        % initialize eyelink
        if EyelinkInit()~= 1
            error('Eyelink initialization failed!');
        end
        % continue with the rest of eyelink initialization
        elHandle=EyelinkInitDefaults(w);
        el=elHandle;
        eyeTrackerFileName = [eyeTrackerBaseName '.edf'];
        % Modify calibration and validation target locations %%
        % it's location here is overridded by EyelinkDoTracker which resets it
        % with display PC coordinates
        Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, winWidth-1, winHeight-1);
        Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, winWidth-1, winHeight-1);
        % set calibration type.
        Eyelink('command', 'calibration_type = HV9');
        % Eyelink('command', 'calibration_type = HV5'); % changed to 5 to correct upper left corner of the screen issue
        % you must send this command with value NO for custom calibration
        % you must also reset it to YES for subsequent experiments
        %    Eyelink('command', 'generate_default_targets = NO');
        
        
        %% Modify target locations
        % due to issues with calibrating the upper left corner of the screen the following lines have been
        % commmented out to change the the sampling from 10 to 5 as
        % listed in line 323
        Eyelink('command','calibration_samples = 10');
        Eyelink('command','calibration_sequence = 0,1,2,3,4,5,6,7,8,9');
        
        %             modFactor = 0.183;
        %
        %             Eyelink('command','calibration_targets = %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
        %                 round(winWidth/2), round(winHeight/2),  round(winWidth/2), round(winHeight*modFactor),  ...
        %                 round(winWidth/2), round(winHeight - winHeight*modFactor),  round(winWidth*modFactor), ...
        %                 round(winHeight/2),  round(winWidth - winWidth*modFactor), round(winHeight/2), ...
        %                 round(winWidth*modFactor), round(winHeight*modFactor), round(winWidth - winWidth*modFactor), ...
        %                 round(winHeight*modFactor), round(winWidth*modFactor), round(winHeight - winHeight*modFactor),...
        %                 round(winWidth - winWidth*modFactor), round(winHeight - winHeight*modFactor) );
        
        %  Eyelink('command','validation_samples = 5');
        Eyelink('command','validation_samples = 10'); %changed to make
        % it 5 samples instead of 10 to deal with upper left corner of
        % the screem issue
        %             Eyelink('command','validation_sequence = 0,1,2,3,4,5,6,7,8,9');
        %             Eyelink('command','validation_targets =  %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
        %                 round(winWidth/2), round(winHeight/2),  round(winWidth/2), round(winHeight*modFactor),  ...
        %                 round(winWidth/2), round(winHeight - winHeight*modFactor),  round(winWidth*modFactor), ...
        %                 round(winHeight/2),  round(winWidth - winWidth*modFactor), round(winHeight/2), ...
        %                 round(winWidth*modFactor), round(winHeight*modFactor), round(winWidth - winWidth*modFactor), ...
        %                 round(winHeight*modFactor), round(winWidth*modFactor), round(winHeight - winHeight*modFactor),...
        %                 round(winWidth - winWidth*modFactor), round(winHeight - winHeight*modFactor)  );
        
        % make sure that we get gaze data from the Eyelink
        Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
        Eyelink('OpenFile', eyeTrackerFileName); % open file to record data  & calibration
        EyelinkDoTrackerSetup(elHandle);
        Eyelink('dodriftcorrect');
        
    end
    
    'troubleshoot: set up eyetracker, start main loop'
    %% main loop
    HideCursor;
    ListenChar(2);
    counter = 0;
    fixwindowPix=fixwindow*pix_deg;
    WaitSecs(1);
    % Select specific text font, style and size:
    Screen('TextFont',w, 'Arial');
    Screen('TextSize',w, 42);
    %     Screen('TextStyle', w, 1+2);
    Screen('FillRect', w, gray);
    colorfixation = white;
    DrawFormattedText(w, 'report the orientation of the gap of the C \n \n using the keyboard arrows \n \n \n \n Press any key to start', 'center', 'center', white);
    Screen('Flip', w);
    KbQueueWait;
    %Screen('Flip', w);
    %WaitSecs(1.5);
    
    [xc, yc] = RectCenter(wRect);
    %if cardinal
    xlocs=[0 PRLecc 0 -PRLecc];
    ylocs=[-PRLecc 0 PRLecc 0 ];
       %if diagonal
    xlocs=[PRLecc  -PRLecc];
    ylocs=[-PRLecc  PRLecc ];
    
    
       xlocs= [5.3  -5.3 ];
    ylocs= [-5.3  5.3 ];
    
    
    eccentricity_X=xlocs*pix_deg;
    eccentricity_Y=ylocs*pix_deg;
    
    PRLlocations=2;
    
    tr_per_condition=16;  %50
    mixtrVAsc1=[];
    
    for  ui=1:(tr_per_condition/PRLlocations)
        b=randperm(PRLlocations);
        mixtrVAsc1=[mixtrVAsc1 b];
    end
    
    mixtrVAsc2=[];
    
    for  ui=1:tr_per_condition
        b=randperm(PRLlocations);
        mixtrVAsc2=[mixtrVAsc2 b];
    end
    mixtrVA=[ mixtrVAsc1' ones(length(mixtrVAsc1),1); mixtrVAsc2' ones(length(mixtrVAsc2),1)*2];
    
    %Crowding
    %radial
    mixtrCWsc1r=[];
    
    for  ui=1:(tr_per_condition/PRLlocations)
        b=randperm(PRLlocations);
        mixtrCWsc1r=[mixtrCWsc1r b];
    end
    
    mixtrCWsc2r=[];
    
    for  ui=1:tr_per_condition
        b=randperm(PRLlocations);
        mixtrCWsc2r=[mixtrCWsc2r b];
    end
    
    mixtrCWr=[ mixtrCWsc1r' ones(length(mixtrCWsc1r),1);  mixtrCWsc2r' ones(length(mixtrCWsc2r),1)*2];
    % tangential
    
    mixtrCWsc1t=[];
    
    for  ui=1:(tr_per_condition/PRLlocations)
        b=randperm(PRLlocations);
        mixtrCWsc1t=[mixtrCWsc1t b];
    end
    
    mixtrCWsc2t=[];
    
    for  ui=1:tr_per_condition
        b=randperm(PRLlocations);
        mixtrCWsc2t=[mixtrCWsc2t b];
    end
    
    mixtrCWt=[ mixtrCWsc1t' ones(length(mixtrCWsc1t),1); mixtrCWsc2t' ones(length(mixtrCWsc2t),1)*2 ];
    
    if randi(2)==2
        mixtrCW= [ mixtrCWt ones(length(mixtrCWt),1) ; mixtrCWr ones(length(mixtrCWr),1)*2];
    else
        mixtrCW= [ mixtrCWr ones(length(mixtrCWr),1)*2 ; mixtrCWt ones(length(mixtrCWt),1)];
    end
    
    mixtrCW =[mixtrCW(:,1) mixtrCW(:,3) mixtrCW(:,2)];
    
    %
    %
    % trymixtrCW=[    mixtrCW(1:16,:)
    %     mixtrCW(81:96,:)
    %     mixtrCW(17:80,:)
    %         mixtrCW(97:end,:)];
    %
    mixtrCWa=[mixtrCW(1:16,:); mixtrCW(81:96,:)];
    mixtrCWb=[ mixtrCW(17:80,:) ;mixtrCW(97:end,:)];
    %  mixtrCWc= mixtrCW(17:80,:);
    %   mixtrCWd=mixtrCW(97:end,:);
    mixtrCWa=mixtrCWa(randperm(length(mixtrCWa)),:);
    mixtrCWb= mixtrCWb(randperm(length(mixtrCWb)),:);
    %    mixtrCWc=   mixtrCWc(randperm(length(mixtrCWc)),:);
    %      mixtrCWd=     mixtrCWd(randperm(length(mixtrCWd)),:);
    
    'troubleshoot: got someplace in the middle of a bunch of useless commented code'
    %mixtrCWa=mixtrCWa(1:10,:);
    %mixtrCWb=mixtrCWb(1:16,:);
    
    
    
    %  mixtrCWa=[1     1     1
    %      4     1     1
    %      2     2     1
    %      1     1     1
    %      4     2     1
    %      1     2     1
    %           1     1     1
    %      3     2     1];
    mixtrCW=[mixtrCWa; mixtrCWb];% mixtrCWc; mixtrCWd];
    
    

    load('AttMatNew.mat')
    
    %numar=size(fields(AttMat));
    numar=7;
    dio= [99 99 ];
    while dio(1) == dio(2)
        dio=randi(numar(1),1,2);
    end
    
    subMat={'one', 'two', 'five', 'seven', 'eight', 'nine', 'ten'};
    firstPartMat=AttMat.(subMat{dio(1)});
    secondPartMat=AttMat.(subMat{dio(2)});
    
    mixtrAtt= [firstPartMat; secondPartMat];
    
    %   totalmixtr = [1 1; 2 1; 3 1; 4 1; 1 2; 2 2; 3 2; 4 2];
    
    totalmixtr=length(mixtrVA)+length(mixtrCW)+length(mixtrAtt);
    % check EyeTracker status
    if EyetrackerType == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        % mark zero-plot time in data file
        Eyelink('message' , 'SYNCTIME');
        
        location =  zeros(length(totalmixtr), 6);
    end
    
    
    eyetime2=0;
    waittime=0;
    scotomadeg=2;
    %    scotomadeg=6;

    if site<3
        scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
    elseif site==3
        scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
    end
    
    scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
    
    %     xeye=[];
    %     yeye=[];
    %
    %     tracktime=[];
    %     VBL_Timestamp=[];
    %     stimonset=[ ];
    %     fliptime=[ ];
    %     mss=[ ];
        scotoma_color=[200 200 200];
     %   scotoma_color=scotoma_color/255;
    FixDotSize=15;
    
    
    if Isdemo==0
        mixtrVA=mixtrVA(1:practicetrials,:);
        mixtrCW=mixtrCW(1:practicetrials,:);
        mixtrAtt=mixtrAtt(1:practicetrials,:);
        
    end
    
    
    fixtype= [0 -8 -5 -3 -2 -1 0 1 2 3 5 8];
    for totaltrial=1:length(fixtype) %totalmixtr
                trialTimedout(totaltrial)=0;

        
fixbox=fixtype(totaltrial);
        
        TrialNum = strcat('Trial',num2str(totaltrial));
        
        clear EyeData
        clear FixIndex
        xeye=[];
        yeye=[];
        pupils=[];
        tracktime=[];
        VBL_Timestamp=[];
        stimonset=[ ];
        fliptime=[ ];
        mss=[ ];
        tracktime=[];
        FixCount=0;
        FixatingNow=0;
        EndIndex=0;
        
        fixating=0;
        counter=0;
        framecounter=0;
        x=0;
        y=0;
        area_eye=0;
        xeye2=[];
        yeye2=[];

        
        theoris =[-180 0 -90 90];
        
      %  theans(trial)=randi(4);
        
      %  ori=theoris(theans(trial));
        %KbQueueFlush()
        
        Priority(0);
        buttons=0;
        eyechecked=0;
        KbQueueFlush()
        trial_time=-1000;
        stopchecking=-100;
        
        trial_time=100000;
        clear starfix
        pretrial_time=GetSecs;
        while eyechecked<1
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            if (eyetime2-pretrial_time)>ifi*35 && (eyetime2-pretrial_time)<ifi*65 && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1))+ keyCode(escapeKey) ==0
              %  fixationscript3
              fixationscriptWGoogle
            elseif  (eyetime2-pretrial_time)>=ifi*65 && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1))+ keyCode(escapeKey) ==0
                if site<3
                    IsFixatingSquare
                elseif site==3
                    IsFixating4pixx
                end
                if exist('starfix')==0
                    startfix=GetSecs;
                    starfix=98;
                end
                %  fixationscript3
              fixationscriptWGoogle
              
            elseif (eyetime2-pretrial_time)>=ifi*65 && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1))+ keyCode(escapeKey) ~=0

                              fixationscriptWGoogle
eyenowx(totaltrial)=newsamplex;
eyenowy(totaltrial)=newsampley;
                                                respTime=GetSecs;
                                                                thekeys = find(keyCode);

                                                                    if (thekeys==escapeKey) % esc pressed
                       closescript = 1;
                        break;
                    end
                                                                                                PsychPortAudio('Start', pahandle1);

                eyechecked=2;
%             elseif (eyetime2-pretrial_time)>ifi*65 && fixating>=fixTime/ifi && stopchecking>1 && fixating<10000 && (eyetime2-pretrial_time)<=trialTimeout
%                 trial_time = GetSecs;
%                 fixating=150000;
%                                                 PsychPortAudio('Start', pahandle2);
% 
%                 respTime=GetSecs;
%                 eyechecked=2;
            
                        elseif (eyetime2-pretrial_time)>trialTimeout
                eyechecked=2;

            end
            

                eyefixation5

            
            if ScotomaPresent == 1
                Screen('FillOval', w, scotoma_color, scotoma);
            else
                fixationlength=10;
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
                
            end
            if EyetrackerType==2
                
                if scotomavpixx==1
                    Datapixx('EnableSimulatedScotoma')
                    Datapixx('SetSimulatedScotomaMode',2) %[~,mode = 0]);
                    %Datapixx('SetSimulatedScotomaMode'[,mode = 0]);
                    scotomaradiuss=round(pix_deg*6);
                    Datapixx('SetSimulatedScotomaRadius',scotomaradiuss) %[~,mode = 0]);
                    
                    mode=Datapixx('GetSimulatedScotomaMode');
                    status= Datapixx('IsSimulatedScotomaEnabled');
                    radius= Datapixx('GetSimulatedScotomaRadius');
                    
                end
            end
%             if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
%                 Screen('FillRect', w, gray);
%             end
            [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
            
            VBL_Timestamp=[VBL_Timestamp eyetime2];
            
            if EyeTracker==1
                
                if site<3
                    GetEyeTrackerData
                elseif site ==3
                    GetEyeTrackerDatapixx
                end
                GetFixationDecision
                
                if EyeData(1)<8000 && stopchecking<0
                    trial_time = GetSecs;
                    stopchecking=10;
                end
                
                if CheckCount > 1
                    if (EyeCode(CheckCount) == 0) && (EyeCode(CheckCount-1) > 0)
                        TimerIndex = FixOnsetIndex;
                        FixCount = FixCount + 1;
                        FixIndex(FixCount,1) = FixOnsetIndex;
                        FixatingNow = 1;
                    end
                    if (EyeCode(CheckCount) ~= 0) && (FixatingNow == 1)
                        if FixCount == 0
                            FixCount = 1;
                            FixIndex(FixCount,1) = EndIndex+1;
                        end
                        FixIndex(FixCount,2) = CheckCount-1;
                        FixatingNow = 0;
                    end
                    
                end
                
            end
            [keyIsDown, keyCode] = KbQueueCheck;
        end

        
        if exist('stim_start')==0
                stim_start=0;
                stimnotshowed(totaltrial)=99;
        end
                if exist('respTime')==0
                respTime=0;
                respotshowed(totaltrial)=99;
        end
        time_stim(kk) = respTime - stim_start;
        totale_trials(kk)=totaltrial;
        coordinate(totaltrial).x=xc;               
        coordinate(totaltrial).y=newyc;
        xxeye(totaltrial).ics=xeye;
        yyeye(totaltrial).ipsi=yeye;
        vbltimestamp(totaltrial).ix=VBL_Timestamp;
        flipptime(totaltrial).ix=fliptime;
        
        fixationdure(totaltrial)=trial_time-startfix;

diffx(totaltrial)=xc-eyenowx(totaltrial);
diffy(totaltrial)=newyc-eyenowy(totaltrial);
        
        if EyeTracker==1
            EyeSummary.(TrialNum).EyeData = EyeData;
            clear EyeData
            EyeSummary.(TrialNum).EyeData(:,6) = EyeCode';
            clear EyeCode
            if exist('FixIndex')==0
                FixIndex=0;
            end
            EyeSummary.(TrialNum).FixationIndices = FixIndex;
            clear FixIndex
            EyeSummary.(TrialNum).TotalEvents = CheckCount;
            clear CheckCount
            EyeSummary.(TrialNum).TotalFixations = FixCount;
            clear FixCount
            EyeSummary.(TrialNum).TargetX = xc;
            EyeSummary.(TrialNum).TargetY = newyc;
            
            

            EyeSummary.(TrialNum).EventData = EvtInfo;
            clear EvtInfo
            EyeSummary.(TrialNum).ErrorData = ErrorData;
            clear ErrorData

            if exist('EndIndex')==0
                EndIndex=0;
            end
            EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
            clear EndIndex
            EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
            EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
            EyeSummary.(TrialNum).TimeStamps.Fixation = stim_start;
            clear ErrorInfo
            
        end
        
            if totaltrial==11
            else
                save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
            end
        
        if closescript==1
            break;
        end
        
        kk=kk+1;
        %  save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
        
    end
            DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
Screen('Flip', w);
    Screen('TextFont', w, 'Arial');
        KbQueueWait;

    % shut down EyeTracker
    if EyetrackerType==1
        Eyelink('StopRecording');
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    elseif EyetrackerType==2
        Datapixx('SetTPxSleep');
        Datapixx('RegWrRd');
        Datapixx('Close');
    end

    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    
    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    ListenChar(0);
 %   Screen('Flip', w);
    ShowCursor;
    
    if site==1
        Screen('CloseAll');
        Screen('Preference', 'SkipSyncTests', 0);
        %     s1 = serial('COM3');     % set the Bits mode back so the screen is in colour
        %     fopen(s1);
        %     fprintf(s1, ['$BitsPlusPlus' 13]); %one day we might use the bits# so better not to get rid of these lines
        %     fclose(s1);
        PsychPortAudio('Close', pahandle);
        
    else
        Screen('Preference', 'SkipSyncTests', 0);
        Screen('LoadNormalizedGammaTable', w , (linspace(0,1,256)'*ones(1,3)));
        Screen('Flip', w);
        Screen('CloseAll');
        if site<3
            PsychPortAudio('Close', pahandle);
        elseif site ==3
            PsychPortAudio('Close', pahandle1);
        end
    end
    
    %% data analysis
    %thresho=permute(Threshlist,[3 1 2]);
    
    %to get the final value for each staircase
    %final_threshold=thresho(10,1:length(thresho(1,:,1)),1:length(thresho(1,1,:)));
    %total_thresh= [final_threshold(:,:,1) final_threshold(:,:,2)];
    %%
    
    
catch ME
    'There was an error caught in the main program.'
    psychlasterror()
end