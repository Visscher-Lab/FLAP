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
%The trial ends when the overall flickering tn.ime is fulfilled, thus the more
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
    prompt={'Participant Name', 'day','site? UCR(1), UAB(2), Vpixx(3)', 'Practice (0) or Session(1)', 'Eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Scotoma? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?', 'response box (1) or keyboard (0)'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '3', '1' , '2', '0', '1', '1', '1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    penalizeLookaway=0;   %mostly for debugging, we can remove the masking on the target when assigned PRL ring is out of range
    expDay=str2num(answer{2,:}); % training day (if >1
    site = str2num(answer{3,:}); % training site (UAB vs UCR vs Vpixx)
    %     AssessmentType=str2num(answer{4,:}); % Assessment type: 1=contrast, 2=contour integration
    demo=str2num(answer{4,:}); % practice
    whicheye=str2num(answer{5,:}); % are we tracking left (1) or right (2) eye? Only for Vpixx
    calibration=str2num(answer{6,:}); % do we want to calibrate or do we skip it? only for Vpixx
    ScotomaPresent = str2num(answer{7,:}); % 0 = no scotoma, 1 = scotoma
    EyeTracker = str2num(answer{8,:}); %0=mouse, 1=eyetracker
    responsebox=str2num(answer{9,:});
    TRLlocation = 2;
    datapixxtime = 1;
    scotomavpixx= 0;
    
    %create a data folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    baseName=['./data/' SUBJECT '_FLAPCIAssessment_Day_' answer{2,:} '_' TimeStart]; %makes unique filename
    
    defineSite % initialize Screen function and features depending on OS/Monitor
    
    CommonParametersFLAPAssessment % define common parameters
    
    PRLecc = [-7.5,0; 7.5,0];
    LocX = [-7.5, 7.5];
    LocY = [0, 0];
    
    %% eyetracker initialization (eyelink)
    if EyeTracker==1
        if site==3
            EyetrackerType=2; %1 = Eyelink, 2 = Vpixx
        else
            EyetrackerType=1; %1 = Eyelink, 2 = Vpixx
        end
        eyetrackerparameters % set up Eyelink eyetracker
    else
        EyetrackerType=0;
    end
    CIShapesIII
    
    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    end
    %% Trial matrix definition
    
    % initialize jitter matrix
    shapes=2; % how many shapes per day?
    JitList = 0:1:90;
    StartJitter=1;
    
    
    %define number of trials per condition
    
    conditionOne=shapes; % shapes (training type 2)
    conditionTwo=2; %location of the target
    if demo==0
        trials=5; %total number of trials per staircase (per shape)
    else
        trials=60;  %total number of trials per staircase (per shape) % trials = 10; debugging
    end
    
    %create trial matrix
    mixcond{1,1} = [1 1; 1 2; 2 2; 2 1];
    mixcond{2,1} = [1 2; 1 1; 2 1; 2 2];
    mixcond{3,1} = [2 1; 2 2; 1 2; 1 1];
    mixcond{4,1} = [2 2; 2 1; 1 1; 1 2];
    for cond = 1:length(mixcond)
        dummy = [];
        for block = 1:length(mixcond{cond,1})
            dummy = [dummy; repmat(mixcond{cond,1}(block,:),trials,1)]; %StartJitter
        end
        mixtr{cond,1} = dummy;
    end
    
%     RespType=[dinRed;
%         dinGreen;
%         dinYellow;
%         dinBlue]';
    %% STAIRCASE
    nsteps=70; % elements in the stimulus intensity list (contrast or jitter or TRL size in training type 3)
    stepsizes=[4 4 4 2 2 2]; % step sizes for staircases
    % Threshold -> 79%
    sc.up = 1;                          % # of incorrect answers to go one step up
    sc.steps= [2 3];                    % # of correct answers to go one step down
    if demo==0
        shapeMat(:,1)= [1 9];
    end
    shapeMat(:,1)= [9 10];
    
    %1: 9 vs 6 19 elements
    %2: 9 vs 6 18 elements
    %3: p vs q
    %4 d vs b
    %5 eggs
    %6: diagonal line
    %7:horizontal vs vertical line
    %8: rotated eggs
    % 9: d and b more elements
    %10: p and q more elements
    %11: %% rotated 6 vs 9 with 19 elements
    
    shapesoftheDay=shapeMat;
    AllShapes=size((Targy));
    trackthresh=ones(AllShapes(2),conditionTwo)*StartJitter; %assign initial jitter to shapes per location
    thresh(1,:)=trackthresh(1,:); % shape 1 location 1 (left), shape 1 location 2 (right)
    thresh(2,:)=trackthresh(2,:); % shape 2 location 1 (left), shape 2 location 2 (right)
    % reversal and counters for each shape and each location
    % depending on mixtr
    reversals = zeros(2,2);
    isreversals = zeros(2,2);
    staircounter = zeros(2,2);
    corrcounter = zeros(2,2);
    
    %% Trial structure
    
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
    
    % general instruction TO BE REWRITTEN
    InstructionFLAPAssessment(w,gray,white)
    theoris =[-45 45];
    
    % check EyeTracker status, if Eyelink
    if EyetrackerType == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        Eyelink('message' , 'SYNCTIME');
        location =  zeros(length(mixtr), 6);
    end
    
    
    %% HERE starts trial loop
    randpick = 1;
    mixtr = mixtr{randi(randpick,1),1};% this is just for debugging, for the actual study, this needs to be the mod of
    % mixtr %(participant's ID,2) for contrast and mod (participant'ss ID,4) for contour assessment
    trialcounter = 0;
    checkcounter = 0;
    resetcounter(1:2) = 1;
    for trial=1:length(mixtr)
        checkcounter = checkcounter + 1;
        if trial > 1 && mixtr(trial,2) == mixtr(trial-1,2) && mixtr(trial,1) == mixtr(trial-1,1)
            trialcounter = trialcounter + 1;
        else
            if trial > 1 % && (mixtr(trial,2) ~= mixtr(trial-1,2) || mixtr(trial,1) ~= mixtr(trial-1,1))
                trialcounter = 0;
            end
        end
        %         % practice
        if trial==1 || trial>2 && mixtr(trial,1)~= mixtr(trial-1,1) || mixtr(trial,2) ~= mixtr(trial-1,2)
            practicePassed=0;
        end
        %         if trial == 1
        %             while practicePassed == 0
        %                 FLAPpracticeAssessmentfb
        %             end
        %         elseif trial > 1
        %             if mixtr(trial,1)~=mixtr(trial-1,1) || mixtr(trial,2) ~= mixtr(trial-1,2)
        %                 while practicePassed==0
        %                     FLAPpracticeAssessmentfb
        %                 end
        %             end
        %         end
        %         if practicePassed==2
        %             closescript=1;
        %             break
        %         end
        
        %         practicePassed=1;
        %% training type-specific staircases
        
        Orijit=JitList(thresh(mixtr(trial,1),mixtr(trial,2)));
        Tscat=0;
        
        %% generate answer for this trial (training type 3 has no button response)
        
        theans(trial)=randi(2);
       %         theans(trial)=1;
CIstimuliModII % add the offset/polarity repulsion
        
        %% target location calculation
        theeccentricity_Y=0;
        theeccentricity_X=LocX(mixtr(trial,2))*pix_deg;
        eccentricity_X(trial)= theeccentricity_X;
        eccentricity_Y(trial) =theeccentricity_Y ;
        
        if trial==length(mixtr)
            endExp=GetSecs; %time at the end of the session
        end
        % -------------------------------------------------------------------------
        if demo==1
            if mod(trial,60)==0 %|| trial== length(mixtr)/4 || trial== length(mixtr)/4
                interblock_instruction
            end
            
        end
        % -------------------------------------------------------------------------
        
        if trial==1
            InstructionCIAssessment
        elseif trial>1
            if mixtr(trial,1)~=mixtr(trial-1,1) || mixtr(trial,2) ~= mixtr(trial-1,2)
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
        %   stimulusduration=2;
        
        if responsebox==1
            Bpress=0;
            timestamp=-1;
            TheButtons=-1;
            inter_buttonpress{1}=[]; % added by Jason because matlab was throwing and error
            % saying that inter_buttonpress was not assigned.
            % 26 June 2018
            RespTime=[];
            binaryvals=[];
            bin_buttonpress{1}=[]; % Jerry:use array instead of cell
            inter_timestamp{1}=[]; % JERRY: NEVER USED, DO NOT UNDERSTAND WHAT IT STANDS FOR
            %
            % Datapixx('RegWrRd');
            % buttonLogStatus = Datapixx('GetDinStatus');
            
            % if buttonLogStatus.logRunning~=1 % initialize digital input log if not up already.
            %     Datapixx('SetDinLog'); %added by Jerry
            %     Datapixx('StartDinLog');
            %     Datapixx('RegWrRd');
            %     buttonLogStatus = Datapixx('GetDinStatus');
            %     Datapixx('RegWrRd');
            % end
            % if ~exist('starttime','var') % var added by Jason
            %     Datapixx('RegWrRd');
            %     starttime=Datapixx('GetTime');
            % elseif  isempty(starttime)  % modified by Jerry from else to elseif
            %     Datapixx('RegWrRd');
            %     starttime=Datapixx('GetTime');
            % end
            
            % Configure digital input system for monitoring button box
            Datapixx('SetDinDataDirection', hex2dec('1F0000'));     % Drive 5 button lights
            Datapixx('EnableDinDebounce');                          % Debounce button presses
            Datapixx('SetDinLog');                                  % Log button presses to default address
            Datapixx('StartDinLog');                                % Turn on logging
            Datapixx('RegWrRd');
            % Wait until all buttons are up
            while (bitand(Datapixx('GetDinValues'), hex2dec('FFFF')) ~= hex2dec('FFFF'))
                Datapixx('RegWrRd');
            end
            % Flush any past button presses
            Datapixx('SetDinLog');
            Datapixx('RegWrRd');
        end
        
        while eyechecked<1
            if datapixxtime==1
                eyetime2=Datapixx('GetTime');
            end
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            fixationscriptW % visual aids on screen
%             fixating=1500;
            currentExoEndoCueDuration=ExoEndoCueDuration(1);
            
            %% here is where the first time-based trial loop starts (until first forced fixation is satisfied)
            if (eyetime2-pretrial_time)>=ITI  && fixating<fixationduration/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                if exist('startrial') == 0
                    startrial=1;
                    trialstart(trial)=GetSecs;
                    trialstart_frame(trial)=eyetime2;
                end
                [fixating, counter, framecounter] = IsFixatingSquareNew(wRect,xeye,yeye,fixating,framecounter,counter,fixwindowPix);
                if exist('starfix') == 0
                    if datapixxtime==1
                        startfix(trial)=Datapixx('GetTime');
                    else
                        startfix(trial)=eyetime2;
                    end
                end
                Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
            elseif (eyetime2-pretrial_time)>ITI && fixating>=fixationduration/ifi && stopchecking>1 && fixating<1000  && (eyetime2-pretrial_time)<=trialTimeout %&& keyCode(escapeKey) ==0 && counterflicker<FlickerTime/ifi
                % here I need to reset the trial time in order to preserve
                % timing for the next events (first fixed fixation event)
                % HERE interval between cue disappearance and beginning of
                % next stream of flickering stimuli
                if datapixxtime==1
                    trial_time = Datapixx('GetTime');
                else
                    trial_time = GetSecs;
                end
                if EyetrackerType ==2
                    Datapixx('SetMarker');
                    Datapixx('RegWrVideoSync');
                    %collect marker data
                    Datapixx('RegWrRd');
                    Pixxstruct(trial).TrialOnset = Datapixx('GetMarker');
                end
                fixating = 1500;
            end
            %% here is where the second time-based trial loop starts
            if (eyetime2-trial_time)>=postfixationblank && (eyetime2-trial_time)< postfixationblank+stimulusduration && fixating>400 && (eyetime2-pretrial_time)<=trialTimeout && stopchecking>1 %present pre-stimulus and stimulus  && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0
                % HERE I PRESENT THE TARGET
                if exist('imageRect_offsCI')==0    % destination rectangle for CI stimuli
                    imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(trial),...
                        imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(trial)];
                    imageRect_offsCI2=imageRect_offsCI;
                    %                         imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                    imageRectMask = CenterRect([0, 0,  CIstimulussize+maskthickness CIstimulussize+maskthickness], wRect);
                    imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
                        imageRectMask(3)+eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];
                end
                %here I draw the target contour
                Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
                imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
                if demo==0
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], 0.7 );
                end
                % here I draw the circle within which I show the contour target
                %                     if trial>4
                Screen('FrameOval', w,[gray], imageRect_offsCImask, maskthickness/2, maskthickness/2);
                Screen('FrameOval', w,gray, imageRect_offsCImask, 22, 22);
                %                     end
                if skipmasking==0
                    assignedPRLpatch
                end
                imagearray{trial}=Screen('GetImage', w);
                
                if exist('stimstar')==0
                    %                     stim_start = GetSecs;
                    stim_start_frame=eyetime2;
                    if responsebox==1
                        Datapixx('SetMarker');
                        Datapixx('RegWrVideoSync');
                        %collect marker data
                        Datapixx('RegWrRd');
                        stim_startBox2(trial)= Datapixx('GetMarker');
                        stim_startBox(trial)=Datapixx('GetTime');
                    end
                    stimstar=1;
                end
            elseif (eyetime2-trial_time)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && (eyetime2-pretrial_time)<=trialTimeout && stopchecking>1 %present pre-stimulus and stimulus
                
                if responsebox==0
                    if    keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0
                        thekeys = find(keyCode);
                        if length(thekeys)>1
                            thekeys=thekeys(1);
                        end
                        thetimes=keyCode(thekeys);
                        [secs  indfirst]=min(thetimes);
                        respTime=GetSecs;
                        eyechecked=10^4; % exit loop for this trial
                    end
                elseif responsebox==1
                    if (buttonLogStatus.newLogFrames > 0)
                        respTime(trial)=secs;
                        eyechecked=10^4;
                    end
                end
            elseif (eyetime2-trial_time)>=postfixationblank+stimulusduration && fixating>400 && (eyetime2-pretrial_time)<=trialTimeout && stopchecking>1 %present pre-stimulus and stimulus
                if responsebox==0
                    if    keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0
                        thekeys = find(keyCode);
                        if length(thekeys)>1
                            thekeys=thekeys(1);
                        end
                        thetimes=keyCode(thekeys);
                        [secs  indfirst]=min(thetimes);
                        respTime=GetSecs;
                        eyechecked=10^4; % exit loop for this trial
                    end
                elseif responsebox==1
                    if (buttonLogStatus.newLogFrames > 0)
                        respTime(trial)=secs;
                        eyechecked=10^4;
                    end
                end
            elseif (eyetime2-pretrial_time)>=trialTimeout
                stim_stop=GetSecs;
                trialTimedout(trial)=1;
                %    [secs  indfirst]=min(thetimes);
                if responsebox==1
                    Datapixx('StopDinLog');
                end
                eyechecked=10^4; % exit loop for this trial
            end
            %% here I draw the scotoma, elements below are called every frame
            eyefixation5
            if ScotomaPresent == 1 % do we want the scotoma? (default is yes)
                Screen('FillOval', w, scotoma_color, scotoma);
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
            if datapixxtime==1
                [eyetime3, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
                VBL_Timestamp=[VBL_Timestamp eyetime3];
            else
                [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
                VBL_Timestamp=[VBL_Timestamp eyetime2];
            end
            %% process eyedata in real time (fixation/saccades)
            if EyeTracker==1
                if EyetrackerType==1
                    GetEyeTrackerData
                elseif EyetrackerType==2
                    GetEyeTrackerDatapixx
                end
                GetFixationDecision
                if EyeData(end,1)<8000 && stopchecking<0
                    trial_time = GetSecs; %start timer if we have eye info
                    stopchecking=10;
                end
                if EyeData(end,1)>8000 && stopchecking<0 && (eyetime2-pretrial_time)>calibrationtolerance
                    trialTimeout=100000;
                    caliblock=1;
                    DrawFormattedText(w, 'Need calibration', 'center', 'center', white);
                    Screen('Flip', w);
                    %   KbQueueWait;
                    if responsebox==0
                        if  sum(keyCode)~=0
                            thekeys = find(keyCode);
                            if  thekeys==escapeKey
                                DrawFormattedText(w, 'Bye', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                %  KbQueueWait;
                                closescript = 1;
                                eyechecked=10^4;
                            elseif thekeys==RespType(5)
                                DrawFormattedText(w, 'continue', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                %  KbQueueWait;
                                % trial=trial-1;
                                eyechecked=10^4;
                            elseif thekeys==RespType(6)
                                DrawFormattedText(w, 'Calibration!', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                TPxReCalibrationTestingMM(1,screenNumber, baseName)
                                %    KbQueueWait;
                                eyechecked=10^4;
                            end
                        end
                    elseif responsebox==1
                        if  thekeys==escapeKey
                            DrawFormattedText(w, 'Bye', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            %  KbQueueWait;
                            closescript = 1;
                            eyechecked=10^4;
                        elseif thekeys==RespType(5)
                            DrawFormattedText(w, 'continue', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            %  KbQueueWait;
                            % trial=trial-1;
                            eyechecked=10^4;
                        elseif thekeys==RespType(6)
                            DrawFormattedText(w, 'Calibration!', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            TPxReCalibrationTestingMM(1,screenNumber, baseName)
                            %    KbQueueWait;
                            eyechecked=10^4;
                        end
                    end
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
            else
                if stopchecking<0
                    trial_time = eyetime2; %start timer if we have eye info
                    stopchecking=10;
                end
            end
            
            if responsebox==1 % DATApixx AYS 5/4/23 I added some documentation for WaitForEvent_Jerry - let me know if you have questions.
                %  [Bpress, RespTime, TheButtons] = WaitForEvent_Jerry(0, TargList);
                Datapixx('RegWrRd');
                buttonLogStatus = Datapixx('GetDinStatus');
                if (buttonLogStatus.newLogFrames > 0)
                    [thekeys secs] = Datapixx('ReadDinLog');
                end
                %         [keyIsDown, keyCode] = KbQueueCheck;
            else % AYS: UCR and UAB?
                [keyIsDown, keyCode] = KbQueueCheck;
            end
        end
        %% response processing
        if trialTimedout(trial)== 0
            foo=(RespType==thekeys);
            % staircase update
            staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
            Threshlist{mixtr(trial,1),mixtr(trial,2)}(staircounter(mixtr(trial,1),mixtr(trial,2)))=Orijit;
            if foo(theans(trial)) % if correct response
                resp = 1;
                PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                PsychPortAudio('Start', pahandle);
                corrcounter(mixtr(trial,1),mixtr(trial,2))=corrcounter(mixtr(trial,1),mixtr(trial,2))+1;
                if reversals(mixtr(trial,1),mixtr(trial,2))<2
                    sc.down=sc.steps(1);
                elseif reversals(mixtr(trial,1),mixtr(trial,2))>= 2
                    sc.down=sc.steps(2);
                end
                if corrcounter(mixtr(trial,1),mixtr(trial,2))==sc.down && staircounter(mixtr(trial,1),mixtr(trial,2))>sc.down
                    isreversals(mixtr(trial,1),mixtr(trial,2)) = isreversals(mixtr(trial,1),mixtr(trial,2)) + 1;
                end
                if corrcounter(mixtr(trial,1),mixtr(trial,2))==sc.down %&& reversalsVA(mixtrVA(trial))>= 2
                    % non streaking after 3 reversals
                    if isreversals(mixtr(trial,1),mixtr(trial,2))==1 %&& ThreshlistVA(staircounterVA(mixtrVA(trial-sc.down)))<ThreshlistVA(staircounterVA(mixtrVA(trial)))
                        if resetcounter(mixtr(trial))==0
                            reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
                            resetcounter(mixtr(trial))=1;
                            rever(trial)=1;
                        end
                        isreversals(mixtr(trial,1),mixtr(trial,2))=0;
                    end
                    thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                    if thestep>length(stepsizes)
                        thestep=length(stepsizes);
                    end
                    corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
                    thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) +stepsizes(thestep);
                end
                thresh(mixtr(trial,1),mixtr(trial,2))=min(thresh(mixtr(trial,1),mixtr(trial,2)),length(JitList));
                
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                ListenChar(0);
                break;
            else
                resp = 0; % if wrong response
                nswr(trial) = 0;
                PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                PsychPortAudio('Start', pahandle);
                resetcounter(mixtr(trial)) = 0;
                if reversals(mixtr(trial,1),mixtr(trial,2)) < 2
                    sc.down = sc.steps(1);
                elseif reversals(mixtr(trial,1),mixtr(trial,2)) >= 2
                    sc.down = sc.steps(2);
                end
                %  WE DON'T CARE ABOUT UPWARD REVERSALS, but we update 'isreversals' to update staircase
                if  corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                    isreversals(mixtr(trial,1),mixtr(trial,2))=1;
                end
                corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
                % we don't want the step size to change on a wrong response
                thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
                thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)));
                if thresh(mixtr(trial,1),mixtr(trial,2))<1
                    thresh(mixtr(trial,1),mixtr(trial,2))=1;
                end
            end
            %                 if AssessmentType~=3
            %                     if  corrcounter(mixtr(trial,1),mixtr(trial,2))==sc.down && reversals(mixtr(trial,1),mixtr(trial,2)) >= 3
            %                         isreversals(mixtr(trial,1),mixtr(trial,2))=1;
            %                         reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
            %                     else
            %                         if reversals(mixtr(trial,1),mixtr(trial,2)) < 3
            %                             isreversals(mixtr(trial,1),mixtr(trial,2))=1;
            %                             reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
            %                         end
            %                     end
            %                     corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
            %                     thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
            %                 end
            %                 if AssessmentType==1
            %                     if contr>SFthreshmax && currentsf>1
            %                         currentsf=max(currentsf-1,1);
            %                         thresh(:,:)=StartCont+SFadjust;
            %                         corrcounter(:,:)=0;
            %                         thestep=3;
            %                     else
            %                         thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
            %                         thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)),1);
            %                     end
            %                 end
            %                 if AssessmentType==2
            %                     thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
            %                     thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)),1);
            %                 end
            %             end
        else
            resp = 0;
            respTime(trial)=0;
            PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
            PsychPortAudio('Start', pahandle);
            if reversals(mixtr(trial,1),mixtr(trial,2))<2
                sc.down=sc.steps(1);
            elseif reversals(mixtr(trial,1),mixtr(trial,2))>= 2
                sc.down=sc.steps(2);
            end
            nswr(trial) = 0;
            staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
            Threshlist{mixtr(trial,1),mixtr(trial,2)}(staircounter(mixtr(trial,1),mixtr(trial,2)))=Orijit;
            resetcounter(mixtr(trial))=0;
            if reversals(mixtr(trial,1),mixtr(trial,2))<2
                sc.down=sc.steps(1);
            elseif reversals(mixtr(trial,1),mixtr(trial,2))>= 2
                sc.down=sc.steps(2);
            end
            %  WE DON'T CARE ABOUT UPWARD REVERSALS, but we update 'isreversals' to update staircase
            if  corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                isreversals(mixtr(trial,1),mixtr(trial,2))=1;
            end
            
            corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
            % we don't want the step size to change on a wrong response
            thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
            thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
            thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)));
            if thresh(mixtr(trial,1),mixtr(trial,2))<1
                thresh(mixtr(trial,1),mixtr(trial,2))=1;
            end
        end
        if trialTimedout(trial)==0
            stim_stop=secs;
            cheis(kk)=thekeys;
        end
        if exist('stimstar')==0
            stim_start(trial)=0;
            stimnotshowed(trial)=99;
        end
        %         time_stim(kk) = stim_stop - stim_start;
        rispo(kk)=resp;
        respTimes(trial)=respTime(trial);
        %         cueendToResp(kk)=stim_stop-cue_last;
        %         cuebeginningToResp(kk)=stim_stop-circle_start;
        %         if AssessmentType > 2 % if it's a
        %             %   training type with flicker
        %             %   fixDuration(trial)=flicker_time_start-trial_time;
        %             if flickerdone>1
        %                 flickertimetrial(trial)=FlickerTime; %  nominal duration of flicker
        %                 movieDuration(trial)=flicker_time_stop(trial)-flicker_time_start(trial); % actual duration of flicker
        %                 Timeperformance(trial)=movieDuration(trial)-(flickertimetrial(trial)*3); % estimated difference between actual and expected flicker duration
        %                 unadjustedTimeperformance(trial)=movieDuration(trial)-flickertimetrial(trial);
        %             end
        %         end
        % -----------------------------------------------------------------------------------
        
        trackthresh(shapesoftheDay(mixtr,1))=thresh(mixtr,1);
        %             threshperday(expDay,:)=trackthresh;
        
        % -----------------------------------------------------------------------------------
        if (mod(trial,150))==1 && trial>1
            save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
        end
        %         if (mod(trial,10))==1 && trial>1 && AssessmentType==3
        %             updatecounter=updatecounter+1;
        %             %some adaptive measures for the TRL size that counts as 'fixation within the TRL'
        %             if mean(unadjustedTimeperformance(end-9:end))>8
        %                 if mod(updatecounter,2)==0
        %                     %here we implement staircase on flicker time
        %                     flickerpointerPre=flickerpointerPre-1;
        %                     flickerpointerPost=flickerpointerPost+1;
        %                 else
        %                     sizepointer=sizepointer-1; % increase the size of the TRL region within which the target will be deemed as 'seen through the TRL'
        %                 end
        %             elseif mean(unadjustedTimeperformance(end-9:end))<5
        %                 if mod(updatecounter,2)==0
        %                     %here we implement staircase on flicker time
        %                     flickerpointerPre=flickerpointerPre+1;
        %                     flickerpointerPost=flickerpointerPost-1;
        %                 else
        %                     sizepointer=sizepointer+1; % decrease the size of the TRL region within which the target will be deemed as 'seen through the TRL'
        %                 end
        %             end
        %             timeflickerallowed=persistentflickerArray(flickerpointerPre); % time before flicker starts
        %             flickerpersistallowed=persistentflickerArray(flickerpointerPost); % time away from flicker in which flicker persis
        %             coeffAdj=sizeArray(sizepointer);
        %         end
        
        TRLsize(trial)=coeffAdj;
        flickOne(trial)=timeflickerallowed;
        flickTwo(trial)=flickerpersistallowed;
        
        if responsebox==1 && trialTimedout(trial)==0
            time_stim(kk) = respTime(trial) - stim_startBox2(trial);
            time_stim2(kk) = respTime(trial) - stim_startBox(trial);
        else
            time_stim(kk) = respTime(trial) - stim_start(trial);
        end
        totale_trials(kk)=trial;
        coordinate(trial).x=theeccentricity_X/pix_deg;
        coordinate(trial).y=theeccentricity_Y/pix_deg;
        xxeye(trial).ics=xeye;
        yyeye(trial).ipsi=yeye;
        vbltimestamp(trial).ix=VBL_Timestamp;
        if exist('ssf')
            feat(kk)=ssf;
        end
        SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
        rectimage{kk}=imageRect_offs;
        if exist('endExp')
            totalduration=(endExp-startExp)/60;
        end
        OriCI(kk)=Orijit;
        
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
            EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;
            clear ErrorInfo
        end
        if closescript==1
            break;
        end
        kk=kk+1;
        if trialcounter>11 && mixtr(trial,2) == mixtr(trial-1,2)
            if mod(checkcounter,10) == 0 && sum(Threshlist{mixtr(trial,1),mixtr(trial,2)}(staircounter(mixtr(trial,1),mixtr(trial,2)))-10:Threshlist{mixtr(trial,1),mixtr(trial,2)}(staircounter(mixtr(trial,1),mixtr(trial,2))))==0
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