% Visual Acuity/Crowding/cued-uncued attention task
% written by Marcello A. Maniglia july 2021 %2017/2021
close all; clear all; clc;
commandwindow
%addpath('/Users/sll/Desktop/Flap/Flap_scripts/utilities')


addpath([cd '/utilities']);
try
    prompt={'Subject Name', 'session', 'site (UCR = 1; UAB = 2; UCR Vpixx = 3)'};
    
    name= 'Subject Name';
    numlines=1;
    defaultanswer={'test','test', '1' };
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
        addpath([cd '/utilities']);

    SUBJECT = answer{1,:}; %Gets Subject Name
    expdayeye=str2num(answer{2,:});
    site = str2num(answer{3,:});
    scotomavpixx=0;
    scotomaoldmode=1; % 0 = no scotoma, 1 = scotoma

    %load (['../PRLocations/' name]);
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    baseName=['./data/' SUBJECT '_FLAPfixationflicker' expdayeye num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    EyeTracker = 1; %0=mouse, 1=eyetracker

    fixat=1;
    fixationlength = 40; % pixels
    
    red=[255 0 0];
    pressspace=1;
    stimulusSize=1.5; 
    cueSize=3; %deg
    
    oneOrfourCues=1; % 1= 1 cue, 4= 4 cue
    fixwindow=2;
    fixTime=1.5/3;
    AnnulusDuration=2;
    
    
    AnnulusTime=AnnulusDuration/3;
        trialTimeout=4;
    realtrialTimeout=trialTimeout;
    %FlickerTime=
    Jitter= [2:0.05:5];
    flickeringrate=0.25;
    PRLecc=10; %2;         %7.5; %eccentricity of PRLs in deg
    %   PRLxx=[0 PRLecc 0 -PRLecc];
    %   PRLyy=[-PRLecc 0 PRLecc 0 ];
    %PRL_x_axis=-5;
    %PRL_y_axis=0;
    %NoPRL_x_axis=5;
    %NoPRL_y_axis=0;
        PRLsize =10; % diameter PRL in deg

        scotomadeg=10; 

       
    
    Screen('Preference', 'SkipSyncTests', 1);
    PC=getComputerName();
    n_blocks=1;
    
    
    closescript=0;
    kk=1;
    
    precircletime=0.55;
    cueISI=0.1;
   % FlickerTime=0.133;
    ScotomaPresent = scotomaoldmode; % 0 = no scotoma, 1 = scotoma
    
    cue_spatial_offset=2;
    
    
    if site==0  %UCR bits++
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
    elseif site==1 % UCR + display++
 crt=0;
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
        PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
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
        fprintf(s1, ['$monoPlusPlus' 13])
        fclose(s1);
        clear s1;
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
        
        initRequired= 1;
        if initRequired>0
            fprintf('\nInitialization required\n\nCalibrating the device...');
            TPxTrackpixx3CalibrationTestingskip;
        end
        % elseif EyetrackerType==2
        
        %Connect to TRACKPixx3
        Datapixx('Open');
        Datapixx('SetTPxAwake');
        Datapixx('RegWrRd');
        v_d=57;
        AssertOpenGL;
        screenNumber=max(Screen('Screens'));
        PsychImaging('PrepareConfiguration');
        % PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
        
       oldResolution=Screen( 'Resolution',screenNumber,1920,1080);
        SetResolution(screenNumber, oldResolution);
                [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);

        screencm=[69.8, 35.5];
        %debug window
        %    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
        %ScreenParameters=Screen('Resolution', screenNumber); %close all
        Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
        
    
    end
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    struct.sz=[screencm(1), screencm(2)];
    
    pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi));
    pix_deg_vert = pi * wRect(4) / atan(screencm(2)/v_d/2) / 360; 
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
    
    %try
     %   [errorS freq  ] = wavread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
      %  [corrS freq  ] = wavread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
   % end
    
    PsychPortAudio('FillBuffer', pahandle1, corrS' ); % loads data into buffer
    PsychPortAudio('FillBuffer', pahandle2, errorS'); % loads data into buffer
    bg_index =round(gray*255); %background color
    
    %
    imsize=stimulusSize*pix_deg;
    
    %imsize=StartSize*pix_deg;
    [x,y]=meshgrid(-imsize/2:imsize/2,-imsize/2:imsize/2);
    %circular mask
    xylim = imsize; %radius of circular mask
    circle = x.^2 + y.^2 <= xylim^2;
    [nrw, ncl]=size(x);
      
    
    %theLetter=imread('letter_c2.tiff');
    
    
    
        theBLetter=imread('blackC.tiff');
    theBLetter=theBLetter(:,:,1);

    theBLetter=imresize(theBLetter,[nrw nrw],'bicubic');

    theBLetter = double(circle) .* double(theBLetter)+bg_index * ~double(circle);
    
    theBCircles=theBLetter;
    

    %theBCircles(1:nrw, nrw/2:nrw)=theBCircles(nrw:-1:1, (nrw/2):-1:1);
    
    
            if  mod(nrw,2)==0
            theBCircles(1:nrw, nrw/2:nrw)=theBCircles(nrw:-1:1, (nrw/2+1):-1:1);
        elseif  mod(nrw,2)>0
            theBCircles(1:nrw, nrw/2:nrw)=theBCircles(nrw:-1:1, round((nrw/2)):-1:1);
        end
        
    
        theBLetter=Screen('MakeTexture', w, theBLetter);

    
    theBCircles = double(circle) .* double(theBCircles)+bg_index * ~double(circle);
    theBCircles=Screen('MakeTexture', w, theBCircles);
    

    theLetter=imread('newletterc22.tiff');
    theLetter=theLetter(:,:,1);

    theLetter=imresize(theLetter,[nrw nrw],'bicubic');
    theCircles=theLetter;
    
    theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
    theLetter=Screen('MakeTexture', w, theLetter);
    
    theCircles(1:nrw, nrw/2:nrw)=theCircles(nrw:-1:1, (nrw/2+1):-1:1);
    theCircles = double(circle) .* double(theCircles)+bg_index * ~double(circle);
    theCircles=Screen('MakeTexture', w, theCircles);
  
    theTest=imread('target_black.tiff');
    theTest=theTest(:,:,1);
        theTest=Screen('MakeTexture', w, theTest);

    [img, sss, alpha] =imread('neutral21.png');
    img(:, :, 4) = alpha;
  Neutralface=Screen('MakeTexture', w, img);
        
            [sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);

             radiusPRL=(PRLsize/2)*pix_deg;

    smallradius=radiusPRL; %+pix_deg/2 %+1*pix_deg;
        radiusPRL=radiusPRL+3*pix_deg;
        
        circlePixels=sx.^2 + sy.^2 <= radiusPRL.^2;
        circlePixels2=sx.^2 + sy.^2 <= smallradius.^2;
        
        d=(circlePixels2==1);
        newfig=circlePixels;
        newfig(d==1)=0;
        circlePixels=newfig;
    % corrS=zeros(size(errorS));
    load('S096_marl-nyu');
    rand('twister', sum(100*clock));
    
    %% response
     
    KbName('UnifyKeyNames');
        
    RespType(1) = KbName('LeftArrow');
    RespType(2) = KbName('RightArrow');
    RespType(3) = KbName('UpArrow');
    RespType(4) = KbName('DownArrow');
   RespType(5) = KbName('Space');
%     if ispc
%         escapeKey = KbName('esc');	% quit key
%     elseif ismac
        escapeKey = KbName('ESCAPE');	% quit key
%    end
    
    
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
    
    
    %% Trial structure
    scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg_vert];
    scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
      imageRect = CenterRect([0, 0, stimulusSize*pix_deg stimulusSize*pix_deg], wRect);

    
          ecc_r=PRLecc*pix_deg;

         angolo= [90 45 0 315 270 225 180 135];
                 
         for ui=1:length(angolo)
           ecc_t=deg2rad(angolo(ui));
            cs= [cos(ecc_t), sin(ecc_t)];
            xxyy=[ecc_r ecc_r].*cs;
            ecc_x=xxyy(1);
            ecc_y=xxyy(2);            
            eccentricity_X(ui)=ecc_x;
            eccentricity_Y(ui)=ecc_y;          
         end
    tr=10;  

     mixtr=[repmat(1:length(angolo),1,tr)'];
      mixtr =mixtr(randperm(length(mixtr)),:);
      
    %  mixtr=[];
                  [xc, yc] = RectCenter(wRect);

    
    %% main loop
    HideCursor;
    counter = 0;    
    ListenChar(2);
    fixwindowPix=fixwindow*pix_deg;        
    WaitSecs(1);
    % Select specific text font, style and size:
    Screen('TextFont',w, 'Arial');
    Screen('TextSize',w, 42);
    %     Screen('TextStyle', w, 1+2);
    Screen('FillRect', w, gray);
    colorfixation = white;
  %  DrawFormattedText(w, 'Press  the arrow key when the circle turns into a C \n \n \n \n Press any key to start', 'center', 'center', white);
        DrawFormattedText(w, 'Keep the scotoma near the stimulus for 2 seconds \n \n the stimulus will start flickering \n \n Press  the space bar when the circle turns black \n \n \n \n Press any key to start', 'center', 'center', white);
Screen('Flip', w);
    KbQueueWait;
    %Screen('Flip', w);
    %WaitSecs(1.5);
     
      
    % check EyeTracker status
    if EyetrackerType == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        % mark zero-plot time in data file
        Eyelink('message' , 'SYNCTIME');
        
        location =  zeros(length(mixtr), 6);
    end

    eyetime2=0;
    waittime=0;

    xeye=[];
    yeye=[];

    tracktime=[];
    VBL_Timestamp=[];
    stimonset=[ ];
    fliptime=[ ];
    mss=[ ];
    scotoma_color=[200 200 200];
    if site<3    
    scotoma_color=scotoma_color/255;
    end
    FixDotSize=15;
    
    
    
    for trial=1:length(mixtr)
                        trialTimedout(trial)=0;

        kkk=0;
        if trial== length(mixtr)/8 %|| trial== length(mixtr)/4 || trial== length(mixtr)/4
            interblock_instruction
        end
         
        
        
        FlickerTime=Jitter(randi(length(Jitter)));
                    actualtrialtimeout=realtrialTimeout;
            trialTimeout=400000;
        TrialNum = strcat('Trial',num2str(trial));
              
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
        counterannulus=0;
        counterflicker=0;
        framecounter=0;
        x=0;
        y=0;
        area_eye=0;
        xeye2=[];
        yeye2=[];

            theeccentricity_X=eccentricity_X(mixtr(trial,1));
            theeccentricity_Y=eccentricity_Y(mixtr(trial,1));
            
            imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
                imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
            
      theoris =[-180 0 -90 90];
        
        theans(trial)=randi(4); 
        
        ori=theoris(theans(trial));
        
        
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
            if (eyetime2-pretrial_time)>ifi*35 && (eyetime2-pretrial_time)<ifi*65 && fixating<fixTime/ifi && stopchecking>1
                %fixationscript2
                fixationscriptW
            elseif  (eyetime2-pretrial_time)>=ifi*65 && fixating<fixTime/ifi && stopchecking>1
                IsFixatingSquare
                %fixationscript2
                fixationscriptW
                if exist('starfix')==0
                    startfix=GetSecs;
                    starfix=98;
                end
            elseif (eyetime2-pretrial_time)>ifi*65 && fixating>=fixTime/ifi && fixating<1000 && stopchecking>1
                trial_time = GetSecs;
                fixating=1500;
            end

            if (eyetime2-trial_time)>=waittime+ifi*2+precircletime && (eyetime2-trial_time)<waittime+ifi*2+precircletime+cueISI && fixating>400 && stopchecking>1 && (eyetime2-trial_time)<=trialTimeout
                clear circlestar
                clear flickerstar
                clear theSwitcher

            elseif (eyetime2-trial_time)>=waittime+ifi*2+precircletime+cueISI && fixating>400 && stopchecking>1 && counterannulus<AnnulusTime/ifi && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ==0 && (eyetime2-trial_time)<=trialTimeout

            
                IsFixatingAnnulus
                Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                if exist('circlestar')==0
                    circle_start = GetSecs;
                    circlestar=1;
                end
                       elseif (eyetime2-trial_time)>=waittime+ifi*2+precircletime+cueISI && fixating>400 && stopchecking>1 && counterannulus<AnnulusTime/ifi && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ~=0 && (eyetime2-trial_time)<=trialTimeout
                           
                           thekeys = find(keyCode);
                           
                           break;
            elseif (eyetime2-trial_time)>=waittime+ifi*2+precircletime+cueISI && fixating>400 && stopchecking>1 && counterannulus>=AnnulusTime/ifi && counterflicker<FlickerTime/ifi && (eyetime2-trial_time)<=trialTimeout
            if exist('flickerstar') == 0
                          flicker_time_start=GetSecs;
                          flickerstar=1;
                          theSwitcher=0;
                          flickswitch=0;
                          flick=1;
           end
           flicker_time=GetSecs-flicker_time_start;
           
           
           if flicker_time>flickswitch
               flickswitch= flickswitch+flickeringrate;
               flick=3-flick;
           end
           
           
           if flicker_time>FlickerTime
               counterflicker=FlickerTime/ifi+1;
           end

if flick==2 
    theSwitcher=theSwitcher+1;
        kkk=kkk+1;
    countfl(trial,kkk)=GetSecs;
    Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
end                            
                cue_last=GetSecs;
                clear targetstar
                clear stimstar
                   elseif (eyetime2-trial_time)>=waittime+ifi*2+precircletime+cueISI+FlickerTime && fixating>400 && counterannulus>=AnnulusTime/ifi && counterflicker>=FlickerTime/ifi && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(RespType(5)) + keyCode(escapeKey) ==0 && stopchecking>1 && (eyetime2-trial_time)<=trialTimeout %present pre-stimulus and stimulus

           if exist('targetstar') == 0
                          target_time_start=GetSecs;
                          targetstar=1;
                          theSwitcher=0;
                          flickswitch=0;
                          flick=1;
                                trialTimeout=actualtrialtimeout+(target_time_start-pretrial_time);
           end
           target_time=GetSecs-target_time_start;
           
           
           if target_time>flickswitch
               flickswitch= flickswitch+flickeringrate;
               flick=3-flick;
           end

if flick==2
    theSwitcher=theSwitcher+1;
        kkk=kkk+1;
    countfl(trial,kkk)=GetSecs;

                        %        Screen('DrawTexture', w, theBLetter, [], imageRect_offs, ori,[], 1);              
                                                              Screen('DrawTexture', w, theBCircles, [], imageRect_offs, ori,[], 1);
     
                                if exist('stimstar')==0
                                    stim_start = GetSecs;
                                    stimstar=1;
                                end
end

            elseif (eyetime2-trial_time)>=waittime+ifi*4+precircletime+cueISI+FlickerTime && fixating>400 && counterannulus>=AnnulusTime/ifi && counterflicker>=FlickerTime/ifi && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(RespType(5)) + keyCode(escapeKey) ~=0 && stopchecking>1 && (eyetime2-trial_time)<=trialTimeout %present pre-stimulus and stimulus
                eyechecked=1111111111;
                               
                thekeys = find(keyCode);
                      if length(thekeys)>1
                    thekeys=thekeys(1);
                      end
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
                                respTime=GetSecs;

                 elseif (eyetime2-pretrial_time)>=trialTimeout
                stim_stop=GetSecs;
                trialTimedout(trial)=1;
                eyechecked=10^4;
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
                    scotomaradiuss=round(pix_deg*6);
                    Datapixx('SetSimulatedScotomaRadius',scotomaradiuss) %[~,mode = 0]);
                    
                    mode=Datapixx('GetSimulatedScotomaMode');
                    status= Datapixx('IsSimulatedScotomaEnabled');
                    radius= Datapixx('GetSimulatedScotomaRadius');
                    
                end
            end
            if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                Screen('FillRect', w, gray);
            end
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
                if trialTimedout(trial)== 0
        foo=(RespType==thekeys);
                if pressspace==0
                    
            if foo(theans(trial))
                resp = 1;             
                PsychPortAudio('Start', pahandle1);
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                if EyetrackerType==2
                    Datapixx('DisableSimulatedScotoma')
                    Datapixx('RegWrRd')
                end
                ListenChar(0);
                break;
            else
                resp = 0;              
                PsychPortAudio('Start', pahandle2);            
            end
                else
                    
                    if (thekeys==escapeKey) % esc pressed
                closescript = 1;
                if EyetrackerType==2
                    Datapixx('DisableSimulatedScotoma')
                    Datapixx('RegWrRd')
                end
                ListenChar(0);
                break;
                    end
                    
                    resp = 1;             
                PsychPortAudio('Start', pahandle1);
                end
                
    end
                if trialTimedout(trial)==0
                    stim_stop=GetSecs;
                    cheis(kk)=thekeys;
                end
        stim_stop=GetSecs;
        annulustrialduration(trial)=flicker_time_start-circle_start;
        flickertriaduration(trial)=FlickerTime;
        targettrialduration(trial)=target_time_start-flicker_time_start;
        if trialTimedout(trial)== 0
        time_stim(kk) = stim_stop - stim_start;
                rispo(kk)=resp;
        cheis(kk)=thekeys;
        end
        totale_trials(kk)=trial;       
        coordinate(trial).x=theeccentricity_X/pix_deg;
        coordinate(trial).y=theeccentricity_Y/pix_deg;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];
        flipptime(trial).ix=[fliptime];

                fixationdure(trial)=trial_time-startfix;

            SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
cueendToResp(kk)=stim_stop-cue_last;
cuebeginningToResp(kk)=stim_stop-circle_start;
        intervalBetweenFlickerandTrget(trial)=target_time_start-flicker_time_start;
        circledurationbeforeflicker(trial)=flicker_time_start-circle_start;
        
        if EyeTracker==1
            EyeSummary.(TrialNum).EyeData = EyeData;
            clear EyeData
            EyeSummary.(TrialNum).EyeData(:,6) = EyeCode';
            clear EyeCode            
            if exist('FixIndex')==0
                FixIndex=0;
            end;
            EyeSummary.(TrialNum).FixationIndices = FixIndex;
            clear FixIndex
            EyeSummary.(TrialNum).TotalEvents = CheckCount;
            clear CheckCount
            EyeSummary.(TrialNum).TotalFixations = FixCount;
            clear FixCount
            EyeSummary.(TrialNum).TargetX = theeccentricity_X/pix_deg;
            EyeSummary.(TrialNum).TargetY = theeccentricity_Y/pix_deg;
            EyeSummary.(TrialNum).EventData = EvtInfo;
            clear EvtInfo
            EyeSummary.(TrialNum).ErrorData = ErrorData;
            clear ErrorData

            if exist('EndIndex')==0
                EndIndex=0;
            end;
            EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
            clear EndIndex
            EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
            EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
            EyeSummary.(TrialNum).TimeStamps.Fixation = stim_start;
            EyeSummary.(TrialNum).TimeStamps.StimulusStart = circle_start;
            EyeSummary.(TrialNum).TimeStamps.StimulusEnd = cue_last;
            EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;

            clear ErrorInfo
            
        end
        
        if (mod(trial,50))==1
            if trial==1
            else
                save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
            end
        end
              
        if closescript==1
            break;
        end
        
        kk=kk+1;
        %  save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
        
    end
     DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
    ListenChar(0);
    Screen('Flip', w);
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
    Screen('Flip', w);
    Screen('TextFont', w, 'Arial');
    
    
    c=clock;
        TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];

   
    KbQueueWait;
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
        PsychPortAudio('Close', pahandle);
    end
    
    %% data analysis
    %thresho=permute(Threshlist,[3 1 2]);
    
    %to get the final value for each staircase
    %final_threshold=thresho(10,1:length(thresho(1,:,1)),1:length(thresho(1,1,:)));
    %total_thresh= [final_threshold(:,:,1) final_threshold(:,:,2)];
    %%
    
    
catch ME
    psychlasterror()
end