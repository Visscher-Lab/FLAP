% MNRead task
% written by Marcello A. Maniglia October 2022 %2017/2022
close all; clear; clc;
commandwindow


addpath([cd '/utilities']);
try
%     participantAssignmentTable = fullfile(cd, ['..\..\datafolder\ParticipantAssignmentsUCR_corr.csv']); % this is set for UCR or UAB separately (This is set here so that definesite.m does not have to change)
    participantAssignmentTable = fullfile(cd, ['..\..\datafolder\ParticipantAssignmentsUAB_corr.csv']); % uncomment this if running task at UAB
    
    prompt={'Participant name', 'day', 'demo (0) or session (1)', 'Calibration(1), Validation (2), or nothing(0)'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '0','1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    temp= readtable(participantAssignmentTable);
    SUBJECT = answer{1,:}; %Gets Subject Name
    expDay =str2num(answer{2,:});
    tt = temp(find(contains(temp.participant,SUBJECT)),:); % if computer doesn't have excel it reads as a struct, else it reads as a table
    site = 3;  %0; 1=bits++; 2=display++
    ScotomaPresent= str2num(tt.ScotomaPresent{1,1}); % 0 = no scotoma, 1 = scotoma
    scotomavpixx = 0;
    controlMD = 1;
    Isdemo=str2num(answer{3,:}); % full session or demo/practice
    if strcmp(tt.WhichEye{1,1},'R') == 1 % are we tracking left (1) or right (2) eye? Only for Vpixx
        whicheye = 2;
    else
        whicheye = 1;
    end
    calibration=str2num(answer{4,:}); % do we want to calibrate or do we skip it? only for Vpixx
    EyeTracker = 1; %0=mouse, 1=eyetracker
    
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    
    if Isdemo==0
        filename='_FLAPMNReadpractice';
    elseif Isdemo==1
        filename='_FLAPMNRead';
    end
    folderchk=cd;
    DAY=['\Assessment\Day' answer{2,:} '\'];
    folder=fullfile(folderchk, ['..\..\datafolder\' SUBJECT DAY]);
    if exist(fullfile(folderchk, ['..\..\datafolder\' SUBJECT DAY])) == 0
        mkdir(folder);
    end
    
    if site==1
        baseName=[folder SUBJECT filename '_' expDay num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[folder SUBJECT filename '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[folder SUBJECT filename 'Pixx_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    datapixxtime = 1;
    responsebox = 0;
    defineSite % initialize Screen function and features depending on OS/Monitor
    CommonParametersMNRead % load parameters for time and space
    if controlMD==2
        scotomadeg=0.2;
        scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
        scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
    end
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
    
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    %% Keys definition/kb initialization
    
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
    
    
    %% creating stimuli
    createMNRead
    %% Keys definition/kb initialization
    
    KbName('UnifyKeyNames');
    
    RespType(1) = KbName('LeftArrow');
    RespType(2) = KbName('RightArrow');
    RespType(3) = KbName('UpArrow');
    RespType(4) = KbName('DownArrow');
    escapeKey = KbName('ESCAPE');	% quit key
    
    corrkey=RespType(1);
    wrongkey=RespType(2);
    
    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    end
    
    %% main loop
    HideCursor(0);
    counter = 0;
    
    %%
    
    DrawFormattedText(w, 'Reading test  \n \n \n \n Press any key to start', 'center', 'center', white);
    Screen('Flip', w);
    KbWait;
    WaitSecs(1.5);
    
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
    
    for trial=1:length(mixtr)
        
        
        TrialNum = strcat('Trial',num2str(trial));
        FLAPVariablesReset
        if EyetrackerType ==2
            %start logging eye data
            Datapixx('RegWrRd');
            Pixxstruct(trial).TrialStart = Datapixx('GetTime');
            Pixxstruct(trial).TrialStart2 = Datapixx('GetMarker');
        end
        while eyechecked<1
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            if (eyetime2-trial_time)>0 && (eyetime2-trial_time)<prefixationsquare+ifi
                if fixat==1
                    Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                    Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
                end
                
            elseif (eyetime2-trial_time)>=prefixationsquare+ifi*3 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0 %present stimulus
                
                if exist('stimstar')==0
                    stim_start=GetSecs;
                    if EyetrackerType ==2
                        Datapixx('SetMarker');
                        Datapixx('RegWrVideoSync');
                        %collect marker data
                        Datapixx('RegWrRd');
                        Pixxstruct(trial).TrialOnset = Datapixx('GetMarker');
                    end
                    stimstar=1;
                end
                %Draw Target
                Screen('DrawTexture', w, TheSentence(trial), [], [], 0 ,0);
                
                
            elseif (eyetime2-trial_time)>=prefixationsquare+ifi*5 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)~= 0 %wait for response
                
                stim_stop=GetSecs;
                thekeys = find(keyCode);
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
                
                eyechecked=10^4;
                % code the response
                
                if thekeys==corrkey
                    resp = 1;
                elseif (thekeys==escapeKey) % esc pressed
                    resp=-1;
                    closescript = 1;
                    %   break;
                elseif thekeys==wrongkey
                    resp = 0;
                    closescript = 1;
                end
                
                %    toc
                %   disp('noise')
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
                Screen('FillRect', w, white);
            else
                Screen('FillOval', w, scotoma_color, scotoma);
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
            else
                if stopchecking<0
                    trial_time = eyetime2; %start timer if we have eye info
                    stopchecking=10;
                end
            end
            [keyIsDown, keyCode] = KbQueueCheck;
        end
        
        if resp == 1
            PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
            PsychPortAudio('Start', pahandle);
        end
        Screen('Flip',w);
        WaitSecs(0.5)
        
        if thekeys~=wrongkey && thekeys~=escapeKey
            clear thekeys
            KbQueueFlush()
            [keyIsDown, keyCode] = KbQueueCheck;
            %            DrawFormattedText(w, '++++++++++++++++', 'center', 'center', white);
            DrawFormattedText(w, '++++++++++++++++', 'center', 'center', [0 0 0]);
            
            Screen('Flip',w);
            while sum(keyCode)==0
                [keyIsDown, keyCode] = KbQueueCheck;
                WaitSecs(0.001);
            end
            thekeys = find(keyCode);
            if thekeys==escapeKey
                Screen('Flip',w);
                save(baseName)
                closescript = 1;
                %     return;
            elseif thekeys==wrongkey
                %                DrawFormattedText(w, 'Press a key to exit', 'center', 'center', white);
                DrawFormattedText(w, 'Press a key to exit', 'center', 'center', [0 0 0]);
                
                Screen('Flip',w);
                save(baseName)
                closescript = 1;
                %    return
            else thekeys~=wrongkey && thekeys~=escapeKey
                err=KbName(thekeys);
            end
            
            
        elseif thekeys==wrongkey
            DrawFormattedText(w, 'Press a key to exit', 'center', 'center', white);
            Screen('Flip',w);
            save(baseName)
            closescript = 1;
        else
            Screen('Flip',w);
            save(baseName)
            closescript = 1;
        end
        
        time_stim(kk) = stim_stop - stim_start;
        total_trials(kk)=trial;
        
        cheiz(kk)=thekeys;
        rispo(kk)=resp;
        poke(trial)=TheSentence(trial);
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];
        if err>1
            err=err(1);
        end
        theerrors(kk)=err;
        
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
            
            EyeSummary.(TrialNum).EventData = EvtInfo;
            clear EvtInfo
            EyeSummary.(TrialNum).ErrorData = ErrorData;
            clear ErrorData
            EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
            EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
            EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
            EyeSummary.(TrialNum).TimeStamps.Stimulus = stim_start;
            EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;
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
        kk=kk+1;
        clear PKnew2
        if closescript==1
            break
            %return
        end
        
    end
    
    DrawFormattedText(w, 'Task completed', 'center', 'center', white);
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    ListenChar(0);
    KbQueueWait;
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
    Screen('Flip', w);
    Screen('TextFont', w, 'Arial');
    
    
    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    
    KbQueueWait;
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
        %     PsychPortAudio('Close', pahandle);
    end
    
    
    %% data analysis (to be completed once we have the final version)
    
    
    %to get each scale in a matrix (as opposite as Threshlist who gets every
    %trial in a matrix)
    %thresho=permute(Threshlist,[3 1 2]);
    
    %to get the final value for each staircase
    %  final_threshold=thresho(numel(thresho(:,:,1)),1:length(thresho(1,:,1)),1:length(thresho(1,1,:)));
    %total_thresh= [final_threshold(:,:,1) final_threshold(:,:,2)];
    %%
    %save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|ax|ay|xxx|yyyy|circle|azimuths|corrS|errorS|Allimg)$).');
    
    
catch ME
    psychlasterror()
end