% Contrast threshold measurement with randomized position of the target -
% wait until response

close all; clear all; clc;
commandwindow
try
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    KbName('UnifyKeyNames');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    
    prompt={'Subject Number:'...
        'Day:'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','0'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end;
    
        addpath([cd '/utilities']);

    
    eyeOrtrack=1 %0=mouse, 1=eyetracker
        EyeTracker = 1; % set to 1 for UAB code testing
                        EyetrackerType=1;
    SUBJECT = answer{1,:}; %Gets Subject Name
    expday = str2num(answer{2,:});
    expdayeye = answer{2,:};
    
    BITS=0; % (1=Bits++; 2=Display++; 0=no bits)
%     if BITS==1
%         % cd '/Users/visionlab/Desktop/AMD assessment 2017/CAT food';
%         cd
%        % cd '/Users/visionlab/Desktop/AMD assessment 2017/CAT food (2 to 13)'
%     elseif BITS==2
%         cd 'C:\Users\labadmin\Desktop\marcello AMD assessment\7.Training'
%     elseif BITS==0
%         cd;
%     end;
    cd
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end;
    baseName=['./data/' SUBJECT '_DAY_' num2str(expday) '_blindCAT_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    
    %Number of actual days of training, not counting noise transfer post-test
    numstudydays=20;
    
    
    closescript=0;
    kk=1;
    
%     if str2num(SUBJECT)<=8
%         %Set up random value for condition matrix
%         theseed=1234897456435;
%         rand('twister',theseed );
%         
%         subcondmat=repmat(fullfact(2),4,1);
%         subcondmixmat=subcondmat(randperm(8));
%         
%     elseif str2num(SUBJECT)>8 && str2num(SUBJECT)<=16
%         
%         theseed=24088974568435;
%         rand('twister',theseed );
%         
%         subcondmat=repmat(fullfact(2),4,1);
%         subcondmixmat=subcondmat(randperm(8));
%         
%     elseif str2num(SUBJECT)>100 && str2num(SUBJECT)<=130
%      %   closescript=1;
%       %  disp('Error: Subject number > maximum number of subject')
%       %  return
%         
%       
%       subcondmixmat=[2 2 1 1 1 1 1 1 2 2 ];
%               
%     end
    
    
%     if expday==numstudydays+1
%         if BITS<2
%             typeOfTraining=3;
%         elseif BITS==2
%             closescript=1;
%             disp('Error: Training day > maximum number of sessions')
%      %       break
%         end
%     elseif expday>numstudydays+1
%         closescript=1;
%         disp('Error: Training day > maximum number of sessions')
%     %    break
%     else
%         if BITS==1;
%       %      typeOfTraining=1
%             
%             typeOfTraining=subcondmixmat(str2num(SUBJECT)-110);  %CAT(1), Classic(2), Noise(3),
%         elseif BITS==2
%             typeOfTraining=1;
%         elseif BITS==0
%             typeOfTraining=1;
%         end;
%     end
                typeOfTraining=2;

    Screen('Preference', 'SkipSyncTests', 1);
    PC=getComputerName();
    max_contrast=1;
    blocks=10;  %number of blocks in which we want the trials to be divided
    if BITS<2
     %   sigma_deg = 1.5/2;

       sigma_deg = 1;

    elseif BITS==2
        sigma_deg = 1.5;
    end;
    
    sflist=[1 2 3 4:2:18]; %check
    

    %     currentsf=1; % sflist(currentsf)<--starting sf out of the sflist
    randomizzato=1;
    CircConts=[0.51,1]; %low/high contrast circular cue
    fixat=0;
    SOA=0;
    face_t=0; % '1' for CAT training with AMD
    noise_level=[0.2475,0.33, 0.2475,0.2475,0.33]; % only for training type 2
    
    
    
    
    theseed=sum(100*clock);
    rand('twister',theseed);
    
    
    %     if any(expday==1 || expday==numstudydays)
    %         if typeOfTraining==2
    %             trials=150; %150 %total number of trials per staircase
    %         elseif typeOfTraining==3
    %             trials=750;
    %         elseif typeOfTraining==1
    %             trials=375;
    %         end
    %     elseif 	any(expday>1 && expday<numstudydays)
    if typeOfTraining==3
        trials=100;  %total number of trials per staircase
    elseif typeOfTraining==2
        trials=250;
    elseif typeOfTraining==1
        trials=125;
    end
    %     end
    sfs=1;
    % number of sf
    ns=length(sfs);
    %number of cue conditions
    
    if typeOfTraining==3;
        ca=length(noise_level);
        cndt=ns;
        randomizzato=0;
    elseif typeOfTraining==2;
        cndt=ns;
        ca=1;
        randomizzato=0;
    else
        ca=length(CircConts);
        %number of face features
        fac=length(face_t);
        
        if face_t==0;
            cndt=ns;
        else
            %total conditions
            cndt=ns+fac;
        end;
        
    end;
    
    %CONDITION MATRIX for Gabor and face
    
    condlist=fullfact([cndt ca]);
    
    if length (condlist(:,1))<2;
        mixcond=condlist;
    else
        mixcond=condlist(randperm(length(condlist)),:);
    end;
    
    if typeOfTraining==2
        numsc=length(sfs);
    else
        numsc=length(condlist);
    end;
    
    n_blocks=round(trials/blocks);   %number of trials per miniblock
    mixtr=[];
    if typeOfTraining==3;
        
        for j=1:blocks;
            for i=1:numsc
                mixtr=[mixtr;repmat(condlist(i,:),n_blocks,1)];
            end;
        end;
        
    elseif typeOfTraining==1
        %condition matrix gabor and faces
        for j=1:blocks;
            % mixcond=condlist(randperm(length(condlist)),:);
            for i=1:numsc
                mixtr=[mixtr;repmat(mixcond(i,:),n_blocks,1)];
            end;
        end;
        
    else
        for j=1:blocks;
            % mixcond=condlist(randperm(length(condlist)),:);
            for i=1:numsc
                mixtr=[mixtr;repmat(mixcond,n_blocks,1)];
            end;
        end;
        
    end;
    
    KbQueueCreate;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get keyboard for the key recording
    device = -1; % reset to default keyboard
    [k_id, k_name] = GetKeyboardIndices();
    for i = 1:numel(k_id)
        if strcmp(k_name{i},'Dell Dell USB Keyboard') % unique for your deivce, check the [k_id, k_name]
            device =  k_id(i);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    KbQueueStart(device); % added device parameter
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % if ispc
    %     escapeKey = KbName('esc');	% quit key
    % elseif ismac
    %     escapeKey = KbName('ESCAPE');	% quit key
    % end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    escapeKey = KbName('Escape'); % quit key
    
    
    if EyeTracker==1;
        useEyeTracker = 0; % otherwise will throw error if not UAB run
        
        %eyeTrackerBaseName=[SUBJECT '_DAY_' num2str(expday) '_CAT_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
        %eyeTrackerBaseName = 's00';
        eyeTrackerBaseName =[SUBJECT expdayeye];
        
    %    save_dir= 'C:\Users\labadmin\Desktop\marcello AMD assessment\7.Training\test_eyetracker_files';
        
        
           
       if exist('dataeyet')==0
        mkdir('dataeyet')
    end;
    save_dir=[cd './dataeyet/']
        
    end;
    
    
    
    if BITS==1  %UCR
        %% psychtoobox settings
        screencm=[40.6, 30];%[UAB:69.8x35.5; UCR: 40.6x30 ]
   %     load gamma197sec;
        v_d=57;
        radius=12.5;   %radius of the circle in which the target can appear
        AssertOpenGL;
        oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
        %PsychGPUControl('SetDitheringEnabled', 0); Not supported on OSX
        screenNumber=max(Screen('Screens'));
        rand('twister', sum(100*clock));
        PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
        PsychImaging('AddTask','General','FloatingPoint32BitIfPossible');
        %PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
        PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
      %  PsychImaging('AddTask', 'FinalFormatting','DisplayColorCorrection','LookupTable');
        oldResolution=Screen( 'Resolution',screenNumber,1280,960);
        SetResolution(screenNumber, oldResolution);
    %    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
       % PsychColorCorrection('SetLookupTable', w, lookuptable);
        %if you want to open a small window for debug
        %   [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
         Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        %  PsychColorCorrection('SetLookupTable', window, Nlinear_lut);
        %Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
                      [w, wRect] = BitsPlusPlus('OpenWindowMono++', screenNumber, 0.5,[],32,2);
    Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
    
       
        Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
    elseif BITS==0;  %no Bits, 256 RGB
        
        %% psychtoobox settings
        v_d=57;
        radius=12.5;   %radius of the circle in which the target can appear
        screencm=[40.6, 30];%[UAB:69.8x35.5; UCR: 40.6x30 ]
        AssertOpenGL;
        screenNumber=max(Screen('Screens'));
        PsychImaging('PrepareConfiguration');
        PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
        %    oldResolution=Screen( 'Resolution',screenNumber,1280,960);
        %    oldResolution=Screen( 'Resolution',screenNumber,1280,960);
        %   SetResolution(screenNumber, oldResolution);
       [w, wRect]=PsychImaging('OpenWindow',screenNumber, 0,[],32,2);
        %debug window
    %  [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
        %ScreenParameters=Screen('Resolution', screenNumber); %close all
        %struct.res=[ScreenParameters.width ScreenParameters.height];
       Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
        Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        
        
    elseif BITS==2; %UAB
        
        s1=serial('com3')
        fopen(s1)
        fprintf(s1, ['$monoPlusPlus' 13])
        fclose(s1)
        clear s1
        screencm=[69.8, 35.5];
        v_d=57;
        AssertOpenGL;
        radius=17.5;   %radius of the circle in which the target can appear
        oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
        %PsychGPUControl('SetDitheringEnabled', 0); Not supported on OSX
        screenNumber=max(Screen('Screens'));
        rand('twister', sum(100*clock));
        PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
        PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
        PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
        %     PsychImaging('AddTask', 'FinalFormatting','DisplayColorCorrection','LookupTable');
        oldResolution=Screen( 'Resolution',screenNumber,1920,1080);
        SetResolution(screenNumber, oldResolution);
     %   [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
                [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);

        
        Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
      end;  
      
      
      
      
    struct.sz=[screencm(1), screencm(2)];
    %pix_deg = pi * wRect(3) / atan(screencm(1)/v_d/2) / 360; %pixperdegree
    pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi));
    pix_deg_vert=1./((2*atan((screencm(2)/wRect(4))./(2*v_d))).*(180/pi));
    
        if EyeTracker == 1
            
            
                                    
        
        
                       % eye_used
            ScreenHeightPix=screencm(2)*pix_deg_vert;
            ScreenWidthPix=screencm(1)*pix_deg;
            VelocityThreshs = [250 2000];      	% px/sec
            ViewpointRefresh = 1;               % dummy variable
            driftoffsetx=0;                     % initial x offset for all eyetracker values
            driftoffsety=0;                     % initial y offset for all eyetracker values
            driftcorr=0.1;                      % how much to adjust drift correction each trial.
            % Parameters to identify fixations
            FixationDecisionThreshold = 0.3;    % sec; how long they have to fixate on a location for it to "count"
            FixationTimeThreshold = 0.033;      % sec; how long the eye has to be stationary before we begin to call it a fixation
            % note, the eye velocity is already low enough to be considered a "fixation"
            FixationLocThreshold = 1;           % degrees;  how far the eye can drift from a fixation location before we "call it" a new fixation
            

           
            % old variables
            [winCenter_x,winCenter_y]=RectCenter(wRect);
            backgroundEntry = [0.5 0.5 0.5];
            % height and width of the screen
            winWidth  = RectWidth(wRect);
            winHeight = RectHeight(wRect);
            % initialize eyelink
            if EyelinkInit()~= 1
                error('Eyelink initialization failed!');
            end
            % continue with the rest of eyelink initialization
            elHandle=EyelinkInitDefaults(w);
            el=elHandle;
            eyeTrackerFileName = [eyeTrackerBaseName '.edf'];
            % Modify calibration and validation target locations %%
            % it's location here is overridded by EyelinkDoTracker which resets it
            % with display PC coordinates
            Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, winWidth-1, winHeight-1);
            Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, winWidth-1, winHeight-1);
            % set calibration type.
             Eyelink('command', 'calibration_type = HV9');
          %  Eyelink('command', 'calibration_type = HV5'); % changed to 5 to correct upper left corner of the screen issue
            % you must send this command with value NO for custom calibration
            % you must also reset it to YES for subsequent experiments
          %  Eyelink('command', 'generate_default_targets = NO');
            
            
            %% Modify target locations
            % due to issues with calibrating the upper left corner of the screen the following lines have been
            % commmented out to change the the sampling from 10 to 5 as
            % listed in line 323
             Eyelink('command','calibration_samples = 10');
             Eyelink('command','calibration_sequence = 0,1,2,3,4,5,6,7,8,9');
%             
%             modFactor = 0.183;
%             
%             Eyelink('command','calibration_targets = %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
%                 round(winWidth/2), round(winHeight/2),  round(winWidth/2), round(winHeight*modFactor),  ...
%                 round(winWidth/2), round(winHeight - winHeight*modFactor),  round(winWidth*modFactor), ...
%                 round(winHeight/2),  round(winWidth - winWidth*modFactor), round(winHeight/2), ...
%                 round(winWidth*modFactor), round(winHeight*modFactor), round(winWidth - winWidth*modFactor), ...
%                 round(winHeight*modFactor), round(winWidth*modFactor), round(winHeight - winHeight*modFactor),...
%                 round(winWidth - winWidth*modFactor), round(winHeight - winHeight*modFactor) );
%             
%             Eyelink('command','validation_samples = 5');
             Eyelink('command','validation_samples = 10'); %changed to make
            % it 5 samples instead of 10 to deal with upper left corner of
            % the screem issue
            Eyelink('command','validation_sequence = 0,1,2,3,4,5,6,7,8,9');
%             Eyelink('command','validation_targets =  %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
%                 round(winWidth/2), round(winHeight/2),  round(winWidth/2), round(winHeight*modFactor),  ...
%                 round(winWidth/2), round(winHeight - winHeight*modFactor),  round(winWidth*modFactor), ...
%                 round(winHeight/2),  round(winWidth - winWidth*modFactor), round(winHeight/2), ...
%                 round(winWidth*modFactor), round(winHeight*modFactor), round(winWidth - winWidth*modFactor), ...
%                 round(winHeight*modFactor), round(winWidth*modFactor), round(winHeight - winHeight*modFactor),...
%                 round(winWidth - winWidth*modFactor), round(winHeight - winHeight*modFactor)  );
%             
            % make sure that we get gaze data from the Eyelink
            Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
            Eyelink('OpenFile', eyeTrackerFileName); % open file to record data  & calibration
            EyelinkDoTrackerSetup(elHandle);
            Eyelink('dodriftcorrect');
        end
        

    
    
    %struct.res=[1280 960];
    %oldRes=SetResolution(0,1280,960);
    %SetResolution(screenNumber, oldRes);
   % pix_deg_vert = pi * wRect(4) / atan(screencm(2)/v_d/2) / 360 %to calculate the limit of target position
    white=WhiteIndex(screenNumber);
    black=BlackIndex(screenNumber);
    gray=round((white+black)/2);
    if gray == white
        gray=white / 2;
    end;
    inc=1;
    theseed=sum(100*clock);
    rand('twister',theseed );
    ifi = Screen('GetFlipInterval', w);
    if ifi==0
        ifi=1/75;
    end
    % SOUND
    InitializePsychSound;
    pahandle = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    pahandle1 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    pahandle2 = PsychPortAudio('Open', [], 1, 1, 44100, 2);

    
    %% fill buffers 
    
 %   if BITS==2;
        [errorS freq  ] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
        [corrS freq  ] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
%     else
%         [errorS freq  ] = wavread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
%         [corrS freq  ] = wavread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
%     end;
    % corrS=zeros(size(errorS));
    
    
        PsychPortAudio('FillBuffer', pahandle1, corrS' ); % loads data into buffer       
    PsychPortAudio('FillBuffer', pahandle2, errorS'); % loads data into buffer
    load('S096_marl-nyu');
    
    %% STAIRCASE
    StartCont=15;  %15
    if expday==0 || expday==1 || expday==numstudydays || expday==numstudydays+1
        thresh(1:cndt, 1:ca)=StartCont; %Changed from 10 to have same starting contrast as the smaller Contlist
        step=5;
        if BITS<2
            %  currentsf=sflist(4);
            currentsf=4;
        elseif BITS==2
            %   currentsf=sflist(1);
            currentsf=1;
            numstudydays=100;
        end
    else
        d = dir(['./data/' SUBJECT '_DAY_' num2str(expday-1) '*.mat']);
        [dx,dx] = sort([d.datenum]);
        newest = d(dx(end)).name;
        oldthresh=load(['./data/' newest],'thresh');
        currentsfold=load(['./data/' newest],'currentsf');
        if isempty(fieldnames(currentsfold))
            if BITS<2
                %   currentsf=sflist(4);
                currentsf=4;
            elseif BITS==2
                %   currentsf=sflist(1);
                currentsf=1;
                numstudydays=100;
            end
        else
            currentsf=currentsfold.currentsf;
        end
        
        thresh(1:cndt, 1:ca)=oldthresh.thresh(1:cndt, 1:ca)-2;
        step=1;
    end;
    
    
    reversals(1:cndt, 1:ca)=0;
    isreversals(1:cndt, 1:ca)=0;
    staircounter(1:cndt, 1:ca)=0;
    corrcounter(1:cndt, 1:ca)=0;
    
    % Threshold -> 79%
    sc.up = 1;                          % # of incorrect answers to go one step up
    sc.down = 3;                        % # of correct answers to go one step down
    
    Contlist = log_unit_down(max_contrast+.122, 0.05, 76); %Updated contrast possible values
    Contlist(1)=1;
    
    stepsizes=[4 4 3 2 1];
    
    SFthreshmin=0.01;
    
    SFthreshmax=Contlist(StartCont);
    SFadjust=10;
    
    
    %% gabor settings and fixation point
    
    sigma_pix = sigma_deg*pix_deg;
    imsize=(sigma_pix*2.5)/2;
    [x,y]=meshgrid(-imsize:imsize,-imsize:imsize);
    G = exp(-((x/sigma_pix).^2)-((y/sigma_pix).^2));
    fixationlength = 10; % pixels
    [r, c] = size(G);
    
    %creating gabor images
    
    % if noise ==1
    
    phases= [pi, pi/2, 2/3*pi, 1/3*pi];
    
        
    %circular mask
    xylim = imsize; %radius of circular mask
    circle = x.^2 + y.^2 <= xylim^2;
    rot=0*pi/180; %redundant but theoretically correct
    Gmaxcontrast=1; %same
    for i=1:(length(sflist));
        for g=1:length(phases);
            f_gabor=(sflist(i)/pix_deg)*2*pi;
            a=cos(rot)*f_gabor;
            b=sin(rot)*f_gabor;
            m=Gmaxcontrast*sin(a*x+b*y+phase(phases(g))).*G;
          %  TheGabors(i,g)=Screen('MakeTexture', w, gray+inc*m,[],[],2);           
            m=m+gray;
            m = double(circle) .* double(m)+gray * ~double(circle);                       
            %TheGabors(i,g)=Screen('MakeTexture', w, gray+inc*m,[],[],2);            
            TheGabors(i,g)=Screen('MakeTexture', w, m,[],[],2);
            
            
        end;
    end;
    
    % else
    % rot=0*pi/180; %redundant but theoretically correct
    % maxcontrast=1; %same
    % for i=1:(length(sfs));
    %     f_gabor=(sfs(i)/pix_deg)*2*pi;
    %     a=cos(rot)*f_gabor;
    %     b=sin(rot)*f_gabor;
    %     m=maxcontrast*sin(a*x+b*y+phase(j)).*G;
    %     TheGabors(i)=Screen('MakeTexture', w, gray+inc*m,[],[],2);
    % end;
    % end;
    
    
    %add a second dimension with phase (4 levels)
    %divide the number of trials x levels of noise
    %noise in the loop, gabor outside
    
    
    oval_thick=10; %thickness of oval
    
    %set the limit for stimuli position along x and y axis
    %xLim=((wRect(3)-(2*imsize))/pix_deg)/2;
    %yLim=((wRect(4)-(2*imsize))/pix_deg_vert)/2;
    
    
    
    xLim=(((35*pix_deg)-(2*imsize))/pix_deg)/2;
    yLim=(((35*pix_deg)-(2*imsize))/pix_deg_vert)/2;
    bg_index =round(gray*255); %background color
    
    
    %radius=17.5;   %radius of the circle in which the target can appear
    r_lim=((radius*pix_deg)-(imsize))/pix_deg;
    
    %circular mask
    xylim = imsize; %radius of circular mask
    circle = x.^2 + y.^2 <= xylim^2;
    [nrw, ncl]=size(x);
    %creating face images
    StimuliFolder='./Images/'; %to be updated! AS now updated.
    thefaces=dir([StimuliFolder '*_*']);
    
    counter=zeros(2);
    for i=1:length(thefaces)
        inputImage=rgb2gray(imread([StimuliFolder thefaces(i).name]));
        inputImage =imresize(inputImage,[nrw nrw],'bicubic');
        inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
        
        if ~isempty(findstr('_h_',thefaces(i).name))
            e=1;
        elseif ~isempty(findstr('_s_',thefaces(i).name))
            e=2;
        end
        
        if ~isempty(findstr('_M_',thefaces(i).name))
            s=1;
        elseif ~isempty(findstr('_F_',thefaces(i).name))
            s=2;
        end
        counter(s,e)=counter(s,e)+1;
        TheFaces(counter(s,e),s,e)=Screen('MakeTexture', w, inputImage);
    end
    
    numfaces=min(counter(:));
    
    %% main loop
    HideCursor(0);
    counter = 0;
    
    WaitSecs(1);
    % Select specific text font, style and size:
    Screen('TextFont',w, 'Arial');
    Screen('TextSize',w, 42);
    %     Screen('TextStyle', w, 1+2);
    Screen('FillRect', w, gray);
    colorfixation = white;
    
    RespType(1) = KbName('RightArrow');
    RespType(2) = KbName('LeftArrow');
    
    %     if exist('passedTraining')==0
    %         passedTraining=0;
    %         numTraining=0;
    %         if BITS==1
    %             passedTraining=training_UCR_noise_current4(SUBJECT, typeOfTraining, baseName, w, wRect, pahandle, RespType, screencm, screenNumber);
    %         elseif BITS==2
    %             passedTraining=training_UAB_noise_current(SUBJECT, typeOfTraining, baseName, w, wRect, pahandle, RespType, screencm, screenNumber);
    %         elseif BITS==0
    %             passedTraining=training_UCR_noise_current4(SUBJECT, typeOfTraining, baseName, w, wRect, pahandle, RespType, screencm, screenNumber);
    %         end;
    %         numTraining=numTraining+1;
    %     elseif passedTraining==0 && numTraining<=4
    %         if BIST==1
    %             passedTraining=training_UCR_noise_current4(SUBJECT, typeOfTraining, baseName, w, wRect, pahandle, RespType, screencm, screenNumber);
    %         elseif BITS==2
    %             passedTraining=training_UAB_noise_current4(SUBJECT, typeOfTraining, baseName, w, wRect, pahandle, RespType, screencm, screenNumber);
    %         elseif BITS==0
    %             passedTraining=training_UCR_noise_current4(SUBJECT, typeOfTraining, baseName, w, wRect, pahandle, RespType, screencm, screenNumber);
    %         end;
    %         numTraining=numTraining+1;
    %     elseif numTraining>4
    %         DrawFormattedText(w, 'Training Failed, please inform the experimenter.', 'center', 'center', white);
    %         Screen('Flip', w);
    %         KbWait;
    %         return;
    %     end
    
    
    %ims=17.5*pix_deg;
    ims=radius*pix_deg;
    [ax,ay]=meshgrid(-ims:ims,-ims:ims);
    
    imageRect2 = CenterRect([0, 0, size(ax)], wRect);
    
    Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('FrameOval', w,0.8, imageRect2, oval_thick, oval_thick);
    Screen('Flip', w);
    KbWait;
    
    
    
    %%
    if face_t==0;
        DrawFormattedText(w, 'Press Left key when tilted Left \n \n Press Right key when tilted Right\n \n \n \n Press any key to start', 'center', 'center', white);
        Screen('Flip', w);
    else
        DrawFormattedText(w, 'Press Left key when tilted Left or female \n \n Press Right key when tilted Right or male \n \n \n \n Press any key to start', 'center', 'center', white);
        Screen('Flip', w);
    end;
    KbWait;
    Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('Flip', w);
    WaitSecs(1.5);
    % KbWait;
    Screen('Flip', w);
    %possible orientations
    % theoris=[22.5 67.5 -22.5 -67.5 ];
    theoris=[22.5 45 -22.5 -45  ];
    %     currentsf=1;
    maskRect=[0,0,length(m),length(m)];
    dstRect=CenterRectOnPoint(maskRect,wRect(3)/2,wRect(4)/2);
    aperture=Screen('OpenOffscreenwindow', w, 0.5, maskRect);
    
    % check EyeTracker status
    if EyeTracker == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        % mark zero-plot time in data file
        Eyelink('message' , 'SYNCTIME');
        
        location =  zeros(length(mixtr), 6);
    end
    

    
    eyetime2=0;
    waittime=ifi*60;
    scotomadeg=10;
    scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg_vert]
    scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
    scotoma_color=[100 100 100];
    xeye=[];
    yeye=[];
    %  pupils=[];
    tracktime=[];
    VBL_Timestamp=[];
    stimonset=[ ];
    fliptime=[ ];
    mss=[ ];
    tracktime=[];
    FixDotSize=15;

        
        
    for trial=1:length(mixtr)
        
  
        
        
                
                    TrialNum = strcat('Trial',num2str(trial));

        
clear EyeData
clear FixIndex
        xeye=[];
    yeye=[];
%    pupils=[];
    tracktime=[];
    VBL_Timestamp=[];
    stimonset=[ ];
    fliptime=[ ];
    mss=[ ];
    tracktime=[];
        %    tracktime=[];
        FixCount=0;
        FixatingNow=0;
        EndIndex=0;  % is it correct? aslo check driftcorr--where is it


        if (mod(trial,100))==1
            if trial==1
                
            else
                Screen('TextFont',w, 'Arial');
                Screen('TextSize',w, 42);
                %     Screen('TextStyle', w, 1+2);
                Screen('FillRect', w, gray);
                colorfixation = white;
                DrawFormattedText(w, 'Take a short break and rest your eyes \n\n  \n \n \n \n Press any key to start', 'center', 'center', white);
                Screen('Flip', w);
                KbQueueWait;
            end
        end
        
        contr = Contlist(thresh(mixtr(trial,1),mixtr(trial,2)));
        if typeOfTraining==3
            noize=noise_level(mixtr(trial,2));
            oval_thick=0;
            ContCirc=0.5;
        elseif typeOfTraining==1
            %contrast of the cue
            ContCirc= CircConts(mixtr(trial,2));
            noize=0;
        else
            oval_thick=0;
            ContCirc=0.5;
            noize=0;
        end
        %noise intertrial
        if trial==1;
            %   start_time = GetSecs;
            %   eyetime=GetSecs-start_time;
            %   eyetime=GetSecs;

            noisemat2=randn(length(m),length(m))*noize+0.5;
            noisemat2(noisemat2>1)=1;
            noisemat2(noisemat2<0)=0;
            noisetex2=Screen('MakeTexture', w, noisemat2,[],[],2);
        end;
        %noise stimulus frame
        noisemat=randn(length(m),length(m))*noize+0.5;
        noisemat(noisemat>1)=1;
        noisemat(noisemat<0)=0;
        noisetex=Screen('MakeTexture', w, noisemat,[],[],2);
        
        
        %get the sf of the stimuli
        sf=sflist(currentsf);
        %randomize (or not) the position of the stimuli along x and y axes
        if randomizzato==1;
            %         xmin = -xLim;
            %         xmax = xLim;
            %         ecc_x = (xmax-xmin).*rand(1,1) + xmin;
            %         ymin = -yLim;
            %         ymax = yLim;
            %         ecc_y = (ymax-ymin).*rand(1,1) + ymin;
            
            ecc_r=r_lim.*rand(1,1);
            ecc_t=2*pi*rand(1,1);
            cs= [cos(ecc_t), sin(ecc_t)];
            xxyy=[ecc_r ecc_r].*cs;
            ecc_x=xxyy(1);
            ecc_y=xxyy(2);
        else
            ecc_x=0;
            ecc_y=0;
        end;
        
        %generate visual cue
        eccentricity_X=ecc_x*pix_deg;
        eccentricity_Y=ecc_y*pix_deg;
        imageRect = CenterRect([0, 0, size(x)], wRect);
        
        imageRect_offs =[imageRect(1)+eccentricity_X, imageRect(2)+eccentricity_Y,...
            imageRect(3)+eccentricity_X, imageRect(4)+eccentricity_Y];
        
        audiocue %generates audio cue
        
        theans(trial)=randi(2); %generates answer for this trial
        if mixtr(trial,1)<=length(sfs)
            ori_i(trial)=2*theans(trial) +randi(2)-2;
            ori= theoris(ori_i(trial));
            fase=randi(4);
            %     texture(trial)=TheGabors(sf, fase);
            texture(trial)=TheGabors(currentsf, fase);
        else
            gender_i(trial)=theans(trial);
            facce(trial)=randi(numfaces);
            emotion(trial)=randi(2);
            ori=0;
            texture(trial)=TheFaces(facce(trial),gender_i(trial), emotion(trial));
        end;
        
        Priority(1);
        eyechecked=0
        KbQueueFlush()
        %trial_time = GetSecs;
           stopchecking=-100;
      %  EyeData=9999;
        trial_time=100000
        
        clear stim_start;
        while eyechecked<1
         %   tic
         %   eyetime2=GetSecs-trial_time;
     %    if trial==1
      %       eyetime2=GetSecs
       %  end
         %   fnfnf=[fnfnf eyetime2];

%            if eyetime2>waittime && eyetime2<waittime+ifi
            if (eyetime2-trial_time)>0 && (eyetime2-trial_time)<waittime+ifi && stopchecking>1
                Screen('DrawTexture', w, noisetex2);
                if typeOfTraining==3
                    Screen('FillOval', aperture, [0.5,0.5,0.5,contr], maskRect);
                    Screen('DrawTexture', w, aperture, [], dstRect, [], 0);
                end
                if fixat==1;
                    Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                    Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
                end
         %       toc
          %      disp('start')
                %here i present the stimuli+acoustic cue
            elseif (eyetime2-trial_time)>=waittime+ifi*2 && (eyetime2-trial_time)<waittime+ifi*3  && stopchecking>1 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0 %present pre-stimulus and stimulus
                
           %      toc
          %      disp('sound+cue')
                % Presents Cue
                %      [vbl,cueonset]=Screen('Flip', w); %clear the screen
                %  cueonset=GetSecs
                
                
                %Fill the buffer and play our sound
                vbl=GetSecs
                cueontime=vbl + (ifi * 0.5);
                % t1 = PsychPortAudio('Start', pahandle);

                        PsychPortAudio('Start', pahandle,1,inf); %starts sound at infinity
                PsychPortAudio('RescheduleStart', pahandle, cueontime, 0) %reschedules startime to
                Screen('FrameOval', w,ContCirc, imageRect_offs, oval_thick, oval_thick);
                
                %Draw Target
                Screen('DrawTexture', w, noisetex);
                if typeOfTraining==3
                    Screen('FillOval', aperture, [0.5,0.5,0.5,0], maskRect);
                    Screen('DrawTexture', w, aperture, [], dstRect, [], 0);
                end
                Screen('DrawTexture', w, texture(trial), [], imageRect_offs, ori,[], contr );
                Screen('FrameOval', w,ContCirc, imageRect_offs, oval_thick, oval_thick);
                               
                
                stim_start=GetSecs;                              
            elseif (eyetime2-trial_time)>=waittime+ifi*3 && stopchecking>1 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0 %present pre-stimulus and stimulus
          %       toc
           %     disp('stimulus')
           
           
             if exist('stim_start')==0
         stim_start=GetSecs; 
     end;
                Screen('DrawTexture', w, noisetex);
                if typeOfTraining==3
                    Screen('FillOval', aperture, [0.5,0.5,0.5,0], maskRect);
                    Screen('DrawTexture', w, aperture, [], dstRect, [], 0);
                end
                Screen('DrawTexture', w, texture(trial), [], imageRect_offs, ori,[], contr );
                Screen('FrameOval', w,ContCirc, imageRect_offs, oval_thick, oval_thick);
                               
                
            elseif (eyetime2-trial_time)>=waittime+ifi*4 && stopchecking>1 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)~= 0 %wait for response    
                
                             if exist('stim_start')==0
         stim_start=GetSecs; 
     end;
            %    tic
            %     toc
             %   disp('afterkeypress')
                stim_stop=GetSecs;
                thekeys = find(keyCode);
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);                                 
                if trial>1;
            Screen('Close', noisetex2);
            noisemat2=randn(length(m),length(m))*noize+0.5;
            noisemat2(noisemat2>1)=1;
            noisemat2(noisemat2<0)=0;
            noisetex2=Screen('MakeTexture', w, noisemat2,[],[],2);
        end;
        
        Screen('DrawTexture', w, noisetex2);
        if typeOfTraining==3
            Screen('FillOval', aperture, [0.5,0.5,0.5,contr], maskRect);
            Screen('DrawTexture', w, aperture, [], dstRect, [], 0);
        end
                eyechecked=1111111111;
                                    % code the response
            foo=(RespType==thekeys);
            
            staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
            Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=contr;
            
            if foo(theans(trial))
                resp = 1;
                corrcounter(mixtr(trial,1),mixtr(trial,2))=corrcounter(mixtr(trial,1),mixtr(trial,2))+1;                
                            PsychPortAudio('Start', pahandle1);
                if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                    
                    if isreversals(mixtr(trial,1),mixtr(trial,2))==1
                        reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
                        isreversals(mixtr(trial,1),mixtr(trial,2))=0;
                    end
                    thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                    
                    %  if thresh(mixtr(trial,1),mixtr(trial,2))<SFthreshmin
                    if contr<SFthreshmin && currentsf<length(sflist)
                        currentsf=min(currentsf+1,length(sflist))
                        foo=find(Contlist>=SFthreshmin);
                        %thresh(mixtr(:,:))=foo(end) -SFadjust;
                        thresh(:,:)=foo(end)-SFadjust;
                        
                        %                     thresh(mixtr(trial,1),mixtr(trial,2))=max( thresh(mixtr(trial,1),mixtr(trial,2)),1);
                        corrcounter(:,:)=0;
                        thestep=3;
                    else
                        thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) +stepsizes(thestep);
                        thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Contlist));
                        
                    end
                    
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
                            PsychPortAudio('Start', pahandle2);
                thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
                
                %   if thresh(mixtr(trial,1),mixtr(trial,2))>SFthreshmax
                if contr>SFthreshmax && currentsf>1
                    currentsf=max(currentsf-1,1);
                    thresh(:,:)=StartCont+SFadjust;
                    corrcounter(:,:)=0;
                    thestep=3;
                    %                 thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Contlist));
                else
                    
                    thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
                    thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)),1);
                end
            end

            end
            eyefixation3
            
                        if newsamplex>wRect(3) || newsampley>wRect(4) || newsamplex<0 || newsampley<0
                Screen('FillRect', w, gray);
            else
                Screen('FillOval', w, scotoma_color, scotoma);
            end
         %   Screen('FillOval', w, scotoma_color, scotoma);  
            %    save time and other stuff from flip    equal Screen('Flip', w,vbl plus desired time half of framerate);
        %    [eyetime, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w, eyetime-(ifi * 0.5));
      
        [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);


     VBL_Timestamp=[VBL_Timestamp eyetime2];
   %  stimonset=[stimonset StimulusOnsetTime];
    % fliptime=[fliptime FlipTimestamp];
    % mss=[mss Missed];
     
     
       GetEyeTrackerData
           GetFixationDecision
           
           
           if EyeData(1)<8000 && stopchecking<0
               trial_time = GetSecs;
               stopchecking=10
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
            [keyIsDown, keyCode] = KbQueueCheck;
           %  toc
            %    disp('fine')
        end
        
        
%                         if trial>1;
%             Screen('Close', noisetex2);
%             noisemat2=randn(length(m),length(m))*noize+0.5;
%             noisemat2(noisemat2>1)=1;
%             noisemat2(noisemat2<0)=0;
%             noisetex2=Screen('MakeTexture', w, noisemat2,[],[],2);
%         end;
%         
%         Screen('DrawTexture', w, noisetex2);
%         if typeOfTraining==2
%             Screen('FillOval', aperture, [0.5,0.5,0.5,contr], maskRect);
%             Screen('DrawTexture', w, aperture, [], dstRect, [], 0);
%         end

        
        
     %   Screen('FillOval', w, scotoma_color, scotoma);
        
      %  Screen('Flip', w);
                %Screen('Close', texture);
                Screen('Close', noisetex);
                % Screen('Close', noisetex2);
        

        %    PsychPortAudio('Start', pahandle);
            
               %     PsychPortAudio('Stop', pahandle);

        
           
      %  stim_stop=secs;
                   if exist('stim_start')==0
         stim_start=GetSecs; 
     end;
        time_stim(kk) = stim_stop - stim_start;
        totale_trials(kk)=trial;
        coordinate(trial).x=ecc_x;
        coordinate(trial).y=ecc_y;
        rispo(kk)=resp;
        feat(kk)=sf;
        contrcir(kk)=ContCirc;
        contrasto(kk)=contr;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
    vbltimestamp(trial).ix=[VBL_Timestamp];
    flipptime(trial).ix=[fliptime];
%         if eyeOrtrack==1
%             ppupils(trial).xx=[pupils];
%             ttrackertime(trial).xx=[tracktime];
%         end
%         


 
    
            
% 
%      if exist('EyeData')==0
%         EyeData=0;
%     end;
%     
    if ~exist('EyeData','var')
    EyeData = ones(1,5)*9001;
    end
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
          EyeSummary.(TrialNum).TargetX = ecc_x;
               EyeSummary.(TrialNum).TargetY = ecc_y;              
%              EyeSummary.(TrialNum).RadOrTan=radOrtan;
     EyeSummary.(TrialNum).EventData = EvtInfo;
     clear EvtInfo
    EyeSummary.(TrialNum).ErrorData = ErrorData;
    clear ErrorData
    
%    EyeSummary.(TrialNum).Fontsize=fontsize_arcmin;
  %  EyeSummary(trial).GetFixationInfo.DriftCorrIndices = DriftCorrIndices;
     EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
     EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
     EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
     EyeSummary.(TrialNum).TimeStamps.RT = stim_stop - stim_start;
          EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;
     %FixStamp(TrialCounter,1);
     EyeSummary.(TrialNum).TimeStamps.Stimulus = stim_start;
     %StimStamp(TrialCounter,1);
       clear ErrorInfo
       
       
       
       if (mod(trial,50))==1
    if trial==1
    else
            save(baseName);
%        save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|ax|ay|xxx|yyyy|circle|azimuths|corrS|errorS|Allimg)$).');
    end
end
    
        
            kk=kk+1;
       %     save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
                         
            if closescript==1
                break;
            end;  
                      
        end
    
    % shut down EyeTracker
    if EyeTracker==1
        Eyelink('StopRecording');
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    end;
    
    
           % save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|ax|ay|xxx|yyyy|circle|azimuths|corrS|errorS|Allimg)$).');
    save(baseName);
    
    DrawFormattedText(w, 'Task completed - Please inform the experimenter', 'center', 'center', white);
    Screen('Flip', w);
    KbWait;
    ShowCursor;
    
    if BITS==1
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
    end;
    
    %% data analysis (to be completed once we have the final version)
    
    
    %to get each scale in a matrix (as opposite as Threshlist who gets every
    %trial in a matrix)
    thresho=permute(Threshlist,[3 1 2]);
    
    %to get the final value for each staircase
    final_threshold=thresho(numel(thresho(:,:,1)),1:length(thresho(1,:,1)),1:length(thresho(1,1,:)));
    %total_thresh= [final_threshold(:,:,1) final_threshold(:,:,2)];
    %%
      %  save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|ax|ay|xxx|yyyy|circle|azimuths|corrS|errorS|Allimg)$).');
    
    
catch ME
    psychlasterror()
end