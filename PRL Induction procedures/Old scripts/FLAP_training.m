% Visual Acuity/Crowding/cued-uncued attention task
% written by Marcello A. Maniglia july 2021 %2017/2021
close all; clear all; clc;
commandwindow
%addpath('/Users/sll/Desktop/Flap/Flap_scripts/utilities')


addpath([cd '/utilities']);
try
    prompt={'Subject Name', 'day','site (UCR = 1; UAB = 2)', 'training type'};
    
    name= 'Subject Name';
    numlines=1;
    defaultanswer={'test','0', '1', '2' };
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    
    penalizeLookaway=1;
    %   if answer{2,:}=='test'
    %      expdayeye=answer{2,:};
    %  else
    expdayeye=str2num(answer{2,:});
    site = str2num(answer{3,:});
    trainingType=str2num(answer{4,:});
    %load (['../PRLocations/' name]);
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    baseName=['./data/' SUBJECT '_FLAPtraining_type_' num2str(trainingType) '_Day_' answer{2,:} '_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    
    eyeOrtrack=1; %0=mouse, 1=eyetracker
    
    if eyeOrtrack==1
        EyeTracker = 1; % set to 1 for UAB code testing
        EyetrackerType=1;
        
    elseif eyeOrtrack==0
        EyeTracker = 0; % set to 1 for UAB code testing
    end
    fixat=1;
    fixationlength = 40; % pixels
    
    red=[255 0 0];
    
    %stimulusSize=1.5;
    
    stimulusSize = 2.5;
    
    sigma_deg = stimulusSize/2.5;
    holdtrial = 1;
    cueSize = 3;
    
    annulusOrPRL = 2; % in training types in which we force fixation before target appearance,
    %do we want fixation within an annulus or within their PRL?
    trialTimeout = 8;
    realtrialTimeout = trialTimeout;
    oneOrfourCues=1; % 1= 1 cue, 4= 4 cue
    fixwindow=2;
    fixTime=0.2;
    %how long do they need to keep fixation near the pre-target element
    AnnulusTime = 2/3;
    %FlickerTime=
    Jitter = [2:0.05:5];
    fixTime2 = 0.2;
    flickeringrate = 0.25;
    targetecc = 10; %2;         %7.5; %eccentricity of PRLs
    %   PRLxx=[0 PRLecc 0 -PRLecc];
    %   PRLyy=[-PRLecc 0 PRLecc 0 ];
    %PRL_x_axis=-5;
    %PRL_y_axis=0;
    %NoPRL_x_axis=5;
    %NoPRL_y_axis=0;
    PRLsize = 5; % diameter PRL
    % training type 2 info
    jitterCI=1;
    possibleoffset=[-1:1];
    
    %possibleoffset=[-1:1];
    
    Screen('Preference', 'SkipSyncTests', 1);
    PC=getComputerName();
    n_blocks=1;
    numstudydays=10;
    
    closescript=0;
    kk=1;
    
    cueonset=0.55; %time between beginning of trial and cue apparition (when we need a switch cue)
    cueduration=0.5; %0.05 % duration of cue when we have a cue (otherwise it's a blank interval)
    exoendoCueDur=0.1; %0.01 %duration of exo/endo cue before target appearance for training type 3 and 4
    postCueISI=0.1; % time interval between cue disappearance and target appearance
    % FlickerTime=0.133;
    ScotomaPresent = 1; % 0 = no scotoma, 1 = scotoma
    
    cue_spatial_offset=2;
    bg_index =round(gray*255); %background color
    
    test=1;
    if site==0  %UCR bits++
        %% psychtoobox settings
        screencm=[40.6 30];
        load gamma197sec;
        v_d=110;
        radius=12.5;   %radius of the circle in which the target can appear
        
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
    elseif site==1 % UCR + bits
        crt=0;
        radius=15.5;   %radius of the circle in which the target can appear
        
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
          %  [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
                         [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);

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
        radius=17.5;   %radius of the circle in which the target can appear
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
    end
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    struct.sz=[screencm(1), screencm(2)];
    
    pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi));
    pix_deg_vert = pi * wRect(4) / atan(screencm(2)/v_d/2) / 360;
    white=WhiteIndex(screenNumber);
    black=BlackIndex(screenNumber);
    
    white=1;
    black=0;
    
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
    % SOUND
    InitializePsychSound;
    pahandle = PsychPortAudio('Open', [], 1, 0, 44100, 2);
    pahandle1 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    pahandle2 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
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
    %imsize=stimulusSize*pix_deg;
    
    %% STIMULI
    
    PreparePRLpatch
    sigma_pix = sigma_deg*pix_deg;
    imsize=(sigma_deg*pix_deg*2.5)/2;
    [ax,ay]=meshgrid(-imsize:imsize,-imsize:imsize);
    r_lim=((radius*pix_deg)-(imsize))/pix_deg;
    xylim = imsize; %radius of circular mask
    if trainingType==1 || trainingType==4
        max_contrast=1;
        %Gabor
        sflist=[1 2 3 4:2:18]; %check
        G = exp(-((ax/sigma_pix).^2)-((ay/sigma_pix).^2));
        fixationlength = 10; % pixels
        [r, c] = size(G);
        phases= [pi, pi/2, 2/3*pi, 1/3*pi];
        
        %circular mask
        circle = ax.^2 + ay.^2 <= xylim^2;
        rot=0*pi/180; %redundant but theoretically correct
        Gmaxcontrast=1; %same
        for i=1:(length(sflist))
            for g=1:length(phases)
                f_gabor=(sflist(i)/pix_deg)*2*pi;
                a=cos(rot)*f_gabor;
                b=sin(rot)*f_gabor;
                m=Gmaxcontrast*sin(a*ax+b*ay+phase(phases(g))).*G;
                m=m+gray;
                m = double(circle) .* double(m)+gray * ~double(circle);
                TheGabors(i,g)=Screen('MakeTexture', w, m,[],[],2);
            end;
        end;
        
        oval_thick=5; %thickness of oval
        CircConts=[0.51,1]*255; %low/high contrast circular cue
        
        xLim=(((35*pix_deg)-(2*imsize))/pix_deg)/2;
        yLim=(((35*pix_deg)-(2*imsize))/pix_deg_vert)/2;
        
        %radius=17.5;   %radius of the circle in which the target can appear
    end
    if trainingType==2 || trainingType==4
        
        %contour integration
        clear a b m f_gabor
        sigma_degSmall=0.1;
        sfs=3;
        sigma_pixSmall = sigma_degSmall*pix_deg;
        imsizeSmall=sigma_pixSmall*2.5;
        
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
        %set the limit for stimuli position along x and y axis
        xLim=((wRect(3)-(2*imsize))/pix_deg)/2; %bpk: this is in degrees
        yLim=((wRect(4)-(2*imsize))/pix_deg_vert)/2;
        
        bg_index =round(gray*255); %background color
        
        %circular mask
        %xylim = imsize; %radius of circular mask
        
        % size of the grid for the contour task
        xs=7;%60; 12;
        ys=7; %45;9;
        
        %density 0.8 deg
        % [x1,y1]=meshgrid(-xs:0.8:xs,-ys:0.8:ys); %possible positions of Gabors within grid; in degrees of visual angle
        [x1,y1]=meshgrid(-xs:xs,-ys:ys); %possible positions of Gabors within grid; in degrees of visual angle
        
        JitRat=1; % amount of jit ratio (the larger the value the less jitter)
        Oscat= 0.5; %JitList(thresh(Ts,Tc));
        
        xlocsCI=x1(:)';
        ylocsCI=y1(:)';
        
        %generate visual cue
        eccentricity_XCI=xlocsCI*pix_deg/2;
        eccentricity_YCI=ylocsCI*pix_deg/2;
        
        % r=1;
        % C =[0 0];
        % theta=0:2*pi/12:2*pi;
        % m=r*[cos(theta')+C(1) sin(theta') + C(2)];
        % m=[m; 0.8 -1; 0.4 -1.5; 0 -2];
        % m_six=[-m(:,1) m(:,2)];
        % m_six=m_six.*pix_deg;
        %
        % m_nine=[m(:,1) -m(:,2)];
        % m_nine=m_nine.*pix_deg;
        
        %target contrast
        Tcontr=0.38;
        %distractor contrast
        Dcontr=0.38;
        
CIShapes
end


    %end
    
    
    if trainingType>1
        %   imsize=(sigma_deg*pix_deg*2.5)/2;
        %imsize=StartSize*pix_deg;
        [x,y]=meshgrid(-imsize/2:imsize/2,-imsize/2:imsize/2);
        %circular mask
        %   xylim = imsize; %radius of circular mask
        circle = x.^2 + y.^2 <= xylim^2;
        [nrw, ncl]=size(x);
        %theLetter=imread('letter_c2.tiff');
        theLetter=imread('newletterc22.tiff');
        theLetter=theLetter(:,:,1);
        theLetter=imresize(theLetter,[nrw nrw],'bicubic');
        theCircles=theLetter;
        
        theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
        theLetter=Screen('MakeTexture', w, theLetter);
        %         if  mod(nrw,2)==0
        %             theCircles(1:nrw, nrw/2:nrw)=theCircles(nrw:-1:1, (nrw/2+1):-1:1);
        %         elseif mod(nrw,2)>0
        %             theCircles(1:nrw, nrw/2:nrw)=theCircles(nrw:-1:1, (nrw/2):-1:2);
        %         end
        
        % if  mod(length(theCircles)/2,2)==0
        %     theCircles(1:nrw, round(nrw/2):nrw)=theCircles(nrw:-1:1, round(nrw/2):-1:1);
        % elseif  mod(length(theCircles)/2,2)>0
        %     theCircles(1:nrw, nrw/2:nrw)=theCircles(nrw:-1:1, (nrw/2+1):-1:1);
        % end
        
%         theArrow=imread('letter_l2.tiff');
%         theArrow=theArrow(:,:,1);
%         theArrow=imresize(theArrow,[nrw nrw],'bicubic');
%         
%         theArrow = double(circle) .* double(theArrow)+bg_index * ~double(circle);
%         theArrow=Screen('MakeTexture', w, theArrow);
        
                theArrow=imread('Arrow.png');
        theArrow=theArrow(:,:,1);
        theArrow=imresize(theArrow,[nrw nrw],'bicubic');
        
        theArrow = double(circle) .* double(theArrow)+bg_index * ~double(circle);
        theArrow=Screen('MakeTexture', w, theArrow);
        
        if  mod(nrw,2)==0
            theCircles(1:nrw, nrw/2:nrw)=theCircles(nrw:-1:1, (nrw/2+1):-1:1);
        elseif  mod(nrw,2)>0
            theCircles(1:nrw, nrw/2:nrw)=theCircles(nrw:-1:1, round((nrw/2)):-1:1);
        end        
  
        theCircles = double(circle) .* double(theCircles)+bg_index * ~double(circle);
        theCircles=Screen('MakeTexture', w, theCircles);
        
        theTest=imread('target_black.tiff');
        theTest=theTest(:,:,1);
        theTest=Screen('MakeTexture', w, theTest);
        [img, sss, alpha] =imread('neutral21.png');
        img(:, :, 4) = alpha;
        Neutralface=Screen('MakeTexture', w, img);
    end
 
    % corrS=zeros(size(errorS));
    load('S096_marl-nyu');
    
    
    rand('twister', sum(100*clock));
    
    %% response
    white=WhiteIndex(screenNumber);
    black=BlackIndex(screenNumber);
    gray=round((white+black)/2);
    if gray == white
        gray=white / 2;
    end
    KbName('UnifyKeyNames');
    
    RespType(1) = KbName('LeftArrow');
    RespType(2) = KbName('RightArrow');
    RespType(3) = KbName('UpArrow');
    RespType(4) = KbName('DownArrow');
    
    
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
    
    if EyeTracker==1
        useEyeTracker = 0; % otherwise will throw error if not UAB run
        
        %eyeTrackerBaseName=[SUBJECT '_DAY_' num2str(expday) '_CAT_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
        %eyeTrackerBaseName = 's00';
        eyeTrackerBaseName =[SUBJECT expdayeye];
        
        %  save_dir= 'C:\Users\labadmin\Desktop\marcello AMD assessment\7.Training\test_eyetracker_files';
    
        % eye_used
        ScreenHeightPix=screencm(2)*pix_deg_vert;
        ScreenWidthPix=screencm(1)*pix_deg;
        %VelocityThreshs = [250 2000];      	% px/sec
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
               PixelsPerDegree=pix_deg;

        if exist('dataeyet')==0
            mkdir('dataeyet');
        end;
        save_dir=[cd './dataeyet/'];
        % old variables
        [winCenter_x,winCenter_y]=RectCenter(wRect);
        backgroundEntry = [0.5 0.5 0.5];
        % height and width of the screen
        winWidth  = RectWidth(wRect);
        winHeight = RectHeight(wRect);
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
    %% TRIAL MATRIX
    
    if trainingType==1
        conditionOne=1; %only Gabors 
        conditionTwo=1;
        trials=500;  %total number of trials per staircase      
    elseif trainingType==2
        shapes=6;
        conditionOne=shapes; % shapes (training type 2)
        conditionTwo=1;
                trials=83;  %total number of trials per staircase
                        % stimulus parameters
        JitList = 0:2:90;
        StartJitter=16;
    elseif trainingType==3
        conditionOne=1; %only landolt C
        conditionTwo=2; % endogenous or exogenous cue
        trials=10;
    elseif trainingType==4
        conditionOne=2; %gabors or contours
        conditionTwo=2; % high or low visibility cue
        trials=125;
    end
    
%     if trainingType==1 || trainingType==2 || trainingType==4
%         blocks=10;  %number of blocks in which we want the trials to be divided       
%         %number of conditions
%         condlist=fullfact([conditionOne conditionTwo]);
% %         if
% % numsc=1;
% %         else
% %             numsc=length(condlist);
% % 
% %         end
% 
% if conditionOne==1 &&  conditionOne==2
%     numsc=1;
% else
% numsc=length(condlist);
% end
% if length (condlist(:,1))<2
%             mixcond=condlist;
%         else
%             mixcond=condlist(randperm(length(condlist)),:);
%         end;
%         n_blocks=round(trials/blocks);   %number of trials per miniblock
%         mixtr=[];
%     end
%     if trainingType==4
%         %condition matrix gabor and faces
%         for j=1:blocks
%             % mixcond=condlist(randperm(length(condlist)),:);
%             for i=1:numsc
%                 mixtr=[mixtr;repmat(mixcond(i,:),n_blocks,1)];
%             end;
%         end;
%     elseif trainingType==1 || trainingType==2
%         for j=1:blocks
%             % mixcond=condlist(randperm(length(condlist)),:);
%             for i=1:numsc
%                 mixtr=[mixtr;repmat(mixcond,n_blocks,1)];
%             end;
%         end;
%     end;
%     
    
    
    
    if trainingType<3
                    mixcond=fullfact([conditionOne conditionTwo]);
mixtr=[];
        for ui=1:conditionOne
           mixtr=[mixtr; repmat(mixcond(ui,:),trials,1) ];
        end
    end
    
    if trainingType==3
        angolo= [90 45 0 315 270 225 180 135];
        mixtr=[repmat(1:length(angolo),1,trials)'];
        mixtr =mixtr(randperm(length(mixtr)),:);
    end
%                     mixcond=fullfact([conditionOne conditionTwo]);
% mixtr=[];
%         for ui=1:conditionOne
%            mixtr=[mixtr; repmat(mixcond(ui,:),trials,1) ]
%         end
%     end
%     
    
    %% STAIRCASE
    
    nsteps=70;
    
    %     if trainingType==1 || trainingType==4
    
    if trainingType~=3
        % stimulus parameters
        if trainingType==1
            Contlist = log_unit_down(max_contrast+.122, 0.05, nsteps);
            Contlist(1)=1;
            SFthreshmin=0.01;
            StartCont=15;  %15
            SFthreshmax=Contlist(StartCont);
            SFadjust=10;
            % if expdayeye==0 || expdayeye==1 || expdayeye==numstudydays || expdayeye==numstudydays+1 %|| sum(expdayeye=='test')> 1
            thresh(1:conditionOne, 1:conditionTwo)=StartCont; %Changed from 10 to have same starting contrast as the smaller Contlist
            step=5;
            if site<2
                %  currentsf=sflist(4);
                currentsf=4;
            elseif site==2
                %   currentsf=sflist(1);
                currentsf=1;
                numstudydays=100;
            end
        end
        if trainingType==2
            thresh(1:conditionOne, 1:conditionTwo)=StartJitter;
        end
        reversals(1:conditionOne, 1:conditionTwo)=0;
        isreversals(1:conditionOne, 1:conditionTwo)=0;
        staircounter(1:conditionOne, 1:conditionTwo)=0;
        corrcounter(1:conditionOne, 1:conditionTwo)=0;
        
        % Threshold -> 79%
        sc.up = 1;                          % # of incorrect answers to go one step up
        sc.down = 3;                        % # of correct answers to go one step down
        
        %     else
        %         d = dir(['./data/' SUBJECT '_DAY_' num2str(expdayeye-1) '*.mat']);
        %         [dx,dx] = sort([d.datenum]);
        %         newest = d(dx(end)).name;
        %         oldthresh=load(['./data/' newest],'thresh');
        %         currentsfold=load(['./data/' newest],'currentsf');
        %         if isempty(fieldnames(currentsfold))
        %             if BITS<2
        %                 %   currentsf=sflist(4);
        %                 currentsf=4;
        %             elseif BITS==2
        %                 %   currentsf=sflist(1);
        %                 currentsf=1;
        %                 numstudydays=100;
        %             end
        %         else
        %             currentsf=currentsfold.currentsf;
        %         end
        %
        %         thresh(1:conditionOne, 1:conditionTwo)=oldthresh.thresh(1:conditionOne, 1:conditionTwo)-2;
        %         step=1;
        %     end;
        
        
        stepsizes=[4 4 3 2 1];
        
    end
    %      end
    
    %% Trial structure
    scotomadeg=10;
    scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg_vert];
    scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
    %  imageRect = CenterRect([0, 0, stimulusSize*pix_deg stimulusSize*pix_deg], wRect);
    imageRect = CenterRect([0, 0, size(ax)], wRect);
    
    if trainingType==2 || trainingType==4
        imageRectSmall = CenterRect([0, 0, size(x0Small)], wRect);
        
        imageRect_offsSmall =[imageRect(1)+eccentricity_XCI', imageRect(2)+eccentricity_YCI',...
            imageRect(3)+eccentricity_XCI', imageRect(4)+eccentricity_YCI'];
        
        ssf=1;
        % texture(trial)=TheGabors(sf);
        Tscat=0; %but we will define the jitter threshold later
        GoodBlock=0;
        Tc=1;
        xmax=2*xs+1; %total number of squares in grid, along x direction (17)
        ymax=2*ys+1; %total number of squares in grid, along x direction (13)
        
        xTrans=round(xmax/2); %Translate target left/right or up/down within grid
        yTrans=round(ymax/2);
        
    end
    
    %     if trainingType~=1
    %     ecc_r=targetecc*pix_deg;
    %
    %     angolo= [90 45 0 315 270 225 180 135];
    %
    %     for ui=1:length(angolo)
    %         %if we want to randomize the angle and the radius of the
    %         %target location
    %         % ecc_r=r_lim.*rand(1,1);
    %         %  ecc_t=2*pi*rand(1,1);
    %         ecc_t=deg2rad(angolo(ui));
    %         cs= [cos(ecc_t), sin(ecc_t)];
    %         xxyy=[ecc_r ecc_r].*cs;
    %         ecc_x=xxyy(1);
    %         ecc_y=xxyy(2);
    %         eccentricity_X(ui)=ecc_x;
    %         eccentricity_Y(ui)=ecc_y;
    %     end
    %     end
    
    
    
    if trainingType==1
        eccentricity_X= zeros(length(mixtr),1);
        eccentricity_Y= zeros(length(mixtr),1);
    elseif trainingType==2 %trainingType==2 || trainingType==4
        for ui=1:length(mixtr)
            %if we want to randomize the angle and the radius of the
            %target location
            ecc_r=(r_lim*pix_deg).*rand(1,1);
            ecc_t=2*pi*rand(1,1);
            % ecc_t=deg2rad(angolo(ui));
            cs= [cos(ecc_t), sin(ecc_t)];
            xxyy=[ecc_r ecc_r].*cs;
            ecc_x=xxyy(1);
            ecc_y=xxyy(2);
            eccentricity_X(ui)=ecc_x;
            eccentricity_Y(ui)=ecc_y;
        end
    elseif trainingType>2
        
        
        ecc_r=targetecc*pix_deg;
        
        
        for ui=1:length(angolo)
            %if we want to randomize the angle and the radius of the
            %target location
            % ecc_r=r_lim.*rand(1,1);
            %  ecc_t=2*pi*rand(1,1);
            ecc_t=deg2rad(angolo(ui));
            cs= [cos(ecc_t), sin(ecc_t)];
            xxyy=[ecc_r ecc_r].*cs;
            ecc_x=xxyy(1);
            ecc_y=xxyy(2);
            eccentricity_X(ui)=ecc_x;
            eccentricity_Y(ui)=ecc_y;
        end

        
        
        thecuemat=[ones(length(mixtr)/2,1); ones(length(mixtr)/2,1)*2];
                thecuemat =thecuemat(randperm(length(thecuemat)),:);

        
       % mixtr=[mixtr ones(length(mixtr),1)];
        mixtr= [mixtr thecuemat];

        
if holdtrial==1
     reptrial=10;
        newmat=[];
        newcue=[];
cuetype=[ones(reptrial*length(angolo),1); ones(reptrial*length(angolo),1)*2];

        cuetype =cuetype(randperm(length(cuetype)),:);

    for i=1:reptrial
        
    totcoord=[1:length(angolo)];
    firstone=totcoord(randi(length(totcoord)));
    newfirstone=firstone;
    newlist=totcoord;
    conte(i)=0;
    done(i)=0;
        kok=0;
    while done(i)<1
        %          if exist('dio')==0
        %          newfirstone=firstone;
        %          dio=1;
        %          end
        
        repnum=randi(4)+2;
        tempmat=repmat([newfirstone],repnum,1);
        newmat=[newmat;tempmat];
        kok=kok+1;
                tempmatcue=repmat(cuetype(kok),repnum,1);
        newcue=[newcue;tempmatcue];

        depl=newlist~=newfirstone;
        
        newlist=newlist(depl);
        if isempty(newlist)
            done=1;
            break
        end
        newfirstone=newlist(randi(length(newlist)));
        conte(i)=conte(i)+1;      
        
    end
end
      
           mixtr=[newmat  newcue];
             
end
     
    end
    


    [xc, yc] = RectCenter(wRect);
    
    % assign PRL
    
    [sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);
    
    %radiusPRL=(scotomasize/2)*pix_deg;
    % annulus for pre-target fixation
    smallradiusannulus=(scotomadeg/2)*pix_deg; %+pix_deg/2 %+1*pix_deg;
    largeradiusannulus=smallradiusannulus+3*pix_deg;
    
    circlePixels=sx.^2 + sy.^2 <= largeradiusannulus.^2;
    circlePixels2=sx.^2 + sy.^2 <= smallradiusannulus.^2;
    
    d=(circlePixels2==1);
    newfig=circlePixels;
    newfig(d==1)=0;
    circlePixels=newfig;
    
    
    if trainingType>2
        %assigned PRL circle
        PRLradius=(PRLsize/2)*pix_deg;
        circlePixels3=sx.^2 + sy.^2 <= PRLradius.^2;
    end
    
    %% main loop
    HideCursor;
    counter = 0;
    if test==0
    ListenChar(2);
    end
    fixwindowPix=fixwindow*pix_deg;
    WaitSecs(1);
    % Select specific text font, style and size:
    Screen('TextFont',w, 'Arial');
    Screen('TextSize',w, 42);
    %     Screen('TextStyle', w, 1+2);
    Screen('FillRect', w, gray);
    colorfixation = white;
    % general instruction
    if trainingType==1
        DrawFormattedText(w, 'Press the arrow key (left vs right) \n \n to indicate the orientation of the grating \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif trainingType==2
        DrawFormattedText(w, 'Press the left arrow key if you see a 9 \n \n Press  the right arrow key if you see a 6  \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif trainingType==3
        DrawFormattedText(w, 'keep the target near the border of the scotoma \n \n for 2 seconds. \n \n Press  the arrow key when the circle turns into a C \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif trainingType==4
        DrawFormattedText(w, 'keep the target near the border of the scotoma \n \n for 2 seconds. \n \n when the target changes into a grating or a contour \n \n Press  the left or right arrow key \n \n to indicate its orientation   \n \n \n \n Press any key to start', 'center', 'center', white);
    end
    Screen('Flip', w);
    KbQueueWait;
    %Screen('Flip', w);
    %WaitSecs(1.5);
    
    
    % check EyeTracker status
    if EyeTracker == 1
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
    widthWag=20;
    diagon=0;
    FixDotSize=15;
    

%mixtr= [[7 1 3 5 7 1]; [1 1 1 1 1 1]]';
% mixtr=[1 1; 1 2; 3 1; 4 2; 5 1]
    for trial=1:length(mixtr)
        if trial==1
            startExp=GetSecs;
        end
        if trial==length(mixtr)
            endExp=GetSecs;
        end
        
                kkk=0;

        trialTimedout(trial)=0;
        circlefix=0;
        
        if trial== length(mixtr)/8 %|| trial== length(mixtr)/4 || trial== length(mixtr)/4
            interblock_instruction
        end
        
        if trainingType==1 || trainingType==4 && mixtr(trial,1)==1
            %           ori_i(trial)=2*theans(trial) +randi(2)-2;
            %     ori= theoris(ori_i(trial));
            ssf=sflist(currentsf);
            fase=randi(4);
            %     texture(trial)=TheGabors(sf, fase);
            texture(trial)=TheGabors(currentsf, fase);
            contr = Contlist(thresh(mixtr(trial,1),mixtr(trial,2)));
            %      contr=0.7;
        end
        
        if trainingType==2 || trainingType==4 && mixtr(trial,1)==2
            
            %   Tscat=1-JitList(thresh(mixtr(trial,1),mixtr(trial,2)));
            
            Orijit=JitList(thresh(mixtr(trial,1),mixtr(trial,2)));
            %Orijit=0;
            Tscat=0;
            %  Oscat=1-JitList(thresh(Ts,Tc));
            
        end
        
        if trainingType==4
            ContCirc= CircConts(mixtr(trial,2));
        end
        
        if trainingType>2
            FlickerTime=Jitter(randi(length(Jitter)));
            actualtrialtimeout=realtrialTimeout;
            trialTimeout=400000;
        elseif trainingType<3
            FlickerTime=0;
        end
        
        
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
        mostratarget=0;
        countertarget=0;
        
        if trainingType==1
            theeccentricity_X=0;
            theeccentricity_Y=0;
        elseif  trainingType==2
            theeccentricity_X=eccentricity_X(trial);
            theeccentricity_Y=eccentricity_Y(trial);
        elseif trainingType>2
            theeccentricity_X=eccentricity_X(mixtr(trial,1));
            theeccentricity_Y=eccentricity_Y(mixtr(trial,1));
        end
        
        %  if trainingType~=2
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
        %     end
        
        if trainingType==3
            theoris =[-180 0 -90 90];
            
            theans(trial)=randi(4);
            
            ori=theoris(theans(trial));
        elseif trainingType==1 ||  trainingType==4
            %      theoris =[-90 90];
            theoris =[-45 45];
            theans(trial)=randi(2);
            ori=theoris(theans(trial));
            
        elseif trainingType==2
            theans(trial)=randi(2); %generates answer for this trial
            %             if theans(trial)==2
            %                 eccentricity_XCIsmooth=m_six(:,1);
            %                 eccentricity_YCIsmooth=m_six(:,2);
            %             elseif theans(trial)==1
            %                 eccentricity_XCIsmooth=m_nine(:,1);
            %                 eccentricity_YCIsmooth=m_nine(:,2);
            %             end
            
            %jittering location of the target within the patch of distractors
            
            if jitterCI==1
                jitterxci(trial)=possibleoffset(randi(length(possibleoffset)));
                jitteryci(trial)=possibleoffset(randi(length(possibleoffset)));
                
            elseif jitterCI==0
                jitterxci(trial)=0;
                jitteryci(trial)=0;
            end
            
            
            
            % here I define the shapes
            
           % shapesoftheDay=shapeMatrix{expdayeye};
            
            load shapeMat.mat;      
            shapesoftheDay=shapeMat(:,expdayeye);
           %R newTargy= Targy{mixtr(trial,1)}+jitteryci(trial);
           %R newTargx= Targx{mixtr(trial,1)}+jitterxci(trial);
            
                        newTargy= Targy(shapesoftheDay{mixtr(trial,1)})+jitteryci(trial);

                        newTargx= Targx(shapesoftheDay{mixtr(trial,1)})+jitterxci(trial);

       newTargy=Targy{shapesoftheDay(mixtr(trial,1))}+jitteryci(trial);
                   newTargx=Targx{shapesoftheDay(mixtr(trial,1))}+jitterxci(trial);

            
            
            targetcord =newTargy(theans(trial),:)+yTrans  + (newTargx(theans(trial),:)+xTrans - 1)*ymax;
            
            xJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
            yJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;
            
            xModLoc=zeros(1,length(eccentricity_XCI));
            yModLoc=zeros(1,length(eccentricity_XCI));
            
            
            %jitter location except for target
            %     xJitLoc(targetcord)=Tscat*xJitLoc(targetcord);
            %     yJitLoc(targetcord)=Tscat*yJitLoc(targetcord);
            
            %     xJitLoc(targetcord)=(pix_deg*offsetx(theans(trial),:))+xJitLoc(targetcord);
            %     yJitLoc(targetcord)=(pix_deg*offsety(theans(trial),:))+yJitLoc(targetcord);
            
            
            xJitLoc(targetcord)=pix_deg*shapesoftheDay(offsetx{mixtr(trial,1)}(theans(trial),:));%+xJitLoc(targetcord);
            yJitLoc(targetcord)=pix_deg*shapesoftheDay(offsety{mixtr(trial,1)}(theans(trial),:));%+yJitLoc(targetcord);
            
            
            
           %R             xJitLoc(targetcord)=pix_deg*offsetx{mixtr(trial,1)}(theans(trial),:);%+xJitLoc(targetcord);
          %R  yJitLoc(targetcord)=pix_deg*offsety{mixtr(trial,1)}(theans(trial),:);%+yJitLoc(targetcord);

            
            theori=180*rand(1,length(eccentricity_XCI));
            %       theori(targetcord)=Targori(theans(trial),:) + (2*rand(1,length(targetcord))-1)*Oscat;
            
            %jitter orientation, except for that of target + add the staircase
            %jitter
            
            %theori(targetcord)=Targori(theans(trial),:) +Orijit + (2*rand(1,length(targetcord))-1)*Oscat;
            
           %R theori(targetcord)=Targori{mixtr(trial,1)}(theans(trial),:) +Orijit;
           
           theori(targetcord)=Targori(shapesoftheDay{mixtr(trial,1)}(theans(trial),:)) +Orijit;
            if test==1
                     %      theori(targetcord)=Targori{mixtr(trial,1)}(theans(trial),:);
           theori(targetcord)=Targori(shapesoftheDay{mixtr(trial,1)}(theans(trial),:));

            end
        end
        
        Priority(0);
        buttons=0;
        eyechecked=0;
        KbQueueFlush();
        trial_time=-1000;
        stopchecking=-100;
        trial_time=100000;
        pretrial_time=GetSecs;
        trial_time=GetSecs;
        % clear temptrial
        while eyechecked<1
            
            %             if (eyetime2-pretrial_time)>ifi*35 && (eyetime2-pretrial_time)<ifi*65 && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
            %                 timein=GetSecs;
            %                 fixationscript2
            %             elseif  (eyetime2-pretrial_time)>=ifi*65 && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
            %                 IsFixating4
            %                 fixationscript2
            %             elseif (eyetime2-pretrial_time)>ifi*65 && fixating>=fixTime/ifi && fixating<1000 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
            %                 trial_time = GetSecs;
            %                 fixating=1500;
            %             end
            fixating=1500;
            %             if exist('temptrial')==0
            %                trial_time= GetSecs;
            %             end
            
            
                            if trainingType>2 && trial>1
                    if mixtr(trial,1)~=mixtr(trial-1,1) % ||  trial==1
                        if mixtr(trial,2)==1 %endogenous cue calculations
                            nexcoordx=(imageRect_offs(1)+imageRect_offs(3))/2;
                            nexcoordy=(imageRect_offs(2)+imageRect_offs(4))/2;
                            previouscoordx=(rectimage{kk-1}(1)+rectimage{kk-1}(3))/2;
                            previouscoordy=(rectimage{kk-1}(2)+rectimage{kk-1}(4))/2;
                            
                       %     delta=[nexcoordx-previouscoordx nexcoordy-previouscoordy];
                            delta=[previouscoordx-nexcoordx previouscoordy-nexcoordy]

                            oriArrow(trial)=atan2d(delta(2), delta(1));
                            oriArrow(trial)=oriArrow(trial)-90;
                      %     oriArrow(trial)=0;
                            
%                             if orighead(trial)<0
%                                 head(trial)=360-orighead(trial);
%                             else
%                                 head(trial)=orighead(trial);
% 
%                             end
                            
                         %   sechead(trial)=-orighead(trial)
                            
%                             if sechead(trial)>0
%                                 head(trial)=180+sechead(trial)
%                             else
%                                 head(trial)=sechead(trial)
%                             end
                        %    head(trial)=180-head(trial)
%                             if head(trial)<180
%                                 head(trial)=head(trial)+180;
%                             end
                            exoendoCueDur=.133;
                        elseif mixtr(trial,2)==2 %exogenous cue
                            exoendoCueDur=0.05;
                        end
                        %                    counterflicker=-10000;
                    end
                    
                    cueonset=0;
                    cueduration=0;
                    
                            end
            if (eyetime2-trial_time)>=waittime+ifi*2+cueonset && (eyetime2-trial_time)<waittime+ifi*2+cueonset+cueduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                
                
% pre-event space
clear circlestar
                clear flickerstar
                clear theSwitcher
                clear imageRect_offsCirc
                clear imageRect_offsCI
                clear imageRect_offsCI2
                clear imageRectMask
                clear imageRect_offsCImask

                

                
                
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration && (eyetime2-trial_time)<+ifi*2+cueonset+cueduration+exoendoCueDur && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                clear circlestar
                clear flickerstar
                clear theSwitcher
                
                % HERE I present the cue for trainnig types 3 and 4
                %     clear imageRect_offs imageRect_offs_flank1 imageRect_offs_flank2 imageRect_offsCI
                if trainingType==1 || trainingType==2
                    counterflicker=-10000;
                end
                if trainingType>2 && trial>1
                   if mixtr(trial,1)~=mixtr(trial-1,1) % ||  trial==1
                        if mixtr(trial,2)==1 %endogenous cue
                        %    Screen('FillArc',w,white,rectimage{kk-1},360-(widthWag/2)-head,widthWag)
                        
                        newrectimage{kk}=[rectimage{kk-1}(1)-2*pix_deg rectimage{kk-1}(2)-2*pix_deg rectimage{kk-1}(3)+2*pix_deg rectimage{kk-1}(4)+2*pix_deg ];
                      %  Screen('FillArc',w,white,newrectimage{kk},head(trial)-(widthWag/2),widthWag)
                                         %   Screen('DrawTexture', w, theArrow, [], rectimage{kk-1}, oriArrow(trial)+135,[], 1);
                                            Screen('DrawTexture', w, theArrow, [], rectimage{kk-1}, oriArrow(trial),[], 1);

                        
                        
                                                 %       Screen('FillArc',w,white,rectimage{kk-1},(widthWag/2)-head(trial),widthWag)
                                                      %  Screen('FillArc',w,white,rectimage{kk-1},180-(widthWag/2)-head,widthWag)

                            pop(trial)=20;
                            %     Screen('DrawTexture', w, theLetter, [], rectimage{kk-1}, [],[], 1);
                        elseif mixtr(trial,2)==2 %exogenous cue
                            pop2(trial)=20;                           
                            Screen('FrameOval', w,scotoma_color, imageRect_offs, 22, 22);                       
                        end
                        %                    counterflicker=-10000;
                    end
                end

                %no cue
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+exoendoCueDur+postCueISI && fixating>400 && stopchecking>1 && counterannulus<AnnulusTime/ifi && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ==0 && (eyetime2-pretrial_time)<=trialTimeout
                
                if trainingType<3 % skip the force fixation for training types 1 and 2
                    counterannulus=(AnnulusTime/ifi)+1;
                elseif        trainingType>2 %force fixation for training types 3 and 4
                    
                    if annulusOrPRL==1
                        IsFixatingAnnulus
                    elseif annulusOrPRL==2
                        IsFixatingPRL2
                    end
                    Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                end
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+exoendoCueDur+postCueISI && fixating>400 && stopchecking>1 && counterannulus<AnnulusTime/ifi && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ~=0 && (eyetime2-pretrial_time)<=trialTimeout
                
                thekeys = find(keyCode);
                break;
                %             clear annulusend
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+exoendoCueDur+postCueISI && fixating>400 && stopchecking>1 && counterannulus>=AnnulusTime/ifi && counterflicker<FlickerTime/ifi && (eyetime2-pretrial_time)<=trialTimeout
                if trainingType>2
                    counterflicker=counterflicker+1;
                elseif trainingType<3
                    counterflicker=1;
                end
                if exist('flickerstar') == 0
                    flicker_time_start=GetSecs;
                    flickerstar=1;
                    theSwitcher=0;
                    flickswitch=0;
                    flick=1;
                end
             %   flicker_time=GetSecs;
                           flicker_time=GetSecs-flicker_time_start;

                           if flicker_time>flickswitch
                               flickswitch= flickswitch+flickeringrate;
                               flick=3-flick;
                           end
                           
                           if flicker_time>FlickerTime
                               counterflicker=FlickerTime/ifi+1;
                           end
                           
%                 if mod(length(VBL_Timestamp),(round(flickeringrate/ifi)))==0
%                     theSwitcher=theSwitcher+1;
%                 end
                
                if trainingType==3
                    %                     if mod(theSwitcher,2)==0
                    %                         Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                    %                     else
                    %                         %                      Screen('DrawTexture', w, theTest, [], imageRect_offs, [],[], 1);
                    %                     end
                    
                    if flick==2 %mod(length(VBL_Timestamp),(round(flickeringrate/ifi)))==0
                        theSwitcher=theSwitcher+1;
                        kkk=kkk+1;
                        countfl(trial,kkk)=GetSecs;
                        
                        Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                        
                    else
                        %                      Screen('DrawTexture', w, theTest, [], imageRect_offs, [],[], 1);
                    end
                    %  elseif trainingType==1 || trainingType==2 || trainingType==4
                elseif  trainingType==4
                    Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                end
                
                clear stimstar
                clear ssstimstar
                clear checktrialstart
                clear targetflickerstar
                if exist('circlestar')==0
                    circle_start = GetSecs;
                    circlestar=1;
                end
                cue_last=GetSecs;
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+exoendoCueDur+postCueISI+FlickerTime && fixating>400 && counterannulus>=AnnulusTime/ifi && counterflicker>=FlickerTime/ifi  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0 && stopchecking>1 %present pre-stimulus and stimulus
                if exist('ssstimstar')==0
                    ssstim_start = GetSecs;
                end
%                 if mod(length(VBL_Timestamp),(round(flickeringrate/ifi)))==0
%                     theSwitcher=theSwitcher+1;
%                 end
                
                if trainingType==3
                    
%                     if mod(theSwitcher,2)==0
%                         Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], 1);
%                     else
%                         %                      Screen('DrawTexture', w, theTest, [], imageRect_offs, [],[], 1);
%                     end
if exist('targetflickerstar') == 0
    targetflicker_time_start=GetSecs;
    targetflickerstar=1;
    theSwitcher=0;
    flickswitch=0;
    flick=1;
end
             %   flicker_time=GetSecs;
                           targetflicker_time=GetSecs-targetflicker_time_start;

                           if targetflicker_time>flickswitch
                               flickswitch= flickswitch+flickeringrate;
                               flick=3-flick;
                           end
                           
                           if targetflicker_time>FlickerTime
                               counterflicker=FlickerTime/ifi+1;
                           end
                    
                           if flick==2 %mod(length(VBL_Timestamp),(round(flickeringrate/ifi)))==0
                               theSwitcher=theSwitcher+1;
                               kkk=kkk+1;
                               countfl(trial,kkk)=GetSecs;
                               
                               Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], 1);
                               
                           else
                               %                      Screen('DrawTexture', w, theTest, [], imageRect_offs, [],[], 1);
                           end
                    
                if test==0
                    assignedPRLpatch
                end
                elseif trainingType==1 || (trainingType==4 && mixtr(trial,1))
                    
                    Screen('DrawTexture', w, texture(trial), [], imageRect_offs, ori,[], contr );
                    if test==0
                    assignedPRLpatch
                end
                    
                elseif trainingType==2 || (trainingType==4 && mixtr(trial,2))
                    if exist('imageRect_offsCI')==0
                        
                        imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(trial),...
                            imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(trial)];
                        %
                        %                              imageRect_offsCIsmoothL =[imageRectSmall(1)+eccentricity_XCIsmooth+eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCIsmooth+eccentricity_Y(trial),...
                        %     imageRectSmall(3)+eccentricity_XCIsmooth+eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCIsmooth+eccentricity_Y(trial)];
                        %                                  imageRect_offsCIsmoothL=round(imageRect_offsCIsmoothL);
                        imageRect_offsCI2=imageRect_offsCI;
                        imageRectMask = CenterRect([0, 0, [ xs*1.75*pix_deg xs*1.75*pix_deg]], wRect);
                        
                        imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
                            imageRectMask(3)+eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];
                        
                    end
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
                    imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
                    
                    %here I draw the target contour (9 or 6)
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Tcontr );
                    % here I draw the circle within which I show the contour target
                    Screen('FrameOval', w,gray, imageRect_offsCImask, 12, 60);
                    if test==0
                    assignedPRLpatch
                end
                    imagearray{trial}=Screen('GetImage', w);
                    
                    %                                      Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
                    %      imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
                    %           Screen('FillRect', w, gray,imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc] );
                    %         Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIsmoothL' , theori(1:16),[], Tcontr);
                    
                end
                
                if trainingType==4
                    Screen('FrameOval', w,ContCirc, imageRect_offs, oval_thick, oval_thick);
                end
                
                if exist('stimstar')==0
                    stim_start = GetSecs;
                    stimstar=1;
                end
                % start counting timeout for the non-fixed time training
                % types
                if trainingType>2
                    if exist('checktrialstart')==0
                        trialTimeout=actualtrialtimeout+(stim_start-pretrial_time);
                        checktrialstart=1;
                    end
                end
                                
            elseif (eyetime2-trial_time)>=waittime+ifi*4+cueonset+cueduration+exoendoCueDur+postCueISI+FlickerTime && fixating>400 && counterannulus>=AnnulusTime/ifi && counterflicker>=FlickerTime/ifi  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 %present pre-stimulus and stimulus
                eyechecked=10^4;
                
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
                %    [secs  indfirst]=min(thetimes);
                eyechecked=10^4;
            end
            
            eyefixation3
            if ScotomaPresent == 1
                Screen('FillOval', w, scotoma_color, scotoma);
                visiblePRLring
            else
                fixationlength=10;
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
            end
            
            if test==0
                    
                
            if penalizeLookaway>0
                if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                    Screen('FillRect', w, gray);
                end
                
            end
            end
            [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
            
            VBL_Timestamp=[VBL_Timestamp eyetime2];
            
            if EyeTracker==1
                
                GetEyeTrackerData
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
            
            
            if trainingType~=3
                staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
            end
            if trainingType==1 || (trainingType == 4 && mixtr(trial,1)==1)
                Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=contr;
            end
            
            if trainingType==2 || (trainingType == 4 && mixtr(trial,1)==2)
                Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=Orijit;
            end
            
            
            if foo(theans(trial))
                resp = 1;
                PsychPortAudio('Start', pahandle1);
                
                if trainingType~=3
                    corrcounter(mixtr(trial,1),mixtr(trial,2))=corrcounter(mixtr(trial,1),mixtr(trial,2))+1;
                    if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                        if isreversals(mixtr(trial,1),mixtr(trial,2))==1
                            reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
                            isreversals(mixtr(trial,1),mixtr(trial,2))=0;
                        end
                        thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                    end
                end
                
                if trainingType==1 || (trainingType == 4 && mixtr(trial,1)==1)
                    
                    %  if thresh(mixtr(trial,1),mixtr(trial,2))<SFthreshmin
                    if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                        
                        if contr<SFthreshmin && currentsf<length(sflist)
                            currentsf=min(currentsf+1,length(sflist));
                            foo=find(Contlist>=SFthreshmin);
                            %thresh(mixtr(:,:))=foo(end) -SFadjust;
                            thresh(:,:)=foo(end)-SFadjust;
                            %                     thresh(mixtr(trial,1),mixtr(trial,2))=max( thresh(mixtr(trial,1),mixtr(trial,2)),1);
                            corrcounter(:,:)=0;
                            thestep=3;
                        else
                            thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) +stepsizes(thestep);
                            thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Contlist));
                        end
                    end
                end
                %end
                
                if trainingType==2 || (trainingType == 4 && mixtr(trial,1)==2)
                    
                    if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                        
                        %  if thresh(mixtr(trial,1),mixtr(trial,2))<SFthreshmin
                        %                     if contr<SFthreshmin && currentsf<length(sflist)
                        %                         currentsf=min(currentsf+1,length(sflist));
                        %                         foo=find(Contlist>=SFthreshmin);
                        %                         %thresh(mixtr(:,:))=foo(end) -SFadjust;
                        %                         thresh(:,:)=foo(end)-SFadjust;
                        %                         %                     thresh(mixtr(trial,1),mixtr(trial,2))=max( thresh(mixtr(trial,1),mixtr(trial,2)),1);
                        %                         corrcounter(:,:)=0;
                        %                         thestep=3;
                        %                     else
                        thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) +stepsizes(thestep);
                        thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(JitList));
                        %                   end
                    end
                end
                %  end
                
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                ListenChar(0);
                break;
            else
                resp = 0;
                PsychPortAudio('Start', pahandle2);
                
                if trainingType~=3
                    if  corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                        isreversals(mixtr(trial,1),mixtr(trial,2))=1;
                    end
                    corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
                    thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                end
                
                if trainingType==1 || trainingType == 4 && mixtr(trial,1)==1
                    %    if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                    
                    %   if thresh(mixtr(trial,1),mixtr(trial,2))>SFthreshmax
                    if contr>SFthreshmax && currentsf>1
                        currentsf=max(currentsf-1,1);
                        thresh(:,:)=StartCont+SFadjust;
                        corrcounter(:,:)=0;
                        thestep=3;
                        %                 thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Contlist));
                    else
                        
                        thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
                        thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)),1);
                    end
                    %   end
                end
                
                if trainingType==2 || trainingType == 4 && mixtr(trial,1)==2
                    %     if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                    
                    %   if thresh(mixtr(trial,1),mixtr(trial,2))>SFthreshmax
                    %                 if contr>SFthreshmax && currentsf>1
                    %                     currentsf=max(currentsf-1,1);
                    %                     thresh(:,:)=StartCont+SFadjust;
                    %                     corrcounter(:,:)=0;
                    %                     thestep=3;
                    %                     %                 thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Contlist));
                    %                 else
                    
                    thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
                    thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)),1);
                    %        end
                    %     end
                end
                
                
            end
        else
            
            resp = 0;
            respTime=0;
            PsychPortAudio('Start', pahandle2);
        end
        
        if trialTimedout(trial)==0
            stim_stop=secs;
            cheis(kk)=thekeys;
        end
        time_stim(kk) = stim_stop - stim_start;
        totale_trials(kk)=trial;
        coordinate(trial).x=theeccentricity_X/pix_deg;
        coordinate(trial).y=theeccentricity_Y/pix_deg;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];
        flipptime(trial).ix=[fliptime];
        respTimes(trial)=respTime;
        rispo(kk)=resp;
        if exist('ssf')
            feat(kk)=ssf;
        end
        SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
        rectimage{kk}=imageRect_offs;
        cueendToResp(kk)=stim_stop-cue_last;
        cuebeginningToResp(kk)=stim_stop-circle_start;
        if exist('endExp')
        totalduration=(endExp-startExp)/60;
        end
        
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
    if EyeTracker==1
        Eyelink('StopRecording');
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    end
    
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    Screen('Flip', w);
    Screen('TextFont', w, 'Arial');
    
    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    %  KbQueueWait;
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
    
catch ME
    psychlasterror()
end