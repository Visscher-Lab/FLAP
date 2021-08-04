
% FLAP Attention task via RSVP streams on 3 peripheral location
% Marcello Maniglia 7/21/2021
close all; clear all; clc;
commandwindow

try
    prompt={'Subject Name', 'day'};
    
    name= 'Subject Name';
    numlines=1;
    defaultanswer={'1', '15' };
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    addpath([cd '/utilities']);
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    expdayeye=answer{2,:};
    
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data');
    end
    baseName=['./data/' SUBJECT 'flap_attention_stream' expdayeye '_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    
    Screen('Preference', 'SkipSyncTests', 1);
    PC=getComputerName();
    max_size=10;
    n_blocks=1;
    reps=100;
    v_d=57;
    sigma_deg = 1; %4;
    sfs=3;
    color=0;
    BITS=0; %0; 1=bits++; 2=display++
    randomizzato=0;
    
    if color ==1
        ContCirc= [0 70 0];
        ContCirc2= [70 0 0];
    elseif color ==0
        ContCirc= [150 150 150];
        ContCirc2= [225 225 225];
    end
    
    alphastim=.8;
    fixat=1;
    SOA=.6;
    closescript=0;
    kk=1;
    stimulus_contingent=1;
    %cuedir=.05;
    precuetime=.1;
    cuedir=1.05;   %.05
    %cuedir=1.05;   %.05
    cuetargetISI=.05;
    stimdur=0.133; %.133
    stimdur=0.533; %.133
    poststimulustime=.1;
    oval_thick=10; %thickness of oval
    cue_size=6;
    endocue=1;
    stimulussize=2;
    circle_size=4.5; % dimension of the circles
    eyeOrtrack=1; %0=mouse, 1=eyetracker
    newswitch=1;
    fixationwindow=6; % diameter
    
    fixwindow=2;
    fixTime=1.2;
    fixTime2=0.2;
    
    
    if eyeOrtrack==1
        EyeTracker = 1; % set to 1 for UAB code testing
        EyetrackerType=1;
    elseif eyeOrtrack==0
        EyeTracker=0;
    end
    
    KbQueueCreate;
    KbQueueStart;
    
    KbName('UnifyKeyNames')
    %if ispc
    %   escapeKey = KbName('esc');	% quit key
    %elseif ismac
    escapeKey = KbName('ESCAPE');	% quit key
    %end
    
    if BITS==1  %UCR
        %% psychtoobox settings
        screencm=[40.6 30];
        %load gamma197sec;
        %load lut_12bits_pd; Disabled until display is calibrated
        AssertOpenGL;
        oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
        %PsychGPUControl('SetDitheringEnabled', 0); Not supported on OSX
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
    elseif BITS==0
        
        %% psychtoobox settings
        AssertOpenGL;
        screenNumber=max(Screen('Screens'));
        PsychImaging('PrepareConfiguration');
        %  PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
        screencm=[40.6 30];
        screencm=[41 30.5];
        oldResolution=Screen( 'Resolution',screenNumber,1280,1024);
        SetResolution(screenNumber, oldResolution);
        [w, wRect]=PsychImaging('OpenWindow',screenNumber, 0,[],32,2);
        %debug window
        %[w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640480],32,2);
        %ScreenParameters=Screen('Resolution', screenNumber); %close all
        Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
    elseif BITS==2   %UAB
        screencm=[69.8, 35.5];
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
    end
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    struct.sz=[screencm(1), screencm(2)];
    
    pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi));
    pix_deg_vert = pi * wRect(4) / atan(screencm(2)/v_d/2) / 360;
    pix_deg_vert=1./((2*atan((screencm(2)/wRect(4))./(2*v_d))).*(180/pi));
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

    prefixwait=ifi*40;
    if stimulus_contingent==1
        waittime=0;
        durfix=0;
    elseif stimulus_contingent==0
        waittime=ifi*50;
        durfix=.133;    %.133
    end
    
    
    % SOUND
    InitializePsychSound;
    pahandle = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    pahandle1 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    pahandle2 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    
    
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
    load('S096_marl-nyu');
    
    
    if EyeTracker==1
        useEyeTracker = 0; % otherwise will throw error if not UAB run
        
        eyeTrackerBaseName =[SUBJECT expdayeye];
        
        %    save_dir= 'C:\Users\labadmin\Desktop\marcello AMD assessment\7.Training\test_eyetracker_files';
        
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
            mkdir('dataeyet')
        end;
        save_dir=[cd './dataeyet/'];
        
    end;
  
    fixationlength = 10; % pixels
    fixwindowPix=fixwindow*pix_deg;
    
    %% gabor settings and fixation point
    
    bg_index =round(gray*255); %background color
    
    
    if EyeTracker == 1
        
        
        
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
        %   Eyelink('command', 'calibration_type = HV5'); % changed to 5 to correct upper left corner of the screen issue
        % you must send this command with value NO for custom calibration
        % you must also reset it to YES for subsequent experiments
        %   Eyelink('command', 'generate_default_targets = NO');
        
        
        %% Modify target locations
        % due to issues with calibrating the upper left corner of the screen the following lines have been
        % commmented out to change the the sampling from 10 to 5 as
        % listed in line 323
        Eyelink('command','calibration_samples = 10');
        Eyelink('command','calibration_sequence = 0,1,2,3,4,5,6,7,8,9');
        %
        %             modFactor = 0.183;
        %
        %             Eyelink('command','calibration_targets = %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
        %                 round(winWidth/2), round(winHeight/2),  round(winWidth/2), round(winHeight*modFactor),  ...
        %                 round(winWidth/2), round(winHeight - winHeight*modFactor),  round(winWidth*modFactor), ...
        %                 round(winHeight/2),  round(winWidth - winWidth*modFactor), round(winHeight/2), ...
        %                 round(winWidth*modFactor), round(winHeight*modFactor), round(winWidth - winWidth*modFactor), ...
        %                 round(winHeight*modFactor), round(winWidth*modFactor), round(winHeight - winHeight*modFactor),...
        %                 round(winWidth - winWidth*modFactor), round(winHeight - winHeight*modFactor) );
        %
        %             Eyelink('command','validation_samples = 5');
        Eyelink('command','validation_samples = 10'); %changed to make
        % it 5 samples instead of 10 to deal with upper left corner of
        % the screem issue
        Eyelink('command','validation_sequence = 0,1,2,3,4,5,6,7,8,9');
        %             Eyelink('command','validation_targets =  %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
        %                 round(winWidth/2), round(winHeight/2),  round(winWidth/2), round(winHeight*modFactor),  ...
        %                 round(winWidth/2), round(winHeight - winHeight*modFactor),  round(winWidth*modFactor), ...
        %                 round(winHeight/2),  round(winWidth - winWidth*modFactor), round(winHeight/2), ...
        %                 round(winWidth*modFactor), round(winHeight*modFactor), round(winWidth - winWidth*modFactor), ...
        %                 round(winHeight*modFactor), round(winWidth*modFactor), round(winHeight - winHeight*modFactor),...
        %                 round(winWidth - winWidth*modFactor), round(winHeight - winHeight*modFactor)  );
        %
        % make sure that we get gaze data from the Eyelink
        Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
        Eyelink('OpenFile', eyeTrackerFileName); % open file to record data  & calibration
        EyelinkDoTrackerSetup(elHandle);
        Eyelink('dodriftcorrect');
    end
    
    
    %% main loop
    HideCursor;
    counter = 0;
    
    e_X=-180;
    e_XX =180;
    e_Y=180;
    e_YY=-180;
    
    
    imageRect = CenterRect([0, 0, [wRect(4)/10 wRect(4)/10]], wRect);
    imRect_offs =[imageRect(1)+e_X, imageRect(2)+e_Y,...
        imageRect(3)+e_X, imageRect(4)+e_Y];
    imRect_offs2 =[imageRect(1)+e_XX, imageRect(2)+e_Y,...
        imageRect(3)+e_XX, imageRect(4)+e_Y];
    imRect_offs3 =[imageRect(1)+e_XX, imageRect(2)+e_YY,...
        imageRect(3)+e_XX, imageRect(4)+e_YY];
    imRect_offs4 =[imageRect(1)+e_X, imageRect(2)+e_YY,...
        imageRect(3)+e_X, imageRect(4)+e_YY];
    
    
    ori_1=0;
    ori_2=90;
    ori_3=180;
    ori_4=270;
    
    theLetter=imread('newletterc22.tiff');
    %theLetter=imread('target_black.tiff');
    
    theLetter=theLetter(:,:,1);
    theLetter=imresize(theLetter,[300 300],'bicubic');
    theLetter=Screen('MakeTexture', w, theLetter);
    
    
    WaitSecs(1);
    Screen('TextFont',w, 'Arial');
    Screen('TextSize',w, 42);
    
    %     Screen('TextStyle', w, 1+2);
    Screen('FillRect', w, gray);
    colorfixation = black;
    DrawFormattedText(w, 'report where the gap of the C is using the arrow keys \n \n a visual cue will indicate the next location of the target \n \n \n \n Press any key to start', 'center', 'center', black);
    % Screen('TextSize',w, 100);
    % Screen('TextFont',w, 'Sloan');
    % DrawFormattedText(w, 'D \n \n L \n \n \n \n R \n \n C', 'center', 'center', 0);
    Screen('Flip', w);
    KbQueueWait;
    WaitSecs(1);
    DrawFormattedText(w, 'Press Right key' , imRect_offs(1)-20, imRect_offs(2)-80, black);
    DrawFormattedText(w, 'Press Down key' , imRect_offs2(1)-20, imRect_offs2(2)-80, black);
    DrawFormattedText(w, 'Press Left key', imRect_offs3(1)-20, imRect_offs3(2)-80, black);
    DrawFormattedText(w, 'Press Up key', imRect_offs4(1)-20, imRect_offs4(2)-80, black);
    
    Screen('DrawTexture',w,theLetter,[],imRect_offs, ori_1 );%
    Screen('DrawTexture',w,theLetter,[],imRect_offs2, ori_2);%
    Screen('DrawTexture',w,theLetter,[],imRect_offs3, ori_3 );%
    Screen('DrawTexture',w,theLetter,[],imRect_offs4, ori_4);%
    Screen('Flip', w);
    WaitSecs(1);
    KbQueueWait;
    % KbWait;
    Screen('Flip', w);
    %possible orientations
    % theoris=[22.5 67.5 -22.5 -67.5 ];
    theoris=[0 180 270 90 991 992 993 994 995];
    
    [xc, yc] = RectCenter(wRect); % coordinate del centro schermo
    
    PRL_x_axis=0;
    PRL_y_axis=-8;
    
    
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
    RespType(5:8) = KbName('w');
    
    
    %load testswitchmatrix.mat;
    
    %load anotherpossiblemixtr;
    
    %load sundaymatrix2.mat
    
    %load shortTrialAttMatrix.mat
    load fullTrialAttMatrix.mat
    
    newtrialmatrix=totalnewnewtrial_incongruent2;
   
    
    % check EyeTracker status
    if EyeTracker == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        % mark zero-plot time in data file
        Eyelink('message' , 'SYNCTIME');
        
        location =  zeros(length(newtrialmatrix), 6);
    end
    eyetime2=0;
    
    scotomadeg=10;
    scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg_vert];
    scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
    %scotoma_color=[100 100 100];
    scotoma_color=[200 200 200];
    cue_color=[255 255 255];
    
    
    
    imageRectcue = CenterRect([0, 0, [cue_size*pix_deg cue_size*pix_deg_vert]], wRect);
    
    imageRectcircles = CenterRect([0, 0, [circle_size*pix_deg circle_size*pix_deg_vert]], wRect);
    
    fixationwindowRect = CenterRect([0, 0, [fixationwindow*pix_deg fixationwindow*pix_deg_vert]], wRect);
    
    
    
    
    %imsize=((VA_threshold*pix_deg)/2);
    imsize=stimulussize*pix_deg;
    imsize2=stimulussize*pix_deg_vert;
    [x,y]=meshgrid(-imsize:imsize,-imsize2:imsize2);
    %circular mask
    xylim = imsize; %radius of circular mask
    circle = x.^2 + y.^2 <= xylim^2;
    [nrw, ncl]=size(x);
    
    
    %theLetter=imread('target_black.tiff');
    theLetter=imread('newletterc22.tiff');
    theLetter=theLetter(:,:,1);
    theLetter=imresize(theLetter,[nrw ncl],'bicubic');
    %       theLetter=imresize(theLetter,[300 300],'bicubic');
    theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
    theLetterO=theLetter;
    theLetter=Screen('MakeTexture', w, theLetter);
    theLetterO(:,ncl/2+1:end)=theLetterO(:,ncl/2:-1:1);
    %      theLetterO=Screen('MakeTexture', w, theLetterO);
    whichLetter(1)=Screen('MakeTexture', w, theLetterO);
    
    
    theLetterl=imread('letter_l2.tiff');
    %                         theLetterl=imread('letter_d2.tiff');
    theLetterl=theLetterl(:,:,1);
    theLetterl=imresize(theLetterl,[nrw ncl],'bicubic');
    % theLetterl = double(circle) .* double(theLetterl)+bg_index * ~double(circle);
    % theLetterl=Screen('MakeTexture', w, theLetterl);
    whichLetter(2)=Screen('MakeTexture', w, theLetterl);
    
    theLetterr=imread('letter_r2.tiff');
    theLetterr=theLetterr(:,:,1);
    theLetterr=imresize(theLetterr,[nrw ncl],'bicubic');
    %  theLetterr = double(circle) .* double(theLetterr)+bg_index * ~double(circle);
    %  theLetterr=Screen('MakeTexture', w, theLetterr);
    whichLetter(3)=Screen('MakeTexture', w, theLetterr);
    
    theLetterd=imread('letter_d2.tiff');
    theLetterd=theLetterd(:,:,1);
    theLetterd=imresize(theLetterd,[nrw ncl],'bicubic');
    %  theLetterd = double(circle) .* double(theLetterd)+bg_index * ~double(circle);
    %  theLetterd=Screen('MakeTexture', w, theLetterd);
    whichLetter(4)=Screen('MakeTexture', w, theLetterd);
    
    imageRect1 = CenterRect([0, 0, [stimulussize*pix_deg stimulussize*pix_deg_vert]], wRect);
    imageRectendocue = CenterRect([0, 0, [endocue*pix_deg endocue*pix_deg_vert]], wRect);
    
    thecue=imread('ccue2.tiff');
    thecue=thecue(:,:,1);
    thecue=imresize(thecue,[nrw ncl],'bicubic');
    % thecue = double(circle) .* double(thecue)+bg_index * ~double(circle);
    
    
    cueimage=Screen('MakeTexture', w, thecue);
    
    cueleft=[-circle_size*pix_deg/2 0  -circle_size*pix_deg/2 0];
    cueright=[circle_size*pix_deg/2 0  circle_size*pix_deg/2 0];
    cuedown=[0 circle_size*pix_deg/2 0  circle_size*pix_deg/2 ];
    cueup=[0 -circle_size*pix_deg/2 0  -circle_size*pix_deg/2 ];
        
    thecues={cueup cueright cuedown cueleft};
   % thecuesEx={cueleft cueright cuedown cueup};
    
    thecuesEx=thecues;
    xeye=[];
    yeye=[];
    VBL_Timestamp=[];
    stimonset=[ ];
    fliptime=[ ];
    mss=[ ];
    tracktime=[];
    
    for trial=1:length(newtrialmatrix)

        if trial>2 && trial<=length(newtrialmatrix)-1
            if newtrialmatrix(trial,1)==3 && newtrialmatrix(trial-1,1)~=newtrialmatrix(trial+1,1)   &&    newtrialmatrix(trial-1,1)~=0
                switch_task_script
            end
        end
        
        if trial==length(newtrialmatrix)/2+1
            switch_task_script

        end
        if sum(trial==totaltrialbreak)>0
            interblock_instruction;
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
        if trial==1
            fixating=0;
        else
            fixating=10001213212;
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
        
        
        %(trial)=trialmatrix(trial,3);
        theans(trial)=newtrialmatrix(trial,5);
        
        %   theans(trial)=newtrial(trial,3);
        %T=newtrial(trial,2)
        
       % coding target ori or cue
        ori_i(trial)=theans(trial);
        ori= theoris(ori_i(trial));
        
        eyechecked=0;
        
        KbQueueFlush();
        %trial_time = GetSecs;
        pretrial_time=GetSecs;
        trial_time=-1000;
        fixstart=100000;
        stopfixating=0;
        stopfixating2=0;
        %  T=trialmatrix(trial,2);
        T=newtrialmatrix(trial,1);
        
        
        if T==1 && newtrialmatrix(trial,5)<=5 || T==2 || T==3 %duration foil/non cued stimulus
            precuetime=.1;
            cuedir=.05;   %.05
            cuetargetISI=.05;
            %   stimdur=0.133; %.133
            stimdur=0.333; %.133
            poststimulustime=.1;
        elseif T==1 && newtrialmatrix(trial,5)>5   %duration endogenous stimulus
            precuetime=.1;
            cuedir=.05;   %.05
            %cuedir=1.05;   %.05
            cuetargetISI=.05;
            %   stimdur=0.133; %.133
            stimdur=0.2; %.133
            %   poststimulustime=.05;
        elseif T==0                     %duration exogenous stimulus
            precuetime=.2;
            cuedir=.05;   %.05
            %cuedir=1.05;   %.05
            cuetargetISI=.05;
            %   stimdur=0.133; %.133
            stimdur=0.333; %.133
            poststimulustime=.1;
        end
        
        
        if trial>1
            if T==0 || newtrialmatrix(trial-1,5)>5
                poststimulustime=1.5;
            elseif T==1 && newtrialmatrix(trial-1,5)>5
                precuetime=.1;
                cuedir=0;   %.05
                cuetargetISI=0;
                %   stimdur=0.133; %.133
                stimdur=0.333; %.133
                poststimulustime=.1;
                
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
        
        
        % if trial>1
        
        
        %    end
        
        
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
 
            if T==3
                                             
                if (eyetime2-pretrial_time)>=0 && (eyetime2-pretrial_time)<=prefixwait+28*ifi
                    
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                elseif (eyetime2-pretrial_time)>prefixwait+28*ifi && (eyetime2-pretrial_time)<prefixwait+30*ifi && stopfixating<80 && sum(keyCode(RespType(1:6)))== 0
                    
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs{tloc}, ori,[], alphastim );
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                    stim_start(trial)=GetSecs;
                    stim_star=GetSecs;
                    
                elseif (eyetime2-pretrial_time)>prefixwait+30*ifi && stopfixating<80 && sum(keyCode(RespType(1:6))+keyCode(escapeKey))== 0
                    
                    if exist('stim_star')==0
                        stim_star=GetSecs;
                        stim_start(trial)=stim_star;
                        skipframe(trial)=1;
                    end
                    
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs{tloc}, ori,[], alphastim );
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                elseif      (eyetime2-pretrial_time)>prefixwait+30*ifi+ifi*20 && stopfixating<80 && sum(keyCode(RespType(1:6))+keyCode(escapeKey))~= 0

                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                    thekeys = find(keyCode);
                    thetimes=keyCode(thekeys);
                    [secs  indfirst]=min(thetimes);
                    
                    foo=(RespType==thekeys);
                    fixating=1500;
                    stopfixating=100;
                    trial_time = GetSecs;
                    
                    if (thekeys==escapeKey) % esc pressed
                        closescript = 1;
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
                    respRT(trial)=secs-stim_start(trial);
                    eyechecked=1111111111;
                end
            end
            
            
            
            if (eyetime2-trial_time)>=0 && (eyetime2-trial_time)<precuetime  && fixating>400
                
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                
            elseif (eyetime2-trial_time)>=precuetime && (eyetime2-trial_time)<=precuetime+ifi && fixating>400
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                
                
                if  T==0                     % Presents Cue
                    cueonset=GetSecs; %clear the screen
                    %Fill the buffer and play our sound
                    cueontime=cueonset + (ifi * 0.5);
                    %      PsychPortAudio('Start', pahandle,1,inf); %starts sound at infinity
                    %  PsychPortAudio('RescheduleStart', pahandle, cueontime, 0) %reschedules startime to
                    
                    
                    imageRect_offscue=[imageRectcue(1)+eccentricity_X(cloc), imageRectcue(2)+eccentricity_Y(cloc),...
                        imageRectcue(3)+eccentricity_X(cloc), imageRectcue(4)+eccentricity_Y(cloc)];
                    
                    
                    cuecounter(trial)=1;
                    %  Screen('DrawTexture', w, cueimage, [], imageRect_offscue, 0,[], alphastim );
                    
                    %
                    
                    Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{1}(1), imageRectendocues{tloc}(2)+thecuesEx{1}(2),imageRectendocues{tloc}(3)+thecuesEx{1}(3), imageRectendocues{tloc}(4)+thecuesEx{1}(4)]);
                    Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{2}(1), imageRectendocues{tloc}(2)+thecuesEx{2}(2),imageRectendocues{tloc}(3)+thecuesEx{2}(3), imageRectendocues{tloc}(4)+thecuesEx{2}(4)]);
                    Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{3}(1), imageRectendocues{tloc}(2)+thecuesEx{3}(2),imageRectendocues{tloc}(3)+thecuesEx{3}(3), imageRectendocues{tloc}(4)+thecuesEx{3}(4)]);
                    Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{4}(1), imageRectendocues{tloc}(2)+thecuesEx{4}(2),imageRectendocues{tloc}(3)+thecuesEx{4}(3), imageRectendocues{tloc}(4)+thecuesEx{4}(4)]);
                    
                end
                %   end
                
            elseif  (eyetime2-trial_time)>precuetime+ifi && (eyetime2-trial_time)<precuetime+cuedir+ifi && fixating>500
                
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                
                %  if  trial>1
                if  T==0 %newtrialmatrix(trial-1,1)==1 && T==2 || newtrialmatrix(trial-1,1)==2 && T==2 && newtrialmatrix(trial,2)~=newtrialmatrix(trial-1,2)
                    
                    imageRect_offscue=[imageRectcue(1)+eccentricity_X(cloc), imageRectcue(2)+eccentricity_Y(cloc),...
                        imageRectcue(3)+eccentricity_X(cloc), imageRectcue(4)+eccentricity_Y(cloc)];
                    
                    %             Screen('DrawTexture', w, cueimage, [], imageRect_offscue, 0,[], alphastim );
                    Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{1}(1), imageRectendocues{tloc}(2)+thecuesEx{1}(2),imageRectendocues{tloc}(3)+thecuesEx{1}(3), imageRectendocues{tloc}(4)+thecuesEx{1}(4)]);
                    Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{2}(1), imageRectendocues{tloc}(2)+thecuesEx{2}(2),imageRectendocues{tloc}(3)+thecuesEx{2}(3), imageRectendocues{tloc}(4)+thecuesEx{2}(4)]);
                    Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{3}(1), imageRectendocues{tloc}(2)+thecuesEx{3}(2),imageRectendocues{tloc}(3)+thecuesEx{3}(3), imageRectendocues{tloc}(4)+thecuesEx{3}(4)]);
                    Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecuesEx{4}(1), imageRectendocues{tloc}(2)+thecuesEx{4}(2),imageRectendocues{tloc}(3)+thecuesEx{4}(3), imageRectendocues{tloc}(4)+thecuesEx{4}(4)]);
                    
                end
                %    end
                
            elseif (eyetime2-trial_time)>=precuetime+cuedir+ifi && (eyetime2-trial_time)<=precuetime+cuedir+ifi+cuetargetISI && fixating>500
                
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                
                
            elseif (eyetime2-trial_time)>precuetime+cuedir+ifi+cuetargetISI && (eyetime2-trial_time)<=precuetime+cuedir+ifi+cuetargetISI+ifi*2 && fixating>500 && T<3;%&& keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0
                
                imageRect_offs1=[imageRect1(1)+eccentricity_X(1), imageRect1(2)+eccentricity_Y(1),...
                    imageRect1(3)+eccentricity_X(1), imageRect1(4)+eccentricity_Y(1)];
                
                imageRect_offs2=[imageRect1(1)+eccentricity_X(2), imageRect1(2)+eccentricity_Y(2),...
                    imageRect1(3)+eccentricity_X(2), imageRect1(4)+eccentricity_Y(2)];
                imageRect_offs3=[imageRect1(1)+eccentricity_X(3), imageRect1(2)+eccentricity_Y(3),...
                    imageRect1(3)+eccentricity_X(3), imageRect1(4)+eccentricity_Y(3)];
                imageRect_offs4=[imageRect1(1)+eccentricity_X(4), imageRect1(2)+eccentricity_Y(4),...
                    imageRect1(3)+eccentricity_X(4), imageRect1(4)+eccentricity_Y(4)];
                
                
                imageRect_offs={imageRect_offs1 imageRect_offs2 imageRect_offs3 imageRect_offs4};
                %    imageRect_offs_other={imageRect_offs1 imageRect_offs2 imageRect_offs3};
                
                if newtrialmatrix(trial,5)<5
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs{tloc}, ori,[], alphastim );
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                elseif newtrialmatrix(trial,5)==5
                    Screen('DrawTexture', w, whichLetter(newtrialmatrix(trial,5)-4), [], imageRect_offs{tloc}, 0,[], alphastim );
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
                    
                    Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecues{whichcue}(1), imageRectendocues{tloc}(2)+thecues{whichcue}(2),imageRectendocues{tloc}(3)+thecues{whichcue}(3), imageRectendocues{tloc}(4)+thecues{whichcue}(4)]);
                end
                
                
                cici(trial)=22;
                stim_start(trial)=GetSecs;
                stim_star=GetSecs;
                
                
            elseif (eyetime2-trial_time)>precuetime+cuedir+ifi+cuetargetISI+ifi*2 && (eyetime2-trial_time)<precuetime+cuedir+ifi+cuetargetISI+stimdur && fixating>500 && T<3;%&& keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0
                
                
                %           Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                %        Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                %        Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
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
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs{tloc}, ori,[], alphastim );
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                elseif newtrialmatrix(trial,5)==5
                    Screen('DrawTexture', w, whichLetter(newtrialmatrix(trial,5)-4), [], imageRect_offs{tloc}, 0,[], alphastim );
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                elseif newtrialmatrix(trial,5)>5
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                    Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                    
                    whichcue=newtrialmatrix(trial,5)-5;
                    Screen('FillOval', w, cue_color, [imageRectendocues{tloc}(1)+thecues{whichcue}(1), imageRectendocues{tloc}(2)+thecues{whichcue}(2),imageRectendocues{tloc}(3)+thecues{whichcue}(3), imageRectendocues{tloc}(4)+thecues{whichcue}(4)]);
                end
                if exist('stim_star')==0
                    stim_start(trial)=GetSecs;
                    skipframe(trial)=1;
                end
                
            elseif (eyetime2-trial_time)>=precuetime+cuedir+ifi+cuetargetISI+stimdur && (eyetime2-trial_time)<precuetime+cuedir+ifi+cuetargetISI+stimdur+ifi*2 && fixating>500 && T<3;%&& keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0
                stim_stop(trial)=GetSecs;
                stim_sto=GetSecs;
                cici2(trial)=23;
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                
                
                
            elseif (eyetime2-trial_time)>=precuetime+cuedir+ifi+cuetargetISI+stimdur+ifi*2 && (eyetime2-trial_time)<=precuetime+cuedir+ifi+cuetargetISI+stimdur+poststimulustime && fixating>500 && T<3
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                
                
                %  elseif
            elseif  (eyetime2-trial_time)>precuetime+cuedir+ifi+cuetargetISI+stimdur+poststimulustime && fixating>500 && T<3
                
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc, imageRect_circleoffs4, oval_thick, oval_thick);
                
                
                if exist('stim_sto')==0
                    stim_stop(trial)=GetSecs;
                    skipframestop(trial)=1;
                end
                
                clear stim_sto
                clear stim_star
                
                
                eyechecked=1111111111;
                %         resp = NaN;
                %   if exist(respo(trial))==0
                %                                                 respo(trial)=resp
                %   end
                
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
                if eyeOrtrack==1
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
            
            eyefixation3
  
            
            if     newsamplex>fixationwindowRect(3)|| newsampley>fixationwindowRect(4) || newsamplex<fixationwindowRect(1) || newsampley<fixationwindowRect(2)
                
                Screen('FillRect', w, gray);
                Screen('FrameOval', w,ContCirc2, imageRect_circleoffs1, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc2, imageRect_circleoffs2, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc2, imageRect_circleoffs3, oval_thick, oval_thick);
                Screen('FrameOval', w,ContCirc2, imageRect_circleoffs4, oval_thick, oval_thick);
                
            else
              end

            Screen('FillOval', w, scotoma_color, scotoma);

            [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
            
            
            VBL_Timestamp=[VBL_Timestamp eyetime2];

            
            if eyeOrtrack==1
                GetEyeTrackerData
                if ~exist('EyeData','var')
                    EyeData = ones(1,5)*9001;
                end
                GetFixationDecision
                
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
            
            
            %  if keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3))+keyCode(RespType(4))+keyCode(RespType(5:8))+keyCode(escapeKey)~= 0 && stopfixating>80
            
            if sum(keyCode(RespType(1:6))+keyCode(escapeKey))~= 0 && stopfixating>80
                
                %  if trial<3
                %      resp = -1;
                % respo(trial)=resp
                %      PsychPortAudio('Start', pahandle2);
                
                %  elseif trial>=3
                
                thekeys = find(keyCode);
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
                
                foo=(RespType==thekeys);
                
                
                % staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1
                % ),mixtr(trial,2))+1;
                % Threshlist(mixtr(trial),staircounter(mixtr(trial)))=siz(mixtr(trial,1), mixtr(trial,2));
                
                
                if (thekeys==escapeKey) % esc pressed
                    closescript = 1;
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
                    respTimeSTamp(trial)=secs;
                    respRT(trial)=secs-stim_start(trial);
                elseif trial==2
                    if foo(theans(trial)) || foo(theans(trial-1))
                        resp = 1;
                        PsychPortAudio('Start', pahandle1);
                        if foo(theans(trial))
                            respo(trial)=resp;
                            respTimeSTamp(trial)=secs;
                            respRT(trial)=secs-stim_start(trial);
                        elseif  foo(theans(trial-1))
                            respo(trial-1)=resp;
                            respTimeSTamp(trial-1)=secs;
                            respRT(trial-1)=secs-stim_start(trial-1);
                        end
                    else
                        resp = -1;
                        if theans(trial-1)<5
                            respo(trial-1)=resp;
                            respTimeSTamp(trial-1)=secs;
                            respRT(trial-1)=secs-stim_start(trial-1);
                        elseif theans(trial)<5
                            respo(trial)=resp;
                            respTimeSTamp(trial)=secs;
                            respRT(trial)=secs-stim_start(trial);
                        end
                        PsychPortAudio('Start', pahandle2);
                    end
                    
                elseif trial>2
                    if foo(theans(trial)) || foo(theans(trial-1)) || foo(theans(trial-2))
                        resp = 1;
                        if foo(theans(trial))
                            respo(trial)=resp;
                            respTimeSTamp(trial)=secs;
                            if exist('stim_star')==0
                                stim_start(trial)=GetSecs;
                                skipframe2(trial)=1;
                            end
                            respRT(trial)=secs-stim_start(trial)
                        elseif  foo(theans(trial-1))
                            respo(trial-1)=resp
                            respTimeSTamp(trial-1)=secs;
                            
                            respRT(trial-1)=secs-stim_start(trial-1)
                        elseif foo(theans(trial-2))
                            respo(trial-2)=resp;
                            respTimeSTamp(trial-2)=secs;
                            respRT(trial-2)=secs-stim_start(trial-2);
                        end
                        PsychPortAudio('Start', pahandle1);
                    else
                        resp = -1;
                        if theans(trial-2)<5
                            respo(trial-2)=resp;
                            respTimeSTamp(trial-2)=secs;
                            respRT(trial-2)=secs-stim_start(trial-2);
                        elseif theans(trial-1)<5
                            respo(trial-1)=resp;
                            respTimeSTamp(trial-1)=secs;
                            respRT(trial-1)=secs-stim_start(trial-1);
                        elseif theans(trial)<5
                            respo(trial)=resp;
                            respTimeSTamp(trial)=secs;
                            
                            if exist('stim_star')==0
                                stim_start(trial)=GetSecs;
                                skipframe2(trial)=1;
                            end
                            respRT(trial)=secs-stim_start(trial);
                            
                            %  respo(trial)=resp
                        end
                        PsychPortAudio('Start', pahandle2);
                    end
                end
                
                %   KbQueueFlush()
                % end
                
            end
        end
        
        
        if (mod(trial,200))==1
            if trial==1
            else
                
                %save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
                save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
            end
        end
        
        
        
        if closescript==1
            break
        end
        
        kk=kk+1;
        %   save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
        
    end
    
    % shut down EyeTracker
    if EyeTracker==1
        Eyelink('StopRecording');
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    end
    
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
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
    Screen('Flip', w);
    KbQueueWait;
    ShowCursor;
    
    if BITS==1
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
    end;
    
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