% PRL induction procedure with simulated scotoma, single target
% written by Marcello A. Maniglia 2017/2021

close all; clear; clc;
commandwindow
try
    participantAssignmentTable = fullfile(cd, ['..\..\datafolder\ParticipantAssignmentsUCR_corr.csv']); % this is set for UCR or UAB separately (This is set here so that definesite.m does not have to change)
%     participantAssignmentTable = fullfile(cd, ['..\..\datafolder\ParticipantAssignmentsUAB_corr.csv']); % uncomment this if running task at UAB
    
    %    prompt={'Participant Name','Day', 'demo (0) or session (1)', 'Calibration? yes(1), no(0)'};
    prompt={'Participant Name','Day', 'demo (0) or session (1)', 'Calibration(1), Validation (2), or nothing(0)'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '1','1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
        
    end
    
    addpath([cd '/utilities']);
    
    temp= readtable(participantAssignmentTable);
    SUBJECT = answer{1,:}; %Gets Subject Name
    expday = str2num(answer{2,:});
    expdayeye = answer{2,:};
    tt = temp(find(contains(temp.participant,SUBJECT)),:); % if computer doesn't have excel it reads as a struct, else it reads as a table
    site= 3;
    if strcmp(tt.WhichEye{1,1},'R') == 1 % are we tracking left (1) or right (2) eye? Only for Vpixx
        whicheye = 2;
    else
        whicheye = 1;
    end
    EyeTracker = 1; %0=mouse, 1=eyetracker
    Isdemo=str2num(answer{3,:}); % full session or demo/practice
    %  calibration=str2num(answer{4,:}); %
    calibration=str2num(answer{4,:});
    
    inductionType = 2; % 1 = assigned, 2 = annulus
    
    scotomavpixx=0;
    datapixxtime=1;
    responsebox=1;
    TRLnumber=2;
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    
    if inductionType ==1
        TYPE = 'Assigned';
    elseif inductionType == 2
        TYPE = 'Annulus';
    end
    if Isdemo==0
        filename = 'PRL_induction_practice';
    elseif Isdemo==1
        filename = 'PRL_induction';
    end
    folderchk=cd;
    DAY=['\Assessment\Day' answer{2,:} '\'];
    folder=fullfile(folderchk, ['..\..\datafolder\' SUBJECT DAY]);
    if exist(fullfile(folderchk, ['..\..\datafolder\' SUBJECT DAY])) == 0
        mkdir(folder);
    end
    
    if site==1
        baseName=[folder SUBJECT '_' filename '_DAY_' num2str(expday) '_' TYPE '_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site ==3
        baseName=[folder SUBJECT '_' filename '_DAY_' num2str(expday) '_' TYPE '_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    end
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    defineSite
    CommonParametersInduction
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
    
    %%
    CreateInductionStimuli
    
    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    end
    
    %% main loop
    HideCursor(0);
    ListenChar(2);
    counter = 0;
    
    Screen('FillRect', w, gray);
    
    %%
    
    DrawFormattedText(w, 'Report the overall orientation of the C stimuli \n \n left (left key) or right (right key) \n \n \n \n Press any key to start', 'center', 'center', white);
    Screen('Flip', w);
    KbWait;
    
    Screen('Flip', w);
    
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
    
    
    
    for trial=1:trials
        FLAPVariablesReset
        
        TrialNum = strcat('Trial',num2str(trial));
        
        %Every 50 trials, pause to allow subject to rest eyes
        if trial>1 && (mod(trial,50))==1
            %     Screen('TextStyle', w, 1+2);
            Screen('FillRect', w, gray);
            %      DrawFormattedText(w, 'Take a short break and rest your eyes \n\n  \n \n \n \n Press any key to start', 'center', 'center', white);
            percentagecompleted= (trial/trials)*100;
            textSw=sprintf( 'Take a short break and rest your eyes  \n \n You completed %d percent of the session \n \n \n \n Press any key to start', percentagecompleted);
            DrawFormattedText(w, textSw, 'center', 'center', white);
            Screen('Flip', w);
            KbQueueWait;
        end
        
        
        angle1= randi(360); %anglearray(randi(length(anglearray)))
        angle2= angle1+120+(jitterAngle(2)-jitterAngle(1).*rand(1,1)+jitterAngle(1));
        angle3= angle1-120+(jitterAngle(2)-jitterAngle(1).*rand(1,1)+jitterAngle(1));
        
        theta = [angle1  angle2  angle3 ];
        theta= deg2rad(theta);
        distanceArray= [distances+(jitterDistance(2)-jitterDistance(1).*rand(1,1)+jitterDistance(1)) distances+(jitterDistance(2)-jitterDistance(1).*rand(1,1)+jitterDistance(1)) distances+(jitterDistance(2)-jitterDistance(1).*rand(1,1)+jitterDistance(1))];
        rho = [distanceArray];
        [elementcoordx,elementcoordy] = pol2cart(theta,rho);
        
        if totalelements==4
            tgtpos=randi(length(posmatrix));
            targetlocation(trial)=randi(4); %generates answer for this trial
            
        elseif totalelements==3
            posmatrix=[elementcoordx' elementcoordy'];
            tgtpos=randi(length(posmatrix));
            targetlocation(trial)=randi(3); %generates answer for this trial
        end
        
        newpos=posmatrix;
        newpos(tgtpos,:)=[];
        
        
        if totalelements == 4
            target_ecc_x=positionmatrix(posmatrix(targetlocation(trial),1));
            target_ecc_y=positionmatrix(posmatrix(targetlocation(trial),2));
            newnewpos=posmatrix;
            newnewpos(targetlocation(trial),:)=[];
            for gg=1:(totalelements-1)
                newdistpos(gg)=randi(length(newnewpos(:,1)));
                newecc_xd(gg)=positionmatrix(newnewpos(newdistpos(gg),1));
                newecc_yd(gg)=positionmatrix(newnewpos(newdistpos(gg),2));
                newnewpos(newdistpos(gg),:)=[];
            end
            neweccentricity_X=target_ecc_x*pix_deg;
            neweccentricity_Y=target_ecc_y*pix_deg;
        elseif totalelements == 3
            target_ecc_x=posmatrix(targetlocation(trial),1);
            target_ecc_y=posmatrix(targetlocation(trial),2);
            newnewpos=posmatrix;
            newnewpos(targetlocation(trial),:)=[];
            for gg=1:(totalelements-1)
                newdistpos(gg)=randi(length(newnewpos(:,1)));
                newecc_xd(gg)=newnewpos(newdistpos(gg),1);
                newecc_yd(gg)=newnewpos(newdistpos(gg),2);
                newnewpos(newdistpos(gg),:)=[];
            end
            neweccentricity_X=elementcoordx(1);
            neweccentricity_Y=elementcoordy(1);
        end
        
        neweccentricity_X=target_ecc_x;
        neweccentricity_Y=target_ecc_y;
        imageRect = CenterRect([0, 0, [imsize imsize]], wRect);
        imageRect_offs =[imageRect(1)+neweccentricity_X, imageRect(2)+neweccentricity_Y,...
            imageRect(3)+neweccentricity_X, imageRect(4)+neweccentricity_Y];
        
        
        if totalelements == 3
            relementcoordx=elementcoordx;
            relementcoordy=elementcoordy;
            relementcoordx(find(relementcoordx==target_ecc_x))=[];
            relementcoordy(find(relementcoordy==target_ecc_y))=[];
            for gg = 1:totalelements-1
                neweccentricity_Xd(gg)=round(relementcoordx(gg));
                neweccentricity_Yd(gg)=round(relementcoordy(gg));
                imageRect_offsDist{gg}= [imageRect(1)+round(relementcoordx(gg)), imageRect(2)+round(relementcoordy(gg)),...
                    imageRect(3)+round(relementcoordx(gg)), imageRect(4)+round(relementcoordy(gg))];
                circlefix2(gg)=0;
            end
        elseif totalelements == 4
            for gg = 1:totalelements-1
                neweccentricity_Xd(gg)=newecc_xd(gg)*pix_deg;
                neweccentricity_Yd(gg)=newecc_yd(gg)*pix_deg;
                imageRect_offsDist{gg}= [imageRect(1)+neweccentricity_Xd(gg), imageRect(2)+neweccentricity_Yd(gg),...
                    imageRect(3)+neweccentricity_Xd(gg), imageRect(4)+neweccentricity_Yd(gg)];
                circlefix2(gg)=0;
            end
        end
        
        
        theans(trial)=randi(2); %generates answer for this trial
        if theans(trial)==1 %present
            counterleft=counterleft+1;
            texture(trial)=theTargets_left{counterleft};
        else % absent
            counterright=counterright+1;
            texture(trial)=theTargets_right{counterright};
        end
        
        nn=0;
        circlefix=0;
        trialTimedout(trial)=0;
        clear stim_start
        
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
                stoptwo(trial)=99;
                %                IsFixating4
                [fixating counter framecounter ]=IsFixatingSquareNew(wRect,xeye,yeye,fixating,framecounter,counter,fixwindowPix);
                
                fixationscriptrand
            elseif (eyetime2-pretrial_time)>ITI && fixating>=fixTime/ifi && fixating<1000 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                if datapixxtime==0
                    trial_time = GetSecs;
                else
                    Datapixx('RegWrRd');
                    trial_time = Datapixx('GetTime');
                end
                fixating=1500;
            end
            
            if (eyetime2-trial_time)>=postfixationISI && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                
                %here i present the stimuli+acoustic cue
                
                %Draw Target
                Screen('DrawTexture', w, texture(trial), [], imageRect_offs );
                
                checktrialstart(trial)=1;
                
                if exist('stim_start')==0
                    PsychPortAudio('FillBuffer', pahandle, bip_sound' ); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    % start counting timeout for the non-fixed time training
                    if datapixxtime==0
                        stim_start = GetSecs;
                    else
                        Datapixx('RegWrRd');
                        stim_start = Datapixx('GetTime');
                    end
                    trialTimeout=actualtrialtimeout+(stim_start-pretrial_time);
                    checktrialstart(trial)=1;
                    stimpresent=1111;
                end
                
                if responsebox==0
                    if (keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey)) ~=0
                        %after target presentation and a key is pressed
                        eyechecked=10^4;
                        thekeys = find(keyCode);
                        if length(thekeys)>1
                            thekeys=thekeys(1);
                        end
                        thetimes=keyCode(thekeys);
                        if datapixxtime==0
                            [secs  indfirst]=min(thetimes);
                            respTime(trial)=secs;
                        else
                            respTime(trial)=eyetime2;
                        end
                    end
                elseif responsebox==1
                    if (buttonLogStatus.newLogFrames > 0)
                        actualsecs{trial}= secs;
                        if length(secs)>1
                            if sum(thekeys(1)==RespType)>0
                                thekeys=thekeys(1);
                                secs=secs(1);
                            elseif sum(thekeys(2)==RespType)>0
                                thekeys=thekeys(2);
                                secs=secs(2);
                            end
                        end
                        respTime(trial)=secs;
                        eyechecked=10^4;
                    end
                end
            elseif  (eyetime2-pretrial_time)>trialTimeout
                trialTimedout(trial)=1;
                eyechecked=10^4;
                if datapixxtime==0
                    secs=GetSecs;
                elseif datapixxtime==1
                    Datapixx('RegWrRd');
                    secs = Datapixx('GetTime');
                end
                
                respTime(trial)=secs;
                
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
                if inductionType==1
                    assignedPRLpatchPRLinduction2TRL
                else
                    annulusPRLpatchTRL
                end
                Screen('FillOval', w, scotoma_color, scotoma);
                if inductionType==1
                    for iu=1:length(PRLx)
                        imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
                            imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
                        if visibleCircle ==1
                            Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
                        end
                    end
                end
            end
            
            %    save time and other stuff from flip    equal Screen('Flip', w,vbl plus desired time half of framerate);
            %    [eyetime, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w, eyetime-(ifi * 0.5));
            
            
            
            if datapixxtime==1
                [eyetime3, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
                VBL_Timestamp=[VBL_Timestamp eyetime3];
            else
                [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
                VBL_Timestamp=[VBL_Timestamp eyetime2];
            end
            
            %% process eyedata in real time (fixation/saccades)
            
            if EyeTracker==1
                GetEyeTrackerDataNew
                GetFixationDecision
                if EyeData(end,1)<8000 && stopchecking<0
                    if datapixxtime==1
                        Datapixx('RegWrRd');
                        trial_time = Datapixx('GetTime');
                    else
                        trial_time = GetSecs; %start timer if we have eye info
                    end
                    stopchecking=10;
                end
                
                if EyeData(end,1)>8000 && stopchecking<0 && (eyetime2-pretrial_time)>calibrationtolerance
                    trialTimeout=100000;
                    caliblock=1;
                    if responsebox==0
                        DrawFormattedText(w, 'Need calibration: press "c" to continue the study, press "m" to recalibrate, press "esc" to exit ', 'center', 'center', white);
                    else
                        DrawFormattedText(w, 'Need calibration: press "red" to continue the study, press "yellow" to recalibrate, press "green" to exit ', 'center', 'center', white);
                    end
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
                        if (buttonLogStatus.newLogFrames > 0)
                            if  thekeys==RespType(3)
                                DrawFormattedText(w, 'Bye', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                %  KbQueueWait;
                                closescript = 1;
                                eyechecked=10^4;
                            elseif thekeys==RespType(1)
                                DrawFormattedText(w, 'continue', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                %  KbQueueWait;
                                % trial=trial-1;
                                eyechecked=10^4;
                            elseif thekeys==RespType(2)
                                DrawFormattedText(w, 'Calibration!', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                TPxReCalibrationTestingMM(1,screenNumber, baseName)
                                %    KbQueueWait;
                                eyechecked=10^4;
                            end
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
            
            if responsebox==1 % DATApixx AYS 5/4/23 I added some documentation for WaitForEvent_Jerry - let me know if you have questions.
                %  [Bpress, RespTime, TheButtons] = WaitForEvent_Jerry(0, TargList);
                Datapixx('RegWrRd');
                buttonLogStatus = Datapixx('GetDinStatus');
                if (buttonLogStatus.newLogFrames > 0)
                    [thekeys secs] = Datapixx('ReadDinLog');
                end
                %         [keyIsDown, keyCode] = KbQueueCheck;
            else % AYS: UCR and UAB?
                [keyIsDown, keyCode] = KbQueueCheck;
            end
            %  toc
            %    disp('fine')
            nn=nn+1;
        end
        if responsebox == 1
            stim_stop = secs;
        else
            stim_stop=secs;
        end
        if trialTimedout(trial)== 0
            foo=(RespType==thekeys);
            if foo(theans(trial))
                resp = 1;
                PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                PsychPortAudio('Start', pahandle);
                
                if stim_stop - stim_start<5
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
                PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                PsychPortAudio('Start', pahandle);
                
            end
        else
            stim_start = 0;
            stim_stop = 0;
            resp = 0;
            respTime=0;
            PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
            PsychPortAudio('Start', pahandle);
        end
        
        time_stim(trial) = stim_stop - stim_start;
        totale_trials(trial)=trial;
        %     coordinate(trial).x=ecc_x;
        %    coordinate(trial).y=ecc_y;
        rispoTotal(trial)=resp;
        rispoInTime(trial)=respTime;
        %  distraktor(trial)=distnum;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];
        % answer(trial)=theans %1 = present
        TGT_loc(trial)=targetlocation(trial);
        TGT_x(trial)=target_ecc_x;
        TGT_y(trial)=target_ecc_y;
        
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
            EyeSummary.(TrialNum).TargetX = target_ecc_x;
            EyeSummary.(TrialNum).TargetY = target_ecc_y;
            
            
            EyeSummary.(TrialNum).EventData = EvtInfo;
            clear EvtInfo
            EyeSummary.(TrialNum).ErrorData = ErrorData;
            clear ErrorData
            %  EyeSummary(trial).GetFixationInfo.DriftCorrIndices = DriftCorrIndices;
            EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
            EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
            EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
            %FixStamp(TrialCounter,1);
            EyeSummary.(TrialNum).TimeStamps.Stimulus = stim_start;
            EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;
            EyeSummary.(TrialNum).StimulusSize=imsize;
            if exist('mostratarget')
                EyeSummary.(TrialNum).Target.App = mostratarget;
            else
                EyeSummary.(TrialNum).Target.App = NaN;
            end
            EyeSummary.(TrialNum).Target.counter=countertarget;
            EyeSummary.(TrialNum).Target.FixInd=fixind;
            EyeSummary.(TrialNum).Target.Fixframe=framefix;
            EyeSummary.(TrialNum).PRL.x=PRLx;
            EyeSummary.(TrialNum).PRL.y=PRLy;
            EyeSummary.(TrialNum).targetlocation =targetlocation;
            %StimStamp(TrialCounter,1);
            clear ErrorInfo
            %    fliptime(trial)=[VBL_Timestamp];
            %thresharray(trial)=tresh;
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
    
    TimeSop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    DrawFormattedText(w, 'Task completed - Please inform the experimenter', 'center', 'center', white);
    ListenChar(0);
    Screen('Flip', w);
    KbWait;
    ShowCursor;
    
    if site==1
        Screen('CloseAll');
        Screen('Preference', 'SkipSyncTests', 0);
        %     s1 = serial('COM3');     % set the Bits mode back so the screen
        %     is in colour
        %     fopen(s1);
        %     fprintf(s1, ['$BitsPlusPlus' 13]); %one day we might use the bits# so better not to get rid of these lines
        %     fclose(s1);
        PsychPortAudio('Close', pahandle);
        
    else
        Screen('Preference', 'SkipSyncTests', 0);
        Screen('LoadNormalizedGammaTable', w , (linspace(0,1,256)'*ones(1,3)));
        Screen('Flip', w);
        Screen('CloseAll');
        PsychPortAudio('Close', pahandle);
    end
catch ME
    psychlasterror()
end