% FLAP Attention task via RSVP streams on 4 peripheral locations
% Marcello Maniglia 1/25/2023

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
    defaultanswer={'test','1', '3', '1','0', '1', '2', '2', '0', '1' };
    
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
        filename=' RSVP_practice';
    elseif Isdemo==1
        filename='RSVP';
    end
    
    if site==1
        baseName=['./data/' SUBJECT filename  '_' num2str(PRLlocations) '_' expDay num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[cd '\data\' SUBJECT filename  '_' num2str(PRLlocations) '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[cd '\data\' SUBJECT filename  'Pixx_' num2str(PRLlocations) '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    EyeTracker = 1; %0=mouse, 1=eyetracker
    
    defineSite % initialize Screen function and features depending on OS/Monitor
    
    CommonParametersRSVP % load parameters for time and space
    
    load  RSVPmxII.mat
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
    
    %  whichLetter={theDot theCircles theLetter theArrow};
    whichLetter(1)=theCircles;
    whichLetter(2)=theCircles;
    whichLetter(3)=theLetter;
    whichLetter(4)=theArrow;
    
    %1= C stays on screen until response
    %2= foil
    %3= target
    %4=cue
    %5= blank
    %post cuie blank
    %% STAIRCASES:
    %mixtr to be created
    %% Keys definition/kb initialization
    
    KbName('UnifyKeyNames');
    
    RespType(1) = KbName('LeftArrow');
    RespType(2) = KbName('RightArrow');
    RespType(3) = KbName('UpArrow');
    RespType(4) = KbName('DownArrow');
    RespType(5) = KbName('c'); % continue with study
    RespType(6) = KbName('m'); %recalibrate
    RespType(7) = KbName('w'); %foil 'wrong' response
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
    
    if Isdemo==0
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
    
    theans=nan(length(mixtr), 39);
    contresp=zeros(length(mixtr), 39);
    
    for trial=1:length(mixtr)
        trialTimedout(trial)=0;
        TrialNum = strcat('Trial',num2str(trial));
        
        stopblock=0;
        if  mod(trial,25)==0
            stopblock=1;
        end
        if mod(trial,(length(mixtr)+1)/6)==0 && trial~= length(mixtr)
            interblock_instruction
        end
        
        theeccentricity_X=eccentricity_X(mixtr(trial,1));
        theeccentricity_Y=eccentricity_Y(mixtr(trial,1));
        
        trialTimeout=realtrialTimeout;
        
        array_of_events=trialArray{trial};
        number_of_events=0;
        clear time_of_this_event
        
        % TRL locations
        imageRect_circleoffs1=[imageRectcircles(1)+eccentricity_X(1), imageRectcircles(2)+eccentricity_Y(1),...
            imageRectcircles(3)+eccentricity_X(1), imageRectcircles(4)+eccentricity_Y(1)];
        imageRect_circleoffs2=[imageRectcircles(1)+eccentricity_X(2), imageRectcircles(2)+eccentricity_Y(2),...
            imageRectcircles(3)+eccentricity_X(2), imageRectcircles(4)+eccentricity_Y(2)];
        imageRect_circleoffs3=[imageRectcircles(1)+eccentricity_X(3), imageRectcircles(2)+eccentricity_Y(3),...
            imageRectcircles(3)+eccentricity_X(3), imageRectcircles(4)+eccentricity_Y(3)];
        
        % compute response for trial
        theoris =[-180 0 -90 90];
        
        
        FLAPVariablesReset
        if EyetrackerType ==2
            %start logging eye data
            Datapixx('RegWrRd');
            Pixxstruct(trial).TrialStart = Datapixx('GetTime');
            Pixxstruct(trial).TrialStart2 = Datapixx('GetMarker');
        end
        
        respcounter=0;
        resetresponse=1;
        if stopblock==1
            tlocblock=mixtr(trial,1);
            oriblock=theoris(randi(4));
            moveblock=0;
        end
        
        
        fixating=2^11;
        stopchecking=10;
        checkout=0;
        counttime=0;
        countthis=0;
        while number_of_events<=length(array_of_events) && checkout<1
            if number_of_events==0
                number_of_events=1;
            end
            time_of_this_event(number_of_events)=time_of_events(array_of_events(number_of_events));
            
            if ScotomaPresent == 1
                fixationscriptW
            end
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            %%         % constrained fixation loop at the beginning of the trial
            %           if stopblock==0
            %               if  (eyetime2-pretrial_time)>=0 && fixating<fixationduration/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
            %                 [fixating counter framecounter ]=IsFixatingSquareNew(wRect,xeye,yeye,fixating,framecounter,counter,fixwindowPix);
            %                 if exist('starfix')==0
            %                     startfix(trial)=eyetime2;
            %                     starfix=98;
            %                 end
            %             elseif (eyetime2-pretrial_time)>0 && fixating>=fixationduration/ifi && stopchecking>1 && fixating<1000 && (eyetime2-pretrial_time)<=trialTimeout
            %                 % forced fixation time satisfied
            %                 trial_time = GetSecs;
            %                 if EyetrackerType ==2
            %                     Datapixx('SetMarker');
            %                     Datapixx('RegWrVideoSync');
            %                     %collect marker data
            %                     Datapixx('RegWrRd');
            %                     Pixxstruct(trial).TrialOnset = Datapixx('GetMarker');
            %                 end
            %                 clear stimstar
            %                 fixating=1500;
            %             end
            %
            %           elseif stopblock==0
            %                             if  (eyetime2-pretrial_time)>=0 && moveblock<1000 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
            %                                            Screen('DrawTexture', w, whichLetter(stimtype), [], imageRect_offs{tlocblock}, oriblock,[], targetAlphaValue);
            %                             if sum(keyCode) ~=0
            %                                 moveblock=2^11;
            %                             end
            %
            %                             end
            %           end
            
            
            if stopblock==1
                if  (eyetime2-pretrial_time)>=0 && moveblock<1000 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout && fixating<1000
                    Screen('DrawTexture', w, whichLetter(stimtype), [], imageRect_offs{tlocblock}, oriblock,[], targetAlphaValue);
                    if sum(keyCode) ~=0
                        moveblock=2^11;
                        blocktime=GetSecs;
                    end
                elseif (eyetime2-pretrial_time)>=0 && (eyetime2-blocktime)<=0.5+ifi*3 && moveblock>1000
                    if (eyetime2-blocktime)>=0.5
                        trial_time=GesSecs;
                        fixating=2^11;
                    end
                end
            end
            
            %%      % beginning of the trial after fixation criteria satisfied in
            % clear stimstar
            time_of_this_event(number_of_events)=time_of_events(array_of_events(number_of_events));
            % this looks into the timing of events array, looks at the array
            % of events and the counter of number of events
            cumulativeclock=sum(time_of_this_event);
            %           if  resetflag==1
            %              trial_time=GetSecs-eyetime2;
            %               resetflag=0;
            %           end
            %   eyetime2=GetSecs-trial_time;
            %  mao=[mao eyetime2];
            timereset=0;
            %if eyetime2>=time_of_this_event(number_of_events) && eyetime2<=time_of_this_event(number_of_events)
            if     (eyetime2-trial_time)<=time_of_this_event(number_of_events) && stopchecking>1 && fixating>1000
                
                if number_of_events>timereset
                   
                    tm(number_of_events)=GetSecs;
                    countthis=countthis+1;
                end
                timereset=number_of_events;
                stimtype=array_of_events(number_of_events);
                tloc=mixtr(trial,1);
                
                if stimtype==4 %cue
                    
                    if mixtr(trial,1) ==1 && mixtr(trial,2)==2
                        ori= 90;
                    elseif mixtr(trial,1) ==1 && mixtr(trial,2)==3
                        ori= 135;
                    elseif mixtr(trial,1) ==2 && mixtr(trial,2)==1
                        ori= -90;
                    elseif mixtr(trial,1) ==2 && mixtr(trial,2)==3
                        ori= -135;
                    elseif mixtr(trial,1) ==3 && mixtr(trial,2)==1
                        ori= -45;
                    elseif mixtr(trial,1) ==3 && mixtr(trial,2)==2
                        ori= 45;
                    end
                elseif stimtype==3 %target
                    if resetresponse==1
                        theans(trial,number_of_events)=randi(4);
                        ori=theoris(theans(trial,number_of_events));
                        resetresponse=0;
                    end
                elseif stimtype==2 %foil
                    theans(trial,number_of_events)=5;
                    % assign the correct response from two trials ago if it
                    % was a target trial
                    if number_of_events>3 && array_of_events(number_of_events-2) == 3
                        theans(trial,number_of_events)=theans(trial,number_of_events-2);
                    end
                elseif stimtype==5 %blank
                    % assign the correct response from one trial ago to the
                    % blank interval
                    theans(trial,number_of_events)= theans(trial,number_of_events-1);
                end
                
                if stimtype~=5 && stimtype~=6
                    Screen('DrawTexture', w, whichLetter(stimtype), [], imageRect_offs{tloc}, ori,[], targetAlphaValue);
                end
                %      resetflag=1;
                
                if exist('stimstar') == 0 && eyetime2>0
                    stim_start(trial,number_of_events)=eyetime2;
                    stimstar=1;
                    counttime=counttime+1;
                end
                if (eyetime2-trial_time)>0
                    if sum(keyCode) ~=0 && contresp(trial, number_of_events)==0 %&& theans(trial,number_of_events)
                        contresp(trial,number_of_events)=9;
                        respcounter=respcounter+1;
                        thekeys = find(keyCode);
                        if length(thekeys)>1
                            thekeys=thekeys(1);
                        end
                        thetimes=keyCode(thekeys);
                        [secs  indfirst]=min(thetimes);
                        respTime(trial, respcounter)=secs;
                        
                        
                        testtime(trial, respcounter)=secs-stim_start(trial,number_of_events)
                        if  thekeys==escapeKey
                            DrawFormattedText(w, 'Bye', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            %  KbQueueWait;
                            closescript = 1;
                            %   number_of_events=10^4;
                            checkout=2;
                            break;
                        end
                        foo=(RespType==thekeys);
                        
                        if foo(theans(trial,number_of_events))
                            resp = 1;
                            nswr(trial)=1;
                            PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                            PsychPortAudio('Start', pahandle);
                            crudeRT(trial,number_of_events)=secs;
                            if  stimtype==3 %response during target
                                RespMatrix(trial,number_of_events)=secs-stim_start(trial,number_of_events);
                                this(trial,number_of_events)=1
                            elseif stimtype==5 %response during blank post target
                                RespMatrix(trial,number_of_events)=secs-stim_start(trial,number_of_events-1);
                                that(trial,number_of_events)=1
                            elseif stimtype==2 %response during foil post blank post target
                                RespMatrix(trial,number_of_events)=secs-stim_start(trial,number_of_events-2);
                                those(trial,number_of_events)=1
                            end
                            %         elseif foo(theans(trial,number_of_events-1))
                            
                            %       RespMatrix(trial,number_of_events)=secs-stim_start(trial,number_of_events-1);
                            
                        else
                            resp = 0;
                            nswr(trial)=0;
                            PsychPortAudio('FillBuffer', pahandle, errorS' ); % loads data into buffer
                            PsychPortAudio('Start', pahandle);
                        end
                    end
                end
                if EyetrackerType ==2
                    %set a marker to get the exact time the screen flips
                    Datapixx('SetMarker');
                    Datapixx('RegWrVideoSync');
                    %collect marker data
                    Datapixx('RegWrRd');
                    Pixxstruct(trial,number_of_events).TargetOnset = Datapixx('GetMarker');
                    Pixxstruct(trial,number_of_events).TargetOnset2 = Datapixx('GetTime');
                end
            end
            
            % if (eyetime2-trial_time)>0
            
            
            
            %    end
            %  end
            if fixating> 1000
                if (eyetime2-trial_time)>=time_of_this_event(number_of_events)
                    number_of_events=number_of_events+1;
                     clear stimstar
                    trial_time=GetSecs;
                    resetresponse=1;
                end
            end
            eyefixation5
            Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
            Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
            Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
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
                    scotomaradiuss=round(pix_deg*scotomadeg);
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
                if EyeData(end,1)>8000 && stopchecking<0 && (eyetime2-pretrial_time)>calibrationtolerance
                    trialTimeout=100000;
                    caliblock=1;
                    DrawFormattedText(w, 'Need calibration', 'center', 'center', white);
                    Screen('Flip', w);
                    %   KbQueueWait;
                    if  sum(keyCode)~=0
                        thekeys = find(keyCode);
                        if  thekeys==escapeKey
                            DrawFormattedText(w, 'Bye', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            %  KbQueueWait;
                            closescript = 1;
                            %       number_of_events=10^4;
                            checkout=2;
                        elseif thekeys==RespType(5)
                            DrawFormattedText(w, 'continue', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            %  KbQueueWait;
                            % trial=trial-1;
                            % number_of_events=10^4;
                            checkout=2;
                        elseif thekeys==RespType(6)
                            DrawFormattedText(w, 'Calibration!', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            %    KbQueueWait;
                            %    number_of_events=10^4;
                            checkout=2;
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
            end
            [keyIsDown, keyCode] = KbQueueCheck;
        end
        %         if  caliblock==0
        %
        %             foo=(RespType==thekeys);
        %         end
        
        if caliblock==0
            %             time_stim(kk) = respTime(trial) - stim_start(trial);
            %  totale_trials(kk)=trial;
            coordinate(trial).x=theeccentricity_X/pix_deg;
            coordinate(trial).y=theeccentricity_Y/pix_deg;
            xxeye(trial).ics=xeye;
            yyeye(trial).ipsi=yeye;
            vbltimestamp(trial).ix=VBL_Timestamp;
            arrays{trial}=time_of_this_event;
            trialTime=cumulativeclock;
            %   rispo(kk)=resp;
            
            %             if exist('thekeys')
            %                 cheis(kk)=thekeys;
            %             else
            %                 cheis(kk)=99;
            %             end
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
        elseif caliblock==1
            trial=trial-1;
            % caliblock=0;
        end
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