% Gabor and contour task for scanner
% written by Marcello A. Maniglia july 2021 %2017/2021
close all;
clear all;
clc;
commandwindow
%addpath('/Users/sll/Desktop/Flap/Flap_scripts/utilities')


addpath([cd '/utilities']);
try
    prompt={'Subject Name', 'day','site (UCR = 1; UAB = 2; UCR Vpixx = 3)', 'demo (0) or session (1)', 'Eyetracker(1) or not (0)'};
    
    name= 'Subject Name';
    numlines=1;
    defaultanswer={'test','1', '1', '0','0' };
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    expdayeye=str2num(answer{2,:});
    site= str2num(answer{3,:});  %0; 1=bits++; 2=display++
    demo=str2num(answer{4,:});
    EyeTracker = str2num(answer{5,:}); %0=mouse, 1=eyetracker
    %load (['../PRLocations/' name]);
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data');
    end
    %baseName=['./data/' SUBJECT '_FLAPcrowdingacuity4sc' expdayeye num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    
    if site==1
        baseName=['./data/' SUBJECT '_FLAP_Scanner' expdayeye num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[cd '\data\' SUBJECT '_FLAP_Scanner' num2str(expdayeye) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[cd '\data\' SUBJECT '__FLAP_ScannerVPixx' num2str(expdayeye) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    
    c=clock;
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    
    
    
    %     if EyeTracker==1
    %         EyetrackerType=1; %1 = Eeyelink, 2 = Vpixx
    %         eTracker = 0; % set to 1 for UAB code testing
    %     end
    fixat=1;
    fixationlength = 10; % pixels
    
    red=[255 0 0];
    
    StartSize=2; %for VA
    cueSize=3;
    circleSize=4.5;
    oneOrfourCues=1; % 1= 1 cue, 4= 4 cue
    fixwindow=2;
    fixTime=0.2;
    fixTime2=0.2;
    sigma_degBig=1;
    sigma_degSmall=.1;
    sfs=3;
    PRL1x=-7.5;
    PRL1y=0; %0.5;
    PRL2x=7.5;
    PRL2y=0; %-0.5;%7.5; %eccentricity of PRLs
    jitterCI=1;
    possibleoffset=[-2:2];
    Gamma=1; %Gamma value. Normally 2.2, but set to 1 if using other tool  for linearlization
    ExerTime=0 ; % If this is a 1 then break time will be ignored.
    JitRat=1; % amount of jit ration the larger the value the less jitter
    
    gaborcontrast=0.5;
    circularMasking=1; % if we want a circular masking around the contour
    %   PRLxx=[0 PRLecc 0 -PRLecc];
    %   PRLyy=[-PRLecc 0 PRLecc 0 ];
    %PRL_x_axis=-5;
    %PRL_y_axis=0;
    %NoPRL_x_axis=5;
    %NoPRL_y_axis=0;
    randomizeUnattended=1; % do we randomize the unattended stimulus or it will always be the other orientation?
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
    
    if demo ==0
        presentationtime=0.5133;
        trialnumber=5;
    elseif demo==1
        presentationtime=0.133;
        trialnumber=20;
    end
    ScotomaPresent = 0; % 0 = no scotoma, 1 = scotoma
    
    cue_spatial_offset=2;
    
    %% Set up Screen
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
        %PsychColorCorrection('SetLookupTable', w, lut_12bits); 
        [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
        %if you want to open a small window for debug
        %   [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
        %    Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        %Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
    elseif site==1 %UCR no bits
        
        %% psychtoobox settings
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
        
        oldResolution=Screen( 'Resolution',screenNumber,1280,1024);
        SetResolution(screenNumber, oldResolution);
        [w, wRect]=PsychImaging('OpenWindow',screenNumber, 0,[],32,2);
        
        screencm=[110 30];
        %debug window
        %    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
        %ScreenParameters=Screen('Resolution', screenNumber); %close all
        Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
        
    end
    
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    struct.sz=[screencm(1), screencm(2)];
    pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi));
    pix_deg_vert = pi * wRect(4) / atan(screencm(2)/v_d/2) / 360; %to calculate the limit of target position
    white=WhiteIndex(screenNumber);
    black=BlackIndex(screenNumber);
    gray=round((white+black)/2);
    if gray == white
        gray=white / 2;
    end;
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
        esleif
        
        % eye_used
        ScreenHeightPix=screencm(2)*pix_deg_vert;
        ScreenWidthPix=screencm(1)*pix_deg;
        %    VelocityThreshs = [250 2000];      	% px/sec
        VelocityThreshs = [20*pix_deg 60*pix_deg];      	% px/sec
        
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
    elseif EyeTracker ==0
        
        
        EyetrackerType=0; %1 = Eeyelink, 2 = Vpixx
        
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
    
    theCircles(1:nrw, round(nrw/2):nrw)=theCircles(nrw:-1:1, round(nrw/2):-1:1);
   
    theCircles = double(circle) .* double(theCircles)+bg_index * ~double(circle);
    theCircles=Screen('MakeTexture', w, theCircles);
    
    
    theDot=imread('thedot2.tiff');
    theDot=theDot(:,:,1);
    
    
    theDot=imresize(theDot,[nrw nrw],'bicubic');
    
    theDot = double(circle) .* double(theDot)+bg_index * ~double(circle);
    theDot=Screen('MakeTexture', w, theDot);
    
    
    load('S096_marl-nyu');
    
    
    rand('twister', sum(100*clock));
    
    %% response
    
    KbName('UnifyKeyNames');
    
    RespType(1) = KbName('LeftArrow');
    RespType(2) = KbName('RightArrow');
    RespType(3) = KbName('UpArrow');
    RespType(4) = KbName('DownArrow');
    
    
    %if ispc
    %    escapeKey = KbName('esc');	% quit key
    %elseif ismac
    escapeKey = KbName('ESCAPE');	% quit key
    %end
    
    
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
        
        eyeTrackerBaseName =[SUBJECT expdayeye];
        
        
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
    DrawFormattedText(w, 'report the orientation of the stimuli (left vs right) \n \n OR \n \n press left if 9, press right if 6 \n \n \n \n Press any key to start', 'center', 'center', white);
    Screen('Flip', w);
    KbQueueWait;
    %Screen('Flip', w);
    %WaitSecs(1.5);
    
    [xc, yc] = RectCenter(wRect);
    %     xlocs=[0 PRLecc 0 -PRLecc];
    %     ylocs=[-PRLecc 0 PRLecc 0 ];
    %
    eccentricity_X=[PRL1x PRL2x]*pix_deg;
    eccentricity_Y=[PRL1y PRL2y]*pix_deg;
    
    eccentricity_Xdeg=[PRL1x PRL2x];
    eccentricity_Ydeg=[PRL1y PRL2y];
    
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
    %  mixtrVA=mixtrVA(1:2,:);
    
    
    mixtrVA=[];
    % Contour integration stimuli
    %% settings for individual gabors and fixation point
    sigma_pixSmall = sigma_degSmall*pix_deg;
    imsizeSmall=sigma_pixSmall*2.5;
    sigma_pixBig = sigma_degBig*pix_deg;
    imsizeBig=sigma_pixBig*2.5;
    
    [x0Small,y0Small]=meshgrid(-imsizeSmall:imsizeSmall,-imsizeSmall:imsizeSmall);
    G = exp(-((x0Small/sigma_pixSmall).^2)-((y0Small/sigma_pixSmall).^2));
    [r, c] = size(G);
    midgray=0.5;
    %creating gabor images
    rot=0*pi/180; %redundant but theoretically correct
    maxcontrast=1; %0.15; %same
    for i=1:(length(sfs))  %bpk: note that sfs has only one element
        f_gabor=(sfs(i)/pix_deg)*2*pi;
        a=cos(rot)*f_gabor;
        b=sin(rot)*f_gabor;
        m=maxcontrast*sin(a*x0Small+b*y0Small+pi).*G;
        TheGaborsSmall(i)=Screen('MakeTexture', w, midgray+inc*m,[],[],2);
    end
    
    clear a b m f_gabor
    
    
    [x0Big,y0Big]=meshgrid(-imsizeBig:imsizeBig,-imsizeBig:imsizeBig);
    G = exp(-((x0Big/sigma_pixBig).^2)-((y0Big/sigma_pixBig).^2));
    for i=1:(length(sfs))  %bpk: note that sfs has only one element
        f_gabor=(sfs(i)/pix_deg)*2*pi;
        a=cos(rot)*f_gabor;
        b=sin(rot)*f_gabor;
        m=maxcontrast*sin(a*x0Big+b*y0Big+pi).*G;
        TheGaborsBig(i)=Screen('MakeTexture', w, midgray+inc*m,[],[],2);
    end
    
    
    %set the limit for stimuli position along x and y axis
    xLim=((wRect(3)-(2*imsize))/pix_deg)/2; %bpk: this is in degrees
    yLim=((wRect(4)-(2*imsize))/pix_deg_vert)/2;
    
    bg_index =round(gray*255); %background color
    
    %circular mask
    xylim = imsize; %radius of circular mask
    circle = x0Big.^2 + y0Big.^2 <= xylim^2;
    [nrw, ncl]=size(x0Big);

    xs=7;
    ys=7;
    
    %density 1 deg
    [x1,y1]=meshgrid(-xs:xs,-ys:ys); %possible positions of Gabors within grid; in degrees of visual angle
    
    %density 0.5 deg
    %[x1,y1]=meshgrid(-xs:0.5:xs,-ys:0.5:ys); %possible positions of Gabors within grid; in degrees of visual angle
    
    
    %density 0.8 deg
    %[x1,y1]=meshgrid(-xs:0.8:xs,-ys:0.8:ys); %possible positions of Gabors within grid; in degrees of visual angle
    
    
    xlocsCI=x1(:)';
    ylocsCI=y1(:)';
    
    %generate visual cue
    eccentricity_XCI=xlocsCI*pix_deg/2;
    eccentricity_YCI=ylocsCI*pix_deg/2;
     
    
    yfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  4];
    xfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1];
    orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 150] ;
    
    
    Xoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0];
    Yoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 1/4];
    
    Targx= [xfoo; -xfoo];
    Targy= [yfoo; -yfoo];
    
    Targori=[orifoo; orifoo];
    
    offsetx= [Xoff; -Xoff];
    offsety=[Yoff; -Yoff];
    
    for  ui=1:(tr_per_condition/PRLlocations)
        b=randperm(PRLlocations);
        mixtrCI=[mixtrVAsc1 b];
    end
    
    mixtrCI=[ mixtrCI' ones(length(mixtrCI),1)];%; mixtrVAsc2' ones(length(mixtrVAsc2),1)*2];
    mixtrCI=[ ones(trialnumber,1) ones(trialnumber,1);ones(trialnumber,1)*2 ones(trialnumber,1)  ];
    
    mixtrVA=mixtrCI;
    totalmixtr=length(mixtrVA)+length(mixtrCI);
    totalmixtr=[mixtrVA;mixtrCI ];
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
    scotomadeg=10;
    
    if site<3
        scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg_vert];
    elseif site==3
        scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
    end
    
    scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);

    scotoma_color=[200 200 200];
    FixDotSize=15;
%% Start Trials
    for totaltrial=1:length(totalmixtr)
        
        
        
        if  totaltrial<=length(mixtrVA)
            stimulusType=1;
        elseif totaltrial>length(mixtrVA)
            stimulusType=2;
        end
        trial=totaltrial;
        
        if  totaltrial==1 && totalmixtr(trial,1)==1 || totaltrial>1 && totalmixtr(trial,1)==1 &&  totalmixtr(trial-1,1)==2
            scanner_instructions_left
        end
        
        if  totaltrial==1 && totalmixtr(trial,1)==2 || totaltrial>1 && totalmixtr(trial,1)==2 &&  totalmixtr(trial-1,1)==1
            scanner_instructions_right
        end
        
        %     whichTask=3
        
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
        
        
        if stimulusType ==1
            
            theeccentricity_X=eccentricity_X(mixtrVA(trial,1));
            theeccentricity_Y=eccentricity_Y(mixtrVA(trial,1));
            
            
            theeccentricity_X2=-theeccentricity_X;
            theeccentricity_Y2=-theeccentricity_Y;
            
            imageRect = CenterRect([0, 0, size(x0Big)], wRect);
            theoris =[-45 45];
            
            theans(trial)=randi(2);
            
            if theans(trial)==1 %left
                ori=theoris(1);
                if randomizeUnattended==1
                    ori2=theoris(randi(2));
                elseif randomizeUnattended==0
                    ori2=theoris(2);
                end
            elseif theans(trial)==2 %right
                ori=theoris(2);
                if randomizeUnattended==1
                    ori2=theoris(randi(2));
                elseif randomizeUnattended==0
                    ori2=theoris(1);
                end
            end
        elseif stimulusType ==2
            
            
            theeccentricity_XCI=eccentricity_X(totalmixtr(trial,1));
            theeccentricity_YCI=eccentricity_Y(totalmixtr(trial,1));
            
            theeccentricity_XCI2=-theeccentricity_XCI;
            theeccentricity_YCI2=-theeccentricity_YCI;
            Oscat= 0.5; %JitList(thresh(Ts,Tc));
            
            imageRect = CenterRect([0, 0, size(x0Small)], wRect);
            % These are the individual rectangles for each Gabor within the array
            imageRect_offs =[imageRect(1)+eccentricity_XCI', imageRect(2)+eccentricity_YCI',...
                imageRect(3)+eccentricity_XCI', imageRect(4)+eccentricity_YCI'];
            
            sf=1;
            % texture(trial)=TheGabors(sf);
            Tscat=0;
            GoodBlock=0;
            Tc=1;
            xmax=2*xs+1; %total number of squares in grid, along x direction (17)
            ymax=2*ys+1; %total number of squares in grid, along x direction (13)
            
           
            xTrans=round(xmax/2); %Translate target left/right or up/down within grid
            yTrans=round(ymax/2);

            
            theans(trial)=randi(2); %generates answer for this trial
            
            if jitterCI==1
                jitterxci(trial)=possibleoffset(randi(length(possibleoffset)));
                jitteryci(trial)=possibleoffset(randi(length(possibleoffset)));
                newTargy= Targy+jitteryci(trial);
                newTargx= Targx+jitterxci(trial);
            elseif jitterCI==0
                newTargy= Targy;
                newTargx= Targx;
            end
            
            
            if theans(trial)==2
                targetcord =newTargy(2,:)+yTrans  + (newTargx(2,:)+xTrans - 1)*ymax;
                
                if randomizeUnattended==1
                    randcontour=randi(2);
                    targetcord2 =newTargy(randcontour,:)+yTrans  + (newTargx(randcontour,:)+xTrans - 1)*ymax;
                elseif randomizeUnattended==0
                    targetcord2 =newTargy(1,:)+yTrans  + (newTargx(1,:)+xTrans - 1)*ymax;
                end
            elseif theans(trial)==1
                targetcord =newTargy(1,:)+yTrans  + (newTargx(1,:)+xTrans - 1)*ymax;
                
                if randomizeUnattended==1
                    randcontour=randi(2);
                    targetcord2 =newTargy(randcontour,:)+yTrans  + (newTargx(randcontour,:)+xTrans - 1)*ymax;
                elseif randomizeUnattended==0
                    targetcord2 =newTargy(2,:)+yTrans  + (newTargx(2,:)+xTrans - 1)*ymax;
                end
            end
            

            xJitLoc=pix_deg*(rand(1,length(imageRect_offs))-.5)/JitRat; %plus or minus .25 deg
            yJitLoc=pix_deg*(rand(1,length(imageRect_offs))-.5)/JitRat;
            xJitLoc2=xJitLoc;
            yJitLoc2=yJitLoc;
            
            xModLoc=zeros(1,length(imageRect_offs));
            yModLoc=zeros(1,length(imageRect_offs));
            
            %jitter location except for target
            xJitLoc(targetcord)=Tscat*xJitLoc(targetcord);
            yJitLoc(targetcord)=Tscat*yJitLoc(targetcord);
            xJitLoc2(targetcord2)=Tscat*xJitLoc2(targetcord2);
            yJitLoc2(targetcord2)=Tscat*yJitLoc2(targetcord2);

            theori=180*rand(1,length(imageRect_offs));
            
            if theans(trial)==1
                theori(targetcord)=Targori(1,:) + (2*rand(1,length(targetcord))-1)*Oscat;
                if randomizeUnattended==1
                    theori(targetcord2)=Targori(randcontour,:) + (2*rand(1,length(targetcord))-1)*Oscat;
                    xJitLoc2(targetcord2)=(pix_deg*offsetx(randcontour,:))+xJitLoc2(targetcord2);
                    yJitLoc2(targetcord2)=(pix_deg*offsety(randcontour,:))+yJitLoc2(targetcord2);
                elseif randomizeUnattended==0
                    theori(targetcord2)=Targori(2,:) + (2*rand(1,length(targetcord))-1)*Oscat;
                    xJitLoc2(targetcord2)=(pix_deg*offsetx(2,:))+xJitLoc2(targetcord2);
                    yJitLoc2(targetcord2)=(pix_deg*offsety(2,:))+yJitLoc2(targetcord2);
                end
                xJitLoc(targetcord)=(pix_deg*offsetx(1,:))+xJitLoc(targetcord);
                yJitLoc(targetcord)=(pix_deg*offsety(1,:))+yJitLoc(targetcord);
                
            elseif theans(trial)==2
                theori(targetcord)=Targori(2,:) + (2*rand(1,length(targetcord))-1)*Oscat;
                if randomizeUnattended==1
                    theori(targetcord2)=Targori(randcontour,:) + (2*rand(1,length(targetcord))-1)*Oscat;
                    xJitLoc2(targetcord2)=(pix_deg*offsetx(randcontour,:))+xJitLoc2(targetcord2);
                    yJitLoc2(targetcord2)=(pix_deg*offsety(randcontour,:))+yJitLoc2(targetcord2);
                elseif randomizeUnattended==0
                    theori(targetcord2)=Targori(1,:) + (2*rand(1,length(targetcord))-1)*Oscat;
                    xJitLoc2(targetcord2)=(pix_deg*offsetx(1,:))+xJitLoc2(targetcord2);
                    yJitLoc2(targetcord2)=(pix_deg*offsety(1,:))+yJitLoc2(targetcord2);
                end
                xJitLoc(targetcord)=(pix_deg*offsetx(2,:))+xJitLoc(targetcord);
                yJitLoc(targetcord)=(pix_deg*offsety(2,:))+yJitLoc(targetcord);
                
                
            end
                      Tcontr=0.738; %0.5;
            Dcontr=0.38; %0.5;
            
        end
        
        Priority(0);
        buttons=0;
        eyechecked=0;
        KbQueueFlush()
        trial_time=-1000;
        stopchecking=-100;
        skipnonetetracker=0;
        trial_time=100000;
        
        pretrial_time=GetSecs;
        while eyechecked<1
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            
            if EyeTracker==1
                if (eyetime2-pretrial_time)>ifi*35 && (eyetime2-pretrial_time)<ifi*65 && fixating<fixTime/ifi && stopchecking>1
                    fixationscript3
                elseif  (eyetime2-pretrial_time)>=ifi*65 && fixating<fixTime/ifi && stopchecking>1
                    if site<3
                        IsFixating4
                    elseif site==3
                        IsFixating4pixx
                    end
                    fixationscript3
                elseif (eyetime2-pretrial_time)>ifi*65 && fixating>=fixTime/ifi && fixating<1000 && stopchecking>1
                    trial_time = GetSecs;
                    fixating=1500;
                end
            elseif EyeTracker==0
                if skipnonetetracker<1
                    fixating=1500;
                    stopchecking=10;
                    trial_time = GetSecs;
                    skipnonetetracker=1000;
                end
            end
            clear imageRect_offsCirc
            if (eyetime2-trial_time)>=waittime+ifi*2+cueonset && (eyetime2-trial_time)<waittime+ifi*2+cueonset+cueduration && fixating>400 && stopchecking>1
                
                
                clear imageRect_offs imageRect_offs2 imageRect_offs_flank1 imageRect_offs_flank2 imageRect_offsCI imageRect_offsCII
                
                %show cue
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration && (eyetime2-trial_time)<waittime+ifi*2+cueonset+cueduration+cueISI && fixating>400 && stopchecking>1
                
                %no cue
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+cueISI && (eyetime2-trial_time)<waittime+ifi*2+cueonset+cueduration+cueISI+presentationtime && fixating>400 && stopchecking>1
                
                
                if stimulusType==1
                    if exist('imageRect_offs')==0
                        imageRect_offs =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                            imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
                        
                        imageRect_offs2 =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X2, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y2,...
                            imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X2, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y2];
                        
                    end
                    Screen('DrawTexture', w, TheGaborsBig, [], imageRect_offs, ori,[], gaborcontrast);
                    Screen('DrawTexture', w, TheGaborsBig, [], imageRect_offs2, ori2,[], gaborcontrast);
                    
                    
                    imagearray{trial}=Screen('GetImage', w);
                    
                elseif stimulusType==2
                    
                    if exist('imageRect_offsCI')==0
                        

                        imageRect_offsCI =[imageRect(1)+(newsamplex-wRect(3)/2)+eccentricity_XCI'+theeccentricity_XCI, imageRect(2)+(newsampley-wRect(4)/2)+eccentricity_YCI'+theeccentricity_YCI,...
                            imageRect(3)+(newsamplex-wRect(3)/2)+eccentricity_XCI'+theeccentricity_XCI, imageRect(4)+(newsampley-wRect(4)/2)+eccentricity_YCI'+theeccentricity_YCI];
                        
                        imageRect_offsCII =[imageRect(1)+(newsamplex-wRect(3)/2)+eccentricity_XCI'+theeccentricity_XCI2, imageRect(2)+(newsampley-wRect(4)/2)+eccentricity_YCI'+theeccentricity_YCI,...
                            imageRect(3)+(newsamplex-wRect(3)/2)+eccentricity_XCI'+theeccentricity_XCI2, imageRect(4)+(newsampley-wRect(4)/2)+eccentricity_YCI'+theeccentricity_YCI];

                        imageRect_offsCI2=imageRect_offsCI;
                        imageRect_offsCII2=imageRect_offsCII;
                        imageRect_offsCI3=imageRect_offsCI;
                        
                       
                        
                        
                        if circularMasking==1
                            imageRectMask = CenterRect([0, 0, [ xs*1.75*pix_deg xs*1.75*pix_deg]], wRect);
                            
                            imageRect_offsCImask1=[imageRectMask(1)+theeccentricity_XCI, imageRectMask(2)+theeccentricity_YCI,...
                                imageRectMask(3)+theeccentricity_XCI, imageRectMask(4)+theeccentricity_YCI];
                            imageRect_offsCImask2=[imageRectMask(1)+theeccentricity_XCI2, imageRectMask(2)+theeccentricity_YCI2,...
                                imageRectMask(3)+theeccentricity_XCI2, imageRectMask(4)+theeccentricity_YCI2];
                            
                        end
                    end
                    
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
                    imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Tcontr );
                    
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCII' + [xJitLoc2+xModLoc; yJitLoc2+yModLoc; xJitLoc2+xModLoc; yJitLoc2+yModLoc], theori,[], Dcontr );
                    imageRect_offsCII2(setdiff(1:length(imageRect_offsCI),targetcord2),:)=0;
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCII2' + [xJitLoc2+xModLoc; yJitLoc2+yModLoc; xJitLoc2+xModLoc; yJitLoc2+yModLoc], theori,[], Tcontr );
                    
                    Screen('FrameOval', w,gray, imageRect_offsCImask2, 12, 60);
                    Screen('FrameOval', w,gray, imageRect_offsCImask1, 12, 60);
                    
                    
                    imagearray{trial}=Screen('GetImage', w);
                end
                stim_start = GetSecs;
                
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+cueISI+presentationtime && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0 && stopchecking>1 %present pre-stimulus and stimulus
                %   Screen('Close');
                
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+cueISI+presentationtime && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 %present pre-stimulus and stimulus
                eyechecked=10^4;
                
                thekeys = find(keyCode);
                if length(thekeys)>1
                    thekeys=thekeys(1);
                end
                thetimes=keyCode(thekeys);
                
                
                [secs  indfirst]=min(thetimes);
                respTime=GetSecs;
            end
            eyefixation5

            
            if ScotomaPresent == 1
                Screen('FillOval', w, scotoma_color, scotoma);
            else
                fixationlength=10;
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
                
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
        
        foo=(RespType==thekeys);
        
        if stimulusType ==1
            if foo(theans(trial))
                resp = 1;
                nswr(trial)=1;
                PsychPortAudio('Start', pahandle1);
                
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                ListenChar(0);
                break;
            else
                resp = 0;
                
                nswr(trial)=0;
                PsychPortAudio('Start', pahandle2);
                
            end
            
        elseif stimulusType ==2
            if foo(theans(trial))
                resp = 1;
                nswr(trial)=1;
                PsychPortAudio('Start', pahandle1);
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                ListenChar(0);
                break;
            else
                resp = 0;
                
                nswr(trial)=0;
                PsychPortAudio('Start', pahandle2);
                
            end
        end
        
        
        %   stim_stop=secs;
        time_stim(kk) = respTime - stim_start;
        totale_trials(kk)=trial;
        if stimulusType==1
            coordinate(totaltrial).x=theeccentricity_X/pix_deg;
            coordinate(totaltrial).y=theeccentricity_Y/pix_deg;
        elseif stimulusType==2
            coordinate(totaltrial).x=theeccentricity_XCI/pix_deg;
            coordinate(totaltrial).y=theeccentricity_YCI/pix_deg;
        end
        xxeye(totaltrial).ics=xeye;
        yyeye(totaltrial).ipsi=yeye;
        vbltimestamp(totaltrial).ix=VBL_Timestamp;
        flipptime(totaltrial).ix=fliptime;
        
        rispo(kk)=resp;

        
        cheis(kk)=thekeys;
        
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
            if stimulusType==1
                EyeSummary.(TrialNum).TargetX = theeccentricity_X/pix_deg;
                EyeSummary.(TrialNum).TargetY = theeccentricity_Y/pix_deg;
            elseif stimulusType==2
                EyeSummary.(TrialNum).TargetX=theeccentricity_XCI/pix_deg;
                EyeSummary.(TrialNum).TargetY=theeccentricity_YCI/pix_deg;
            end
            EyeSummary.(TrialNum).EventData = EvtInfo;
            clear EvtInfo
            EyeSummary.(TrialNum).ErrorData = ErrorData;
            clear ErrorData
            if stimulusType==1
                %     EyeSummary.(TrialNum).VA= Gaborsize;
            elseif stimulusType==2
                %   EyeSummary.(TrialNum).Separation = sep;
            end
            if exist('EndIndex')==0
                EndIndex=0;
            end
            EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
            clear EndIndex
            EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
            EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
            EyeSummary.(TrialNum).TimeStamps.Fixation = stim_start;
            EyeSummary.(TrialNum).TimeStamps.Stimulus = stim_start;
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
        
    end
    %% Clean up
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
    
    
catch ME
    'There was an error caught in the main program.'
    psychlasterror()
end