% Contrast threshold measurement with randomized position of the target -
% wait until response
close all; clear all; clc;
commandwindow
 
addpath([cd '/CrowdingDependencies']);
addpath([cd '/utilities']); %add folder with utilities files

%RTBox('clear');a
try
prompt={'Participant Name', 'day','site? UCR(1), UAB(2), Vpixx(3)', 'Training type', 'Demo? (1:yes, 2:no)', 'Eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Scotoma? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?', 'left (1) or right (2) TRL?' };
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '1', '2', '2' , '2', '0', '1', '1', '1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    penalizeLookaway=0;   %mostly for debugging, we can remove the masking on the target when assigned PRL ring is out of range
    expDay=str2num(answer{2,:}); % training day (if >1
    site = str2num(answer{3,:}); % training site (UAB vs UCR vs Vpixx)
    trainingType=str2num(answer{4,:}); % training type: 1=contrast, 2=contour integration, 3= oculomotor, 4=everything bagel
    demo=str2num(answer{5,:}); % are we testing in debug mode?
    test=demo;
    whicheye=str2num(answer{6,:}); % are we tracking left (1) or right (2) eye? Only for Vpixx
    calibration=str2num(answer{7,:}); % do we want to calibrate or do we skip it? only for Vpixx
    ScotomaPresent = str2num(answer{8,:}); % 0 = no scotoma, 1 = scotoma
    EyeTracker = str2num(answer{9,:}); %0=mouse, 1=eyetracker
    TRLlocation= str2num(answer{10,:}); %1=left, 2=right
expDay=str2num(answer{2,:});
%load (['../PRLocations/' name]);
cc = clock; %Current date and time as date vector. [year month day hour minute seconds]
%create a folder if it doesn't exist already
if exist('data')==0
    mkdir('data')
end;

baseName=['.\data\' SUBJECT '_LatIn ' num2str(expDay) '_' num2str(cc(1)) '_' num2str(cc(2)) '_' num2str(cc(3)) '_' num2str(cc(4))];
    
       %% eyetracker initialization (eyelink)
  defineSite
    
    CommonParametersFLAP % define common parameters  
    if EyeTracker==1
        if site==3
            EyetrackerType=2; %1 = Eyelink, 2 = Vpixx
        else
            EyetrackerType=1; %1 = Eyelink, 2 = Vpixx
        end
        eyetrackerparameters % set up Eyelink eyetracker
    end
    
    
    
% lat int variables    
fixat=1;
fixationlength = 40; % pixels    

red=[255 0 0];

VA_threshold=.8;

fixwindow=2;
fixTime=0.2;
fixTime2=0.2;

PRL_x_axis=-4;
PRL_y_axis=0;
NoPRL_x_axis=4;
NoPRL_y_axis=0;
flankersContrast=.6;

presentationtime=.333;
ISIinterval=0.5;


    
    %% eyetracker initialization (eyelink)
    
    if EyeTracker==1
        if site==3
            EyetrackerType=2; %1 = Eyelink, 2 = Vpixx
        else
            EyetrackerType=1; %1 = Eyelink, 2 = Vpixx
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
        pahandle3 = PsychPortAudio('Open', [], 1, 1, 44100, 2);

    elseif site==3 % Windows
        
        pahandle1 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
        pahandle2 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
        pahandle3 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    end
    try
        [errorS freq] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
        [corrS freq] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
    end
    
    PsychPortAudio('FillBuffer', pahandle1, corrS' ); % loads data into buffer
    PsychPortAudio('FillBuffer', pahandle2, errorS'); % loads data into buffer
    

%% STAIRCASE
cndt=2;
ca=2;
thresh(1:cndt, 1:ca)=19;
reversals(1:cndt, 1:ca)=0;
isreversals(1:cndt, 1:ca)=0;
staircounter(1:cndt, 1:ca)=0;
corrcounter(1:cndt, 1:ca)=0;
    StartCont=5;  %15
thresh(1:cndt, 1:ca)=StartCont;
        step=5;
                    currentsf=1;
% Threshold -> 79%
sc.up = 1;                          % # of incorrect answers to go one step up
sc.down = 3;                        % # of correct answers to go one step down
   max_contrast=.7;
    Contlist = log_unit_down(max_contrast+.122, 0.05, 76); %Updated contrast possible values
    Contlist(1)=1;
    
    stepsizes=[4 4 3 2 1];
    
    SFthreshmin=0.01;
    
    SFthreshmax=Contlist(StartCont);
    SFadjust=10;
    
stepsizes=[8 4 3 2 1];


      lok=2; %location: PRL vs no PRL
        fl=2; % flankers: Iso vs orto
            condlist=fullfact([lok fl]);
                   numsc=length(condlist);

            n_blocks=1;

                      trials=10 %100;    
          blocks=1 %10;   
              n_blocks=round(trials/blocks);   %number of trials per miniblock
                  mixtr=[];    
        for j=1:blocks;
            for i=1:numsc
                mixtr=[mixtr;repmat(condlist(i,:),n_blocks,1)];
            end;
        end;

        
        
        b=mixtr(randperm(length(mixtr)),:);




    %% gabor settings and fixation point
    sf=3;
    lambdaSeparation=4;
    lambda=1/sf;
    sigma_deg=lambda;
    sigma_pix = sigma_deg*pix_deg;
    lambdadeg=lambdaSeparation*lambda*pix_deg;
    imsize=(sigma_pix*2.5) %/2;
       imsizeTarget=(sigma_pix*2.5);
    [x,y]=meshgrid(-imsize:imsize,-imsize:imsize);
        [xta,yta]=meshgrid(-imsizeTarget:imsizeTarget,-imsizeTarget:imsizeTarget);

    G = exp(-((x/sigma_pix).^2)-((y/sigma_pix).^2));
    fixationlength = 10; % pixels
    [r, c] = size(G);
    
    
    
%    phases= [pi, pi/2, 2/3*pi, 1/3*pi];
     phases=pi;
   
        grayG=0.5;
    %circular mask
    xylim = imsize; %radius of circular mask
    circle = x.^2 + y.^2 <= xylim^2;
    rot=0*pi/180; %redundant but theoretically correct
    Gmaxcontrast=1; %same
    for i=1:(length(sf));
        for g=1:length(phases)
            f_gabor=(sf(i)/pix_deg)*2*pi;
            a=cos(rot)*f_gabor;
            b=sin(rot)*f_gabor;
            m=Gmaxcontrast*sin(a*x+b*y+phase(phases(g))).*G;
          %  TheGabors(i,g)=Screen('MakeTexture', w, gray+inc*m,[],[],2);           
            m=m+grayG;
            m = double(circle) .* double(m)+grayG * ~double(circle);                       
            %TheGabors(i,g)=Screen('MakeTexture', w, gray+inc*m,[],[],2);            
            TheGabors(i,g)=Screen('MakeTexture', w, m,[],[],2);
            
        end;
    end;


%% stimulus settings
 rand('twister', sum(100*clock));



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


fixwindowPix=fixwindow*pix_deg;


WaitSecs(1);
% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
%     Screen('TextStyle', w, 1+2);
Screen('FillRect', w, gray);
colorfixation = white;
DrawFormattedText(w, 'Press (a) if target in the first interval, press (b) if in the second \n \n \n \n Press any key to start', 'center', 'center', white);
Screen('Flip', w);
WaitSecs(1.5);
       KbQueueWait;

[xc, yc] = RectCenter(wRect); % center screen

xlocs=[PRL_x_axis NoPRL_x_axis];
ylocs=[PRL_y_axis NoPRL_y_axis];


eccentricity_X=[xlocs(1)*pix_deg xlocs(2)*pix_deg];
eccentricity_Y=[ylocs(1)*pix_deg ylocs(2)*pix_deg];

    % check EyeTracker status, if Eyelink
    if EyetrackerType == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        Eyelink('message' , 'SYNCTIME');
        location =  zeros(length(mixtr), 6);
    end
    

    

    imageRect = CenterRect([0, 0, size(x)], wRect);
    
        imageRectTarget = CenterRect([0, 0, size(xta)], wRect);

    % widthFactor is news
    % heightFactor is nrw
widthFactor=2.24;
heightFactor=2.69;
%imageRect11 = CenterRect([0, 0, [nrw*heightFactor news*widthFactor ]], wRect);
%   imageRect11 = CenterRect([0, 0, [nrw news ]], wRect);
%imageRect12 = CenterRect([0, 0, [nrw*1.5 nrw*1.5 ]], wRect);

    eyetime2=0;
   % waittime=ifi*60;
   waittime=0;
  scotomadeg= 1;
    scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg_vert];
    scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);

    xeye=[];
    yeye=[];
  %  pupils=[];
    tracktime=[];
    VBL_Timestamp=[];
    stimonset=[ ];
    fliptime=[ ];
    mss=[ ];
    scotoma_color=[200 200 200];
     FixDotSize=15;
     
    
     

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

        
clear EyeData
clear FixIndex
        xeye=[];
    yeye=[];
    pupils=[];
    tracktime=[];
    VBL_Timestamp=[];
    stimonset=[ ];
    fliptime=[ ];
    mss=[ ];
    tracktime=[];
        %    tracktime=[];
        FixCount=0;
        FixatingNow=0;
        EndIndex=0;  
        
          fixating=0;
counter=0;
framecounter=0;
x=0;
y=0;
area_eye=0;
xeye2=[];
yeye2=[];
        

  ori=0;                 
contr = Contlist(thresh(mixtr(trial,1),mixtr(trial,2)));

eccentricita_o=eccentricity_X(mixtr(trial,1));
eccentricita_v=eccentricity_Y(mixtr(trial,1));
isorto=mixtr(trial,2);
if isorto==1
%    angolo=deg2rad(0)
    angolo=0;
elseif isorto==2 
    %angolo=deg2rad(90) 
       angolo=90
end

 [xc, yc] = RectCenter(wRect); % coordinate del centro schermo
 
 
        theeccentricity_X=eccentricity_X(mixtr(trial,1));
        theeccentricity_Y=eccentricity_Y(mixtr(trial,1));
        
        
        eccentricity_X1=theeccentricity_X;
        eccentricity_Y1=theeccentricity_Y;
        eccentricity_X2=eccentricity_X1;
        eccentricity_Y2=eccentricity_Y1;        

    theintervals=[1 2];


theans(trial)=randi(2); %generates answer for this trial
interval=theintervals(theans(trial));

  %% Initialization/reset of several trial-based variables
        FLAPVariablesReset % reset some variables used in each trial
 while eyechecked<1
  %   fixationtype(w, wRect, fixat,fixationlength, white,pix_deg,AMD);
  
    
  if (eyetime2-pretrial_time)>ifi*35 && (eyetime2-pretrial_time)<ifi*65 && fixating<fixTime/ifi && stopchecking>1
      fixationscript
  elseif  (eyetime2-pretrial_time)>=ifi*65 && fixating<fixTime/ifi && stopchecking>1
              IsFixatingSquare
      fixationscript
  elseif (eyetime2-pretrial_time)>ifi*65 && fixating>=fixTime/ifi && fixating<1000 && stopchecking>1
      trial_time = GetSecs;
      fixating=1500;
  end
 
           
             
              if (eyetime2-trial_time)>=waittime+ifi && (eyetime2-trial_time)<waittime+ifi*2 && fixating>400 && stopchecking>1

                                         PsychPortAudio('Start', pahandle3);

         elseif (eyetime2-trial_time)>=waittime+ifi*2 && (eyetime2-trial_time)<waittime+ifi*2+presentationtime && fixating>400 && stopchecking>1
         
         
          imageRect_offs_flank1 =[imageRect(1)+(newsamplex-wRect(3)/2)+eccentricity_X1, imageRect(2)+(newsampley-wRect(4)/2)+eccentricity_Y1+lambdadeg,...
        imageRect(3)+(newsamplex-wRect(3)/2)+eccentricity_X1, imageRect(4)+(newsampley-wRect(4)/2)+eccentricity_Y1+lambdadeg];
    
        imageRect_offs_flank2 =[imageRect(1)+eccentricity_X2+(newsamplex-wRect(3)/2), imageRect(2)+(newsampley-wRect(4)/2)+eccentricity_Y2-lambdadeg,...
        imageRect(3)+eccentricity_X2+(newsamplex-wRect(3)/2), imageRect(4)+(newsampley-wRect(4)/2)+eccentricity_Y2-lambdadeg];   
    
    
     imageRect_offs =[imageRectTarget(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectTarget(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
            imageRectTarget(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectTarget(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
    
         

                         Screen('DrawTexture',w, TheGabors(1,1), [],imageRect_offs_flank1,angolo,[],flankersContrast); % lettera a sx del target
                         Screen('DrawTexture',w, TheGabors(1,1), [], imageRect_offs_flank2,angolo,[],flankersContrast); % lettera a sx del target
         if interval==1
         
                         Screen('DrawTexture', w, TheGabors(1,1), [], imageRect_offs, ori,[], contr);
         end

         
         %     Screen('DrawTexture', w, texture(trial), [], imageRect_offs{tloc}, ori,[], contr );
         stim_start = GetSecs;
         
         
         
         
      elseif (eyetime2-trial_time)>=waittime+ifi*2+presentationtime && (eyetime2-trial_time)<waittime+ifi*2+presentationtime+ISIinterval && fixating>400 && stopchecking>1
          %blank ISI
          
          
          
                elseif (eyetime2-trial_time)>=waittime+ifi*2+presentationtime+ISIinterval && (eyetime2-trial_time)<waittime+ifi*3+presentationtime+ISIinterval && fixating>400 && stopchecking>1

                                                   PsychPortAudio('Start', pahandle3);

      elseif (eyetime2-trial_time)>waittime+ifi*3+presentationtime+ISIinterval && (eyetime2-trial_time)<waittime+ifi*3+presentationtime+ISIinterval+presentationtime && fixating>400 && stopchecking>1
          
                
 
          imageRect_offs_flank1 =[imageRect(1)+(newsamplex-wRect(3)/2)+eccentricity_X1, imageRect(2)+(newsampley-wRect(4)/2)+eccentricity_Y1+lambdadeg,...
        imageRect(3)+(newsamplex-wRect(3)/2)+eccentricity_X1, imageRect(4)+(newsampley-wRect(4)/2)+eccentricity_Y1+lambdadeg];
    
        imageRect_offs_flank2 =[imageRect(1)+eccentricity_X2+(newsamplex-wRect(3)/2), imageRect(2)+(newsampley-wRect(4)/2)+eccentricity_Y2-lambdadeg,...
        imageRect(3)+eccentricity_X2+(newsamplex-wRect(3)/2), imageRect(4)+(newsampley-wRect(4)/2)+eccentricity_Y2-lambdadeg];   
    
    
     imageRect_offs =[imageRectTarget(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectTarget(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
            imageRectTarget(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectTarget(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];

         

                         Screen('DrawTexture',w, TheGabors(1,1), [],imageRect_offs_flank1,angolo,[],flankersContrast ); % lettera a sx del target
                         Screen('DrawTexture',w, TheGabors(1,1), [], imageRect_offs_flank2,angolo,[],flankersContrast); % lettera a sx del target
      if interval==2
         
                         Screen('DrawTexture', w, TheGabors(1,1), [], imageRect_offs, ori,[], contr);
         end
          
     elseif (eyetime2-trial_time)>waittime+ifi*3+presentationtime+ISIinterval+presentationtime && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey) ==0 && stopchecking>1; %present pre-stimulus and stimulus
      %   Screen('Close');
         
     elseif (eyetime2-trial_time)>waittime+ifi*3+presentationtime+ISIinterval+presentationtime && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey) ~=0 && stopchecking>1; %present pre-stimulus and stimulus
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
                if site<3
                    GetEyeTrackerData
                elseif site ==3
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
            end 
     [keyIsDown, keyCode] = KbQueueCheck;
     
 end



    
        %Screen('Close', texture);
    % code the response
  %  foo=(theans==thekeys);

            foo=(RespType==thekeys);
            
            staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
            Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=contr;
    

        
if foo(theans(trial))
        resp = 1;
        corrcounter(mixtr(trial,1),mixtr(trial,2))=corrcounter(mixtr(trial,1),mixtr(trial,2))+1;
          %  PsychPortAudio('Close', pahandle3);
                            PsychPortAudio('Start', pahandle1);
        if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
            
            if isreversals(mixtr(trial,1),mixtr(trial,2))==1
                reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
                isreversals(mixtr(trial,1),mixtr(trial,2))=0;
            end
            thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
            if thestep>5 %Doesn't this negate the step size of 8 in the step size list? --Denton
                thestep=5;
            end;                     
            thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) +stepsizes(thestep);
            thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Contlist));
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
                  %  PsychPortAudio('Close', pahandle3);
                            PsychPortAudio('Start', pahandle2);
        thestep=max(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
              if thestep>5
                thestep=5;
        end;        
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
    flipptime(trial).ix=[fliptime];
    angl(trial).a=angolo;

    rispo(kk)=resp;
    kontrast(kk)=contr;
cheis(kk)=thekeys;
righinterval(kk)=interval;

    
    %offsetX(kk)=eccentricity_X;
    %offsetY(kk)=eccentricity_Y;
    
    
        
    if EyeTracker==1
            EyeSummary.(TrialNum).EyeData = EyeData;
    clear EyeData
     EyeSummary.(TrialNum).EyeData(:,6) = EyeCode';
     clear EyeCode
     
     
     
     if exist('FixIndex')==0
        FixIndex=0;
    end;
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
    end;
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
    end;
    
    kk=kk+1;
    
end;
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