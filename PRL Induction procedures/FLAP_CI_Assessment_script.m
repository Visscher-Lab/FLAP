% FLAP Training
% written by Marcello A. Maniglia july 2021 %2017/2021
% Training script for FLAP. This script runs the assessment for the Contour
% Integration in the presence of simulated central vision loss.
% participants use one of 4 PRL (peripheral retinal location) present either left
% or right up or down of the simulated scotoma.
% Participants identify contours in the presence of background elements
% when jitter is manipulated for two groups of shapes: 'p' & 'd' or '2' &
% '5'


close all; clear all; clc;
commandwindow


addpath([cd '/utilities']); %add folder with utilities files
try
    prompt={'Participant Name', 'day','site? UCR(1), UAB(2), Vpixx(3)', 'Demo? (1:yes, 2:no)', 'Eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Scotoma? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '3', '2' , '2', '0', '1', '1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    penalizeLookaway=0;   %mostly for debugging, we can remove the masking on the target when assigned PRL ring is out of range
    expDay=str2num(answer{2,:}); % training day (if >1
    site = str2num(answer{3,:}); % training site (UAB vs UCR vs Vpixx)
    demo=str2num(answer{4,:}); % are we testing in debug mode?
    test=demo;
    whicheye=str2num(answer{5,:}); % are we tracking left (1) or right (2) eye? Only for Vpixx
    calibration=str2num(answer{6,:}); % do we want to calibrate or do we skip it? only for Vpixx
    ScotomaPresent = str2num(answer{7,:}); % 0 = no scotoma, 1 = scotoma
    EyeTracker = str2num(answer{8,:}); %0=mouse, 1=eyetracker
    TRLlocation = 1;
    
    %create a data folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    baseName=['./data/' SUBJECT '_FLAPCIAssessment_' TimeStart]; %makes unique filename
    
    defineSite % initialize Screen function and features depending on OS/Monitor
    CommonParametersCIAssessmentFLAP % define common parameters
    
    PRLecc=[0 7.5 0 -7.5; -7.5 0 7.5 0]; %eccentricity of PRL in deg
    %% eyetracker initialization (eyelink)
    
    if EyeTracker==1
        if site==3
            EyetrackerType=2; %1 = Eyelink, 2 = Vpixx
        else
            EyetrackerType=1; %1 = Eyelink, 2 = Vpixx
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
    
    PreparePRLpatch
    
    CIAssessmentShapes % Isolating the 2 shapes using which we want to perform the assessment
    
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
    
    %% Trial matrix definition
    
    % initialize jitter matrix
    shapes=2; % how many shapes per day?
    JitList = 0:2:90;
    StartJitter=1;
    
    %define number of trials per condition
    
    conditionOne=shapes; % shapes (training type 2)
    conditionTwo=2; %locations (left and right - TRL and URL)
    if demo==1
        trials=5; %total number of trials per staircase (per shape)
    else
        trials=30;  %total number of trials per staircase (per shape)
    end
     % 4 combinations of shapes x locations repeated for 4 blocks with each combination repeated for 30 trials
    mixcond = [1 1; 1 2; 1 1; 1 2; 2 1; 2 2; 2 1; 2 2; 1 2; 1 1; 1 2; 1 1; 2 2; 2 1; 2 2; 2 1];
    mixtr = [];
    for block = 1:16
        mixtr = [mixtr; repmat(mixcond(block,:),trials,1)];
    end

    %% STAIRCASE
    nsteps=70; % elements in the stimulus intensity list (contrast or jitter or TRL size in training type 3)
    stepsizes=[4 4 3 2 1]; % step sizes for staircases
    % Threshold -> 79%
    sc.up = 1;   % # of incorrect answers to go one step up
    sc.down = 3;  % # of correct answers to go one step down
    shapesoftheDay= [1 2];
    
    % Defining intial matrices to track thresholds
    AllShapes=size((Targy));
    trackthresh=[ones(AllShapes(2),1)*StartJitter, ones(conditionTwo,1)*StartJitter]; %assign initial jitter to shapes
    thresh=trackthresh(shapesoftheDay, 1:conditionTwo);
    reversals(1:conditionOne, 1:conditionTwo)=0;
    isreversals(1:conditionOne, 1:conditionTwo)=0;
    staircounter(1:conditionOne, 1:conditionTwo)=0;
    corrcounter(1:conditionOne, 1:conditionTwo)=0;
    
    %% Trial structure
    
%     if annulusOrPRL==1 % annulus for pre-target fixation (default is NOT this)
%         % here I define the annulus around the scotoma which allows for a
%         % fixation to count as 'valid', i.e., the flickering is on when a
%         % fixation is within this region
%         [sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);
%         smallradiusannulus=(scotomadeg/2)*pix_deg; % inner circle: scotoma eccentricity
%         largeradiusannulus=smallradiusannulus+3*pix_deg; %outer circle (3 degrees from the border of the scotoma
%         circlePixels=sx.^2 + sy.^2 <= largeradiusannulus.^2;
%         circlePixels2=sx.^2 + sy.^2 <= smallradiusannulus.^2;
%         d=(circlePixels2==1);
%         newfig=circlePixels;
%         newfig(d==1)=0;
%         circlePixelsPRL=newfig;
%     end
    
    %% Initialize trial loop
    HideCursor;
    if demo==2
        ListenChar(2);
    end
    ListenChar(0);
    
    % general instruction TO BE REWRITTEN
    InstructionCIFLAP(w,shapesoftheDay,gray,white) % Probably need to change it for the assessment type
    
    %% HERE starts trial loop
    for trial=1:length(mixtr)
        
        % practice - Needs to maybe be changed, otherwise we have about 120
        % practice trials???????????
        if trial==1 || trial>2 && mixtr(trial,1)~= mixtr(trial-1,1)
            practicePassed=0;
        end
        while practicePassed==0
            FLAPCIAssessmentPractice
        end
        
        
        %% training type-specific staircases
        Orijit=JitList(thresh(mixtr(trial,1),mixtr(trial,2)));
        Tscat=0;
        FlickerTime=0;
        
        %% generate answer for this trial (training type 3 has no button response)
        theans(trial)=randi(2);
        CIstimuliMod % add the offset/polarity repulsion
        
        %% target location calculation
        theeccentricity_Y=0;
        theeccentricity_X=PRLx*pix_deg;
        eccentricity_X(trial)= theeccentricity_X;
        eccentricity_Y(trial) =theeccentricity_Y ;
        
        if trial==length(mixtr)
            endExp=GetSecs; %time at the end of the session
        end
        
        if demo==2
            if mod(trial,round(length(mixtr)/16))==0 %|| trial== length(mixtr)/4 || trial== length(mixtr)/4
                interblock_instruction
            end
            
        end
        
        if trial==1
            InstructionCIAssessment
        elseif trial>1
            if mixtr(trial,2) ~= mixtr(trial-1,2) || mixtr(trial,1)~=mixtr(trial-1,1)
                InstructionCIAssessment
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
            fixationscriptW % visual aids on screen
            fixating=1500;
            
            %% here is where the first time-based trial loop starts (until first forced fixation is satisfied)
            if (eyetime2-trial_time)>=ifi*2 && (eyetime2-trial_time)<ifi*2+preCueISI && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout                
                % pre-event empty space, allows for some cleaning
                counterflicker=-10000;
                if skipforcedfixation==1 % skip the force fixation
                    counterannulus=(AnnulusTime/ifi)+1;
                    skipcounterannulus=1000;
                else %force fixation for training types 1 and 2
                    %   [counterannulus framecounter ]=  IsFixatingPRL3(newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,EyetrackerType,theeccentricity_X,theeccentricity_Y,framecounter,counterannulus)
                    
                    [counterannulus framecounter ]=  IsFixatingSquareNew2(wRect,newsamplex,newsampley,framecounter,counterannulus,fixwindowPix);
                    
                    Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                    
                    if counterannulus==round(AnnulusTime/ifi) % when I have enough frame to satisfy the fixation requirements
                        newtrialtime=GetSecs;
                        skipcounterannulus=1000;
                    end
                end
            end
          %% here is where the second time-based trial loop starts
%             if (eyetime2-newtrialtime)>=forcedfixationISI && fixating>400 && stopchecking>1 && skipcounterannulus>10 && counterflicker<=FlickerTime/ifi && flickerdone<1 && (eyetime2-pretrial_time)<=trialTimeout
%                 % HERE starts the flicker for training types 3 and 4, if
%                 % training type is 1 or 2, this is skipped
%                 
%                 
%                 
%                 if exist('circlestar')==0
%                     circle_start = GetSecs;
%                     circlestar=1;
%                 end
%                 cue_last=GetSecs;
%                 newtrialtime=GetSecs; % when fixation constrains are satisfied, I reset the timer to move to the next series of events
%                 flickerdone=10;
%                 flicker_time_stop(trial)=eyetime2; % end of the overall flickering period
%             elseif (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0 && stopchecking>1 %present pre-stimulus and stimulus
%                 % HERE I PRESENT THE TARGET
%                 
%                 if exist('imageRect_offsCI')==0    % destination rectangle for CI stimuli
%                     imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(trial),...
%                         imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(trial)];
%                     imageRect_offsCI2=imageRect_offsCI;
%                     imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
%                     imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
%                         imageRectMask(3)+eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];
%                 end
%                 %here I draw the target contour
%                 Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
%                 imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
%                 if demo==1
%                     Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], 0.7 );
%                 end
%                 % here I draw the circle within which I show the contour target
%                 Screen('FrameOval', w,gray, imageRect_offsCImask, 22, 22);
%                 if skipmasking==0
%                     assignedPRLpatch
%                 end
%                 imagearray{trial}=Screen('GetImage', w);
%                 
%                 if exist('stimstar')==0
%                     stim_start = GetSecs;
%                     stim_start_frame=eyetime2;
%                     stimstar=1;
%                 end
%                 
%             elseif (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 %present pre-stimulus and stimulus
%                 eyechecked=10^4; % exit loop for this trial
%                 thekeys = find(keyCode);
%                 if length(thekeys)>1
%                     thekeys=thekeys(1);
%                 end
%                 thetimes=keyCode(thekeys);
%                 [secs  indfirst]=min(thetimes);
%                 respTime=GetSecs;
%                 
%             elseif (eyetime2-newtrialtime)>=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 %present pre-stimulus and stimulus
%                 eyechecked=10^4; % exit loop for this trial
%                 thekeys = find(keyCode);
%                 if length(thekeys)>1
%                     thekeys=thekeys(1);
%                 end
%                 thetimes=keyCode(thekeys);
%                 [secs  indfirst]=min(thetimes);
%                 respTime=GetSecs;
%             elseif (eyetime2-pretrial_time)>=trialTimeout
%                 stim_stop=GetSecs;
%                 trialTimedout(trial)=1;
%                 %    [secs  indfirst]=min(thetimes);
%                 eyechecked=10^4; % exit loop for this trial
%             end
            %% here I draw the scotoma, elements below are called every frame
            eyefixation5
            if ScotomaPresent == 1 % do we want the scotoma? (default is yes)
                Screen('FillOval', w, scotoma_color, scotoma);
            else % else we get a fixation cross and no scotoma
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
            end
            if demo==2
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
        if trialTimedout(trial)== 0 
            foo=(RespType==thekeys);

                staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
                Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=Orijit;
            if foo(theans(trial)) % if correct response
                resp = 1;
                PsychPortAudio('Start', pahandle1); % sound feedback
                    corrcounter(mixtr(trial,1),mixtr(trial,2))=corrcounter(mixtr(trial,1),mixtr(trial,2))+1;
                    if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                        if isreversals(mixtr(trial,1),mixtr(trial,2))==1
                            reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
                            isreversals(mixtr(trial,1),mixtr(trial,2))=0;
                        end
                        thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                        % if we want to prevent streaking, uncomment below
                        %corrcounter(mixtr(trial,1),mixtr(trial,3))=0;
                    end
                    if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                        thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) +stepsizes(thestep);
                        thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(JitList));
                    end
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                ListenChar(0);
                break;
            else
                resp = 0; % if wrong response
                PsychPortAudio('Start', pahandle2); % sound feedback
                    if  corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                        isreversals(mixtr(trial,1),mixtr(trial,2))=1;
                    end
                    corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
                    thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                    thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
                    thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)),1);
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
            rispo(kk)=resp;
            respTimes(trial)=respTime;
            cueendToResp(kk)=stim_stop-cue_last;
            cuebeginningToResp(kk)=stim_stop-circle_start;
            trackthresh(shapesoftheDay(mixtr,1))=thresh(mixtr,1);
            threshperday(expDay,:)=trackthresh;
        if (mod(trial,120))==1
            if trial==1
            else
                save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
            end
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
        if trial>11
            if sum(Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2))-10:staircounter(mixtr(trial,1),mixtr(trial,2))))==0
                DrawFormattedText(w, 'Wake up and call the experimenter', 'center', 'center', white);
                Screen('Flip', w);
                KbQueueWait;
            end
        end
    end
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    
    ListenChar(0);
    Screen('Flip', w);
    KbQueueWait;
    
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
    
    ShowCursor;
    Screen('CloseAll');
    PsychPortAudio('Close', pahandle);
    
catch ME
    psychlasterror()
end