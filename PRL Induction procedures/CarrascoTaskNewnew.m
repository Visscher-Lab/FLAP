% Exogenous/endogenous switch task
% written by Marcello A. Maniglia August 2022
close all;
clear all;
clc;
commandwindow

addpath([cd '/utilities']);
try
    prompt={'Participant name', 'day','site? UCR(1), UAB(2), Vpixx(3)','scotoma active','scotoma Vpixx active', 'demo (0) or session (1)',  'eye? left(1) or right(2)', 'Calibration? yes (1), no(0)'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '1', '1','0', '0','2','0' };
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
    whicheye=str2num(answer{7,:}); % which eye to track (vpixx only)
    calibration=str2num(answer{8,:}); % do we want to calibrate or do we skip it? only for Vpixx
    
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a data folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    
    if Isdemo==0
        filename='_newcarrasco_practice';
    elseif Isdemo==1
        filename='_newcarrasco';
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
    
    %% space parameters
    scotomadeg=6; % scotoma size in deg
    stimulusSize=2; %stimulus size in deg
    attContr= 0.35; % contrast of the target
    fixwindow=3;  %degrees
    PRLecc=7.5;         %%eccentricity of PRLs
    xlocs=[0 PRLecc 0 -PRLecc]; %PRL coordinates
    ylocs=[-PRLecc 0 PRLecc 0 ]; %PRL coordinates
    dotsize=0.6; %size of the dots constituting the peripheral diamonds in deg
    dotecc=2; %eccentricity of the dot with respect to the center of the TRL in deg
    
    %% time parameters
    Jitter=[0.5:0.5:2]; %jitter array for trial start in seconds
    cueonset=0.5; % time between first O and the cue
    cueduration=[0.05 0.05 0.133 0.133]; % cue duration
    cueISI=[ 0.05 0.05 0.133 0.133]; % cue to target ISI
    circleduration=0.133; % duration of the first O
    presentationtime=1.133; % duration of the C
    posttargetcircleduration=0.133;
    posttargetISIduration= 0.233;
    fixTime=0.1/3;
    effectivetrialtimeout=5; %max time duration for a trial (otherwise it counts as elapsed)
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
    
    %% Sound
    InitializePsychSound(1); %'optionally providing
    % the 'reallyneedlowlatency' flag set to one to push really hard for low
    % latency'.
    pahandle = PsychPortAudio('Open', [], 1, 0, 44100, 2);
    if site<3
        pahandle1 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
        pahandle2 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    elseif site==3 % Windows
        
        pahandle1 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
        pahandle2 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
    end
    try
        [errorS freq] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
        [corrS freq] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
    end
    PsychPortAudio('FillBuffer', pahandle1, corrS' ); % loads data into buffer
    PsychPortAudio('FillBuffer', pahandle2, errorS'); % loads data into buffer
    
    %% creating stimuli
    bg_index =round(gray*255); %background color
    [xc, yc] = RectCenter(wRect);
    eccentricity_X=xlocs*pix_deg;
    eccentricity_Y=ylocs*pix_deg;
    imsize=stimulusSize*pix_deg;
    createO
    scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
    scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
    scotoma_color=[200 200 200];
    imageRect = CenterRect([0, 0, (stimulusSize*pix_deg) (stimulusSize*pix_deg)], wRect);
    fixwindowPix=fixwindow*pix_deg; % fixation window
    
    %% trial matrix
    
    thelocs=1:length(xlocs); % PRL locations
    cueconditions =[1:4]; %1= cued exo, 2=uncued exo, 3=cued endo, 4=uncued endo
    tr_per_condition=16;  %50
    
    mixtr= repmat(fullfact([length(thelocs) length(cueconditions)]), tr_per_condition,1);
    
    mixtr(mixtr(:,1)==mixtr(:,2),:)= [];
    mixtr=mixtr(randperm(length(mixtr)),:);
    
    
    mixtr1= [mixtr ones(length(mixtr),1)];
    mixtr2= [mixtr ones(length(mixtr),1)*2];
    mixtr=[mixtr1;mixtr2];
    
    load  CarrascoMatrixII.mat
    
    if Isdemo==0
        %  mixtr=[2,3;1,1;2,4;3,2;4,1]; % if it's practice time, just assign random mixtr combination
        
        
        mixtr=[totalmixtr(1:5,:) ;mixtr1(1:5,:) ones(5,1)];
    else
        mixtr= totalmixtr;
    end
    
    totalmixtr=length(mixtr);
    %% response
    
    KbName('UnifyKeyNames');
    
    RespType(1) = KbName('LeftArrow');
    RespType(2) = KbName('RightArrow');
    RespType(3) = KbName('UpArrow');
    RespType(4) = KbName('DownArrow');
    
    escapeKey = KbName('ESCAPE');	% quit key
    
    
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
    
    if EyetrackerType==1
        eyelinkCalib % calibrate eyetracker, if Eyelink
    end
    
    %% main loop
    HideCursor;
    ListenChar(2);
    counter = 0;
    WaitSecs(1);
    % Select specific text font, style and size:
    Screen('TextFont',w, 'Arial');
    Screen('TextSize',w, 42);
    Screen('FillRect', w, gray);
    DrawFormattedText(w, 'You will see two stimuli in each trial. \n \n Report the orientation of the gap of the C \n \n using the keyboard arrows \n \n \n \n Press any key to start', 'center', 'center', white);
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
    
    
    eyetime2=0;
    closescript=0;
    kk=1;
    
    
    
    exocuearray=[1, 5, 9, 13];
    for trial=1:totalmixtr
        
        
        if mod(trial,50)==0
            interblock_instruction
            
        end
        trialTimedout(trial)=0; % count trials that trialed-out
        TrialNum = strcat('Trial',num2str(trial));
        trialonsettime=Jitter(randi(length(Jitter))); % pick a jittered start time for trial
        trialTimeout=effectivetrialtimeout+trialonsettime; % update the max trial duration accounting for the jittered start
        
        % compute target location (and exo cue location)
        theeccentricity_X=eccentricity_X(mixtr(trial,2));
        theeccentricity_Y=eccentricity_Y(mixtr(trial,2));
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
        
        % compute response for trial
        theoris =[-180 0 -90 90];
        theans(trial)=randi(4);
        ori=theoris(theans(trial));
        
        Priority(0);
        eyechecked=0;
        VBL_Timestamp=[];
        FixCount=0;
        FixatingNow=0;
        EndIndex=0;
        
        fixating=0;
        counter=0;
        framecounter=0;
        xeye=[];
        yeye=[];
        KbQueueFlush()
        trial_time=-1000;
        stopchecking=-100;
        trial_time=100000;
        clear starfix
        clear EyeData
        clear FixIndex
        
        pretrial_time=GetSecs;
        while eyechecked<1
            
            if ScotomaPresent == 1
                fixationscriptW
                CarrascoStimuli
            end
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            
            if  (eyetime2-pretrial_time)>=0 && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                IsFixatingSquare % check for the eyes to stay in the fixation window for enough (fixTime) frames
                
                if ScotomaPresent == 1
                    fixationscriptW
                end
            elseif (eyetime2-pretrial_time)>ifi && fixating>=fixTime/ifi && stopchecking>1 && fixating<1000 && (eyetime2-pretrial_time)<=trialTimeout
                trial_time = GetSecs;
                fixating=1500;
                
            end
            currentcueISI=cueISI(mixtr(trial,2));
            currentcueduration=cueduration(mixtr(trial,2));
            
            if (eyetime2-trial_time)>=0 && (eyetime2-trial_time)<trialonsettime+ifi*2 && fixating>400 && stopchecking>1
                clear imageRect_offsCirc
                clear cuegenerator
                clear Dotloc
                clear subimageRect_offs_cue
            elseif (eyetime2-trial_time)>=trialonsettime && (eyetime2-trial_time)<trialonsettime+ifi*2+circleduration && fixating>400 && stopchecking>1
                %    Screen('DrawTexture', w, theCircles, [], imageRect_offso, ori,[], attContr);
                % compute cue
                if mixtr(trial,3)== 1 %exo cue
                    
                    if    mixtr(trial,4)== 1 %congruent exo cue
                        
                        subimageRect_offs_cue=imageRect_offs_cue(exocuearray(mixtr(trial,2)):exocuearray(mixtr(trial,2))+3,:);
                    elseif mixtr(trial,4)== 0 %incongruent exo cue
                        inconexocuearray=exocuearray;
                        if exist('cuegenerator')==0
                            cuegenerator=9;
                            newlocincogruent=inconexocuearray(inconexocuearray~=inconexocuearray(mixtr(trial,2)));
                            thisnewlocincogruent=newlocincogruent(randi(length(newlocincogruent)));
                            subimageRect_offs_cue=imageRect_offs_cue(thisnewlocincogruent:thisnewlocincogruent+3,:);
                        end
                        
                    end
                    
                elseif mixtr(trial,3)== 2 %endo cue
                    % compute endo cue location
                    pickloc=mixtr(trial,1);
                    tut(trial)=1
                    whichDot=((pickloc*4)-3); % which diamond?
                    
                    if pickloc==1 & mixtr(trial,2)== 2 || pickloc==3 & mixtr(trial,2)== 2 || pickloc==4 & mixtr(trial,2)== 2
                        Dotloc=whichDot+1;
                    elseif pickloc==1 & mixtr(trial,2)== 3 || pickloc==2 & mixtr(trial,2)== 3 || pickloc==4 & mixtr(trial,2)== 3
                        Dotloc=whichDot+2;
                    elseif pickloc==1 & mixtr(trial,2)== 4 || pickloc==2 & mixtr(trial,2)== 4 || pickloc==3 & mixtr(trial,2)== 4
                        Dotloc=whichDot+3;
                    elseif pickloc==2 & mixtr(trial,2)== 1 || pickloc==3 & mixtr(trial,2)== 1 || pickloc==4 & mixtr(trial,2)== 1
                        Dotloc=whichDot;
                    end
                    
                    diffLoc=(Dotloc-whichDot)+1;
                    
                    if    mixtr(trial,4)== 1 %congruent endo cue
                        
                        subimageRect_offs_cue=imageRect_offs_cue(Dotloc,:);
                        
                    elseif  mixtr(trial,4)== 0 %incongruent endo cue
                        
                        
                        if exist('cuegenerator')==0
                            endoinc=1:4;
                            newlocincogruent=(endoinc(endoinc~=diffLoc))-1;
                            Dotloc=whichDot+newlocincogruent(randi(length(newlocincogruent)));
                            subimageRect_offs_cue=imageRect_offs_cue(Dotloc,:);
                            cuegenerator=9;
                        end
                    end
                end
            elseif (eyetime2-trial_time)>=trialonsettime+ifi*2+cueonset+circleduration && (eyetime2-trial_time)<trialonsettime+ifi*2+cueonset+currentcueduration+circleduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                % present cue
                Screen('FillOval', w, [255  255 255], subimageRect_offs_cue');
                
                
                %     if mixtr(trial,2)== 1 ||  mixtr(trial,2)== 3
                %     end
                clear imageRect_offs
                %  clear subimageRect_offs_cue
            elseif (eyetime2-trial_time)>=trialonsettime+ifi*2+cueonset+currentcueduration+circleduration && (eyetime2-trial_time)<trialonsettime+ifi*2+cueonset+currentcueduration+currentcueISI+circleduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                % cue-target ISI
            elseif (eyetime2-trial_time)>=trialonsettime+ifi*2+cueonset+currentcueduration+currentcueISI+circleduration && (eyetime2-trial_time)<trialonsettime+ifi*2+cueonset+currentcueduration+currentcueISI+presentationtime+circleduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                % show target
                if exist('imageRect_offs')==0
                    imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
                        imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
                    imageRect_offscircle=[imageRect_offs(1)-(0.635*pix_deg) imageRect_offs(2)-(0.635*pix_deg) imageRect_offs(3)+(0.635*pix_deg) imageRect_offs(4)+(0.635*pix_deg) ];
                    stim_start=eyetime2;
                end
                Screen('FillOval',w, gray,imageRect_offscircle);
                Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], attContr);
                if keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0
                    % wait for response
                    thekeys = find(keyCode);
                    if length(thekeys)>1
                        thekeys=thekeys(1);
                    end
                    thetimes=keyCode(thekeys);
                    [secs  indfirst]=min(thetimes);
                    respTime=secs;
                    mao(trial)=99;
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
                end
            elseif (eyetime2-trial_time)>=trialonsettime+ifi*2+cueonset+currentcueduration+currentcueISI+circleduration && (eyetime2-trial_time)<trialonsettime+ifi*2+cueonset+currentcueduration+currentcueISI+presentationtime+circleduration+posttargetISIduration && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout%
                % wait for response
                thekeys = find(keyCode);
                if length(thekeys)>1
                    thekeys=thekeys(1);
                end
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
                respTime=secs;
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
            elseif (eyetime2-trial_time)>=trialonsettime+ifi*2+cueonset+currentcueduration+currentcueISI+presentationtime+circleduration+posttargetISIduration && (eyetime2-trial_time)<trialonsettime+ifi*2+cueonset+currentcueduration+currentcueISI+presentationtime+circleduration+posttargetcircleduration+posttargetISIduration && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout%
                % O after target and wait for response
                Screen('FillOval',w, gray,imageRect_offscircle);
                Screen('DrawTexture', w, theCircles, [], imageRect_offs, ori,[], attContr);
                thekeys = find(keyCode);
                if length(thekeys)>1
                    thekeys=thekeys(1);
                end
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
                respTime=secs;
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
            elseif (eyetime2-trial_time)>=trialonsettime+ifi*2+cueonset+currentcueduration+currentcueISI+presentationtime+circleduration+posttargetISIduration && (eyetime2-trial_time)<trialonsettime+ifi*2+cueonset+currentcueduration+currentcueISI+presentationtime+circleduration+posttargetcircleduration+posttargetISIduration && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout%
                % O after target and no
                % response
                Screen('FillOval',w, gray,imageRect_offscircle);
                Screen('DrawTexture', w, theCircles, [], imageRect_offs, ori,[], attContr);
                
            elseif (eyetime2-trial_time)>=trialonsettime+ifi*2+cueonset+currentcueduration+currentcueISI+presentationtime+circleduration+posttargetcircleduration+posttargetISIduration && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout%
                %wait for response after the O after the target
                
                thekeys = find(keyCode);
                
                if length(thekeys)>1
                    thekeys=thekeys(1);
                end
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
                respTime=secs;
                eyechecked=10^4;
                
            elseif (eyetime2-trial_time)>=trialonsettime+ifi*2+cueonset+currentcueduration+currentcueISI+presentationtime+circleduration+posttargetcircleduration+posttargetISIduration && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout%
                if mao(1,trial)==99
                    eyechecked=10^4;
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
                colorfixation = white;
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
        if trialTimedout(trial)== 0 && mao(trial)<99
            stim_stop=secs;
            cheis(kk)=thekeys;
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
        elseif trialTimedout(trial)== 1
            resp = 0;
            respTime=0;
            PsychPortAudio('Start', pahandle2);
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