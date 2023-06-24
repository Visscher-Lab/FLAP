% FLAP Scanner task
% written by Marcello A. Maniglia April 2023 %2017/2021
% This script runs 6 runs of 4 blocks each (16 trials per block) of an
% orientation discrimination and cvontour integration task (2 blocks of
% each per run). It collects correct vs wrong responses and RT for fixed
% values of contrast and CI jitter


close all; clear; clc;
commandwindow



addpath([cd '/utilities']); %add folder with utilities files
try
    prompt={'Participant Name', 'day','site? UCR(1), UAB(2), Vpixx(3)', 'Practice (0) or Session(1)', 'Eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Scotoma? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?', 'response box (1) or keyboard (0)'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '3', '1' , '2', '0', '1', '0', '1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    penalizeLookaway=0;   %mostly for debugging, we can remove the masking on the target when assigned PRL ring is out of range
    expDay=str2num(answer{2,:}); % training day (if >1
    site = str2num(answer{3,:}); % training site (UAB vs UCR vs Vpixx)
    demo=str2num(answer{4,:}); % practice
    whicheye=str2num(answer{5,:}); % are we tracking left (1) or right (2) eye? Only for Vpixx
    calibration=str2num(answer{6,:}); % do we want to calibrate or do we skip it? only for Vpixx
    ScotomaPresent = str2num(answer{7,:}); % 0 = no scotoma, 1 = scotoma
    EyeTracker = str2num(answer{8,:}); %0=mouse, 1=eyetracker
    responsebox= str2num(answer{9,:}); 
    datapixxtime=1;
    %create a data folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    baseName=['./data/' SUBJECT '_FLAPScannertask' answer{2,:} '_' TimeStart]; %makes unique filename
    
    defineSite % initialize Screen function and features depending on OS/Monitor
    
    CommonParametersScanner % define common parameters
    


    %% eyetracker initialization (eyelink)
    if EyeTracker==1
        if site==3 || site==5
            EyetrackerType=2; %1 = Eyelink, 2 = Vpixx
        else
            EyetrackerType=1; %1 = Eyelink, 2 = Vpixx
        end
        eyetrackerparameters % set up Eyelink eyetracker
    else
        EyetrackerType=0;
    end
    
    % Gabor stimuli
    createGabors
    % CI stimuli
    CIShapesIII
    % audio params for DATAPixx audio, AYS 4/29/23
    fs=44100;
    FlipInt=Screen('GetFlipInterval',w); %Gets Flip Interval 


    
    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    elseif EyetrackerType==2 || (EyetrackerType==0 && site ==5) %added by AS 4-28-23, you can put into a script if you wish
%        if Calibrate
%             %CalibrateTracker; %obsolete
%             TPxTrackpixx3CalibrationTesting;
%             Calibrate=0;
%         end
        %% TO START EYE TRACKING DATA:
        dpx_isReady = Datapixx('IsReady');
        if site == 5 && (~dpx_isReady) 
             Datapixx('Open');
             audioGrpDelay=Datapixx('GetAudioGroupDelay',fs);
             audioDelay=FlipInt-audioGrpDelay; 
             Datapixx('StopAllSchedules');
             Datapixx('InitAudio');
             Datapixx('SetAudioVolume', [1,1]);
             Datapixx('SetDinLog');
             Datapixx('StartDinLog');
             Datapixx('EnableDinDebounce');
             Datapixx('RegWrRd');
             Screen('Preference', 'SkipSyncTests', 1); 
        end
         
        Datapixx('SetupTPxSchedule');
        Datapixx('RegWrRd');
        Datapixx('StartTPxSchedule');
        Datapixx('RegWrRdVideoSync'); % put VideoSync here, so that the eye tracking sync with the flipping
        EyeTrack_StartTime=Datapixx('GetTime');

    end
    %% Trial matrix definition
    shapes=2; % how many shapes per day?
    conditionOne=2; %Gabors + shapes
    conditionTwo=1; %location of the target
    conditionThree=shapes;
    %define number of trials per condition
    condmat= fullfact([conditionOne conditionTwo conditionThree ]);
    condmat=condmat(~(condmat(:,1)==1 & condmat(:,3)==2),:);
    condmat=[condmat(1,:); condmat];
    runs=6;
    blocks=4;
    trials=16;
    if demo==0
        runs=1;
        blocks=1;
        trials=1;
        demotrial=5;
        mixtr = [ ones(demotrial,1)*2 ones(demotrial,1) ones(demotrial,1)];
    end
    
    mixtr= []; % 1: gabor of shapes; 2: target location (left vs right), 3: shape type (6/9 or eggs)
    %mixtr 1: assessment type gabor (1) vs CI (2)
    %mixtr 2: stimulus location left (1) vs right (2)
    possiblerest=[trials trials*2
        trials trials*3
        trials*2  trials*3];
    for iii=1:runs % for each run
        %randomize blocks within run
        randorer=condmat(randperm(length(condmat)),:);
        for ui=1:length(condmat)           % for each block
            added=repmat(randorer(ui,:), trials,1);
            pointer=(randperm(length(added)));
            replacers=pointer(1:length(pointer)/2); % add other location in random order in half of the trial per block
            added(replacers,2)=2;
            mixtr=[mixtr; added];
            % insert random rest
        end
        clear randorder
        whenrest(iii,:)=possiblerest(randi(3),:);
    end
    
    %AS 4-28-23 Question, we normally would run the script for each run..that makes
    %a number of things easier...if you keep it this way then you might
    %need to restructure the eye-tracker code a bit. 
    for ui=1:runs
        resttrial(ui,:)= whenrest(ui,:)+(trials*blocks*(ui-1))+1;
    end
    resttrial=resttrial(:);
    resttrial=sort(resttrial);
    
    fase=randi(4);
    texture=TheGabors(spat_freq, fase);
    
    
    shapesoftheDay=shapeMat;
    AllShapes=size((Targy));
    %% Initialize trial loop
    HideCursor;
    if demo==1
        ListenChar(2);
    end
    ListenChar(0);    
    % check EyeTracker status, if Eyelink
    if EyetrackerType == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        Eyelink('message' , 'SYNCTIME');
        location =  zeros(length(mixtr), 6);
    end
    
    for io=1:runs
       blockstart(io)=io*(trials*4)+1; 
    end
    
%% RESPONSEpixx (Vpixx buttonbox) init 5/3/23
TargList = [1 2 3 4]; % 1=red (right), 2=yellow (up), 3=green (left), 4=blue (down)
TheTrigger = 11;

%AS 4-28-23 the following code is what we use for waiting for the trigger
%Andrew, can you adjust to make sure that it waits an additional TR, like
%the LC code before starting into the main procedure?
     disp('Ready, waiting for trigger...');

if site == 5
    [Bpress timestamp1]=WaitForEvent_Jerry(500, TheTrigger); % waits for trigger
    Datapixx('SetMarker');
    Datapixx('RegWrVideoSync'); % time sync
    ExpStartTimeP=Screen('Flip',window); %PTB-3 
    Datapixx('RegWrRd');
    ExpStartTimeD=Datapixx('GetMarker');
end

%% Jitter/wait TR init AYS 4/28/23
TR = 1.75; % TR dur in s CONFIRM TR DURATION
TRpat = [1 1 2 2 3]'; % 40% 1 TR, 40% 2, 20% 3 CONFIRM TR PATTERN
TRrem = 1; % remainder TRs if uneven div CONFIRM TR REMAINDER
TRlist = [repmat(TRpat, floor(length(mixtr)/length(TRpat)), 1); repmat(TRrem, rem(length(mixtr), length(TRpat)), 1)];
TRwait = TRlist(randperm(length(mixtr))); % TRwait arr tells how long to wait before next trial
TRcount = 0;

    %% HERE starts trial loop
    for trial=1:length(mixtr)
        %% jitter code @ trial loop start, AYS 4/28/23. See also jitter code @ trial loop end
        if site == 5
            Datapixx('RegWrRd');
            JitterStartTimeD(trial)=Datapixx('GetTime');
            TRpass=floor((JitterStartTimeD(trial)-ExpStartTimeD)/TR); % TRpass: time since Exp start (in TRs)

            if trial==1
                TRcount=TRcount+TRwait(trial); 
            else
                TRcount=TRcount+TRwait(trial)-1;
            end
        
            while TRpass<TRcount % wait until TRpass=TRcount, then
                WaitForEvent_Jerry(3, TheTrigger); % sync with next TR pulse
                Datapixx('RegWrRd');
                CurrentTimeD=Datapixx('GetTime');
                TRpass=round((CurrentTimeD-ExpStartTimeD)/TR); 
            end
            Datapixx('RegWrRd');
            JitterEndTimeD(trial)=Datapixx('GetTime');
            TrialStartTimeD(trial)=JitterEndTimeD(trial);
        end 
        %%  
               AssessmentType=mixtr(trial,1);
%blocks

if sum(trial==resttrial)>0
preCueISI=preCueISIarray(4);
restscreen=1;
elseif trial==1
    preCueISI=preCueISIarray(2);
    restscreen=0;
else
    ITI=randi(3);    
     preCueISI=preCueISIarray(ITI);   
restscreen=0;
end
timeITI(trial)=preCueISI;

if sum(trial==blockstart)>0
    % what to do in between blocks?
end
%% generate answer for this trial (training type 3 has no button response)
        theans(trial)=randi(2);
                  theothershape(trial)=randi(2);
  if AssessmentType==1
            ori=theoris(theans(trial));
            ori2=theoris(theothershape(trial));
        elseif AssessmentType==2
            CIstimuliModII % add the offset/polarity repulsion
        end
        if trial==1
            %   InstructionFLAPAssessment(w,AssessmentType,gray,white)
            if AssessmentType == 1
                Instruction_Contrast_Assessment
            elseif AssessmentType==2
                InstructionCIAssessment
            end
        elseif trial > 1 && (mixtr(trial,1)~= mixtr(trial-1,1) || mixtr(trial,3)~= mixtr(trial-1,3) )
            if trial==1 || mixtr(trial,1)~= mixtr(trial-1,1)
                %     InstructionFLAPAssessment(w,AssessmentType,gray,white)
                if AssessmentType == 1
                    Instruction_Contrast_Assessment
                elseif AssessmentType==2
                    InstructionCIAssessment
                end
            end
        end
        %% target location calculation
        theeccentricity_Y=LocY(1)*pix_deg;
        theeccentricity_X=LocX(mixtr(trial,2))*pix_deg;
        eccentricity_X(trial)= theeccentricity_X;
        eccentricity_Y(trial) =theeccentricity_Y ;
        
        if trial==length(mixtr)
            endExp=GetSecs; %time at the end of the session
        end
               
        %  destination rectangle for the target stimulus
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
        
        %  destination rectangle for the other stimulus
        imageRect_offs2 =[imageRect(1)-theeccentricity_X, imageRect(2)-theeccentricity_Y,...
            imageRect(3)-theeccentricity_X, imageRect(4)-theeccentricity_Y];

        %% Initialization/reset of several trial-based variables
        if trial==1
            startExp=GetSecs; %time at the beginning of the session
        end
        playsound=0;


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
        FLAPVariablesReset % reset some variables used in each trial


%stimulusduration=2.5;
respgiven=0;
        while eyechecked<1
            if datapixxtime==1
                eyetime2=Datapixx('GetTime');
            end
            if EyetrackerType ==2 %AS 4-28-23, not sure what this is doing....see the code earlier Are you trying to make this gaze contingent? I thought we are just recording eye-movements?
                Datapixx('RegWrRd');
            end

            if restscreen==0
                fixationscriptW % visual aids on screen
            end
              %% here is where the first time-based trial loop starts (until first forced fixation is satisfied)
                if (eyetime2-trial_time)>=0 && (eyetime2-trial_time)<preCueISI && stopchecking>1
                    % pre-event empty space, allows for some cleaning
                    if restscreen==1
                        Screen('FillRect', w, gray);
                        DrawFormattedText(w, 'Rest for 15 seconds', 'center', 'center', white);
                    end
                elseif (eyetime2-trial_time)>=preCueISI && (eyetime2-trial_time)<preCueISI+CueDuration && stopchecking>1
                   restscreen=0;
                   if exist('startrial') == 0
                       trialstart(trial)=GetSecs;
                       startrial=1;
                       if datapixxtime==1
                        trialstart_frame(trial)=Datapixx('GetTime');
                       elseif datapixxtime==0                        
                        trialstart_frame(trial)=eyetime2;
                       end
                   end
                    
                    % HERE I present the acoustic cue
                    if site == 5 % use DATApixx to play audio @ CAN, AYS 4/29/23
                        if mixtr(trial,2)==1
                            Datapixx('WriteAudioBuffer', bip_sound_left', 0); % loads data into buffer
                            Datapixx('SetAudioSchedule',0,fs,length(bip_sound_left'),3,0,length(bip_sound_left')); 
                        elseif mixtr(trial,2)==2
                            Datapixx('WriteAudioBuffer', bip_sound_right', 0); % loads data into buffer
                            Datapixx('SetAudioSchedule',0,fs,length(bip_sound_right'),3,0,length(bip_sound_right')); 
                        end
                        if playsound==0
                            Datapixx('StartAudioSchedule'); 
                            Datapixx('RegWrRd'); % synchronize Datapixx registers to local register cache
                            playsound=1;
                        end
                    else
                        if mixtr(trial,2)==1 %@Andrew can you put in the code needed for the Datapixx to play the sounds? Let me know if you need help
                            PsychPortAudio('FillBuffer', pahandle, bip_sound_left' ); % loads data into buffer
                        elseif mixtr(trial,2)==2
                            PsychPortAudio('FillBuffer', pahandle, bip_sound_right' ); % loads data into buffer                        
                        end
                        if playsound==0
                            PsychPortAudio('Start', pahandle);
                            playsound=1;
                        end
                    end
                elseif (eyetime2-trial_time)>=preCueISI+CueDuration  && (eyetime2-trial_time)<preCueISI+CueDuration+postCueISI && stopchecking>1
                    % cue to target interval
                    
                    %AS 4-28-23 I'm not sure what the following does? Where you are
                    %asking for the key response?
                    % I exit the script if I press ESC
                 if responsebox==0
                     if keyCode(escapeKey) ~=0                       
                        thekeys = find(keyCode);
                        closescript=1;
                        break;
                     end
                 end
                elseif (eyetime2-trial_time)>=preCueISI+CueDuration+postCueISI  && (eyetime2-trial_time)<preCueISI+CueDuration+postCueISI+stimulusduration && stopchecking>1
                    % present target
                    if AssessmentType==1
                        Screen('DrawTexture', w, texture, [], imageRect_offs, ori,[], contr );
                        Screen('DrawTexture', w, texture, [], imageRect_offs2, ori2,[], contr );                     
                    elseif AssessmentType==2
                        if exist('imageRect_offsCI')==0    % destination rectangle for CI stimuli
                            imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(trial),...
                                imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(trial)];
                            imageRect_offsCI2=imageRect_offsCI;
                            %                         imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                            imageRectMask = CenterRect([0, 0,  CIstimulussize+maskthickness CIstimulussize+maskthickness], wRect);
                            imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
                                imageRectMask(3)+eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];
                            
                            % other shapes
                            imageRect_offsCI3 =[imageRectSmall(1)+eccentricity_XCI'-eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(trial),...
                                imageRectSmall(3)+eccentricity_XCI'-eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(trial)];
                            imageRect_offsCI4=imageRect_offsCI3;
                            %                         imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                            %   imageRectMask2 = CenterRect([0, 0,  CIstimulussize+maskthickness CIstimulussize+maskthickness], wRect);
                            imageRect_offsCImask2=[imageRectMask(1)-eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
                                imageRectMask(3)-eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];
                        end
                        %here I draw the target contour
                        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
                        imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
                        if demo==0
                            Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], 0.7 );
                        end
                        % here I draw the circle within which I show the contour target
                        Screen('FrameOval', w,[gray], imageRect_offsCImask, maskthickness/2, maskthickness/2);
                        Screen('FrameOval', w,gray, imageRect_offsCImask, 22, 22);
                        
                        %here I draw the other contour
                        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI3' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori2,[], Dcontr );
                        imageRect_offsCI4(setdiff(1:length(imageRect_offsCI3),targetcord),:)=0;
                        if demo==0
                            Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI4' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori2,[], 0.7 );
                        end
                        % here I draw the circle within which I show the contour target
                        Screen('FrameOval', w,[gray], imageRect_offsCImask2, maskthickness/2, maskthickness/2);
                        Screen('FrameOval', w,gray, imageRect_offsCImask2, 22, 22);
                        imagearray{trial}=Screen('GetImage', w);
                    end
                    if exist('stimstar')==0
                                      stim_start = GetSecs; %AS 4-28-23 don't use get-secs @Andrew please replace with datapixx time from when the stim started
                     
                         if datapixxtime==1
                                Datapixx('RegWrRd');
                                stim_start_frame = Datapixx('GetTime');     
                         elseif datapixxtime==0
                        stim_start_frame=eyetime2;
                         end
                         stimstar=1;
                   end
                if responsebox==0
                if keyCode(escapeKey) ~=0 %AS 4-28-23 Where is the key being bressed @andrew can you help put in the datapixx button presses? 
                        % AYS: did we want a datapixx button to close the
                        % script? I believe using the control room keyboard
                        % to close should work
                        thekeys = find(keyCode);
                        closescript=1;
                        break;
                end
                end
                elseif (eyetime2-trial_time)>=preCueISI+CueDuration+postCueISI+stimulusduration  && (eyetime2-trial_time)<preCueISI+CueDuration+postCueISI+stimulusduration+poststimulustime && stopchecking>1
                                                     
                    if responsebox==0                        
                        if sum(keyCode)~=0
                            thekeys = find(keyCode);
                            if length(thekeys)>1
                                thekeys=thekeys(1);
                            end
                            thetimes=keyCode(thekeys);
                            [secs  indfirst]=min(thetimes);
                            respTime(trial)=secs;
                            foo=(RespType==thekeys);
                            if site == 5 % use DATApixx to play audio @ CAN, AYS 4/29/23
                                if foo(theans(trial)) % if correct response
                                    resp = 1;
                                    Datapixx('WriteAudioBuffer', corrS', 0); % loads data into buffer
                                    Datapixx('SetAudioSchedule',0,fs,length(corrS'),3,0,length(corrS'));
                                else
                                    resp = 0; % if wrong response
                                    Datapixx('WriteAudioBuffer', corrS', 0); % loads data into buffer
                                    Datapixx('SetAudioSchedule',0,fs,length(errorS'),3,0,length(errorS'));
                                end
                                Datapixx('StartAudioSchedule');
                                Datapixx('RegWrRd'); % synchronize Datapixx registers to local register cache
                            else
                                if foo(theans(trial)) % if correct response
                                    resp = 1;
                                    PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer %AS 4-28-23 @Andrew add  Datapixx sound commands
                                elseif (thekeys==escapeKey) % esc pressed
                                    closescript = 1;
                                    ListenChar(0); %AS 4-28-23 We cannot use ListenChar This is deprcated. We need either KbQueue for UAB and Datapixx button for UCR
                                    break;
                                else
                                    resp = 0; % if wrong response
                                    PsychPortAudio('FillBuffer', pahandle, errorS' ); % loads data into buffer %AS 4-28-23 @Andrew add  Datapixx sound commands
                                end
                                PsychPortAudio('Start', pahandle); %AS 4-28-23 @Andrew add  Datapixx sound commands
                            end
                        end
                    elseif responsebox==1
                        if (buttonLogStatus.newLogFrames > 0) && respgiven==0
                            respTime(trial)=secs;
                            foo=(RespType==thekeys);
                            if site == 5 % use DATApixx to play audio @ CAN, AYS 4/29/23
                                if foo(theans(trial)) % if correct response
                                    resp = 1;
                                    Datapixx('WriteAudioBuffer', corrS', 0); % loads data into buffer
                                    Datapixx('SetAudioSchedule',0,fs,length(corrS'),3,0,length(corrS'));
                                else
                                    resp = 0; % if wrong response
                                    Datapixx('WriteAudioBuffer', corrS', 0); % loads data into buffer
                                    Datapixx('SetAudioSchedule',0,fs,length(errorS'),3,0,length(errorS'));
                                end
                                Datapixx('StartAudioSchedule');
                                Datapixx('RegWrRd'); % synchronize Datapixx registers to local register cache
                            else
                                if foo(theans(trial)) % if correct response
                                    resp = 1;
                                    PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer %AS 4-28-23 @Andrew add  Datapixx sound commands
                                elseif (thekeys==escapeKey) % esc pressed
                                    closescript = 1;
                                    ListenChar(0); %AS 4-28-23 We cannot use ListenChar This is deprcated. We need either KbQueue for UAB and Datapixx button for UCR
                                    break;
                                else
                                    resp = 0; % if wrong response
                                    PsychPortAudio('FillBuffer', pahandle, errorS' ); % loads data into buffer %AS 4-28-23 @Andrew add  Datapixx sound commands
                                end
                                PsychPortAudio('Start', pahandle); %AS 4-28-23 @Andrew add  Datapixx sound commands
                            end
                            respgiven=1;
                        end
                    end              

                elseif (eyetime2-trial_time)>=preCueISI+CueDuration+postCueISI+stimulusduration+poststimulustime
            duda=1;
didi=eyetime2;
didu=trial_time;
        eyechecked=10^4; % exit loop for this trial
                end
            %% here I draw the scotoma, elements below are called every frame
            %AS 4-28-23 Do we have the scotoma in the scanner? I didn't
            %think so
            eyefixation5
          if restscreen==0
                  if ScotomaPresent == 1 % do we want the scotoma? (default is yes)
                Screen('FillOval', w, scotoma_color, scotoma);
            else % else we get a fixation cross and no scotoma
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
                  end
              end
            if demo==1
                if penalizeLookaway>0
                    if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                        Screen('FillRect', w, gray);
                    end
                end
            end 
            if datapixxtime==1
                [eyetime3, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
                VBL_Timestamp=[VBL_Timestamp eyetime3 ];
                datapixx_Timestamp=[datapixx_Timestamp eyetime2];
dd(length(datapixx_Timestamp))=trial_time;
            else
                [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
                VBL_Timestamp=[VBL_Timestamp eyetime2];
            end          
            %% process eyedata in real time (fixation/saccades)
            if EyeTracker==1 %AS 4-28-23 Do we need any of this or just get eye-tracking data at the end of the trial? @Andrew can you help Marcello with that code?
                    GetEyeTrackerDataNew
                GetFixationDecision
                if EyeData(end,1)<8000 && stopchecking<0
                    if datapixxtime==1
                        trial_time=Datapixx('GetTime');%
                    elseif datapixxtime==0
                        trial_time = GetSecs; %start timer if we have eye info
                    end
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
%             if site == 5 % DATApixx AYS 5/4/23 I added some documentation for WaitForEvent_Jerry - let me know if you have questions.
%                 [Bpress, RespTime, TheButtons] = WaitForEvent_Jerry(responseduration, TargList, startime);
%             else % AYS: UCR and UAB?
%                 [keyIsDown, keyCode] = KbQueueCheck; %AS 4-28-23 @Andrew add  Datapixx button press as an option
%             end
            if responsebox==1 && site ~=5 % DATApixx AYS 5/4/23 I added some documentation for WaitForEvent_Jerry - let me know if you have questions.
                %  [Bpress, RespTime, TheButtons] = WaitForEvent_Jerry(0, TargList);
                Datapixx('RegWrRd');
                buttonLogStatus = Datapixx('GetDinStatus');
                if (buttonLogStatus.newLogFrames > 0)
                    [thekeys secs] = Datapixx('ReadDinLog');
                end
                %         [keyIsDown, keyCode] = KbQueueCheck;
            elseif responsebox==1 && site == 5 % DATApixx AYS 5/4/23 I added some documentation for WaitForEvent_Jerry - let me know if you have questions.
                [Bpress, RespTime, TheButtons] = WaitForEvent_Jerry(responseduration, TargList, startime);
                
            else % AYS: UCR and UAB?
                [keyIsDown, keyCode] = KbQueueCheck;
            end
        end
        %% response processing
    if exist('secs')==0
    secs=nan;
    end
        stim_stop=secs;
        clear secs
        if exist('thekeys')==0
             thekeys=nan;   
        end
            if exist('resp')==0
             resp=nan;   
        end    
        cheis(kk)=thekeys;
        time_stim(kk) = stim_stop - stim_start_frame;
        rispo(kk)=resp;
        % -----------------------------------------------------------------------------------
        if (mod(trial,150))==1 && trial>1
            save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
        end       
        coordinate(trial).x=theeccentricity_X/pix_deg;
        coordinate(trial).y=theeccentricity_Y/pix_deg;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];        
        SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
        rectimage{kk}=imageRect_offs;
        if exist('endExp')
            totalduration=(endExp-startExp)/60;
        end
        %% record eyelink-related variables
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
            if exist('stim_start')
                EyeSummary.(TrialNum).TimeStamps.Fixation = stim_start;
            end
            if AssessmentType~=3
                EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;
            end
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
        if closescript==1
            break;
        end
        kk=kk+1;
        %% jitter code @ trial loop end, AYS 4/28/23. See also jitter code @ trial loop start
        if site == 5
            Datapixx('RegWrRd');
            TrialEndTimeD(trial)=Datapixx('GetTime');
            TrialinTRsD(trial)=ceil((TrialEndTimeD(trial)-TrialStartTimeD(trial))/TR);
            TRcount=TRcount+TrialinTRsD(trial);
        end 
        %% 
    end
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    
    ListenChar(0);
    Screen('Flip', w);
 %   KbQueueWait;
    
    %% shut down EyeTracker and screen functions 
    if EyetrackerType==1
        Eyelink('StopRecording');
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    elseif EyetrackerType==2     %AS 4-28-23 @Andrew add  Datapixx commands  
        Datapixx('StopTPxSchedule');
        Datapixx('RegWrRd');
        finish_time = Datapixx('GetTime');
        Datapixx('SetTPxSleep');
        Datapixx('RegWrRd');
        Datapixx('Close');
    end
    
    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    ShowCursor;
    Screen('CloseAll');
    PsychPortAudio('Close', pahandle);     %AS 4-28-23 @Andrew add  Datapixx commands 

    if site == 5 % AYS 5/4/23
        Datapixx('StopDinLog');
        Datapixx('RegWrRd');
        finish_time = Datapixx('GetTime');
        Datapixx('Close');
    end
    
catch ME
    if site == 5 && EyetrackerType==2 && Datapixx('IsReady') % AYS 5/4/23
        Datapixx('StopTPxSchedule');
        status = Datapixx('GetTPxStatus');
        toRead = status.newBufferFrames;
        [bufferData, underflow, overflow] = Datapixx('ReadTPxData', toRead);
        save(eyetrack_fname,'bufferData'); 
    end
    if Datapixx('IsReady')
        Datapixx('StopDinLog');
        Datapixx('Close');
    end
    psychlasterror()
end