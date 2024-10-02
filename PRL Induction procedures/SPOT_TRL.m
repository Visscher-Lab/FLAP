% PRL induction procedure with simulated scotoma, single target
% written by Marcello A. Maniglia 2017/2021

close all; clear; clc;
commandwindow
try
    prompt={'Participant name', 'Assessment day','TRL x coord', 'TRL y coord', 'TRL size (diameter)', 'practice (0) or session (1)',  'eye? left(1) or right(2)','Calibration? yes(1), no(0)',  'Eyetracker(1) or mouse(0)?','response box (1) or keyboard (0)'};
    addpath([cd '/utilities']);
    addpath([cd '/../utilities']); %add folder with utilities files
        addpath([cd '/Functions']);

    name= 'Parameters';
    numlines=1;
    defaultanswer={'SPOT11','1',' -6.5','1', '6','1', '1', '0', '0', '0'};
    
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    expDay=str2num(answer{2,:});
  %  ScotomaPresent= str2num(answer{3,:}); % 0 = no scotoma, 1 = scotoma
PRLx=str2num(answer{3,:}); % x coordinates (in deg) of the TRL
PRLy=str2num(answer{4,:}); % y coordinates (in deg) of the TRL
PRLsize=str2num(answer{5,:});  % diameter of the assigned PRL in degrees of visual angle
    
    Isdemo=str2num(answer{6,:}); % full session or demo/practice
  %  PRLlocations=str2num(answer{6,:});
    TRLnumber=1; %str2num(answer{7,:});  % how many TRLs do we want?
    whicheye=str2num(answer{7,:}); % which eye to track (vpixx only)
    calibration=str2num(answer{8,:}); % do we want to calibrate or do we skip it? only for Vpixx
    EyeTracker = str2num(answer{9,:}); %0=mouse, 1=eyetracker
    responsebox=str2num(answer{10,:});
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    site=3;  % VPixx
    scotomavpixx= 0;
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    
    inductionType = 1; % 1 = assigned, 2 = annulus
    if inductionType ==1
        TYPE = 'Assigned';
    elseif inductionType == 2
        TYPE = 'Annulus';
    end
    if site==1
        baseName=['./data/' SUBJECT '_DAY_' num2str(expday) '_PRL_induction_SingleTarget_' TYPE '_' num2str(scotomadeg) ' deg ' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[cd '\data\' SUBJECT filename filename2  '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[cd '\data\' SUBJECT '_DAY_' num2str(expDay) '_Awareness_TRL_' TYPE   num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    datapixxtime=1;
    
    defineSite % initialize Screen function and features depending on OS/Monitor
    
    CommonParametersInductionSPOT % load parameters for time and space
    
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
    
    % response
    KbName('UnifyKeyNames');
    
    RespType(1) = KbName('h');
    RespType(2) = KbName('s');
    
    
    escapeKey = KbName('ESCAPE');	% quit key
    
    
    %% creating stimuli
    CommonParametersAwareness % this script identifies the size and shape of scotoma for this participant.  If there is an error it is probably because that participant's data has not been put in here yet.
    createO
    
    
    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    end
    %% main loop
    HideCursor(0);
    ListenChar(2);
    counter = 0;
    
    Screen('FillRect', w, gray);
    colorfixation = white;
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
        location =  zeros(length(mixtr), 6);
    elseif EyetrackerType == 2
        %Connect to TRACKPixx3
        Datapixx('Open');
        Datapixx('SetTPxAwake');
        Datapixx('SetupTPxSchedule');
        Datapixx('RegWrRd');
        % %set up recording to start on the same frame flip that shows the image.
        % %We also get the time of the flip using a Marker which saves a time of the
        % %frame flip on the DATAPixx clock
        Datapixx('StartTPxSchedule');
        Datapixx('SetMarker');
        Datapixx('RegWrVideoSync');
    end
    
    
    counterleft=0;
    counterright=0;
    counteremojisize=0;
    for trial=1:trials
        
        TrialNum = strcat('Trial',num2str(trial));
        
        
        trialTimedout(trial)=0; % count trials that trialed-out
        trialonsettime=Jitter(randi(length(Jitter))); % pick a jittered start time for trial
        trialTimeout=effectivetrialtimeout+trialonsettime; % update the max trial duration accounting for the jittered start
        trialonsettime=0; % if we want the stimulus to appear right after fixation has been acquired
        % compute target location
        theeccentricity_X=randdegarray(randi(length(randdegarray)))*pix_deg;
        theeccentricity_Y=randdegarray(randi(length(randdegarray)))*pix_deg;
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
        
            neweccentricity_X=theeccentricity_X;
        neweccentricity_Y=theeccentricity_Y;
        % compute response for trial
        theans(trial)=randi(2);
        
        %Every 50 trials, pause to allow subject to rest eyes
        if (mod(trial,50))==1
            if trial~=1
                Screen('FillRect', w, gray);
                colorfixation = white;
                percentagecompleted= round(trial/trials);
                textSw=sprintf( 'Take a short break and rest your eyes  \n \n You completed %d percent of the session \n \n \n \n Press any key to start', percentagecompleted);
                DrawFormattedText(w, textSw, 'center', 'center', white);
                Screen('Flip', w);
                KbQueueWait;
            end
        end
        
        
        
        FLAPVariablesReset
        nn=0;
        playsound=0;
        if EyetrackerType ==2
            %start logging eye data
            Datapixx('RegWrRd');
            Pixxstruct(trial).TrialStart = Datapixx('GetTime');
            Pixxstruct(trial).TrialStart2 = Datapixx('GetMarker');
        end
        
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
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            if datapixxtime==1     
                Datapixx('RegWrRd');
                eyetime2=Datapixx('GetTime');
            end
            
            
            if  (eyetime2-pretrial_time)>=ITI && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                % forced fixation window
                [fixating counter framecounter ]=IsFixatingSquareNew(wRect,xeye,yeye,fixating,framecounter,counter,fixwindowPix);
                fixationscriptW
            elseif (eyetime2-pretrial_time)>ITI && fixating>=fixTime/ifi && fixating<1000 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                % exit forced fixation when fixation criteria are met
                   if datapixxtime==1
                         Datapixx('RegWrRd');
                    trial_time=Datapixx('GetTime');
                else
                    trial_time=eyetime2;
                end
                if EyetrackerType ==2
                    Datapixx('SetMarker');
                    Datapixx('RegWrVideoSync');
                    %collect marker data
                    Datapixx('RegWrRd');
                    Pixxstruct(trial).TrialOnset = Datapixx('GetMarker');
                end
                fixating=1500;
            end
            
            if (eyetime2-trial_time)>postfixationISI && (eyetime2-pretrial_time)<=trialTimeout && fixating>400 && stopchecking>1 %present stimulus
                %here I present the stimuli+acoustic cue
                
                if exist('stimstar') == 0
                    stim_start(trial)=eyetime2;
                    stimstar=1;
                    stimpresent=1;
                    if EyetrackerType ==2
                        %set a marker to get the exact time the screen flips
                        Datapixx('SetMarker');
                        Datapixx('RegWrVideoSync');
                        %collect marker data
                        Datapixx('RegWrRd');
                        Pixxstruct(trial).TargetOnset = Datapixx('GetMarker');
                        Pixxstruct(trial).TargetOnset2 = Datapixx('GetTime');
                    end
                    
                    if responsebox==1
                        Datapixx('SetMarker');
                        Datapixx('RegWrVideoSync');
                        %collect marker data
                        Datapixx('RegWrRd');
                        stim_startBox2(trial)= Datapixx('GetMarker');
                        stim_startBox(trial)=Datapixx('GetTime');
                    end
                end
                PsychPortAudio('FillBuffer', pahandle, bip_sound' ); % loads data into buffer
                if playsound==0
                    PsychPortAudio('Start', pahandle);
                    playsound=1;
                end
                if theans(trial)==1
                    Screen('DrawTexture', w, Happyface, [], imageRect_offs, [],[], attContr);
                elseif theans(trial)==2
                    Screen('DrawTexture', w, Sadface, [], imageRect_offs, [],[], attContr);
                end
                
                trialTimeout=actualtrialtimeout+(stim_start(end)-pretrial_time(end));
                checktrialstart(trial)=1;
                if responsebox==0
                    if sum(keyCode)~=0
                        thekeys = find(keyCode);
                        thetimes=keyCode(thekeys);
                      if datapixxtime ==0
                          [secs  indfirst]=min(thetimes);
                        stim_stop(trial)=secs;
                      else
                         Datapixx('RegWrRd');
                     stim_stop(trial)=Datapixx('GetTime');
                      end
                        
                        eyechecked=10^4;
                    end
                elseif responsebox==1
                    if (buttonLogStatus.newLogFrames > 0)
                        respTime(trial)=secs;
                        eyechecked=10^4;
                    end
                end
                
            elseif (eyetime2-pretrial_time)>=trialTimeout
                stim_stop(trial)=eyetime2;
                trialTimedout(trial)=1;
                if responsebox==1
                    Datapixx('StopDinLog');
                end
                eyechecked=10^4;
            end
            eyefixation5
            
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
            else
                InductionPRLpatch
         %       Screen('FillOval', w, scotoma_color, scotoma);
                
                                
                imageRect_ScotomaLive =[scotomarect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X_scotoma, scotomarect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y_scotoma,...
                    scotomarect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X_scotoma, scotomarect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y_scotoma];
                
                Screen('DrawTexture', w, texture2, [], imageRect_ScotomaLive, [],[], 1);
                
                
                for iu=1:length(PRLx)
                    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
                        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
                    if visibleCircle ==1
                        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
                    end
                end
            end
            
                 if datapixxtime==1
                Datapixx('RegWrRd');
                eyetime2=Datapixx('GetTime');
                [eyetime3, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
                VBL_Timestamp=[VBL_Timestamp eyetime3];
                datapixx_Timestamp=[datapixx_Timestamp eyetime2];
                dd(length(datapixx_Timestamp))=trial_time;
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
                      if datapixxtime==1
                    trial_time=Datapixx('GetTime');
                else
                    trial_time=eyetime2;
                end
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
            [keyIsDown, keyCode] = KbQueueCheck;
            nn=nn+1;
        end
        
        if trialTimedout(trial)== 0
            foo=(RespType==thekeys);
            if foo(theans(trial))
                resp = 1;
                PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                PsychPortAudio('Start', pahandle);
                if stim_stop(trial) - stim_start(trial)<5
                    respTime=1;
                else
                    respTime=0;
                    counteremojisize=0;
                end
                
                
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                if EyetrackerType==2
                    Datapixx('DisableSimulatedScotoma')
                    Datapixx('RegWrRd')
                end
                ListenChar(0);
                break;
            else
                resp = 0;
                respTime=0;
                PsychPortAudio('FillBuffer', pahandle, errorS' ); % loads data into buffer
                PsychPortAudio('Start', pahandle);
            end
        else
            
            resp = 0;
            respTime=0;
            PsychPortAudio('FillBuffer', pahandle, errorS' ); % loads data into buffer
            PsychPortAudio('Start', pahandle);
        end
        
        %  stim_stop=secs;
        time_stim(kk) = stim_stop(trial) - stim_start(trial);
        totale_trials(kk)=trial;
        %     coordinate(trial).x=ecc_x;
        %    coordinate(trial).y=ecc_y;
        rispoTotal(kk)=resp;
        rispoInTime(kk)=respTime;
        %  distraktor(trial)=distnum;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];
        TGT_x(trial)= theeccentricity_X/pix_deg;
        TGT_y(trial)= theeccentricity_Y/pix_deg;
        
        tutti{trial} =imageRect_offs;
        
        
        if EyeTracker==1
            EyeSummary.(TrialNum).EyeData = EyeData;
            clear EyeData
            if exist('EyeCode')==0
                EyeCode = 888;
            end
            EyeSummary.(TrialNum).EyeData(:,6) = EyeCode';
            clear EyeCode
            if exist('FixIndex')==0
                FixIndex=0;
            end
            if exist('fixind')==0
                fixind=0;
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
            %  EyeSummary(trial).GetFixationInfo.DriftCorrIndices = DriftCorrIndices;
            EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
            EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
            EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
            %FixStamp(TrialCounter,1);
            EyeSummary.(TrialNum).TimeStamps.Stimulus = stim_start(trial);
            EyeSummary.(TrialNum).TimeStamps.Response = stim_stop(trial);
            EyeSummary.(TrialNum).StimulusSize=imsize;
            EyeSummary.(TrialNum).Target.App = showtarget;
            EyeSummary.(TrialNum).Target.counter=countertarget;
            EyeSummary.(TrialNum).Target.FixInd=fixind;
            EyeSummary.(TrialNum).Target.Fixframe=framefix;
            EyeSummary.(TrialNum).PRL.x=PRLx;
            EyeSummary.(TrialNum).PRL.y=PRLy;
            EyeSummary.(TrialNum).targetlocation =targetlocation;
            %StimStamp(TrialCounter,1);
            clear ErrorInfo
            %    fliptime(trial)=[VBL_Timestamp];
            %thresharray(kk)=tresh;
        end
        
        kk=kk+1;
        
        %
        %             if trial==100 | 200 | 300 | 400 | 500 | 600 | 700
        %             save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|ax|ay|xxx|yyyy|circle|azimuths|corrS|errorS|Allimg)$).');
        %             end;
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
        if (mod(trial,100))==1
            if trial==1
            else
                save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
            end
        end
        
        if closescript==1
            break;
        end
        
    end
    
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
    if trial>1
        comparerisp=[rispoTotal' rispoInTime']; %Marcello - is this for debugging/needed for anything? % it's just a quick summary of the response (correct/incorrect) and the RT per trial
    end
    c=clock;
    TimeSop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
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
        Datapixx('StopTPxSchedule');
        Datapixx('RegWrRd');
        finish_time = Datapixx('GetTime');
        Datapixx('SetTPxSleep');
        Datapixx('RegWrRd');
        Datapixx('Close');
    end
    
    KbQueueWait;
    ListenChar(0);
    %   Screen('Flip', w);
    ShowCursor;
    Screen('CloseAll');
    Screen('Preference', 'SkipSyncTests', 0);
    
    
catch ME
    psychlasterror()
end