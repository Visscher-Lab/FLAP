% Pre-FLAP fixation training
% written by Marcello A. Maniglia May 2023
close all;
clear all;
clc;
commandwindow

addpath([cd '/utilities']);
try
    prompt={'Participant name', 'day','scotoma active', 'demo (0) or session (1)',  'eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '1', '1','2','0', '1' };
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    expDay=str2num(answer{2,:});
    site= 3;  %0; 1=bits++; 2=display++
    ScotomaPresent= str2num(answer{3,:}); % 0 = no scotoma, 1 = scotoma
    Isdemo=str2num(answer{4,:}); % full session or demo/practice
    whicheye=str2num(answer{5,:}); % which eye to track (vpixx only)
    calibration=str2num(answer{6,:}); % do we want to calibrate or do we skip it? only for Vpixx
    EyeTracker = str2num(answer{7,:}); %0=mouse, 1=eyetracker
        scotomavpixx= 0;
    responsebox=0;
    datapixxtime=0;
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a data folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    
    if Isdemo==0
        filename='_fixationpre_practice';
    elseif Isdemo==1
        filename='_fixationpre';
    end
    
    if site==1
        baseName=['./data/' SUBJECT filename  '_' expDay num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[cd '\data\' SUBJECT filename '_'  num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site>2
        baseName=[cd '\data\' SUBJECT filename 'Pixx_'  num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    defineSite % initialize Screen function and features depending on OS/Monitor
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
    %% creating stimuli
    CommonParametersFixationtraining
    createO    
    %% trial matrixc
    
    trials=5;
    % fullfact([length(fixTime_values) length(fixwindow_values)])
    %  mixtr=[ones(trials,1) ones(trials,1);];
    mixtr= fullfact([length(fixTime_values) length(fixwindow_values)]);
      
    newmixtr=[];
    for ui=1:length(mixtr)
        tempm=repmat(mixtr(ui,:),trials,1);
        newmixtr=[newmixtr; tempm];
    end
    
    mixtr=newmixtr;
    if Isdemo==0
        mixtr=mixtr(1:5,:); % if it's practice time, just assign random mixtr combination
       mixtr=mixtr(end-4:end,:);
 end   
    totalmixtr=length(mixtr);    
    if EyetrackerType==1
        eyelinkCalib % calibrate eyetracker, if Eyelink
    end
    
    %% main loop
    HideCursor;
    ListenChar(2);
    counter = 0;
    WaitSecs(1);
    
    Screen('FillRect', w, gray);
    DrawFormattedText(w, 'Keep the circle in the box until you hear the completion sound \n \n \n \n Press any key to start', 'center', 'center', white);
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
     %   trialonsettime=Jitter(randi(length(Jitter))); % pick a jittered start time for trial
   %     trialTimeout=effectivetrialtimeout+trialonsettime; % update the max trial duration accounting for the jittered start
        trialonsettime=0; % if we want the stimulus to appear right after fixation has been acquired
       % compute target location
        theeccentricity_X=randdegarray(randi(length(randdegarray)))*pix_deg;
        theeccentricity_Y=randdegarray(randi(length(randdegarray)))*pix_deg;
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
        %mask background for the stimulus (when we want to present a
        %stimulus)
        imageRect_offscircle=[imageRect_offs(1)-(0.635*pix_deg) imageRect_offs(2)-(0.635*pix_deg) imageRect_offs(3)+(0.635*pix_deg) imageRect_offs(4)+(0.635*pix_deg) ];
        
        % compute response for trial
                % compute response for trial
        theoris =[-180 0 -90 90];
        theans(trial)=randi(4);
        ori=theoris(theans(trial));      
 
        fixwindowPix=fixwindow_values(mixtr(trial,2))*pix_deg;        
        fixTime=fixTime_values(mixtr(trial,1));
               trialTimeout=fixTime*5;
               if fixwindowPix/pix_deg<1.5
                                  trialTimeout=fixTime*6;
               end
        Priority(0);
        KbQueueFlush()
        FLAPVariablesReset
        onsett=0;
        
                if mod(trial,round(length(mixtr)/3))==0
            interblock_instruction
        end
        while eyechecked<1
            
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            
            if  (eyetime2-pretrial_time)>=ITI && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                %   IsFixatingSquare % check for the eyes to stay in the fixation window for enough (fixTime) frames
                [fixating counter framecounter ]=IsFixatingSquareNew(wRect,xeye,yeye,fixating,framecounter,counter,fixwindowPix);
                if onsett==0
                    if EyetrackerType ==2
                        Datapixx('SetMarker');
                        Datapixx('RegWrVideoSync');
                        %collect marker data
                        Datapixx('RegWrRd');
                        Pixxstruct(trial).Trialstart = Datapixx('GetMarker');
                        Pixxstruct(trial).Trialstart2 = Datapixx('GetTime');
                        
                    end
                    trial_start=eyetime2;
                    onsett=1;
                end
                if ScotomaPresent == 1
                    fixationscriptWtraining
                end
                if keyCode(escapeKey)>0
                    closescript = 1;
                    eyechecked=10^4;
                end
                
                if  (eyetime2-pretrial_time)>=2 && trial>10 
                    Screen('FillOval',w, gray,imageRect_offscircle); % lettera a sx del target
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], 1 );
                end
            elseif (eyetime2-pretrial_time)>ifi && fixating>=fixTime/ifi && stopchecking>1 && fixating<10000 && (eyetime2-pretrial_time)<=trialTimeout
                trial_time = eyetime2;
                if EyetrackerType ==2
                    Datapixx('SetMarker');
                    Datapixx('RegWrVideoSync');
                    %collect marker data
                    Datapixx('RegWrRd');
                    Pixxstruct(trial).Trialend = Datapixx('GetMarker');
                    Pixxstruct(trial).Trialend2 = Datapixx('GetTime');
                end
                clear imageRect_offs
                fixating=15000;
                PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                PsychPortAudio('Start', pahandle);
                completedtrial(trial)=1;
                eyechecked=10^4;
                framesoffixation(trial)=fixating;
            elseif (eyetime2-pretrial_time)>trialTimeout
                trial_time = eyetime2;
                if EyetrackerType ==2
                    Datapixx('SetMarker');
                    Datapixx('RegWrVideoSync');
                    %collect marker data
                    Datapixx('RegWrRd');
                    Pixxstruct(trial).Trialend = Datapixx('GetMarker');
                    Pixxstruct(trial).Trialend2 = Datapixx('GetTime');
                end
                clear imageRect_offs
                                completedtrial(trial)=0;
                fixating=15000;
                PsychPortAudio('FillBuffer', pahandle, errorS' ); % loads data into buffer
                PsychPortAudio('Start', pahandle);
                eyechecked=10^4;
                
            end
            
            eyefixation5
            
            if ScotomaPresent == 1
                
                imageRect_ScotomaLive =[scotomarect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X_scotoma, scotomarect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y_scotoma,...
                    scotomarect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X_scotoma, scotomarect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y_scotoma];
                
                %     Screen('FillOval', w, scotoma_color, scotoma);
                %          Screen('DrawTexture', w, texture2, [], imageRect_ScotomaLive, [],[], 1);
                Screen('FillOval', w, scotoma_color, imageRect_ScotomaLive);
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
        
        time_stim(kk) = trial_time - trial_start;
        totale_trials(kk)=trial;
        coordinate(trial).x=theeccentricity_X/pix_deg;
        coordinate(trial).y=theeccentricity_Y/pix_deg;
        xxeye(trial).ics=xeye;
        yyeye(trial).ipsi=yeye;
        vbltimestamp(trial).ix=VBL_Timestamp;
        
        if exist('imageRect_offs')
            SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
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
            EyeSummary.(TrialNum).TimeStamps.Fixation = trial_start;
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
        if (mod(trial,50))==1
            if trial==1
            else
                save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
                tx(trial)=99;
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