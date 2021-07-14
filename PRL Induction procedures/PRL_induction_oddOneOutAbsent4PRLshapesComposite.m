% Contrast threshold measurement with randomized position of the target -
% wait until response

close all; clear all; clc;
commandwindow
try
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    KbName('UnifyKeyNames');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    
    prompt={'Subject Number:'...
        'Day:', 'scotoma size'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','0', '10'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end;
    
    addpath('/Users/sll/Desktop/Flap/Flap_scripts/utilities')
 %   addpath('/Volumes/STORE N GO/NewInductionToTest/utilities')
    eyeOrtrack=1; %0=mouse, 1=eyetracker   
    
    if eyeOrtrack==1
        EyeTracker = 1; % set to 1 for UAB code testing
        EyetrackerType=1;
    elseif eyeOrtrack==0
        EyeTracker=0;
    end

    SUBJECT = answer{1,:}; %Gets Subject Name
    expday = str2num(answer{2,:});
    expdayeye = answer{2,:};
    scotomadeg=str2num(answer{3,:});
    
    BITS=0; % (1=Bits++; 2=Display++; 0=no bits)
    if BITS==1
        % cd '/Users/visionlab/Desktop/AMD assessment 2017/CAT food';
        
        cd '/Users/visionlab/Desktop/AMD assessment 2017/CAT food (2 to 13)'
    elseif BITS==2
        cd 'C:\Users\labadmin\Desktop\marcello AMD assessment\7.Training'
    elseif BITS==0
        cd;
    end;
    
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end;
    
    
            inductionType = 1; % 1 = assigned, 2 = annulus
if inductionType ==1
    TYPE = 'Assigned'
elseif inductionType == 2
    TYPE = 'Annulus'
end
    
    baseName=['./data/' SUBJECT '_DAY_' num2str(expday) '_PRL_induction_oddoneoutabsent_' TYPE '_' num2str(scotomadeg) ' deg ' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    

      
    closescript=0;
    kk=1;               

    
    Screen('Preference', 'SkipSyncTests', 1);
    PC=getComputerName();
    max_distractors=15;
    blocks=10;  %number of blocks in which we want the trials to be divided

   %    sigma_deg = 1;
    stimulussize=3;
    
    randomizzato=1;
    CircConts=[0.51,1]; %low/high contrast circular cue
    fixat=0;
    SOA=0;          
    
    theseed=sum(100*clock);
    rand('twister',theseed);
    

     %   trials=500;
                trials=10;

       randomposition = 0; 
        assignedpositionmatrix=[-8 -8; 8 -8; -8 8; 8 8];

mixtr=ones(trials,2);           
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
    
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if ispc
%         escapeKey = KbName('esc');	% quit key
%     elseif ismac
%         escapeKey = KbName('ESCAPE');	% quit key
%     end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     
    
    
    
    escapeKey = KbName('Escape'); % quit key
    
    
    if EyeTracker==1;
        useEyeTracker = 0; % otherwise will throw error if not UAB run
        
        %eyeTrackerBaseName=[SUBJECT '_DAY_' num2str(expday) '_CAT_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
        %eyeTrackerBaseName = 's00';
        eyeTrackerBaseName =[SUBJECT expdayeye];
        
   %     save_dir='C:\Users\labadmin\Desktop\marcello AMD assessment\7.Training\test_eyetracker_files';
        
   
       if exist('dataeyet')==0
        mkdir('dataeyet')
    end;
    save_dir=[cd './dataeyet/']
    end;
    
    
    
    if BITS==1  %UCR
        %% psychtoobox settings
        screencm=[40.6, 30];%[UAB:69.8x35.5; UCR: 40.6x30 ]
        load gamma197sec;
        v_d=110;
        radius=9.5;   %radius of the circle in which the target can appear
        AssertOpenGL;
        oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
        %PsychGPUControl('SetDitheringEnabled', 0); Not supported on OSX
        screenNumber=max(Screen('Screens'));
        rand('twister', sum(100*clock));
        PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
        PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
        %PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
        PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
        PsychImaging('AddTask', 'FinalFormatting','DisplayColorCorrection','LookupTable');
        oldResolution=Screen( 'Resolution',screenNumber,1280,960);
        SetResolution(screenNumber, oldResolution);
        [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
        PsychColorCorrection('SetLookupTable', w, lookuptable);
        %if you want to open a small window for debug
        %   [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
        % Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        %  PsychColorCorrection('SetLookupTable', window, Nlinear_lut);
        %Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
        Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
    elseif BITS==0;  %no Bits, 256 RGB
        
        %% psychtoobox settings
        v_d=57;
        radius=12.5;   %radius of the circle in which the target can appear
        screencm=[40.6, 30];%[UAB:69.8x35.5; UCR: 40.6x30 ]
        AssertOpenGL;
        screenNumber=max(Screen('Screens'));
        PsychImaging('PrepareConfiguration');
     %   PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
        %    oldResolution=Screen( 'Resolution',screenNumber,1280,960);
        %    oldResolution=Screen( 'Resolution',screenNumber,1280,960);
            oldRes=SetResolution(0,1280,1024);
    SetResolution(screenNumber, oldRes);
        %   SetResolution(screenNumber, oldResolution);
       [w, wRect]=PsychImaging('OpenWindow',screenNumber, 0,[],32,2);
        %debug window
   % [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
        %ScreenParameters=Screen('Resolution', screenNumber); %close all
        %struct.res=[ScreenParameters.width ScreenParameters.height];
        %Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
        %Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
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
      
      
      
      %struct.res=[1280 960];

    struct.sz=[screencm(1), screencm(2)];
    %pix_deg = pi * wRect(3) / atan(screencm(1)/v_d/2) / 360; %pixperdegree
    pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi));
    pix_deg_vert=1./((2*atan((screencm(2)/wRect(4))./(2*v_d))).*(180/pi));
    %pix_deg_vert = pi * wRect(4) / atan(screencm(2)/v_d/2) / 360 %to calculate the limit of target position
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
      %      Eyelink('command', 'calibration_type = HV5'); % changed to 5 to correct upper left corner of the screen issue
            % you must send this command with value NO for custom calibration
            % you must also reset it to YES for subsequent experiments
       %     Eyelink('command', 'generate_default_targets = NO');
            
            
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
%                 round(winWidth*modFactor), round(winHeight*modFactor),
%                 round(winWidth - winWidth*modFactor), ...
%                 round(winHeight*modFactor), round(winWidth*modFactor), round(winHeight - winHeight*modFactor),...
%                 round(winWidth - winWidth*modFactor), round(winHeight - winHeight*modFactor)  );
%             
            % make sure that we get gaze data from the Eyelink
            Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
            Eyelink('OpenFile', eyeTrackerFileName); % open file to record data  & calibration
            EyelinkDoTrackerSetup(elHandle);
            Eyelink('dodriftcorrect');
        end
         
    % SOUND
    InitializePsychSound;
    pahandle = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    pahandle1 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    pahandle2 = PsychPortAudio('Open', [], 1, 1, 44100, 2);

    
    %% fill buffers 
    
%     if BITS==2;
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
    StartCont=1;  %15
    thresh(1:1, 1:1)=StartCont; 
    step=5;

    
    reversals(1:1, 1:1)=0;
    isreversals(1:1, 1:1)=0;
    staircounter(1:1, 1:1)=0;
    corrcounter(1:1, 1:1)=0;
    
    % Threshold -> 79%
    sc.up = 1;                          % # of incorrect answers to go one step up
    sc.down = 3;                        % # of correct answers to go one step down
        
    Distlist=[0:1:max_distractors]';
    
    %stepsizes=[4 4 3 2 1];
    
    
    stepsizes=[1 1 1 1 1];
    
    SFthreshmin=0.01;
    
    
    %% gabor settings and fixation point

    imsize=stimulussize*pix_deg;
    [x,y]=meshgrid(-imsize:imsize,-imsize:imsize);
    fixationlength = 10; % pixels
    
        
    %set the limit for stimuli position along x and y axis
    %xLim=((wRect(3)-(2*imsize))/pix_deg)/2;
    %yLim=((wRect(4)-(2*imsize))/pix_deg_vert)/2;
    
    
    
    xLim=(((35*pix_deg)-(2*imsize))/pix_deg)/2;
    yLim=(((35*pix_deg_vert)-(2*imsize))/pix_deg_vert)/2;
    bg_index =round(gray*255); %background color
    
    
    %radius=17.5;   %radius of the circle in which the target can appear
   % radius=6
    r_lim=((radius*pix_deg)-(imsize))/pix_deg;

    
    
  %  positions=(-r_lim:stimulussize*1.2:r_lim);



positions = [-3 3];
positionmatrix=[positions; positions]';

posmatrix=fullfact([length(positions) length(positions)]);

    
 poknrw=imsize;


[img, sss, alpha] =imread('neutralface.png');
img(:, :, 4) = alpha;
Distractorface=Screen('MakeTexture', w, img);



[img, sss, alpha] =imread('neutral21.png');
img(:, :, 4) = alpha;
Neutralface=Screen('MakeTexture', w, img);



totalelements = 4; % number of stimuli on screen

visibleCircle = 1; % 1= visible, 2 = invisible
    OtherFolder='/Users/sll/Desktop/Flap/stimuli_inductionii/'; %to be updated! AS now updated.

    thetargets=dir([OtherFolder '*TGT*']);
        theothers=dir([OtherFolder '*OT*']);
 
  %  sigma_pix = stimulussize*pix_deg;
  %  imsize=(sigma_pix*2.5)/2;
  %      [x,y]=meshgrid(-imsize:imsize,-imsize:imsize);
 % cxylim = imsize; %radius of circular mask
 %   circle = x.^2 + y.^2 <= cxylim^2;
  %  counter=zeros(2);
 %   [nrw, ncl]=size(x);
%     
%     for i=1:length(thetargets)
% %        inputImage=rgb2gray(imread([OtherFolder thetargets(i).name]));
%                 inputImage=imread([OtherFolder thetargets(i).name]);
%         inputImage =imresize(inputImage,[nrw nrw],'bicubic');
%         inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
%         theTargetss(i)=Screen('MakeTexture', w, inputImage);
%     end
%     
%     
%     for i=1:length(theothers)
% %        inputImage=rgb2gray(imread([OtherFolder theothers(i).name]));
%         inputImage=imread([OtherFolder theothers(i).name]);
%         inputImage =imresize(inputImage,[nrw nrw],'bicubic');
%         inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
%         theOtherss(i)=Screen('MakeTexture', w, inputImage);
%     end


    
    
    
    
    %%
sizedeg=3;
%pix_deg=34;
separationdeg=2;
separation=round(separationdeg*pix_deg);

distancedeg=6;
distances=round(distancedeg*pix_deg);
theta = [3*pi/2  0  pi ];

rho = [distances distances distances];

[elementcoordx,elementcoordy] = pol2cart(theta,rho);


%imsize=((sizedeg*pix_deg)/2);
imsize=sizedeg*pix_deg;

totalstimulussize=separation+imsize*2;
totalstimulussize=[totalstimulussize totalstimulussize];
[x,y]=meshgrid(-imsize:imsize,-imsize:imsize);
xylim = imsize; %radius of circular mask
circle = x.^2 + y.^2 <= xylim^2;
[nrw, ncl]=size(x);

angles= [-60 -45 -30 30 45 60 90 -90];

rotationAngle=angles(randi(length(angles)));

    theFolder = [cd '/letter/'];

%trials=10;
for i=1:trials
   pos_one(i)=angles(randi(length(angles)));
   pos_two(i)=angles(randi(length(angles))) ;
   pos_three(i)= angles(randi(length(angles)));
   pos_four(i)= angles(randi(length(angles)));
   
   set_dist{i}=[pos_one(i) pos_two(i) pos_three(i) pos_four(i)];
   whichLoc(i)=randi(4);   
   thesetDist=set_dist{i};
newangles=angles;
newangles(find(thesetDist(whichLoc(i)))) = [];
   thesetTgt=thesetDist
   thesetTgt(whichLoc)=newangles(randi(length(newangles)));
   set_tgt{i}=thesetTgt;
   %clear theset newangles
%end

%set_tgt{i}
%set_dist{i}


theLetter=imread([theFolder 'newletterc22.tiff']);
theLetter=theLetter(:,:,1);
theLetter=imresize(theLetter,[nrw nrw],'bicubic');


theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
rotLetterone=imrotate(theLetter,thesetDist(1));
rotLetterone(rotLetterone==0)=127;
[rotrwi, rotcli]=size(rotLetterone);

rotLettertwo=imrotate(theLetter,thesetDist(2));
rotLettertwo(rotLettertwo==0)=127;
[rotrwii, rotclii]=size(rotLettertwo);

rotLetterthree=imrotate(theLetter,thesetDist(3));
rotLetterthree(rotLetterthree==0)=127;
[rotrwiii, rotcliii]=size(rotLetterthree);

rotLetterfour=imrotate(theLetter,thesetDist(4));
rotLetterfour(rotLetterfour==0)=127;
[rotrwiv, rotcliv]=size(rotLetterfour);

thesizes= [rotrwi rotrwii rotrwiii rotrwiv];

thisize=max(thesizes)

blankimage = ones(thisize,thisize)*bg_index;
largerBlankimage=ones(thisize+separation,thisize+separation)*bg_index;

border_two=round(((thisize+separation)-nrw)/2);
border_one=border_two+1;

[largrotrw, largrotcl]=size(largerBlankimage);

largerrotLetterone=largerBlankimage;

border_two_rot =round(largrotrw-rotrwi)/2;
border_one_rot=border_two_rot+1;

try
    largerrotLetterone(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetterone(1:end,1:end);
end

try
    largerrotLetterone(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetterone(1:end,1:end);
end

try
    largerrotLetterone(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterone(1:end,1:end);
end

largerrotLettertwo=largerBlankimage;

border_two_rot =round(largrotrw-rotrwii)/2;
border_one_rot=border_two_rot+1;

try
largerrotLettertwo(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLettertwo(1:end,1:end);
end

try
    largerrotLettertwo(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLettertwo(1:end,1:end);

end

try
largerrotLetterone(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterone(1:end,1:end);
end



largerrotLetterthree=largerBlankimage;

border_two_rot =round(largrotrw-rotrwiii)/2;
border_one_rot=border_two_rot+1;

try
largerrotLetterthree(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetterthree(1:end,1:end);
end

try
 largerrotLetterthree(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetterthree(1:end,1:end);
end

try
largerrotLetterthree(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterthree(1:end,1:end);
end




largerrotLetterfour=largerBlankimage;

border_two_rot =round(largrotrw-rotrwiv)/2;
border_one_rot=border_two_rot+1;

try
largerrotLetterfour(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetterfour(1:end,1:end);
end

try
largerrotLetterfour(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetterfour(1:end,1:end);

end

try
largerrotLetterfour(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterfour(1:end,1:end);
end


clear largerimaj

largerimaj(:,:,1)=largerrotLetterone;
largerimaj(:,:,2)=largerrotLettertwo;
largerimaj(:,:,3)=largerrotLetterthree;
largerimaj(:,:,4)=largerrotLetterfour;
largerout = imtile(largerimaj,'Frames', 1:4, 'GridSize', [2 2]);

    

theLetter=imread([theFolder 'newletterc22.tiff']);
theLetter=theLetter(:,:,1);
theLetter=imresize(theLetter,[nrw nrw],'bicubic');


theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
rotLetterone=imrotate(theLetter,thesetTgt(1));
rotLetterone(rotLetterone==0)=127;
[rotrwi, rotcli]=size(rotLetterone);

rotLettertwo=imrotate(theLetter,thesetTgt(2));
rotLettertwo(rotLettertwo==0)=127;
[rotrwii, rotclii]=size(rotLettertwo);

rotLetterthree=imrotate(theLetter,thesetTgt(3));
rotLetterthree(rotLetterthree==0)=127;
[rotrwiii, rotcliii]=size(rotLetterthree);

rotLetterfour=imrotate(theLetter,thesetTgt(4));
rotLetterfour(rotLetterfour==0)=127;
[rotrwiv, rotcliv]=size(rotLetterfour);

thesizes= [rotrwi rotrwii rotrwiii rotrwiv];

thisize=max(thesizes)

blankimage = ones(thisize,thisize)*bg_index;
largerBlankimage=ones(thisize+separation,thisize+separation)*bg_index;

border_two=round(((thisize+separation)-nrw)/2);
border_one=border_two+1;

[largrotrw, largrotcl]=size(largerBlankimage);

TlargerrotLetterone=largerBlankimage;

border_two_rot =round(largrotrw-rotrwi)/2;
border_one_rot=border_two_rot+1;

try
    TlargerrotLetterone(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetterone(1:end,1:end);
end

try
    TlargerrotLetterone(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetterone(1:end,1:end);
end

try
    TlargerrotLetterone(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterone(1:end,1:end);
end

TlargerrotLettertwo=largerBlankimage;

border_two_rot =round(largrotrw-rotrwii)/2;
border_one_rot=border_two_rot+1;

try
TlargerrotLettertwo(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLettertwo(1:end,1:end);
end

try
    TlargerrotLettertwo(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLettertwo(1:end,1:end);

end

try
TlargerrotLetterone(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterone(1:end,1:end);
end


TlargerrotLetterthree=largerBlankimage;

border_two_rot =round(largrotrw-rotrwiii)/2;
border_one_rot=border_two_rot+1;

try
TlargerrotLetterthree(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetterthree(1:end,1:end);
end

try
 TlargerrotLetterthree(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetterthree(1:end,1:end);
end

try
TlargerrotLetterthree(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterthree(1:end,1:end);
end


TlargerrotLetterfour=largerBlankimage;

border_two_rot =round(largrotrw-rotrwiv)/2;
border_one_rot=border_two_rot+1;

try
TlargerrotLetterfour(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetterfour(1:end,1:end);
end

try
TlargerrotLetterfour(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetterfour(1:end,1:end);

end

try
TlargerrotLetterfour(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterfour(1:end,1:end);
end


    clear largerimaj2
    
    largerimaj2(:,:,1)=TlargerrotLetterone;
largerimaj2(:,:,2)=TlargerrotLettertwo;
largerimaj2(:,:,3)=TlargerrotLetterthree;
largerimaj2(:,:,4)=TlargerrotLetterfour;
    largerout2 = imtile(largerimaj2,'Frames', 1:4, 'GridSize', [2 2]);

theTargets{i}=Screen('MakeTexture', w, largerout2);
theOthers{i}=Screen('MakeTexture', w, largerout);


end
    %%
    
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
    
   
    RespType(1) = KbName('p');
    RespType(2) = KbName('a');
 
 
        
   
    
    %ims=17.5*pix_deg;
    ims=radius*pix_deg;
    [ax,ay]=meshgrid(-ims:ims,-ims:ims);
    e_X=-180;
e_XX =180;
e_Y=180;
    imageRect2 = CenterRect([0, 0, size(ax)/10], wRect);
    imRect_offs =[imageRect2(1)+e_X, imageRect2(2)+e_Y,...
        imageRect2(3)+e_X, imageRect2(4)+e_Y];
imRect_offs2 =[imageRect2(1)+e_XX, imageRect2(2)+e_Y,...
        imageRect2(3)+e_XX, imageRect2(4)+e_Y];
    
%     Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
%     Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
%     Screen('Flip', w);
%     KbWait;
    
    
    
    %%

DrawFormattedText(w, 'report whether the odd element is (p)resent or (a)bsent \n \n by pressing the corresponding key \n \n \n \n Press any key to start', 'center', 'center', white);
        Screen('Flip', w);
    KbWait;
  %  Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
  %  Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
  
  
%   DrawFormattedText(w, 'Press ' , imRect_offs(1)-20, imRect_offs(2)-80, white);
% DrawFormattedText(w, 'Press h' , imRect_offs2(1)-20, imRect_offs2(2)-80, white);
% 
% 
% Screen('DrawTexture',w,Happyface,[],imRect_offs2);%
% Screen('DrawTexture',w,Sadface,[],imRect_offs);%
%   
%   
%   
  
  
  
%     Screen('Flip', w);
%     WaitSecs(1.5);
%       KbWait;
    Screen('Flip', w);
    %possible orientations

    
    % check EyeTracker status
    if EyeTracker == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        % mark zero-plot time in data file
        Eyelink('message' , 'SYNCTIME');
        
      %  location =  zeros(length(mixtr), 6);
    end
    
    
    waittime=ifi*50;
    
    %scotomadeg=14;
    
    scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg_vert]
   
     [xc, yc] = RectCenter(wRect); % coordinate del centro schermo
    scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
    xeye=[];
    yeye=[];
 %   pupils=[];
    VBL_Timestamp=[];
    stimonset=[ ];
    fliptime=[ ];
    mss=[ ];
    scotoma_color=[200 200 200];
      %  scotoma_color=[100 100 100];
      fixat=1;
fixationlength = 40; % pixels    

if inductionType ==1
PRLxx=[0 7.5 0 -7.5];
PRLyy=[-7.5 0 7.5 0 ];
PRLxx=[0 2 0 -2];
PRLyy=[-2 0 2 0 ];
else
PRLxx=0;
PRLyy=0;
end

angolo=pi/2;
 %angolo=0; 

 for ui=1:length(PRLxx)
 [theta,rho] = cart2pol(PRLxx(ui), PRLyy(ui));
 ecc_r=rho;
 ecc_t=theta+angolo;
 cs= [cos(ecc_t), sin(ecc_t)];
 xxyy=[ecc_r ecc_r].*cs;
 PRLx(ui)=xxyy(1);
 PRLy(ui)=xxyy(2);
 clear xxyy
end
 
 
PRLxpix=PRLx*pix_deg;
%PRLxpix=PRLxpix(1);
PRLypix=PRLy*pix_deg_vert;
%PRLypix=PRLypix(1);

fixwindow=2;
fixTime=0.5;
fixTime2=0.5;

fixwindowPix=fixwindow*pix_deg;

radius = scotomasize(1)/2; %radius of circular mask
  %    smallradius=(scotomasize(1)/2)+1.5*pix_deg;
      
     % smallradius=radius+pix_deg/2 %+1*pix_deg;
     

      %[sx,sy]=meshgrid(-wRect(4)/2:wRect(4)/2,-wRect(3)/2:wRect(3)/2);
      [sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);
      
      
      if inductionType == 1 % 1 = assigned, 2 = annulus
           radius=2.5*pix_deg;
      circlePixels=sx.^2 + sy.^2 <= radius.^2;
      else
             
      
      smallradius=radius %+pix_deg/2 %+1*pix_deg;
      radius=radius+3*pix_deg;
     
      circlePixels=sx.^2 + sy.^2 <= radius.^2;
      circlePixels2=sx.^2 + sy.^2 <= smallradius.^2;

      d=(circlePixels2==1);
      newfig=circlePixels;
      newfig(d==1)=0;
      circlePixels=newfig;       
          
end

    
      counteremojisize=0;
    for trial=1:length(mixtr)
        
        
            TrialNum = strcat('Trial',num2str(trial));

            

            distnum = Distlist(thresh(mixtr(trial,1),mixtr(trial,2)));


        
clear EyeData
clear FixIndex
        xeye=[];
        yeye=[];
        pupils=[];
        VBL_Timestamp=[];
        stimonset=[ ];
        fliptime=[ ];
        mss=[ ];
    %    tracktime=[];
        FixCount=0;
        FixatingNow=0;
        EndIndex=0;  % is it correct? aslo check driftcorr--where is it
                  fixating=0;
                  counter=0;
framecounter=0;
x=0;
y=0;
area_eye=0;
xeye2=[];
yeye2=[];
mostratarget=0;
countertarget=0;
oval_thick=5;
cue_sizex=radius+1.5*pix_deg;
cue_sizey=(radius/pix_deg)*1.5*pix_deg_vert;

cue_sizex=radius*2;
cue_sizey=((radius/pix_deg)*pix_deg_vert)*2;

    imageRectcue = CenterRect([0, 0, [cue_sizex cue_sizey]], wRect);
                  
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

        if trial==1;         
          eyetime2=0;
        end;

        
        
        %randomize (or not) the position of the stimuli along x and y axes
%         if randomizzato==1;
%             ecc_r=r_lim.*rand(1,1);
%             ecc_t=2*pi*rand(1,1);
%             cs= [cos(ecc_t), sin(ecc_t)];
%             xxyy=[ecc_r ecc_r].*cs;
%             ecc_x=xxyy(1);
%             ecc_y=xxyy(2);
%             if distnum>110
%                 for gh=1:distnum
%                     ecc_rd=r_lim.*rand(1,1);
%                     ecc_td=2*pi*rand(1,1);
%                     cs= [cos(ecc_td), sin(ecc_td)];
%                     xxyyd=[ecc_rd ecc_rd].*cs;                  
%                     if xxyyd(1)-ecc_x<(poknrw/pix_deg)                   
%                         xxyyd(1)=xxyyd(1)+(poknrw/pix_deg)                        
%                     else
%                     ecc_xd(gh)=xxyyd(1);
%                     end                    
%                     if xxyyd(2)-ecc_x<(poknrw/pix_deg)
%                         xxyyd(2)==xxyyd(2)+(poknrw/pix_deg)
%                     else
%                     ecc_yd(gh)=xxyyd(2);
%                     end
%                 end
%             end
%         else
%             ecc_x=0;
%             ecc_y=0;
%         end;






if randomposition == 1
posmatrix=[1:4; 1:4]';
positionmatrix=assignedpositionmatrix;

        tgtpos=randi(length(posmatrix));
        ecc_x=positionmatrix(posmatrix(tgtpos,1),1);
        ecc_y=positionmatrix(posmatrix(tgtpos,2),2);  
else
    
        tgtpos=randi(length(posmatrix));
        ecc_x=positionmatrix(posmatrix(tgtpos,1));
        ecc_y=positionmatrix(posmatrix(tgtpos,2));  
end

        newpos=posmatrix;
        newpos(tgtpos,:)=[];
        
                    if distnum>110
                for gh=1:distnum                                     
                    distpos(gh)=randi(length(newpos));                  
                    ecc_xd(gh)=positionmatrix(newpos(distpos(gh),1));
                    ecc_yd(gh)=positionmatrix(newpos(distpos(gh),2));
                    newpos(distpos(gh),:)=[];                    
                end
            end
                                    
        %generate visual cue
        eccentricity_X=ecc_x*pix_deg;
        eccentricity_Y=ecc_y*pix_deg_vert;
     %   imageRect = CenterRect([0, 0, size(x)], wRect);
     
     
     

%      aux=1;
%      aux2=2;
if totalelements == 3
targetlocation(trial)=randi(3); %generates answer for this trial
elseif totalelements == 4
    targetlocation(trial)=randi(4); %generates answer for this trial
end
   
        
        if randomposition == 1
                            
                    target_ecc_x=positionmatrix(posmatrix(targetlocation(trial)),1);
        target_ecc_y=positionmatrix(posmatrix(targetlocation(trial)),2);
        
        newnewpos=posmatrix;
        newnewpos(targetlocation(trial),:)=[];
            
            for gg=1:(totalelements-1)                                     
                    newdistpos(gg)=randi(length(newnewpos(:,1)));                  
                    newecc_xd(gg)=positionmatrix(newnewpos(newdistpos(gg)),1);
                    newecc_yd(gg)=positionmatrix(newnewpos(newdistpos(gg)),2);
                    newnewpos(newdistpos(gg),:)=[];                    
                end    
        else
            
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
     
        end
     
        neweccentricity_X=target_ecc_x*pix_deg;
        neweccentricity_Y=target_ecc_y*pix_deg_vert;
        
                imageRect = CenterRect([0, 0, [poknrw poknrw]], wRect);
        
        imageRect_offs =[imageRect(1)+neweccentricity_X, imageRect(2)+neweccentricity_Y,...
            imageRect(3)+neweccentricity_X, imageRect(4)+neweccentricity_Y];
        
        
       for gg = 1:totalelements-1 
                      neweccentricity_Xd(gg)=newecc_xd(gg)*pix_deg;
        neweccentricity_Yd(gg)=newecc_yd(gg)*pix_deg_vert;         
           imageRect_offsDist{gg}= [imageRect(1)+neweccentricity_Xd(gg), imageRect(2)+neweccentricity_Yd(gg),...
            imageRect(3)+neweccentricity_Xd(gg), imageRect(4)+neweccentricity_Yd(gg)]; 
circlefix2(gg)=0;
    end
         if distnum>110
                for gh=1:distnum
                     eccentricity_Xd(gh)=ecc_xd(gh)*pix_deg;
        eccentricity_Yd(gh)=ecc_yd(gh)*pix_deg_vert;                      
        imageRect_offsd{gh} =[imageRect(1)+eccentricity_Xd(gh), imageRect(2)+eccentricity_Yd(gh),...
            imageRect(3)+eccentricity_Xd(gh), imageRect(4)+eccentricity_Yd(gh)];     
        circlefix22(gh)=0;
                end
            end
        
        
        audiocue2 %generates audio cue
        

%type of target
theTarget(trial) = randi(length(theTargets));
texture(trial)=theTargets{theTarget(trial)};


theans(trial)=randi(2); %generates answer for this trial
if theans(trial)==1 %present
disTexture(trial)=theOthers{theTarget(trial)};
else % absent
    disTexture(trial)=texture(trial);
end
 

Priority(1);
        eyechecked=0;
        KbQueueFlush();
%        trial_time = GetSecs;
         stopchecking=-100;
      %  EyeData=9999;
        trial_time=100000;
        
        
        pretrial_time=GetSecs;
        stimpresent=0;
        circlefix=0;
        while eyechecked<1

            
              if (eyetime2-pretrial_time)>ifi*35 && (eyetime2-pretrial_time)<ifi*75 && fixating<fixTime/ifi && stopchecking>1
      fixationscript2
      for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
  elseif  (eyetime2-pretrial_time)>=ifi*75 && fixating<fixTime/ifi && stopchecking>1
     for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
    IsFixating4
      fixationscript2
  elseif (eyetime2-pretrial_time)>ifi*75 && fixating>=fixTime/ifi && fixating<1000 && stopchecking>1
      trial_time = GetSecs;
      fixating=1500;
for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
              end
            if (eyetime2-trial_time)>=0 && (eyetime2-trial_time)<waittime+ifi*2 && fixating>400 && stopchecking>1              
for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end              
            end
            
            
%            if eyetime2>waittime && eyetime2<waittime+ifi
            if (eyetime2-trial_time)>=waittime+ifi*2 && (eyetime2-trial_time)<waittime+ifi*4 && fixating>400 && stopchecking>1
%                 if fixat==1;
% 
%                     Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
%                     Screen('DrawLine', w, colorfixation,
%                     wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
%                 end
for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
    %here i present the stimuli+acoustic cue
            elseif (eyetime2-trial_time)>waittime+ifi*4 && (eyetime2-trial_time)<waittime+ifi*6 && fixating>400 && stopchecking>1 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0 %present pre-stimulus and stimulus

                %  cueonset=GetSecs                
                
                vbl=GetSecs
                cueontime=vbl + (ifi * 0.5);
                        PsychPortAudio('Start', pahandle,1,inf); %starts sound at infinity
                PsychPortAudio('RescheduleStart', pahandle, cueontime, 0) %reschedules startime to

                
                %Draw Target
                Screen('DrawTexture', w, texture(trial), [], imageRect_offs );
                
                for ui = 1:totalelements-1
                    Screen('DrawTexture', w, disTexture(trial), [], imageRect_offsDist{ui} );
                end

                if distnum>110
                    for gh=1:distnum
                        Screen('DrawTexture', w, Distractorface, [], imageRect_offsd{gh});                                                                                                
                    end 
                end
                    
                stim_start=GetSecs; 
                       stimpresent=1111;
for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end                  
            elseif (eyetime2-trial_time)>=waittime+ifi*6 && fixating>400 && stopchecking>1 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0 %present pre-stimulus and stimulus
          %       toc
           %     disp('stimulus')
  if exist('stim_start')==0
           stim_start = GetSecs;
  end
              stimpresent=1111;
                Screen('DrawTexture', w, texture(trial), [], imageRect_offs );
                                                
                for ui = 1:totalelements-1
                    Screen('DrawTexture', w, disTexture(trial), [], imageRect_offsDist{ui} );
                end
                                if distnum>110
                    for gh=1:distnum
                        Screen('DrawTexture', w, Distractorface, [], imageRect_offsd{gh});                                                                                                
                    end
                                end
                                                                 
            elseif (eyetime2-trial_time)>=waittime+ifi*7 && fixating>400 && stopchecking>1 && keyCode(RespType(1)) + keyCode(RespType(2))  + keyCode(escapeKey)~= 0 && mostratarget>10 % wait for response               
            %    tic
            %     toc
             %   disp('afterkeypress')
                stim_stop=GetSecs;
                thekeys = find(keyCode);
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);                                         
                eyechecked=1111111111;
                cicci=100;
                                    % code the response            
                elseif (eyetime2-trial_time)>=waittime+ifi*8 && fixating>400 && stopchecking>1 && keyCode(escapeKey)~= 0 % wait for response               
                                 stim_stop=GetSecs;
                thekeys = find(keyCode);
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);                                         
                eyechecked=1111111111;
                                    
          %    toc
           %   disp('noise')
            end
            eyefixation3
            

            if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                Screen('FillRect', w, gray);
            else

                if  stimpresent>0
% here to force fixations with the PRL
                 for aux= 1:length(PRLxpix)
                     
                     for aup= 1:length(PRLxpix)
                         if round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aup))<=size(circlePixels,1) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix(aup))<=size(circlePixels,2) ...
                          &&  round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aup))> 0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix(aup))> 0;
                                 
                             
                             codey(aup)=round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aup));
                             codex(aup)=round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix(aup));
                             activePRLT(aup) =1;
                         else
                             codey(aup)= round(1025/2); %round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aup));
                             codex(aup)= round(1281/2);%round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix(aup));
                             activePRLT(aup) = 0;
                             
                         end
                     end
                   
                     if  stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux))<wRect(4) && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux))>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux)))<wRect(3) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux)))>0
                        %              if  sum(circlePixels(round(wRect(3)/2+(abs(newsamplex-(wRect(3)/2+eccentricity_X)),:))<1 && ...
                        %                          sum(circlePixels(:,round(wRect(4)/2+(abs(newsampley-(wRect(4)/2+eccentricity_Y)))))<1
                    %    if       sum(circlePixels(round(wRect(3)/2+(abs(newsamplex-(wRect(3)/2+eccentricity_X)))),:))<1 && sum(circlePixels(:,round(wRect(4)/2+(abs(newsampley-(wRect(4)/2+eccentricity_Y))))))<1
                            %  Screen('FrameOval', w,[ 255 0 0], imageRect_offs, oval_thick, oval_thick);
                     %   if       circlePixels(round(wRect(3)/2+(abs(newsamplex-(wRect(3)/2+eccentricity_X)))),round(wRect(4)/2+(abs(newsampley-(wRect(4)/2+eccentricity_Y)))))<1 
                  
                                    if   circlePixels(codey(1), codex(1))<0.81 && circlePixels(codey(2), codex(2))<0.81 && circlePixels(codey(3), codex(3))<0.81 ...
                                       && circlePixels(codey(4), codex(4))<0.81
                                       

     % 
                     Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                                   %  Screen('DrawTexture', w, texture(trial), [], imageRect_offs );

for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
    %                            Screen('FillOval', w, [255 0 0], imageRect_offs);

                            circlefix=0;                           
                            
                             else
                                if  exist('EyeCode','var')
                                    if length(EyeCode)>6 %&& circlefix>6
                                     circlefix=circlefix+1;
                            % if  EyeCode(end-1)~=0 && EyeCode(end)~=0
                            if sum(EyeCode(end-6:end))~=0
                             %   circlefix2(gh)=circlefix2(gh)+1;
                              %  if circlefix2(gh)<5
                            Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                            for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
    %     elseif EyeCode(end-1)==0 && EyeCode(end)==0
                            elseif sum(EyeCode(end-5:end))==0  
%mostra target
                                                                     
                                                                     countertarget=countertarget+1
                                                                     framefix(countertarget)=length(EyeData(:,1));
                                                                     if exist('FixIndex','var')
                                                                     fixind(countertarget)=FixIndex(end,1);
                                                                     end
                                                                     mostratarget=100;
                                                                     timeprevioustarget(countertarget)=GetSecs;
                                    % circlefix=circlefix+1;
                             end
                                elseif length(EyeCode)<=5 %&& circlefix<=6
                            Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                            for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
    circlefix=circlefix+1;
                                                         elseif length(EyeCode)>5 %&& circlefix<=6
                            Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                        for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
    circlefix=circlefix+1;
                                    end
                                end
                                    end
                  

                    elseif stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux))>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux))<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux)))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux)))<0 %...
                         %  || round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux2))>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux2))<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux2)))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux2)))<0


                        %  Screen('FrameOval', w,[ 255 0 0], imageRect_offs, oval_thick, oval_thick);
                                                    circlefix=0;
                        Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                        for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
                    end
                end                        
            for gg=1:totalelements-1
                
                
                
                for aux=1:length(PRLxpix)
                   for uso= 1:totalelements-1
                                         for aup= 1:length(PRLxpix)
                         if round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(uso)))+PRLypix(aup))<=size(circlePixels,1) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(uso)))+PRLxpix(aup))<=size(circlePixels,2) ...
                           &&  round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(uso)))+PRLypix(aup))> 0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(uso)))+PRLxpix(aup))> 0;
                                 
                             
                             coodey(uso,aup)=round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(uso)))+PRLypix(aup));
                             coodex(uso,aup)=round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(uso)))+PRLxpix(aup));
                             activePRL(uso,aup) =1;
                         else
                             coodey(uso,aup)= round(1025/2); %round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aup));
                             coodex(uso,aup)= round(1281/2);%round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix(aup));
                             activePRL(uso,aup) = 0;
                             
                         end
                                         end
                    
                end
                     
                                         
                                           
                                         
                                         
                                         
                    
if stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux))<wRect(4) && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux))>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux)))<wRect(3) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux)))>0 %|| ...
      %  (round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux2))<wRect(4) && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux2))>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux2)))<wRect(3) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux2)))>0))
        

                         %   if       sum(circlePixels(round(wRect(3)/2+(abs(newsamplex-(wRect(3)/2+eccentricity_Xd(gh))))),:))<1 || sum(circlePixels(:,round(wRect(4)/2+(abs(newsampley-(wRect(4)/2+eccentricity_Yd(gh)))))))<1
                      %   if       circlePixels(round(wRect(3)/2+(abs(newsamplex-(wRect(3)/2+eccentricity_Xd(gh))))),round(wRect(4)/2+(abs(newsampley-(wRect(4)/2+eccentricity_Yd(gh))))))<1 
                        
                           %  if circlePixels(round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux)), round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg)))+PRLxpix(aux)))<1
                                   if   circlePixels(coodey(gg,1), coodex(gg,1))<0.81 && circlePixels(coodey(gg,2), coodex(gg,2))<0.81 && circlePixels(coodey(gg,3), coodex(gg,3))<0.81 ...
                                           && circlePixels(coodey(gg,4), coodex(gg,4))<0.81 %...
                                      % && circlePixels(coodey(1,4), coodex(1,4))<0.81 && circlePixels(coodey(2,1), coodex(2,1))<0.81 && circlePixels(coodey(2,2), coodex(2,2))<0.81 && circlePixels(coodey(2,3), coodex(2,3))<0.81 ...
                                      % && circlePixels(coodey(2,4), coodex(2,4))<0.81 && circlePixels(coodey(3,1), coodex(3,1))<0.81 && circlePixels(coodey(3,2), coodex(3,2))<0.81 && circlePixels(coodey(3,3), coodex(3,3))<0.81 ...
                                      % && circlePixels(coodey(3,4), coodex(3,4))<0.81 
                                                 
                             Screen('DrawTexture', w, Neutralface, [], imageRect_offsDist{gg});  %eccentricity_Xd(gh)
                          for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
    circlefix2(gg)=0;
                         else
                                if  exist('EyeCode','var')
                                   %     circlefix2(gg)=0;
                                    if length(EyeCode)>5 && circlefix2(gg)>5
                                circlefix2(gg)=circlefix2(gg)+1;
                            % if  EyeCode(end-1)~=0 && EyeCode(end)~=0
                             if sum(EyeCode(end-5:end))~=0                          
                                circlefix2(gg)=circlefix2(gg)+1;
                            Screen('DrawTexture', w, Neutralface, [], imageRect_offsDist{gg});
                           for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
    % elseif EyeCode(end-1)==0 && EyeCode(end)==0
                             elseif   sum(EyeCode(end-5:end))==0  
                                                                     %mostra target
                             end
                                elseif length(EyeCode)<5 && circlefix2(gg)<=5
                           Screen('DrawTexture', w, Neutralface, [], imageRect_offsDist{gg});
                         for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
    circlefix2(gg)=circlefix2(gg)+1;
                                elseif length(EyeCode)>5 && circlefix2(gg)<=5
                           Screen('DrawTexture', w, Neutralface, [], imageRect_offsDist{gg});
                                circlefix2(gg)=circlefix2(gg)+1;
                               for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
                                    end
                         end
                            end                                                      
                        elseif stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux))>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux))<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux)))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux)))<0  %|| ...
                    %    round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux2))>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux2))<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux2)))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux2)))<0
                            
                            
                            Screen('DrawTexture', w, Neutralface, [], imageRect_offsDist{gg});  %eccentricity_Xd(gh)
                                                        circlefix2(gg)=0;
                                                        for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
end
            end
                end
       
                  
                if distnum>110 && stimpresent>0
                    for gh=1:distnum
if stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+eccentricity_Yd(gh)))+PRLypix(aux))<wRect(4) && round(wRect(4)/2+(newsampley-(wRect(4)/2+eccentricity_Yd(gh)))+PRLypix(aux))>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+eccentricity_Xd(gh))+PRLxpix(aux)))<wRect(3) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+eccentricity_Xd(gh))+PRLxpix(aux)))>0

                         %   if       sum(circlePixels(round(wRect(3)/2+(abs(newsamplex-(wRect(3)/2+eccentricity_Xd(gh))))),:))<1 || sum(circlePixels(:,round(wRect(4)/2+(abs(newsampley-(wRect(4)/2+eccentricity_Yd(gh)))))))<1
                      %   if       circlePixels(round(wRect(3)/2+(abs(newsamplex-(wRect(3)/2+eccentricity_Xd(gh))))),round(wRect(4)/2+(abs(newsampley-(wRect(4)/2+eccentricity_Yd(gh))))))<1 
                        
                             if circlePixels(round(wRect(4)/2+(newsampley-(wRect(4)/2+eccentricity_Yd(gh)))+PRLypix(aux)), round(wRect(3)/2+(newsamplex-(wRect(3)/2+eccentricity_Xd(gh)))+PRLxpix(aux)))<1
                     
                             
                             Screen('DrawTexture', w, Neutralface, [], imageRect_offsd{gh});  %eccentricity_Xd(gh)
                            for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
    circlefix22(gh)=0;
                         else
                                if  exist('EyeCode','var')
                                    if length(EyeCode)>5 && circlefix22(gh)>5
                                circlefix22(gh)=circlefix22(gh)+1;
                            % if  EyeCode(end-1)~=0 && EyeCode(end)~=0
                             if sum(EyeCode(end-5:end))~=0                          
                                circlefix22(gh)=circlefix2(gh)+1;
                           Screen('DrawTexture', w, Neutralface, [], imageRect_offsd{gh});
%                            imageRect_offscue=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix, imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix,...
%        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix, imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix];
%    Screen('FrameOval', w,200, imageRect_offscue, oval_thick, oval_thick);    
                               % elseif EyeCode(end-1)==0 && EyeCode(end)==0
                             elseif   sum(EyeCode(end-5:end))==0  
                                                                     %mostra target

                             end
                                elseif length(EyeCode)<5 && circlefix22(gh)<=5
                           Screen('DrawTexture', w, Neutralface, [], imageRect_offsd{gh});
%                            imageRect_offscue=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix, imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix,...
%        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix, imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix];
%    Screen('FrameOval', w,200, imageRect_offscue, oval_thick, oval_thick);     
                                circlefix22(gh)=circlefix22(gh)+1;
                                elseif length(EyeCode)>5 && circlefix22(gh)<=5
                            Screen('DrawTexture', w, Neutralface, [], imageRect_offsd{gh});
                                circlefix2(gh)=circlefix22(gh)+1;
%                                imageRect_offscue=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix, imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix,...
%        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix, imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix];
%    Screen('FrameOval', w,200, imageRect_offscue, oval_thick, oval_thick);    
                                end
                         end
                            end                                                      
                        elseif stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+eccentricity_Yd(gh)))+PRLypix(aux))>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+eccentricity_Yd(gh)))+PRLypix(aux))<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+eccentricity_Xd(gh))+PRLxpix(aux)))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+eccentricity_Xd(gh))+PRLxpix(aux)))<0
 Screen('DrawTexture', w, Neutralface, [], imageRect_offsd{gh});  %eccentricity_Xd(gh)
                                                        circlefix22(gh)=0;
                                                     for iu=1:length(PRLx)
    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
    if visibleCircle ==1
        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
    end
              end
end
                    end


                end%   Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                end
                Screen('FillOval', w, scotoma_color, scotoma);
            end


            %    save time and other stuff from flip    equal Screen('Flip', w,vbl plus desired time half of framerate);
        %    [eyetime, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w, eyetime-(ifi * 0.5));
      
        [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);



            VBL_Timestamp=[VBL_Timestamp eyetime2];
        %    stimonset=[stimonset StimulusOnsetTime];
        %    fliptime=[fliptime FlipTimestamp];
      %      mss=[mss Missed];
      
      if eyeOrtrack==1
      
          GetEyeTrackerData
          if ~exist('EyeData','var')
              EyeData = ones(1,5)*9001;
          end
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
        
      end
            [keyIsDown, keyCode] = KbQueueCheck;
           %  toc
            %    disp('fine')
        end
        
        
            foo=(RespType==thekeys);


    
    staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
    Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=distnum;
        
        
        if foo(theans(trial))
        resp = 1;
                                    PsychPortAudio('Start', pahandle1);
                                    
           if stim_stop - stim_start<5   
               respTime=1;
        corrcounter(mixtr(trial,1),mixtr(trial,2))=corrcounter(mixtr(trial,1),mixtr(trial,2))+1;

        if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
                    corrcounter(mixtr(trial,1),mixtr(trial,2))=0;
            if isreversals(mixtr(trial,1),mixtr(trial,2))==1
                reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
                isreversals(mixtr(trial,1),mixtr(trial,2))=0;
            end
            thestep=min(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
            if thestep>5 %Doesn't this negate the step size of 8 in the step size list? --Denton
                thestep=5;
            end;                     
            thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) +stepsizes(thestep);
            thresh(mixtr(trial,1),mixtr(trial,2))=min( thresh(mixtr(trial,1),mixtr(trial,2)),length(Distlist));
            
        end
            
                  if  distnum==15
                counteremojisize=counteremojisize+1;
                if counteremojisize==3
                    counteremojisize=0
         poknrw=poknrw*.9
                end               
      elseif distnum<7
          counteremojisize=0;
          poknrw=imsize
                  end
      
                  
 
           else
               respTime=0;
               counteremojisize=0;
        
           end
        
        
    elseif (thekeys==escapeKey) % esc pressed
        closescript = 1;
        break;
    else
        resp = 0;
        respTime=0;
                                    PsychPortAudio('Start', pahandle2);
                                    
        if  corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
            isreversals(mixtr(trial,1),mixtr(trial,2))=1;
        end
        corrcounter(mixtr(trial,1),mixtr(trial,2))=0;

        thestep=max(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
              if thestep>5
                thestep=5;
        end;        
        thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
        thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)),1);
    end
        


  
        
           
      %  stim_stop=secs;
        time_stim(kk) = stim_stop - stim_start;
        totale_trials(kk)=trial;
   %     coordinate(trial).x=ecc_x;
    %    coordinate(trial).y=ecc_y;
    rispoTotal(kk)=resp;
    rispoInTime(kk)=respTime;
    distraktor(trial)=distnum;
    xxeye(trial).ics=[xeye];
    yyeye(trial).ipsi=[yeye];
    vbltimestamp(trial).ix=[VBL_Timestamp];
   % answer(trial)=theans %1 = present
    TGT_loc(trial)=targetlocation(trial);
    TGT_x(trial)=target_ecc_x;
    TGT_y(trial)=target_ecc_y;

          tutti{trial} =imageRect_offs;
          
          
 %   flipptime(trial).ix=[fliptime];
        if eyeOrtrack==1
    %        ppupils(trial).xx=[pupils];
       %     ttrackertime(trial).xx=[tracktime];
%           EyeSummary.(trial).Trial = trial;


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
               
               if exist('ecc_xd')==1
                   EyeSummary.(TrialNum).DistX=ecc_xd;
                   EyeSummary.(TrialNum).DistY=ecc_yd;
                   EyeSummary.(TrialNum).Distnum=gh
               end;
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
     EyeSummary.(TrialNum).StimulusSize=poknrw;
               EyeSummary.(TrialNum).Target.App = mostratarget;
                         EyeSummary.(TrialNum).Target.counter=countertarget;
                         EyeSummary.(TrialNum).Target.FixInd=fixind;
                     EyeSummary.(TrialNum).Target.Fixframe=framefix;
         EyeSummary.(TrialNum).PRL.x=PRLx;
                  EyeSummary.(TrialNum).PRL.y=PRLy;
                  EyeSummary.(TrialNum).targetlocation =targetlocation;
     %StimStamp(TrialCounter,1);
       clear ErrorInfo
   %    fliptime(trial)=[VBL_Timestamp];
        %thresharray(kk)=tresh;
        end

            
            kk=kk+1;
            
            
%             
%             if trial==100 | 200 | 300 | 400 | 500 | 600 | 700  
%             save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|ax|ay|xxx|yyyy|circle|azimuths|corrS|errorS|Allimg)$).');
%             end;
            
if (mod(trial,100))==1
    if trial==1
    else
save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    end
end
            
            
            
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
    if trial>1
    comparerisp=[rispoTotal' rispoInTime'];
    end
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
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
    %thresho=permute(Threshlist,[3 1 2]);
    
    %to get the final value for each staircase
  %  final_threshold=thresho(numel(thresho(:,:,1)),1:length(thresho(1,:,1)),1:length(thresho(1,1,:)));
    %total_thresh= [final_threshold(:,:,1) final_threshold(:,:,2)];
    %%
%    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|ax|ay|xxx|yyyy|circle|azimuths|corrS|errorS|Allimg)$).');
    
    
catch ME
    psychlasterror()
end