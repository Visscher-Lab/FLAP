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
    prompt={'Participant Name', 'day','site? UCR(1), UAB(2), Vpixx(3)', 'Practice (0) or Session(1)', 'Eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Scotoma? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '3', '1' , '2', '0', '1', '0'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    penalizeLookaway=0;   %mostly for debugging, we can remove the masking on the target when assigned PRL ring is out of range
    expDay=str2num(answer{2,:}); % training day (if >1
    site = str2num(answer{3,:}); % training site (UAB vs UCR vs Vpixx)
    demo=str2num(answer{4,:}); % practice
    whicheye=str2num(answer{5,:}); % are we tracking left (1) or right (2) eye? Only for Vpixx
    calibration=str2num(answer{6,:}); % do we want to calibrate or do we skip it? only for Vpixx
    ScotomaPresent = str2num(answer{7,:}); % 0 = no scotoma, 1 = scotoma
    EyeTracker = str2num(answer{8,:}); %0=mouse, 1=eyetracker
    TRLlocation = 2;
    
    %create a data folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    baseName=['./data/' SUBJECT '_FLAPScannertask' answer{2,:} '_' TimeStart]; %makes unique filename
    
    defineSite % initialize Screen function and features depending on OS/Monitor
    
    CommonParametersScanner % define common parameters
    
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
    
    % Gabor stimuli
    createGabors
    % CI stimuli
    CIShapesIII
    
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
    theoris =[-45 45];
    contr=0.5;
    shapes=2; % how many shapes per day?
    conditionOne=2; %Gabors + shapes
    conditionTwo=1; %location of the target
    conditionThree=shapes;
    %define number of trials per condition
    condmat= fullfact([conditionOne conditionTwo conditionThree ]);
    condmat=condmat(~(condmat(:,1)==1 & condmat(:,3)==2),:);
    condmat=[condmat(1,:); condmat];
    runs=6;
    blocks=4;
    trials=16;
    if demo==0
        runs=1;
        blocks=1;
        trials=1;
    end
    
    mixtr= []; % 1: gabor of shapes; 2: target location (left vs right), 3: shape type (6/9 or eggs)
    possiblerest=[trials trials*2
        trials trials*3
        trials*2  trials*3];
    for iii=1:runs % for each run
        %randomize blocks within run
        randorer=condmat(randperm(length(condmat)),:);
        for ui=1:length(condmat)           % for each block
            added=repmat(randorer(ui,:), trials,1);
            pointer=(randperm(length(added)));
            replacers=pointer(1:length(pointer)/2); % add other location in random order in half of the trial per block
            added(replacers,2)=2;
            mixtr=[mixtr; added];
            % insert random rest
        end
        clear randorder
whenrest(iii,:)=possiblerest(randi(3),:);
    end
    
    demotrial=5
    mixtr = [ ones(demotrial,1)*2 ones(demotrial,1) ones(demotrial,1)]
    
    theSF=4;   
    fase=randi(4);
    texture=TheGabors(theSF, fase);
    Orijit=0;
    Tscat=0;
    shapeMat(:,1)= [9 1];
    
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
    
    for io=1:runs
       blockstart(io)=io*trials; 
    end
    %% HERE starts trial loop
    resetcounter(1:2) = 1;
    for trial=1:length(mixtr)
               AssessmentType=mixtr(trial,1);
%blocks

               %% generate answer for this trial (training type 3 has no button response)
        theans(trial)=randi(2);
                  theothershape(trial)=randi(2);
  if AssessmentType==1
            ori=theoris(theans(trial));
            ori2=theoris(theothershape(trial));
        elseif AssessmentType==2
            CIstimuliModII % add the offset/polarity repulsion
        end
        if trial==1
            %   InstructionFLAPAssessment(w,AssessmentType,gray,white)
            if AssessmentType == 1
                Instruction_Contrast_Assessment
            elseif AssessmentType==2
                InstructionCIAssessment
            end
        elseif trial > 1 && (mixtr(trial,1)~= mixtr(trial,1) || mixtr(trial,3)~= mixtr(trial,3) )
            if trial==1 || mixtr(trial,1)~= mixtr(trial,1)
                %     InstructionFLAPAssessment(w,AssessmentType,gray,white)
                if AssessmentType == 1
                    Instruction_Contrast_Assessment
                elseif AssessmentType==2
                    InstructionCIAssessment
                end
            end
        end
        

        %% target location calculation
        theeccentricity_Y=0;
        theeccentricity_X=LocX(mixtr(trial,2))*pix_deg;
        eccentricity_X(trial)= theeccentricity_X;
        eccentricity_Y(trial) =theeccentricity_Y ;
        
        if trial==length(mixtr)
            endExp=GetSecs; %time at the end of the session
        end
               
        %  destination rectangle for the target stimulus
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
        
        %  destination rectangle for the other stimulus
        imageRect_offs2 =[imageRect(1)-theeccentricity_X, imageRect(2)-theeccentricity_Y,...
            imageRect(3)-theeccentricity_X, imageRect(4)-theeccentricity_Y];
        
%         %  destination rectangle for the fixation dot
%         imageRect_offs_dot=[imageRectDot(1)+theeccentricity_X, imageRectDot(2)+theeccentricity_Y,...
%             imageRectDot(3)+theeccentricity_X, imageRectDot(4)+theeccentricity_Y];
        
        %% Initialization/reset of several trial-based variables
        FLAPVariablesReset % reset some variables used in each trial
        if trial==1
            startExp=GetSecs; %time at the beginning of the session
        end
        stimulusduration=2;
        playsound=0;
        while eyechecked<1
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
                fixationscriptW % visual aids on screen
            fixating=1500;
            
            %% here is where the first time-based trial loop starts (until first forced fixation is satisfied)
            if (eyetime2-trial_time)>=ifi*2 && (eyetime2-trial_time)<ifi*2+preCueISI && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                % pre-event empty space, allows for some cleaning
                if AssessmentType==1 || AssessmentType==2 % no flicker type of training trial
                    counterflicker=-10000;
                end
                
            elseif (eyetime2-trial_time)>=ifi*2+preCueISI && (eyetime2-trial_time)<+ifi*2+preCueISI+CueDuration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                if exist('startrial') == 0
                    startrial=1;
                    trialstart(trial)=GetSecs;
                    trialstart_frame(trial)=eyetime2;
                end
                % HERE I present the acoustic cue 
                if mixtr(trial,2)==1
                    PsychPortAudio('FillBuffer', pahandle, bip_sound_left' ); % loads data into buffer
                elseif mixtr(trial,2)==2
                    PsychPortAudio('FillBuffer', pahandle, bip_sound_right' ); % loads data into buffer
                    
                end
                if playsound==0
                PsychPortAudio('Start', pahandle);
                playsound=1;
                end
            elseif (eyetime2-trial_time)>=ifi*2+preCueISI+CueDuration+postCueISI && fixating>400 && stopchecking>1 && flickerdone<1 && counterannulus<=AnnulusTime/ifi  && keyCode(escapeKey) ==0 && (eyetime2-pretrial_time)<=trialTimeout %&& counterflicker<FlickerTime/ifi
                % here I need to reset the trial time in order to preserve
                % timing for the next events (first fixed fixation event)
                % HERE interval between cue disappearance and beginning of
                % next stream of flickering stimuli
                if skipforcedfixation==1 % skip the forced fixation
                    counterannulus=(AnnulusTime/ifi)+1;
                    skipcounterannulus=1000;
                else %force fixation for training types 1 and 2
                    [counterannulus framecounter ]=  IsFixatingSquareNew2(wRect,newsamplex,newsampley,framecounter,counterannulus,fixwindowPix);
                %    Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                    
                    
                    if counterannulus==round(AnnulusTime/ifi) % when I have enough frame to satisfy the fixation requirements
                        newtrialtime=GetSecs;
                        skipcounterannulus=1000;
                    end
                end
            elseif (eyetime2-trial_time)>=ifi*2+preCueISI+CueDuration+postCueISI && fixating>400 && stopchecking>1 && counterannulus<AnnulusTime/ifi && flickerdone<1  && keyCode(escapeKey) ~=0 && (eyetime2-pretrial_time)<=trialTimeout %&& counterflicker<FlickerTime/ifi
                % HERE I exit the script if I press ESC
                thekeys = find(keyCode);
                closescript=1;
                break;
            end
            %% here is where the second time-based trial loop starts
            if (eyetime2-newtrialtime)>=forcedfixationISI && fixating>400 && stopchecking>1 && skipcounterannulus>10  && flickerdone<1 && (eyetime2-pretrial_time)<=trialTimeout %&& counterflicker<=FlickerTime/ifi
                % HERE starts the flicker for training types 3 and 4, if
                % training type is 1 or 2, this is skipped
                
                if exist('circlestar')==0
                    circle_start = GetSecs;
                    circlestar=1;
                end
                cue_last=GetSecs;
                
                newtrialtime=GetSecs; % when fixation constrains are satisfied, I reset the timer to move to the next series of events
                flickerdone=10;
                flicker_time_stop(trial)=eyetime2; % end of the overall flickering period
            elseif (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0 && stopchecking>1 %present pre-stimulus and stimulus
                % HERE I PRESENT THE TARGET
                
                if AssessmentType==3
                    eyechecked=10^4; % if it's training type 3, we exit the trial, good job
                    
                elseif AssessmentType==1
                    Screen('DrawTexture', w, texture, [], imageRect_offs, ori,[], contr );
                    Screen('DrawTexture', w, texture, [], imageRect_offs2, ori2,[], contr );
                    
                elseif AssessmentType==2
                    if exist('imageRect_offsCI')==0    % destination rectangle for CI stimuli
                        imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(trial),...
                            imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(trial)];
                        imageRect_offsCI2=imageRect_offsCI;
                        %                         imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                        imageRectMask = CenterRect([0, 0,  CIstimulussize+maskthickness CIstimulussize+maskthickness], wRect);
                        imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
                            imageRectMask(3)+eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];
                        
                        % other shapes
                         imageRect_offsCI3 =[imageRectSmall(1)+eccentricity_XCI'-eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(trial),...
                            imageRectSmall(3)+eccentricity_XCI'-eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(trial)];
                        imageRect_offsCI4=imageRect_offsCI3;
                        %                         imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                     %   imageRectMask2 = CenterRect([0, 0,  CIstimulussize+maskthickness CIstimulussize+maskthickness], wRect);
                        imageRect_offsCImask2=[imageRectMask(1)-eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
                            imageRectMask(3)-eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];                  
                    end
                    %here I draw the target contour
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
                    imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
                    if demo==0
                        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], 0.7 );
                    end
                    % here I draw the circle within which I show the contour target
                    Screen('FrameOval', w,[gray], imageRect_offsCImask, maskthickness/2, maskthickness/2);
                    Screen('FrameOval', w,gray, imageRect_offsCImask, 22, 22);
                    
                                     %here I draw the other contour
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI3' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori2,[], Dcontr );
                    imageRect_offsCI4(setdiff(1:length(imageRect_offsCI3),targetcord),:)=0;
                    if demo==0
                        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI4' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori2,[], 0.7 );
                    end
                    % here I draw the circle within which I show the contour target
                    Screen('FrameOval', w,[gray], imageRect_offsCImask2, maskthickness/2, maskthickness/2);
                    Screen('FrameOval', w,gray, imageRect_offsCImask2, 22, 22);
                 
                    imagearray{trial}=Screen('GetImage', w);
                    
                end
                if exist('stimstar')==0
                    stim_start = GetSecs;
                    stim_start_frame=eyetime2;
                    stimstar=1;
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
            [keyIsDown, keyCode] = KbQueueCheck;
        end
        %% response processing
        if trialTimedout(trial)== 0 && AssessmentType~=3
            foo=(RespType==thekeys);

            if foo(theans(trial)) % if correct response
                resp = 1;
                PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                PsychPortAudio('Start', pahandle);

           
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                ListenChar(0);
                break;
            else
                resp = 0; % if wrong response
                PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                PsychPortAudio('Start', pahandle);

            end

        else
            resp = 0;
            respTime=0;
            PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
            PsychPortAudio('Start', pahandle);

        end
        if AssessmentType~=3 % if the trial didn't time out, save some variables
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
        if AssessmentType==2
            trackthresh(shapesoftheDay(mixtr,1))=thresh(mixtr,1);
            %             threshperday(expDay,:)=trackthresh;
        end
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
        totale_trials(kk)=trial;
        coordinate(trial).x=theeccentricity_X/pix_deg;
        coordinate(trial).y=theeccentricity_Y/pix_deg;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];
        
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
            if AssessmentType~=3
                EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;
            end
            clear ErrorInfo
        end
        if closescript==1
            break;
        end
        kk=kk+1;

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