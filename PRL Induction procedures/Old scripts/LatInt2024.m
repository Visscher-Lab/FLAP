% Contrast threshold measurement with randomized position of the target -
% wait until response
close all; clear all; clc;
commandwindow

addpath([cd '/CrowdingDependencies']);
addpath([cd '/utilities']); %add folder with utilities files
addpath([cd '/../utilities']); %add folder with utilities files

%RTBox('clear');a
try
    prompt={'Participant Name', 'day','site? UCR(1), UAB(2), Vpixx(3)', 'Task type (1: Lat int, 2: noise, 3: ori, 4: symmetrical dots)', 'Demo? (1:yes, 2:no)', 'Eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Scotoma? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?', 'left (1) or right (2) TRL?' };
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '3', '3', '2' , '2', '1', '1', '1', '1'};
%        defaultanswer={'test','1', '3', '3', '1' , '2', '0', '1', '0', '1'};

    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    penalizeLookaway=0;   %mostly for debugging, we can remove the masking on the target when assigned PRL ring is out of range
    expDay=str2num(answer{2,:}); % training day
    site = str2num(answer{3,:}); % training site (UAB vs UCR vs Vpixx)
    taskType=str2num(answer{4,:}); % training type: 1: Lat int, 2: noise, 3: ori, 4: symmetrical dots
    test=str2num(answer{5,:}); % are we testing in debug mode?
    whicheye=str2num(answer{6,:}); % are we tracking left (1) or right (2) eye? Only for Vpixx
    calibration=str2num(answer{7,:}); % do we want to calibrate or do we skip it? only for Vpixx
    ScotomaPresent = str2num(answer{8,:}); % 0 = no scotoma, 1 = scotoma
    EyeTracker = str2num(answer{9,:}); %0=mouse, 1=eyetracker
    TRLlocation= str2num(answer{10,:}); %1=left, 2=right
    expDay=str2num(answer{2,:});
    responsebox=0;
    contingentfirstframe=1; % if we want the stimulus location to be gaze conitngent, but only with rerspoect to the first frame (it doesn;t move acxross the screen to follow the eye)
    %load (['../PRLocations/' name]);
    cc = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    datapixxtime=0;
    %  taskType=1;
    if taskType==1
        baseName=['.\data\' SUBJECT '_LatIn ' num2str(expDay) '_' num2str(cc(1)) '_' num2str(cc(2)) '_' num2str(cc(3)) '_' num2str(cc(4))];
    elseif  taskType==2
        baseName=['.\data\' SUBJECT '_OriInNoise ' num2str(expDay) '_' num2str(cc(1)) '_' num2str(cc(2)) '_' num2str(cc(3)) '_' num2str(cc(4))];
    elseif  taskType==3
        baseName=['.\data\' SUBJECT '_OriDisc ' num2str(expDay) '_' num2str(cc(1)) '_' num2str(cc(2)) '_' num2str(cc(3)) '_' num2str(cc(4))];
    elseif  taskType==4
        baseName=['.\data\' SUBJECT '_OriSym ' num2str(expDay) '_' num2str(cc(1)) '_' num2str(cc(2)) '_' num2str(cc(3)) '_' num2str(cc(4))];
    end
    filename=baseName;
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
    staircaseLatInt
    %% create stimuli
  if taskType~=4
      createGabors
  end
    %% response
    RespType(1) = KbName('a');
    RespType(2) = KbName('b');
    
    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    end
    %% main loop
    HideCursor;
    
    % Select specific text font, style and size:
    %   Screen('TextFont',w, 'Arial');
    %   Screen('TextSize',w, 42);
    %     Screen('TextStyle', w, 1+2);
    Screen('FillRect', w, gray);
    if taskType<3
        DrawFormattedText(w, 'Press (a) if target in the first interval, press (b) if in the second \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif taskType>2
        DrawFormattedText(w, 'Press (a) if target more counterclockwise than reference,press (b) if target more clockwise \n \n \n \n Press any key to start', 'center', 'center', white);
    end
    Screen('Flip', w);
    WaitSecs(1.5);
    KbQueueWait;
    
    
    
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
    noisestop=0;
    %for trial=1:length(mixtr)
    while sum(revcount>0)< reversalsToEnd
        % if   (mod(trial,tr*2)==1)
        %         if trial==1
        %             whichInstruction=(mixtr(trial,2))
        %             interblock_instruction_crowd;
        %         elseif mixtr(trial,2)~=mixtr(trial-1,2)
        %                         whichInstruction=(mixtr(trial,2))
        %             interblock_instruction_crowd;
        %         end
        %   end
        
        FLAPVariablesReset
        TrialNum = strcat('Trial',num2str(trial));
        %  contr = Contlist(thresh(mixtr(trial,1),mixtr(trial,2)));
        
        theeccentricity_X=eccentricity_X(mixtr(trial,1));
        theeccentricity_Y=eccentricity_Y(mixtr(trial,1));
        if taskType==1
            contr = Contlist(thresh(mixtr(trial,1),mixtr(trial,2)));
            isorto=mixtr(trial,2);
            if isorto==1
                FlankersOri=0;
            elseif isorto==2
                FlankersOri=90;
            end
        elseif taskType==2
            noise_level= Noiselist(thresh(mixtr(trial,1),mixtr(trial,2)));
        elseif taskType==3
            ori = Orilist(thresh(mixtr(trial,1),mixtr(trial,2)));
        elseif taskType==4
            ori = Orilist(thresh(mixtr(trial,1),mixtr(trial,2)));
        end
        
        theans(trial)=randi(2); %generates answer for this trial
        if taskType<3
            interval=theintervals(theans(trial));
        elseif taskType>2
            plusORminus=plusminus(theans(trial));
        end
        if  taskType==4
            symmetricDotsCreate
        end
        if EyetrackerType ==2
            %start logging eye data
            Datapixx('RegWrRd');
            Pixxstruct(trial).TrialStart = Datapixx('GetTime');
            Pixxstruct(trial).TrialStart2 = Datapixx('GetMarker');
        end
        %% Initialization/reset of several trial-based variables
        FLAPVariablesReset % reset some variables used in each trial
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
                fixationscript
                if contingentfirstframe==1
                    stopupdatingtgt=0;
                    stopupdating=0;
                end
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
            end
            
            % beginning of the trial after fixation criteria satisfied in
            % previous loop
            
            if (eyetime2-trial_time)>= ifi*2 && (eyetime2-trial_time)< ifi*2+presentationtime && fixating>400 && stopchecking>1
                if playsound==1
                    PsychPortAudio('FillBuffer', pahandle, bip_sound' )
                    PsychPortAudio('Start', pahandle);
                    playsound=0;
                end
                if taskType ==1 % destination rect for flankers only for collinear task
                    if contingentfirstframe==0
                    imageRect_offs_flank1 =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y+lambdadeg,...
                        imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y+lambdadeg];
                    
                    imageRect_offs_flank2 =[imageRect(1)+theeccentricity_X+(newsamplex-wRect(3)/2), imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y-lambdadeg,...
                        imageRect(3)+theeccentricity_X+(newsamplex-wRect(3)/2), imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y-lambdadeg];
                    elseif contingentfirstframe==1
                        if stopupdating==0
                           imageRect_offs_flank1 =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y+lambdadeg,...
                        imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y+lambdadeg];
                    
                    imageRect_offs_flank2 =[imageRect(1)+theeccentricity_X+(newsamplex-wRect(3)/2), imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y-lambdadeg,...
                        imageRect(3)+theeccentricity_X+(newsamplex-wRect(3)/2), imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y-lambdadeg];
                       stopupdating=1;
                        end
                    end
                end
                
               if taskType~=4
                   if contingentfirstframe==0
                imageRect_offs =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                    imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
                 elseif contingentfirstframe==1
                     if stopupdatingtgt==0
                     imageRect_offs =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                    imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
  stopupdatingtgt=1;
                     end
                 end
            end
                if taskType ==1
                    Screen('DrawTexture',w, TheGabors(sf,1), [],imageRect_offs_flank1,FlankersOri,[],flankersContrast); % lettera a sx del target
                    Screen('DrawTexture',w, TheGabors(sf,1), [], imageRect_offs_flank2,FlankersOri,[],flankersContrast); % lettera a sx del target
                    
                    if interval==1
                        Screen('DrawTexture', w, TheGabors(sf,1), [], imageRect_offs, ori,[], contr);
                    else
                    end
                end
                
                if taskType ==2
                    subNoise
                    %   Screen('DrawTexture', w, noisetex)
                    if interval==1
                 %       Screen('DrawTexture', w, TheGabors(sf,1), [], imageRect_offs, ori,[],  contr);
                                         Screen('DrawTexture', w, TheGabors(1,1), [], imageRect_offs, ori,[],  contr);
                    else
                        Screen('DrawTexture', w, TheNoise, [], imageRect_offs, [],[], contr);
                    end
                    
                    %    Screen('FillOval', aperture, [0.5, 0.5,0.5, contr], maskRect )
                    %    Screen('DrawTexture', w, aperture, [], dstRect, [], 0);
                    imageRect_offscircle=[imageRect_offs(1)-maskthickness/2 imageRect_offs(2)-maskthickness/2 imageRect_offs(3)+maskthickness/2 imageRect_offs(4)+maskthickness/2 ];
                    % Screen('FillOval',w, gray,imageRect_offscircle);
                    Screen('FrameOval', w,gray, imageRect_offscircle, maskthickness/2, maskthickness/2);
                    noisestop=1;
                end
                if taskType ==3
                    %    if interval==1
                    Screen('DrawTexture', w, TheGabors(sf,1), [], imageRect_offs, refOri,[], contr);
                    %    else
                    %    end
                    %      Screen('DrawTexture', w, TheGabors(3,1), [], imageRect_offs, ori,[], 0);
                end
                
                if taskType ==4
                    Screen('DrawDots', w, dotcoord', dotSizePix, [1 1 1]);
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
                %                 if noiseOn ==1
                %                     createNoise
                %                     %   Screen('DrawTexture', w, noisetex)
                %                     Screen('DrawTexture', w, noisetex, [], imageRect_offs, [],[], []);
                %
                %                     %    Screen('FillOval', aperture, [0.5, 0.5,0.5, contr], maskRect )
                %                     %      Screen('DrawTexture', w, aperture, [], dstRect, [], 0)
                %                     noisestop=1;
                %                 end
                if contingentfirstframe==1
                    stopupdatingtgt=0;
                    stopupdating=0;
                end
                if taskType ==2
                    subNoise
                    %   Screen('DrawTexture', w, noisetex)
            %%%%%        Screen('DrawTexture', w, TheNoise, [], imageRect_offs, [],[], contr);
                    %    Screen('FillOval', aperture, [0.5, 0.5,0.5, contr], maskRect )
                    %    Screen('DrawTexture', w, aperture, [], dstRect, [], 0);
                    imageRect_offscircle=[imageRect_offs(1)-(0.635*pix_deg) imageRect_offs(2)-(0.635*pix_deg) imageRect_offs(3)+(0.635*pix_deg) imageRect_offs(4)+(0.635*pix_deg) ];
                    %      Screen('FillOval',w, gray,imageRect_offscircle);
          %%%%%         Screen('FrameOval', w,[gray], imageRect_offscircle, maskthickness/2, maskthickness/2);
                    noisestop=1;
                end
                
            elseif (eyetime2-trial_time)> ifi*3+presentationtime+ISIinterval && (eyetime2-trial_time)< ifi*3+presentationtime+ISIinterval+presentationtime && fixating>400 && stopchecking>1
                if playsound==1
                    PsychPortAudio('FillBuffer', pahandle, bip_sound' )
                    PsychPortAudio('Start', pahandle);
                    playsound=0;
                    noisestop=0;
                end
                if taskType ==1
                    if contingentfirstframe==0
                        imageRect_offs_flank1 =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y+lambdadeg,...
                            imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y+lambdadeg];
                        imageRect_offs_flank2 =[imageRect(1)+theeccentricity_X+(newsamplex-wRect(3)/2), imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y-lambdadeg,...
                            imageRect(3)+theeccentricity_X+(newsamplex-wRect(3)/2), imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y-lambdadeg];
                    elseif contingentfirstframe==1
                        if stopupdating==0
                            imageRect_offs_flank1 =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y+lambdadeg,...
                                imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y+lambdadeg];
                            imageRect_offs_flank2 =[imageRect(1)+theeccentricity_X+(newsamplex-wRect(3)/2), imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y-lambdadeg,...
                                imageRect(3)+theeccentricity_X+(newsamplex-wRect(3)/2), imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y-lambdadeg];
                            stopupdating=1;
                        end
                    end
                end
                if taskType~=4
                if contingentfirstframe==0
                imageRect_offs =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                    imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
                
                elseif contingentfirstframe==1
                    if stopupdatingtgt==0
                          imageRect_offs =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                    imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
             stopupdatingtgt=1;
                    end
                end
                end
                if taskType==1
                    Screen('DrawTexture',w, TheGabors(sf,1), [],imageRect_offs_flank1,FlankersOri,[],flankersContrast ); % lettera a sx del target
                    Screen('DrawTexture',w, TheGabors(sf,1), [], imageRect_offs_flank2,FlankersOri,[],flankersContrast); % lettera a sx del target
                    
                    if interval==2
                        Screen('DrawTexture', w, TheGabors(sf,1), [], imageRect_offs, ori,[], contr);
                    else
                        %           Screen('DrawTexture', w, TheGabors(3,1), [], imageRect_offs, ori,[], 0);
                    end
                end
                if taskType ==2
                    subNoise
                    %   Screen('DrawTexture', w, noisetex)
                    if interval==2
%                        Screen('DrawTexture', w, TheGabors(sf,1), [], imageRect_offs, ori,[],  contr);
                                                Screen('DrawTexture', w, TheGabors(1,1), [], imageRect_offs, ori,[],  contr);

                    else
                        Screen('DrawTexture', w, TheNoise, [], imageRect_offs, [],[], contr);
                    end
                    imageRect_offscircle=[imageRect_offs(1)-maskthickness/2 imageRect_offs(2)-maskthickness/2 imageRect_offs(3)+maskthickness/2 imageRect_offs(4)+maskthickness/2 ];
                    % Screen('FillOval',w, gray,imageRect_offscircle);
                    Screen('FrameOval', w,gray, imageRect_offscircle, maskthickness/2, maskthickness/2);
                    noisestop=1;
                end
                
                
                if taskType==3
                    targetOri(trial)=[refOri+(ori*plusORminus)];
                    Screen('DrawTexture', w, TheGabors(sf,1), [], imageRect_offs, [refOri+(ori*plusORminus)],[], contr);
                end
                if taskType ==4
                    Screen('DrawDots', w, dotcoord2', dotSizePix, [1 1 1]);
                end
                
            elseif (eyetime2-trial_time)> ifi*3+presentationtime+ISIinterval+presentationtime && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey) ==0 && stopchecking>1; %present pre-stimulus and stimulus
                %   Screen('Close');
                
            elseif (eyetime2-trial_time)> ifi*3+presentationtime+ISIinterval+presentationtime && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey) ~=0 && stopchecking>1; %present pre-stimulus and stimulus
                eyechecked=10^4;
                thekeys = find(keyCode);
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
            end
            
            eyefixation5
            Screen('FillOval', w, scotoma_color, scotoma);
            
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
        
        %Screen('Close', texture);
        % code the response
        %  foo=(theans==thekeys);
        
        foo=(RespType==thekeys);
        
        staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
        if taskType==1
            Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=contr;
        elseif taskType==2
            Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=noise_level;
        elseif taskType>2
            Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=ori;
        end
        if foo(theans(trial))
            resp = 1;
            corrcounter(mixtr(trial,1),mixtr(trial,2))=corrcounter(mixtr(trial,1),mixtr(trial,2))+1;
            PsychPortAudio('FillBuffer', pahandle, corrS' )
            PsychPortAudio('Start', pahandle);
            
            if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down && trial>sc.down
                if isreversals(mixtr(trial,1),mixtr(trial,2))==2
                    isreversals(mixtr(trial,1),mixtr(trial,2))=1;
                end
            end
            if corrcounter(mixtr(trial,1),mixtr(trial,2))==sc.down
                if isreversals(mixtr(trial,1),mixtr(trial,2))==1
                    revcount(kk) = 2;
                    reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
                    isreversals(mixtr(trial,1),mixtr(trial,2))=0;
                end
                thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
            else
                if taskType == 1
                    thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Contlist));
               elseif taskType == 2
                    thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Noiselist));
                elseif taskType >2 
                    thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Orilist));
                end
            end
            if corrcounter(mixtr(trial,1),mixtr(trial,2))==sc.down % update stimulus intensity
                if thestep>5 %Doesn't this negate the step size of 8 in the step size list? --Denton
                    thestep=5;
                end
                thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) +stepsizes(thestep);
                if taskType == 1
                    thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Contlist));
                elseif taskType == 2
                    thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Noiselist));
                elseif taskType >2
                    thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Orilist));
                end
                if streakon == 0
                    corrcounter(mixtr(trial,1),mixtr(trial,2)) = 0;
                end
            else
                if corrcounter(mixtr(trial,1),mixtr(trial,2))<sc.down % maintain stimulus intensity
                    thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2));
                    if taskType == 1
                        thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Contlist));
                  elseif taskType == 2
                    thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Noiselist));
                elseif taskType >2
                        thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Orilist));
                    end
                end
            end
        elseif (thekeys==escapeKey) % esc pressed
            closescript = 1;
            break;
        else
            resp = 0; % if wrong response
            if   isreversals(mixtr(trial,1),mixtr(trial,2))==0 && trial>1 %corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                isreversals(mixtr(trial,1),mixtr(trial,2))=2;
                revcount(kk)=1.5;
                reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
            end
            corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
            PsychPortAudio('FillBuffer', pahandle, errorS');
            PsychPortAudio('Start', pahandle);
            thestep=max(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
            if thestep>5
                thestep=5;
            end
            thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
            thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)),1);
        end
        
        stim_stop=secs;
        time_stim(kk) = stim_stop - stim_start;
        totale_trials(kk)=trial;
        coordinate(trial).x=theeccentricity_X;
        coordinate(trial).y=theeccentricity_Y;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];
        if taskType ==1
            angl(trial).a=FlankersOri;
            kontrast(kk)=contr;
        end
        rispo(kk)=resp;
        
        cheis(kk)=thekeys;
        if taskType <3
            righinterval(kk)=interval;
        end
        
        %offsetX(kk)=eccentricity_X;
        %offsetY(kk)=eccentricity_Y;
        
        
        
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
               if taskType ==1
            EyeSummary.(TrialNum).Separation = lambdaSeparation;
               end
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
        
        if (mod(trial,50))==1 && trial>1
            save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
        end
        rispo(kk) = resp;
        revve {kk} = isreversals;
        if closescript==1
            break;
        end
        kk=kk+1;
        trial=kk;
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
    
    thresho=permute(Threshlist, [3 1 2]);
    scatter(1:length(thresho), thresho)
    hold on
    scatter(1:length(rispo), rispo/2, 'k');
    hold on
    scatter(1:length(revcount), revcount-1.3, 'r');
    if taskType==2
         ylim([0 1])
    else
        ylim([0 2.2])
    end
catch ME
    psychlasterror()
end