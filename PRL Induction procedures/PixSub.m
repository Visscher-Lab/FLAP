% Contrast threshold measurement with randomized position of the target -
% wait until response
close all; clear all; clc;
commandwindow

addpath([cd '/CrowdingDependencies']);
addpath([cd '/utilities']); %add folder with utilities files

%RTBox('clear');a
try
    prompt={'Participant Name', 'day','site? UCR(1), UAB(2), Vpixx(3)', 'Training type (lat int (0), noise (1) )', 'Demo? (1:yes, 2:no)', 'Eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Scotoma? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?', 'fovea (1) or periphery (2}'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '3', '1', '2' , '2', '0', '0', '0', '1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    penalizeLookaway=0;   %mostly for debugging, we can remove the masking on the target when assigned PRL ring is out of range
    expDay=str2num(answer{2,:}); % training day (if >1
    site = str2num(answer{3,:}); % training site (UAB vs UCR vs Vpixx)
    trainingType=str2num(answer{4,:}); % training type: 1=noise, 0=lat int
    test=str2num(answer{5,:}); % are we testing in debug mode?
    %test=demo;
    whicheye=str2num(answer{6,:}); % are we tracking left (1) or right (2) eye? Only for Vpixx
    calibration=str2num(answer{7,:}); % do we want to calibrate or do we skip it? only for Vpixx
    ScotomaPresent = str2num(answer{8,:}); % 0 = no scotoma, 1 = scotoma
    EyeTracker = str2num(answer{9,:}); %0=mouse, 1=eyetracker
    TargetLoc = str2num(answer{10,:}); %0=mouse, 1=eyetracker

    %load (['../PRLocations/' name]);
    cc = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    
    if trainingType==0
        baseName=['.\data\' SUBJECT '_LatIn ' num2str(expDay) '_' num2str(cc(1)) '_' num2str(cc(2)) '_' num2str(cc(3)) '_' num2str(cc(4))];
    else
        baseName=['.\data\' SUBJECT '_PixSub ' num2str(expDay) '_' num2str(cc(1)) '_' num2str(cc(2)) '_' num2str(cc(3)) '_' num2str(cc(4))];
    end
    %% eyetracker initialization (eyelink)
    defineSite
    
    CommonParametersLatInt % define common parameters
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
    %% STAIRCASE
    
    if trainingType==0 % lat int
        cndt=2; % Eccentricity (left vs right side)
        ca=2; % flankers: Iso vs orto
        StartCont=5;  %15
        thresh(1:cndt, 1:ca)=StartCont;
        max_contrast=.7;
        Contlist = log_unit_down(max_contrast+.122, 0.05, 76); %Updated contrast possible values
        Contlist(1)=1;
    else % orientation discrimination in noise
        trials=40; %100;
            %  trials=5; %100;
  blocks=8; %10;
        mixtr=[];
        for ii=1:blocks
            mixtr=[mixtr; ones(trials,1) ones(trials,1)*ii'  ];
        end
        cndt=1; % Eccentricity (left vs right side)
       % ca=1; % empty variable
       ca=blocks;
        StartNoise=13;  %15 we target 25% signal
        thresh(1:cndt, 1:blocks)=StartNoise;
        max_noise=1;
        
        Noiselist=log_unit_down(max_noise+.122, 0.05, 76);
   % below if we want larger step sizes but still start from 25% signal
        %         StartNoise=7;  %15 we target 25% signal
        % Noiselist=log_unit_down(max_noise+.122, 0.1, 76);

     %   Noiselist=fliplr(Noiselist);
    end
    reversals(1:cndt, 1:ca)=0;
    isreversals(1:cndt, 1:ca)=0;
    staircounter(1:cndt, 1:ca)=0;
    corrcounter(1:cndt, 1:ca)=0;
    step=5;
    currentsf=1;
    % Threshold -> 70% (Shibata et al., 2017)
    sc.up = 1;                          % # of incorrect answers to go one step up
    sc.down = 2;                        % # of correct answers to go one step down
    
%    stepsizes=[4 4 3 2 1];   
        stepsizes=[1 1 1 1 1];   

    condlist=fullfact([cndt ca]);
    numsc=length(condlist);
    
   % n_blocks=1;    

 %   n_blocks=round(trials/blocks);   %number of trials per miniblock
    
%     for j=1:blocks
%         for i=1:numsc
%             mixtr=[mixtr;repmat(condlist(i,:),n_blocks,1)];
%         end
%     end
    
    b=mixtr(randperm(length(mixtr)),:);
    %% create stimuli
    createGabors
    %% response
    KbName('UnifyKeyNames')
    
    RespType(1) = KbName('a');
    RespType(2) = KbName('b');
    
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
    %% main loop
    HideCursor;
    counter = 0;
    
    Screen('FillRect', w, gray);
    colorfixation = white;
    if site==4
        DrawFormattedText(w, 'Premi (a) se vedi la griglia nel primo intervallo, premi (b) se si trova nel secondo \n \n \n \n Premi qualsiasi tasto per iniziare', 'center', 'center', white);
    else
        DrawFormattedText(w, 'Press (a) if target in the first interval, press (b) if in the second \n \n \n \n Press any key to start', 'center', 'center', white);
    end
   Screen('Flip', w);
    KbQueueWait;
        WaitSecs(0.7);

    % check EyeTracker status, if Eyelink
    if EyetrackerType == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        Eyelink('message' , 'SYNCTIME');
        location =  zeros(length(mixtr), 6);
    end
    noisestop=0;
    for trial=1:length(mixtr)
        
        % if   (mod(trial,tr*2)==1)
        %         if trial==1
        %             whichInstruction=(mixtr(trial,2))
        %             interblock_instruction_crowd;
        %         elseif mixtr(trial,2)~=mixtr(trial-1,2)
        %                         whichInstruction=(mixtr(trial,2))
        %             interblock_instruction_crowd;
        %         end
        %   end
        
        TrialNum = strcat('Trial',num2str(trial));
        if trial >1 && mixtr(trial-1,2) ~=mixtr(trial,2)
            interblock_instruction
            
        end
        if trainingType==1
            noise_level= Noiselist(thresh(mixtr(trial,1),mixtr(trial,2)));
        else
            contr = Contlist(thresh(mixtr(trial,1),mixtr(trial,2)));
            isorto=mixtr(trial,2);
            if isorto==1
                FlankersOri=0;
            elseif isorto==2
                FlankersOri=90;
            end
        end

        theeccentricity_X=eccentricity_X(mixtr(trial,1));
        theeccentricity_Y=eccentricity_Y(mixtr(trial,1));
        theintervals=[1 2];
        theans(trial)=randi(2); %generates answer for this trial
        interval=theintervals(theans(trial));
        
        %% Initialization/reset of several trial-based variables
        FLAPVariablesReset % reset some variables used in each trial
        
        presentationtime=2;
        while eyechecked<1
            %   fixationtype(w, wRect, fixat,fixationlength, white,pix_deg,AMD);
            
            % constrained fixation loop
            if  (eyetime2-pretrial_time)>=ITI && fixating<fixationduration/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                [fixating counter framecounter ]=IsFixatingSquareNew(wRect,xeye,yeye,fixating,framecounter,counter,fixwindowPix);
                if exist('starfix')==0
                    startfix(trial)=eyetime2;
                    starfix=98;
                end
                playsound=1;
                isinoise=0;
                %  Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
              if ScotomaPresent==1
                  fixationscript
              end
              skiptrial=0;
              soundon=1;
            elseif (eyetime2-pretrial_time)>ITI && fixating>=fixationduration/ifi && stopchecking>1 && fixating<1000 && (eyetime2-pretrial_time)<=trialTimeout
                % forced fixation time satisfied
                trial_time = eyetime2;
                if EyetrackerType ==2
                    Datapixx('SetMarker');
                    Datapixx('RegWrVideoSync');
                    %collect marker data
                    Datapixx('RegWrRd');
                    Pixxstruct(trial).TrialOnset = Datapixx('GetMarker');
                end
                clear imageRect_offs imageRect_offs_flank1 imageRect_offs_flank2 imageRect_offscircle imageRect_offscircle1 imageRect_offscircle2
                clear stimstar subimageRect_offs_cue
                fixating=1500;
            elseif (eyetime2-pretrial_time)>ITI && fixating<1000 && (eyetime2-pretrial_time)>trialTimeout && sum(keyCode)==0
                                     DrawFormattedText(w, 'Chiama lo sperimentatore', 'center', 'center', white);
                                     if soundon==1
                                         PsychPortAudio('FillBuffer', pahandle, errorS');
                                         PsychPortAudio('Start', pahandle);
                                         soundon=0;
                                     end
            elseif (eyetime2-pretrial_time)>ITI && fixating<1000 && (eyetime2-pretrial_time)>trialTimeout && sum(keyCode)>0
                  skiptrial=1;
            eyechecked=10^4;
            end
            
            % beginning of the trial after fixation criteria satisfied in
            % previous loop
            
            if (eyetime2-trial_time)>= ifi*2 && (eyetime2-trial_time)< ifi*2+presentationtime && fixating>400 && stopchecking>1
                if playsound==1
                    PsychPortAudio('FillBuffer', pahandle, bip_sound' )
                    PsychPortAudio('Start', pahandle);
                    playsound=0;
                end
                 
               if trainingType ==0 % create flankers
                imageRect_offs_flank1 =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y+lambdadeg,...
                    imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y+lambdadeg];
                
                imageRect_offs_flank2 =[imageRect(1)+theeccentricity_X+(newsamplex-wRect(3)/2), imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y-lambdadeg,...
                    imageRect(3)+theeccentricity_X+(newsamplex-wRect(3)/2), imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y-lambdadeg];
               end
                imageRect_offs =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                    imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
                                imageRectDot2_offs=[imageRectDot2(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectDot2(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                    imageRectDot2(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectDot2(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
                if trainingType ==1
                    subNoise
                    if interval==1
                        Screen('DrawTexture', w, TheGabors, [], imageRect_offs, ori,[]);
                    else
                        Screen('DrawTexture', w, TheNoise, [], imageRect_offs, ori,[]);
                    end
                                    Screen('FillOval', w, [0.5 0.5 0.5], imageRectDot2_offs);
                    imageRect_offscircle=[imageRect_offs(1)-maskthickness/2 imageRect_offs(2)-maskthickness/2 imageRect_offs(3)+maskthickness/2 imageRect_offs(4)+maskthickness/2 ];
                    Screen('FrameOval', w,gray, imageRect_offscircle, maskthickness/2, maskthickness/2);
                    noisestop=1;
                end
                if trainingType ==0
                    Screen('DrawTexture',w, TheGabors(sf,1), [],imageRect_offs_flank1,FlankersOri,[],flankersContrast); % lettera a sx del target
                    Screen('DrawTexture',w, TheGabors(sf,1), [], imageRect_offs_flank2,FlankersOri,[],flankersContrast); % lettera a sx del target
                    
                    if interval==1
                        Screen('DrawTexture', w, TheGabors(sf,1), [], imageRect_offs, ori,[], contr);
                    else
                    end
                    %      Screen('DrawTexture', w, TheGabors(3,1), [], imageRect_offs, ori,[], 0);
                end
                
                %     Screen('DrawTexture', w, texture(trial), [], imageRect_offs{tloc}, ori,[], contr );
                stim_start = eyetime2;
                
            elseif (eyetime2-trial_time)>= ifi*2+presentationtime && (eyetime2-trial_time)< ifi*2+presentationtime+ISIinterval && fixating>400 && stopchecking>1
                %blank ISI
                if isinoise==0
                    noisestop=0;
                    isinoise=1;
                end
                playsound=1;
                %                 if trainingType ==1
                %                     createNoise
                %                     %   Screen('DrawTexture', w, noisetex)
                %                     Screen('DrawTexture', w, noisetex, [], imageRect_offs, [],[], []);
                %
                %                     %    Screen('FillOval', aperture, [0.5, 0.5,0.5, contr], maskRect )
                %                     %      Screen('DrawTexture', w, aperture, [], dstRect, [], 0)
                %                     noisestop=1;
                %                 end
              
                % if we want noise during ISI
%                 if trainingType ==1
%                     subNoise
%                     Screen('DrawTexture', w, TheNoise, [], imageRect_offs, ori,[]);
%                     Screen('FrameOval', w,[gray], imageRect_offscircle, maskthickness/2, maskthickness/2);
%                     noisestop=1;
%                 end
                
            elseif (eyetime2-trial_time)> ifi*3+presentationtime+ISIinterval && (eyetime2-trial_time)< ifi*3+presentationtime+ISIinterval+presentationtime && fixating>400 && stopchecking>1
                if playsound==1
                    PsychPortAudio('FillBuffer', pahandle, bip_sound' )
                    PsychPortAudio('Start', pahandle);
                    playsound=0;
                    noisestop=0;
                end
          if trainingType ==0      
                imageRect_offs_flank1 =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y+lambdadeg,...
                    imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y+lambdadeg];
                imageRect_offs_flank2 =[imageRect(1)+theeccentricity_X+(newsamplex-wRect(3)/2), imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y-lambdadeg,...
                    imageRect(3)+theeccentricity_X+(newsamplex-wRect(3)/2), imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y-lambdadeg];
          end
          imageRect_offs =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                    imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];                
                                imageRectDot2_offs=[imageRectDot2(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectDot2(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                    imageRectDot2(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectDot2(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
                if trainingType ==1
                    subNoise
                    if interval==2
                        Screen('DrawTexture', w, TheGabors, [], imageRect_offs, ori,[]);
                    else
                        Screen('DrawTexture', w, TheNoise, [], imageRect_offs, ori,[]);
                    end
                                    Screen('FillOval', w, [0.5 0.5 0.5], imageRectDot2_offs);
                    imageRect_offscircle=[imageRect_offs(1)-maskthickness/2 imageRect_offs(2)-maskthickness/2 imageRect_offs(3)+maskthickness/2 imageRect_offs(4)+maskthickness/2 ];
                    Screen('FrameOval', w,gray, imageRect_offscircle, maskthickness/2, maskthickness/2);
                    noisestop=1;
                end
                
                
                if trainingType==0
                    Screen('DrawTexture',w, TheGabors(sf,1), [],imageRect_offs_flank1,FlankersOri,[],flankersContrast ); % lettera a sx del target
                    Screen('DrawTexture',w, TheGabors(sf,1), [], imageRect_offs_flank2,FlankersOri,[],flankersContrast); % lettera a sx del target
                    
                    if interval==2
                        Screen('DrawTexture', w, TheGabors(sf,1), [], imageRect_offs, ori,[], contr);
                    else
                        %           Screen('DrawTexture', w, TheGabors(3,1), [], imageRect_offs, ori,[], 0);
                    end
                end
            elseif (eyetime2-trial_time)> ifi*3+presentationtime+ISIinterval+presentationtime && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey) ==0 && stopchecking>1; %present pre-stimulus and stimulus
                
            elseif (eyetime2-trial_time)> ifi*3+presentationtime+ISIinterval+presentationtime && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey) ~=0 && stopchecking>1; %present pre-stimulus and stimulus
                eyechecked=10^4;
                thekeys = find(keyCode);
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
            end          
            eyefixation5
            
            if ScotomaPresent == 1 % do we want the scotoma? (default is yes)
                Screen('FillOval', w, scotoma_color, scotoma);
                
            else % else we get a fixation cross and no scotoma
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
           if EyeTracker==0
               smallscotoma = [smallscotomarect(1)+(occhi(1)-wRect(3)/2), smallscotomarect(2)+(occhi(2)-wRect(4)/2), smallscotomarect(3)+(occhi(1)-wRect(3)/2), smallscotomarect(4)+(occhi(2)-wRect(4)/2)];
                Screen('FillOval', w, scotoma_color, smallscotoma);
           end
            
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
                    trial_time = GetSecs; %start timer if we have eye info
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
        
        % code the response
if skiptrial==0
        foo=(RespType==thekeys);
        
        staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
       if trainingType==0
           Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=contr;
       else
               Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=noise_level;       
       end
        if foo(theans(trial))
            resp = 1;
            corrcounter(mixtr(trial,1),mixtr(trial,2))=corrcounter(mixtr(trial,1),mixtr(trial,2))+1;

      %                      PsychPortAudio('FillBuffer', pahandle, corrS' )
    %        PsychPortAudio('Start', pahandle);
            
            if corrcounter(mixtr(trial,1),mixtr(trial,2))==sc.down
                                        isreversals(mixtr(trial,1),mixtr(trial,2))=1;
                if isreversals(mixtr(trial,1),mixtr(trial,2))==1
                    reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
                    isreversals(mixtr(trial,1),mixtr(trial,2))=0;
                end
                thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                if thestep>5
                    thestep=5;
                end
                thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) +stepsizes(thestep);
                if trainingType==0
                    thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Contlist));
                else
                    thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Noiselist));
                end
                corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
            end
        elseif (thekeys==escapeKey) % esc pressed
            closescript = 1;
            break;
        else
            resp = 0;
            if  corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                isreversals(mixtr(trial,1),mixtr(trial,2))=1;
            end
            corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
         %   PsychPortAudio('FillBuffer', pahandle, errorS');
         %   PsychPortAudio('Start', pahandle);
            thestep=max(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
            if thestep>5
                thestep=5;
            end
            thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
            thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)),1);
        end
        
        stim_stop=secs;
        time_stim(kk) = stim_stop - stim_start;
        rispo(kk)=resp;
                cheis(kk)=thekeys;
end
        totale_trials(kk)=trial;
        coordinate(trial).x=theeccentricity_X;
        coordinate(trial).y=theeccentricity_Y;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];
        if trainingType==0
            angl(trial).a=FlankersOri;
            kontrast(kk)=contr;
        else
            noisevalues(kk)=noise_level;
            
        end
        righinterval(kk)=interval;

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
            EyeSummary.(TrialNum).TargetX = theeccentricity_X;
            EyeSummary.(TrialNum).TargetY = theeccentricity_Y;
            % EyeSummary.(TrialNum).isorto=isorto;
            EyeSummary.(TrialNum).EventData = EvtInfo;
            clear EvtInfo
            EyeSummary.(TrialNum).ErrorData = ErrorData;
            clear ErrorData
            EyeSummary.(TrialNum).Separation = lambdaSeparation;
            if exist('EndIndex')==0
                EndIndex=0;
            end
            EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
            clear EndIndex
            %  EyeSummary.(TrialNum).EndIndex = EndIndex;
            EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
            EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
            EyeSummary.(TrialNum).TimeStamps.Fixation = stim_start;
            %FixStamp(TrialCounter,1);
            EyeSummary.(TrialNum).TimeStamps.Stimulus = stim_start;
            %StimStamp(TrialCounter,1);
            clear ErrorInfo
        end

        if (mod(trial,50))==1 && trial>1
            save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
        end
        
        if closescript==1
            break;
        end
        kk=kk+1;
    end
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    %% shut down EyeTracker and screen functions
    if EyetrackerType==1
        Eyelink('StopRecording');
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    end
    
    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    ShowCursor;
    Screen('CloseAll');
    PsychPortAudio('Close', pahandle);
    
    
    % %% data analysis (to be completed once we have the final version)
    %
    %
    % %to get each scale in a matrix (as opposite as Threshlist who gets every
    % %trial in a matrix)
    % thresho=permute(Threshlist,[3 1 2]);
    % PRL_iso=thresho(:,1);
    % PRL_ortho=thresho(:,3);
    % NoPRL_iso=thresho(:,2);
    % NoPRL_ortho=thresho(:,4);
    % PRL_iso_thresh=mean(PRL_iso(end-15:end));
    % PRL_ortho_thresh=mean(PRL_ortho(end-15:end));
    %
    % NoPRL_iso_thresh=mean(NoPRL_iso(end-15:end));
    % NoPRL_ortho_thresh=mean(NoPRL_ortho(end-15:end));
    %
    % thresh_elevationPRL=log10(PRL_iso_thresh/PRL_ortho_thresh);
    % thresh_elevationNoPRL=log10(NoPRL_iso_thresh/NoPRL_ortho_thresh);
    %
    % Collinear_differencePRL=PRL_iso_thresh-PRL_ortho_thresh;
    % Collinear_differenceNoPRL=NoPRL_iso_thresh-NoPRL_ortho_thresh;
    % scatter(Collinear_differencePRL, Collinear_differenceNoPRL)
    % xlabel('Collinear difference PRL')
    % ylabel('Collinear difference NoPRL')
    % title('Lateral interaction PRL vs NoPRL')
    %
    %
    % figure
    % scatter(1:length(PRL_iso),PRL_iso )
    % hold on
    % scatter(1:length(PRL_ortho),PRL_ortho)
    % hold on
    %
    % text(30, PRL_iso(1), ['PRL iso thresh = ' num2str(PRL_iso_thresh)])
    % text(30, PRL_ortho(10), ['PRL ortho thresh = ' num2str(PRL_ortho_thresh)])
    %
    % figure
    % scatter(1:length(NoPRL_iso),NoPRL_iso )
    % hold on
    % scatter(1:length(NoPRL_ortho),NoPRL_ortho)
    % hold on
    % text(30, NoPRL_iso(1), ['NoPRL iso thresh = ' num2str(NoPRL_iso_thresh)])
    % text(30, NoPRL_ortho(10), ['NoPRL ortho thresh = ' num2str(NoPRL_ortho_thresh)])
    %
    %
    % figure
    % scatter(thresh_elevationPRL, thresh_elevationNoPRL)
    % xlabel('Threshold elevation PRL')
    % ylabel('Threshold elevation NoPRL')
    % title('Lateral interaction PRL vs NoPRL - threshold elevation')
    %
    %
    % PRLISO=kontrast(1:trials)
    % NoPRLISO=kontrast((trials+1):(trials*2))
    %
    % PRLORTO=kontrast((trials*2+1):(trials*3))
    % NoPRLORTO=kontrast((trials*3+1):(trials*4))
    %
    %
    % figure
    % scatter(1:length(PRLISO),PRLISO )
    % hold on
    % scatter(1:length(PRLORTO),PRLORTO)
    %
    %
    % figure
    % scatter(1:length(NoPRLISO),NoPRLISO)
    % hold on
    % scatter(1:length(NoPRLORTO),NoPRLORTO)
    %
    % %to get the final value for each staircase
    % %final_threshold=thresho(10,1:length(thresho(1,:,1)),1:length(thresho(1,1,:)));
    % %total_thresh= [final_threshold(:,:,1) final_threshold(:,:,2)];
    % %%
    
    
catch ME
    psychlasterror()
end