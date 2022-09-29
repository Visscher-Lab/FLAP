% FLAP Training
% written by Marcello A. Maniglia july 2021 %2017/2021
% Training script for FLAP. This script runs 4 types of visual/oculomotor
% training in conditions of gaze-contingent, simulated central vision loss.
% participants are assigned a TRL (trained retinal location) to either left
% or right of the simulated scotoma.
% 1 = Contrast detection: Participant has to keep the simulated scotoma
% within the boundaries of the central visual aid (square) for some
% time defined by the variable AnnulusTime, then a Gabor appears for
% Stimulustime, participant has to report the Gabor's orientation.
% Participant has trialTimeout amount of time to respond, otherwise the
% trial is considered wrong and the script moves to the next trial.
% 2 = Contour Integration: Participant has to keep the simulated scotoma
% within the boundaries of the central visual aid (square) for some
% time defined by the variable AnnulusTime, then a CI target appears for
% Stimulustime, participant has to report the identity of the stimulus
%within the CI. Participant has trialTimeout amount of time to respond,
%otherwise the trial is considered wrong and the script moves to the next trial.
% 3 = Fixation stability: Participant has to find a white O on the screen and
%keep it within their TRL for some time defined by the variable AnnulusTime,
%then the O will start flickering for an amount of time defined by the
%variable flickertime. If the participant moves the TRL away from the O, it
% will stop flickering (and the flicker timer will stop as well).
%The trial ends when the overall flickering time is fulfilled, thus the more
%the participant keeps the O within their TRL, the shorter the trial duration
%Few consecutive trials are at the same location, then an endogenous (arrow) or an
%exogenous (briefly appearing O) indicates the location of the next series
%of trials.
% 4 = perceptual/oculomotor training: same as 3, but with a target after
%the forced fixation period, either a Gabor (contrast detection) or a
%contour (contour integration).




close all; clear all; clc;
commandwindow


addpath([cd '/utilities']); %add folder with utilities files
try
    prompt={'Participant Name', 'day','site? UCR(1), UAB(2), Vpixx(3)', 'Training type', 'Debug? (1:yes, 2:no)', 'Eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Scotoma? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?', 'left (1) or right (2) TRL?' };
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '1', '4', '2' , '2', '1', '1', '1', '1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    penalizeLookaway=0;   %mostly for debugging, we can remove the masking on the target when assigned PRL ring is out of range
    expDay=str2num(answer{2,:}); % training day (if >1
    site = str2num(answer{3,:}); % training site (UAB vs UCR vs Vpixx)
    trainingType=str2num(answer{4,:}); % training type: 1=contrast, 2=contour integration, 3= oculomotor, 4=everything bagel
    test=str2num(answer{5,:}); % are we testing in debug mode?
    whicheye=str2num(answer{6,:}); % are we tracking left (1) or right (2) eye? Only for Vpixx
    calibration=str2num(answer{7,:}); % do we want to calibrate or do we skip it? only for Vpixx
    ScotomaPresent = str2num(answer{8,:}); % 0 = no scotoma, 1 = scotoma
    EyeTracker = str2num(answer{9,:}); %0=mouse, 1=eyetracker
    TRLlocation= str2num(answer{10,:}); %1=left, 2=right
    
    %create a data folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    baseName=['./data/' SUBJECT '_FLAPtraining_type_' num2str(trainingType) '_Day_' answer{2,:} '_' TimeStart]; %makes unique filename
    
    defineSite % initialize Screen function and features depending on OS/Monitor
    
    %% general visual parameters
    
    stimulusSize = 2.5;% size of the stimulus in degrees of visual angle
    PRLsize = 5; % diameter of the assigned PRL in degrees of visual angle
    scotomadeg=10; % size of the scotoma in degrees of visual angle
    oval_thick=3; %thickness of the TRL oval (value of the filloval function)
    possibleTRLlocations=[-7.5 7.5]; % possible TRL location with respect to the center of the screen in degrees of visual angle
    PRLecc=[possibleTRLlocations(TRLlocation) 0 ]; %eccentricity of PRL in deg
    fixwindow=2; % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
    scotoma_color=[200 200 200]; % color of the scotoma (light gray)
    skipforcedfixation=0; %if we want to skip forced fixation for training type 1 and 2
    fixdotcolor=[177 177 177]; % color of the fixation dot for training type 1 and 2 (4?)
    fixdotcolor2=[0 0 0]; % color of the fixation dot for training type 4 when dot is outside the TRL
    skipmasking=1; % if we want to allow masking of the target when it is not within the assigned PRL (default is no masking)
    fixationlength=10; % if we don't want the scotoma (pixel size)
    colorfixation = [200 200 200]; % if we don't want the scotoma
    
    %% general temporal parameters (trial events)
    
    preCueISI=0.75; % time between beginning of trial and first event in the trial (fixations, cues or targets)
    ExoEndoCueDuration= 0; % duration of exo/endo cue before target appearance for training type 3 and 4
    postCueISI=0; % time interval between cue disappearance and next event (forced fixation before target appearance for training type 1 and 2)
    forcedfixationISI=0; % ISI between end of forced fixation and stimulus presentation (training type 1 and 2) or flickering (training type 3 and 4)
    if test==1
        stimulusduration=2.133; % stimulus duration during debugging
    else
        stimulusduration=0.133; % stimulus duration during actual sessions
    end
    trialTimeout = 8; % how long (seconds) should a trial last without a response
    
    %% training type-specific parameters
    
    % training type 1
    sigma_deg = stimulusSize/2.5; % sigma of the Gabor in degrees of visual angle
    dotsizedeg=0.5; % size of the fixation dot for Training type 1 and 2
    
    % training type 2
    jitterCI=1; % jitter for countour stimuli of training type 2 and 4
    possibleoffset=[-1:1]; %location offset for countour stimuli of training type 2 and 4
    
    % training type 3/4
    holdtrial = 1; %for training type 3 and 4: we force a series of consecutive trials to be in the same location
    annulusOrPRL = 2; % in training types in which we force fixation before target appearance, do we want fixation within an annulus (1) or within the assigned PRL (2)? default is PRL
    timeflickerallowed=0.2; % time before flicker starts
    flickerpersistallowed=0.2; % time away from flicker in which flicker persists
    AnnulusTime = 2/3; %how long do they need to keep fixation near the pre-target element
    Jitter = [2:0.05:3]/3; %flickering duration for task type 3 and 4
    flickeringrate = 0.25; %rate of flickering (in seconds) for task type 3 and 4
    coeffAdj=1; % size of the fixation window for training task 3 and 4 (100% of the TRL size, it is adaptive in training type 3) NOT FULLY IMPLEMENTED YET, DETAILS STILL TO BE DECIDED
    CircConts=[0.51,1]*255; %low/high contrast circular cue
    radius=12.5;   %radius of the circle in which the target can appear (training type 3 and 4)
    cuecontrast=1; % contrast of the cue (0-1)
    %% eyetracker initialization (eyelink)
    
    if EyeTracker==1
        if site==3
            EyetrackerType=2; %1 = Eeyelink, 2 = Vpixx
        else
            EyetrackerType=1; %1 = Eeyelink, 2 = Vpixx
        end
        eyetrackerparameters % set up Eyelink eyetracker
    end
    
    %% Sound
    
    InitializePsychSound(1); %'optionally providing
    % the 'reallyneedlowlatency' flag set to one to push really hard for low
    % latency'.
    pahandle = PsychPortAudio('Open', [], 1, 0, 44100, 2);
    if site<3
        pahandle1 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
        pahandle2 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    elseif site==3 % Windows
        
        pahandle1 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
        pahandle2 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
    end
    try
        [errorS freq] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
        [corrS freq] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
    end
    
    PsychPortAudio('FillBuffer', pahandle1, corrS' ); % loads data into buffer
    PsychPortAudio('FillBuffer', pahandle2, errorS'); % loads data into buffer
    
    %% Stimuli creation
    
    PreparePRLpatch % here I characterize PRL features
    imsize=(stimulusSize*pix_deg)/2; %Gabor mask (effective stimulus size)
    [ax,ay]=meshgrid(-imsize:imsize,-imsize:imsize);
    scotomarect = CenterRect([0, 0, scotomadeg*pix_deg, scotomadeg*pix_deg_vert], wRect); % destination rect for scotoma
    imageRect = CenterRect([0, 0, size(ax)], wRect); % initial destination rectangle for the target
    imageRectDot = CenterRect([0, 0, dotsizedeg*pix_deg, dotsizedeg*pix_deg_vert], wRect); % destination rect for fixation dot training type 1 and 2
    [xc, yc] = RectCenter(wRect);
    r_lim=((radius*pix_deg)-(imsize))/pix_deg; % visual space limits within which random locations are chosen
    fixwindowPix=fixwindow*pix_deg;
    % Gabor stimuli
    midgray=0.5;
    if trainingType==1 || trainingType==4
        createGabors
    end
    
    % CI stimuli
    if trainingType==2 || trainingType==4
        CIShapes
        imageRectSmall = CenterRect([0, 0, size(x0Small)], wRect);
    end
    
    % create flickering Os
    if trainingType>1
        createO
    end
    % trial type-specific time parameters
    if trainingType==3 || trainingType==4
        ExoEndoCueDuration=0.1; %0.01 %duration of exo/endo cue before target appearance for training type 3 and 4
        postCueISI=0.1; % time interval between cue disappearance and first forced fixation
        framesbeforeflicker=timeflickerallowed/ifi; % frames before flicker starts
        blankframeallowed=flickerpersistallowed/ifi; % frames away from flicker in which flicker persists
    end
    
    realtrialTimeout = trialTimeout;
    
    %% Keys definition/kb initialization
    
    KbName('UnifyKeyNames');
    
    RespType(1) = KbName('LeftArrow');
    RespType(2) = KbName('RightArrow');
    RespType(3) = KbName('UpArrow');
    RespType(4) = KbName('DownArrow');
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
    
    if EyetrackerType==1
        eyelinkCalib
    end
    %% Trial matrix definition
    
    % initialize jitter matrix
    if trainingType==2 || trainingType==4
        shapes=6; % how many shapes per day?
        JitList = 0:2:90;
        StartJitter=16;
    end
    
    
    %define number of trials per condition
    if trainingType==1
        conditionOne=1; %only Gabors
        conditionTwo=1;
        if test==1
            trials=5; %total number of trials per staircase
        else
            trials=500;  %total number of trials per staircase
        end
    elseif trainingType==2
        conditionOne=shapes; % shapes (training type 2)
        conditionTwo=1;
        if test==1
            trials=5; %total number of trials per staircase (per shape)
        else
            trials=83;  %total number of trials per staircase (per shape)
        end
    elseif trainingType==3
        conditionOne=1; %only landolt C
        conditionTwo=2; % endogenous or exogenous cue
        if test==1
            trials=5;
        else
            trials=62;  %total number of trials per stimulus (250 trials
            %per cue condition divided by 4 because of the 'hold trial
            %location' later)
        end
    elseif trainingType==4
        conditionOne=2; %gabors or contours
        conditionTwo=2; % high or low visibility cue
        if test==1
            trialsContrast=5;
            trialsShape=4;
        else
            trialsContrast=125;
            trialsShape=21;
        end
    end
    
    %create trial matrix
    if trainingType<3
        mixcond=fullfact([conditionOne conditionTwo]);
        mixtr=[];
        for ui=1:conditionOne
            mixtr=[mixtr; repmat(mixcond(ui,:),trials,1) ];
        end
        mixtr=[mixtr ones(length(mixtr(:,1)),1)];
    elseif trainingType==3
        mixcond=fullfact([conditionOne conditionTwo]);
        mixtr=[];
        for ui=1:conditionTwo
            mixtr=[mixtr; repmat(mixcond(ui,:),trials,1) ];
        end
        mixtr=[ones(length(mixtr(:,1)),1) mixtr];
        mixtr =mixtr(randperm(length(mixtr)),:);
    elseif trainingType==4
        
        % type of stimulus, shapes, type of cue
        mixcond=fullfact([shapes conditionTwo 1]);
        mixcond=[mixcond(:,1:2) mixcond(:,3)+1 ];
        mixcond2=fullfact([1 conditionTwo 1]);
        mixtr=[];
        % divide the number of trials by 4 because we have the 'hold
        % location' later that will increase the number of trials
        mixtr_gabor=[repmat(mixcond2,round(trialsContrast/4),1) ];
        mixtr_shapes=[repmat(mixcond,round(trialsShape/4),1) ];
        block_n=length(mixtr_shapes)/3;
        %         block_n=length(mixtr_gabor)/3;
        if test==1
            mixtr=[mixtr_gabor;mixtr_shapes];
        else
            mixtr=[mixtr_gabor(1:block_n,:);mixtr_shapes(1:block_n,:); mixtr_gabor(block_n+1:block_n*2,:); mixtr_shapes(block_n+1:block_n*2,:);mixtr_gabor(block_n*2+1:end,:);mixtr_shapes(block_n*2+1:end,:)];
        end
    end
    
    %% STAIRCASE
    nsteps=70; % elements in the stimulus intensity list (contrast or jitter or TRL size in training type 3)
    if trainingType~=3
        stepsizes=[4 4 3 2 1]; % step sizes for staircases
        % Threshold -> 79%
        sc.up = 1;   % # of incorrect answers to go one step up
        sc.down = 3;  % # of correct answers to go one step down
        SFthreshmin=0.01;     % contrast value below which we increase SF
        SFthreshmax=0.2; % contrast value above which we decrease SF
        SFadjust=10; % steps to go up in the contrast list (easier) once we increase SF
        if trainingType==2 || trainingType==4
            load shapeMat.mat;         % shape parameters
            if test==1
                shapeMat(:,1)= [5 4 7 6 2 3];
            end
            shapesoftheDay=shapeMat(:,expDay);
        end
        
        if expDay==1
            if trainingType==1 || trainingType==4
                if expDay==1
                    StartCont=15;  %starting value for Gabor contrast
                    currentsf=4;
                end
                Contlist = log_unit_down(max_contrast+.122, 0.05, nsteps); % contrast list for trainig type 1 and 4
                Contlist(1)=1;
                
                if trainingType==1
                    thresh(1:conditionOne, 1:conditionTwo)=StartCont; %Changed from 10 to have same starting contrast as the smaller Contlist
                end
                step=5;
                if trainingType==4
                    Contrthresh=StartCont; % training type 4 has both shapes and contrast
                end
            end
            if trainingType==2 || trainingType==4
                AllShapes=size((Targy));
                trackthresh=ones(AllShapes(2),1)*StartJitter; %assign initial jitter to shapes
            end
        else % load thresholds from previous days
            d = dir(['./data/' SUBJECT '_FLAPtraining_type_' num2str(trainingType) '_Day_' num2str(expDay-1) '*.mat']);
            [dx,dx] = sort([d.datenum]);
            newest = d(dx(end)).name;
            lasttrackthresh=load(['./data/' newest],'trackthresh');
            trackthresh=lasttrackthresh.trackthresh;
        end
        if trainingType==2
            thresh=trackthresh(shapesoftheDay);
        elseif trainingType==4
            thresh(:,2)=trackthresh(shapesoftheDay);
            thresh(:,1)=Contrthresh;
        end
        if trainingType<4
            reversals(1:conditionOne, 1:conditionTwo)=0;
            isreversals(1:conditionOne, 1:conditionTwo)=0;
            staircounter(1:conditionOne, 1:conditionTwo)=0;
            corrcounter(1:conditionOne, 1:conditionTwo)=0;
        elseif trainingType==4
            reversals=zeros(shapes,2);
            isreversals=zeros(shapes,2);
            staircounter=zeros(shapes,2);
            corrcounter=zeros(shapes,2);
        end
    end
    
    % training type 3 has its own structure, no behavioral performance
    % recorded except for eye movements, no keys to press
    if trainingType==3
        
        if expDay==1
            
            sizeArray=log_unit_down(1.65, 0.008, nsteps);
            
            %higher pointer=more difficult
            sizepointer=15;
            coeffAdj=sizeArray(sizepointer); % possible list of TRL size (proportion of TRL size) that allows frames to be counted as 'within the TRL'
        end
        if expDay>1 % if we are not on day one, we load thresholds from previous days
            
            d = dir(['./data/' SUBJECT '_FLAPtraining_type_' num2str(trainingType) '_Day_' num2str(expDay-1) '*.mat']);
            
            [dx,dx] = sort([d.datenum]);
            newest = d(dx(end)).name;
            %  oldthresh=load(['./data/' newest],'thresh');
            previousFixTime=load(['./data/' newest],'movieDuration');
            previousresp=load(['./data/' newest],'rispo');
            previoustrials=load(['./data/' newest],'trials');
            
            if sum(previousresp)/previoustrials< 0.8
                coeffAdj=1.3;
            elseif  sum(previousresp)/previoustrials> 0.8
                coeffAdj=1;
            end
        end
    end
    
    %% Trial structure
    
    if trainingType==3 || trainingType==4
        
        % 1: shape type (1-6 for shapes, 1 for Gabors), 2: cue type (exo or endo), 3: stimulus type (gabor of shapes)
        if holdtrial==1 % if we want to hold target position for few consecutive trials
            
            newmat = [];
            for i=1:length(mixtr) % clone trials from original trial matrix
                %to have a series of stimuli presented in the same location
                newfirstone=mixtr(i,:);
                repnum=randi(4)+2;
                tempmat=repmat([newfirstone],repnum,1);
                newmat=[newmat;tempmat];
            end
            mixtr=newmat;
        end
    end
    if annulusOrPRL==1 % annulus for pre-target fixation (default is NOT this)
        % here I define the annulus around the scotoma which allows for a
        % fixation to count as 'valid', i.e., the flickering is on when a
        % fixation is within this region
        [sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);
        smallradiusannulus=(scotomadeg/2)*pix_deg; % inner circle: scotoma eccentricity
        largeradiusannulus=smallradiusannulus+3*pix_deg; %outer circle (3 degrees from the border of the scotoma
        circlePixels=sx.^2 + sy.^2 <= largeradiusannulus.^2;
        circlePixels2=sx.^2 + sy.^2 <= smallradiusannulus.^2;
        d=(circlePixels2==1);
        newfig=circlePixels;
        newfig(d==1)=0;
        circlePixelsPRL=newfig;
    end
    
    %% Initialize trial loop
    HideCursor;
    if test==2
        ListenChar(2);
    end
    ListenChar(0);
    
    % Select specific text font, style and size:
    Screen('TextFont',w, 'Arial');
    Screen('TextSize',w, 42);
    Screen('FillRect', w, gray);
    % general instruction TO BE REWRITTEN
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
    WaitSecs(0.5);
    
    % check EyeTracker status, if Eyelink
    if EyetrackerType == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        % mark zero-plot time in data file
        Eyelink('message' , 'SYNCTIME');
        location =  zeros(length(mixtr), 6);
    end
    
    
    eyetime2=0; % trial-based timer
    closescript=0; % to allow ESC use
    kk=1;
    
    % HERE starts trial loop
    for trial=1:length(mixtr)
        if trial==1
            startExp=GetSecs; %time at the beginning of the session
        end
        if trial==length(mixtr)
            endExp=GetSecs; %time at the end of the session
        end
        
        if trial== length(mixtr)/8 %|| trial== length(mixtr)/4 || trial== length(mixtr)/4
            interblock_instruction
        end
        %% training type-specific conditions
        
        if trainingType==1 || trainingType==4 && mixtr(trial,3)==1  %if it's a Gabor trial (training type 1 or 4)
            ssf=sflist(currentsf);
            fase=randi(4);
            texture(trial)=TheGabors(currentsf, fase);
            contr = Contlist(thresh(mixtr(trial,1),mixtr(trial,3)));
        end
        
        if trainingType==2 || trainingType==4 && mixtr(trial,3)==2 %if it's a CI trial (training type 2 or 4)
            Orijit=JitList(thresh(mixtr(trial,1),mixtr(trial,3)));
            Tscat=0;
        end
        if trainingType==4 %if it's a training type 4 trial, which cue type? high or low visibility cue
            ContCirc= CircConts(mixtr(trial,2));
        end
        if trainingType==3 || trainingType==4 %if it's a training type 3 or 4 trial, how long is the flickering?
            FlickerTime=Jitter(randi(length(Jitter)));
            actualtrialtimeout=realtrialTimeout;
            trialTimeout=400000;
        elseif trainingType==1 || trainingType==2 || test==1 %if it's a training type 1 or 2 trial, no flicker
            FlickerTime=0;
        end
        
        
        %% Initialization/reset of several trial-based variables
        
        clear EyeData
        clear FixIndex
        xeye=[]; %x coordinates from eyetracker
        yeye=[];   %y coordinates from eyetracker
        VBL_Timestamp=[]; %array to collect frame time stamp
        FixCount=0;
        FixatingNow=0;
        EndIndex=0;
        fixating=0;
        counter=0;
        counterannulus=0; %count 'correct fixation' frames during IsfixatingPRL3
        counterflicker=0; %count 'correct fixation' frames during ForcedFixation
        framecounter=0; %count overall frames during ForedFixation
        showtarget=0; % counts how many frames was the target shown
        trialTimedout(trial)=0; % counts how many trials timed out before response
        circlefix=0; %counter of frames in which the target is within the PRL
        blankcounter=0; % counter of frames n which the target is outside the PRL
        countgt =[];
        framecont=[];
        countblank=[];
        blankcounter2=0;
        counterflicker2=0;
        TrialNum = strcat('Trial',num2str(trial));
        
        if trainingType==1 || trainingType==2 % if training type 1 or 2, stimulus always presented in the center
            theeccentricity_X=0;
            theeccentricity_Y=0;
            theeccentricity_X=PRLx*pix_deg;
            eccentricity_X(trial)= theeccentricity_X;
            eccentricity_Y(trial) =theeccentricity_Y ;
        elseif trainingType==3 || trainingType==4 % if training type 3 or 4 and not a hold trial, stimulus position spatially randomized
            if trial==1 || sum(mixtr(trial,:)~=mixtr(trial-1,:))>0
                ecc_r=(r_lim*pix_deg).*rand(1,1);
                ecc_t=2*pi*rand(1,1);
                cs= [cos(ecc_t), sin(ecc_t)];
                xxyy=[ecc_r ecc_r].*cs;
                ecc_x=xxyy(1);
                ecc_y=xxyy(2);
                eccentricity_X(trial)=ecc_x;
                eccentricity_Y(trial)=ecc_y;
                theeccentricity_X=ecc_x;
                theeccentricity_Y=ecc_y;
            end
        end
        
        %  destination rectangle for the target stimulus
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
        
        %  destination rectangle for the fixation dot
        imageRect_offs_dot=[imageRectDot(1)+theeccentricity_X, imageRectDot(2)+theeccentricity_Y,...
            imageRectDot(3)+theeccentricity_X, imageRectDot(4)+theeccentricity_Y];
        %% generate answer for this trial (training type 3 has no button response)
        
        if trainingType==1 ||  (trainingType==4 && mixtr(trial,3)==1)
            theoris =[-45 45];
            theans(trial)=randi(2);
            ori=theoris(theans(trial));
        elseif trainingType==2 || (trainingType==4 && mixtr(trial,3)==2)
            theans(trial)=randi(2);
            CIstimuliMod % add the offset/polarity repulsion
        end
        %% prepare trial loop (reset/clean up every trial)
        Priority(0);
        eyechecked=0; % while 0, trial loop is active
        KbQueueFlush();
        stopchecking=-100;
        skipcounterannulus=1;
        flickerdone=0;
        pretrial_time=GetSecs; % trial timing
        trial_time=GetSecs;  % trial timing that gets updated later on when we have eye info (if no eye info, the trial won't move on)
        newtrialtime=GetSecs; % real value to be assigned later, after flicker is done
        while eyechecked<1
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            if trainingType<3
                fixationscriptW % visual aids on screen
            end
            fixating=1500;
            
            if trainingType>2 && trial>1 %if it's training 3 or 4 trial, we evaluate whether it's a cue trial
                if mixtr(trial,3)~=mixtr(trial-1,3) || mixtr(trial,3)==2 && mixtr(trial,1)~=mixtr(trial-1,1) % ||  trial==1
                    if mixtr(trial,3)==1 %if it's endogenous cue
                        %calculations for arrow pointing to the next location (endo cue)
                        nexcoordx=(imageRect_offs(1)+imageRect_offs(3))/2;
                        nexcoordy=(imageRect_offs(2)+imageRect_offs(4))/2;
                        previouscoordx=(rectimage{kk-1}(1)+rectimage{kk-1}(3))/2;
                        previouscoordy=(rectimage{kk-1}(2)+rectimage{kk-1}(4))/2;
                        delta=[previouscoordx-nexcoordx previouscoordy-nexcoordy];
                        oriArrow(trial)=atan2d(delta(2), delta(1));
                        oriArrow(trial)=oriArrow(trial)-90;
                        ExoEndoCueDuration=0.133;
                    elseif mixtr(trial,3)==2 %if it's exogenous cue (circle flashing to the next location)
                        ExoEndoCueDuration=0.05;
                    end
                end
            end
            %% here is where the first time-based trial loop starts (until first forced fixation is satisfied)
            if (eyetime2-trial_time)>=ifi*2 && (eyetime2-trial_time)<ifi*2+preCueISI && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                
                % pre-event empty space, allows for some cleaning
                clear circlestar
                clear flickerstar
                clear imageRect_offsCirc
                clear imageRect_offsCI
                clear imageRect_offsCI2
                clear imageRectMask
                clear imageRect_offsCImask
                clear isendo
                clear startrial
                if trainingType==1 || trainingType==2 % no flicker type of training trial
                    counterflicker=-10000;
                end
                
            elseif (eyetime2-trial_time)>=ifi*2+preCueISI && (eyetime2-trial_time)<+ifi*2+preCueISI+ExoEndoCueDuration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                if exist('startrial') == 0
                    startrial=1;
                    trialstart(trial)=GetSecs;
                    trialstart_frame(trial)=eyetime2;
                    
                end
                % HERE I present the cue for training types 3 and 4 or skip
                % this interval for training types 1 and 2
                
                if trainingType>2 && trial>1
                    if mixtr(trial,2)~=mixtr(trial-1,2) || mixtr(trial,3)==2 && mixtr(trial,1)~=mixtr(trial-1,1) % ||  trial==1
                        if mixtr(trial,2)==1 %endogenous cue
                            newrectimage{kk}=[rectimage{kk-1}(1)-2*pix_deg rectimage{kk-1}(2)-2*pix_deg rectimage{kk-1}(3)+2*pix_deg rectimage{kk-1}(4)+2*pix_deg ];
                            Screen('DrawTexture', w, theArrow, [], rectimage{kk-1}, oriArrow(trial),[], 1);
                            cuecontrast=0.1;
                            isendo=1;
                        elseif mixtr(trial,2)==2 %exogenous cue
                            Screen('FrameOval', w,scotoma_color, imageRect_offs, 22, 22);
                            isendo=0;
                        end
                    else
                        isendo=0;
                    end
                elseif trainingType>2 && trial==1
                    isendo=0;
                end
            elseif (eyetime2-trial_time)>=ifi*2+preCueISI+ExoEndoCueDuration+postCueISI && fixating>400 && stopchecking>1 && flickerdone<1 && counterannulus<=AnnulusTime/ifi && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ==0 && (eyetime2-pretrial_time)<=trialTimeout
                % here I need to reset the trial time in order to preserve
                % timing for the next events (first fixed fixation event)
                if trainingType~=3
                    if skipforcedfixation==1 % skip the force fixation for training types 1, 2 and 4
                        counterannulus=(AnnulusTime/ifi)+1;
                        skipcounterannulus=1000;
                    else %force fixation for training types 1 and 2
                        [counterannulus framecounter ]=  IsFixatingPRL3(newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,EyetrackerType,theeccentricity_X,theeccentricity_Y,framecounter,counterannulus)
                        Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                    end
                elseif trainingType==3 %force fixation for training types 3
                    [counterannulus framecounter ]= IsFixatingPRL3(newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,EyetrackerType,theeccentricity_X,theeccentricity_Y,framecounter,counterannulus)
                    if isendo==1 % if is endo trial we slowly increase the visibility of the cue
                        if mod(round(eyetime2-trial_time),0.4)
                            cuecontrast=cuecontrast+0.35;
                        end
                    elseif isendo==0
                        cuecontrast=0.8;
                    end
                    Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], cuecontrast);
                end
                
                if counterannulus==round(AnnulusTime/ifi) % when I have enough frame to satisfy the fixation requirements
                    newtrialtime=GetSecs;
                    skipcounterannulus=1000;
                end
                
            elseif (eyetime2-trial_time)>=ifi*2+preCueISI+ExoEndoCueDuration+postCueISI && fixating>400 && stopchecking>1 && counterannulus<AnnulusTime/ifi && flickerdone<1 && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ~=0 && (eyetime2-pretrial_time)<=trialTimeout
                % HERE I exit the script if I press ESC
                thekeys = find(keyCode);
                closescript=1;
                break;
                
            end
            %%             %% here is where the second time-based trial loop starts
            if (eyetime2-newtrialtime)>=forcedfixationISI && fixating>400 && stopchecking>1 && skipcounterannulus>10 && counterflicker<=FlickerTime/ifi && flickerdone<1 && (eyetime2-pretrial_time)<=trialTimeout
                % HERE starts the flicker for training types 3 and 4, if
                % training type is 1 or 2, this is skipped
                if trainingType>2
                    %counterflicker=counterflicker+1;
                elseif trainingType<3 || test==1
                    counterflicker=1;
                    flickerdone=10;
                end
                if exist('flickerstar') == 0 % start flicker timer
                    flicker_time_start=GetSecs; % beginning of the overall flickering period
                    flickerstar=1;
                    flickswitch=0;
                    flick=1;
                end
                flicker_time=GetSecs-flicker_time_start;
                
                if flicker_time>flickswitch % time to flicker?
                    flickswitch= flickswitch+flickeringrate;
                    flick=3-flick;
                end
                if trainingType==3 % training type 3 shows actual flickering O
                    if flick==2
                        Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                    end
                end
                if trainingType==4 % training type 4 shows solid, non-flickering dot
                    Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                end
                
                if trainingType>2 && test==2  % Force flicker here (training type 3 and 4)
                    [countgt framecont countblank blankcounter counterflicker ]=  ForcedFixationFlicker(countgt,countblank, framecont, w, theCircles, imageRect_offs, imageRect_offs_dot,fixdotcolor2, newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,theeccentricity_X,theeccentricity_Y,blankcounter,framesbeforeflicker,blankframeallowed, circlefix, EyeData, counterflicker,trainingType,eyetime2,EyeCode)
                    %
                end
                clear stimstar
                clear checktrialstart
                clear targetflickerstar
                if exist('circlestar')==0
                    circle_start = GetSecs;
                    circlestar=1;
                end
                cue_last=GetSecs;
                
                if trainingType>2 && counterflicker==round(FlickerTime/ifi)
                    newtrialtime=GetSecs; % when fixation constrains are satisfied, I reset the timer to move to the next series of events
                    flickerdone=10;
                    flicker_time_stop=eyetime2; % end of the overall flickering period
                end
            elseif (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1 && counterflicker>=FlickerTime/ifi  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0 && stopchecking>1 %present pre-stimulus and stimulus
                % HERE I PRESENT THE TARGET
                
                if trainingType==3
                    eyechecked=10^4; % if it's training type 3, we exit the trial
                    if skipmasking==0
                        if trainingType~=3
                            assignedPRLpatch
                        end
                    end
                elseif trainingType==1 || (trainingType==4 && mixtr(trial,3)==1)
                    Screen('DrawTexture', w, texture(trial), [], imageRect_offs, ori,[], contr );
                    if skipmasking==0
                        assignedPRLpatch
                    end
                elseif trainingType==2 || (trainingType==4 && mixtr(trial,3)==2)
                    if exist('imageRect_offsCI')==0    % destination rectangle for CI stimuli
                        imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(trial),...
                            imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(trial)];
                        imageRect_offsCI2=imageRect_offsCI;
                        imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                        imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
                            imageRectMask(3)+eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];
                    end
                    %here I draw the target contour
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
                    imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
                    % here I draw the circle within which I show the contour target
                    Screen('FrameOval', w,gray, imageRect_offsCImask, 22, 22);
                    if skipmasking==0
                        assignedPRLpatch
                    end
                    imagearray{trial}=Screen('GetImage', w);
                    
                end
                if exist('stimstar')==0
                    stim_start = GetSecs;
                    stim_start_frame=eyetime2;
                    stimstar=1;
                end
                % start counting timeout for the non-fixed time training
                % types 3 and 4
                if trainingType>2
                    if exist('checktrialstart')==0
                        trialTimeout=actualtrialtimeout+(stim_start-pretrial_time);
                        checktrialstart=1;
                    end
                end
                
            elseif (eyetime2-newtrialtime)>=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && counterflicker>=FlickerTime/ifi  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 %present pre-stimulus and stimulus
                eyechecked=10^4; % exit loop for this trial
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
                eyechecked=10^4; % exit loop for this trial
            end
            %% here I draw the scotoma, elements below are called every frame
            eyefixation5
            if ScotomaPresent == 1 % do we want the scotoma? (default is yes)
                Screen('FillOval', w, scotoma_color, scotoma);
                visiblePRLring
            else % else we get a fixation cross and no scotoma
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
            end
            if test==2
                if penalizeLookaway>0
                    if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                        Screen('FillRect', w, gray);
                    end
                end
            end
            [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
            
            VBL_Timestamp=[VBL_Timestamp eyetime2];
            %% process eyedata in real time (fixation/saccades)
            if EyeTracker==1
                if site<3
                    GetEyeTrackerData
                elseif site ==3
                    GetEyeTrackerDatapixx
                end
                GetFixationDecision
                if EyeData(end,1)<8000 && stopchecking<0
                    trial_time = GetSecs; %start timer if we have eye info
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
        %% response processing
        if trialTimedout(trial)== 0 && trainingType~=3
            foo=(RespType==thekeys);
            
            % staircase update
            if trainingType~=3
                staircounter(mixtr(trial,1),mixtr(trial,3))=staircounter(mixtr(trial,1),mixtr(trial,3))+1;
            end
            if trainingType==1 || (trainingType == 4 && mixtr(trial,3)==1)
                Threshlist(mixtr(trial,1),mixtr(trial,3),staircounter(mixtr(trial,1),mixtr(trial,3)))=contr;
            end
            if trainingType==2 || (trainingType == 4 && mixtr(trial,3)==2)
                Threshlist(mixtr(trial,1),mixtr(trial,3),staircounter(mixtr(trial,1),mixtr(trial,3)))=Orijit;
            end
            if foo(theans(trial)) % if correct response
                resp = 1;
                PsychPortAudio('Start', pahandle1); % sound feedback
                if trainingType~=3
                    corrcounter(mixtr(trial,1),mixtr(trial,3))=corrcounter(mixtr(trial,1),mixtr(trial,3))+1;
                    if corrcounter(mixtr(trial,1),mixtr(trial,3))>=sc.down
                        if isreversals(mixtr(trial,1),mixtr(trial,3))==1
                            reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                            isreversals(mixtr(trial,1),mixtr(trial,3))=0;
                        end
                        thestep=min(reversals(mixtr(trial,1),mixtr(trial,3))+1,length(stepsizes));
                    end
                end
                if trainingType==1 || (trainingType == 4 && mixtr(trial,3)==1)
                    
                    if corrcounter(mixtr(trial,1),mixtr(trial,3))>=sc.down % if we have enough consecutive correct responses to
                        %update stimulus intensity
                        if contr<SFthreshmin && currentsf<length(sflist)
                            currentsf=min(currentsf+1,length(sflist));
                            foo=find(Contlist>=SFthreshmin);
                            thresh(:,:)=foo(end)-SFadjust;
                            corrcounter(:,:)=0;
                            thestep=3;
                        else
                            thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)) +stepsizes(thestep);
                            thresh(mixtr(trial,1),mixtr(trial,3))=min( thresh(mixtr(trial,1),mixtr(trial,3)),length(Contlist));
                        end
                    end
                end
                if trainingType==2 || (trainingType == 4 && mixtr(trial,3)==2)
                    if corrcounter(mixtr(trial,1),mixtr(trial,3))>=sc.down
                        thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)) +stepsizes(thestep);
                        thresh(mixtr(trial,1),mixtr(trial,3))=min( thresh(mixtr(trial,1),mixtr(trial,3)),length(JitList));
                    end
                end
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                ListenChar(0);
                break;
            else
                resp = 0; % if wrong response
                PsychPortAudio('Start', pahandle2); % sound feedback
                if trainingType~=3
                    if  corrcounter(mixtr(trial,1),mixtr(trial,3))>=sc.down
                        isreversals(mixtr(trial,1),mixtr(trial,3))=1;
                    end
                    corrcounter(mixtr(trial,1),mixtr(trial,3))=0;
                    thestep=min(reversals(mixtr(trial,1),mixtr(trial,3))+1,length(stepsizes));
                end
                if trainingType==1 || trainingType == 4 && mixtr(trial,3)==1
                    if contr>SFthreshmax && currentsf>1
                        currentsf=max(currentsf-1,1);
                        thresh(:,:)=StartCont+SFadjust;
                        corrcounter(:,:)=0;
                        thestep=3;
                    else
                        thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)) -stepsizes(thestep);
                        thresh(mixtr(trial,1),mixtr(trial,3))=max(thresh(mixtr(trial,1),mixtr(trial,3)),1);
                    end
                end
                if trainingType==2 || trainingType == 4 && mixtr(trial,3)==2
                    thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)) -stepsizes(thestep);
                    thresh(mixtr(trial,1),mixtr(trial,3))=max(thresh(mixtr(trial,1),mixtr(trial,3)),1);
                end
            end
        elseif trainingType==3 % no response to be recorded here
            if closescript==1
                PsychPortAudio('Start', pahandle2);
            else
                PsychPortAudio('Start', pahandle1);
            end
        else
            resp = 0;
            respTime=0;
            PsychPortAudio('Start', pahandle2);
        end
        if trainingType~=3 % if the trial didn't time out, save some variables
            if trialTimedout(trial)==0
                stim_stop=secs;
                cheis(kk)=thekeys;
            end
            time_stim(kk) = stim_stop - stim_start;
            rispo(kk)=resp;
            respTimes(trial)=respTime;
            cueendToResp(kk)=stim_stop-cue_last;
            cuebeginningToResp(kk)=stim_stop-circle_start;
        end
        if trainingType > 2 % if it's a training type with flicker
            %   fixDuration(trial)=flicker_time_start-trial_time;
            if flickerdone>1
                movieDuration(trial)=flicker_time_stop-flicker_time_start;
            end
        end
        totale_trials(kk)=trial;
        coordinate(trial).x=theeccentricity_X/pix_deg;
        coordinate(trial).y=theeccentricity_Y/pix_deg;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];
        if exist('ssf')
            feat(kk)=ssf;
        end
        SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
        rectimage{kk}=imageRect_offs;
        if exist('endExp')
            totalduration=(endExp-startExp)/60;
        end
        
        %% record eyelink-related variables
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
            if exist('stim_start')
                EyeSummary.(TrialNum).TimeStamps.Fixation = stim_start;
            end
            if trainingType~=3
                EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;
            end
            clear ErrorInfo
        end
        
        if trainingType==2
            trackthresh(shapesoftheDay(mixtr,1))=thresh(mixtr,1);
            threshperday(expDay,:)=trackthresh;
        end
        
        if (mod(trial,150))==1
            if trial==1
            else
                save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
            end
        end
        if (mod(trial,50))==1 && trial>1
            if trainingType==3 %some adaptive measures for the TRL size that counts as 'fixation within the TRL'
                %for trainng type 3, to be verified
                if mean(movieDuration(trial-49:trial))>3
                    if trial==100 || trial==200 || trial==300 || trial==400 || trial==500
                    elseif trial==150 || trial==250 || trial==350 || trial==450 || trial==50
                        sizepointer=sizepointer-1;
                    end
                elseif mean(movieDuration(trial-49:trial))<2
                    if trial==100 || trial==200 || trial==300 || trial==400 || trial==500
                    elseif trial==150 || trial==250 || trial==350 || trial==450 || trial==50
                        sizepointer=sizepointer+1;
                    end
                end
                
                if  trialTimedout(trial-49:trial)>5
                    if trial==100 || trial==200 || trial==300 || trial==400 || trial==500
                    elseif trial==150 || trial==250 || trial==350 || trial==450 || trial==50
                        sizepointer=sizepointer-1;
                    end
                end
                coeffAdj=sizeArray(sizepointer);
            end
        end
        if closescript==1
            break;
        end
        kk=kk+1;
    end
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
    timearray=[preCueISI ExoEndoCueDuration postCueISI forcedfixationISI stimulusduration]';
    
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    
    ListenChar(0);
    Screen('Flip', w);
    
    KbQueueWait;
    %% shut down EyeTracker and screen functions
    if EyeTracker==1
        Eyelink('StopRecording');
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    end
    
    Screen('Flip', w);
    Screen('TextFont', w, 'Arial');
    
    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
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