% FLAP Attention task via RSVP streams on 4 peripheral locations
% Marcello Maniglia 7/21/2021

% troubleshooting notes from kmmv July 9, 2022 (delete when code finalized):
% setting site to UAB at UAB causes psych port audio error.  we may want to
% fix that.
% blinking repeatedly during eyetracking seems to cause an error involving
% libptbdrawtext_ftg164.dll.
% it appears that responses that are early (but reasonable RTs) are not
% being recorded (have to hit button twice to get feedback.  Happens in
% both exo and endo cue types.
%Participants must be reminded to use only their right index finger for the
%tasks.
% search for term "code review" for code review comments about the code on
% particular lines.
% percentage complete does not appear to be correctly calculated.  It said
% "1%" for about 10 minutes.
% eye tracking data does not appear to be saved.
% there are a lot of indentation inconsistencies.  I've tried to
% automatically fix them, but they may not have worked correctly.  This is
% an issue in part because it's very hard to tell where the end of if
% statements are.


close all; clear all; clc; % clear the window
commandwindow

try
    prompt={'Participant name', 'day', 'site? UCR(1), UAB(2), Vpixx(3)', 'demo (0) or session (1)', 'eye? left(1) or right(2)', 'Scotoma? yes(1), no(2)'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test', '1', '3','0', '2', '1' };
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    addpath([cd '/utilities']);
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    expdayeye=answer{2,:};
    site= str2num(answer{3,:});  %0; 1=bits++; 2=display++
    Isdemo=answer{4,:};
    whicheye=str2num(answer{5,:});
    ScotomaPresent = str2num(answer{6,:}); % 0 = no scotoma, 1 = scotoma
    
    
    
    %% spatial parameters
    scotomadeg=6; % scotoma size in deg
    scotoma_color=[200 200 200];  % scotoma color in rgb
    oval_thick=10; %thickness of TRL ring in pixels
    exocuesize=3; % size of the exogenous cue in degrees
    endocuesize=1; % size of the endogenous cue (little dot) in degrees
    stimulussize=2; % size of the stimulus (C or O) in degrees
    circle_size=4.5; % dimension of the TRL rings in degrees
    fixationwindow=6; % diameter of fixation window in degrees (outside the box the stimuli disappear)
    color=0; %if we want to use color for TRL rings
    if color ==1
        ContCirc= [0 70 0]; % TRL ring color
        ContCirc2= [70 0 0]; % TRL ring color when fixation is broken
    elseif color ==0 %if we use grayscale (default)
        ContCirc= [150 150 150]; % TRL ring color
        ContCirc2= [225 225 225]; %if we use grayscale (default)
    end
    cue_color=[255 255 255]; % cue color in rgb
    ContCircEx=[255 0 0]; %exogenous cue color
    
    % background color on line 229
    
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data');
    end
    if str2num(Isdemo)==0
        baseName=['./data/' SUBJECT 'FLAP_RSVP_demo' expdayeye '_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif str2num(Isdemo)==1
        baseName=['./data/' SUBJECT 'FLAP_RSVP' expdayeye '_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    end
    c=clock;
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    Screen('Preference', 'SkipSyncTests', 1);
    PC=getComputerName();
    
    if site>0 && site<3
        ContCirc=ContCirc/255;
        ContCirc2=ContCirc2/255;
    end
    disp('Setting up temporal parameters')
    %% Temporal parameters
    targetAlphaValue=0.8; % transparency of the targets/foils (1:opaque, 0: invisible)
    flickeringrate = 0.4; %rate of flickering (in seconds) in between trials
    doesitflicker=1; % do we want the flickering between trials? 1:yes, 2:no
    fixat=1;
    closescript=0;
    kk=1;
    stimulus_contingent=1;
    precuetime=0.1; % time between second to last element in the stream and exo cue if it's an exo cue trial.
    cuedir=0.05;   %.05
    cuetargetISIexo=0.05; % ISI between cue and target for exo
    endocueduration=0.133; % duration of the endo cue
    exocueduration=0.05; % duration of the endo cue
    regularpoststimulustime=0.133; % (empty) ISI between stimuli during RSVP
    trialISI=1.5; % interval between end of one RSVP trial and beginning of next. Trial is here defined as the series of stimuli ending with the target appearing after exo or endo cue
    stimulusduration=0.3; % duration of the stimuli (Cs and Os)
    lookaway=2; % 0: location rings disappear, 1:location rings increase in brightness, 2: location rings stay the same color
    
    
    blocking= 16;%number of consecutive trials of one type
    
    fixwindow=2;
    fixTime=1.2;
    fixTime2=0.2;
    % oval_thickEx=20; %thickness of exo cue ring
    % cue_size=6; %old exo cue
    
    EyeTracker = 1; %0=mouse, 1=eyetracker
    
    
    
    KbQueueCreate;
    KbQueueStart;
    
    KbName('UnifyKeyNames')
    %if ispc
    %   escapeKey = KbName('esc');	% quit key
    %elseif ismac
    escapeKey = KbName('ESCAPE');	% quit key
    %end
    disp('Setting up parameters for different sites')
    if site==0  %UCR bits++
        v_d=57;
        screencm=[40.6 30];
        %load gamma197sec;
        %load lut_12bits_pd; Disabled until display is calibrated
        AssertOpenGL;
        oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
        %screenNumber=max(Screen('Screens'));
        screenNumber=0;
        rand('twister', sum(100*clock));
        PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
        PsychImaging('AddTask','General','FloatingPoint32BitIfPossible');
        PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
        PsychImaging('AddTask', 'FinalFormatting','DisplayColorCorrection','LookupTable');
        %     oldResolution=Screen( 'Resolution',screenNumber,1280,960);
        % SetResolution(screenNumber, oldResolution);
        %lut_12bits= repmat((linspace(0,1,4096).^(1/2.2))',1,3);
        %  [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
        %  PsychColorCorrection('SetLookupTable', w, lookuptable);
        %if you want to open a small window for debug
        %   [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
        
        %                  [w, wRect] = BitsPlusPlus('OpenWindowMono++', screenNumber, 0.5,[0 0 640 480],32,2);
        [w, wRect] = BitsPlusPlus('OpenWindowMono++', screenNumber, 0.5,[],32,2);
        Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
    elseif site==1 %UCR no bits
        %% psychtoobox settings
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
            %          PsychImaging('AddTask', 'FinalFormatting','DisplayColorCorrection','LookupTable');
            oldResolution=Screen( 'Resolution',screenNumber,1920,1080);
            SetResolution(screenNumber, oldResolution);
            [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
            %       [w, wRect]=Screen('OpenWindow',whichScreen, 127, [], [], [], [],3);
            %     [w, wRect] = Screen('OpenWindow', screenNumber, 0.5,[],[],[],[],3);
            
        end
    elseif site==2   %UAB
        screencm=[69.8, 35.5];
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
        
    elseif site==3      % VPixx
        initRequired= 0;
        if initRequired>0
            fprintf('\nInitialization required\n\nCalibrating the device...');
            TPxTrackpixx3CalibrationTestingskip;
        end
        % elseif EyetrackerType==2
        
        %Connect to TRACKPixx3
        Datapixx('Open');
        Datapixx('SetTPxAwake');
        Datapixx('RegWrRd');
        screencm=[69.8, 35.5];
        
        v_d=80;
        AssertOpenGL;
        screenNumber=max(Screen('Screens'));
        PsychImaging('PrepareConfiguration');
        % PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
        oldResolution=Screen( 'Resolution',screenNumber,1920,1080);
        SetResolution(screenNumber, oldResolution);
        [w, wRect]=PsychImaging('OpenWindow',screenNumber, 0.5,[],32,2);
        
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
    pix_deg_vert=1./((2*atan((screencm(2)/wRect(4))./(2*v_d))).*(180/pi));
    white=WhiteIndex(screenNumber);
    black=BlackIndex(screenNumber);
    gray=round((white+black)/2); % background color
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
    
    prefixwait=ifi*40;
    if stimulus_contingent==1
        waittime=0;
        durfix=0;
    elseif stimulus_contingent==0
        waittime=ifi*50;
        durfix=.133;    %.133
    end
    
    disp('Starting Eyetracker setup')
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
        PixelsPerDegree=pix_deg;
        
        % old variables
        [winCenter_x,winCenter_y]=RectCenter(wRect);
        backgroundEntry = [0.5 0.5 0.5];
        % height and width of the screen
        winWidth  = RectWidth(wRect);
        winHeight = RectHeight(wRect);
    end
    % SOUND
    disp('setting up Sound')
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
        [errorS freq  ] = wavread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
        [corrS freq  ] = wavread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
    end
    try
        [errorS freq  ] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
        [corrS freq  ] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
    end
    
    PsychPortAudio('FillBuffer', pahandle1, corrS' ); % loads data into buffer
    PsychPortAudio('FillBuffer', pahandle2, errorS'); % loads data into buffer
    
    % corrS=zeros(size(errorS));
    load('S096_marl-nyu');   %Comment needed: what is this?
    
    
    fixationlength = 10; % pixels
    fixwindowPix=fixwindow*pix_deg;
    
    bg_index =round(gray*255); %background color
    
    
    
    
    disp('Start main loop')
    %% main loop
    HideCursor;
    if Isdemo==1
        ListenChar(2);
    end
    WaitSecs(1);
    
    theoris=[0 180 270 90 991 992 993 994 995];
    
    [xc, yc] = RectCenter(wRect); % coordinate del centro schermo
    
    PRL_x_axis=0;
    PRL_y_axis=-7.5;
    
    
    [theta,rho] = cart2pol(PRL_x_axis, PRL_y_axis);
    
    ecc_r=rho;
    ecc_t=theta-pi; % ecc_t=theta+pi/2
    cs= [cos(ecc_t), sin(ecc_t)];
    xxyy=[ecc_r ecc_r].*cs;
    PRL3_x_axis=xxyy(1);
    PRL3_y_axis=xxyy(2);
    
    %ecc_r=rho;
    ecc_t=theta-pi/2; % ecc_t=theta+3*pi/2
    cs= [cos(ecc_t), sin(ecc_t)];
    xxyy=[ecc_r ecc_r].*cs;
    PRL4_x_axis=xxyy(1);
    PRL4_y_axis=xxyy(2);
    
    ecc_t=theta+pi/2;
    cs= [cos(ecc_t), sin(ecc_t)];
    xxyy=[ecc_r ecc_r].*cs;
    PRL2_x_axis=xxyy(1);
    PRL2_y_axis=xxyy(2);
    
    
    xlocs=[PRL_x_axis PRL2_x_axis PRL3_x_axis PRL4_x_axis];
    ylocs=[PRL_y_axis PRL2_y_axis PRL3_y_axis PRL4_y_axis];
    
    
    %xlocs=[PRL_x_axis No ThirdPoint_x_axis];
    %ylocs=[PRL_y_axis NoPRL_y_axis ThirdPoint_y_axis];
    
    
    %generate visual cue
    eccentricity_X=xlocs*pix_deg;
    eccentricity_Y=ylocs*pix_deg_vert;
    
    RespType(1) = KbName('RightArrow');
    RespType(2) = KbName('LeftArrow');
    RespType(3) = KbName('UpArrow');
    RespType(4) = KbName('DownArrow');
    RespType(5:9) = KbName('w');
    
    
    if str2num(expdayeye)==1
        %load RSVPTrialMat2022-A.mat
        load RSVPTrialMat2022-B.mat
    elseif str2num(expdayeye)==2
        load RSVPTrialMat2022-B.mat
    elseif str2num(expdayeye)==3
        load RSVPTrialMat2022-C.mat
    elseif str2num(expdayeye)==0
        load RSVPTrialMat2022-D.mat
    end
    newtrialmatrix=totalnewnewtrial_incongruent4;
    
    exo_index=find(newtrialmatrix(:,1)==2);
    exo_index=exo_index(1)-1;
    endo=newtrialmatrix(1:exo_index-1,:);
    exo=newtrialmatrix(exo_index:end,:);
    
    endo=endo(1:end-1,:);
    exo=exo(1:end-1,:);
    
    trialcounterEndo=find(endo(:,1)==3);
    trialcounterExo=find(exo(:,1)==3);
    
    
    shortendo=endo(1:trialcounterEndo(5)-1,:);
    shortexo=exo(1:trialcounterExo(5)-1,:);
    shortexo=shortexo(3:end,:);
    
    newtrialmatrix=[shortendo;shortexo];
    
    blockCounterEndo=[trialcounterEndo(1:blocking:end); length(endo)+1];
    blockCounterExo=[trialcounterExo(1:blocking:end); length(exo)+1];
    counterexo=0;
    counterendo=0;
    soloexo=[];
    soloendo=[];
    %% Generate trial blocks
    newnewtrialmatrix=[];
    for ui=1:(length(blockCounterEndo)+length(blockCounterExo)-1)
        if mod(ui,2)==0
            counterexo=counterexo+1;
            exocon(counterexo)=ui;
            if length(blockCounterExo)>counterexo
                chunck=[exo(blockCounterExo(counterexo):blockCounterExo(counterexo+1)-1,:)];
                soloexo=[soloexo; chunck];
                newnewtrialmatrix=[newnewtrialmatrix;chunck];
            end
        elseif mod(ui,2)>0
            counterendo=counterendo+1;
            endocon(counterendo)=ui;
            if length(blockCounterEndo)>counterendo
                chunck=[endo(blockCounterEndo(counterendo):blockCounterEndo(counterendo+1)-1,:)];
                soloendo=[soloendo; chunck];
                newnewtrialmatrix=[newnewtrialmatrix;chunck];
            end
        end
    end
    
    if str2num(Isdemo)==1
        newtrialmatrix=newnewtrialmatrix;
    end
    %     newtrialmatrix=soloexo;
    
    if EyetrackerType==1
        useEyeTracker = 0; % otherwise will throw error if not UAB run
        
        eyeTrackerBaseName =[SUBJECT expdayeye];
        
        
        if exist('dataeyet')==0
            mkdir('dataeyet')
        end
        save_dir=[cd './dataeyet/'];  %code review: this does not seem to do what you think it will?  nothing is being saved here.  And changing directories mid-code can be dangerous
        
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
        
        Eyelink('command','validation_samples = 10'); %changed to make
        
        % make sure that we get gaze data from the Eyelink
        Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
        Eyelink('OpenFile', eyeTrackerFileName); % open file to record data  & calibration
        EyelinkDoTrackerSetup(elHandle);
        Eyelink('dodriftcorrect');
        
    end
    %% Load images and set up eyetracker
    % check EyeTracker status
    if EyetrackerType == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        % mark zero-plot time in data file
        Eyelink('message' , 'SYNCTIME');
        
        location =  zeros(length(newtrialmatrix), 6);
    end
    eyetime2=0;
    
    
    scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg_vert];
    scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
    
    
    imageRectcircles = CenterRect([0, 0, [circle_size*pix_deg circle_size*pix_deg_vert]], wRect);
    fixationwindowRect = CenterRect([0, 0, [fixationwindow*pix_deg fixationwindow*pix_deg_vert]], wRect);
    
    
    imsize=stimulussize*pix_deg;
    imsize2=stimulussize*pix_deg_vert;
    [x,y]=meshgrid(-imsize:imsize,-imsize2:imsize2);
    xylim = imsize; %radius of circular mask
    circle = x.^2 + y.^2 <= xylim^2;
    [nrw, ncl]=size(x);
    
    
    theLetter=imread('newletterc22.tiff');
    theLetter=theLetter(:,:,1);
    theLetter=imresize(theLetter,[nrw ncl],'bicubic');
    theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
    theLetterO=theLetter;
    theLetter=Screen('MakeTexture', w, theLetter);
    theLetterO(:,ncl/2+1:end)=theLetterO(:,ncl/2:-1:1);
    whichLetter(1)=Screen('MakeTexture', w, theLetterO);
    
    theLetterl=imread('letter_l2.tiff');
    theLetterl=theLetterl(:,:,1);
    theLetterl=imresize(theLetterl,[nrw ncl],'bicubic');
    whichLetter(2)=Screen('MakeTexture', w, theLetterl);
    
    theLetterr=imread('letter_r2.tiff');
    theLetterr=theLetterr(:,:,1);
    theLetterr=imresize(theLetterr,[nrw ncl],'bicubic');
    whichLetter(3)=Screen('MakeTexture', w, theLetterr);
    
    theLetterd=imread('letter_d2.tiff');
    theLetterd=theLetterd(:,:,1);
    theLetterd=imresize(theLetterd,[nrw ncl],'bicubic');
    whichLetter(4)=Screen('MakeTexture', w, theLetterd);
    
    imageRect1 = CenterRect([0, 0, [stimulussize*pix_deg stimulussize*pix_deg_vert]], wRect);
    imageRectendocue = CenterRect([0, 0, [endocuesize*pix_deg endocuesize*pix_deg_vert]], wRect);
    
    thecue=imread('ccue2.tiff');
    thecue=thecue(:,:,1);
    thecue=imresize(thecue,[nrw ncl],'bicubic');
    cueimage=Screen('MakeTexture', w, thecue);
    
    cueleft=[-circle_size*pix_deg/2 0  -circle_size*pix_deg/2 0];
    cueright=[circle_size*pix_deg/2 0  circle_size*pix_deg/2 0];
    cuedown=[0 circle_size*pix_deg/2 0  circle_size*pix_deg/2 ];
    cueup=[0 -circle_size*pix_deg/2 0  -circle_size*pix_deg/2 ];
    
    thecues={cueup cueright cuedown cueleft};
    
    thecuesEx=thecues;
    xeye=[];
    yeye=[];
    VBL_Timestamp=[];
    stimonset=[ ];
    fliptime=[ ];
    mss=[ ];
    tracktime=[];
    %% Trials
    for trial=1:length(newtrialmatrix)
        %for trial=14
        
        
        Response.start=0;
        kkk=0;
        kkk2=0;
        kkk3=0;
        
        if trial==1 && newtrialmatrix(trial+1,1)==1
            switch_task_script_endo2
        end
        
        if trial==1 && newtrialmatrix(trial+1,1)==2
            switch_task_script_exo2
        end
        
        if trial>1 && newtrialmatrix(trial,1)==3 && newtrialmatrix(trial-1,1)==1 && newtrialmatrix(trial+1,1)==2
            switch_task_script_exo2
        end
        
        
        if trial>1 && newtrialmatrix(trial,1)==3 && newtrialmatrix(trial-1,1)==0 && newtrialmatrix(trial+1,1)==1 && trial<length(newtrialmatrix)
            switch_task_script_endo2
        end
        
        %         if sum(trial==totaltrialbreak)>0
        %             interblock_instruction_rsvp;
        %         end
        
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
        if trial==1
            fixating=0;
        else
            fixating=10^12;
        end
        fixating2=0;
        counter=0;
        counter2=0;
        framecounter=0;
        x=0;
        y=0;
        area_eye=0;
        xeye2=[];
        yeye2=[];
        
        %current target location
        cloc=newtrialmatrix(trial,2);
        %next target location
        tloc=newtrialmatrix(trial,3);
        ecc_x_tgt=xlocs(tloc);
        ecc_y_tgt=ylocs(tloc);
        ecc_x_cue=xlocs(cloc);
        ecc_y_cue=ylocs(cloc);
        audiocue2 %generates audio cue
        
        %    theans(trial)=randi(4); %generates answer for this trial
        
        
        theans(trial)=newtrialmatrix(trial,5);
        
        
        
        % coding target ori or cue
        ori_i(trial)=theans(trial);
        ori= theoris(ori_i(trial));
        
        eyechecked=0;
        
        KbQueueFlush();
        pretrial_time=GetSecs;
        trial_time=-1000;
        fixstart=100000;
        stopfixating=0;
        stopfixating2=0;
        T=newtrialmatrix(trial,1);
        cueExsize=exocuesize*pix_deg;
        
        
        if T==1 && newtrialmatrix(trial,5)<=5 || T==2 || T==3 % foil/non cued stimulus
            cuedir=.05;   %.05
            cuetargetISI=.05;
            stimdur=stimulusduration; %.133
            poststimulustime=regularpoststimulustime;
        elseif T==1 && newtrialmatrix(trial,5)>5   % endogenous stimulus
            cuedir=.05;   %.05
            cuetargetISI=.05;
            stimdur=endocueduration; %.133
        elseif T==0                     % exogenous stimulus
            %   precuetime=.2;
            cuedir=exocueduration;   %duration of the cue
            cuetargetISI=cuetargetISIexo; %interval between cue disappearance and target appearance
            stimdur=stimulusduration; %.133
            poststimulustime=regularpoststimulustime;
        end
        
        
        if trial>1
            if T==0 || newtrialmatrix(trial-1,5)>5
                poststimulustime=trialISI;
            elseif T==1 && newtrialmatrix(trial-1,5)>5
                cuedir=0;   %.05
                cuetargetISI=0;
                stimdur=stimulusduration; %.133
                poststimulustime=regularpoststimulustime;
                
            end
        end
        
        %timing trials
        if T==3 %trial==1 || sum(trial==totaltrialbreak)>0
            pretrial_time=GetSecs;
            trial_time=-1000;
            fixstart=100000;
            stopfixating=0;
            fixating=0;
            imageRect_offs1=[imageRect1(1)+eccentricity_X(1), imageRect1(2)+eccentricity_Y(1),...
                imageRect1(3)+eccentricity_X(1), imageRect1(4)+eccentricity_Y(1)];
            imageRect_offs2=[imageRect1(1)+eccentricity_X(2), imageRect1(2)+eccentricity_Y(2),...
                imageRect1(3)+eccentricity_X(2), imageRect1(4)+eccentricity_Y(2)];
            imageRect_offs3=[imageRect1(1)+eccentricity_X(3), imageRect1(2)+eccentricity_Y(3),...
                imageRect1(3)+eccentricity_X(3), imageRect1(4)+eccentricity_Y(3)];
            imageRect_offs4=[imageRect1(1)+eccentricity_X(4), imageRect1(2)+eccentricity_Y(4),...
                imageRect1(3)+eccentricity_X(4), imageRect1(4)+eccentricity_Y(4)];
            
            imageRect_offs={imageRect_offs1 imageRect_offs2 imageRect_offs3 imageRect_offs4};
            
        else
            trial_time=GetSecs;
            fixating=1500;
            stopfixating=1000;
        end
        
        imageRect_circleoffs1=[imageRectcircles(1)+eccentricity_X(1), imageRectcircles(2)+eccentricity_Y(1),...
            imageRectcircles(3)+eccentricity_X(1), imageRectcircles(4)+eccentricity_Y(1)];
        imageRect_circleoffs2=[imageRectcircles(1)+eccentricity_X(2), imageRectcircles(2)+eccentricity_Y(2),...
            imageRectcircles(3)+eccentricity_X(2), imageRectcircles(4)+eccentricity_Y(2)];
        imageRect_circleoffs3=[imageRectcircles(1)+eccentricity_X(3), imageRectcircles(2)+eccentricity_Y(3),...
            imageRectcircles(3)+eccentricity_X(3), imageRectcircles(4)+eccentricity_Y(3)];
        imageRect_circleoffs4=[imageRectcircles(1)+eccentricity_X(4), imageRectcircles(2)+eccentricity_Y(4),...
            imageRectcircles(3)+eccentricity_X(4), imageRectcircles(4)+eccentricity_Y(4)];
        
        imageRect_circleoffs1offs={imageRect_circleoffs1 imageRect_circleoffs2 imageRect_circleoffs3 imageRect_circleoffs4};
        
        
        imageRectendocue1=[imageRectendocue(1)+eccentricity_X(1), imageRectendocue(2)+eccentricity_Y(1),...
            imageRectendocue(3)+eccentricity_X(1), imageRectendocue(4)+eccentricity_Y(1)];
        imageRectendocue2=[imageRectendocue(1)+eccentricity_X(2), imageRectendocue(2)+eccentricity_Y(2),...
            imageRectendocue(3)+eccentricity_X(2), imageRectendocue(4)+eccentricity_Y(2)];
        imageRectendocue3=[imageRectendocue(1)+eccentricity_X(3), imageRectendocue(2)+eccentricity_Y(3),...
            imageRectendocue(3)+eccentricity_X(3), imageRectendocue(4)+eccentricity_Y(3)];
        imageRectendocue4=[imageRectendocue(1)+eccentricity_X(4), imageRectendocue(2)+eccentricity_Y(4),...
            imageRectendocue(3)+eccentricity_X(4), imageRectendocue(4)+eccentricity_Y(4)];
        
        imageRectendocues={imageRectendocue1 imageRectendocue2 imageRectendocue3 imageRectendocue4};
        
        Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
        Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
        Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
        Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
        
        while eyechecked<1
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            if T==3
                if (eyetime2-pretrial_time)>=0 && (eyetime2-pretrial_time)<=ifi*11
                    clear flickerstar
                    clear startflickerstar
                    clear preflickerstar
                    clear postflickerstar
                    clear stim_star
                    counting(trial)=99;
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                elseif (eyetime2-pretrial_time)>ifi*11 && (eyetime2-pretrial_time)<=prefixwait+28*ifi
                    
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    if exist('startflickerstar') == 0
                        flicker_time_start=GetSecs;
                        startflickerstar=1;
                        theSwitcher=0;
                        flickswitch=0;
                        flick=1;
                    end
                    flicker_time=GetSecs-flicker_time_start;
                    
                    if flicker_time>flickswitch
                        flickswitch= flickswitch+flickeringrate;
                        flick=3-flick;
                    end
                    if trial==1
                        if flick==2 && newtrialmatrix(trial,1)==3 || flick==2 && newtrialmatrix(trial+1,1)==3 &&  trial<=length(newtrialmatrix(:,1))
                            theSwitcher=theSwitcher+1;
                            kkk=kkk+1;
                            countfl(trial,kkk)=GetSecs;
                            if doesitflicker==1
                                Screen('DrawTexture', w, theLetter, [], imageRect_offs{tloc}, ori,[], targetAlphaValue );
                            end
                        end
                    else
                        if flick==2 && newtrialmatrix(trial,1)==3 && GetSecs-stim_start(trial-1)>=flickeringrate || flick==2 && newtrialmatrix(trial+1,1)==3 &&  trial<=length(newtrialmatrix(:,1)) && GetSecs-stim_start(trial-1)>=flickeringrate
                            theSwitcher=theSwitcher+1;
                            kkk=kkk+1;
                            countfl(trial,kkk)=GetSecs;
                            if doesitflicker==1
                                Screen('DrawTexture', w, theLetter, [], imageRect_offs{tloc}, ori,[], targetAlphaValue );
                            end
                        end
                    end
                    
                elseif (eyetime2-pretrial_time)>prefixwait+28*ifi && (eyetime2-pretrial_time)<prefixwait+30*ifi && stopfixating<80 && sum(keyCode(RespType(1:6)))== 0  %
                    %target at the beginning of the trial stays on screen
                    %until response (2 frames)
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs{tloc}, ori,[], targetAlphaValue );
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                    stim_start(trial)=GetSecs;
                    stim_star=GetSecs;
                    if exist('preflickerstar') == 0
                        flicker_time_start=GetSecs;
                        preflickerstar=1;
                        theSwitcher=0;
                        flickswitch=0;
                        flick=1;
                    end
                    flicker_time=GetSecs-flicker_time_start;
                    
                    if flicker_time>flickswitch
                        flickswitch= flickswitch+flickeringrate;
                        flick=3-flick;
                    end
                    
                    if trial==1
                        if flick==2 && newtrialmatrix(trial,1)==3 || flick==2 && newtrialmatrix(trial+1,1)==3 &&  trial<=length(newtrialmatrix(:,1))
                            theSwitcher=theSwitcher+1;
                            kkk=kkk+1;
                            countfl(trial,kkk)=GetSecs;
                            if doesitflicker==1
                                Screen('DrawTexture', w, theLetter, [], imageRect_offs{tloc}, ori,[], targetAlphaValue );
                            end
                        end
                    else
                        if flick==2 && newtrialmatrix(trial,1)==3 && GetSecs-stim_start(trial)>=flickeringrate || flick==2 && newtrialmatrix(trial+1,1)==3 &&  trial<=length(newtrialmatrix(:,1)) && GetSecs-stim_start(trial)>=flickeringrate
                            theSwitcher=theSwitcher+1;
                            kkk=kkk+1;
                            countfl(trial,kkk)=GetSecs;
                            if doesitflicker==1
                                Screen('DrawTexture', w, theLetter, [], imageRect_offs{tloc}, ori,[], targetAlphaValue );
                            end
                        end
                    end
                    
                elseif (eyetime2-pretrial_time)>prefixwait+30*ifi && stopfixating<80 && sum(keyCode(RespType(1:6))+keyCode(escapeKey))== 0
                    %target at the beginning of the trial stays on screen
                    %until response (stimulus duration)
                    if exist('stim_star')==0
                        stim_star=GetSecs;
                        stim_start(trial)=stim_star;
                        skipframe(trial)=1;
                    end
                    
                    
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
                    
                    if flick==2 && newtrialmatrix(trial,1)==3 || flick==2 && newtrialmatrix(trial+1,1)==3 &&  trial<=length(newtrialmatrix(:,1))
                        theSwitcher=theSwitcher+1;
                        kkk=kkk+1;
                        countfl(trial,kkk)=GetSecs;
                        if doesitflicker==1
                            Screen('DrawTexture', w, theLetter, [], imageRect_offs{tloc}, ori,[], targetAlphaValue );
                        end
                    end
                    
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                elseif      (eyetime2-pretrial_time)>prefixwait+30*ifi+ifi*20 && stopfixating<80 && sum(keyCode(RespType(1:6))+keyCode(escapeKey))~= 0
                    
                    if exist('stim_star')==0
                        stim_star=GetSecs;
                        stim_start(trial)=stim_star;
                        skipframe(trial)=1;
                    end
                    %when response to the first target is produced, we only present the 4 circles
                    %until response. 20 frames are provided of stimulus on
                    %screen before participant is allowed to response
                    %(avoid slips of finger at the beginning of a trial)
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                    
                    thekeys = find(keyCode);
                    if length(thekeys)>1
                        thekeys=thekeys(1);
                    end
                    thetimes=keyCode(thekeys);
                    [secs  indfirst]=min(thetimes);
                    
                    foo=(RespType==thekeys);
                    if flick==1
                        fixating=1500;
                        stopfixating=100;
                    end
                    trial_time = GetSecs;
                    
                    if (thekeys==escapeKey) % esc pressed
                        closescript = 1;
                        if EyetrackerType==2
                            Datapixx('DisableSimulatedScotoma')
                            Datapixx('RegWrRd')
                        end
                        ListenChar(0);
                        break;
                    end
                    
                    if foo(theans(trial))
                        resp = 1;
                        PsychPortAudio('Start', pahandle1);
                    else
                        resp=-1;
                        PsychPortAudio('Start', pahandle2);
                    end
                    respo(trial)=resp;
                    respTimeSTamp(trial)=secs;
                    respTotrial=1;
                    resptrial(trial)=99;
                    %    end
                    if exist('stim_star')==0
                        stim_start(trial)=GetSecs;
                        errorTrial(trial)=99;
                    end
                    respRT(trial)=GetSecs-stim_start(trial);
                    eyechecked=11^11;
                end
            end
            
            %here starts the RSVP stream OR it's the end of an exogenous
            %cue trial so I present the cue and then the last target of the
            %stream
            
            if (eyetime2-trial_time)>=0 && (eyetime2-trial_time)<precuetime  && fixating>400
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                clear stim_star
            elseif (eyetime2-trial_time)>=precuetime && (eyetime2-trial_time)<=precuetime+ifi && fixating>400
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                
                % if it's exogenous cue trial
                if  T==0
                    cueonset=GetSecs;
                    cueontime=cueonset + (ifi * 0.5);
                    
                    
                    %                     imageRect_offscue=[imageRectcue(1)+eccentricity_X(cloc), imageRectcue(2)+eccentricity_Y(cloc),...
                    %                         imageRectcue(3)+eccentricity_X(cloc), imageRectcue(4)+eccentricity_Y(cloc)];
                    %
                    %
                    cuecounter(trial)=1;
                    
                    
                    imageRect_circleoffscover=[imageRectcircles(1)+eccentricity_X(tloc), imageRectcircles(2)+eccentricity_Y(tloc),...
                        imageRectcircles(3)+eccentricity_X(tloc), imageRectcircles(4)+eccentricity_Y(tloc)];
                    %  Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{1}(1), imageRectendocues{tloc}(2)+thecuesEx{1}(2),imageRectendocues{tloc}(3)+thecuesEx{1}(3), imageRectendocues{tloc}(4)+thecuesEx{1}(4)]);
                    %  Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{2}(1), imageRectendocues{tloc}(2)+thecuesEx{2}(2),imageRectendocues{tloc}(3)+thecuesEx{2}(3), imageRectendocues{tloc}(4)+thecuesEx{2}(4)]);
                    %  Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{3}(1), imageRectendocues{tloc}(2)+thecuesEx{3}(2),imageRectendocues{tloc}(3)+thecuesEx{3}(3), imageRectendocues{tloc}(4)+thecuesEx{3}(4)]);
                    %  Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{4}(1), imageRectendocues{tloc}(2)+thecuesEx{4}(2),imageRectendocues{tloc}(3)+thecuesEx{4}(3), imageRectendocues{tloc}(4)+thecuesEx{4}(4)]);
                    Screen('FrameOval', w,gray, imageRect_circleoffscover, oval_thick, oval_thick);
                    %HERE I present the exo cue
                    %    Screen('FrameOval', w,ContCircEx, [imageRectendocues{tloc}(1)-cueExsize, imageRectendocues{tloc}(2)-cueExsize,imageRectendocues{tloc}(3)+cueExsize, imageRectendocues{tloc}(4)+cueExsize], oval_thickEx, oval_thickEx);
                    Screen('FrameRect', w, ContCircEx,imageRect_circleoffscover, oval_thick);
                    
                end
                
            elseif  (eyetime2-trial_time)>precuetime+ifi && (eyetime2-trial_time)<precuetime+cuedir+ifi && fixating>500
                
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                
                if  T==0
                    % EXO CUE
                    %                     imageRect_offscue=[imageRectcue(1)+eccentricity_X(cloc), imageRectcue(2)+eccentricity_Y(cloc),...
                    %                         imageRectcue(3)+eccentricity_X(cloc), imageRectcue(4)+eccentricity_Y(cloc)];
                    
                    %  Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{1}(1), imageRectendocues{tloc}(2)+thecuesEx{1}(2),imageRectendocues{tloc}(3)+thecuesEx{1}(3), imageRectendocues{tloc}(4)+thecuesEx{1}(4)]);
                    %  Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{2}(1), imageRectendocues{tloc}(2)+thecuesEx{2}(2),imageRectendocues{tloc}(3)+thecuesEx{2}(3), imageRectendocues{tloc}(4)+thecuesEx{2}(4)]);
                    % Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{3}(1), imageRectendocues{tloc}(2)+thecuesEx{3}(2),imageRectendocues{tloc}(3)+thecuesEx{3}(3), imageRectendocues{tloc}(4)+thecuesEx{3}(4)]);
                    %  Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{4}(1), imageRectendocues{tloc}(2)+thecuesEx{4}(2),imageRectendocues{tloc}(3)+thecuesEx{4}(3), imageRectendocues{tloc}(4)+thecuesEx{4}(4)]);
                    imageRect_circleoffscover=[imageRectcircles(1)+eccentricity_X(tloc), imageRectcircles(2)+eccentricity_Y(tloc),...
                        imageRectcircles(3)+eccentricity_X(tloc), imageRectcircles(4)+eccentricity_Y(tloc)];
                    Screen('FrameOval', w,gray, imageRect_circleoffscover, oval_thick, oval_thick);
                    %HERE I present the exo cue
                    %    Screen('FrameOval', w,ContCircEx, [imageRectendocues{tloc}(1)-cueExsize, imageRectendocues{tloc}(2)-cueExsize,imageRectendocues{tloc}(3)+cueExsize, imageRectendocues{tloc}(4)+cueExsize], oval_thickEx, oval_thickEx);
                    Screen('FrameRect', w, ContCircEx,imageRect_circleoffscover, oval_thick);
                    
                end
                
            elseif (eyetime2-trial_time)>=precuetime+cuedir+ifi && (eyetime2-trial_time)<=precuetime+cuedir+ifi+cuetargetISI && fixating>500
                
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                
                
            elseif (eyetime2-trial_time)>precuetime+cuedir+ifi+cuetargetISI && (eyetime2-trial_time)<=precuetime+cuedir+ifi+cuetargetISI+ifi*2 && fixating>500 && T<3%&& keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0
                
                imageRect_offs1=[imageRect1(1)+eccentricity_X(1), imageRect1(2)+eccentricity_Y(1),...
                    imageRect1(3)+eccentricity_X(1), imageRect1(4)+eccentricity_Y(1)];
                
                imageRect_offs2=[imageRect1(1)+eccentricity_X(2), imageRect1(2)+eccentricity_Y(2),...
                    imageRect1(3)+eccentricity_X(2), imageRect1(4)+eccentricity_Y(2)];
                imageRect_offs3=[imageRect1(1)+eccentricity_X(3), imageRect1(2)+eccentricity_Y(3),...
                    imageRect1(3)+eccentricity_X(3), imageRect1(4)+eccentricity_Y(3)];
                imageRect_offs4=[imageRect1(1)+eccentricity_X(4), imageRect1(2)+eccentricity_Y(4),...
                    imageRect1(3)+eccentricity_X(4), imageRect1(4)+eccentricity_Y(4)];
                
                
                imageRect_offs={imageRect_offs1 imageRect_offs2 imageRect_offs3 imageRect_offs4};
                
                if newtrialmatrix(trial,5)<5
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs{tloc}, ori,[], targetAlphaValue );
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                elseif newtrialmatrix(trial,5)==5
                    Screen('DrawTexture', w, whichLetter(newtrialmatrix(trial,5)-4), [], imageRect_offs{tloc}, 0,[], targetAlphaValue );
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                elseif newtrialmatrix(trial,5)>5
                    whichcue=newtrialmatrix(trial,5)-5;
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    % ENDO CUE
                    Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecues{whichcue}(1), imageRectendocues{tloc}(2)+thecues{whichcue}(2),imageRectendocues{tloc}(3)+thecues{whichcue}(3), imageRectendocues{tloc}(4)+thecues{whichcue}(4)]);
                end
                
                cici(trial)=22;
                stim_start(trial)=GetSecs;
                stim_star=GetSecs;
                
            elseif (eyetime2-trial_time)>precuetime+cuedir+ifi+cuetargetISI+ifi*2 && (eyetime2-trial_time)<precuetime+cuedir+ifi+cuetargetISI+stimdur && fixating>500 && T<3%&& keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0
                
                imageRect_offs1=[imageRect1(1)+eccentricity_X(1), imageRect1(2)+eccentricity_Y(1),...
                    imageRect1(3)+eccentricity_X(1), imageRect1(4)+eccentricity_Y(1)];
                imageRect_offs2=[imageRect1(1)+eccentricity_X(2), imageRect1(2)+eccentricity_Y(2),...
                    imageRect1(3)+eccentricity_X(2), imageRect1(4)+eccentricity_Y(2)];
                imageRect_offs3=[imageRect1(1)+eccentricity_X(3), imageRect1(2)+eccentricity_Y(3),...
                    imageRect1(3)+eccentricity_X(3), imageRect1(4)+eccentricity_Y(3)];
                imageRect_offs4=[imageRect1(1)+eccentricity_X(4), imageRect1(2)+eccentricity_Y(4),...
                    imageRect1(3)+eccentricity_X(4), imageRect1(4)+eccentricity_Y(4)];
                
                imageRect_offs={imageRect_offs1 imageRect_offs2 imageRect_offs3 imageRect_offs4};
                
                if newtrialmatrix(trial,5)<5
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs{tloc}, ori,[], targetAlphaValue );
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                elseif newtrialmatrix(trial,5)==5
                    Screen('DrawTexture', w, whichLetter(newtrialmatrix(trial,5)-4), [], imageRect_offs{tloc}, 0,[], targetAlphaValue );
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                elseif newtrialmatrix(trial,5)>5
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    % ENDO CUE
                    
                    whichcue=newtrialmatrix(trial,5)-5;
                    Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecues{whichcue}(1), imageRectendocues{tloc}(2)+thecues{whichcue}(2),imageRectendocues{tloc}(3)+thecues{whichcue}(3), imageRectendocues{tloc}(4)+thecues{whichcue}(4)]);
                end
                if exist('stim_star')==0
                    stim_start(trial)=GetSecs;
                    skipframe(trial)=1;
                end
                
            elseif (eyetime2-trial_time)>=precuetime+cuedir+ifi+cuetargetISI+stimdur && (eyetime2-trial_time)<precuetime+cuedir+ifi+cuetargetISI+stimdur+ifi*2 && fixating>500 && T<3 %&& keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0
                stim_stop(trial)=GetSecs;
                stim_sto=GetSecs;
                cici2(trial)=23;
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                % flicker
                
                
                if exist('postflickerstar') == 0
                    postflicker_time_start=GetSecs;
                    postflickerstar=1;
                    posttheSwitcher=0;
                    postflickswitch=0;
                    postflick=1;
                end
                postflicker_time=GetSecs-postflicker_time_start;
                
                if postflicker_time>postflickswitch
                    postflickswitch= postflickswitch+flickeringrate;
                    postflick=3-postflick;
                end
                
                if postflick==2 && newtrialmatrix(trial+1,1)==3 && trial<=length(newtrialmatrix(:,1)) && GetSecs-stim_start(trial)>=flickeringrate
                    posttheSwitcher=posttheSwitcher+1;
                    kkk=kkk+1;
                    countfl(trial,kkk)=GetSecs;
                    if doesitflicker==1
                        Screen('DrawTexture', w, whichLetter(1), [], imageRect_offs{tloc}, ori,[], targetAlphaValue );
                    end
                end
                
            elseif (eyetime2-trial_time)>=precuetime+cuedir+ifi+cuetargetISI+stimdur+ifi*2 && (eyetime2-trial_time)<=precuetime+cuedir+ifi+cuetargetISI+stimdur+poststimulustime && fixating>500 && T<3
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                
                
                if exist('postflickerstar') == 0
                    postflicker_time_start=GetSecs;
                    postflickerstar=1;
                    posttheSwitcher=0;
                    postflickswitch=0;
                    postflick=1;
                end
                %   flicker_time=GetSecs;
                postflicker_time=GetSecs-postflicker_time_start;
                
                if postflicker_time>postflickswitch
                    kkk3=kkk3+1;
                    countpostflick(kkk3)=postflick;
                    postflickswitch= postflickswitch+flickeringrate;
                    postflick=3-postflick;
                end
                
                if  postflick==2 && newtrialmatrix(trial,1)==3 && GetSecs-stim_start(trial)>=flickeringrate  || postflick==2 && newtrialmatrix(trial+1,1)==3 &&  trial<=length(newtrialmatrix(:,1)) && GetSecs-stim_start(trial)>=flickeringrate
                    
                    posttheSwitcher=posttheSwitcher+1;
                    kkk2=kkk2+1;
                    countfl2(trial,kkk2)=GetSecs;
                    cecco(kkk2)=GetSecs;
                    if doesitflicker==1
                        Screen('DrawTexture', w, whichLetter(1), [], imageRect_offs{tloc}, ori,[], targetAlphaValue );
                    end
                    %                  else
                end
            elseif  (eyetime2-trial_time)>precuetime+cuedir+ifi+cuetargetISI+stimdur+poststimulustime && fixating>500 && T<3
                %after last stimulus presentation, I wait for response
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                
                if exist('postflickerstar') == 0
                    postflicker_time_start=GetSecs;
                    postflickerstar=1;
                    posttheSwitcher=0;
                    postflickswitch=0;
                    postflick=1;
                end
                %   flicker_time=GetSecs;
                postflicker_time=GetSecs-postflicker_time_start;
                
                if postflicker_time>postflickswitch
                    kkk3=kkk3+1;
                    countpostflick(kkk3)=postflick;
                    postflickswitch= postflickswitch+flickeringrate;
                    postflick=3-postflick;
                end
                
                if  postflick==2 && newtrialmatrix(trial,1)==3 && GetSecs-stim_start(trial)>=flickeringrate || postflick==2 && newtrialmatrix(trial+1,1)==3 &&  trial<=length(newtrialmatrix(:,1)) && GetSecs-stim_start(trial)>=flickeringrate
                    
                    posttheSwitcher=posttheSwitcher+1;
                    kkk2=kkk2+1;
                    countfl2(trial,kkk2)=GetSecs;
                    cecco(kkk2)=GetSecs;
                    if doesitflicker==1
                        Screen('DrawTexture', w, whichLetter(1), [], imageRect_offs{tloc}, ori,[], targetAlphaValue );
                    end
                    %                  else
                end
                if exist('stim_sto')==0
                    stim_stop(trial)=GetSecs;
                    skipframestop(trial)=1;
                end
                
                clear stim_sto
                clear stim_star
                
                
                eyechecked=1111111111;
                
                
                if fixating>80
                    if numel(stim_start)<kk
                        stim_start(trial)=GetSecs;
                    end
                    time_stim(kk) = stim_stop(trial) - stim_start(trial);
                    totale_trials(kk)=trial;
                end
                
                if exist('resp')==1
                    rispo(kk)=resp;
                end
                quale(kk)=cloc;
                lori(kk)=ori;
                coordinate(trial).x=ecc_x_tgt;
                coordinate(trial).y=ecc_y_tgt;
                xxeye(trial).ics=[xeye];
                yyeye(trial).ipsi=[yeye];
                vbltimestamp(trial).ix=[VBL_Timestamp];
                flipptime(trial).ix=[fliptime];
                if EyeTracker==1
                    EyeSummary.(TrialNum).EyeData = EyeData;
                    
                    if ~exist('EyeCode','var')
                        EyeCode =9001;
                    end
                    if length(EyeCode)>length(EyeData)
                        EyeCode=0;
                    end
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
                    EyeSummary.(TrialNum).TargetX = ecc_x_tgt;
                    EyeSummary.(TrialNum).TargetY = ecc_y_tgt;
                    if trial>1
                        if T==0 %T==2 && newtrialmatrix(trial-1,1)==1 || newtrialmatrix(trial-1,1)==2 && T==2 && newtrialmatrix(trial-1,2)~=newtrialmatrix(trial,2)
                            EyeSummary.(TrialNum).cueX = ecc_x_cue;
                            EyeSummary.(TrialNum).cueY = ecc_y_cue;
                        else
                            EyeSummary.(TrialNum).cueX = 0;
                            EyeSummary.(TrialNum).cueY = 0;
                        end
                    else
                        EyeSummary.(TrialNum).cueX = 0;
                        EyeSummary.(TrialNum).cueY = 0;
                    end
                    
                    if exist('EvtInfo')==0
                        
                        EvtInfo=ones(1,153);
                    end
                    EyeSummary.(TrialNum).EventData = EvtInfo;
                    clear EvtInfo
                    EyeSummary.(TrialNum).ErrorData = ErrorData;
                    clear ErrorData
                    
                    EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
                    EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
                    EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
                    EyeSummary.(TrialNum).TimeStamps.Fixation = stim_start;
                    EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;
                    EyeSummary.(TrialNum).TimeStamps.Stimulus = stim_start;
                    clear ErrorInfo
                    
                end
                
                
            end
            
            eyefixation5
            
            
            if     newsamplex>fixationwindowRect(3)|| newsampley>fixationwindowRect(4) || newsamplex<fixationwindowRect(1) || newsampley<fixationwindowRect(2)
                
                Screen('FillRect', w, gray);
                if lookaway==1
                    Screen('FrameOval', w,ContCirc2, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc2, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc2, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc2, imageRect_circleoffs4, oval_thick, oval_thick);
                elseif lookaway==2
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                end
                if ScotomaPresent == 1
                    fixationscriptW
                end
            else
            end
            
            
            
            if ScotomaPresent == 1
                fixationscriptW
                Screen('FillOval', w, scotoma_color, scotoma);
            else
                fixationlength=10;
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
                
            end
            [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
            
            
            VBL_Timestamp=[VBL_Timestamp eyetime2];
            if EyeTracker==1
                
                if site<3
                    GetEyeTrackerData
                elseif site ==3
                    GetEyeTrackerDatapixx
                end
                if ~exist('EyeData','var')
                    EyeData = ones(1,5)*9001;
                end
                GetFixationDecision
                
                %                 if EyeData(1)<8000 && stopchecking<0
                %                     trial_time = GetSecs;
                %                     stopchecking=10;
                %                 end
                
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
            
            
            
            if sum(keyCode(RespType(1:6))+keyCode(escapeKey))~= 0 && stopfixating>80   % code review: why 80?  is this a parameter that should be set up top?
                
                if sum(contains(fieldnames(Response), (TrialNum))) ==0
                    Response.(TrialNum)=1;
                    thekeys = find(keyCode);
                    if length(thekeys)>1
                        thekeys=thekeys(1);
                    end
                    
                    thetimes=keyCode(thekeys);
                    [secs  indfirst]=min(thetimes);
                    
                    foo=(RespType==thekeys);
                    
                    if (thekeys==escapeKey) % esc pressed
                        closescript = 1;
                        ListenChar(0);
                        break;
                    end
                    if trial==1
                        if foo(theans(trial))
                            resp = 1;
                            PsychPortAudio('Start', pahandle1);
                        else
                            resp=-1;
                            PsychPortAudio('Start', pahandle2);
                        end
                        respo(trial)=resp;
                        respTimeSTamp(trial)=GetSecs;
                        respRT(trial)=GetSecs-stim_start(trial);
                    elseif trial==2
                        if foo(theans(trial)) || foo(theans(trial-1)) %some leeway for participants  % code review: not clear to me exactly what this is going to do.  consider whether it causes an error where participants are getting 'correct' even on trials where they were not correct?
                            resp = 1;
                            PsychPortAudio('Start', pahandle1);
                            if foo(theans(trial))
                                respo(trial)=resp;
                                respTimeSTamp(trial)=GetSecs;
                                respRT(trial)=GetSecs-stim_start(trial);
                            elseif  foo(theans(trial-1))
                                respo(trial-1)=resp;
                                respTimeSTamp(trial-1)=GetSecs;
                                respRT(trial-1)=GetSecs-stim_start(trial-1);
                            end
                        else
                            resp = -1;
                            if theans(trial-1)<5
                                respo(trial-1)=resp;
                                respTimeSTamp(trial-1)=GetSecs;
                                respRT(trial-1)=GetSecs-stim_start(trial-1);
                            elseif theans(trial)<5
                                respo(trial)=resp;
                                respTimeSTamp(trial)=GetSecs;
                                respRT(trial)=GetSecs-stim_start(trial);
                            end
                            PsychPortAudio('Start', pahandle2);
                        end
                        
                    elseif trial>2
                        if foo(theans(trial)) || foo(theans(trial-1)) || foo(theans(trial-2))
                            
                            if foo(theans(trial))
                                respo(trial)=resp;
                                respTimeSTamp(trial)=GetSecs;
                                %                                 if exist('stim_star')==0
                                %                                     stim_start(trial)=GetSecs;
                                %                                     skipframe2(trial)=1;
                                %                                 end
                                if length(stim_start)==trial
                                    respRT(trial)=GetSecs-stim_start(trial);
                                    resp = 1;
                                    PsychPortAudio('Start', pahandle1);
                                else
                                    wrongcount(trial)=99;
                                    PsychPortAudio('Start', pahandle2);
                                    
                                end
                                countzeropre(trial)=99;
                            elseif  foo(theans(trial-1)) && sum(contains(fieldnames(Response), ([['Trial' num2str(trial-1)]])))<1 %one back
                                respo(trial-1)=resp;
                                respTimeSTamp(trial-1)=GetSecs;
                                
                                respRT(trial-1)=GetSecs-stim_start(trial-1);
                                resp = 1;
                                PsychPortAudio('Start', pahandle1);
                                countonepre(trial)=99;
                            elseif foo(theans(trial-2)) && sum(contains(fieldnames(Response), ([['Trial' num2str(trial-1)]])))<1 %two back
                                respo(trial-2)=resp;
                                respTimeSTamp(trial-2)=GetSecs;
                                respRT(trial-2)=GetSecs-stim_start(trial-2);
                                resp = 1;
                                PsychPortAudio('Start', pahandle1);
                                counttwopre(trial)=99;
                            end
                            
                        else
                            resp = -1;
                            if theans(trial-2)<5
                                respo(trial-2)=resp;
                                respTimeSTamp(trial-2)=GetSecs;
                                respRT(trial-2)=GetSecs-stim_start(trial-2);
                            elseif theans(trial-1)<5
                                respo(trial-1)=resp;
                                respTimeSTamp(trial-1)=GetSecs;
                                respRT(trial-1)=GetSecs-stim_start(trial-1);
                            elseif theans(trial)<5
                                respo(trial)=resp;
                                respTimeSTamp(trial)=GetSecs;
                                
                                %                                 if exist('stim_star')==0
                                %                                     stim_start(trial)=GetSecs;
                                %                                     skipframe2(trial)=1;
                                %                                 end
                                
                                if length(stim_start)==trial
                                    respRT(trial)=GetSecs-stim_start(trial);
                                else
                                    wrongcounter(trial)=99;
                                end
                                %  respo(trial)=resp
                            end
                            PsychPortAudio('Start', pahandle2);
                        end
                        
                    end
                end
                %   KbQueueFlush()
                % end
                
            end
        end
        
        
        if (mod(trial,200))==1
            if trial==1
            else
                save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).'); % code review: it looks like this saves every 200 trials.  consider saving more often (during a break) to avoid losing data.
            end
        end
        
        
        
        if closescript==1
            break
        end
        
        kk=kk+1;
    end
    %% Clean up and Save
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
    
    if exist('respo')==1
        if length(respo)<trial
            s=trial-length(respo);
            ss=nan(1,s);
            
            respo=[respo ss];
        end
        if length(respRT)<trial
            s=trial-length(respRT);
            ss=nan(1,s);
            respRT=[respRT ss];
        end
        sss=[(1:length(respo))' newtrialmatrix(1:length(respo),:) respo' respRT'];
    end
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    
    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
    ListenChar(0);
    Screen('Flip', w);
    KbQueueWait;
    
    ShowCursor;
    
    if site==0
        Screen('CloseAll');
        %  Screen('Preference', 'SkipSyncTests', 0);
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
    
    %%
    if exist('respo')==1
        if length(respo)<trial
            s=trial-length(respo);
            ss=nan(1,s);
            %  respo=[respo;ss']
            % respo=[respo;ss]
            % respo=respo'
            respo=[respo ss];
        end
        if length(respRT)<trial
            s=trial-length(respRT);
            ss=nan(1,s);
            respRT=[respRT ss];
        end
        sss=[(1:length(respo))' newtrialmatrix(1:length(respo),:) respo' respRT'];
    end
    
catch ME
    psychlasterror()
end