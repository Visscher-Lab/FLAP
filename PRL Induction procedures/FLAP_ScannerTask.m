% FLAP Scanner task
% written by Marcello A. Maniglia April 2023 %2017/2021
% This script runs 6 runs of 4 blocks each (16 trials per block) of an
% orientation discrimination and cvontour integration task (2 blocks of
% each per run). It collects correct vs wrong responses and RT for fixed
% values of contrast and CI jitter

%Glossary of variables to use for analyses
%ExpStartTimeP=first flip after the trigger in Psychtoolbox clock time
%ExpStarttimeD=first flip after the trigger in datapixx clock time
%TRwait is a 5x 16 matrix, blockwise for each trial.  Most of the code is written trialwise, with a single event for the %rest’ block.  So TRwait(trial) is giving the wrong value.

%Activeblocktype is 8 runsx5 blocks; used correctly.
%timestamp1=time of the trigger signal from the scanner in Datapixx clock time
%TrialStartTimeD=JitterEndTimeD=Trial start time in datapixx clock time
%AssessmentType= OD (1) vs CI (2)
%theans and theothershape is totally random -- this means that there may be
%   different numbers of trials with the unattended stimulus pointing left
%   vs. right (for example).  This is probably ok.
%totalduration= is the total amount of time from start of first trial, to the start of the last trial.  for one run it was 4.11 min
%During rest block, there is a text on the screen
%preCueISI=0.200, CueDuration=0.250, postCueISI=0.500, stimulusduration=0.200
%TheGabors(spat_freq, fase)  spatial frequency is set to 4, fase is random between 1-4
%TrialEndTimeD=Timestamp for trial ends in Datapixx clock
% we didn't save finish_time varible which is experiment finish time in datapixx clock
%rispo= ones and zeros indicating correct and incorrect responses respectively
%respTime=Response time in Psychtoolbox clock, 0 for the rest block. It equals RespTime
%ReactionT=respTime-stim_start_frame(stim presentation) for each trial. NaN for misses.
%stim_start_frame=stimulus presentation time in Datapixx time
%trialstart_frame-trial start frame in Datapixx time
%In demo, it starts with 6 trials of gabor, then it shows 6 trials of egg
%then 15 sec rest then 6 trials of 6/9, then 6 trials of gabor stimuli. It
%works fine with site=6, it waits for t to start and response keys were
%r(left)and y (right)

close all; clear; clc;
commandwindow


% which run
% pre vs post

addpath([cd '/utilities']); %add folder with utilities files
try
    prompt={'Participant Name', 'Pre (1) vs Post (2)','site? Vpixx(3), UCRScanner (5), UABScanner (6), ScannerTaskDemo (7)', 'Practice (0) or Session(1)', 'Eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Scotoma? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?', 'response box (1) or keyboard (0)', 'which run?(1-6)' };

    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '6', '1' , '2', '0', '0', '0', '0', '1'};
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
    responsebox= str2num(answer{9,:}); %PD:1=response box, 0=keyboard
    whichRun=str2num(answer{10,:}); %PD:which run you're scanning
    if site==5  %PD added this if statement 8/15/23
        datapixxtime=1;
    elseif site ==6 || site==7
        datapixxtime=0;
    end
    gazecontingent=ScotomaPresent;
    %create a data folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    if expDay==1
        prevspost= 'Pre';
    elseif expDay==2
        prevspost= 'Post';
    end
    eyetrack_fname=SUBJECT;
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    if demo==0
        baseName=['./data/' SUBJECT '_FLAPScannertaskDEMO ' prevspost '_' TimeStart]; %makes unique filename
    else
        baseName=['./data/' SUBJECT '_FLAPScannertask ' prevspost '_' TimeStart]; %makes unique filename
    end

    defineSite % initialize Screen function and features depending on OS/Monitor
    CommonParametersScanner % define common parameters
    %% eyetracker initialization (eyelink)
    if EyeTracker==1
        if site==3 || site==5
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
    CIShapesIV
    % audio params for DATAPixx audio, AYS 4/29/23
    %    fs=44100;

    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    elseif EyetrackerType==2 || (EyetrackerType==0 && site ==5) %added by AS 4-28-23, you can put into a script if you wish
        %        if Calibrate
        %             %CalibrateTracker; %obsolete
        %             TPxTrackpixx3CalibrationTesting;
        %             Calibrate=0;
        %         end
        %% TO START EYE TRACKING DATA:
        dpx_isReady = Datapixx('IsReady');
        if site == 5 %&& (~dpx_isReady)
            Datapixx('Open');
            audioGrpDelay=Datapixx('GetAudioGroupDelay',Fs);
            audioDelay=FlipInt-audioGrpDelay;
            Datapixx('StopAllSchedules');
            Datapixx('InitAudio');
            Datapixx('SetAudioVolume', [1,1]);
            Datapixx('SetDinLog');
            Datapixx('StartDinLog');
            Datapixx('EnableDinDebounce');
            Datapixx('RegWrRd');
            Screen('Preference', 'SkipSyncTests', 1);
        end
        Datapixx('SetupTPxSchedule');
        Datapixx('RegWrRd');
        Datapixx('StartTPxSchedule');
        Datapixx('RegWrRdVideoSync'); % put VideoSync here, so that the eye tracking sync with the flipping
        EyeTrack_StartTime=Datapixx('GetTime');
    end
    %% Trial matrix definition
    trials=16;
    %     if demo==0
    %           runs=1;
    %          blocks=1;
    %         trials=1;
    %         demotrial=5;
    %         mixtr = [ ones(demotrial,1)*2 ones(demotrial,1) ones(demotrial,1)];
    %     end

    mixtr= []; % 1: gabor of shapes; 2: target location (left vs right), 3: shape type (6/9 or eggs)
    %mixtr 1: assessment type gabor (1) vs CI (2)
    %mixtr 2: stimulus location left (1) vs right (2)
    %mixtr 3: shape type (only for CI), Eggs (1) vs 6/9 (2)

    condtr=activeblocktype(whichRun,:);%order of the block types, 1=gabor, 2=egg, 3=6/9, 4=rest
    [eggordercol]=find(condtr==2);% PD added these to determine order of the active blocks to give sound information about the next block
    [pdordercol]=find(condtr==3);
    [gaborordercol]=find(condtr==1);
    possiblecond=[1 1;% PD: I don't know why we don't have 1 2 condition?
        2 1;
        2 2;
        9 9];
    mixtr =[];
    sidecolumn= [];
    for ui=1:length(condtr)
        if possiblecond(condtr(ui))== 9 % PD: rest block. why we don't use condtr==4 instead?
            mixtr=[mixtr; repmat(possiblecond(condtr(ui),:),1,1)];
            sidecolumn=[sidecolumn; 9];
        else
            mixtr=[mixtr; repmat(possiblecond(condtr(ui),:),trials,1)];
            leftRight=[ones(trials/2,1);ones(trials/2,1)*2];
            leftRight=leftRight(randperm(length(leftRight))); % define the flicker time duration (movie duration) for this trial
            sidecolumn=[sidecolumn; leftRight];
            clear leftRight
        end
    end
    %1: gabor; 2: CI- Eggs, 3: CI-6/9, 4: rest
    mixtr = [mixtr(:,1) sidecolumn mixtr(:,2)];

    %mixtr2=[mixtr(:,3) mixtr(:,2) mixtr(:,1)]; %PD:We don't use mixtr2 to anywhere else. sam added it
    fase=randi(4);
    texture=TheGabors(spat_freq, fase);


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

    %% Get Trigger
    if site==5 %PD added if statement 8/15/23
        TargList=[1 3]; % red=1; green=3.
        TheTrigger = 11;
    elseif site==6 || site==7
        TheTrigger=false;
    end
    InstructionShapeScanner %PD created instructions page with shapes 8/15/23
    %soundsc(sin(1:.5:1000)); % PD addedd play 'ready' tone
    disp('Ready, waiting for trigger...');

    if site == 5
        [Bpress timestamp1]=WaitForEvent_Jerry(500, TheTrigger); % waits for trigger
        Datapixx('SetMarker');
        Datapixx('RegWrVideoSync'); % time sync
        ExpStartTimeP=Screen('Flip',w); %PTB-3
        Datapixx('RegWrRd');
        ExpStartTimeD=Datapixx('GetMarker');
        startTime=ExpStartTimeD;
    elseif site==6 || site==7
        while ~TheTrigger
            %[ keyIsDown, keyTime, keyCode ] = KbCheck;
            [keyIsDown, keyCode] = KbQueueCheck;
            TTL = find(keyCode, 1);
            if keyIsDown==1 && TTL==KbName('t')
                fixationscriptW
                ExpStartTimeP=Screen('Flip',w); %PTB-3
                startTime=GetSecs;
                clear keyIsDown keyCode
                TheTrigger=true;
            end
        end
    elseif site==7
        KbWait;
        startTime=GetSecs;
    end
    disp(['Trigger received - ' startTime]); %PD added this info for the MRI user
    %% Jitter/wait TR init AYS 4/28/23
    TR = 1.5; % TR dur in s
    TRrem = 1; % remainder TRs if uneven div CONFIRM TR REMAINDER
    TRwait=(interTrialIntervals{whichRun})';%Sam added this, it converts 5x16 matrix to 16x5.
    TRwait2=reshape(TRwait,[],1);%rehape 16x5 matrix to 80x1 matrix. PD added this to match TRwait with mixtr 8/17
    [restordercol]=find(condtr==4);%finds the rest block. PD added this to match TRwait with mixtr 8/17
    TRwait3(1:((restordercol-1)*trials)+1,:)=TRwait2(1:((restordercol-1)*trials)+1);%takes everything before the rest block. add 0 for the rest block(same cell is 9 in mixtr). PD added this to match TRwait with mixtr 8/17
    TRwait3(((restordercol-1)*trials)+2:((restordercol-1)*trials)+2+(5-restordercol)*15+(5-restordercol-1),:)=TRwait2((restordercol*trials)+1:end);%copy the TRwait after the rest block. PD added this to match TRwait with mixtr 8/17
    TRwait=TRwait3; %updates TR wait. PD added this to match TRwait with mixtr 8/17
    TRcount = 0;
    % Demo
    if demo==0 %PD added this part 8/15/23
        mixtr=[1,1,1;1,2,1;1,1,1;1,2,1;1,2,1;1,1,1;2,1,1;2,2,1;2,1,1;2,2,1;2,1,1;2,1,1;9,9,9;2,2,2;2,1,2;2,1,2;2,2,2;2,2,2;2,2,2;1,2,1;1,1,1;1,1,1;1,2,1;1,1,1;1,2,1];
    TRwait=ones(25,1);
    end
    %% HERE starts trial loop
    Bpress1=0;
    for trial=1:length(mixtr)
        %% jitter code @ trial loop start, AYS 4/28/23. See also jitter code @ trial loop end
        if site == 5
            Datapixx('RegWrRd');
            JitterStartTimeD(trial)=Datapixx('GetTime');
            TRpass=floor((JitterStartTimeD(trial)-ExpStartTimeD)/TR); % TRpass: time since Exp start (in TRs)

            if trial==1
                TRcount=TRcount+TRwait(trial);
            else
                TRcount=TRcount+TRwait(trial)-1;
            end

            while TRpass<TRcount %&& Bpress1==0 % wait until TRpass=TRcount, then
                [Bpress1 timestamp2]= WaitForEvent_Jerry(0, TheTrigger); % sync with next TR pulse
                Datapixx('RegWrRd');
                CurrentTimeD=Datapixx('GetTime');
                TRpass=round((CurrentTimeD-ExpStartTimeD)/TR);
            end
            if Bpress1>0
                Bpress1=0;
            end
            Datapixx('RegWrRd');
            JitterEndTimeD(trial)=Datapixx('GetTime');
            TrialStartTimeD(trial)=JitterEndTimeD(trial);
        elseif site==6 %PD added this part to count TRs 8/18/23
            kt(trial,1)=1;
            if trial==1 %PD:if it is first trial of the experiment wait for 1 TR long before the experiment start
                itiprevious=1;
                TimeToStopListening(trial,1)=startTime+((itiprevious-0.5)*TR);
                TrialStartTime(trial,1)=startTime+TR;
                PreviousCueTime=0;
            elseif mixtr(trial-1,1)==9 %PD: first trial after the rest block 8/18/23
                TimeToStopListening(trial,1)=TrialStartTime(trial-1,1)+RestDuration; %no time to listen
                TrialStartTime(trial,1)=TrialStartTime(trial-1,1)+RestDuration;
            elseif trial~=1 && mixtr(trial-1,1)~=9 %PD: when previous trial was not rest 8/18/23
                itiprevious=TRwait(trial-1,1);
                PreviousCueTime=CueOnsetTime(trial-1,1);
                if TRwait(trial-1,1)==0 %PD:if previous TRwait equals to 0 8/18/23
                    TimeToStopListening(trial,1)=PreviousCueTime+(2*TR); %no time to listen
                    TrialStartTime(trial,1)=PreviousCueTime+(2*TR);
                else %when the previous TRwait grater than 0 8/18/23
                    TimeToStopListening(trial,1)=PreviousCueTime+(2*TR)+((itiprevious-0.5)*TR);
                    TrialStartTime(trial,1)=PreviousCueTime+(2*TR)+(itiprevious*TR);
                end
            end
            fixationscriptW;
            clear keyIsDown keyCode
            while GetSecs < TimeToStopListening(trial,1) %PD: listening TTL Pulses during TRwait
                [keyIsDown, keyCode]=KbQueueCheck;
                if keyIsDown
                    key(k,1) = find(keyCode,1);
                    keypresstime(k,1)=GetSecs;
                    if key==KbName('t');
                        if k==1 && keypresstime(k,1)<startTime+TR
                        elseif k==1 && keypresstime(k,1)>startTime+TR
                            TTL_time(j)=keypresstime(k,1);
                            k=k+1;
                            j=j+1;
                            kt(trial,1)=k;
                        elseif keypresstime(k,1)-keypresstime(k-1,1)>.5
                            TTL_time(j)=keypresstime(k,1);
                            k=k+1;
                            j=j+1;
                            kt(trial,1)=k;
                        end
                    end
                end
            end
            if exist('TTL_time')
                clear keyIsDown keyCode
            end
            if trial>1 && mixtr(trial-1,1)==9 %PD: if the previous trial was rest
                if exist('TTL_timeforrest')
                    TrialStartTime(trial,1)=TTL_timeforrest(jr-1)+TR;
                end
            elseif kt(trial,1)>1 %PD:if TTL pulses were counted during TRwait
                TrialStartTime(trial,1)=TTL_time(j-1)+TR;
            end
            while GetSecs < TrialStartTime(trial,1)-0.001 %PD:leftover TRwait
            end
        end
        %% telling participant what type of the block they are going to have
        whichblock=GetSecs;
        if demo==0 %PD added audio information to demo 9/15/23
        if site ==7
            if trial==1 ||trial==20
            PsychPortAudio('FillBuffer',pahandle,gaborsound')
        elseif trial==7
            PsychPortAudio('FillBuffer',pahandle,eggsound')
elseif trial==13
            PsychPortAudio('FillBuffer',pahandle,restsound')
        elseif trial==14
            PsychPortAudio('FillBuffer',pahandle,dsound')
            end
             PsychPortAudio('Start',pahandle)
        end

        if site ==5
            if trial==1 ||trial==20
            Datapixx('WriteAudioBuffer', gaborsound', 0); % loads data into buffer
            Datapixx('RegWrRd'); %
            Datapixx('SetAudioSchedule',0,Fs,length(gaborsound'),1,0,length(gaborsound'));
            Datapixx('RegWrRd'); %
            Datapixx('StartAudioSchedule');
            Datapixx('RegWrRd'); %
        elseif trial==7
            Datapixx('WriteAudioBuffer', eggsound', 0); % loads data into buffer
            Datapixx('RegWrRd'); %
            Datapixx('SetAudioSchedule',0,Fs,length(eggsound'),1,0,length(eggsound'));
            Datapixx('RegWrRd'); %
            Datapixx('StartAudioSchedule');
            Datapixx('RegWrRd'); %
elseif trial==13
            Datapixx('WriteAudioBuffer', restsound', 0); % loads data into buffer
            Datapixx('RegWrRd'); %
            Datapixx('SetAudioSchedule',0,Fs,length(restsound'),1,0,length(restsound'));
            Datapixx('RegWrRd'); %
            Datapixx('StartAudioSchedule');
            Datapixx('RegWrRd'); %
        elseif trial==14
            Datapixx('WriteAudioBuffer', dsound', 0); % loads data into buffer
            Datapixx('RegWrRd'); %
            Datapixx('SetAudioSchedule',0,Fs,length(dsound'),1,0,length(dsound'));
            Datapixx('RegWrRd'); %
            Datapixx('StartAudioSchedule');
            Datapixx('RegWrRd'); %  
            end
        end
       
        while GetSecs < whichblock + TR
        end
        else
        if (trial==1 && eggordercol==1) || (trial==17 && eggordercol==2) || (trial==18 && eggordercol==3) || (trial==33 && eggordercol==3) || (trial==34 && eggordercol==4) || (trial==50 && eggordercol==5) || (trial==1 && pdordercol==1) || (trial==17 && pdordercol==2) || (trial==18 && pdordercol==3) || (trial==33 && pdordercol==3) || (trial==34 && pdordercol==4) || (trial==50 && pdordercol==5) || (trial==1 && gaborordercol(1)==1) || (trial==17 && gaborordercol(1)==2) || (trial==17 && gaborordercol(2)==2) || (trial==18 && gaborordercol(1)==3) || (trial==18 && gaborordercol(2)==3) || (trial==33 && gaborordercol(1)==3) || (trial==33 && gaborordercol(2)==3) || (trial==34 && gaborordercol(1)==4) || (trial==34 && gaborordercol(2)==4) || (trial==50 && gaborordercol(2)==5) || (trial==17 && restordercol==2) || (trial==33 && restordercol==3) || (trial==49 && restordercol==4)
            %while GetSecs < whichblock +TR
            if site == 5
                Datapixx('StartAudioSchedule');
                Datapixx('RegWrRd');
                if (trial==1 && eggordercol==1) || (trial==17 && eggordercol==2) || (trial==18 && eggordercol==3) || (trial==33 && eggordercol==3) || (trial==34 && eggordercol==4) || (trial==50 && eggordercol==5)
                    Datapixx('WriteAudioBuffer', eggsound', 0); % loads data into buffer
                    Datapixx('SetAudioSchedule',0,Fs,length(eggsound'),1,0,length(eggsound'));
                elseif (trial==1 && pdordercol==1) || (trial==17 && pdordercol==2) || (trial==18 && pdordercol==3) || (trial==33 && pdordercol==3) || (trial==34 && pdordercol==4) || (trial==50 && pdordercol==5)
                    Datapixx('WriteAudioBuffer', dsound', 0); % loads data into buffer
                    Datapixx('SetAudioSchedule',0,Fs,length(dsound'),1,0,length(dsound'));
                elseif (trial==1 && gaborordercol(1)==1) || (trial==17 && gaborordercol(1)==2) || (trial==17 && gaborordercol(2)==2) || (trial==18 && gaborordercol(1)==3) || (trial==18 && gaborordercol(2)==3) || (trial==33 && gaborordercol(1)==3) || (trial==33 && gaborordercol(2)==3) || (trial==34 && gaborordercol(1)==4) || (trial==34 && gaborordercol(2)==4) || (trial==50 && gaborordercol(2)==5)
                    Datapixx('WriteAudioBuffer', gaborsound', 0); % loads data into buffer
                    Datapixx('SetAudioSchedule',0,Fs,length(gaborsound'),1,0,length(gaborsound'));
                elseif (trial==17 && restordercol==2) || (trial==33 && restordercol==3) || (trial==49 && restordercol==4)
                    Datapixx('WriteAudioBuffer', restsound', 0); % loads data into buffer
                    Datapixx('SetAudioSchedule',0,Fs,length(restsound'),1,0,length(restsound'));
                end
                Datapixx('StopAudioSchedule');
                Datapixx('RegWrRd'); %
            else
                if (trial==1 && eggordercol==1) || (trial==17 && eggordercol==2) || (trial==18 && eggordercol==3) || (trial==33 && eggordercol==3) || (trial==34 && eggordercol==4) || (trial==50 && eggordercol==5)
                    PsychPortAudio('FillBuffer', pahandle, eggsound' ); % loads data into buffer
                elseif (trial==1 && pdordercol==1) || (trial==17 && pdordercol==2) || (trial==18 && pdordercol==3) || (trial==33 && pdordercol==3) || (trial==34 && pdordercol==4) || (trial==50 && pdordercol==5)
                    PsychPortAudio('FillBuffer', pahandle, dsound' ); % loads data into buffer
                elseif (trial==1 && gaborordercol(1)==1) || (trial==17 && gaborordercol(1)==2) || (trial==17 && gaborordercol(2)==2) || (trial==18 && gaborordercol(1)==3) || (trial==18 && gaborordercol(2)==3) || (trial==33 && gaborordercol(1)==3) || (trial==33 && gaborordercol(2)==3) || (trial==34 && gaborordercol(1)==4) || (trial==34 && gaborordercol(2)==4) || (trial==50 && gaborordercol(2)==5)
                    PsychPortAudio('FillBuffer', pahandle, gaborsound' ); % loads data into buffer
                elseif (trial==17 && restordercol==2) || (trial==33 && restordercol==3) || (trial==49 && restordercol==4)
                    PsychPortAudio('FillBuffer', pahandle, restsound' ); % loads data into buffer
                end
                PsychPortAudio('Start', pahandle);
                while GetSecs < whichblock +TR
                end
            end
            end
        end
        %%
        AssessmentType=mixtr(trial,1);
        %         AssessmentType=mixtr(trial,3);


        %% generate answer for this trial (training type 3 has no button response)
        theans(trial)=randi(2);
        theothershape(trial)=randi(2);
        if AssessmentType==1
            ori=theoris(theans(trial));
            ori2=theoris(theothershape(trial));
            restscreen=0;
            %preCueISI=0;
        elseif AssessmentType==2
            CIstimuliModII_v2 % add the offset/polarity repulsion
            restscreen=0;
            %preCueISI=0;
        else
            % rest
            restscreen=1;
            %preCueISI=0;
        end
        %         if trial==1
        %             %   InstructionFLAPAssessment(w,AssessmentType,gray,white)
        %             if AssessmentType == 1
        %                 Instruction_Contrast_AssessmentTest
        %             elseif AssessmentType==2
        %                 InstructionCIAssessment
        %             end
        %         elseif trial > 1 && (mixtr(trial,1)~= mixtr(trial-1,1) || mixtr(trial,3)~= mixtr(trial-1,3) )
        %             if trial==1 || mixtr(trial,1)~= mixtr(trial-1,1)
        %                 %     InstructionFLAPAssessment(w,AssessmentType,gray,white)
        %                 if AssessmentType == 1
        %                     Instruction_Contrast_Assessment
        %                 elseif AssessmentType==2
        %                     InstructionCIAssessmentscanner
        %                 end
        %             end
        %         end
        %% target location calculation
        if        restscreen~=1
            theeccentricity_Y=LocY(1)*pix_deg;%PD: this is always 0 because LocY is O 8/17/23
            theeccentricity_X=LocX(mixtr(trial,2))*pix_deg;
            eccentricity_X(trial)= theeccentricity_X;
            eccentricity_Y(trial) =theeccentricity_Y ;%PD: this is always 0 8/17/23
            %  destination rectangle for the target stimulus
            imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
                imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
            %  destination rectangle for the other stimulus
            imageRect_offs2 =[imageRect(1)-theeccentricity_X, imageRect(2)-theeccentricity_Y,...
                imageRect(3)-theeccentricity_X, imageRect(4)-theeccentricity_Y];
        end

        if trial==length(mixtr)
            endExp=GetSecs; %time at the end of the session
        end
        %% Initialization/reset of several trial-based variables
        if trial==1
            startExp=GetSecs; %time at the beginning of the session
        end
        playsound=0;


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
            if site==3 %PD: originally site~=5, changed to site==3. 8/15/23
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
            elseif site ==5
                Datapixx('EnableDinDebounce');                          % Debounce button presses
                Datapixx('SetDinLog');                                  % Log button presses to default address
                Datapixx('StartDinLog');                                % Turn on logging
                Datapixx('RegWrRd');
                % Flush any past button presses
                Datapixx('SetDinLog');
                Datapixx('RegWrRd');
            end
        end
        FLAPVariablesReset % reset some variables used in each trial

        %% Initialize deafult values
        %stimulusduration=2.5;
        respgiven=0;

        while eyechecked<1
            if datapixxtime==1
                eyetime2=Datapixx('GetTime');
            end
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            if restscreen==0
                fixationscriptW % visual aids on screen
            else
                %Screen('FillRect', w, gray);
                fixationscriptWrest %PD:this changes the color of the fixation aids indicating the rest block 8/15/23
                CueOnsetTime(trial,1)=0;
                if site==6
                    while GetSecs < TrialStartTime(trial) + (RestDuration-(0.5*TR)); %  rest for 15 sec while GetSecs < RestTime + (RestDuration-0.5);
                        %[keyIsDown, keyTime, keyCode] = KbCheck; %during the rest get TTL pulses
                        [keyIsDown, keyCode]=KbQueueCheck;
                        if  keyIsDown
                            keyr(1,kr) = find(keyCode, 1);
                            keypresstimer(1,kr)=GetSecs;
                            if keyr==KbName('t');
                                if kr==1 && keypresstimer(1,kr)<startTime+TR
                                elseif kr==1 && keypresstimer(1,kr)>startTime+TR
                                    TTL_timeforrest(jr)=keypresstimer(1);
                                    kr=kr+1;
                                    jr=jr+1;
                                elseif keypresstimer(1,kr)-keypresstimer(1,kr-1)>=.5 %I added this because kbcheck gets ~30 keypresses since manual testing isn't quick enough
                                    TTL_timeforrest(jr)=keypresstimer(1,kr);
                                    kr=kr+1;
                                    jr=jr+1;
                                end
                            end
                        end

                    end
                elseif site==5 || site==7
                    WaitSecs(15)
                end
                fixationscriptW; %PD:return to normal colors after the rest period 8/18/23
                eyechecked=2^3;
            end
            %% here is where the first time-based trial loop starts (until first forced fixation is satisfied)
            %             if (eyetime2-trial_time)>=0 && (eyetime2-trial_time)<preCueISI && stopchecking>1
            %                 % pre-event empty space, allows for some cleaning
            %             else
            if (eyetime2-trial_time)==preCueISI && (eyetime2-trial_time)<preCueISI+CueDuration && stopchecking>1
                %                 if restscreen==1 %PD commented this part out & move it
                %                 above, we're checking the rest screen before 8/17/23
                %                     eyechecked=2^3;
                %                 end
                if exist('startrial') == 0
                    trialstart(trial)=GetSecs;
                    startrial=1;
                    if datapixxtime==1
                        trialstart_frame(trial)=Datapixx('GetTime');
                    elseif datapixxtime==0
                        trialstart_frame(trial)=eyetime2;
                    end
                end

                % HERE I present the acoustic cue left or right
                if site == 5 % use DATApixx to play audio @ CAN, AYS 4/29/23
                    if mixtr(trial,2)==1
                        Datapixx('WriteAudioBuffer', bip_sound_left', 0); % loads data into buffer
                        %  Datapixx('SetAudioSchedule',0,fs,length(bip_sound_left'),3,0,length(bip_sound_left'));
                        Datapixx('SetAudioSchedule',0,Fs,length(bip_sound_left'),1,0,length(bip_sound_left'));
                    elseif mixtr(trial,2)==2
                        Datapixx('WriteAudioBuffer', bip_sound_right', 0); % loads data into buffer
                        %  Datapixx('SetAudioSchedule',0,fs,length(bip_sound_right'),3,0,length(bip_sound_right'));
                        Datapixx('SetAudioSchedule',0,Fs,length(bip_sound_right'),2,0,length(bip_sound_right'));
                    end
                    if playsound==1
                        Datapixx('StopAudioSchedule');
                        Datapixx('RegWrRd'); % synchronize Datapixx registers to local register cache
                    end
                    if playsound==0
                        Datapixx('StartAudioSchedule');
                        Datapixx('RegWrRd'); % synchronize Datapixx registers to local register cache
                        playsound=1;
                    end
                else
                    CueOnsetTime(trial,1)=GetSecs; %PD added this to acquire cue onset time
                    if mixtr(trial,2)==1 %@Andrew can you put in the code needed for the Datapixx to play the sounds? Let me know if you need help
                        PsychPortAudio('FillBuffer', pahandle, bip_sound_left' ); % loads data into buffer
                    elseif mixtr(trial,2)==2
                        PsychPortAudio('FillBuffer', pahandle, bip_sound_right' ); % loads data into buffer

                    end
                    if playsound==0
                        PsychPortAudio('Start', pahandle);
                        playsound=1;
                    end
                end
            elseif (eyetime2-trial_time)>=preCueISI+CueDuration  && (eyetime2-trial_time)<preCueISI+CueDuration+postCueISI && stopchecking>1
                % cue-to-target interval

                % I exit the script if I press ESC
                if responsebox==0
                    if keyCode(escapeKey) ~=0
                        thekeys = find(keyCode);
                        closescript=1;
                        break;
                    end
                end

                % below: some response box flushing, might not be needed
                if site ==5
                    Datapixx('EnableDinDebounce');                          % Debounce button presses
                    Datapixx('SetDinLog');                                  % Log button presses to default address
                    Datapixx('StartDinLog');                                % Turn on logging
                    Datapixx('RegWrRd');
                    % Flush any past button presses
                    Datapixx('SetDinLog');
                    Datapixx('RegWrRd');
                end
            elseif (eyetime2-trial_time)>=preCueISI+CueDuration+postCueISI  && (eyetime2-trial_time)<preCueISI+CueDuration+postCueISI+StimulusDuration && stopchecking>1
                % present target
                if AssessmentType==1
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
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
                    if demo==0
                        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], 0.7 );
                    end
                    % here I draw the circle within which I show the contour target
                    Screen('FrameOval', w,[gray], imageRect_offsCImask, maskthickness/2, maskthickness/2);
                    Screen('FrameOval', w,gray, imageRect_offsCImask, 22, 22);
                    fixationscriptW %PD added this on the mask 8/17/23
                    %here I draw the other contour
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI3' + [xJitLocothershape+xModLoc; yJitLocothershape+yModLoc; xJitLocothershape+xModLoc; yJitLocothershape+yModLoc], theori2,[], Dcontr );
                    imageRect_offsCI4(setdiff(1:length(imageRect_offsCI3),targetcord2),:)=0;
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI4' + [xJitLocothershape+xModLoc; yJitLocothershape+yModLoc; xJitLocothershape+xModLoc; yJitLocothershape+yModLoc], theori2,[], Dcontr );
                    if demo==0
                        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI4' + [xJitLocothershape+xModLoc; yJitLocothershape+yModLoc; xJitLocothershape+xModLoc; yJitLocothershape+yModLoc], theori2,[], 0.7 );
                    end
                    % here I draw the circle within which I show the contour target
                    Screen('FrameOval', w,[gray], imageRect_offsCImask2, maskthickness/2, maskthickness/2);
                    Screen('FrameOval', w,gray, imageRect_offsCImask2, 22, 22);
                    fixationscriptW %PD added this on the mask 8/17/23
                    imagearray{trial}=Screen('GetImage', w);
                end
                if exist('stimstar')==0
                    stim_start = GetSecs; %AS 4-28-23 don't use get-secs @Andrew please replace with datapixx time from when the stim started

                    if datapixxtime==1
                        Datapixx('RegWrRd');
                        stim_start_frame(trial) = Datapixx('GetTime');
                    elseif datapixxtime==0
                        stim_start_frame(trial)=eyetime2;
                    end
                    stimstar=1;
                end
                %                 if responsebox==0
                %                     if keyCode(escapeKey) ~=0 %AS 4-28-23 Where is the key being bressed @andrew can you help put in the datapixx button presses?
                %                         % AYS: did we want a datapixx button to close the
                %                         % script? I believe using the control room keyboard
                %                         % to close should work
                %                         thekeys = find(keyCode);
                %                         closescript=1;
                %                         break;
                %                     end
                %                 end
                if responsebox==0
                    if keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 %sum(keyCode)~=0
                        thekeys = find(keyCode);
                        if length(thekeys)>1
                            thekeys=thekeys(1);
                        end
                        thetimes=keyCode(thekeys);
                        [secs  indfirst]=min(thetimes);
                        respTime(trial)=secs;
                        foo=(RespType==thekeys);
                        if site == 5 % use DATApixx to play audio @ CAN, AYS 4/29/23
                            if foo(theans(trial)) % if correct response
                                resp = 1;
                                %                                 Datapixx('WriteAudioBuffer', corrS', 0); %PD commented out since we don't have any auditory feedback 8/15/23
                                %                                 Datapixx('SetAudioSchedule',0,fs,length(corrS'),3,0,length(corrS'));
                            else
                                resp = 0; % if wrong response
                                %                                 Datapixx('WriteAudioBuffer', corrS', 0); % loads data into buffer PD commented out since we don't have any auditory feedback 8/15/23
                                %                                 Datapixx('SetAudioSchedule',0,fs,length(errorS'),3,0,length(errorS'));
                            end
                            %                             Datapixx('StartAudioSchedule');
                            Datapixx('RegWrRd'); % synchronize Datapixx registers to local register cache
                        else
                            if foo(theans(trial)) % if correct response
                                resp = 1;
                                %PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer %AS 4-28-23 @Andrew add  Datapixx sound commands
                            elseif (thekeys==escapeKey) % esc pressed
                                closescript = 1;
                                ListenChar(0); %AS 4-28-23 We cannot use ListenChar This is deprcated. We need either KbQueue for UAB and Datapixx button for UCR
                                break;
                            else
                                resp = 0; % if wrong response
                                %PsychPortAudio('FillBuffer', pahandle, errorS' ); % loads data into buffer %AS 4-28-23 @Andrew add  Datapixx sound commands
                            end
                            PsychPortAudio('Start', pahandle); %AS 4-28-23 @Andrew add  Datapixx sound commands
                        end
                        respgiven=1;
                    end
                elseif responsebox==1
                    if Bpress~=0 && respgiven==0
                        if site ~=5
                            respTime(trial)=secs;
                        elseif site==5
                            respTime(trial)=RespTime;
                            thekeys=TheButtons;
                        end
                        foo=(RespType==thekeys);
                        if site == 5 % use DATApixx to play audio @ CAN, AYS 4/29/23
                            if foo(theans(trial)) % if correct response
                                resp = 1;
                                %                                 Datapixx('WriteAudioBuffer', corrS', 0); % loads data into buffer
                                %                                 Datapixx('SetAudioSchedule',0,fs,length(corrS'),3,0,length(corrS'));
                            else
                                resp = 0; % if wrong response
                                %                                 Datapixx('WriteAudioBuffer', errorS', 0); % loads data into buffer
                                %                                 Datapixx('SetAudioSchedule',0,fs,length(errorS'),3,0,length(errorS'));
                            end
                            %                             Datapixx('StartAudioSchedule');
                            Datapixx('RegWrRd'); % synchronize Datapixx registers to local register cache
                        else
                            if foo(theans(trial)) % if correct response
                                resp = 1;
                                %PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer %AS 4-28-23 @Andrew add  Datapixx sound commands
                            elseif (thekeys==escapeKey) % esc pressed
                                closescript = 1;
                                ListenChar(0); %AS 4-28-23 We cannot use ListenChar This is deprcated. We need either KbQueue for UAB and Datapixx button for UCR
                                break;
                            else
                                resp = 0; % if wrong response
                                % PsychPortAudio('FillBuffer', pahandle, errorS' ); % loads data into buffer %AS 4-28-23 @Andrew add  Datapixx sound commands
                            end
                            PsychPortAudio('Start', pahandle); %AS 4-28-23 @Andrew add  Datapixx sound commands
                        end
                        respgiven=1;
                    end
                end
            elseif (eyetime2-trial_time)>=preCueISI+CueDuration+postCueISI+StimulusDuration  && (eyetime2-trial_time)<preCueISI+CueDuration+postCueISI+StimulusDuration+PostStimulusDuration && stopchecking>1
                if responsebox==0
                    if keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 %sum(keyCode)~=0
                        thekeys = find(keyCode);
                        if length(thekeys)>1
                            thekeys=thekeys(1);
                        end
                        thetimes=keyCode(thekeys);
                        [secs  indfirst]=min(thetimes);
                        respTime(trial)=secs;
                        foo=(RespType==thekeys);
                        if site == 5 % use DATApixx to play audio @ CAN, AYS 4/29/23
                            if foo(theans(trial)) % if correct response
                                resp = 1;
                                %                                 Datapixx('WriteAudioBuffer', corrS', 0); %PD commented out since we don't have any auditory feedback 8/15/23
                                %                                 Datapixx('SetAudioSchedule',0,fs,length(corrS'),3,0,length(corrS'));
                            else
                                resp = 0; % if wrong response
                                %                                 Datapixx('WriteAudioBuffer', corrS', 0); % loads data into buffer PD commented out since we don't have any auditory feedback 8/15/23
                                %                                 Datapixx('SetAudioSchedule',0,fs,length(errorS'),3,0,length(errorS'));
                            end
                            %                             Datapixx('StartAudioSchedule');
                            Datapixx('RegWrRd'); % synchronize Datapixx registers to local register cache
                        else
                            if foo(theans(trial)) % if correct response
                                resp = 1;
                                %                                 PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer %AS 4-28-23 @Andrew add  Datapixx sound commands
                            elseif (thekeys==escapeKey) % esc pressed
                                closescript = 1;
                                ListenChar(0); %AS 4-28-23 We cannot use ListenChar This is deprcated. We need either KbQueue for UAB and Datapixx button for UCR
                                %   break;
                            else
                                resp = 0; % if wrong response
                                %                                 PsychPortAudio('FillBuffer', pahandle, errorS' ); % loads data into buffer %AS 4-28-23 @Andrew add  Datapixx sound commands
                            end
                            %                             PsychPortAudio('Start', pahandle); %AS 4-28-23 @Andrew add  Datapixx sound commands
                        end
                        respgiven=1;
                    end
                elseif responsebox==1
                    if Bpress~=0 && respgiven==0
                        if site ~=5
                            respTime(trial)=secs;
                        elseif site==5
                            respTime(trial)=RespTime;
                            thekeys=TheButtons;
                        end
                        foo=(RespType==thekeys);
                        if site == 5 % use DATApixx to play audio @ CAN, AYS 4/29/23
                            if foo(theans(trial)) % if correct response
                                resp = 1;
                                %                                 Datapixx('WriteAudioBuffer', corrS', 0); % loads data into buffer
                                %                                 Datapixx('SetAudioSchedule',0,fs,length(corrS'),3,0,length(corrS'));
                            else
                                resp = 0; % if wrong response
                                %                                 Datapixx('WriteAudioBuffer', errorS', 0); % loads data into buffer
                                %                                 Datapixx('SetAudioSchedule',0,fs,length(errorS'),3,0,length(errorS'));
                            end
                            %                             Datapixx('StartAudioSchedule');
                            Datapixx('RegWrRd'); % synchronize Datapixx registers to local register cache
                        else
                            if foo(theans(trial)) % if correct response
                                resp = 1;
                                %PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer %AS 4-28-23 @Andrew add  Datapixx sound commands
                            elseif (thekeys==escapeKey) % esc pressed
                                closescript = 1;
                                ListenChar(0); %AS 4-28-23 We cannot use ListenChar This is deprcated. We need either KbQueue for UAB and Datapixx button for UCR
                                break;
                            else
                                resp = 0; % if wrong response
                                %PsychPortAudio('FillBuffer', pahandle, errorS' ); % loads data into buffer %AS 4-28-23 @Andrew add  Datapixx sound commands
                            end
                            PsychPortAudio('Start', pahandle); %AS 4-28-23 @Andrew add  Datapixx sound commands
                        end
                        respgiven=1;
                    end
                end
            elseif (eyetime2-trial_time)>=preCueISI+CueDuration+postCueISI+StimulusDuration+PostStimulusDuration
                if respgiven==0
                    respTime(trial)=NaN;
                    resp = 0;
                end
                eyechecked=10^4; % exit loop for this trial
            end
            %% here I draw the scotoma, elements below are called every frame
            %AS 4-28-23 Do we have the scotoma in the scanner? I didn't
            %think so
            %             if gazecontingent==1
            %                 eyefixation5
            %                 if restscreen==0
            %                     if ScotomaPresent == 1 % do we want the scotoma? (default is yes)
            %                         Screen('FillOval', w, scotoma_color, scotoma);
            %                     else % else we get a fixation cross and no scotoma
            %                         Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
            %                         Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
            %                     end
            %                 end
            %                 if demo==1
            %                     if penalizeLookaway>0
            %                         if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
            %                             Screen('FillRect', w, gray);
            %                         end
            %                     end
            %                 end
            %             end
            %% last wait
            if trial==length(mixtr) %PD added this last wait after last trial ends 9/7/23
                if GetSecs-startTime < 280.5; %total duration should be 274.5
                    while GetSecs + (TRwait(trial)*TR) < 280.5 %waits for the last TRwait long
                    end
                end
            end
            if datapixxtime==1
                [eyetime3, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
                VBL_Timestamp=[VBL_Timestamp eyetime3 ];
                datapixx_Timestamp=[datapixx_Timestamp eyetime2];
                dd(length(datapixx_Timestamp))=trial_time;
            else
                [eyetime2, StimulusOnsetTime(trial,1), FlipTimestamp, Missed]=Screen('Flip',w);%PD addedd (trial,1)to StimulusOmnsetTime here. 8/18/23
                VBL_Timestamp=[VBL_Timestamp eyetime2];
            end
            %% process eyedata in real time (fixation/saccades)
            if gazecontingent==1 && EyeTracker==1  %AS 4-28-23 Do we need any of this or just get eye-tracking data at the end of the trial? @Andrew can you help Marcello with that code?
                GetEyeTrackerDataNew
                GetFixationDecision
                if EyeData(end,1)<8000 && stopchecking<0
                    if datapixxtime==1
                        trial_time=Datapixx('GetTime');%
                    elseif datapixxtime==0
                        trial_time = GetSecs; %start timer if we have eye info
                    end
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
            %% Response saving
            if responsebox==1 && site ~=5 % DATApixx AYS 5/4/23 I added some documentation for WaitForEvent_Jerry - let me know if you have questions.
                %  [Bpress, RespTime, TheButtons] = WaitForEvent_Jerry(0, TargList);
                Datapixx('RegWrRd');
                buttonLogStatus = Datapixx('GetDinStatus');
                if (buttonLogStatus.newLogFrames > 0)
                    [thekeys secs] = Datapixx('ReadDinLog');
                end
                %         [keyIsDown, keyCode] = KbQueueCheck;
            elseif responsebox==1 && site == 5 % DATApixx AYS 5/4/23 I added some documentation for WaitForEvent_Jerry - let me know if you have questions.
                %  [Bpress, RespTime, TheButtons] = WaitForEvent_Jerry(responseduration, TargList, startime);
                [Bpress, RespTime, TheButtons] = DontWaitForEvent_Jerry3(TargList, Bpress, TheButtons, RespTime,timestamp, binaryvals,inter_buttonpress, bin_buttonpress, inter_timestamp);
                %     buttonpress=thekeys;
                %    buttonLogStatus.newLogFrames
            else
                [keyIsDown, keyCode] = KbQueueCheck;
            end
            %             if site == 5 % DATApixx AYS 5/4/23 I added some documentation for WaitForEvent_Jerry - let me know if you have questions.
            %                 [Bpress, RespTime, TheButtons] = WaitForEvent_Jerry(responseduration, TargList, startime);
            %             else % AYS: UCR and UAB?
            %                 [keyIsDown, keyCode] = KbQueueCheck; %AS 4-28-23 @Andrew add  Datapixx button press as an option
            %             end

        end
        %% response processing
        if exist('secs')==0 % PD: if we're giving response with response box 8/17/23
            secs=nan;
        end
        stim_stop=secs;
        clear secs
        if exist('thekeys')==0% PD: if we're giving response with response box 8/17/23
            thekeys=nan;
        end
        if exist('resp')==0
            resp=nan;
        end


        if  restscreen==0
            cheis(trial)=thekeys;
            %   time_stim(trial) = stim_stop - stim_start_frame;
            ReactionT(trial)=respTime(trial)-stim_start_frame(trial);
            rispo(trial)=resp;
            coordinate(trial).x=theeccentricity_X/pix_deg;
            coordinate(trial).y=theeccentricity_Y/pix_deg;
            xxeye(trial).ics=[xeye];
            yyeye(trial).ipsi=[yeye];
            vbltimestamp(trial).ix=[VBL_Timestamp];
            SizeAttSti(trial) =imageRect_offs(3)-imageRect_offs(1);
            rectimage{trial}=imageRect_offs;
            if exist('endExp')
                totalduration=(endExp-startExp)/60;
            end
            %% record eyelink-related variables
            if EyeTracker==1 && gazecontingent==1
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
            if EyetrackerType==2
                %read in eye data
                Datapixx('RegWrRd');
                status = Datapixx('GetTPxStatus');
                toRead = status.newBufferFrames;
                if toRead>0
                    [bufferData, ~, ~] = Datapixx('ReadTPxData', toRead);

                    %bufferData is formatted as follows:
                    %1      --- Timetag (in seconds)
                    %2      --- Left Eye X (in pixels)
                    %3      --- Left Eye Y (in pixels)
                    %4      --- Left Pupil Diameter (in pixels)
                    %5      --- Right Eye X (in pixels)
                    %6      --- Right Eye Y (in pixels)
                    %7      --- Right Pupil Diameter (in pixels)
                    %8      --- Digital Input Values (24 bits)
                    %9      --- Left Blink Detection (0=no, 1=yes)
                    %10     --- Right Blink Detection (0=no, 1=yes)
                    %11     --- Digital Output Values (24 bits)
                    %12     --- Left Eye Fixation Flag (0=no, 1=yes)
                    %13     --- Right Eye Fixation Flag (0=no, 1=yes)
                    %14     --- Left Eye Saccade Flag (0=no, 1=yes)
                    %15     --- Right Eye Saccade Flag (0=no, 1=yes)
                    %16     --- Message code (integer)
                    %17     --- Left Eye Raw X (in pixels)
                    %18     --- Left Eye Raw Y (in pixels)
                    %19     --- Right Eye Raw X (in pixels)
                    %20     --- Right Eye Raw Y (in pixels)

                    %IMPORTANT: "RIGHT" and "LEFT" refer to the right and left eyes shown
                    %in the console overlay. In tabletop and MEG setups, this view is
                    %inverted. This means "RIGHT" in our labelling convention corresponds
                    %to the participant's left eye. Similarly "LEFT" in our convention
                    %refers to left on the screen, which corresponds to the participant's
                    %right eye.

                    %If you are using an MRI setup with an inverting mirror, "RIGHT" will
                    %correspond to the participant's right eye.

                    %save eye data from trial as a table in the trial structure
                    Pixxstruct(trial).EyeData = array2table(bufferData, 'VariableNames', {'TimeTag', 'LeftEyeX', 'LeftEyeY', 'LeftPupilDiameter', 'RightEyeX', 'RightEyeY', 'RightPupilDiameter',...
                        'DigitalIn', 'LeftBlink', 'RightBlink', 'DigitalOut', 'LeftEyeFixationFlag', 'RightEyeFixationFlag', 'LeftEyeSaccadeFlag', 'RightEyeSaccadeFlag',...
                        'MessageCode', 'LeftEyeRawX', 'LeftEyeRawY', 'RightEyeRawX', 'RightEyeRawY'});
                    %interim save
                    % save(baseName, 'Pixxstruct');
                    % Pixxstruct(trial).EyeData.TimeTag-Pixxstruct(trial).TargetOnset2
                end
            end
            if closescript==1
                break;
            end
            %% jitter code @ trial loop end, AYS 4/28/23. See also jitter code @ trial loop start
            if site == 5
                Datapixx('RegWrRd');
                TrialEndTimeD(trial)=Datapixx('GetTime');
                TrialinTRsD(trial)=ceil((TrialEndTimeD(trial)-TrialStartTimeD(trial))/TR);
                TRcount=TRcount+TrialinTRsD(trial);
            end
        end

        %%
        % -----------------------------------------------------------------------------------
        if (mod(trial,150))==1 && trial>1
            save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
        end
    end
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
    ListenChar(0);
    ScriptEnds=Screen('Flip', w);
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    %   KbQueueWait;

    %% shut down EyeTracker and screen functions
    if EyetrackerType==1
        Eyelink('StopRecording');
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    elseif EyetrackerType==2     %AS 4-28-23 @Andrew add  Datapixx commands
        Datapixx('StopTPxSchedule');
        Datapixx('RegWrRd');
        finish_time = Datapixx('GetTime');
        Datapixx('SetTPxSleep');
        Datapixx('RegWrRd');
        Datapixx('Close');
    end

    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];

    ShowCursor;

    Screen('CloseAll');
    if site ~= 5
        PsychPortAudio('Close', pahandle);     %AS 4-28-23 @Andrew add  Datapixx commands
    end
    %     if site == 5 % AYS 5/4/23
    %         Datapixx('StopDinLog');
    %         Datapixx('RegWrRd');
    %         finish_time = Datapixx('GetTime');
    %         Datapixx('Close');
    %     end
    %
catch ME
    if site == 5 && EyetrackerType==2 && Datapixx('IsReady') % AYS 5/4/23
        Datapixx('StopTPxSchedule');
        status = Datapixx('GetTPxStatus');
        toRead = status.newBufferFrames;
        [bufferData, underflow, overflow] = Datapixx('ReadTPxData', toRead);
        save(eyetrack_fname,'bufferData');
    end
    if site == 5 || site == 3
        if Datapixx('IsReady')
            Datapixx('StopDinLog');
            Datapixx('Close');
        end
    end
    psychlasterror()
end