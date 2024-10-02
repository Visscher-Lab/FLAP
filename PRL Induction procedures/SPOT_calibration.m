% Visual Acuity/Crowding/cued-uncued attention task
% written by Marcello A. Maniglia july 2021 %2017/2021
close all;
clear;
clc;
commandwindow
%addpath('/Users/sll/Desktop/Flap/Flap_scripts/utilities')


addpath([cd '/utilities']);
try
%    prompt={'Participant name', 'Assessment day','site? UCR eyelink (1), UAB eyelink (2), Vpixx(3)','scotoma old mode active','scotoma Vpixx active', 'demo (0) or session (1)', 'Locations: (2) or (4)',  'eye? left(1) or right(2)','Calibration? yes (1), no(0)', 'Task: acuity (1), crowding (2), exo attention (3), contrast (4)'};
     prompt={'Participant name', 'Assessment day','scotoma old mode active', 'practice (0) or session (1)', 'Locations: (2) or (4)',  'eye? left(1) or right(2)','Calibration? yes (1), no(0)', 'Task: acuity (1), crowding (2), exo attention (3), contrast (4)'};
   
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1',  '1', '1', '2', '2', '0', '1' };
    
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    expDay=str2num(answer{2,:});
    ScotomaPresent= str2num(answer{3,:}); % 0 = no scotoma, 1 = scotoma
    
    IsPractice=str2num(answer{4,:}); % full session or demo/practice
    PRLlocations=str2num(answer{5,:});
    whicheye=str2num(answer{6,:}); % which eye to track (vpixx only)
    calibration=str2num(answer{7,:}); % do we want to calibrate or do we skip it? only for Vpixx
    whichTask=str2num(answer{8,:}); % acuity (1), crowding (2), exo attention (3)
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    site=3;  % VPixx
    scotomavpixx= 0;
    
    if exist('data')==0
        mkdir('data')
    end
    

        filename='SPOT_calibration';

    
    if IsPractice==0
        filename2=' practice';
    elseif IsPractice==1
        filename2='';
    end
    
    if site==1
        baseName=['./data/' SUBJECT filename filename2 '_' num2str(PRLlocations) '_' expDay num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[cd '\data\' SUBJECT filename filename2 '_' num2str(PRLlocations) '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[cd '\data\' SUBJECT filename filename2 'Pixx_' num2str(PRLlocations) '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    EyeTracker = 1; %0=mouse, 1=eyetracker
    
    defineSite % initialize Screen function and features depending on OS/Monitor
    
    CommonParametersACA % load parameters for time and space
    
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
    
  
    %% Keys definition/kb initialization
    
    KbName('UnifyKeyNames');
  
    RespType(1) = KbName('c'); % take coordinates 
    RespType(2) = KbName('m'); %recalibrate
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
  
    if IsPractice==0
        mixtr=mixtr(1:practicetrials,:);
    end
    
    %% main loop
    HideCursor;
    ListenChar(2);
    counter = 0;
    
    Screen('FillRect', w, gray);
    DrawFormattedText(w, '\n \n \n \n Press any key to start', 'center', 'center', white);
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

   
       imageRect = CenterRect([0, 0, stimulussize stimulussize], wRect);
       %     coordx= [0 -8 -5 -3 -2 -1 0 1 2 3 5 8];
       %     coordy= [0 -8 -5 -3 -2 -1 0 1 2 3 5 8];
            xcord=[-8 0 8];
premat=fullfact([3 3]);
coordmat= xcord(premat);

    for trial=1:length(fixtype)
        
        countSamples=0;
        fixboxx=coordmat(trial,1);
        fixboxy=coordmat(trial,2);

        trialTimedout(trial)=0;
        TrialNum = strcat('Trial',num2str(trial));
        if trial==1
                interblock_instruction_calibrtion

        end
        
        if mod(trial,tr_per_condition+1)==0 && trial~= length(mixtr)
            interblock_instruction
        end
        
        theeccentricity_X=eccentricity_X(mixtr(trial,1));
        theeccentricity_Y=eccentricity_Y(mixtr(trial,1));
        %  destination rectangle for the fixation dot
        imageRect_offs_dot=[imageRectDot(1)+theeccentricity_X, imageRectDot(2)+theeccentricity_Y,...
            imageRectDot(3)+theeccentricity_X, imageRectDot(4)+theeccentricity_Y];
        
            trialTimeout=realtrialTimeout;

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
            if (eyetime2-pretrial_time)>ifi*35 && (eyetime2-pretrial_time)<ifi*65 && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1))+ keyCode(escapeKey) ==0
                fixationscriptSpot
            elseif  (eyetime2-pretrial_time)>=ifi*65 && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout && sum(keyCode) ==0
                if site<3
                    IsFixatingSquare
                elseif site==3
                    IsFixating4pixx
                end
                if exist('starfix')==0
                    startfix=GetSecs;
                    starfix=98;
                end
                    fixationscriptSpot
            elseif (eyetime2-pretrial_time)>=ifi*65 && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout && sum(keyCode) ~=0               
                fixationscriptWGoogle
               
                 thekeys = find(keyCode);

                 if thekeys==RespType(1)
                     countSamples=countSamples+1;
                eyenowx(totaltrial,countSamples)=newsamplex;
                eyenowy(totaltrial,countSamples)=newsampley;
                respTime=GetSecs;
                 elseif thekeys==RespType(2)
                
                                eyechecked=2;                            
                 elseif thekeys==escapeKey % esc pressed
                    closescript = 1;
                    break;
                end
                PsychPortAudio('Start', pahandle1);                
            elseif (eyetime2-pretrial_time)>trialTimeout
                eyechecked=2;               
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
                    %Datapixx('SetSimulatedScotomaMode'[,mode = 0]);
                    scotomaradiuss=round(pix_deg*6);
                    Datapixx('SetSimulatedScotomaRadius',scotomaradiuss) %[~,mode = 0]);                   
                    mode=Datapixx('GetSimulatedScotomaMode');
                    status= Datapixx('IsSimulatedScotomaEnabled');
                    radius= Datapixx('GetSimulatedScotomaRadius');                   
                end
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
                if EyeData(1)<8000 && stopchecking<0
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
      
        
        
        time_stim(kk) = respTime(trial) - stim_start(trial);
        totale_trials(kk)=trial;
        coordinate(trial).x=theeccentricity_X/pix_deg;
        coordinate(trial).y=theeccentricity_Y/pix_deg;
        xxeye(trial).ics=xeye;
        yyeye(trial).ipsi=yeye;
        vbltimestamp(trial).ix=VBL_Timestamp;
        
        rispo(kk)=resp;

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
            if whichTask==1
                EyeSummary.(TrialNum).VA= VAsize;
            elseif whichTask==2
                EyeSummary.(TrialNum).Separation = sep;
            elseif whichTask==3
            end
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
        if EyetrackerType==2
            %read in eye data
            Datapixx('RegWrRd');
            status = Datapixx('GetTPxStatus');
            toRead = status.newBufferFrames;
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
%         elseif caliblock==1
%             trial=trial-1;
            % caliblock=0;
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
        Datapixx('StopTPxSchedule');
        Datapixx('RegWrRd');
        finish_time = Datapixx('GetTime');
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
    
    
    figure
    hold on
    scatter(coordmat(:,1), coordmat(:,2), 'filled', 'r');
    hold on
    scatter(eyenowx, eyenowy, 'filled', 'b');
    xlim([-20 20])
    ylim([-20 20])
    title ([baseName 'calibration']);
    
    
    
    
    
    
    for ui=1:length(eyenowx)
        dist_diff(ui,1)=eyenowx(ui)-coordmat(ui,1);
        dist_diff(ui,2)=eyenowy(ui)-coordmat(ui,2);
    end



for ui=1:length(coordinates)
[theta,rho] = cart2pol(dist_diff(ui,1),dist_diff(ui,2));

radialDist(ui)=rho;
clear rho
end



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