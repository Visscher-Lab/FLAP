% Visual Acuity/Crowding/cued-uncued attention task
% written by Marcello A. Maniglia july 2021 %2017/2021
close all;
clear;
clc;
commandwindow
%addpath('/Users/sll/Desktop/Flap/Flap_scripts/utilities')


addpath([cd '/utilities']);
try
    prompt={'Participant name', 'day','site? UCR(1), UAB(2), Vpixx(3)','scotoma old mode active','scotoma Vpixx active', 'demo (0) or session (1)', 'Locations: (2) or (4)',  'eye? left(1) or right(2)','Calibration? yes (1), no(0)'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '3', '1','0', '1', '2', '2', '0' };
    
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
    PRLlocations=str2num(answer{7,:});
    whicheye=str2num(answer{8,:}); % which eye to track (vpixx only)
    calibration=str2num(answer{9,:}); % do we want to calibrate or do we skip it? only for Vpixx
    
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    
    if Isdemo==0
        filename='_FLAP_contrast_nostreak_practice';
    elseif Isdemo==1
        filename='_FLAP_contrast_nostreak';
    end
    
    if site==1
        baseName=['./data/' SUBJECT filename '_' num2str(PRLlocations) '_' expDay num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[cd '\data\' SUBJECT filename '_' num2str(PRLlocations) '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[cd '\data\' SUBJECT filename 'Pixx_' num2str(PRLlocations) '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    EyeTracker = 1; %0=mouse, 1=eyetracker
    
    defineSite % initialize Screen function and features depending on OS/Monitor
    
    CommonParametersACA % load parameters for time and space
    exocuearray=[1, 5];
    
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
    createO
                imageRect = CenterRect([0, 0, StartSize*pix_deg StartSize*pix_deg], wRect);

 %% STAIRCASES:
    
    % Acuity sc1
    threshVA(1:PRLlocations)=15; %starting value for Gabor contrast
    reversalsVA(1:PRLlocations)=0;
    isreversalsVA(1:PRLlocations)=0;
    staircounterVA(1:PRLlocations)=0;
    corrcounterVA(1:PRLlocations)=0;
    
    % Threshold -> 79%
    sc.up = 1;                          % # of incorrect answers to go one step up
    sc.steps= [2 3];                    % # of correct answers to go one step down
   max_contrast=1;
            Contlist = log_unit_down(max_contrast+.122, 0.05, 70); % contrast list for trainig type 1 and 4
            Contlist(1)=1;

    stepsizesVA=[5 5 3 3 3 1];
    
  
    tr_per_condition=60;  %50
    tr_per_conditionAtt=40;
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
    
    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    end
    %% Trial structure
    if PRLlocations==2
        % acuity
        coin=randi(2);
        if coin==1
            % acuity sx first
            mixtrVA=[ones(tr_per_condition,1); ones(tr_per_condition,1)*2];
        else
            % acuity dx first
            mixtrVA=[ones(tr_per_condition,1)*2; ones(tr_per_condition,1)];
        end
    end
    

    if Isdemo==0
        mixtrVA=mixtrVA(1:practicetrials,:);
    end
    totalmixtr=length(mixtrVA);
    %% main loop
    HideCursor;
    ListenChar(2);
    counter = 0;
    
    Screen('FillRect', w, gray);
    DrawFormattedText(w, 'report the orientation of the gap of the C \n \n using the keyboard arrows \n \n \n \n Press any key to start', 'center', 'center', white);
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
        location =  zeros(length(totalmixtr), 6);
    end
    presentcue=0;
    %  resetcounterVA=1;
    %    resetcounterCW=1;
    
    resetcounterVA(1:PRLlocations)=1;
        ThreshlistVA(1:PRLlocations)=0;

    for trial=1:totalmixtr
        trialTimedout(trial)=0;
        TrialNum = strcat('Trial',num2str(trial));
        
        if trial== length(mixtrVA)+1
            interblock_instruction_crowding
        end
        if trial== (length(mixtrVA)+length(mixtrCW))+1
            interblock_instruction_attention
        end
                
        if mod(trial,tr_per_condition+1)==0 && trial~= length(mixtrVA)+1
            interblock_instruction
        end
       
            trialTimeout=realtrialTimeout;
            theeccentricity_X=eccentricity_X(mixtrVA(trial));
            theeccentricity_Y=eccentricity_Y(mixtrVA(trial));

            cont = Contlist(threshVA(mixtrVA(trial)));

        %  destination rectangle for the fixation dot
        imageRect_offs_dot=[imageRectDot(1)+theeccentricity_X, imageRectDot(2)+theeccentricity_Y,...
            imageRectDot(3)+theeccentricity_X, imageRectDot(4)+theeccentricity_Y];
        

            currentpostfixationblank=postfixationblank(1);
            currentcueISI=0;
            currentcueduration=0;
        trialTimeout=realtrialTimeout+currentpostfixationblank;
        
        % compute response for trial
        theoris =[-180 0 -90 90];
        theans(trial)=randi(4);
        ori=theoris(theans(trial));
        
        
        FLAPVariablesReset
        
        while eyechecked<1
            
            if ScotomaPresent == 1
                fixationscriptW
            end
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            
            % constrained fixation loop
            if  (eyetime2-pretrial_time)>=ITI && fixating<fixationduration/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                presentcue=0;
                %   IsFixatingSquare
                [fixating counter framecounter ]=IsFixatingSquareNew(wRect,xeye,yeye,fixating,framecounter,counter,fixwindowPix);
                if exist('starfix')==0
                    startfix(trial)=eyetime2;
                    starfix=98;
                end
                Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
            elseif (eyetime2-pretrial_time)>ITI && fixating>=fixationduration/ifi && stopchecking>1 && fixating<1000 && (eyetime2-pretrial_time)<=trialTimeout
                % forced fixation time satisfied
                trial_time = GetSecs;
                %      clear imageRect_offsCirc
                clear imageRect_offs imageRect_offs_flank1 imageRect_offs_flank2 imageRect_offscircle imageRect_offscircle1 imageRect_offscircle2
                clear stimstar subimageRect_offs_cue
                fixating=1500;
            end
            
            
            % beginning of the trial after fixation criteria satisfied in
            % previous loop
            if (eyetime2-trial_time)>=currentpostfixationblank && (eyetime2-trial_time)<currentpostfixationblank+currentcueduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                presentcue=1;

            elseif (eyetime2-trial_time)>=currentpostfixationblank+currentcueduration && (eyetime2-trial_time)<currentpostfixationblank+currentcueISI+currentcueduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                ACAExoStimuli
                presentcue=0;
                %no cue
            elseif (eyetime2-trial_time)>=currentpostfixationblank+currentcueISI+currentcueduration && (eyetime2-trial_time)<currentpostfixationblank+currentcueduration+currentcueISI+stimulusduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                % show target
                if exist('imageRect_offs')==0
                    imageRect_offs =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                        imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
                    imageRect_offscircle=[imageRect_offs(1)-(0.635*pix_deg) imageRect_offs(2)-(0.635*pix_deg) imageRect_offs(3)+(0.635*pix_deg) imageRect_offs(4)+(0.635*pix_deg) ];
                end
                
                Screen('FillOval',w, gray,imageRect_offscircle); % lettera a sx del target
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], cont);

                if exist('stimstar') == 0
                    stim_start(trial)=eyetime2;
                    stimstar=1;
                end

                if (keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey)) ~=0
                    %after target presentation and a key is pressed
                    eyechecked=10^4;
                    thekeys = find(keyCode);
                    if length(thekeys)>1
                        thekeys=thekeys(1);
                    end
                    thetimes=keyCode(thekeys);
                    [secs  indfirst]=min(thetimes);
                    respTime(trial)=secs;
                end
            elseif (eyetime2-trial_time)>=currentpostfixationblank+currentcueISI+currentcueduration+stimulusduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout%present pre-stimulus and stimulus
                %after target presentation and no key pressed
                
                if (keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey)) ~=0
                    %after target presentation and a key is pressed
                    eyechecked=10^4;
                    thekeys = find(keyCode);
                    if length(thekeys)>1
                        thekeys=thekeys(1);
                    end
                    thetimes=keyCode(thekeys);
                    [secs  indfirst]=min(thetimes);
                    respTime(trial)=secs;
                end
                
            elseif (eyetime2-pretrial_time)>=trialTimeout
                stim_stop=GetSecs;
                trialTimedout(trial)=1;
                eyechecked=10^4;
            end
            eyefixation5
            
            if ScotomaPresent == 1
                Screen('FillOval', w, scotoma_color, scotoma);
            else
                fixationlength=10;
                Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
                
            end
            
            
            if EyetrackerType==2
                
                if scotomavpixx==1
                    Datapixx('EnableSimulatedScotoma')
                    Datapixx('SetSimulatedScotomaMode',2) %[~,mode = 0]);
                    %Datapixx('SetSimulatedScotomaMode'[,mode = 0]);
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
        if trialTimedout(trial)== 0
            
            foo=(RespType==thekeys);
            
                staircounterVA(mixtrVA(trial))=staircounterVA(mixtrVA(trial))+1;
                ThreshlistVA(staircounterVA(mixtrVA(trial)))=cont;
                if foo(theans(trial))
                    resp = 1;
                    nswr(trial)=1;
                    PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    corrcounterVA(mixtrVA(trial))=corrcounterVA(mixtrVA(trial))+1;
                    if reversalsVA(mixtrVA(trial))<2
                        sc.down=sc.steps(1);
                    elseif reversalsVA(mixtrVA(trial))>= 2
                        sc.down=sc.steps(2);
                    end
                    if corrcounterVA(mixtrVA(trial))==sc.down && staircounterVA(mixtrVA(trial))>sc.down % we don't want to call the first scale down a reversal
                        isreversalsVA(mixtrVA(trial))=1;
                        %  rever(trial)=1;
                        
                    end
                    if corrcounterVA(mixtrVA(trial))==sc.down %&& reversalsVA(mixtrVA(trial))>= 2
                        % non streaking after 3 reversals
                        if isreversalsVA(mixtrVA(trial))==1 %&& ThreshlistVA(staircounterVA(mixtrVA(trial-sc.down)))<ThreshlistVA(staircounterVA(mixtrVA(trial)))
                            if resetcounterVA(mixtrVA(trial))==0
                                reversalsVA(mixtrVA(trial))=reversalsVA(mixtrVA(trial))+1;
                                resetcounterVA(mixtrVA(trial))=1;
                                rever(trial)=1;
                            end
                            isreversalsVA(mixtrVA(trial))=0;
                        end
                        thestep=min(reversalsVA(mixtrVA(trial))+1,length(stepsizesVA));
                        if thestep>length(stepsizesVA)
                            thestep=length(stepsizesVA);
                        end
                        corrcounterVA(mixtrVA(trial))=0;
                        threshVA(mixtrVA(trial))=threshVA(mixtrVA(trial)) +stepsizesVA(thestep);
                        %      threshVA(mixtrVA(trial))=min(threshVA(mixtrVA(trial)),length(Sizelist));
                    end
                    threshVA(mixtrVA(trial))=min(threshVA(mixtrVA(trial)),length(Contlist));
                elseif (thekeys==escapeKey) % esc pressed
                    closescript = 1;
                    if EyetrackerType==2
                        Datapixx('DisableSimulatedScotoma')
                        Datapixx('RegWrRd')
                    end
                    ListenChar(0);
                    break;
                else % wrong response
                    resp = 0;
                    nswr(trial)=0;
                    PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    resetcounterVA(mixtrVA(trial))=0;
                    
                    %  WE DON'T CARE ABOUT UPWARD REVERSALS, but we update 'isreversals' to update staircase
                    if  corrcounterVA(mixtrVA(trial))>=sc.down
                        isreversalsVA(mixtrVA(trial))=1;
                    end

                    corrcounterVA(mixtrVA(trial))=0;
                    % we don't want the step size to change on a wrong response

                    thestep=min(reversalsVA(mixtrVA(trial))+1,length(stepsizesVA));
                    threshVA(mixtrVA(trial))=threshVA(mixtrVA(trial)) -stepsizesVA(thestep);
                    threshVA(mixtrVA(trial))=max(threshVA(mixtrVA(trial)));
                    if threshVA(mixtrVA(trial))<1
                        threshVA(mixtrVA(trial))=1;
                    end
                end
        else
            resp = 0;
            respTime(trial)=0;
            PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
            PsychPortAudio('Start', pahandle);
                            staircounterVA(mixtrVA(trial))=staircounterVA(mixtrVA(trial))+1;
                ThreshlistVA(staircounterVA(mixtrVA(trial)))=cont;
                    nswr(trial)=0;
                    resetcounterVA(mixtrVA(trial))=0;
                                        if reversalsVA(mixtrVA(trial))<2
                        sc.down=sc.steps(1);
                    elseif reversalsVA(mixtrVA(trial))>= 2
                        sc.down=sc.steps(2);
                    end
                    %  WE DON'T CARE ABOUT UPWARD REVERSALS, but we update 'isreversals' to update staircase
                    if  corrcounterVA(mixtrVA(trial))>=sc.down
                        isreversalsVA(mixtrVA(trial))=1;
                    end

                    corrcounterVA(mixtrVA(trial))=0;
                    % we don't want the step size to change on a wrong response
                    thestep=min(reversalsVA(mixtrVA(trial))+1,length(stepsizesVA));
                    threshVA(mixtrVA(trial))=threshVA(mixtrVA(trial)) -stepsizesVA(thestep);
                    threshVA(mixtrVA(trial))=max(threshVA(mixtrVA(trial)));
                    if threshVA(mixtrVA(trial))<1
                        threshVA(mixtrVA(trial))=1;
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
        time_stim(kk) = respTime(trial) - stim_start(trial);
        totale_trials(kk)=trial;
        coordinate(trial).x=theeccentricity_X/pix_deg;
        coordinate(trial).y=theeccentricity_Y/pix_deg;
        xxeye(trial).ics=xeye;
        yyeye(trial).ipsi=yeye;
        vbltimestamp(trial).ix=VBL_Timestamp;
        
        rispo(kk)=resp;
            lettercontrast(kk)=cont;
            tles{kk} = threshVA;
      
            contacorr(trial)=corrcounterVA(mixtrVA(trial));

        
        if exist('thekeys')
            cheis(kk)=thekeys;
        else
            cheis(kk)=99;
            
        end
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
                EyeSummary.(TrialNum).contrast= cont;

            if exist('EndIndex')==0
                EndIndex=0;
            end
            EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
            clear EndIndex
            EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
            EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
            EyeSummary.(TrialNum).TimeStamps.Fixation = stim_start(trial);
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
        
    end
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
    Screen('Flip', w);
    Screen('TextFont', w, 'Arial');
    
    
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
    
    
    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    KbQueueWait;
    ListenChar(0);
    %   Screen('Flip', w);
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
    'There was an error caught in the main program.'
    psychlasterror()
end