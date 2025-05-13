% FLAP Attention task via RSVP streams on 4 peripheral locations
% Marcello Maniglia 1/25/2023

close all;
clear;
clc;
commandwindow
%addpath('/Users/sll/Desktop/Flap/Flap_scripts/utilities')


addpath([cd '/utilities']);
try
%     participantAssignmentTable = fullfile(cd, ['..\..\datafolder\ParticipantAssignmentsUCR_corr.csv']); % this is set for UCR or UAB separately (This is set here so that definesite.m does not have to change)
   % participantAssignmentTable = fullfile(cd, ['..\..\datafolder\ParticipantAssignmentsUAB_corr.csv']); % uncomment this if running task at UAB
    
    prompt={'Participant name', 'day', 'demo (0) or session (1)', 'Calibration(1), Validation (2), or nothing(0)'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '1', '1'};
    
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
  
    SUBJECT = answer{1,:}; %Gets Subject Name
    expDay=str2num(answer{2,:});
    [tt,site] = getParticipantAssignmentTable(SUBJECT);
    
    ScotomaPresent= str2num(tt.ScotomaPresent{1,1}); % 0 = no scotoma, 1 = scotoma
    Isdemo=str2num(answer{3,:}); % full session or demo/practice
    PRLlocations=2;
    if strcmp(tt.WhichEye{1,1},'R') == 1 % are we tracking left (1) or right (2) eye? Only for Vpixx
        whicheye = 2;
    else
        whicheye = 1;
    end
    calibration=str2num(answer{4,:}); % do we want to calibrate or do we skip it? only for Vpixx
    EyeTracker = 1; %0=mouse, 1=eyetracker
    responsebox=1;   
    scotomavpixx= 0;
    datapixxtime=1;
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]    
    
    if Isdemo==0
        filename=' RSVP_practice';
    elseif Isdemo==1
        filename='RSVP';
    end
    folderchk=cd;
    DAY=['\Assessment\Day' answer{2,:} '\'];
    folder=fullfile(folderchk, ['..\..\datafolder\' SUBJECT DAY]);
    if exist(fullfile(folderchk, ['..\..\datafolder\' SUBJECT DAY])) == 0
        mkdir(folder);
    end
    
    if site==1
        baseName=[folder SUBJECT filename  '_' num2str(PRLlocations) '_' expDay num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[folder SUBJECT filename  '_' num2str(PRLlocations) '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[folder SUBJECT filename  'Pixx_' num2str(PRLlocations) '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    defineSite % initialize Screen function and features depending on OS/Monitor
    
    CommonParametersRSVP % load parameters for time and space
    
    %load  RSVPmxII.mat
    %   load RSVPmxIncong.mat
    load RSVP3mxIII.mat
    %% eyetracker initialization (eyelink)
    %     defineSite
    
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
    
    %     theans=nan(length(mixtr), 39);
    %     contresp=zeros(length(mixtr), 39);
    %     RespMatrix=nan(length(mixtr),39);
    %     resp=nan(length(mixtr),39);
    
    for trial=1:length(mixtr)
        trialTimedout(trial)=0;
        TrialNum = strcat('Trial',num2str(trial));
        
        stopblock=0;
        if  trial==1 || mod(trial,25)==0
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
        moveblock=2^11;
        fixating=2^11;
        if stopblock==1
            tlocblock=mixtr(trial,1);
            theansblock=randi(4);
            oriblock=theoris(theansblock);
            moveblock=0;
            blocktime=eyetime2+1000;
            fixating=0;
        end
        %    stopchecking=10;
        checkout=0;
        counttime(trial)=0;
        countthis=0;
        isfixatingnow=0;
        
        
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
                    respgiven=0;
        end
        cfc=0;
        
        respgiven = 0;
        while number_of_events<=length(array_of_events) && checkout<1
            if datapixxtime==1
                eyetime2=Datapixx('GetTime');
                                Datapixx('RegWrRd');
            end
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
            
            stimtype=array_of_events(number_of_events);
            
            if stopblock==1
                if  (eyetime2-pretrial_time)>=0 && moveblock<1000 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout && fixating<1000
                    Screen('DrawTexture', w, whichLetter(stimtype), [], imageRect_offs{tlocblock}, oriblock,[], targetAlphaValue);
                    if responsebox==0
                        if sum(keyCode) ~=0
                            thekeys = find(keyCode);
                            if length(thekeys)>1
                                thekeys=thekeys(1);
                            end
                            thetimes=keyCode(thekeys);
                            foo=(RespType==thekeys);
                            
                            if foo(theansblock)
                                PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                            else
                                PsychPortAudio('FillBuffer', pahandle, errorS' ); % loads data into buffer
                            end
                            PsychPortAudio('Start', pahandle);
                            moveblock=2^11; %time to move to next event
                            blocktime=eyetime2;
                        end
                    elseif responsebox==1
                        Datapixx('RegWrRd');
                        buttonLogStatus = Datapixx('GetDinStatus');
                        if (buttonLogStatus.newLogFrames > 0)
                            [thekeys secs] = Datapixx('ReadDinLog');
                            [logData{trial}, logTimetags{trial}, underflow{trial}] = Datapixx('ReadDinLog');
                            
                            foo=(RespType==thekeys);
                            if foo(theansblock)
                                PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                            else
                                PsychPortAudio('FillBuffer', pahandle, errorS' ); % loads data into buffer
                            end
                            PsychPortAudio('Start', pahandle);
                            moveblock=2^11; %time to move to next event
                            blocktime=eyetime2;
                        end
                    end
                elseif (eyetime2-pretrial_time)>=0 && (eyetime2-blocktime)<=0.5+ifi*3 && moveblock>1000 && fixating<1000
                    if (eyetime2-blocktime)>=0.5
                        if datapixxtime==1
                            trial_time=Datapixx('GetTime');
                        else
                            trial_time=eyetime2;
                        end
                        fixating=2^11;
                    end
                    cfc=cfc+1;
                    tut(cfc)=eyetime2;
                    tit(cfc)=blocktime;
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
            if     (eyetime2-trial_time)<=time_of_this_event(number_of_events) && stopchecking>1 && fixating>1000 && moveblock>1000
                
                if number_of_events>timereset
                    
                    tm(number_of_events)=eyetime2;
                    countthis=countthis+1;
                end
                timereset=number_of_events;
                stimtype=array_of_events(number_of_events);
                tloc=mixtr(trial,1);
                
                if stimtype==2 %foil
                    theans(trial,number_of_events)=7;
                    
                    %stim type
                    %1: target stays on screen until response
                    %2: foil
                    %3: target
                    %4: cue
                    %5 blank
                    %6: post cue blank
                    
                    %the ans
                    %1-4: target
                    %5: blank
                    %6: cue
                    %7: foil
                    %6:post cue blank
                elseif stimtype==3 %target
                    if resetresponse==1
                        theans(trial,number_of_events)=randi(4);
                        ori=theoris(theans(trial,number_of_events));
                        resetresponse=0;
                    end
                elseif stimtype==4 %cue
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
                    theans(trial,number_of_events)=8;
                elseif stimtype==5 %blank
                    % assign the correct response from one trial ago to the
                    % blank interval
                    theans(trial,number_of_events)= 5;
                elseif stimtype==6 %post cue blank
                    theans(trial,number_of_events)= 6;
                end
                %                 if stimtype==2
                % %                     targetAlphaValue1 = 1;
                %                     Screen('DrawTexture', w, whichLetter(stimtype), [], imageRect_offs{tloc}, ori,[], 1);
                %                 end
                if stimtype~=5 && stimtype~=6
                    Screen('DrawTexture', w, whichLetter(stimtype), [], imageRect_offs{tloc}, ori,[], targetAlphaValue);
                end
                if number_of_events == 1 && array_of_events(number_of_events) == 3 && stimtype~=5 && stimtype~=6
                    Screen('DrawTexture', w, whichLetter(stimtype), [], imageRect_offs{tloc}, ori,[], 1);
                end
                
                if exist('stimstar') == 0 && eyetime2>0
                    stim_start(trial,number_of_events)=eyetime2;
                    stimstar=1;
                    counttime(trial)=counttime(trial)+1;
                end
                if (eyetime2-trial_time)>0
                    if responsebox==0
                        if sum(keyCode) ~=0
                            respcounter=respcounter+1;
                            thekeys = find(keyCode);
                            %          PsychPortAudio('Start', pahandle);
                            
                            if length(thekeys)>1
                                thekeys=thekeys(1);
                            end
                            thetimes=keyCode(thekeys);
                            [secs  indfirst]=min(thetimes);
                            respTime(trial, respcounter)=secs;
                            if thekeys==RespType(1)
                                respKeys(trial, respcounter)=1;
                            elseif thekeys==RespType(2)
                                respKeys(trial, respcounter)=2;
                            elseif thekeys==RespType(3)
                                respKeys(trial, respcounter)=3;
                            elseif thekeys==RespType(4)
                                respKeys(trial, respcounter)=4;
                            elseif  thekeys==escapeKey
                                DrawFormattedText(w, 'Bye', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                %  KbQueueWait;
                                closescript = 1;
                                %   number_of_events=10^4;
                                checkout=2;
                                break;
                            end
                        end
                    elseif responsebox==1
                        Datapixx('RegWrRd');
                        buttonLogStatus = Datapixx('GetDinStatus');
                        if (buttonLogStatus.newLogFrames > 0) && respgiven == 0 %responsegiven==0
                            [thekeys secs] = Datapixx('ReadDinLog');
                                                        [logData{trial}, logTimetags{trial}, underflow{trial}] = Datapixx('ReadDinLog');

                            respcounter=respcounter+1;
                            if length(secs)>1
                                if sum(thekeys(1)==RespType)>0
                                    thekeys=thekeys(1);
                                    secs=secs(1);
                                elseif sum(thekeys(2)==RespType)>0
                                    thekeys=thekeys(2);
                                    secs=secs(2);
                                end
                            end
                            respTime(trial, respcounter)=secs;
                            
                            %                      PsychPortAudio('Start', pahandle);
                            if thekeys==RespType(1)
                                respKeys(trial, respcounter)=1;
                            elseif thekeys==RespType(2)
                                respKeys(trial, respcounter)=2;
                            elseif thekeys==RespType(3)
                                respKeys(trial, respcounter)=3;
                            elseif thekeys==RespType(4)
                                respKeys(trial, respcounter)=4;
                            elseif  thekeys==escapeKey
                                DrawFormattedText(w, 'Bye', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                %  KbQueueWait;
                                closescript = 1;
                                %   number_of_events=10^4;
                                checkout=2;
                                break;
                            end
                            respgiven=1;
                        end
                        if respgiven==1
                            if  eyetime2-respTime(end)>0.45 % to avoid long presses counting as multiple button presses
                                % WaitSecs(0.5);
                                Bpress=0;
                                timestamp=-1;
                                TheButtons=-1;
                                inter_buttonpress{1}=[]; % added by Jason because matlab was throwing and error
                                % saying that inter_buttonpress was not assigned.
                                % 26 June 2018
                                RespTime=[];
                                PTBRespTime=[];
                                binaryvals=[];
                                bin_buttonpress{1}=[]; % Jerry:use array instead of cell
                                inter_timestamp{1}=[]; % JERRY: NEVER USED, DO NOT UNDERSTAND WHAT IT STANDS FOR
                                
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
                                respgiven=0;
                            end
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
            eyefixation5
            
            if fixating> 1000 && moveblock>1000
                [isfixatingnow counter framecounter ]=IsFixatingSquareNew(wRect,xeye,yeye,isfixatingnow,framecounter,counter,fixwindowPix);
                if (eyetime2-trial_time)>=time_of_this_event(number_of_events) && isfixatingnow>0
                    number_of_events=number_of_events+1;
                    clear stimstar
                    trial_time=eyetime2;
                    resetresponse=1;
                    isfixatingnow=0;
                    stopchecking=-10;
                    
                    if responsebox==1
                        %      Datapixx('StopDinLog');
                    end
                end
            end
            Screen('FrameOval', w,ContCirc, imageRect_circleoffs1, oval_thick, oval_thick);
            Screen('FrameOval', w,ContCirc, imageRect_circleoffs2, oval_thick, oval_thick);
            Screen('FrameOval', w,ContCirc, imageRect_circleoffs3, oval_thick, oval_thick);
            teet=111;
            if ScotomaPresent == 1
                Screen('FillOval', w, scotoma_color, scotoma);
            else
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
            if datapixxtime==1
                [eyetime3, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
                VBL_Timestamp=[VBL_Timestamp eyetime3];
            else
                [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
                VBL_Timestamp=[VBL_Timestamp eyetime2];
            end
            
            
            if EyeTracker==1
                if EyetrackerType==1
                    GetEyeTrackerData
                elseif EyetrackerType==2
                    GetEyeTrackerDatapixx
                end
                GetFixationDecision
                if EyeData(end,1)<8000 && stopchecking<0
                    trial_time = eyetime2;
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
            else
                if stopchecking<0
                    trial_time = eyetime2; %start timer if we have eye info
                    stopchecking=10;
                end
            end
            [keyIsDown, keyCode] = KbQueueCheck;
        end
        %         if  caliblock==0
        %
        %             foo=(RespType==thekeys);
        %         end
        totalresptrial(trial)=respcounter;
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