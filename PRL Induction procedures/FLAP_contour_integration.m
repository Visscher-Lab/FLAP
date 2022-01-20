% Contrast threshold measurement with randomized position of the target -
close all; clear all; clc;
commandwindow % drawgabor drawimage GenerateEnvelope GenerateTone imageproc immagini3 phase visualcue
shapeType=2; % 1 is S, 2 is open C, and 3 is closed C, 4 is dense closed
addJitter=1; %Add or remove both types of jitter (orientation and positional)

prompt={'Subject Name', 'Session', 'Site'};

name= 'Subject Name';
numlines=1;
defaultanswer={'test', '','a'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if isempty(answer)
    return;
end;
        addpath([cd '/utilities']);

SUBJECT = answer{1,:}; %Gets Subject Name
Session = answer{2,:}; %Gets Subject Name
station= answer{3,:}; % which testing site? 'r' is for Rutgers; 's' is for the Seitz lab, 'b' is for braingamecenter, 'a' is for alabama
expdayeye=Session;
%Timing Parameters and Gamma

if str2num(Session)==1
    SessionTime=10*60; % session time
elseif str2num(Session)==2
    SessionTime=15*60; % session time % why is it longer for posttest?
else
    SessionTime=20*60; % session time
end
ResponseTime=5; % response time
Gamma=1; %Gamma value. Normally 2.2, but set to 1 if using other tool  for linearlization
ExerTime=0 ; % If this is a 1 then break time will be ignored.
JitRat=1; % amount of jit ratio (the larger the value the less jitter)



c = clock; %Current date and time as date vector. [year month day hour minute seconds]
%create a folder if it doesn't exist already
if exist('data')==0
    mkdir('data')
end;
baseName=['./data/' SUBJECT '_' Session '_CI_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
Screen('Preference', 'SkipSyncTests', 1);
PC=getComputerName();
max_contrast=.8;
n_blocks=2;
reps=10;
if station=='s' %Seitz lab
    screencm=[24 18];
    struct.res=[1024 768];
    struct.sz=[screencm(1), screencm(2)];
    BITS=0; %0;
elseif station=='r' %Rutgers
    screencm=[59.7 33.6];
    struct.res=[2560 1440];
    struct.sz=[screencm(1), screencm(2)];
    BITS=0; %0;
elseif station=='b'
    screencm=[40.6 30];
    struct.res=[1280 960];
    struct.sz=[screencm(1), screencm(2)];
    BITS=0; %0;
elseif station == 'a'
    %this site uses a pc, so the filenames differ.
    baseName=[cd '\data\' SUBJECT '_' Session '_CI_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    screencm= [69.8 35.5];
    struct.res= [1920 1080]; %[3840 2160]; %[1920 1080];
    struct.sz=[screencm(1), screencm(2)];
    BITS=2; %0;
end

v_d=57;  % distance in cm to the screen [this is a guess. COMMENT YOUR CODE.]
sigma_deg = .1; %bpk: Gaussian envelope size?
sfs=6;
% BITS=0; %0; This is now set for 'station'
CircConts=1;
fixat=1;
SOA=.1;
closescript=0;
kk=1;


cuedir=.05;
stimdur=5;
oval_thick=10; %thickness of oval

% get keyboard for the key recording
device = -1; % reset to default keyboard
[k_id, k_name] = GetKeyboardIndices();
for i = 1:numel(k_id)
    if strcmp(k_name{i},'USB KEYBOARD') % unique for your device, check the [k_id, k_name]
        device =  k_id(i);
    elseif  strcmp(k_name{i},'Apple Internal Keyboard / Trackpad')
        device =  k_id(i);
    end
end
% device=3
KbQueueCreate(device);
KbQueueStart(device); % added device parameter

if ispc
    escapeKey = KbName('esc');	% quit key
elseif ismac
    escapeKey = KbName('ESCAPE');	% quit key
end
                       
                         eyeOrtrack=1; %0=mouse, 1=eyetracker
    
    if eyeOrtrack==1
        EyeTracker = 1; % set to 1 for UAB code testing
                        EyetrackerType=1;
                        
    elseif eyeOrtrack==0
                EyeTracker = 0; % set to 1 for UAB code testing
    end
fixat=1;
fixationlength = 40; % pixels    

red=[255 0 0];

fixwindow=2;
fixTime=0.2;
fixTime2=0.2;
                        
                        
if BITS==1 %bits ++
    %% psychtoobox settings
        screencm=[40.6 30];
    %load lut_12bits_pd; Disabled until display is calibrated
    AssertOpenGL;
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    %PsychGPUControl('SetDitheringEnabled', 0); Not supported on OSX
    screenNumber=max(Screen('Screens'));
    rand('twister', sum(100*clock));
    PsychImaging('PrepareConfiguration');   % tell PTB what modes we're using
    PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
    PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
    PsychImaging('AddTask', 'FinalFormatting','DisplayColorCorrection','LookupTable');
    PsychColorCorrection('SetLookupTable', window, lookup);
    %lut_12bits= repmat((linspace(0,1,4096).^(1/2.2))',1,3);
    %PsychColorCorrection('SetLookupTable', w, lut_12bits); --Denton-Disabled until calibration is done, moved to before OpenWindow, if initialized afterwards it won't have any effect until after the first flip
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
    %if you want to open a small window for debug
    %   [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
    %    Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
    %Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
elseif BITS==0
    %% psychtoobox settings
    AssertOpenGL;
    screenNumber=max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput'); %bot stea;omg
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
    %debug window
    %[w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640480],32,2);
    %ScreenParameters=Screen('Resolution', screenNumber); %close all
    %struct.res=[ScreenParameters.width ScreenParameters.height];
    %Nlinear_lut = repmat((linspace(0,1,256).^(1/Gamma))',1,3);
    %Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
elseif BITS==2
    v_d=57;
        AssertOpenGL;
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
        [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
end;
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

pix_deg = pi * wRect(3) / atan(screencm(1)/v_d/2) / 360; %pixperdegree
pix_deg_vert = pi * wRect(4) / atan(screencm(2)/v_d/2) / 360 %to calculate the limit of target position
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
       [errorS freq  ] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
        [corrS freq  ] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script

      
     if EyeTracker == 1
            
              useEyeTracker = 0; % otherwise will throw error if not UAB run
        
        %eyeTrackerBaseName=[SUBJECT '_DAY_' num2str(expday) '_CAT_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
        %eyeTrackerBaseName = 's00';
        eyeTrackerBaseName =[SUBJECT expdayeye];
        
      %  save_dir= 'C:\Users\labadmin\Desktop\marcello AMD assessment\7.Training\test_eyetracker_files';
                               
      
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
             
       if exist('dataeyet')==0
        mkdir('dataeyet')
    end;
    save_dir=[cd './dataeyet/']
                        
            % old variables
            [winCenter_x,winCenter_y]=RectCenter(wRect);
            backgroundEntry = [0.5 0.5 0.5];
            % height and width of the screen
            winWidth  = RectWidth(wRect);
            winHeight = RectHeight(wRect);
            
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
         %   Eyelink('command', 'calibration_type = HV5'); % changed to 5 to correct upper left corner of the screen issue
            % you must send this command with value NO for custom calibration
            % you must also reset it to YES for subsequent experiments
         %   Eyelink('command', 'generate_default_targets = NO');
            
            
            %% Modify target locations
            % due to issues with calibrating the upper left corner of the screen the following lines have been
            % commmented out to change the the sampling from 10 to 5 as
            % listed in line 323
            % Eyelink('command','calibration_samples = 10');
            % Eyelink('command','calibration_sequence = 0,1,2,3,4,5,6,7,8,9');
            
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
    

%% STAIRCASE
cndt=2;
ca=1;
thresh(1:cndt, 1:ca)=1;
% thresh(2, 1:ca)=25;
reversals(1:cndt, 1:ca)=0;
isreversals(1:cndt, 1:ca)=0;
%shouldn't 'thresh' start from 5 or 10 to allow for errors to move back along
%the fixedstepsizes?
staircounter(1:cndt, 1:ca)=0;
corrcounter(1:cndt, 1:ca)=0;
wrongcounter(1:cndt, 1:ca)=0;

% Threshold -> 79%
sc.up = 1;                          % # of incorrect answers to go one step up
sc.down = 3;                        % # of correct answers to go one step down

max_transp=0.3; %could be the same as max_contrast if the performance between faces and gabors are
%similar
nsteps=41;
Contlist = [1 1 1 max_contrast log_unit_down(max_contrast, 0.05, nsteps) 0 ];
JitList = 0:2:90;%[1 log_unit_down(1, 0.05, nsteps)]; % apparently different values from which to choose when going up or down within staircase

stepsizes=[8 4 3 2 1];

%% settings for individual gabors and fixation point
sigma_pix = sigma_deg*pix_deg;
imsize=sigma_pix*2.5;
[x0,y0]=meshgrid(-imsize:imsize,-imsize:imsize);
G = exp(-((x0/sigma_pix).^2)-((y0/sigma_pix).^2));
fixationlength = 10; % pixels
[r, c] = size(G);

%creating gabor images
rot=0*pi/180; %redundant but theoretically correct
maxcontrast=1; %same
for i=1:(length(sfs));  %bpk: note that sfs has only one element
    f_gabor=(sfs(i)/pix_deg)*2*pi;
    a=cos(rot)*f_gabor;
    b=sin(rot)*f_gabor;
    m=maxcontrast*sin(a*x0+b*y0+pi).*G;
    TheGabors(i)=Screen('MakeTexture', w, gray+inc*m,[],[],2);
end

%set the limit for stimuli position along x and y axis
xLim=((wRect(3)-(2*imsize))/pix_deg)/2; %bpk: this is in degrees
yLim=((wRect(4)-(2*imsize))/pix_deg_vert)/2;

bg_index =round(gray*255); %background color

%circular mask
xylim = imsize; %radius of circular mask
circle = x0.^2 + y0.^2 <= xylim^2;
[nrw, ncl]=size(x0);

%% main loop
HideCursor;
counter = 0;

% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
%     Screen('TextStyle', w, 1+2);
Screen('FillRect', w, gray);
colorfixation = white;
[xc, yc] = RectCenter(wRect); % coordinate del centro schermo

%possible orientations
% theoris=[22.5 67.5 -22.5 -67.5 ];
theoris=[22.5 45 -22.5 -45  ];

xs=12;
ys=9;
[x1,y1]=meshgrid(-xs:xs,-ys:ys); %possible positions of Gabors within grid; seem to be in degrees of visual angle

xlocs=x1(:)';
ylocs=y1(:)';

%generate visual cue
eccentricity_X=xlocs*pix_deg;
eccentricity_Y=ylocs*pix_deg;

imageRect = CenterRect([0, 0, size(x0)], wRect);
% These are the individual rectangles for each Gabor within the array
imageRect_offs =[imageRect(1)+eccentricity_X', imageRect(2)+eccentricity_Y',...
    imageRect(3)+eccentricity_X', imageRect(4)+eccentricity_Y'];

%x and y pixel values of Gabor relative to origin
Ex=eccentricity_X+wRect(3)/2;
Ey=eccentricity_Y+wRect(4)/2;

RespType(1) = KbName('LeftArrow');
RespType(2) = KbName('RightArrow');

AdjustType(1) = KbName('RightArrow');
AdjustType(2) = KbName('LeftArrow');
AdjustType(3) = KbName('UpArrow');
AdjustType(4) = KbName('DownArrow');
AdjustType(5) = KbName('a');
AdjustType(6) = KbName('s');
AdjustType(7) = KbName('Delete');
AdjustType(8) = KbName('Space');
Return=KbName('Return');
%mixtr=randi(2,100,2);

mixtr=randi(2,[100 2])

lr=2;
cc=3;
tr=5;

%stmloc cueloc
trmat1=[repmat([1],1,2*tr)' repmat(ceil((1:lr)),1, tr)'];
trmat2=[repmat(2:lr +1,1,cc*tr)' repmat(ceil((1:(cc*lr))/lr),1, tr)'];

mixtr = [trmat1(randperm(length(trmat1)),:) ; trmat2(randperm(length(trmat2)),:)] ;
blocksize=length(mixtr)/4; % stimulus presentations per block
response=zeros(length(mixtr),2)-1; %intialize response matrix with -1

% - - \
%     |
% / x /
% |
% \ - -
%
% / - -
% |
% \ x \
%     |
% - - /

%    _
%  /   \
%
% |  x  |
%
%  \   /
%    _


fid = fopen( [SUBJECT '.txt'],'r+');

if (fid==-1)
    nElem=max(24 -floor(str2num(Session)/3),12); % number of elements in *completed* circular shape
else
    nElem = fscanf(fid,'%d');
fclose(fid)
end


nElemStart=nElem;
%show left or right half of circle
% nElem=max(24 -floor(str2num(Session)/2),12); % number of elements in *completed* circular shape

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
    

numblock=6;
blocksize=50; % stimulus presentations per block
numtrial=blocksize*numblock;
Tscat=0;
GoodBlock=0;
Tc=1;


  eyetime2=0;
   % waittime=ifi*60;
   waittime=0;
  scotomadeg=10;
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


fixwindowPix=fixwindow*pix_deg;


SessStartTime=GetSecs;
for trial=1:numtrial
    
                        TrialNum = strcat('Trial',num2str(trial));
                        
    if   (mod(trial,blocksize)==1)
        Bt1=GetSecs;
        Screen('FillRect', w, gray);
        if trial>1
            x=sprintf('Great work, you have completed %d   minutes of training',floor((GetSecs-SessStartTime)/60 ));
            Screen('DrawText',w,x,100,100,[0 255 0]);
        end
        Ts=mod(floor((trial-1)/blocksize),2)+1;
        if Ts==2
            shapeType=1
            Targx=[0 1 2 2 2 1 0 0 0 1 0
                0 1 2 0 0 1 2 2 2 1 0];
            Targx=[-1 0 1  1  1 0 -1 -1 -1 0  1
                -1 0 1 -1 -1 0  1  1  1 0 -1];
            Targy=[-2 -2 -2 -1 0 0 0 1 2 2 2
                -2 -2 -2 -1 0 0 0 1 2 2 2];
            Targori=90+[0  0 45 90 135  0 135  90 45 0 0
                135 0 0   90 45 0 45 90 135  0 0];
                        thresh(Ts,Tc)=max(1,thresh(Ts,Tc)-5);

            DrawFormattedText(w, sprintf('You are now on Number Level %d \n \n \n Press the Left key when 2  \n \n Press the Right key when 5  \n\n\n \n Press any key to begin',thresh(Ts,Tc)), 'center', 'center', white);
        else
            shapeType=2
            if thresh(Ts,Tc)>15
                nElem=max(nElem-1,8); % number of elements in *completed* circular shape
            elseif trial>1 & thresh(Ts,Tc)<5
                nElem=min(nElem+1,24);
            end
            radiusDeg=2; %radius = number of square grid units
            spacing=linspace(0,2*pi,nElem+1); %equally spaced along circumf
            [xPosT, yPosT] = pol2cart(spacing(1:end-1),radiusDeg); %prior to jittering target
            Targx=[round(xPosT) ; round(xPosT)];
            Targy=[round(yPosT) ; round(yPosT)];
            Targori=[atan2(yPosT,xPosT)*180/pi ; atan2(yPosT,xPosT)*180/pi];
            thresh(Ts,Tc)=max(1,thresh(Ts,Tc)-8);
            
            DrawFormattedText(w, sprintf('You are now on Circle Level %d\n \n \n \n   Click inside of the Circle   \n\n\n \n Press any key to begin',25-nElem), 'center', 'center', white);
        end
        
        interblock_instruction;
                Bt2=GetSecs;
                if ExerTime
                    SessionTime=SessionTime+(Bt2-Bt1);
                end
    end
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
        EndIndex=0;  % is it correct? aslo check driftcorr--where is it
        
          fixating=0;
counter=0;
framecounter=0;
x=0;
y=0;
area_eye=0;
xeye2=[];
yeye2=[];
        
    imageRect_offs=[imageRect(1)+eccentricity_X', imageRect(2)+eccentricity_Y',...
        imageRect(3)+eccentricity_X', imageRect(4)+eccentricity_Y'];
    
    if Ts==1
        Tcontr=Contlist(1)
        Dcontr=Contlist(1)
        Oscat=JitList(thresh(Ts,Tc));
    else
        Tcontr=Contlist(1);
        Dcontr =1- Contlist(thresh(Ts,Tc));
        Oscat=0;
    end
    
    
    
    
    Priority(0);
 buttons=0;
 eyechecked=0;
 eyechecked2=0;
 %KbQueueFlush()
         trial_time=-1000;
 
         
         
           stopchecking=-100;
      %  EyeData=9999;
        trial_time=100000
         
 pretrial_time=GetSecs;
 
 
%     if fixat==1;
%         Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
%         Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
%         vbl = Screen('Flip', w); % show fixation
%         WaitSecs(.75);
%     else
%         vbl = Screen('Flip', w); % show fixation
%         WaitSecs(.75);
%     end;




    sf=1;
    texture(trial)=TheGabors(sf);
    
    priorityLevel=MaxPriority(w);
  %  [vbl,cueonset]=Screen('Flip', w); %clear the screen
    
    xmax=2*xs+1; %total number of squares in grid, along x direction (17)
    ymax=2*ys+1; %total number of squares in grid, along x direction (13)
    
    %     Xoff=round(mod(theans(trial),2)-.5)
    %     Yoff=round((theans(trial)>=2)-.5)
    %
    
    xTrans=4+randi(xmax-8); %Translate target left/right or up/down within grid
    yTrans=4+randi(ymax-8);
    theans(trial)=randi(2); %generates answer for this trial
    
    %   targetcord =Targx(theans(trial),:)+x  + (Targy(theans(trial),:)+y - 1)*xm;
    targetcord =Targy(theans(trial),:)+yTrans  + (Targx(theans(trial),:)+xTrans - 1)*ymax;
    
    xJitLoc=pix_deg*(rand(1,length(imageRect_offs))-.5)/JitRat; %plus or minus .25 deg
    yJitLoc=pix_deg*(rand(1,length(imageRect_offs))-.5)/JitRat;
    
    
    xModLoc=zeros(1,length(imageRect_offs));
    yModLoc=zeros(1,length(imageRect_offs));
    
    if shapeType>1
        xModLoc(targetcord)=pix_deg*(xPosT-Targx(1,:));  %left, and then right
        yModLoc(targetcord)=pix_deg*(yPosT-Targy(1,:));
    end
    %jitter location
    xJitLoc(targetcord)=Tscat*xJitLoc(targetcord);
    yJitLoc(targetcord)=Tscat*yJitLoc(targetcord);
    
    %jitter orientation, except for that of target
    theori=180*rand(1,length(imageRect_offs));
    theori(targetcord)=Targori(theans(trial),:) + (2*rand(1,length(targetcord))-1)*Oscat;
    
        KbQueueFlush(device)
    MousePress=0; %initializes flag to indicate no response
     while eyechecked<1
  %   fixationtype(w, wRect, fixat,fixationlength, white,pix_deg,AMD);
  
    
  if (eyetime2-pretrial_time)>ifi*35 && (eyetime2-pretrial_time)<ifi*65 && fixating<fixTime/ifi && stopchecking>1
      fixationscript
  elseif  (eyetime2-pretrial_time)>=ifi*65 && fixating<fixTime/ifi && stopchecking>1
      IsFixating4
      fixationscript
  elseif (eyetime2-pretrial_time)>ifi*65 && fixating>=fixTime/ifi && fixating<1000 && stopchecking>1
      trial_time = GetSecs;
      fixating=1500
  end
    
        if (eyetime2-trial_time)>=waittime+ifi*1+SOA && (eyetime2-trial_time)<=waittime+ifi*5+SOA && fixating>400 && stopchecking>1
    imageRect_offs =[imageRect(1)+eccentricity_X', imageRect(2)+eccentricity_Y',...
    imageRect(3)+eccentricity_X', imageRect(4)+eccentricity_Y'];

    Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
    imageRect_offs(setdiff(1:length(imageRect_offs),targetcord),:)=0;
    Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Tcontr );
    
    %stim_start = Screen('Flip', w, vbl + SOA);
             stim_start = GetSecs;
    
    
    %         Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xr; yr; xr; yr], theori,[], contr );
    %  KbQueueWait;
    %  Screen('Flip', w)
    %

    TargBox=round([min(imageRect_offs(targetcord,1:2)) max(imageRect_offs(targetcord,3:4))])
    Priority(0);
    
    
%         elseif (eyetime2-trial_time)>=waittime+ifi*2+SOA && (eyetime2-trial_time)<waittime+ifi*2+SOA && fixating>400 && stopchecking>1
%     
%     Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
%     imageRect_offs(setdiff(1:length(imageRect_offs),targetcord),:)=0;
%     Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Tcontr );
%        imageRect_offs=[imageRect(1)+eccentricity_X', imageRect(2)+eccentricity_Y',...
%         imageRect(3)+eccentricity_X', imageRect(4)+eccentricity_Y'];
    
    %         Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xr; yr; xr; yr], theori,[], contr );
    %  KbQueueWait;
    %  Screen('Flip', w)
    %

%     TargBox=round([min(imageRect_offs(targetcord,1:2)) max(imageRect_offs(targetcord,3:4))])
%     Priority(0);
    
        elseif (eyetime2-trial_time)>=waittime+ifi*3+SOA && fixating>400 && stopchecking>1 && Ts==2 && (keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0) & (GetSecs - stim_start < ResponseTime)
    imageRect_offs =[imageRect(1)+eccentricity_X', imageRect(2)+eccentricity_Y',...
    imageRect(3)+eccentricity_X', imageRect(4)+eccentricity_Y'];

        Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
    imageRect_offs(setdiff(1:length(imageRect_offs),targetcord),:)=0;
    Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Tcontr );

    cici(trial)=22;
    
%     
%         imageRect_offs=[imageRect(1)+eccentricity_X', imageRect(2)+eccentricity_Y',...
%         imageRect(3)+eccentricity_X', imageRect(4)+eccentricity_Y'];
    
    %         Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xr; yr; xr; yr], theori,[], contr );
    %  KbQueueWait;
    %  Screen('Flip', w)
    %

    TargBox=round([min(imageRect_offs(targetcord,1:2)) max(imageRect_offs(targetcord,3:4))]);
    Priority(0);
    
        elseif (eyetime2-trial_time)>waittime+ifi*3+SOA && fixating>400 && stopchecking>1 && Ts==2 && (keyCode(RespType(1)) + keyCode(RespType(2))+ keyCode(escapeKey) >0) & (GetSecs - stim_start < ResponseTime)
    
            eyechecked=1111111111;
         
         
          thekeys = find(keyCode);
    thetimes=keyCode(thekeys);
     [secs  indfirst]=min(thetimes);
            foo=(RespType==thekeys);
            IsCorr(trial)=foo(theans(trial));
            
            
                    elseif (eyetime2-trial_time)>=waittime+ifi*3+SOA && fixating>400 && stopchecking>1 && Ts==2 && (keyCode(RespType(1)) + keyCode(RespType(2))+ keyCode(escapeKey)==0) & (GetSecs - stim_start >= ResponseTime)
            
             thekeys = -1;
            thetimes=-1;
            secs =-1;
            IsCorr(trial)=0;
                        eyechecked=1111111111;
                        
                %mouse section here               
                        
                   elseif (eyetime2-trial_time)>=waittime+ifi*3+SOA && fixating>400 && stopchecking>1 && Ts~=2 && ( MousePress==0 ) & (GetSecs - stim_start < ResponseTime) 
             imageRect_offs =[imageRect(1)+eccentricity_X', imageRect(2)+eccentricity_Y',...
    imageRect(3)+eccentricity_X', imageRect(4)+eccentricity_Y'];

                     
        Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
    imageRect_offs(setdiff(1:length(imageRect_offs),targetcord),:)=0;
    Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Tcontr );
  
    TargBox=round([min(imageRect_offs(targetcord,1:2)) max(imageRect_offs(targetcord,3:4))]);
    Priority(0);
         
                       ShowCursor;
        
  
          [x,y,buttons]=GetMouse();  %waits for a key-press
            MousePress=any(buttons); %sets to 1 if a button was pressed
           % WaitSecs(.01); % put in small interval to allow other system events
            thekeys = find(keyCode);
         if (thekeys==escapeKey) % esc pressed
                closescript = 1;
                break;
            end
            
                               elseif (eyetime2-trial_time)>=waittime+ifi*3+SOA && fixating>400 && stopchecking>1 && Ts~=2 && ( MousePress~=0 ) & (GetSecs - stim_start < ResponseTime) 
            
    stim_end = GetSecs;
    resp_time=GetSecs;
            if (x>TargBox(1) & x<TargBox(3) & y>TargBox(2) & y<TargBox(4) )
                IsCorr(trial)=1;
            else
                IsCorr(trial)=0;
            end
    
                                    eyechecked=1111111111;
            
        elseif (eyetime2-trial_time)>=waittime+ifi*2+SOA && fixating>400 && stopchecking>1 && Ts~=2 && ( MousePress==0 ) & (GetSecs - stim_start >= ResponseTime) 
            
             
             thekeys = -1;
            thetimes=-1;
            secs =-1;
            IsCorr(trial)=0;
                resp_time=GetSecs;
                        eyechecked=1111111111;

            
        end
        
            eyefixation3
 
  %   Screen('FillOval', w, scotoma_color, scotoma);
             if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                Screen('FillRect', w, gray);
            else
                Screen('FillOval', w, scotoma_color, scotoma);
            end
 
     [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
     
 
          VBL_Timestamp=[VBL_Timestamp eyetime2];
  %   stimonset=[stimonset StimulusOnsetTime];
   %  fliptime=[fliptime FlipTimestamp];
    % mss=[mss Missed];
     
    
    
    if EyeTracker==1
    
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
    
    end
     [keyIsDown, keyCode] = KbQueueCheck; 
        
     end
        
        if Ts~=2 
        if MousePress
            if (x>TargBox(1) & x<TargBox(3) & y>TargBox(2) & y<TargBox(4) )
                IsCorr(trial)=1;
            else
                IsCorr(trial)=0;
            end
        else
            IsCorr(trial)=0;
        end      
        end

    
    stim_end = GetSecs;
    
   %end of eyecheck 
    staircounter(Ts,Tc)=staircounter(Ts,Tc)+1;
    Threshlist(Ts,Tc,staircounter(Ts,Tc))=thresh(Ts,Tc);
    
    if IsCorr(trial)
        resp = 1;
        corrcounter(Ts,Tc)=corrcounter(Ts,Tc)+1;
        wrongcounter(Ts,Tc)=0;
        PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
        if corrcounter(Ts,Tc)>=sc.down
            thresh(Ts,Tc)=thresh(Ts,Tc) +1;
            thresh(Ts,Tc)=min(thresh(Ts,Tc),length(JitList));
            if Ts==2
                corrcounter(Ts,Tc)=0;
            end
        end
        
        imageRect_offs =[imageRect(1)+eccentricity_X', imageRect(2)+eccentricity_Y',...
    imageRect(3)+eccentricity_X', imageRect(4)+eccentricity_Y'];

%         Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr  );
%         imageRect_offs(setdiff(1:length(imageRect_offs),targetcord),:)=0;
%         Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Tcontr,[1.5 .5 .5] );
%         
    else
        resp = 0;
        wrongcounter(Ts,Tc)=wrongcounter(Ts,Tc)+1;
        corrcounter(Ts,Tc)=0;
        PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
        if  wrongcounter(Ts,Tc)>=sc.up
            wrongcounter(Ts,Tc)=0;
            thresh(Ts,Tc)=thresh(Ts,Tc) -2;
            thresh(Ts,Tc)=max(thresh(Ts,Tc),1);
        end
        
        imageRect_offs =[imageRect(1)+eccentricity_X', imageRect(2)+eccentricity_Y',...
    imageRect(3)+eccentricity_X', imageRect(4)+eccentricity_Y'];

%         Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr  );
%         imageRect_offs(setdiff(1:length(imageRect_offs),targetcord),:)=0;
%         Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Tcontr,[.5 100 100] );
%         
    end
        PsychPortAudio('Start', pahandle);
    
        while eyechecked2<1
            
              if (eyetime2-stim_end)>ifi*35 && (eyetime2-stim_end)<=ifi*65 
                  imageRect_offs =[imageRect(1)+eccentricity_X', imageRect(2)+eccentricity_Y',...
    imageRect(3)+eccentricity_X', imageRect(4)+eccentricity_Y'];

        Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr  );
        imageRect_offs(setdiff(1:length(imageRect_offs),targetcord),:)=0;
        Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Tcontr,[1.5 .5 .5] );
              elseif (eyetime2-stim_end)>ifi*65 && (eyetime2-stim_end)<ifi*105 
                  
                 imageRect_offs=[imageRect(1)+eccentricity_X', imageRect(2)+eccentricity_Y',...
        imageRect(3)+eccentricity_X', imageRect(4)+eccentricity_Y'];
    Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr  );
    imageRect_offs(setdiff(1:length(imageRect_offs),targetcord),:)=0;
    Screen('DrawTextures', w, texture(trial), [], imageRect_offs' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Tcontr);
         
              elseif (eyetime2-stim_end)>=ifi*106                  
                  eyechecked2=111111111
              end    
                eyefixation3
 
  %   Screen('FillOval', w, scotoma_color, scotoma);
             if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                Screen('FillRect', w, gray);
            else
                Screen('FillOval', w, scotoma_color, scotoma);
            end
 
     [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
     
        end

        time_stim(trial) = stim_end - stim_start;
        rispo(trial)=resp;
        
        
        Resp_RT(trial)=resp_time-stim_start;
     
%     WaitSecs(.5);
%     
% 
%     Screen('Flip', w);
%     WaitSecs(.5);
%     Screen('Flip', w);
%     
    
    
    %  time_stim(kk) = stim_end - stim_start;
        totale_trials(kk)=trial;
     %   coordinate(trial).x=ecc_x;
     %   coordinate(trial).y=ecc_y;
        rispo(kk)=resp;
        feat(kk)=sf;
%        contrcir(kk)=ContCirc;
   %     contrasto(kk)=contr;
   %     xxeye(trial).ics=[xeye];
   %     yyeye(trial).ipsi=[yeye];
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
%          EyeSummary.(TrialNum).TargetX = ecc_x;
        %       EyeSummary.(TrialNum).TargetY = ecc_y;              
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
     EyeSummary.(TrialNum).TimeStamps.RT = stim_end - stim_start;
          EyeSummary.(TrialNum).TimeStamps.Response = stim_end;
     %FixStamp(TrialCounter,1);
     EyeSummary.(TrialNum).TimeStamps.Stimulus = stim_start;
     %StimStamp(TrialCounter,1);
       clear ErrorInfo
       Tss(trial)=Ts;
       
       
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
    
    save(baseName);
    
    
    
    
    
    
    
    
%     
%     if closescript==1 | (GetSecs-SessStartTime)>SessionTime
%         break;
%     end;
%     
%     save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
% end
fid = fopen( [SUBJECT '.txt'],'r+')
if (fid==-1)
    fid = fopen([SUBJECT '.txt'],'w')
end
fprintf(fid,'%d',floor((nElem+nElemStart)/2));
fclose(fid)

DrawFormattedText(w, sprintf('Task completed \n \n \n You ended at Circle Level %d and Number Level %d \n \n \n  Press a key to close', 25-nElem,thresh(2,1)), 'center', 'center', white);
Screen('Flip', w);
KbQueueWait(device);
ShowCursor;

if BITS==1
    Screen('CloseAll');
    Screen('Preference', 'SkipSyncTests', 0);
    %     s1 = serial('COM3');     % set the Bits mode back so the screen is in colour
    %     fopen(s1);
    %     fprintf(s1, ['$BitsPlusPlus' 13]); %one day we might use the bits# so better not to get rid of these lines
    %     fclose(s1);
    PsychPortAudio('Close', pahandle);
    
else
    %Screen('Preference', 'SkipSyncTests', 0);
    %Screen('LoadNormalizedGammaTable', w , (linspace(0,1,256)'*ones(1,3)));
    Screen('Flip', w);
    Screen('CloseAll');
    PsychPortAudio('Close', pahandle);
end;

%% data analysis (to be completed once we have the final version)


%to get each scale in a matrix (as opposite as Threshlist who gets every
%trial in a matrix)
% thresho=permute(Threshlist,[3 1 2]);

%to get the final value for each staircase
% final_threshold=thresho(10,1:length(thresho(1,:,1)),1:length(thresho(1,1,:)));
% total_thresh= [final_threshold(:,:,1) final_threshold(:,:,2)];
%%
save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');


