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
    defaultanswer={'test','0', '1', '4' };
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
   
    penalizeLookaway=0;
 %   if answer{2,:}=='test'
  %      expdayeye=answer{2,:};
  %  else
expdayeye=str2num(answer{2,:});
    site = answer{3,:};
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

    stimulusSize=2.5;
    
    sigma_deg=stimulusSize/2.5;
    holdtrial=0;
    cueSize=3;
    
timeOut=45;
trialTimeout=timeOut+3;
    oneOrfourCues=1; % 1= 1 cue, 4= 4 cue
    fixwindow=2;
    fixTime=0.2;
    %how long do they need to keep fixation near the pre-target element
    AnnulusTime=2;
    %FlickerTime=
    Jitter= [2:0.05:5];
    fixTime2=0.2;
    flickeringrate=0.25;
    PRLecc=10; %2;         %7.5; %eccentricity of PRLs
    %   PRLxx=[0 PRLecc 0 -PRLecc];
    %   PRLyy=[-PRLecc 0 PRLecc 0 ];
    %PRL_x_axis=-5;
    %PRL_y_axis=0;
    %NoPRL_x_axis=5;
    %NoPRL_y_axis=0;
    PRLsize =10; % diameter PRL

       
    
    Screen('Preference', 'SkipSyncTests', 1);
    PC=getComputerName();
    n_blocks=1;
    numstudydays=10;
    
    BITS=str2num(site); %0; 1=bits++; 2=display++
    closescript=0;
    kk=1;
    
    cueonset=0.55;
    cueduration=.05;
    cueISI=0.1;
   % FlickerTime=0.133;
    ScotomaPresent = 1; % 0 = no scotoma, 1 = scotoma
    
    cue_spatial_offset=2;
        bg_index =round(gray*255); %background color

    
    if BITS==0  %UCR bits++
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
    elseif BITS==1 % UCR no bits
        
        %% psychtoobox settings
        v_d=57;
        AssertOpenGL;
        screenNumber=max(Screen('Screens'));
        PsychImaging('PrepareConfiguration');
        % PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
                radius=15.5;   %radius of the circle in which the target can appear
        oldResolution=Screen( 'Resolution',screenNumber,1280,1024);
        SetResolution(screenNumber, oldResolution);
        [w, wRect]=PsychImaging('OpenWindow',screenNumber, 0,[],32,2);
        screencm=[40.6 30];
        %debug window
        %    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
        %ScreenParameters=Screen('Resolution', screenNumber); %close all
        Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
    elseif BITS==2   %UAB
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

    oval_thick=10; %thickness of oval
    CircConts=[0.51,1]*255; %low/high contrast circular cue

    xLim=(((35*pix_deg)-(2*imsize))/pix_deg)/2;
    yLim=(((35*pix_deg)-(2*imsize))/pix_deg_vert)/2;
    
    %radius=17.5;   %radius of the circle in which the target can appear
    end
    if trainingType==2 || trainingType==4 
        
        %contour integration
        clear a b m f_gabor
        sigma_degSmall=.1;
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

xs=5;%60; 12;
ys=5; %45;9;

%density 0.8 deg
[x1,y1]=meshgrid(-xs:0.8:xs,-ys:0.8:ys); %possible positions of Gabors within grid; in degrees of visual angle
   JitRat=1; % amount of jit ration the larger the value the less jitter
                    Oscat= 0.5; %JitList(thresh(Ts,Tc));

xlocsCI=x1(:)';
ylocsCI=y1(:)';

%generate visual cue
eccentricity_XCI=xlocsCI*pix_deg/2;
eccentricity_YCI=ylocsCI*pix_deg/2;

r=1;
C =[0 0];
theta=0:2*pi/12:2*pi;
m=r*[cos(theta')+C(1) sin(theta') + C(2)];
m=[m; 0.8 -1; 0.4 -1.5; 0 -2];
m_six=[-m(:,1) m(:,2)];
m_six=m_six.*pix_deg;

m_nine=[m(:,1) -m(:,2)];
m_nine=m_nine.*pix_deg;

    %target contrast
        Tcontr=0.8;
    %distractor contrast
        Dcontr=0.38; 
              
        Targx=[ -1 0 1  1  1 0 -1 -1 -1 0  1 1
            -1 0 1  -1  1 0 -1 -1 -1 0  1 1];
        Targy=[-2 -2 -2 -1 0 0 0 -1 2 2 2 1
            -2 -2 -2 -1 0 0 0 1 2 2 2 1];
        
        Targori=90+[135  0 45 90 90  0 45  90 180 180 135  90
            135 180 180   90 45 0 90 90 45  0 45 90];
        

    end
    
    
    if trainingType==2 || trainingType==3 || trainingType==4 
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
    
    theCircles(1:nrw, nrw/2:nrw)=theCircles(nrw:-1:1, (nrw/2+1):-1:1);
    theCircles = double(circle) .* double(theCircles)+bg_index * ~double(circle);
    theCircles=Screen('MakeTexture', w, theCircles);
  
    theTest=imread('target_black.tiff');
    theTest=theTest(:,:,1);
        theTest=Screen('MakeTexture', w, theTest);
    [img, sss, alpha] =imread('neutral21.png');
    img(:, :, 4) = alpha;
  Neutralface=Screen('MakeTexture', w, img);
    end
  
  
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
        VelocityThreshs = [250 2000];      	% px/sec
        ViewpointRefresh = 1;               % dummy variable
        driftoffsetx=0;                     % initial x offset for all eyetracker values
        driftoffsety=0;                     % initial y offset for all eyetracker values
        driftcorr=0.1;                      % how much to adjust drift correction each trial.
        % Parameters to identify fixations
        FixationDecisionThreshold = 0.3;    % sec; how long they have to fixate on a location for it to "count"
        FixationTimeThreshold = 0.033;      % sec; how long the eye has to be stationary before we begin to call it a fixation
        % note, the eye velocity is already low enough to be considered a "fixation"
        FixationLocThreshold = 1;           % degrees;  how far the eye can drift from a fixation location before we "call it" a new fixation
        
      
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
               
        if trainingType==3
            trials=10;  %total number of trials per staircase
        elseif trainingType==1 || trainingType==2
            trials=250;
        elseif trainingType==4
            trials=125;
        end
        if trainingType==1 || trainingType==2
            sfs=1;
            ns=length(sfs);
            cndt=ns;
            ca=1;
        elseif trainingType==4
            sfs=1;
            ns=length(sfs);
            ca=length(CircConts);
            %number of face features
            cndt=ns;
        end;
               if trainingType==1 || trainingType==2 || trainingType==4
                blocks=10;  %number of blocks in which we want the trials to be divided


    %number of cue conditions
            condlist=fullfact([cndt ca]);
            numsc=length(condlist);

    if length (condlist(:,1))<2
        mixcond=condlist;
    else
        mixcond=condlist(randperm(length(condlist)),:);
    end;   
           n_blocks=round(trials/blocks);   %number of trials per miniblock
    mixtr=[];
               end          
       if trainingType==4
        %condition matrix gabor and faces
        for j=1:blocks
            % mixcond=condlist(randperm(length(condlist)),:);
            for i=1:numsc
                mixtr=[mixtr;repmat(mixcond(i,:),n_blocks,1)];
            end;
        end;        
       elseif trainingType==1 || trainingType==2
        for j=1:blocks
            % mixcond=condlist(randperm(length(condlist)),:);
            for i=1:numsc
                mixtr=[mixtr;repmat(mixcond,n_blocks,1)];
            end;
        end;        
    end;        
                %% STAIRCASE

        if trainingType==1 || trainingType==4
    StartCont=15;  %15
    if expdayeye==0 || expdayeye==1 || expdayeye==numstudydays || expdayeye==numstudydays+1 %|| sum(expdayeye=='test')> 1
        thresh(1:cndt, 1:ca)=StartCont; %Changed from 10 to have same starting contrast as the smaller Contlist
        step=5;
        if BITS<2
            %  currentsf=sflist(4);
            currentsf=4;
        elseif BITS==2
            %   currentsf=sflist(1);
            currentsf=1;
            numstudydays=100;
        end
    else
        d = dir(['./data/' SUBJECT '_DAY_' num2str(expdayeye-1) '*.mat']);
        [dx,dx] = sort([d.datenum]);
        newest = d(dx(end)).name;
        oldthresh=load(['./data/' newest],'thresh');
        currentsfold=load(['./data/' newest],'currentsf');
        if isempty(fieldnames(currentsfold))
            if BITS<2
                %   currentsf=sflist(4);
                currentsf=4;
            elseif BITS==2
                %   currentsf=sflist(1);
                currentsf=1;
                numstudydays=100;
            end
        else
            currentsf=currentsfold.currentsf;
        end
        
        thresh(1:cndt, 1:ca)=oldthresh.thresh(1:cndt, 1:ca)-2;
        step=1;
    end;
        reversals(1:cndt, 1:ca)=0;
    isreversals(1:cndt, 1:ca)=0;
    staircounter(1:cndt, 1:ca)=0;
    corrcounter(1:cndt, 1:ca)=0;
    
    % Threshold -> 79%
    sc.up = 1;                          % # of incorrect answers to go one step up
    sc.down = 3;                        % # of correct answers to go one step down
    
    Contlist = log_unit_down(max_contrast+.122, 0.05, 76); %Updated contrast possible values
    Contlist(1)=1;
    
    stepsizes=[4 4 3 2 1];
    
    SFthreshmin=0.01;
    
    SFthreshmax=Contlist(StartCont);
    SFadjust=10;   
        end
    
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
            
            sf=1;
            % texture(trial)=TheGabors(sf);
            Tscat=0;
            GoodBlock=0;
            Tc=1;
            xmax=2*xs+1; %total number of squares in grid, along x direction (17)
            ymax=2*ys+1; %total number of squares in grid, along x direction (13)
            
            xTrans=round(xmax/2); %Translate target left/right or up/down within grid
            yTrans=round(ymax/2);
            
        end
          ecc_r=PRLecc*pix_deg;

         angolo= [90 45 0 315 270 225 180 135];
                 
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
         
if trainingType==3
     mixtr=[repmat(1:length(angolo),1,trials)'];
      mixtr =mixtr(randperm(length(mixtr)),:);
      
      
      
%       if holdlocations
%           for ui=1:length(mixtr)
%               
%              if 
%               thex=eccentricity_X(ui2);
%             they=eccentricity_Y(ui2);
%           end
%             newmixtr(ui,1)=thex;
%             newmixtr(ui,2)=they;
%           end
%       end
elseif trainingType==2 || trainingType==4
     
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
    
end


if trainingType>1
  
       if holdtrial==1
        totcoord=[eccentricity_X' eccentricity_Y'];
        newmat=[];
        tempmat=totcoord(1,:);
        while length(newmat)<length(mixtr)
            
            depl=totcoord~=tempmat(1,:);
            newdep=totcoord(depl(:,1), :);
            repnum=randi(4)+2;
            newpair=newdep(randi(length(newdep)),:)
            tempmat=repmat([newpair],repnum,1)
            newmat=[newmat;tempmat];
            conte=conte+1;
        end        
        if length(newmat)>length(mixtr)            
            newmat=newmat(1:length(mixtr(:,1)),:);           
        end        
        eccentricity_X=newmat(:,1);
        eccentricity_Y=newmat(:,2);
    end 
end
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
   % general instruction
   if trainingType==1
       DrawFormattedText(w, 'Press  the arrow key (left vs right) \n \n to indicate the orientation of the grating \n \n \n \n Press any key to start', 'center', 'center', white);
   elseif trainingType==2
       DrawFormattedText(w, 'Press  the arrow key (left vs right) \n \n to indicate the orientation of the contour \n \n \n \n Press any key to start', 'center', 'center', white);
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
    FixDotSize=15;
    
    
    
    for trial=1:length(mixtr)
        if trial== length(mixtr)/8 %|| trial== length(mixtr)/4 || trial== length(mixtr)/4
            interblock_instruction
        end
         
        if trainingType==1 || trainingType==4
            %           ori_i(trial)=2*theans(trial) +randi(2)-2;
            %     ori= theoris(ori_i(trial));
            sf=sflist(currentsf);
            fase=randi(4);
            %     texture(trial)=TheGabors(sf, fase);
            texture(trial)=TheGabors(currentsf, fase);
                    contr = Contlist(thresh(mixtr(trial,1),mixtr(trial,2)));
              %      contr=0.7;
        end
        
        if trainingType==4
            ContCirc= CircConts(mixtr(trial,2));
        end

        
        if trainingType>2
        FlickerTime=Jitter(randi(length(Jitter)));
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

        
        if trainingType==1
            theeccentricity_X=0;
            theeccentricity_Y=0;
        elseif  trainingType==2 || trainingType==4
            theeccentricity_X=eccentricity_X(trial);
            theeccentricity_Y=eccentricity_Y(trial);
        elseif trainingType==3
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
            if theans(trial)==2
                eccentricity_XCIsmooth=m_six(:,1);
                eccentricity_YCIsmooth=m_six(:,2);
            elseif theans(trial)==1
                eccentricity_XCIsmooth=m_nine(:,1);
                eccentricity_YCIsmooth=m_nine(:,2);
            end
            targetcord =Targy(theans(trial),:)+yTrans  + (Targx(theans(trial),:)+xTrans - 1)*ymax;
            %targetcord2 =Targy(theans(trial),:)+yTrans  + (Targx(theans(trial),:)+xTrans2 - 1)*ymax;
            targetcord2=targetcord;
           % xJitLoc=pix_deg*(rand(1,length(imageRect_offs))-.5)/JitRat; %plus or minus .25 deg
           % yJitLoc=pix_deg*(rand(1,length(imageRect_offs))-.5)/JitRat;
            
            
               xJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
            yJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;

            
%             xModLoc=zeros(1,length(imageRect_offs));
%             yModLoc=zeros(1,length(imageRect_offs));
%             
                xModLoc=zeros(1,length(eccentricity_XCI));
            yModLoc=zeros(1,length(eccentricity_XCI));

            
            
            
            %jitter location except for target
            xJitLoc(targetcord)=Tscat*xJitLoc(targetcord);
            yJitLoc(targetcord)=Tscat*yJitLoc(targetcord);
            xJitLoc(targetcord2)=Tscat*xJitLoc(targetcord2);
            yJitLoc(targetcord2)=Tscat*yJitLoc(targetcord2);
            %jitter orientation, except for that of target
            theori=180*rand(1,length(eccentricity_XCI));
            theori(targetcord)=Targori(theans(trial),:) + (2*rand(1,length(targetcord))-1)*Oscat;
            theori(targetcord2)=Targori(theans(trial),:) + (2*rand(1,length(targetcord))-1)*Oscat;
            
        end
          
        Priority(0);
        buttons=0;
        eyechecked=0;
        KbQueueFlush()
        trial_time=-1000;
        stopchecking=-100;
        
        trial_time=100000;
                pretrial_time=GetSecs;

        pretrial_time=GetSecs;
        while eyechecked<1
            
            if (eyetime2-pretrial_time)>ifi*35 && (eyetime2-pretrial_time)<ifi*65 && fixating<fixTime/ifi && stopchecking>1
                fixationscript2
            elseif  (eyetime2-pretrial_time)>=ifi*65 && fixating<fixTime/ifi && stopchecking>1
                IsFixating4
                fixationscript2
            elseif (eyetime2-pretrial_time)>ifi*65 && fixating>=fixTime/ifi && fixating<1000 && stopchecking>1
                trial_time = GetSecs;
                fixating=1500;
            end
            
            if (eyetime2-trial_time)>=waittime+ifi*2+cueonset && (eyetime2-trial_time)<waittime+ifi*2+cueonset+cueduration && fixating>400 && stopchecking>1
                
                %show cue
                clear circlestar
                clear flickerstar
                clear theSwitcher
                clear imageRect_offsCirc

            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration && (eyetime2-trial_time)<waittime+ifi*2+cueonset+cueduration+cueISI && fixating>400 && stopchecking>1
                clear circlestar
                clear flickerstar
                clear theSwitcher
           %     clear imageRect_offs imageRect_offs_flank1 imageRect_offs_flank2 imageRect_offsCI
                   if trainingType==1 || trainingType==2
                       counterflicker=-10000;
                   end
                %no cue
                %         elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+cueISI && (eyetime2-trial_time)<waittime+ifi*2+cueonset+cueduration+cueISI+FlickerTime && fixating>400 && stopchecking>1
                tito=1
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+cueISI && fixating>400 && stopchecking>1 && counterannulus<AnnulusTime/ifi && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ==0
                
                if trainingType==1 || trainingType==2
                    counterannulus=(AnnulusTime/ifi)+1;
                elseif        trainingType>2
                    IsFixatingAnnulus
                    Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                end
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+cueISI && fixating>400 && stopchecking>1 && counterannulus<AnnulusTime/ifi && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ~=0
                
                thekeys = find(keyCode);
                break;
                %             clear annulusend
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+cueISI && fixating>400 && stopchecking>1 && counterannulus>=AnnulusTime/ifi && counterflicker<FlickerTime/ifi
                cur=1;
                if trainingType>2
counterflicker=counterflicker+1;
                elseif trainingType<3
                    counterflicker=1;
                end
                if exist('flickerstar') == 0
                    flicker_time_start=GetSecs;
                    flickerstar=1;
                    theSwitcher=0;
                end
                flicker_time=GetSecs;
                
                
                if mod(length(VBL_Timestamp),(round(flickeringrate/ifi)))==0
                    theSwitcher=theSwitcher+1;
                end
                
                if trainingType==3
                    if mod(theSwitcher,2)==0
                        Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                    else
                        %                      Screen('DrawTexture', w, theTest, [], imageRect_offs, [],[], 1);
                    end
              %  elseif trainingType==1 || trainingType==2 || trainingType==4
              elseif  trainingType==4
                    Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                end
                
             
                clear stimstar
                if exist('circlestar')==0
                    circle_start = GetSecs;
                    circlestar=1;
                end
                cue_last=GetSecs;
            elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+cueISI+FlickerTime && fixating>400 && counterannulus>=AnnulusTime/ifi && counterflicker>=FlickerTime/ifi && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0 && stopchecking>1 %present pre-stimulus and stimulus
                
                if mod(length(VBL_Timestamp),(round(flickeringrate/ifi)))==0
                    theSwitcher=theSwitcher+1;
                end
                
                if trainingType==3
                    
                    if mod(theSwitcher,2)==0
                        Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], 1);
                    else
                        %                      Screen('DrawTexture', w, theTest, [], imageRect_offs, [],[], 1);
                    end
                elseif trainingType==1 || trainingType==4 
                    Screen('DrawTexture', w, texture(trial), [], imageRect_offs, ori,[], contr );
                end
                
                if trainingType==4
                    Screen('FrameOval', w,ContCirc, imageRect_offs, oval_thick, oval_thick);
                end
                
                
                                if trainingType==2
                                    
                                      if exist('imageRect_offsCI')==0
                                          
                         imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(trial),...
    imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(trial)];  

                             imageRect_offsCIsmoothL =[imageRectSmall(1)+eccentricity_XCIsmooth+eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCIsmooth+eccentricity_Y(trial),...
    imageRectSmall(3)+eccentricity_XCIsmooth+eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCIsmooth+eccentricity_Y(trial)]; 
                                 imageRect_offsCIsmoothL=round(imageRect_offsCIsmoothL);
                                    imageRect_offsCI2=imageRect_offsCI;

                                      end
                                    
                                       Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
     imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;    
          Screen('FillRect', w, gray,imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc] );
        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIsmoothL' , theori(1:16),[], Tcontr );

                                    
                end
                if exist('stimstar')==0
                    stim_start = GetSecs;
                end
            elseif (eyetime2-trial_time)>=waittime+ifi*4+cueonset+cueduration+cueISI+FlickerTime && fixating>400 && counterannulus>=AnnulusTime/ifi && counterflicker>=FlickerTime/ifi && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 %present pre-stimulus and stimulus
                eyechecked=1111111111;
                
                thekeys = find(keyCode);
                if length(thekeys)>1
                    thekeys=thekeys(1);
                end
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
            end
            
            eyefixation3
            if ScotomaPresent == 1
                Screen('FillOval', w, scotoma_color, scotoma);
            else
                fixationlength=10;
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
            end
            
            if penalizeLookaway>0
                if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                    Screen('FillRect', w, gray);
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

        foo=(RespType==thekeys);
       
        if trainingType==1 || trainingType == 4
           staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
            Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=contr; 
        end
        if foo(theans(trial))
            resp = 1;
            PsychPortAudio('Start', pahandle1);
            if trainingType==1 || trainingType == 4
                corrcounter(mixtr(trial,1),mixtr(trial,2))=corrcounter(mixtr(trial,1),mixtr(trial,2))+1;
                if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                    if isreversals(mixtr(trial,1),mixtr(trial,2))==1
                        reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
                        isreversals(mixtr(trial,1),mixtr(trial,2))=0;
                    end
                    thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                    
                    %  if thresh(mixtr(trial,1),mixtr(trial,2))<SFthreshmin
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
        elseif (thekeys==escapeKey) % esc pressed
            closescript = 1;
            ListenChar(0);
            break;
        else
            resp = 0;
            PsychPortAudio('Start', pahandle2);
        
            if trainingType==1 || trainingType == 4
                
                if  corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                    isreversals(mixtr(trial,1),mixtr(trial,2))=1;
                end
                corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
                thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
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
            end
        end
        
        stim_stop=secs;
        time_stim(kk) = stim_stop - stim_start;
        totale_trials(kk)=trial;
        coordinate(trial).x=theeccentricity_X/pix_deg;
        coordinate(trial).y=theeccentricity_Y/pix_deg;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];
        flipptime(trial).ix=[fliptime];
        
        rispo(kk)=resp;
        SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
        cueendToResp(kk)=stim_stop-cue_last;
        cuebeginningToResp(kk)=stim_stop-circle_start;
        cheis(kk)=thekeys;
        
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
 
    KbQueueWait;
    ShowCursor;
    
    if BITS==1
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