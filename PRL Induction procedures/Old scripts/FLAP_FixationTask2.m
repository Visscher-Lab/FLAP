% PRL evaluation/Fixation task
% written by Marcello A. Maniglia August 2022 %2017/2022
close all; clear; clc;
commandwindow


addpath([cd '/utilities']);
try
    prompt={'Participant name', 'day','site? UCR(1), UAB(2), Vpixx(3)','scotoma active','scotoma Vpixx active', 'demo (0) or session (1)',  'eye? left(1) or right(2)', 'Calibration? yes (1), no(0)'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '3', '1','0', '0','2','0' };
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    expDay=str2num(answer{2,:});
    site= str2num(answer{3,:});  %0; 1=bits++; 2=display++
    ScotomaPresent= str2num(answer{4,:}); % 0 = no scotoma, 1 = scotoma
    scotomavpixx= str2num(answer{5,:});
    Isdemo=str2num(answer{6,:}); % full session or demo/practice
    whicheye=str2num(answer{7,:}); % which eye to track (vpixx only)
    calibration=str2num(answer{8,:}); % do we want to calibrate or do we skip it? only for Vpixx
    
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    
    if Isdemo==0
        filename='_FLAPfixationflickerpractice';
    elseif Isdemo==1
        filename='_FLAPfixationflicker';
    end
    if site==1
        baseName=['./data/' SUBJECT filename '_' expDay num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[cd '\data\' SUBJECT filename '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[cd '\data\' SUBJECT filename 'Pixx_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    EyeTracker = 1; %0=mouse, 1=eyetracker
    defineSite % initialize Screen function and features depending on OS/Monitor
    CommonParametersFixation % load parameters for time and space
    
    %% eyetracker initialization (eyelink)
    
    if EyeTracker==1
        if site==3
            EyetrackerType=2; %1 = Eeyelink, 2 = Vpixx
        else
            EyetrackerType=1; %1 = Eeyelink, 2 = Vpixx
        end
        eyetrackerparameters % set up Eyelink eyetracker
    end
    
    %% creating stimuli
    imsize=stimulusSize*pix_deg;
    createO
    %% Keys definition/kb initialization
    
    KbName('UnifyKeyNames');
    
    
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
    
    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    end
    
    %% Trial structure
    imageRect = CenterRect([0, 0, stimulusSize*pix_deg stimulusSize*pix_deg], wRect);
    
    ecc_r=PRLecc*pix_deg; % radius of possible target locations
    
    
    for ui=1:length(angl)
        ecc_t=deg2rad(angl(ui));
        cs= [cos(ecc_t), sin(ecc_t)];
        xxyy=[ecc_r ecc_r].*cs;
        ecc_x=xxyy(1);
        ecc_y=xxyy(2);
        eccentricity_X(ui)=ecc_x;
        eccentricity_Y(ui)=ecc_y;
    end
    tr=5; % trials per target location
    loc = [1;2]; % number of fixation locations
    mixtr1 = [repmat(loc(1),1,(length(angl)*tr))', repmat(1:length(angl),1,tr)'];
    mixtr2 = [repmat(loc(2),1,(length(angl)*tr))', repmat(1:length(angl),1,tr)'];
    mixtr1 = mixtr1(randperm(length(mixtr1)),:);
    mixtr2 = mixtr2(randperm(length(mixtr2)),:);
    mixtr = [mixtr1;mixtr2];
%       tr=1;
 %  mixtr=[repmat(loc(1),1,(length(angl)*tr))', repmat(1:length(angl),1,tr)'; repmat(loc(2),1,(length(angl)*tr))', repmat(1:length(angl),1,tr)']; % create unrandomized mixtr
%    mixtr=[repmat(loc(2),1,(length(angl)*tr))', repmat(1:length(angl),1,tr)'; repmat(loc(1),1,(length(angl)*tr))', repmat(1:length(angl),1,tr)']; % create unrandomized mixtr

  %       mixtr =mixtr(randperm(length(mixtr)),:); % randomize trials
    
%     if Isdemo==0
%         tr=2;
%         mixtr=[repmat(1:length(angl),1,tr)'];
%         mixtr =mixtr(randperm(length(mixtr)),:);
%     elseif Isdemo==1
%         tr=10; % trials per target location
%         mixtr=[repmat(1:length(angl),1,tr)']; % create unrandomized mixtr
%         mixtr =mixtr(randperm(length(mixtr)),:); % randomize trials
%     end
    
    
    %% main loop
    HideCursor;
    ListenChar(2);
    WaitSecs(1);
    
    Screen('FillRect', w, gray);
    DrawFormattedText(w, 'Keep the scotoma near the stimulus until it start flickering \n \n  after some time, the trial will end automatically \n \n \n \n Press any key to start', 'center', 'center', white);
    Screen('Flip', w);
    KbQueueWait;
    WaitSecs(0.5);
    
    
    % check EyeTracker status
    if EyetrackerType == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        % mark zero-plot time in data file
        Eyelink('message' , 'SYNCTIME');
        
        location =  zeros(length(mixtr), 6);
    end
    
    
    %   for trial=1:length(mixtr)
    for trial=1:length(mixtr)
        trialTimedout(trial)=0;
        
        flickk=0;
        if mod(trial,10)==0
            interblock_instruction
        end
        
        
        FlickerTime=JitterFlicker(randi(length(JitterFlicker))); % define the flicker time duration (movie duration) for this trial
        actualtrialtimeout=400000;
        
        theeccentricity_X=eccentricity_X(mixtr(trial,2)); % target location x
        
        if mixtr(trial,1)==1
        theeccentricity_Y=startingfixationpoint(mixtr(trial,1))*pix_deg + eccentricity_Y(mixtr(trial,2)); % target location y
        elseif mixtr(trial,1)==2
        theeccentricity_Y=startingfixationpoint(mixtr(trial,1))*pix_deg - eccentricity_Y(mixtr(trial,2)); % target location y
        end
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
        
        FLAPVariablesReset
%         newRect = wRect;
%         newRect(4) = newRect(4) + startingfixationpoint(mixtr(trial,1)) * pix_deg;
        
        while eyechecked<1
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            if  (eyetime2-pretrial_time)>=ifi*2 && fixating<initialfixationduration/ifi && stopchecking>1
                fixationscriptW_fixationTask
                isFixatingSquare_fixationTask2
                
                if exist('starfix')==0
                    startfix=GetSecs;
                    starfix=98;
                end
            elseif (eyetime2-pretrial_time)>ifi*2 && fixating>=initialfixationduration/ifi && fixating<1000 && stopchecking>1
                trial_time = GetSecs;
                clear circlestar
                clear flickerstar
                clear theSwitcher
                fixating=1500;
            end
            if (eyetime2-trial_time)>= ifi*2+pretargettime && fixating>400 && stopchecking>1 && counterannulus<AnnulusTime/ifi && counterflicker<FlickerTime/ifi && flickerdone<1 && keyCode(escapeKey) ==0 && (eyetime2-trial_time)<=actualtrialtimeout
                
                % 2: force fixation within 2 degrees of the
                % scotoma. No flicker yet
                IsFixatingAnnulus
                Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                if exist('circlestar')==0
                    circle_start(trial) = eyetime2;
                    circlestar=1;
                end
                if counterannulus==round(AnnulusTime/ifi)
                    newtrialtime=eyetime2;
                    actualtrialtimeout=FlickerTime+trialTimeout;
                    skipcounterannulus=1000; % satisfied the annulustime duration before the flicker starts
                end
            elseif (eyetime2-trial_time)>= ifi*2+pretargettime && fixating>400 && stopchecking>1 && flickerdone<1  && counterannulus<AnnulusTime/ifi && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ~=0 && (eyetime2-trial_time)<=actualtrialtimeout
                %HERE if I press ESC
                thekeys = find(keyCode);
                closescript=1;
                break;
            elseif (eyetime2-newtrialtime)>= ifi*2+pretargettime && fixating>400 && stopchecking>1 &&  skipcounterannulus>10  && counterflicker<FlickerTime/ifi && (eyetime2-trial_time)<=actualtrialtimeout && keyCode(escapeKey) ==0
                % 3: flickering start, only flicker if within 2 degrees of the scotoma
                if exist('flickerstar') == 0
                    flicker_time_start(trial)=eyetime2;
                    flickerstar=1;
                    theSwitcher=0;
                    flickswitch=0;
                    flick=1;
                end
                flicker_time=GetSecs-flicker_time_start(trial);
                
                if flicker_time>flickswitch
                    flickswitch= flickswitch+flickeringrate;
                    flick=3-flick;
                end
                
                cue_last(trial)=eyetime2;
                clear targetstar
                clear stimstar
                
                [countgt framecont countblank blankcounter counterflicker turnFlickerOn]=  ForcedFixationFlicker3(w,countgt,countblank, framecont, newsamplex,newsampley,wRect,0,0,circlePixels,theeccentricity_X,theeccentricity_Y,blankcounter,framesbeforeflicker,blankframeallowed, EyeData, counterflicker,eyetime2,EyeCode,turnFlickerOn);
                %      [countgt framecont countblank blankcounter counterflicker turnFlickerOn]=  ForcedFixationFlicker3(w,countgt,countblank, framecont, newsamplex,newsampley,wRect,0,0,circlePixels,theeccentricity_X,theeccentricity_Y,blankcounter,framesbeforeflicker,blankframeallowed, EyeData, counterflicker,eyetime2,EyeCode,turnFlickerOn);
                
                % from ForcedFixationFlicker3, should I show the flicker or not?
                if turnFlickerOn(end)==1 %flickering cue
                    if flick==2
                        Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                    end
                elseif turnFlickerOn(end)==0 %non-flickering cue
                    Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                end
                
                
                if counterflicker>=round(FlickerTime/ifi)
                    
                    newtrialtime=eyetime2;
                    flickerdone=10;
                    flicker_time_stop(trial)=eyetime2; % end of the overall flickering period
                    
                end
            elseif (eyetime2-newtrialtime)>= ifi*2+pretargettime && fixating>400 && stopchecking>1 && skipcounterannulus>10 && counterflicker<FlickerTime/ifi && (eyetime2-trial_time)<=actualtrialtimeout && keyCode(escapeKey) ~=0
                closescript = 1;
                thekeys = find(keyCode);
                % ESC pressed
                break
            elseif (eyetime2-newtrialtime)>= ifi*2+pretargettime && fixating>400 && skipcounterannulus>10 && counterflicker>=FlickerTime/ifi &&   keyCode(escapeKey) ==0 && stopchecking>1 && (eyetime2-trial_time)<=actualtrialtimeout %present pre-stimulus and stimulus %keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3))+ keyCode(RespType(4)) + keyCode(RespType(5))
                % trial completed
                PsychPortAudio('Start', pahandle1); % sound feedback
                
                eyechecked=10^4;
                
            elseif (eyetime2-pretrial_time)>=actualtrialtimeout % trial timed out
                stim_stop(trial)=eyetime2;
                trialTimedout(trial)=1;
                flicker_time_stop(trial)=NaN;
                PsychPortAudio('Start', pahandle2); % sound feedback
                
                eyechecked=10^4;
            end
            
            eyefixation5
            if ScotomaPresent == 1
                Screen('FillOval', w, scotoma_color, scotoma);
            else
                fixationlength=10;
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
                
            end
            if EyetrackerType==2
                
                if scotomavpixx==1
                    Datapixx('EnableSimulatedScotoma')
                    Datapixx('SetSimulatedScotomaMode',2) %[~,mode = 0]);
                    scotomaradiuss=round(pix_deg*6);
                    Datapixx('SetSimulatedScotomaRadius',scotomaradiuss) %[~,mode = 0]);
                    mode=Datapixx('GetSimulatedScotomaMode');
                    status= Datapixx('IsSimulatedScotomaEnabled');
                    radius= Datapixx('GetSimulatedScotomaRadius');
                    
                end
            end
            if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                Screen('FillRect', w, gray);
            end
            [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
            
            VBL_Timestamp=[VBL_Timestamp eyetime2];
            
            if EyeTracker==1
                
                if site<3
                    GetEyeTrackerData
                elseif site ==3
                    GetEyeTrackerDatapixx
                end
                GetFixationDecision
                
                if EyeData(end,1)<8000 && stopchecking<0
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
        if trialTimedout(trial)==0
            stim_stop(trial)=GetSecs;
        end
        if closescript~=1 && trialTimedout(trial)==0
            movieDuration(trial)=flicker_time_stop(trial)-flicker_time_start(trial); % actual duration of flicker
            flickertimetrial(trial)=FlickerTime; %  nominal duration of flicker
            Timeperformance(trial)=movieDuration(trial)-(flickertimetrial(trial)*3); % estimated difference between actual and expected flicker duration
            unadjustedTimeperformance(trial)=movieDuration(trial)-flickertimetrial(trial);
            totaltrialduration(trial)=flicker_time_start(trial)-circle_start(trial); % overall trial duration from stimulus appearance (static + flickering target)
            cueendToResp(kk)=stim_stop(trial)-cue_last(trial);
        end
        
        totale_trials(kk)=trial;
        coordinate(trial).x=theeccentricity_X/pix_deg;
        coordinate(trial).y=theeccentricity_Y/pix_deg;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];
        
        fixationdure(trial)=trial_time-startfix;
        
        SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
        cuebeginningToResp(kk)=stim_stop(trial)-circle_start(trial);
        %  intervalBetweenFlickerandTrget(trial)=target_time_start-flicker_time_start;
        
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
            EyeSummary.(TrialNum).TimeStamps.Fixation = circle_start; % stimulus appearance
            EyeSummary.(TrialNum).TimeStamps.StimulusStart = flicker_time_start; % flicker start
            EyeSummary.(TrialNum).TimeStamps.StimulusEnd = flicker_time_stop; % flicker end
            EyeSummary.(TrialNum).TimeStamps.Response = stim_stop(trial);
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
    
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    Screen('Flip', w);
    Screen('TextFont', w, 'Arial');
    
    
    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    
    KbQueueWait;
    ShowCursor;
    Screen('CloseAll');
    Screen('Preference', 'SkipSyncTests', 0);
    
    
    %% data analysis
    %thresho=permute(Threshlist,[3 1 2]);
    
    %to get the final value for each staircase
    %final_threshold=thresho(10,1:length(thresho(1,:,1)),1:length(thresho(1,1,:)));
    %total_thresh= [final_threshold(:,:,1) final_threshold(:,:,2)];
    %%
    
    
catch ME
    psychlasterror()
end