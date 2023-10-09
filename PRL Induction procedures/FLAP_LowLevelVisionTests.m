% Visual Acuity/Crowding/cued-uncued attention task
% written by Marcello A. Maniglia july 2021 %2017/2021
close all;
clear;
clc;
commandwindow
%addpath('/Users/sll/Desktop/Flap/Flap_scripts/utilities')


addpath([cd '/utilities']);
try
    participantAssignmentTable = 'ParticipantAssignmentsUCR_corr.csv'; % this is set for UCR or UAB separately (This is set here so that definesite.m does not have to change)
%     participantAssignmentTable = 'ParticipantAssignmentsUAB_corr.csv'; % uncomment this if running task at UAB

    prompt={'Participant name', 'Assessment day', 'practice (0) or session (1)','Calibration? yes(1), no(0)', 'Task: acuity (1), crowding (2), exo attention (3), contrast (4)',  'Eyetracker(1) or mouse(0)?', 'fixation present? yes(1), no(0)', 'response box (1) or keyboard (0)'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '1', '2', '1', '1', '1', '1'}; 
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    temp= readtable(participantAssignmentTable);
    SUBJECT = answer{1,:}; %Gets Subject Name
    expDay=str2num(answer{2,:});
    t = temp(find(contains(temp.x___participant,SUBJECT)),:); % if computer doesn't have excel it reads as a struct, else it reads as a table
    ScotomaPresent= str2num(t.ScotomaPresent{1,1}); % 0 = no scotoma, 1 = scotoma    
    IsPractice=str2num(answer{3,:}); % full session or demo/practice 
    if strcmp(t.WhichEye{1,1},'R') == 1 % are we tracking left (1) or right (2) eye? Only for Vpixx 
        whicheye = 2;
    else 
        whicheye = 1;
    end
    calibration=str2num(answer{4,:}); % do we want to calibrate or do we skip it? only for Vpixx
    whichTask=str2num(answer{5,:}); % acuity (1), crowding (2), exo attention (3), contrast (4)
    EyeTracker = str2num(answer{6,:}); %0=mouse, 1=eyetracker
    fixationpresent=str2num(answer{7,:});
    responsebox=str2num(answer{8,:});
    if whichTask == 3
        PRLlocations= 3;
    else
        PRLlocations= 2;
    end
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    site=3;  % VPixx
    scotomavpixx= 0;
    datapixxtime=1;
    
    if exist('data')==0
        mkdir('data')
    end
    
    if whichTask==1
        filename='Acuity';
    elseif whichTask==2
        filename='Crowding';
    elseif whichTask==3
        filename='Attention';
    elseif whichTask==4
        filename='Contrast';
    end
    
    if IsPractice==0
        filename2=' practice';
    elseif IsPractice==1
        filename2='';
    end
    folder=cd;
    folder=fullfile(folder, '..\..\datafolder\');

    if site==1
        baseName=[folder SUBJECT filename filename2 '_' num2str(PRLlocations) '_' expDay num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[folder SUBJECT filename filename2 '_' num2str(PRLlocations) '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[folder SUBJECT filename filename2 'Pixx_' num2str(PRLlocations) '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    
    defineSite % initialize Screen function and features depending on OS/Monitor
    
    CommonParametersACA % load parameters for time and space
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
    createO
    
    %% STAIRCASES:
    if whichTask==1    % Acuity
        ca=1; %conditions; one
        Sizelist=log_unit_down(StartSize, 0.1, 90);
        thresh(1:PRLlocations, 1:ca)=3;
    end
    if whichTask==2   % Crowding
        ca=2; % conditions: radial and tangential
        Separationtlist=log_unit_down(max_separation, 0.1, 90); % maybe we want to use 0.03 to get finer thresholds?
        thresh(1:PRLlocations, 1:ca)=2;
    end
    if whichTask==4    % Contrast
        ca=1; %conditions; one
        Contlist=log_unit_down(StartCont, 0.1, 90);
        Contlist(1)=1;
        thresh(1:PRLlocations, 1:ca)=4; %11;
    end
    if whichTask~=3
        % Threshold -> 79%
        sc.up = 1;                          % # of incorrect answers to go one step up
        sc.steps= [2 3];                    % # of correct answers to go one step down
        stepsizes=[2 2 2 1 1 1];
        tr_per_condition=60;  %50
        %         thresh(1:PRLlocations, 1:ca)=9; %25;
        reversals(1:PRLlocations, 1:ca)=0;
        isreversals(1:PRLlocations, 1:ca)=0;
        staircounter(1:PRLlocations, 1:ca)=0;
        corrcounter(1:PRLlocations, 1:ca)=0;
    end
    if whichTask==3
        tr_per_condition=40;
        tr_per_condition=60;
    end
    
    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    end
    %% Trial structure
    if PRLlocations==2
        % acuity
        if whichTask == 1
            coin=str2num(t.AcuityCondition{1,1});
        elseif whichTask == 2
            coin = str2num(t.crowdingCondition{1,1});
        elseif whichTask == 4
            coin = str2num(t.ContrastCondition{1,1});
        end

        if whichTask==1 || whichTask==4
            if coin==1
                % acuity sx first
                mixtr=[ones(tr_per_condition,1); ones(tr_per_condition,1)*2];
            else
                % acuity dx first
                mixtr=[ones(tr_per_condition,1)*2; ones(tr_per_condition,1)];
            end
            mixtr=[mixtr ones(length(mixtr),1)];
            preresp=[ones(tr_per_condition/4,1) ; ones(tr_per_condition/4,1)*2; ones(tr_per_condition/4,1)*3; ones(tr_per_condition/4,1)*4];
            predefinedResp=[preresp(randperm(length(preresp)),:); preresp(randperm(length(preresp)),:)];
        end
        
        if whichTask==2
            %Crowding
            % left - radial and tangential sx
            mixtr1=[ones(tr_per_condition*2,1) [ones(tr_per_condition,1); ones(tr_per_condition,1)*2]];
            %right - radial and tangential dx
            mixtr2=[ones(tr_per_condition*2,1)*2 [ones(tr_per_condition,1); ones(tr_per_condition,1)*2]];
            % left - tangential and radial
            mixtr3 = [ones(tr_per_condition*2,1) [ones(tr_per_condition,1)*2; ones(tr_per_condition,1)]];
            % right - tangential and radial
            mixtr4 = [ones(tr_per_condition*2,1) [ones(tr_per_condition,1)*2; ones(tr_per_condition,1)]];

            if coin==1
                % LR -- LT -- RT -- RR
                mixtr=[mixtr1;mixtr4];
            elseif coin == 2
                % LT -- LR -- RR -- RT
                mixtr=[mixtr3;mixtr2];
            elseif coin == 3
                % RR -- RT -- LT -- LR
                mixtr = [mixtr2; mixtr3];
            else
                % RT -- RR -- LR -- LR
                mixtr = [mixtr4; mixtr1];
            end           
               preresp=[ones(tr_per_condition/4,1) ; ones(tr_per_condition/4,1)*2; ones(tr_per_condition/4,1)*3; ones(tr_per_condition/4,1)*4];
            predefinedResp=[preresp(randperm(length(preresp)),:); preresp(randperm(length(preresp)),:); preresp(randperm(length(preresp)),:); preresp(randperm(length(preresp)),:)];
   
        end
        
        if whichTask==3
            %attention
            mixtrtemp=repmat(fullfact([2 2]),tr_per_condition,1);
            mixtr=mixtrtemp(randperm(length(mixtrtemp)),:);           
                        respmixtrtemp=repmat(fullfact([2 2 4]),tr_per_condition/4,1);
            respmixtr=respmixtrtemp(randperm(length(respmixtrtemp)),:);
            mixtr=respmixtr(:,1:2);
predefinedResp=respmixtr(:,3);
                       % mixtrtemp=repmat(fullfact([2 2]),tr_per_condition/4,1);

            
        end
    elseif PRLlocations==3
        mixtrtemp=repmat(fullfact([3 3]),tr_per_condition,1);
        mixtr=mixtrtemp(randperm(length(mixtrtemp)),:);
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
    presentcue=0;
    
    if whichTask~=3
        resetcounter(1:PRLlocations, 1:ca)=1; %25;
        Threshlist(1:PRLlocations, 1:ca)=0;
    end
    
    if whichTask ~= 1
        imageRect = CenterRect([0,0, stimulussize_crowding stimulussize_crowding], wRect);
    end
    for trial=1:length(mixtr)
        trialTimedout(trial)=0;
        TrialNum = strcat('Trial',num2str(trial));
        if trial==1
            if whichTask==1
                interblock_instruction_acuity
            elseif whichTask==2
                interblock_instruction_crowding
            elseif whichTask==3
                interblock_instruction_attention
            elseif whichTask==4
                interblock_instruction_contrast
            end
        end
        
        if mod(trial,tr_per_condition/2+1)==0 && trial~= length(mixtr)
            interblock_instruction
        end
        
        % if  trial== 5
        %     interblock_instruction
        % end
        %
        theeccentricity_X=eccentricity_X(mixtr(trial,1));
        theeccentricity_Y=eccentricity_Y(mixtr(trial,1));
        %  destination rectangle for the fixation dot
        imageRect_offs_dot=[imageRectDot(1)+theeccentricity_X, imageRectDot(2)+theeccentricity_Y,...
            imageRectDot(3)+theeccentricity_X, imageRectDot(4)+theeccentricity_Y];
        
        if whichTask == 3
            % For the attention task, add the fixation dot to both cue
            % destinations.
            theeccentricity_X_fix=eccentricity_X;
            theeccentricity_Y_fix=eccentricity_Y;
            %  destination rectangle for the fixation dot
            imageRect_offs_dot_fix =[imageRectDot(1)+theeccentricity_X_fix, imageRectDot(2)+theeccentricity_Y_fix,...
                imageRectDot(3)+theeccentricity_X_fix, imageRectDot(4)+theeccentricity_Y_fix];
        end
        
        if whichTask ~=3
            trialTimeout=realtrialTimeout;
        end
        if whichTask ==1
            VAsize = Sizelist(thresh(mixtr(trial,1),mixtr(trial,2)));
            imageRect = CenterRect([0, 0, VAsize*pix_deg VAsize*pix_deg], wRect);
        end
        
        if whichTask ==2
            imageRectFlankOne =imageRect;
            imageRectFlankTwo =imageRect;
            sep = Separationtlist(thresh(mixtr(trial,1),mixtr(trial,2)));
            
            horizontal_eccentricity=eccentricity_X(mixtr(trial,1));
            vertical_eccentricity=eccentricity_Y(mixtr(trial,1));
            radOrtan=mixtr(trial,2);
            if radOrtan==1 % is crowding radial or tangential?
                crowding_angle=atan((vertical_eccentricity)/(horizontal_eccentricity));
            elseif radOrtan==2 && mixtr(trial,1)==2
                crowding_angle=atan((vertical_eccentricity)/(horizontal_eccentricity))+pi/2;
            elseif radOrtan==2 && mixtr(trial,1)==1
                crowding_angle=atan((vertical_eccentricity)/(horizontal_eccentricity))-pi/2;
            elseif radOrtan==2 && mixtr(trial,1)==4
                crowding_angle=atan((vertical_eccentricity)/(horizontal_eccentricity))+pi/2;
            elseif radOrtan==2 && mixtr(trial,1)==3
                crowding_angle=atan((vertical_eccentricity)/(horizontal_eccentricity))-pi/2;
            end
            ecc_r=sep*pix_deg; % critical distance for crowding
            
            %Compute flank one
            ecc_t=crowding_angle;
            cs= [cos(ecc_t), sin(ecc_t)];
            xxyy=[ecc_r ecc_r].*cs;
            ecc_x=xxyy(1);
            ecc_y=xxyy(2);
            eccentricity_X1=ecc_x;
            eccentricity_Y1=ecc_y;
            imageRect_offsFlankOne =[imageRectFlankOne(1)+theeccentricity_X, imageRectFlankOne(2)+theeccentricity_Y,...
                imageRectFlankOne(3)+theeccentricity_X, imageRectFlankOne(4)+theeccentricity_Y];
            
            %Compute flank two
            ecc_t2=-crowding_angle;
            cs= [cos(ecc_t2), sin(ecc_t2)];
            xxyy2=[ecc_r ecc_r].*cs;
            ecc_x2=xxyy2(1);
            ecc_y2=xxyy2(2);
            eccentricity_X2=ecc_x2;
            eccentricity_Y2=ecc_y2;
            
            imageRect_offsFlankTwo =[imageRectFlankTwo(1)+theeccentricity_X, imageRectFlankTwo(2)+theeccentricity_Y,...
                imageRectFlankTwo(3)+theeccentricity_X, imageRectFlankTwo(4)+theeccentricity_Y];
            
            anglout = radtodeg(crowding_angle+pi/2);
            anglout2=radtodeg(crowding_angle);
        end
        
        
        if whichTask ==3
            imageRectCue = CenterRect([0, 0, cueSize*pix_deg cueSize*pix_deg], wRect);
            imageRectCirc= CenterRect([0, 0, circleSize*pix_deg circleSize*pix_deg], wRect);
            currentpostfixationblank=postfixationblank(2);
            currentcueISI=cueISI;
            currentcueduration=cueduration;
        else
            currentpostfixationblank=postfixationblank(1);
            currentcueISI=0;
            currentcueduration=0;
        end
        if whichTask == 4
            contr = Contlist(thresh(mixtr(trial,1),mixtr(trial,2)));
        end
        
        trialTimeout=realtrialTimeout+currentpostfixationblank;
        
        % compute response for trial
        theoris =[-180 0 -90 90];
       % theans(trial)=randi(4);
       theans(trial)=predefinedResp(trial);
        ori=theoris(theans(trial));
        
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
                FLAPVariablesReset

        while eyechecked<1
            if datapixxtime==1
                Datapixx('RegWrRd');
                eyetime2=Datapixx('GetTime');
            end
            
            if ScotomaPresent == 1
                fixationscriptW
            end
            if whichTask==3 && presentcue==0
                ACAExoStimuli
            end
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            
            % constrained fixation loop
            if  (eyetime2-pretrial_time)>=ITI && fixating<fixationduration/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                presentcue=0;
                %   IsFixatingSquare
                [fixating counter framecounter ]=IsFixatingSquareNew(wRect,xeye,yeye,fixating,framecounter,counter,fixwindowPix);
                if exist('starfix')==0
                    
                    if datapixxtime==1
                        startfix(trial)=Datapixx('GetTime');
                       startfix2(trial)= eyetime2;
                    else
                        startfix(trial)=eyetime2;
                    end
                end
                if whichTask ==3
                    % Have fixation dot appear at destinations described
                    % earlier
                    if PRLlocations==2
                        Screen('FillOval', w, fixdotcolor, imageRect_offs_dot_fix(1:2:7));
                        Screen('FillOval', w, fixdotcolor, imageRect_offs_dot_fix(2:2:8));
                    elseif PRLlocations==3
                        Screen('FillOval', w, fixdotcolor, imageRect_offs_dot_fix(1:3:10));
                        Screen('FillOval', w, fixdotcolor, imageRect_offs_dot_fix(2:3:11));
                        Screen('FillOval', w, fixdotcolor, imageRect_offs_dot_fix(2:3:12));
                    end
                else
                    Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                    Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                end
            elseif (eyetime2-pretrial_time)>ITI && fixating>=fixationduration/ifi && stopchecking>1 && fixating<1000 && (eyetime2-pretrial_time)<=trialTimeout
                % forced fixation time satisfied
                if datapixxtime==1
                                    Datapixx('RegWrRd');
                    trial_time = Datapixx('GetTime');
                                        trial_time2 = eyetime2;
                else
                    trial_time = eyetime2;
                end
                if EyetrackerType ==2
                    Datapixx('SetMarker');
                    Datapixx('RegWrVideoSync');
                    %collect marker data
                    Datapixx('RegWrRd');
                    Pixxstruct(trial).TrialOnset = Datapixx('GetMarker');
                end
                %      clear imageRect_offsCirc
                clear imageRect_offs imageRect_offs_flank1 imageRect_offs_flank2 imageRect_offscircle imageRect_offscircle1 imageRect_offscircle2
                clear stimstar subimageRect_offs_cue
                fixating=1500;
            end
            
            % beginning of the trial after fixation criteria satisfied in
            % previous loop
            if (eyetime2-trial_time)>=currentpostfixationblank && (eyetime2-trial_time)<currentpostfixationblank+currentcueduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                presentcue=1;
                if whichTask ==3 % if it's attention task and cue time, prepare cue's destination rect
                    if exist('subimageRect_offs_cue')==0
                        subimageRect_offs_cue=imageRect_offs_cue(exocuearray(mixtr(trial,2)):exocuearray(mixtr(trial,2))+3,:);
                        
                        
                        if exocuearray(mixtr(trial,2))==1
                            subimageRect_offs_cue2=imageRect_offs_cue(exocuearray(2):exocuearray(2)+3,:);
                        else
                            subimageRect_offs_cue2=imageRect_offs_cue(exocuearray(1):exocuearray(1)+3,:);
                        end
                    end
                    Screen('FillOval', w, [255  255 255], subimageRect_offs_cue');
                    Screen('FillOval', w, [0], subimageRect_offs_cue2');
                    
                end
            elseif (eyetime2-trial_time)>=currentpostfixationblank+currentcueduration && (eyetime2-trial_time)<currentpostfixationblank+currentcueISI+currentcueduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                ACAExoStimuli
                presentcue=0;
                %no cue
            elseif (eyetime2-trial_time)>=currentpostfixationblank+currentcueISI+currentcueduration && (eyetime2-trial_time)<currentpostfixationblank+currentcueduration+currentcueISI+stimulusduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                % show target
                if exist('imageRect_offs')==0
                    if whichTask~=3
                        imageRect_offs =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                            imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
                        imageRect_offscircle=[imageRect_offs(1)-(0.635*pix_deg) imageRect_offs(2)-(0.635*pix_deg) imageRect_offs(3)+(0.635*pix_deg) imageRect_offs(4)+(0.635*pix_deg) ];
                    elseif whichTask==3
                        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
                            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
                        imageRect_offscircle=[imageRect_offs(1)-(0.635*pix_deg) imageRect_offs(2)-(0.635*pix_deg) imageRect_offs(3)+(0.635*pix_deg) imageRect_offs(4)+(0.635*pix_deg) ];
                    end
                end
                
                Screen('FillOval',w, gray,imageRect_offscircle); % lettera a sx del target
                if whichTask<3
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], 1);
                elseif whichTask==3
                    %      Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], attContr);
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], 0.7);
                    
                elseif whichTask==4
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], contr );
                end
                if exist('stimstar') == 0
                    stim_start(trial)=eyetime2;
                    if EyetrackerType ==2
                        %set a marker to get the exact time the screen flips
                        Datapixx('SetMarker');
                        Datapixx('RegWrVideoSync');
                        %collect marker data
                        Datapixx('RegWrRd');
                        Pixxstruct(trial).TargetOnset = Datapixx('GetMarker');
                        Pixxstruct(trial).TargetOnset2 = Datapixx('GetTime');
                    end
                    
                    if responsebox==1
                        Datapixx('SetMarker');
                        Datapixx('RegWrVideoSync');
                        %collect marker data
                        Datapixx('RegWrRd');
                        stim_startBox2(trial)= Datapixx('GetMarker');
                        stim_startBox(trial)=Datapixx('GetTime');
                    end
                    stimstar=1;
                end
                
                if whichTask == 2 % show flankers for crowding
                    if exist('imageRect_offs_flank1')==0
                        
                        imageRect_offs_flank1 =[imageRect_offsFlankOne(1)+(newsamplex-wRect(3)/2)+eccentricity_X1, imageRect_offsFlankOne(2)+(newsampley-wRect(4)/2)+eccentricity_Y1,...
                            imageRect_offsFlankOne(3)+(newsamplex-wRect(3)/2)+eccentricity_X1, imageRect_offsFlankOne(4)+(newsampley-wRect(4)/2)+eccentricity_Y1];
                        imageRect_offs_flank2 =[imageRect_offsFlankOne(1)-eccentricity_X2+(newsamplex-wRect(3)/2), imageRect_offsFlankOne(2)+(newsampley-wRect(4)/2)+eccentricity_Y2,...
                            imageRect_offsFlankOne(3)-eccentricity_X2+(newsamplex-wRect(3)/2), imageRect_offsFlankOne(4)+(newsampley-wRect(4)/2)+eccentricity_Y2];
                        imageRect_offscircle1=[imageRect_offs_flank1(1)-(0.1*pix_deg) imageRect_offs_flank1(2)-(0.1*pix_deg) imageRect_offs_flank1(3)+(0.1*pix_deg) imageRect_offs_flank1(4)+(0.1*pix_deg) ];
                        imageRect_offscircle2=[imageRect_offs_flank2(1)-(0.1*pix_deg) imageRect_offs_flank2(2)-(0.1*pix_deg) imageRect_offs_flank2(3)+(0.1*pix_deg) imageRect_offs_flank2(4)+(0.1*pix_deg) ];
                        
                    end
                    Screen('FillOval',w, gray,imageRect_offscircle1); % letter to the left of target
                    Screen('FillOval',w, gray, imageRect_offscircle2); % letter to the right of target
                    
                    Screen('DrawTexture',w, theCircles, [],imageRect_offs_flank1,anglout,[],1 ); % letter to the left of target
                    Screen('DrawTexture',w, theCircles, [], imageRect_offs_flank2,anglout,[],1); % letter to the right of target
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
                        respTime(trial)=secs;
                        eyechecked=10^4;
                    end
                end
            elseif (eyetime2-trial_time)>=currentpostfixationblank+currentcueISI+currentcueduration+stimulusduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout%present pre-stimulus and stimulus
                %after target presentation and no key pressed
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
                        respTime(trial)=secs;
                        eyechecked=10^4;
                    end
                end
            elseif (eyetime2-pretrial_time)>=trialTimeout
                stim_stop=GetSecs;
                trialTimedout(trial)=1;
                eyetyimeval=eyetime2;
                pretrial_timeval=pretrial_time;
                eyechecked=10^4;
                if responsebox==1
                    Datapixx('StopDinLog');
                end
            end
            eyefixation5
            
            if ScotomaPresent == 1
                Screen('FillOval', w, scotoma_color, scotoma);
            else
                fixationlength=30;
                Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
                %             Screen('FillOval', w, scotoma_color, scotoma);
            end
            
            if fixationpresent==1
                colorfixation=0;
                % a fixation cross and no scotoma
                    Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                     Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
                Screen('FillOval', w, colorfixation, imageRectDot);
                
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
                    DrawFormattedText(w, 'Need calibration', 'center', 'center', white);
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
                        if  thekeys==RespType(2)
                            DrawFormattedText(w, 'Bye', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            %  KbQueueWait;
                            closescript = 1;
                            eyechecked=10^4;
                        elseif thekeys==RespType(3)
                            DrawFormattedText(w, 'continue', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            %  KbQueueWait;
                            % trial=trial-1;
                            eyechecked=10^4;
                        elseif thekeys==RespType(4)
                            DrawFormattedText(w, 'Calibration!', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            TPxReCalibrationTestingMM(1,screenNumber, baseName)
                            %    KbQueueWait;
                            eyechecked=10^4;
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
            
        end
        if trialTimedout(trial)== 0 && caliblock==0
            
            foo=(RespType==thekeys);
            if whichTask ~= 3
                staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
                if whichTask==1
                    Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=VAsize;
                elseif whichTask==2
                    Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=sep;
                elseif whichTask==4
                    Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=contr;
                end
                if foo(theans(trial))
                    resp = 1;
                    nswr(trial)=1;
                    PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    corrcounter(mixtr(trial,1),mixtr(trial,2))=corrcounter(mixtr(trial,1),mixtr(trial,2))+1;
                    if reversals(mixtr(trial,1),mixtr(trial,2))<2
                        sc.down=sc.steps(1);
                    elseif reversals(mixtr(trial,1),mixtr(trial,2))>= 2
                        sc.down=sc.steps(2);
                    end
                    if corrcounter(mixtr(trial,1),mixtr(trial,2))==sc.down && staircounter(mixtr(trial,1),mixtr(trial,2))>sc.down % we don't want to call the first scale down a reversal
                        isreversals(mixtr(trial,1),mixtr(trial,2))=1;
                    end
                    if corrcounter(mixtr(trial,1),mixtr(trial,2))==sc.down %&& reversals(mixtr(trial))>= 2
                        % non streaking after 3 reversals
                        if isreversals(mixtr(trial,1),mixtr(trial,2))==1 %&& Threshlist(staircounter(mixtr(trial-sc.down)))<Threshlist(staircounter(mixtr(trial)))
                            if resetcounter(mixtr(trial,1),mixtr(trial,2))==0
                                reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
                                resetcounter(mixtr(trial,1),mixtr(trial,2))=1;
                                rever(trial)=1;
                            end
                            isreversals(mixtr(trial,1),mixtr(trial,2))=0;
                        end
                        thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                        if thestep>length(stepsizes)
                            thestep=length(stepsizes);
                        end
                        corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
                        thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) +stepsizes(thestep);
                    end
                    if whichTask==1
                        thresh(mixtr(trial,1),mixtr(trial,2))=min(thresh(mixtr(trial,1),mixtr(trial,2)),length(Sizelist));
                    elseif whichTask==2
                        thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Separationtlist));
                    elseif whichTask==4
                        thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Contlist));
                    end
                elseif (thekeys==escapeKey) % esc pressed
                    closescript = 1;
                    if EyetrackerType==2
                        Datapixx('DisableSimulatedScotoma')
                        Datapixx('RegWrRd')
                    end
                    ListenChar(0);
                    break;
                else % wrong response
                    resp = 0;
                    nswr(trial)=0;
                    PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    resetcounter(mixtr(trial,1),mixtr(trial,2))=0;
                    if reversals(mixtr(trial,1),mixtr(trial,2))<2
                        sc.down=sc.steps(1);
                    elseif reversals(mixtr(trial,1),mixtr(trial,2))>= 2
                        sc.down=sc.steps(2);
                    end
                    %  WE DON'T CARE ABOUT UPWARD REVERSALS, but we update 'isreversals' to update staircase
                    if  corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                        isreversals(mixtr(trial,1),mixtr(trial,2))=1;
                    end
                    corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
                    % we don't want the step size to change on a wrong response
                    
                    thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                    thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
                    thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)));
                    if thresh(mixtr(trial,1),mixtr(trial,2))<1
                        thresh(mixtr(trial,1),mixtr(trial,2))=1;
                    end
                end
            elseif whichTask == 3
                if foo(theans(trial))
                    resp = 1;
                    PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    
                elseif (thekeys==escapeKey) % esc pressed
                    closescript = 1;
                    break;
                else
                    resp = 0;
                    PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                end
            end
        elseif trialTimedout(trial)==1 && caliblock==0
            resp = 0;
            respTime(trial)=0;
            PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
            PsychPortAudio('Start', pahandle);
            if whichTask~=3
                staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
                if whichTask==1
                    Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=VAsize;
                elseif whichTask==2
                    Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=sep;
                elseif whichTask==4
                    Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=contr;
                end
                if reversals(mixtr(trial,1),mixtr(trial,2))<2
                    sc.down=sc.steps(1);
                elseif reversals(mixtr(trial,1),mixtr(trial,2))>= 2
                    sc.down=sc.steps(2);
                end
                nswr(trial)=0;
                resetcounter(mixtr(trial,1),mixtr(trial,2))=0;
                if reversals(mixtr(trial,1),mixtr(trial,2))<2
                    sc.down=sc.steps(1);
                elseif reversals(mixtr(trial,1),mixtr(trial,2))>= 2
                    sc.down=sc.steps(2);
                end
                %  WE DON'T CARE ABOUT UPWARD REVERSALS, but we update 'isreversals' to update staircase
                if  corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                    isreversals(mixtr(trial,1),mixtr(trial,2))=1;
                end
                
                corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
                % we don't want the step size to change on a wrong response
                thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
                thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)));
                if thresh(mixtr(trial,1),mixtr(trial,2))<1
                    thresh(mixtr(trial,1),mixtr(trial,2))=1;
                end
            end
        end
        if trialTimedout(trial)==0 && caliblock==0
            stim_stop=respTime(trial);
            cheis(kk)=thekeys;
        end
        
        if exist('stimstar')==0
            stim_start(trial)=0;
            stimnotshowed(trial)=99;
        end
        
        
        if caliblock==0
            if responsebox==1 && trialTimedout(trial)==0
                time_stim(kk) = respTime(trial) - stim_startBox2(trial);
                time_stim2(kk) = respTime(trial) - stim_startBox(trial);
            else
                time_stim(kk) = respTime(trial) - stim_start(trial);
            end
            totale_trials(kk)=trial;
            coordinate(trial).x=theeccentricity_X/pix_deg;
            coordinate(trial).y=theeccentricity_Y/pix_deg;
            xxeye(trial).ics=xeye;
            yyeye(trial).ipsi=yeye;
            vbltimestamp(trial).ix=VBL_Timestamp;
            
            rispo(kk)=resp;
            if whichTask==1
                lettersize(kk)=VAsize;
                tles{kk} = thresh;
                contacorr(trial)=corrcounter(mixtr(trial,1),mixtr(trial,2));
            elseif whichTask ==2
                separation(kk)=sep;
                if exist('imageRect_offs')
                    sizeCrSti(kk)=imageRect_offs(3)-imageRect_offs(1);
                end
            elseif whichTask ==3
                correx(kk)=resp;
                if exist('imageRect_offs')
                    SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
                end
                Att_RT(kk) = respTime(trial) - stim_start(trial);
            elseif whichTask ==4
                thecont(kk)=contr;
            end
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