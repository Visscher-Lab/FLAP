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


close all; clear; clc;
commandwindow


addpath([cd '/utilities']); %add folder with utilities files
try
    prompt={'Participant Name', 'day', 'Training type', 'debug (0) or session (1)', 'Eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Scotoma? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?', 'left (1) or right (2) TRL?' };
  %    prompt={'Participant Name', 'day','site? UCR(1), UAB(2), Vpixx(3)', 'Training type', 'Demo? (1:yes, 2:no)', 'Eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Scotoma? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?', 'left (1) or right (2) TRL?' };

   % practice (0) or session (1)
    % prompt={'Participant name', 'Assessment day','scotoma old mode active', 'practice (0) or session (1)', 'Locations: (2) or (4)',  'eye? left(1) or right(2)','Calibration? yes (1), no(0)', 'Task: acuity (1), crowding (2), exo attention (3), contrast (4)'};

    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '2', '0', '2' , '0', '1', '1', '1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    penalizeLookaway=0;   %mostly for debugging, we can remove the masking on the target when assigned PRL ring is out of range
    expDay=str2num(answer{2,:}); % training day (if >1
    trainingType=str2num(answer{3,:}); % training type: 1=contrast, 2=contour integration, 3= oculomotor, 4=everything bagel
    demo=str2num(answer{4,:}); % are we testing in debug mode?
    whicheye=str2num(answer{5,:}); % are we tracking left (1) or right (2) eye? Only for Vpixx
    calibration=str2num(answer{6,:}); % do we want to calibrate or do we skip it? only for Vpixx
    ScotomaPresent = str2num(answer{7,:}); % 0 = no scotoma, 1 = scotoma
    EyeTracker = str2num(answer{8,:}); %0=mouse, 1=eyetracker
    TRLlocation= str2num(answer{9,:}); %1=left, 2=right
    
    %create a data folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
 filename='_FLAPtraining_type';
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    baseName=['./data/' SUBJECT  filename '_' num2str(trainingType) '_Day_' answer{2,:} '_' TimeStart]; %makes unique filename
        site = 3; % training site (UAB vs UCR vs Vpixx)

    defineSite % initialize Screen function and features depending on OS/Monitor
    
    CommonParametersFLAP % define common parameters
    
    %% eyetracker initialization (eyelink)
    
    if EyeTracker==1
        if site==3
            EyetrackerType=2; %1 = Eyelink, 2 = Vpixx
        else
            EyetrackerType=1; %1 = Eyelink, 2 = Vpixx
        end
        eyetrackerparameters % set up Eyelink eyetracker
    end
    %% Stimuli creation
    
    PreparePRLpatch % here I characterize PRL features
            stimulusduration=2.2; % stimulus duration during actual sessions

    % Gabor stimuli
    if trainingType==1 || trainingType==4
        createGabors
    end
    
    % CI stimuli
    if trainingType==2 || trainingType==4
        CIShapesIII
    end
    
    % create flickering Os
    if trainingType>1
        createO
    end
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
    
    KbQueueCreate(deviceIndex); %checks for keyboard inputs
    KbQueueStart(deviceIndex);
    
    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    end
    %% Trial matrix definition
    
    % initialize jitter matrix
    if trainingType==2 || trainingType==4
        shapes=3; % how many shapes per day?
        JitList = 0:2:90;
        StartJitter=1;
    end
    
    %define number of trials per condition
    if trainingType==1
        conditionOne=1; %only Gabors
        conditionTwo=1; %currently not needed for this training type
        if demo==0
            trials=5; %total number of trials per staircase
        else
            trials=500;  %total number of trials per staircase
        end
    elseif trainingType==2
        conditionOne=shapes; % shapes (training type 2)
        conditionTwo=1; %currently not needed for this training type
        if demo==0
            trials=5; %total number of trials per staircase (per shape)
        else
            trials= 6;  %total number of trials per staircase (per shape, we have 3 per day)
        end
    elseif trainingType==3
        conditionOne=1; %only landolt C
        conditionTwo=2; % endogenous or exogenous cue
        if demo==0
            trials=5;
        else
            trials=62;  %total number of trials per stimulus (250 trials
            %per cue condition divided by 4 because of the 'hold trial
            %location' later)
        end
    elseif trainingType==4
        conditionOne=2; %gabors or contours
        conditionTwo=2; % high or low visibility cue
        if demo==0
            trialsContrast=5;
            trialsShape=4;
        else
            trialsContrast=125;
            trialsShape=21;
        end
    end
    
    %create trial matrix
    if trainingType<3 % trial matrix for training type 1 and 2 are structurally similar,
        %with Training type 2 having multiple stimulus types (shapes) per
        %session
        mixcond=fullfact([conditionOne conditionTwo]); %full factorial design
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
        mixtr=[mixtr ones(length(mixtr(:,1)),1) ];
        mixtr =mixtr(randperm(length(mixtr)),:);
    elseif trainingType==4 % more complex structure, we have type of shapes
        %(for Gabor it's always the same, for shapes it will have 6 types per
        %session; type of stimuli (shapes/Gabors), type of cue (exo vs
        %endo)
        
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
        if demo==0
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
            load NewShapeMat.mat;         % shape parameters for each session of training
            shapeMat=[shapeMat(1,:); shapeMat(3,:); shapeMat(5,:) ] ;
            if demo==0
                shapeMat(:,1)= [8 1 6];
            end            
            shapeMat(:,1)= [1 2 3];
            shapeMat(:,1)= [4 9 10];            
      %      shapeMat(:,1)= [11 6 7 ];
shapeMat(:,1)= [9 11 7 ];
            shapesoftheDay=shapeMat(:,expDay);
        end
        
        if expDay==1
            if trainingType==1 || trainingType==4
                if expDay==1
                    StartCont=15;  %starting value for Gabor contrast
                    currentsf=4;
                    logUnitStep=0.05;
                end
                            theoris =[-45 45]; % possible orientation of the Gabor
                Contlist = log_unit_down(max_contrast+.122, logUnitStep, nsteps); % contrast list for trainig type 1 and 4
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
        else
            if trainingType==2 || trainingType==4 % load thresholds from previous days
                d = dir(['./data/' SUBJECT '_FLAPtraining_type_' num2str(trainingType) '_Day_' num2str(expDay-1) '*.mat']);
                [dx,dx] = sort([d.datenum]);
                newest = d(dx(end)).name;
                lasttrackthresh=load(['./data/' newest],'trackthresh');
                trackthresh=lasttrackthresh.trackthresh;
            elseif trainingType==1
                d = dir(['./data/' SUBJECT '_FLAPtraining_type_' num2str(trainingType) '_Day_' num2str(expDay-1) '*.mat']);
                [dx,dx] = sort([d.datenum]);
                newest = d(dx(end)).name;
                lasttrackthresh=load(['./data/' newest],'thresh');
                thresh=lasttrackthresh.thresh;
                Contlist2=load(['./data/' newest],'Contlist');
                Contlist = Contlist2.Contlist;
                lasttracksf=load(['./data/' newest],'currentsf');
                currentsf=lasttracksf.currentsf;
            end
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
            
            sizeArray=log_unit_down(1.99, 0.008, nsteps); % array of TRL size: the larger, the easier the task (keeping the target within the PRL)
            persistentflickerArray=log_unit_up(0.08, 0.026, nsteps); % array of flickering persistence: the lower, the easier the task (keeping the target within the PRL for tot time)
            %higher pointer=more difficult
            % TRL size parameter
            sizepointer=15;
            coeffAdj=sizeArray(sizepointer); % possible list of TRL size (proportion of TRL size) that allows frames to be counted as 'within the TRL'
            % flcikering time parameter
            flickerpointerPre=15;
            flickerpointerPost=15;
            timeflickerallowed=persistentflickerArray(flickerpointerPre); % time before flicker starts
            flickerpersistallowed=persistentflickerArray(flickerpointerPost); % time away from flicker in which flicker persists
            
        end
        if expDay>1 % if we are not on day one, we load thresholds from previous days
            sizeArray=log_unit_down(1.99, 0.008, nsteps);
            persistentflickerArray=log_unit_up(0.08, 0.026, nsteps);
            
            d = dir(['./data/' 'AR' '_FLAPtraining_type_' num2str(trainingType) '_Day_' num2str(expDay-1) '*.mat']);
            
            [dx,dx] = sort([d.datenum]);
            newest = d(dx(end)).name;
            %  oldthresh=load(['./data/' newest],'thresh');
            previousFixTime2=load(['./data/' newest],'movieDuration');
            %previousresp=load(['./data/' newest],'rispo');
            previoustrials2=load(['./data/' newest],'trials');
            coeffAdj2=load(['./data/' newest],'coeffAdj'); 
            sizepointer2=load(['./data/' newest],'sizepointer');
            flickerpointerPre2 = load(['./data/' newest],'flickerpointerPre');
            flickerpointerPost2 = load(['./data/' newest],'flickerpointerPost');
            coeffAdj = coeffAdj2.coeffAdj;
            previousFixTime = previousFixTime2.movieDuration;
            previoustrials = previoustrials2.trials;
            sizepointer = sizepointer2.sizepointer;
            flickerpointerPre = flickerpointerPre2.flickerpointerPre;
            flickerpointerPost = flickerpointerPost2.flickerpointerPost;
%             if sum(previousresp)/previoustrials< 0.8
%                 coeffAdj=1.3;
%             elseif  sum(previousresp)/previoustrials> 0.8
%                 coeffAdj=1;
%             end
        end
    end
    
    %% Trial structure
    
    if trainingType==3 || trainingType==4
        
        % 1: shape type (1-6 for shapes, 1 for Gabors), 2: cue type (exo or endo), 3: stimulus type (gabor of shapes)
        if holdtrial==1 % if we want to hold target position for few consecutive trials
            
            newmat = [];
            theoriginalmat=mixtr;
            mixtr=[mixtr (1:length(theoriginalmat))'];
            for i=1:length(mixtr) % clone trials from original trial matrix
                %to have a series of stimuli presented in the same location
                newfirstone=mixtr(i,:);
                repnum=randi(2)+1;
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
    if demo==1
        ListenChar(2);
    end
    ListenChar(0);
    

    % check EyeTracker status, if Eyelink
    if EyetrackerType == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        Eyelink('message' , 'SYNCTIME');
        location =  zeros(length(mixtr), 6);
    end
    
   checkcounter = 0;
   shapecounter = 0;
  % currentsf = currentsf.currentsf;
    %% HERE starts trial loop
    for trial=1:length(mixtr)
        checkcounter = checkcounter + 1;
        if trial>1 && mixtr(trial,1) == mixtr(trial-1,1)
            shapecounter = shapecounter+1;
        else 
            if trial>1 && mixtr(trial,1)~= mixtr(trial-1,1)
                shapecounter = 0;
            end
        end
        % practice
        if trial==1 || trial>2 && mixtr(trial,1)~= mixtr(trial-1,1) && trainingType==2
            practicePassed=0;
      %         practicePassed=1;

        end
%         if demo==0
%             practicePassed=1;
%         end
        if trainingType<3
            while practicePassed==0
          %      FLAPpractice
          FLAPpractice
            end
        end
        if practicePassed==2
           closescript=1;
           break
        end
        
        
            % general instruction TO BE REWRITTEN
   if trainingType~=2 && trial==1
       InstructionFLAP(w,trainingType,gray,white)
   end
    
        %% training type-specific staircases
        
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
         %   trialTimeout=400000;
                        trialTimeout=realtrialTimeout+5;

        elseif trainingType==1 || trainingType==2 || demo==0 %if it's a training type 1 or 2 trial, no flicker
            FlickerTime=0;
        end
        %% generate answer for this trial (training type 3 has no button response)
        
        if trainingType==1 ||  (trainingType==4 && mixtr(trial,3)==1)
            theans(trial)=randi(2);
            ori=theoris(theans(trial));
        elseif trainingType==2 || (trainingType==4 && mixtr(trial,3)==2)
            theans(trial)=randi(2);
            CIstimuliModII % add the offset/polarity repulsion
        end
        %% target location calculation
        if trainingType==1 || trainingType==2 % if training type 1 or 2, stimulus always presented in the center
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
                xlimit=[-8:0.5:8]*pix_deg;
                ylimit=xlimit;
                theeccentricity_X=xlimit(randi(length(xlimit)));
                theeccentricity_Y=ylimit(randi(length(xlimit)));
            end
        end
        
        if trial==length(mixtr)
            endExp=GetSecs; %time at the end of the session
        end
        
        if demo==1
            if mod(trial,round(length(mixtr)/8))==0 %|| trial== length(mixtr)/4 || trial== length(mixtr)/4
                interblock_instruction
            end
            
        end
        if trainingType==2
            if trial==1
                InstructionShape
            elseif trial>1
                if mixtr(trial,1)~=mixtr(trial-1,1)
                    InstructionShape
                end
            end
        end
        
        %  destination rectangle for the target stimulus
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
        
        %  destination rectangle for the fixation dot
        imageRect_offs_dot=[imageRectDot(1)+theeccentricity_X, imageRectDot(2)+theeccentricity_Y,...
            imageRectDot(3)+theeccentricity_X, imageRectDot(4)+theeccentricity_Y];
        
        %% Initialization/reset of several trial-based variables
        FLAPVariablesReset % reset some variables used in each trial
        if trial==1
            startExp=GetSecs; %time at the beginning of the session
        end
        while eyechecked<1
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            if trainingType<3
                fixationscriptW % visual aids on screen
            end
            fixating=1500;
            
            if trainingType>2 && trial>1 %if it's training 3 or 4 trial, we evaluate whether it's a cue trial
                %    if mixtr(trial,2)~=mixtr(trial-1,2) || mixtr(trial,2)==2 && mixtr(trial,1)~=mixtr(trial-1,1) % ||  trial==1
                
                if mixtr(trial,4)~=mixtr(trial-1,4)
                    if mixtr(trial,2)==1 %if it's endogenous cue
                        %calculations for arrow pointing to the next location (endo cue)
                        nexcoordx=(imageRect_offs(1)+imageRect_offs(3))/2;
                        nexcoordy=(imageRect_offs(2)+imageRect_offs(4))/2;
                        previouscoordx=(rectimage{kk-1}(1)+rectimage{kk-1}(3))/2;
                        previouscoordy=(rectimage{kk-1}(2)+rectimage{kk-1}(4))/2;
                        delta=[previouscoordx-nexcoordx previouscoordy-nexcoordy];
                        oriArrow(trial)=atan2d(delta(2), delta(1));
                        oriArrow(trial)=oriArrow(trial)-90;
                    elseif mixtr(trial,2)==2 %if it's exogenous cue (circle flashing to the next location)
                    end
                end
                currentExoEndoCueDuration=ExoEndoCueDuration(mixtr(trial,2));
            else
                currentExoEndoCueDuration=ExoEndoCueDuration(1);
            end
            %% here is where the first time-based trial loop starts (until first forced fixation is satisfied)
            if (eyetime2-trial_time)>=ifi*2 && (eyetime2-trial_time)<ifi*2+preCueISI && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                % pre-event empty space, allows for some cleaning
                if trainingType==1 || trainingType==2 % no flicker type of training trial
                    counterflicker=-10000;
                end
                
            elseif (eyetime2-trial_time)>=ifi*2+preCueISI && (eyetime2-trial_time)<+ifi*2+preCueISI+currentExoEndoCueDuration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                if exist('startrial') == 0
                    startrial=1;
                    trialstart(trial)=GetSecs;
                    trialstart_frame(trial)=eyetime2;
                end
                % HERE I present the cue for training types 3 and 4 or skip
                % this interval for training types 1 and 2
                
                if trainingType>2 && trial>1
                    %   if mixtr(trial,2)~=mixtr(trial-1,2) || mixtr(trial,3)==2 && mixtr(trial,1)~=mixtr(trial-1,1) % ||  trial==1
                    if mixtr(trial,4)~=mixtr(trial-1,4)
                        if mixtr(trial,2)==1 %endogenous cue
                            newrectimage{kk}=[rectimage{kk-1}(1)-2*pix_deg rectimage{kk-1}(2)-2*pix_deg rectimage{kk-1}(3)+2*pix_deg rectimage{kk-1}(4)+2*pix_deg ];
                            Screen('DrawTexture', w, theArrow, [], rectimage{kk-1}, oriArrow(trial),[], 1);
                            realcuecontrast=cuecontrast*0.1;
                            isendo=1;
                            contrastcounter=0;
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
            elseif (eyetime2-trial_time)>=ifi*2+preCueISI+currentExoEndoCueDuration+postCueISI && fixating>400 && stopchecking>1 && flickerdone<1 && counterannulus<=AnnulusTime/ifi && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ==0 && (eyetime2-pretrial_time)<=trialTimeout
                % here I need to reset the trial time in order to preserve
                % timing for the next events (first fixed fixation event)
                % HERE interval between cue disappearance and beginning of
                % next stream of flickering stimuli
                if trainingType~=3 % no more dots!
                    Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                end
                if skipforcedfixation==1 % skip the forced fixation
                    counterannulus=(AnnulusTime/ifi)+1;
                    skipcounterannulus=1000;
                else %force fixation for training types 1 and 2
                    if trainingType<3
                        [counterannulus framecounter ]=  IsFixatingSquareNew2(wRect,newsamplex,newsampley,framecounter,counterannulus,fixwindowPix);
                    elseif trainingType>2
                        [counterannulus framecounter ]=  IsFixatingPRL3(newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,EyetrackerType,theeccentricity_X,theeccentricity_Y,framecounter,counterannulus);
                    end
                    if trainingType~=3 % no more dots!
%                        Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                    elseif trainingType==3 %force fixation for training types 3
                        if exist('isendo') == 0
                            isendo=0;
                        end
                        if isendo==1 % if is endo trial we slowly increase the visibility of the cue
                            if mod(round(eyetime2-trial_time),100)
                                contrastcounter=contrastcounter+1;
                                realcuecontrast=(cuecontrast*0.45)+(contrastcounter/2000);
                            end
                            Screen('FillOval', w, realcuecontrast, imageRect_offs_dot);
                        elseif isendo==0
                            realcuecontrast=cuecontrast;
                            Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], realcuecontrast);
                        end
                    end
                    if counterannulus==round(AnnulusTime/ifi) % when I have enough frame to satisfy the fixation requirements
                        newtrialtime=GetSecs;
                        skipcounterannulus=1000;
                    end
                end
            elseif (eyetime2-trial_time)>=ifi*2+preCueISI+currentExoEndoCueDuration+postCueISI && fixating>400 && stopchecking>1 && counterannulus<AnnulusTime/ifi && flickerdone<1 && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ~=0 && (eyetime2-pretrial_time)<=trialTimeout
                % HERE I exit the script if I press ESC
                thekeys = find(keyCode);
                closescript=1;
                break;
            end
            %% here is where the second time-based trial loop starts
            if (eyetime2-newtrialtime)>=forcedfixationISI && fixating>400 && stopchecking>1 && skipcounterannulus>10 && counterflicker<=FlickerTime/ifi && flickerdone<1 && (eyetime2-pretrial_time)<=trialTimeout
                % HERE starts the flicker for training types 3 and 4, if
                % training type is 1 or 2, this is skipped
                
                if exist('flickerstar') == 0 % start flicker timer
                    flicker_time_start(trial)=eyetime2; % beginning of the overall flickering period
                    flickerstar=1;
                    flickswitch=0;
                    flick=1;
                end
                flicker_time=GetSecs-flicker_time_start(trial);     % timer for the flicker decision
                if flicker_time>flickswitch % time to flicker?
                    flickswitch= flickswitch+flickeringrate;
                    flick=3-flick; % flicker/non flicker
                end
                if trainingType>2 && demo==1  % Force flicker here (training type 3 and 4)
                    [countgt framecont countblank blankcounter counterflicker turnFlickerOn]=  ForcedFixationFlicker3(w,countgt,countblank, framecont, newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,theeccentricity_X,theeccentricity_Y,blankcounter,framesbeforeflicker,blankframeallowed, EyeData, counterflicker,eyetime2,EyeCode,turnFlickerOn);
                end
                
                % from ForcedFixationFlicker3, should I show the flicker or not?
                if turnFlickerOn(end)==1 %flickering cue
                    if flick==2
                        if trainingType==3
                            Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                        elseif trainingType==4
                            Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                        end
                    end
                elseif turnFlickerOn(end)==0 %non-flickering cue
                    if trainingType==3
                        Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                    elseif trainingType==4
                        Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                    end
                end
                if exist('circlestar')==0
                    circle_start = GetSecs;
                    circlestar=1;
                end
                cue_last=GetSecs;
                
                if trainingType>2 && counterflicker>=round(FlickerTime/ifi) || trainingType<3 || demo==0
                    newtrialtime=GetSecs; % when fixation constrains are satisfied, I reset the timer to move to the next series of events
                    flickerdone=10;
                    flicker_time_stop(trial)=eyetime2; % end of the overall flickering period
                end
            elseif (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0 && stopchecking>1 %present pre-stimulus and stimulus
                % HERE I PRESENT THE TARGET
                
                if trainingType==3
                    eyechecked=10^4; % if it's training type 3, we exit the trial, good job
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
                     %   imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                                  %          imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)+pix_deg*2 (xs/coeffCI*pix_deg)]+pix_deg*2 ], wRect);
                                    %          imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)+pix_deg*2 (xs/coeffCI*pix_deg_vert)]+pix_deg_vert*2 ], wRect);
                                               imageRectMask = CenterRect([0, 0,  CIstimulussize+maskthickness CIstimulussize+maskthickness ], wRect);
                                           %    imageRectMask = CenterRect([0, 0, [ (stimulusSize*2*pix_deg) (stimulusSize*2*pix_deg_vert)] ], wRect);
 imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
                            imageRectMask(3)+eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];
                    end
                    %here I draw the target contour
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
                    imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0; % target coordinates
                    if demo==0
                        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], 0.99 );
                    end
                    % here I draw the circle within which I show the contour target
                    Screen('FrameOval', w,[gray], imageRect_offsCImask, maskthickness/2, maskthickness/2);
              %                    Screen('FrameOval', w,[gray*1.5], imageRect_offsCImask, 1, 1);
fixationscriptW
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
                
            elseif (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 %present pre-stimulus and stimulus
                eyechecked=10^4; % exit loop for this trial
                thekeys = find(keyCode);
                if length(thekeys)>1
                    thekeys=thekeys(1);
                end
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
                respTime=GetSecs;
                
            elseif (eyetime2-newtrialtime)>=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 %present pre-stimulus and stimulus
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
                if trainingType>2
                    visiblePRLring
                end
            else % else we get a fixation cross and no scotoma
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
            end
            if demo==1
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
                    PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    if trainingType~=3
%                     count1 = count1 + 1; % first stage staircase counter
                    corrcounter(mixtr(trial,1),mixtr(trial,3))=corrcounter(mixtr(trial,1),mixtr(trial,3))+1;
                    
                    if  corrcounter(mixtr(trial,1),mixtr(trial,3))==sc.down
                        isreversals(mixtr(trial,1),mixtr(trial,3))=1;
                    end
              % if more than 3 reversals have passed, we switch to a 3:1
              % staircase
                    if corrcounter(mixtr(trial,1),mixtr(trial,3))==sc.down && reversals(mixtr(trial,1),mixtr(trial,3)) >= 3
                        if isreversals(mixtr(trial,1),mixtr(trial,3))==1
                            reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                            isreversals(mixtr(trial,1),mixtr(trial,3))=0;
                        end
                        thestep=min(reversals(mixtr(trial,1),mixtr(trial,3))+1,length(stepsizes));
                    else
               % the staircase begins as a 1 up 1 down until 3 reversals
               % have passed
                        if reversals(mixtr(trial,1),mixtr(trial,3)) < 3
                            if isreversals(mixtr(trial,1),mixtr(trial,3))==1
                                reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                                isreversals(mixtr(trial,1),mixtr(trial,3))=0;
                            end
                            thestep=min(reversals(mixtr(trial,1),mixtr(trial,3))+1,length(stepsizes));
                        end
                        % if we want to prevent streaking, uncomment below
%                         corrcounter(mixtr(trial,1),mixtr(trial,3))=0;
                    end
                end
                if trainingType==1 || (trainingType == 4 && mixtr(trial,3)==1)
                    
                    if corrcounter(mixtr(trial,1),mixtr(trial,3))==sc.down && reversals(mixtr(trial,1),mixtr(trial,3)) >= 3 % if we have enough consecutive correct responses to
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
                        corrcounter(mixtr(trial,1),mixtr(trial,3))=0;
                    else
                        if reversals(mixtr(trial,1),mixtr(trial,3)) < 3
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
                            corrcounter(mixtr(trial,1),mixtr(trial,3))=0;
                        end
                    end
                end
                if trainingType==2 || (trainingType == 4 && mixtr(trial,3)==2)
                    if corrcounter(mixtr(trial,1),mixtr(trial,3))>=sc.down && reversals(mixtr(trial,1),mixtr(trial,3)) >= 3
                        thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)) +stepsizes(thestep);
                        thresh(mixtr(trial,1),mixtr(trial,3))=min( thresh(mixtr(trial,1),mixtr(trial,3)),length(JitList));
                        corrcounter(mixtr(trial,1),mixtr(trial,3))=0;
                    else
                        if reversals(mixtr(trial,1),mixtr(trial,3)) < 3
                            thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)) +stepsizes(thestep);
                            thresh(mixtr(trial,1),mixtr(trial,3))=min( thresh(mixtr(trial,1),mixtr(trial,3)),length(JitList));
                            corrcounter(mixtr(trial,1),mixtr(trial,3))=0;
                        end
                    end
                end
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                ListenChar(0);
                break;
            else
                resp = 0; % if wrong response
                    PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    if trainingType~=3
                    if  corrcounter(mixtr(trial,1),mixtr(trial,3))>=sc.down && reversals(mixtr(trial,1),mixtr(trial,3)) >= 3
                        isreversals(mixtr(trial,1),mixtr(trial,3))=1;
                        reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
%                     else
%                         if reversals(mixtr(trial,1),mixtr(trial,3)) < 3
%                             isreversals(mixtr(trial,1),mixtr(trial,3))=1;
%                             reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
%                         end
                    end
                    corrcounter(mixtr(trial,1),mixtr(trial,3))=0;
                    thestep=min(reversals(mixtr(trial,1),mixtr(trial,3))+1,length(stepsizes));
                end
                if trainingType==1 || trainingType == 4 && mixtr(trial,3)==1
                    if contr>SFthreshmax && currentsf>1
                        currentsf=max(currentsf-1,1);
                        thresh(:,:)=StartCont;
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
       %         PsychPortAudio('Start', pahandle2);
            elseif trialTimedout(trial)==1
                    PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
            else
                    PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
            end
        else % if trial has timed out, 
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
            resp = 0;
            respTime=0;
                    PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    if trainingType~=3
                if  corrcounter(mixtr(trial,1),mixtr(trial,3))==sc.down && reversals(mixtr(trial,1),mixtr(trial,3)) >= 3
                    isreversals(mixtr(trial,1),mixtr(trial,3))=1;
                    reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                else
                    if reversals(mixtr(trial,1),mixtr(trial,3)) < 3
                        isreversals(mixtr(trial,1),mixtr(trial,3))=1;
                        reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                    end
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
        if trainingType > 2 % if it's a
            %   training type with flicker
            %   fixDuration(trial)=flicker_time_start-trial_time;
            if flickerdone>1
                flickertimetrial(trial)=FlickerTime; %  nominal duration of flicker
                movieDuration(trial)=flicker_time_stop(trial)-flicker_time_start(trial); % actual duration of flicker
                Timeperformance(trial)=movieDuration(trial)-(flickertimetrial(trial)*3); % estimated difference between actual and expected flicker duration
                unadjustedTimeperformance(trial)=movieDuration(trial)-flickertimetrial(trial);
            end
        end
        if trainingType==2
            trackthresh(shapesoftheDay(mixtr,1))=thresh(mixtr,1);
            threshperday(expDay,:)=trackthresh;
        end
        if (mod(trial,150))==1 && trial>1
                save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
        end
        if (mod(trial,10))==1 && trial>1 && trainingType==3
            updatecounter=updatecounter+1;
            %some adaptive measures for the TRL size that counts as 'fixation within the TRL'
            if mean(unadjustedTimeperformance(end-9:end))>8
                if mod(updatecounter,2)==0 && flickerpointerPre ~= 0 && flickerpointerPre ~= 1
                    %here we implement staircase on flicker time
                    flickerpointerPre=flickerpointerPre-1;
                    flickerpointerPost=flickerpointerPost+1;   
                end
            sizepointer=sizepointer-1; % increase the size of the TRL region within which the target will be deemed as 'seen through the TRL'
            elseif mean(unadjustedTimeperformance(end-9:end))<5
                if mod(updatecounter,2)==0 && flickerpointerPost ~= 0 && flickerpointerPost ~= 1 
                    %here we implement staircase on flicker time
                    flickerpointerPre=flickerpointerPre+1;
                    flickerpointerPost=flickerpointerPost-1;
                end
               if sizepointer~=length(sizeArray)
                  sizepointer=sizepointer+1; % decrease the size of the TRL region within which the target will be deemed as 'seen through the TRL'
                  end
            end
            timeflickerallowed=persistentflickerArray(flickerpointerPre); % time before flicker starts
            flickerpersistallowed=persistentflickerArray(flickerpointerPost); % time away from flicker in which flicker persists
            coeffAdj=sizeArray(sizepointer);
        end
        
        TRLsize(trial)=coeffAdj;
        flickOne(trial)=timeflickerallowed;
        flickTwo(trial)=flickerpersistallowed;
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
            end
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
            end
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
        if closescript==1
            break;
        end
        kk=kk+1;
        if shapecounter>11 && trainingType~=3 
            if mod(checkcounter,10) == 0 && sum(Threshlist(mixtr(trial,1),mixtr(trial,3),staircounter(mixtr(trial,1),mixtr(trial,3))-10:staircounter(mixtr(trial,1),mixtr(trial,3))))==0
                DrawFormattedText(w, 'Wake up and call the experimenter', 'center', 'center', white);
                Screen('Flip', w);
                KbQueueWait;
            end
        end
    end
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
    
    ListenChar(0);
    Screen('Flip', w);
    
    %% shut down EyeTracker and screen functions
    if EyetrackerType==1
        Eyelink('StopRecording');
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    end
    
    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
        save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    KbQueueWait;

    ShowCursor;
    Screen('CloseAll');
    PsychPortAudio('Close', pahandle);
    
catch ME
    psychlasterror()
end