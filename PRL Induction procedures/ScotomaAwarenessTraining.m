% Exogenous/endogenous switch task
% written by Marcello A. Maniglia August 2022
close all;
clear all;
clc;
commandwindow

addpath([cd '/utilities']);
try
    prompt={'Participant name', 'day','scotoma active','scotoma Vpixx active', 'demo (0) or session (1)',  'eye? left(1) or right(2)', 'Calibration? yes (1), no(0)'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '1','0', '0','2','0' };
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    expDay=str2num(answer{2,:});
    site= 3  %0; 1=bits++; 2=display++
    ScotomaPresent= str2num(answer{3,:}); % 0 = no scotoma, 1 = scotoma
    scotomavpixx= str2num(answer{4,:});
    Isdemo=str2num(answer{5,:}); % full session or demo/practice
    whicheye=str2num(answer{6,:}); % which eye to track (vpixx only)
    calibration=str2num(answer{7,:}); % do we want to calibrate or do we skip it? only for Vpixx
    
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a data folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    
    if Isdemo==0
        filename='_carrasco_practice';
    elseif Isdemo==1
        filename='_carrasco';
    end
    
    if site==1
        baseName=['./data/' SUBJECT filename  '_' expDay num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[cd '\data\' SUBJECT filename '_'  num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[cd '\data\' SUBJECT filename 'Pixx_'  num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    EyeTracker = 1; %0=mouse, 1=eyetracker
    

    

    defineSite % initialize Screen function and features depending on OS/Monitor
    
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
CommonParametersAwareness
    createO
    


    %% trial matrixc
    
    trials=50;
    mixtr=[ones(trials,1) ones(trials,1)];
    
    if Isdemo==0
        mixtr=mixtr(1:5,:); % if it's practice time, just assign random mixtr combination
    end
    
    totalmixtr=trials;
    %% response
    
    KbName('UnifyKeyNames');
    
    RespType(1) = KbName('h');
    RespType(2) = KbName('s');

     
    escapeKey = KbName('ESCAPE');	% quit key
    
    
    deviceIndex = -1; % reset to default keyboard
    [k_id, k_name] = GetKeyboardIndices();
    for i = 1:numel(k_id)
        if strcmp(k_name{i},'Dell Dell USB Keyboard') % unique for your device, check the [k_id, k_name]
            deviceIndex =  k_id(i);
        elseif  strcmp(k_name{i},'Apple Internal Keyboard / Trackpad')
            deviceIndex =  k_id(i);
        end
    end
    KbQueueCreate(deviceIndex);
    KbQueueStart(deviceIndex);
    
    if EyetrackerType==1
        eyelinkCalib % calibrate eyetracker, if Eyelink
    end
    
    %% main loop
    HideCursor;
    ListenChar(2);
    counter = 0;
    WaitSecs(1);
   
    Screen('FillRect', w, gray);
    DrawFormattedText(w, 'Report whether the emoji is (h)appy or (s)ad by pressing the corresponding key \n \n \n \n Press any key to start', 'center', 'center', white);
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
    
    
    
    for trial=1:totalmixtr
        trialTimedout(trial)=0; % count trials that trialed-out
        TrialNum = strcat('Trial',num2str(trial));
        trialonsettime=Jitter(randi(length(Jitter))); % pick a jittered start time for trial
        trialTimeout=effectivetrialtimeout+trialonsettime; % update the max trial duration accounting for the jittered start
        trialonsettime=0; % if we want the stimulus to appear right after fixation has been acquired
        % compute target location
        theeccentricity_X=randdegarray(randi(length(randdegarray)))*pix_deg;
        theeccentricity_Y=randdegarray(randi(length(randdegarray)))*pix_deg;
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];

        
        % compute response for trial
        theans(trial)=randi(2);
       
        
                Priority(0);
        KbQueueFlush()
FLAPVariablesReset
        while eyechecked<1
            
%             if ScotomaPresent == 1
%                 fixationscriptW
%             end
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            
            if  (eyetime2-pretrial_time)>=0 && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
             %   IsFixatingSquare % check for the eyes to stay in the fixation window for enough (fixTime) frames
                                [fixating counter framecounter ]=IsFixatingSquareNew(wRect,xeye,yeye,fixating,framecounter,counter,fixwindowPix);

                if ScotomaPresent == 1
                    fixationscriptW
                end
            elseif (eyetime2-pretrial_time)>ifi && fixating>=fixTime/ifi && stopchecking>1 && fixating<1000 && (eyetime2-pretrial_time)<=trialTimeout
                trial_time = GetSecs;
                fixating=1500;                
                clear imageRect_offs
            end
            
if (eyetime2-trial_time)>=trialonsettime && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout  && (keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)) ==0
                % show target
                if exist('imageRect_offs')==0
                    imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
                        imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
                    imageRect_offscircle=[imageRect_offs(1)-(0.635*pix_deg) imageRect_offs(2)-(0.635*pix_deg) imageRect_offs(3)+(0.635*pix_deg) imageRect_offs(4)+(0.635*pix_deg) ];
                    stim_start=eyetime2;
                end
                if theans(trial)==1
                    Screen('DrawTexture', w, theHappyface, [], imageRect_offs, [],[], attContr);
                elseif theans(trial)==2
                    Screen('DrawTexture', w, theSadface, [], imageRect_offs, [],[], attContr);
                end
            elseif (eyetime2-trial_time)>=trialonsettime && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout  && (keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)) ~=0
                % if a response has been produced
                thekeys = find(keyCode);
                if length(thekeys)>1
                    thekeys=thekeys(1);
                end
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
                respTime=secs;
                                eyechecked=10^4;


            elseif (eyetime2-pretrial_time)>=trialTimeout % trial timed out
                stim_stop=GetSecs;
                trialTimedout(trial)=1;
                eyechecked=10^4;
            end
            eyefixation5
            
            if ScotomaPresent == 1              
                
                  imageRect_ScotomaLive =[scotomarect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X_scotoma, scotomarect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y_scotoma,...
                        scotomarect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X_scotoma, scotomarect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y_scotoma];

           %     Screen('FillOval', w, scotoma_color, scotoma);
                                    Screen('DrawTexture', w, texture2, [], imageRect_ScotomaLive, [],[], 1);
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
            % eyetracker fixation calcuation
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
        
        % response processing
        if trialTimedout(trial)== 0
            
            foo=(RespType==thekeys);
            
            if foo(theans(trial))
                resp = 1;
                PsychPortAudio('Start', pahandle1);
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                break;
            else
                resp = 0;
                PsychPortAudio('Start', pahandle2);
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
        
        if exist('stim_start')==0
            stim_start=0;
            stimnotshowed(trial)=99;
        end
        time_stim(kk) = respTime - stim_start;
        totale_trials(kk)=trial;
        coordinate(trial).x=theeccentricity_X/pix_deg;
        coordinate(trial).y=theeccentricity_Y/pix_deg;
        xxeye(trial).ics=xeye;
        yyeye(trial).ipsi=yeye;
        vbltimestamp(trial).ix=VBL_Timestamp;
        rispo(kk)=resp;
        
        correx(kk)=resp;
        if exist('imageRect_offs')
            SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
        end
        Att_RT(kk) = respTime - stim_start;
        
        if exist('thekeys')
            ks(kk)=thekeys;
        else
            ks(kk)=99;
            
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
            if exist('EndIndex')==0
                EndIndex=0;
            end
            EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
            clear EndIndex
            EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
            EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
            EyeSummary.(TrialNum).TimeStamps.Fixation = stim_start;
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
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    Screen('Flip', w);
    KbQueueWait;
    
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