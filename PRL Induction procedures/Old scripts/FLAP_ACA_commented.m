% Visual Acuity/Crowding/cued-uncued attention task
% written by Marcello A. Maniglia july 2021 %2017/2021
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
    defaultanswer={'test','1', '1', '1','0', '0', '4', '2', '1' };
    
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
        filename='_FLAP_ACA_practice';
    elseif Isdemo==1
        filename='_FLAP_ACA';
    end
    
    if site==1
        baseName=['./data/' SUBJECT filename '_' num2str(PRLlocations) '_' expDay num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[cd '\data\' SUBJECT filename '_' num2str(PRLlocations) '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[cd '\data\' SUBJECT filename 'Pixx_' num2str(PRLlocations) '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
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
    
    %% STAIRCASES:
    
    % Acuity sc1
    threshVA=19;
    reversalsVA=0;
    isreversalsVA=0;
    staircounterVA=0;
    corrcounterVA=0;
    
    % Threshold -> 79%
    sc.up = 1;                          % # of incorrect answers to go one step up
    sc.down = 3;                        % # of correct answers to go one step down
    
    Sizelist=log_unit_down(StartSize, 0.01, 90);
    
    stepsizesVA=[4 4 4 4 4];
    
    % Crowding
    ca=2; % conditions: radial and tangential
    threshCW(1, 1:ca)=33; %25;
    reversalsCW(1, 1:ca)=0;
    isreversalsCW(1, 1:ca)=0;
    staircounterCW(1, 1:ca)=0;
    corrcounterCW(1, 1:ca)=0;
    
    max_separation=8; %max deg for crowding
    
    Separationtlist=log_unit_down(max_separation, 0.015, 90);
    
    stepsizesCW=[4 4 4 4 4];
    tr_per_condition=16;  %50
    
    %% Keys definition/kb initialization
    
    KbName('UnifyKeyNames');
    
    RespType(1) = KbName('LeftArrow');
    RespType(2) = KbName('RightArrow');
    RespType(3) = KbName('UpArrow');
    RespType(4) = KbName('DownArrow');
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
    
    % acuity
    mixtrVAsc1=[];
    
    for  ui=1:(tr_per_condition/PRLlocations)
        b=randperm(PRLlocations);
        mixtrVAsc1=[mixtrVAsc1 b];
    end
    
    mixtrVAsc2=[];
    
    for  ui=1:tr_per_condition
        b=randperm(PRLlocations);
        mixtrVAsc2=[mixtrVAsc2 b];
    end
    mixtrVA=[ mixtrVAsc1' ones(length(mixtrVAsc1),1); mixtrVAsc2' ones(length(mixtrVAsc2),1)*2];
    
    %Crowding
    
    %radial
    
    mixtrCWsc1r=[];
    
    for  ui=1:(tr_per_condition/PRLlocations)
        b=randperm(PRLlocations);
        mixtrCWsc1r=[mixtrCWsc1r b];
    end
    
    mixtrCWsc2r=[];
    
    for  ui=1:tr_per_condition
        b=randperm(PRLlocations);
        mixtrCWsc2r=[mixtrCWsc2r b];
    end
    
    mixtrCWr=[ mixtrCWsc1r' ones(length(mixtrCWsc1r),1);  mixtrCWsc2r' ones(length(mixtrCWsc2r),1)*2];
    
    % tangential
    
    mixtrCWsc1t=[];
    
    for  ui=1:(tr_per_condition/PRLlocations)
        b=randperm(PRLlocations);
        mixtrCWsc1t=[mixtrCWsc1t b];
    end
    
    mixtrCWsc2t=[];
    
    for  ui=1:tr_per_condition
        b=randperm(PRLlocations);
        mixtrCWsc2t=[mixtrCWsc2t b];
    end
    
    mixtrCWt=[ mixtrCWsc1t' ones(length(mixtrCWsc1t),1); mixtrCWsc2t' ones(length(mixtrCWsc2t),1)*2 ];
    
    if randi(2)==2
        mixtrCW= [ mixtrCWt ones(length(mixtrCWt),1) ; mixtrCWr ones(length(mixtrCWr),1)*2];
    else
        mixtrCW= [ mixtrCWr ones(length(mixtrCWr),1)*2 ; mixtrCWt ones(length(mixtrCWt),1)];
    end
    
    mixtrCW =[mixtrCW(:,1) mixtrCW(:,3) mixtrCW(:,2)];
    
    if PRLlocations==4
        mixtrCWa=[mixtrCW(1:16,:); mixtrCW(81:96,:)]; % 16 trials of 'a' sc type
        mixtrCWb=[ mixtrCW(17:80,:) ;mixtrCW(97:end,:)]; % 64 trials of 'b' sc type
    elseif PRLlocations==2
        mixtrCWa=[mixtrCW(1:16,:); mixtrCW(49:64,:)];
        mixtrCWb=[ mixtrCW(17:48,:) ;mixtrCW(65:end,:)];
    end
    
    mixtrCWa=mixtrCWa(randperm(length(mixtrCWa)),:);
    mixtrCWb= mixtrCWb(randperm(length(mixtrCWb)),:);
    
    mixtrCW=[mixtrCWa; mixtrCWb];
    
    if PRLlocations==4
        load('AttMatNew.mat')
        
        numar=7;
        tt= [99 99 ];
        while tt(1) == tt(2)
            tt=randi(numar(1),1,2);
        end
        
        subMat={'one', 'two', 'five', 'seven', 'eight', 'nine', 'ten'};
        firstPartMat=AttMat.(subMat{tt(1)});
        secondPartMat=AttMat.(subMat{tt(2)});
        mixtrAtt= [firstPartMat; secondPartMat];
    elseif PRLlocations==2
        %if only two locations
        rep=40;
        mixtrAtttemp=repmat(fullfact([PRLlocations 4]), rep,1);
        mixtrAtt=mixtrAtttemp(randperm(length(mixtrAtttemp)),:);
    end
    
    % for attention: create array of jittered trial onset
    jit=[0.5:0.3:1.5];
    jitterArray=[];
    for ui=1:length(mixtrAtt(:,1))/4
        tempjitter=jit(randperm(length(jit)))';
        jitterArray=[jitterArray;tempjitter];
    end
    if Isdemo==0
        mixtrVA=mixtrVA(1:practicetrials,:);
        mixtrCW=mixtrCW(1:practicetrials,:);
        if PRLlocations==2
            mixtrAtt=[2,3;1,1;2,4;1,2;1,1];
        elseif  PRLlocations==4
            mixtrAtt=[2,3;1,1;2,4;3,2;4,1];
        end
    end
    totalmixtr=length(mixtrVA)+length(mixtrCW)+length(mixtrAtt);
    %% main loop
    HideCursor;
    ListenChar(2);
    counter = 0;
    
    Screen('FillRect', w, gray);
    DrawFormattedText(w, 'report the orientation of the gap of the C \n \n using the keyboard arrows \n \n \n \n Press any key to start', 'center', 'center', white);
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
    
    for totaltrial=1:totalmixtr
        trialTimedout(totaltrial)=0;
        TrialNum = strcat('Trial',num2str(totaltrial));
        
        if totaltrial== length(mixtrVA)+1
            interblock_instruction_crowding
        end
        if totaltrial== (length(mixtrVA)+length(mixtrCW))+1
            interblock_instruction_attention
        end
        if totaltrial<= length(mixtrVA)
            whichTask=1;
            trial=totaltrial;
        elseif totaltrial<=(length(mixtrVA)+length(mixtrCW)) && totaltrial> length(mixtrVA)
            whichTask=2;
            trial=totaltrial-length(mixtrVA);
        elseif totaltrial<=(length(mixtrVA)+length(mixtrCW)+length(mixtrAtt)) && totaltrial> length(mixtrVA)+length(mixtrCW)
            whichTask=3;
            trial=totaltrial-(length(mixtrVA)+length(mixtrCW));
        end
        
        %        whichTask=3;
        
        if whichTask ==1
            trialTimeout=realtrialTimeout;
            theeccentricity_X=eccentricity_X(mixtrVA(trial));
            theeccentricity_Y=eccentricity_Y(mixtrVA(trial));
            VAsize = Sizelist(threshVA);
            imageRect = CenterRect([0, 0, VAsize*pix_deg VAsize*pix_deg], wRect);
        elseif whichTask ==2
            trialTimeout=realtrialTimeout;
            VA_thresho=1;
            
            imageRect = CenterRect([0, 0, (VA_thresho*pix_deg) (VA_thresho*pix_deg)], wRect);
            imageRectFlankOne =imageRect;
            imageRectFlankTwo =imageRect;
            sep = Separationtlist(threshCW(mixtrCW(trial,2)));
            
            horizontal_eccentricity=eccentricity_X(mixtrCW(trial,1));
            vertical_eccentricity=eccentricity_Y(mixtrCW(trial,1));
            radOrtan=mixtrCW(trial,2);
            if radOrtan==1 % is crowding radial or tangential?
                crowding_angle=atan((vertical_eccentricity)/(horizontal_eccentricity));
            elseif radOrtan==2 && mixtrCW(trial,1)==2
                crowding_angle=atan((vertical_eccentricity)/(horizontal_eccentricity))+pi/2;
            elseif radOrtan==2 && mixtrCW(trial,1)==1
                crowding_angle=atan((vertical_eccentricity)/(horizontal_eccentricity))-pi/2;
            elseif radOrtan==2 && mixtrCW(trial,1)==4
                crowding_angle=atan((vertical_eccentricity)/(horizontal_eccentricity))+pi/2;
            elseif radOrtan==2 && mixtrCW(trial,1)==3
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
            
            %Compute flank two
            ecc_t2=-crowding_angle;
            cs= [cos(ecc_t2), sin(ecc_t2)];
            xxyy2=[ecc_r ecc_r].*cs;
            ecc_x2=xxyy2(1);
            ecc_y2=xxyy2(2);
            eccentricity_X2=ecc_x2;
            eccentricity_Y2=ecc_y2;
            
            theeccentricity_X=eccentricity_X(mixtrCW(trial,1));
            theeccentricity_Y=eccentricity_Y(mixtrCW(trial,1));
            
            imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
                imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
            
            imageRect_offsFlankOne =[imageRectFlankOne(1)+theeccentricity_X, imageRectFlankOne(2)+theeccentricity_Y,...
                imageRectFlankOne(3)+theeccentricity_X, imageRectFlankOne(4)+theeccentricity_Y];
            
            imageRect_offsFlankTwo =[imageRectFlankTwo(1)+theeccentricity_X, imageRectFlankTwo(2)+theeccentricity_Y,...
                imageRectFlankTwo(3)+theeccentricity_X, imageRectFlankTwo(4)+theeccentricity_Y];
            
            anglout = radtodeg(crowding_angle+pi/2);
            anglout2=radtodeg(crowding_angle);
            
        elseif whichTask == 3
            cueonset=jitterArray(trial); % cue onset for this trial, from jittered array
            trialTimeout=realtrialTimeout+cueonset;
            
            imageRectCue = CenterRect([0, 0, cueSize*pix_deg cueSize*pix_deg], wRect);
            imageRectCirc= CenterRect([0, 0, circleSize*pix_deg circleSize*pix_deg], wRect);
            
            VA_thresho=1;
            imageRect = CenterRect([0, 0, (VA_thresho*pix_deg) (VA_thresho*pix_deg)], wRect);
            
            theeccentricity_X=eccentricity_X(mixtrAtt(trial,1));
            theeccentricity_Y=eccentricity_Y(mixtrAtt(trial,1));
            imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
                imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
        end
        
        % compute response for trial
        theoris =[-180 0 -90 90];
        theans(trial)=randi(4);
        ori=theoris(theans(trial));
        
        
        FLAPVariablesReset
        
        while eyechecked<1
            
            if ScotomaPresent == 1
                fixationscriptW
            end
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            
            % constrained fixation loop
            if  (eyetime2-pretrial_time)>=prefixationsquare && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                
                %   IsFixatingSquare
                [fixating counter framecounter ]=IsFixatingSquareNew(wRect,xeye,yeye,fixating,framecounter,counter,fixwindowPix)
                if exist('starfix')==0
                    startfix(trial)=eyetime2;
                    starfix=98;
                end
                
            elseif (eyetime2-pretrial_time)>prefixationsquare && fixating>=fixTime/ifi && stopchecking>1 && fixating<1000 && (eyetime2-pretrial_time)<=trialTimeout
                trial_time = GetSecs;
                fixating=1500;
            end
            if whichTask ==3
                currentcueISI=cueISI(mixtrAtt(trial,2));
                currentcueduration=cueduration(mixtrAtt(trial,2));
            else
                currentcueISI=cueISI(1);
                currentcueduration=cueduration(1);
            end
            clear imageRect_offsCirc
            
            % beginning of the trial after fixation criteria satisfied in
            % previous loop
            if (eyetime2-trial_time)>=cueonset && (eyetime2-trial_time)<cueonset+currentcueduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                if whichTask ==3 % if it's attention task and cue time, prepare cue's destination rect
                    
                    if oneOrfourCues ==4
                        imageRect_offs_cue =[imageRectCue(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectCue(2)+(newsampley-wRect(4)/2)+theeccentricity_Y-(cue_spatial_offset*pix_deg),...
                            imageRectCue(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectCue(4)+(newsampley-wRect(4)/2)+theeccentricity_Y-(cue_spatial_offset*pix_deg)];
                        imageRect_offs_cue2 =[imageRectCue(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectCue(2)+(newsampley-wRect(4)/2)+theeccentricity_Y+(cue_spatial_offset*pix_deg),...
                            imageRectCue(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectCue(4)+(newsampley-wRect(4)/2)+theeccentricity_Y+(cue_spatial_offset*pix_deg)];
                        imageRect_offs_cue3 =[imageRectCue(1)+(newsamplex-wRect(3)/2)+theeccentricity_X-(cue_spatial_offset*pix_deg), imageRectCue(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                            imageRectCue(3)+(newsamplex-wRect(3)/2)+theeccentricity_X-(cue_spatial_offset*pix_deg), imageRectCue(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
                        imageRect_offs_cue4 =[imageRectCue(1)+(newsamplex-wRect(3)/2)+theeccentricity_X+(cue_spatial_offset*pix_deg), imageRectCue(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                            imageRectCue(3)+(newsamplex-wRect(3)/2)+theeccentricity_X+(cue_spatial_offset*pix_deg), imageRectCue(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
                        globalimageRect_offs_cue=[imageRect_offs_cue;imageRect_offs_cue2;imageRect_offs_cue3;imageRect_offs_cue4];
                    end
                    
                    if exist('imageRect_offsCirc')==0
                        imageRect_offsCirc =[imageRectCirc(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectCirc(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                            imageRectCirc(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectCirc(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
                    end
                    
                    if mixtrAtt(trial,2)==  1 || mixtrAtt(trial,2)== 3 % drawing cue
                        
                        if oneOrfourCues ==4
                            Screen('DrawTexture',w, theDot, [], imageRect_offs_cue,0,[],1);
                            Screen('DrawTexture',w, theDot, [], imageRect_offs_cue2,0,[],1);
                            Screen('DrawTexture',w, theDot, [], imageRect_offs_cue3,0,[],1);
                            Screen('DrawTexture',w, theDot, [], imageRect_offs_cue4,0,[],1);
                        else
                            Screen('FrameOval', w,ContCirc, imageRect_offsCirc, oval_thick, oval_thick);
                        end
                    end
                end
                
                clear imageRect_offs imageRect_offs_flank1 imageRect_offs_flank2 imageRect_offscircle imageRect_offscircle1 imageRect_offscircle2
                clear stimstar
                %show cue
            elseif (eyetime2-trial_time)>=cueonset+currentcueduration && (eyetime2-trial_time)<cueonset+currentcueISI+currentcueduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                
                %no cue
            elseif (eyetime2-trial_time)>=cueonset+currentcueISI+currentcueduration && (eyetime2-trial_time)<cueonset+currentcueduration+currentcueISI+stimulusduration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                % show target
                if exist('imageRect_offs')==0
                    imageRect_offs =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
                        imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
                    imageRect_offscircle=[imageRect_offs(1)-(0.635*pix_deg) imageRect_offs(2)-(0.635*pix_deg) imageRect_offs(3)+(0.635*pix_deg) imageRect_offs(4)+(0.635*pix_deg) ];
                end
                
                Screen('FillOval',w, gray,imageRect_offscircle); % lettera a sx del target
                if whichTask<3
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], 1);
                elseif whichTask==3
                    Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], attContr);
                end
                if exist('stimstar') == 0
                    stim_start(trial)=eyetime2;
                    stimstar=1;
                end
                if whichTask == 2 % show flankers for crowding
                    if exist('imageRect_offs_flank1')==0
                        
                        imageRect_offs_flank1 =[imageRect_offsFlankOne(1)+(newsamplex-wRect(3)/2)+eccentricity_X1, imageRect_offsFlankOne(2)+(newsampley-wRect(4)/2)+eccentricity_Y1,...
                            imageRect_offsFlankOne(3)+(newsamplex-wRect(3)/2)+eccentricity_X1, imageRect_offsFlankOne(4)+(newsampley-wRect(4)/2)+eccentricity_Y1];
                        imageRect_offs_flank2 =[imageRect_offsFlankOne(1)-eccentricity_X2+(newsamplex-wRect(3)/2), imageRect_offsFlankOne(2)+(newsampley-wRect(4)/2)+eccentricity_Y2,...
                            imageRect_offsFlankOne(3)-eccentricity_X2+(newsamplex-wRect(3)/2), imageRect_offsFlankOne(4)+(newsampley-wRect(4)/2)+eccentricity_Y2];
                        imageRect_offscircle1=[imageRect_offs_flank1(1)-(0.635*pix_deg) imageRect_offs_flank1(2)-(0.635*pix_deg) imageRect_offs_flank1(3)+(0.635*pix_deg) imageRect_offs_flank1(4)+(0.635*pix_deg) ];
                        imageRect_offscircle2=[imageRect_offs_flank2(1)-(0.635*pix_deg) imageRect_offs_flank2(2)-(0.635*pix_deg) imageRect_offs_flank2(3)+(0.635*pix_deg) imageRect_offs_flank2(4)+(0.635*pix_deg) ];
                        
                    end
                    Screen('FillOval',w, gray,imageRect_offscircle1); % letter to the left of target
                    Screen('FillOval',w, gray, imageRect_offscircle2); % letter to the right of target
                    
                    Screen('DrawTexture',w, theCircles, [],imageRect_offs_flank1,anglout,[],1 ); % letter to the left of target
                    Screen('DrawTexture',w, theCircles, [], imageRect_offs_flank2,anglout,[],1); % letter to the right of target
                end
                
            elseif (eyetime2-trial_time)>=cueonset+currentcueISI+currentcueduration+stimulusduration && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                %after target presentation and no key pressed
                
            elseif (eyetime2-trial_time)>=cueonset+currentcueISI+currentcueduration+stimulusduration && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout%present pre-stimulus and stimulus
                %after target presentation and a key is pressed
                
                eyechecked=10^4;
                thekeys = find(keyCode);
                if length(thekeys)>1
                    thekeys=thekeys(1);
                end
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
                respTime(trial)=secs;
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
                Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
                
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
        if trialTimedout(trial)== 0
            
            foo=(RespType==thekeys);
           
            if whichTask == 1
                staircounterVA=staircounterVA+1;
                ThreshlistVA(staircounterVA)=VAsize;
                if foo(theans(trial))
                    resp = 1;
                    nswr(trial)=1;
                    PsychPortAudio('Start', pahandle1);
                    corrcounterVA=corrcounterVA+1;
                    if mixtrVA(trial,2) == 1                       
                        if corrcounterVA>=sc.down                        
                            if isreversalsVA==1
                                reversalsVA=reversalsVA+1;
                                isreversalsVA=0;
                            end
                            thestep=min(reversalsVA+1,length(stepsizesVA));
                            if thestep>5
                                thestep=5;
                            end
                            threshVA=threshVA +stepsizesVA(thestep);
                            threshVA=min(threshVA,length(Sizelist));
                        end                        
                    elseif mixtrVA(trial,2)==2                        
                        if mod(trial,4)==0 && trial>(sum(mixtrVA(:,2)==1))+1                            
                            chec(trial) =99;
                            if sum(nswr(trial-3:trial))==4
                                if isreversalsVA==1
                                    reversalsVA=reversalsVA+1;
                                    isreversalsVA=0;
                                    %      reversalcounterVA=reversalcounterVA+1;
                                end
                                thestep=min(reversalsVA+1,length(stepsizesVA));
                                if thestep>5
                                    thestep=5;
                                end
                                threshVA=threshVA +stepsizesVA(thestep);
                                threshVA=min(threshVA,length(Sizelist));
                                
                            elseif sum(nswr(trial-3:trial))>2 && sum(nswr(trial-3:trial))<4
                                threshVA=threshVA;
                            elseif sum(nswr(trial-3:trial))<2
                                corrcounterVA=0;
                                thestep=max(reversalsVA+1,length(stepsizesVA));
                                if thestep>5
                                    thestep=5;
                                end
                                threshVA=threshVA -stepsizesVA(thestep);
                                threshVA=max(threshVA);
                                if threshVA<1
                                threshVA=1;
                                end
                            end
                        end                       
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
                    PsychPortAudio('Start', pahandle2);
                    if mixtrVA(trial,2)==1
                        if  corrcounterVA>=sc.down
                            isreversalsVA=1;
                        end
                        corrcounterVA=0;
                        thestep=max(reversalsVA+1,length(stepsizesVA));
                        if thestep>5
                            thestep=5;
                        end
                        threshVA=threshVA -stepsizesVA(thestep);
                        threshVA=max(threshVA);
                        if threshVA<1
                            threshVA=1;
                        end                        
                    elseif mixtrVA(trial,2)==2                        
                        if mod(trial,4)==0 && trial>(sum(mixtrVA(:,2)==1))+1                            
                            if sum(nswr(trial-3:trial))==4
                                if isreversalsVA==1
                                    reversalsVA=reversalsVA+1;
                                    isreversalsVA=0;
                                end
                                thestep=min(reversalsVA+1,length(stepsizesVA));
                                if thestep>5
                                    thestep=5;
                                end
                                threshVA=threshVA +stepsizesVA(thestep);
                                threshVA=min(threshVA,length(Sizelist));                                
                            elseif sum(nswr(trial-3:trial))>2 && sum(nswr(trial-3:trial))<4
                                threshVA=threshVA;
                            elseif sum(nswr(trial-3:trial))<2
                                corrcounterVA=0;
                                thestep=max(reversalsVA+1,length(stepsizesVA));
                                if thestep>5
                                    thestep=5;
                                end
                                threshVA=threshVA -stepsizesVA(thestep);
                                threshVA=max(threshVA);
                            end
                        end
                   end
                end
          elseif whichTask == 2
                
                staircounterCW(mixtrCW(trial,2))=staircounterCW(mixtrCW(trial,2))+1;
                ThreshlistCW(mixtrCW(trial,2),staircounterCW(mixtrCW(trial,2)))=sep;
                
                if foo(theans(trial))
                    resp = 1;
                    nswrCW(mixtrCW(trial,2),staircounterCW(mixtrCW(trial,2)))=1;
                    corrcounterCW(mixtrCW(trial,2))=corrcounterCW(mixtrCW(trial,2))+1;
                    PsychPortAudio('Start', pahandle1);
                    
                    if mixtrCW(trial,3) == 1
                        if corrcounterCW(mixtrCW(trial,2))>=sc.down
                            
                            if isreversalsCW(mixtrCW(trial,2))==1
                                reversalsCW(mixtrCW(trial,2))=reversalsCW(mixtrCW(trial,2))+1;
                                isreversalsCW(mixtrCW(trial,2))=0;
                            end
                            thestep=min(reversalsCW(mixtrCW(trial,2))+1,length(stepsizesCW));
                            if thestep>5
                                thestep=5;
                            end
                            threshCW(mixtrCW(trial,2))=threshCW(mixtrCW(trial,2)) +stepsizesCW(thestep);
                            threshCW(mixtrCW(trial,2))=min( threshCW(mixtrCW(trial,2)),length(Separationtlist));            
                        end                       
                    elseif mixtrCW(trial,3)==2
                        if mod(staircounterCW(mixtrCW(trial,2)),4)==0
                            
                            if sum(nswrCW(mixtrCW(trial,2),staircounterCW(mixtrCW(trial,2))-3:staircounterCW(mixtrCW(trial,2))))==4
                                if isreversalsCW(mixtrCW(trial,2))==1
                                    reversalsCW(mixtrCW(trial,2))=reversalsCW(mixtrCW(trial,2))+1;
                                    isreversalsCW(mixtrCW(trial,2))=0;
                                end
                                thestep=min(reversalsCW(mixtrCW(trial,2))+1,length(stepsizesCW));
                                if thestep>5
                                    thestep=5;
                                end
                                threshCW(mixtrCW(trial,2))=threshCW(mixtrCW(trial,2)) +stepsizesCW(thestep);
                                threshCW(mixtrCW(trial,2))=min( threshCW(mixtrCW(trial,2)),length(Separationtlist));
                                
                            elseif sum(nswrCW(mixtrCW(trial,2),staircounterCW(mixtrCW(trial,2))-3:staircounterCW(mixtrCW(trial,2))))>2 && sum(nswrCW(mixtrCW(trial,2),staircounterCW(mixtrCW(trial,2))-3:staircounterCW(mixtrCW(trial,2))))<4
                                threshCW(mixtrCW(trial,2))=threshCW(mixtrCW(trial,2));
                            elseif sum(nswrCW(mixtrCW(trial,2),staircounterCW(mixtrCW(trial,2))-3:staircounterCW(mixtrCW(trial,2))))<2
                                corrcounterCW(mixtrCW(trial,2))=0;
                                thestep=max(reversalsCW(mixtrCW(trial,2))+1,length(stepsizesCW));
                                if thestep>5
                                    thestep=5;
                                end
                                threshCW(mixtrCW(trial,2))=threshCW(mixtrCW(trial,2)) -stepsizesCW(thestep);
                                threshCW(mixtrCW(trial,2))=max(threshCW(mixtrCW(trial,2)),1);
                            end
                        end
                    end
                elseif (thekeys==escapeKey) % esc pressed
                    closescript = 1;
                    ListenChar(0);
                    break;
                else
                    resp = 0;
                    nswrCW(mixtrCW(trial,2),staircounterCW(mixtrCW(trial,2)))=0;
                    corrcounterCW(mixtrCW(trial,2))=0;
                    PsychPortAudio('Start', pahandle2);
                    if mixtrCW(trial,3)==1
                        if  corrcounterCW(mixtrCW(trial,2))>=sc.down
                            isreversalsCW(mixtrCW(trial,2))=1;
                        end                       
                        thestep=max(reversalsCW(mixtrCW(trial,2))+1,length(stepsizesCW));
                        if thestep>5
                            thestep=5;
                        end
                        threshCW(mixtrCW(trial,2))=threshCW(mixtrCW(trial,2)) -stepsizesCW(thestep);
                        threshCW(mixtrCW(trial,2))=max(threshCW(mixtrCW(trial,2)),1);
                    elseif mixtrCW(trial,3)==2
                        
                        if mod(staircounterCW(mixtrCW(trial,2)),4)==0
                            checCW(trial) =99;
                            if sum(nswrCW(mixtrCW(trial,2),staircounterCW(mixtrCW(trial,2))-3:staircounterCW(mixtrCW(trial,2))))==4
                                if isreversalsCW(mixtrCW(trial,2))==1
                                    reversalsCW(mixtrCW(trial,2))=reversalsCW(mixtrCW(trial,2))+1;
                                    isreversalsCW(mixtrCW(trial,2))=0;
                                end
                                thestep=min(reversalsCW(mixtrCW(trial,2))+1,length(stepsizesCW));
                                if thestep>5
                                    thestep=5;
                                end
                                threshCW(mixtrCW(trial,2))=threshCW(mixtrCW(trial,2)) +stepsizesCW(thestep);
                                threshCW(mixtrCW(trial,2))=min( threshCW(mixtrCW(trial,2)),length(Separationtlist));
                                
                            elseif sum(nswrCW(mixtrCW(trial,2),staircounterCW(mixtrCW(trial,2))-3:staircounterCW(mixtrCW(trial,2))))>2 && sum(nswrCW(mixtrCW(trial,2),staircounterCW(mixtrCW(trial,2))-3:staircounterCW(mixtrCW(trial,2))))<4
                                threshCW(mixtrCW(trial,2))=threshCW(mixtrCW(trial,2));
                            elseif sum(nswrCW(mixtrCW(trial,2),staircounterCW(mixtrCW(trial,2))-3:staircounterCW(mixtrCW(trial,2))))<2
                                corrcounterCW(mixtrCW(trial,2))=0;
                                thestep=max(reversalsCW(mixtrCW(trial,2))+1,length(stepsizesCW));
                                if thestep>5
                                    thestep=5;
                                end
                                threshCW(mixtrCW(trial,2))=threshCW(mixtrCW(trial,2)) -stepsizesCW(thestep);
                                threshCW(mixtrCW(trial,2))=max(threshCW(mixtrCW(trial,2)),1);
                            end
                        end
                    end
                end               
            elseif whichTask == 3                
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
            %   stim_stop=secs;        
        else          
            resp = 0;
            respTime(trial)=0;
            PsychPortAudio('Start', pahandle2);
        end
        if trialTimedout(trial)==0
            stim_stop=secs;
            cheis(kk)=thekeys;
        end
        
        if exist('stimstar')==0
            stim_start(trial)=0;
            stimnotshowed(totaltrial)=99;
        end
        time_stim(kk) = respTime(trial) - stim_start(trial);
        totale_trials(kk)=trial;
        coordinate(totaltrial).x=theeccentricity_X/pix_deg;
        coordinate(totaltrial).y=theeccentricity_Y/pix_deg;
        xxeye(totaltrial).ics=xeye;
        yyeye(totaltrial).ipsi=yeye;
        vbltimestamp(totaltrial).ix=VBL_Timestamp;
        
        rispo(kk)=resp;
        if whichTask==1
            lettersize(kk)=VAsize;
            tles(kk) = threshVA;
        elseif whichTask ==2
            separation(kk)=sep;
            refsizeCrSti(kk)=VA_thresho;
            if exist('imageRect_offs')
                sizeCrSti(kk)=imageRect_offs(3)-imageRect_offs(1);
            end
        elseif whichTask ==3
            correx(kk)=resp;
            if exist('imageRect_offs')
                SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
            end
            Att_RT(kk) = respTime(trial) - stim_start(trial);
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