% Contrast threshold measurement with randomized position of the target -
% wait until response
close all; clear all; clc;
commandwindow
    addpath('/Users/sll/Desktop/Flap/Flap_scripts/utilities')


try
prompt={'Subject Name', 'day'};

name= 'Subject Name';
numlines=1;
defaultanswer={'test','test' };
answer=inputdlg(prompt,name,numlines,defaultanswer);
if isempty(answer)
    return;
end;

SUBJECT = answer{1,:}; %Gets Subject Name
expdayeye=str2num(answer{2,:});
%load (['../PRLocations/' name]);
c = clock; %Current date and time as date vector. [year month day hour minute seconds]
%create a folder if it doesn't exist already
if exist('data')==0
    mkdir('data')
end;
baseName=['./data/' SUBJECT '_FLAPcrowdingacuity3practice' expdayeye num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename


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

StartSize=1.1; %for VA
cueSize=3;

oneOrfourCues=1; % 1= 1 cue, 4= 4 cue
fixwindow=2;
fixTime=0.2;
fixTime2=0.2;

         PRLecc=8;         %7.5; %eccentricity of PRLs
     %   PRLxx=[0 PRLecc 0 -PRLecc];
     %   PRLyy=[-PRLecc 0 PRLecc 0 ];
%PRL_x_axis=-5;
%PRL_y_axis=0;
%NoPRL_x_axis=5;
%NoPRL_y_axis=0;

Screen('Preference', 'SkipSyncTests', 1);
PC=getComputerName();
n_blocks=1;


BITS=0; %0; 1=bits++; 2=display++
closescript=0;
kk=1;

cueonset=0.55;
cueduration=.05;
cueISI=0.1;
presentationtime=0.133;


cue_spatial_offset=2;


if BITS==1  %UCR
    %% psychtoobox settings
    screencm=[40.6 30];
    load gamma197sec;
v_d=110;
    %load lut_12bits_pd; Disabled until display is calibrated
    AssertOpenGL;
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    %PsychGPUControl('SetDitheringEnabled', 0); Not supported on OSX
    screenNumber=max(Screen('Screens'));
    rand('twister', sum(100*clock));
    PsychImaging('PrepareConfiguration');   % tell PTB what modes we're usingvv
    PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
    PsychImaging('AddTask', 'General', 'EnableBits++Mono++Output');
    PsychImaging('AddTask', 'FinalFormatting','DisplayColorCorrection','LookupTable');
    PsychColorCorrection('SetLookupTable', window, lookup);
    oldResolution=Screen( 'Resolution',screenNumber,1280,960);
    SetResolution(screenNumber, oldResolution);
    %lut_12bits= repmat((linspace(0,1,4096).^(1/2.2))',1,3);
    %PsychColorCorrection('SetLookupTable', w, lut_12bits); --Denton-Disabled until calibration is done, moved to before OpenWindow, if initialized afterwards it won't have any effect until after the first flip
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
    %if you want to open a small window for debug
    %   [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
    %    Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
    %Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
elseif BITS==0
    
    %% psychtoobox settings
    v_d=57;
    AssertOpenGL;
    screenNumber=max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');
   % PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
   
        oldResolution=Screen( 'Resolution',screenNumber,1280,1024);
    SetResolution(screenNumber, oldResolution);;
   [w, wRect]=PsychImaging('OpenWindow',screenNumber, 0,[],32,2);
        screencm=[40.6 30];
    %debug window
%    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
    %ScreenParameters=Screen('Resolution', screenNumber); %close all
    Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
    Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
elseif BITS==2   %UAB
       s1=serial('com3')
     fopen(s1)
     fprintf(s1, ['$monoPlusPlus' 13])
     fclose(s1)
     clear s1
     screencm=[69.8, 35.5];
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
%       [w, wRect]=Screen('OpenWindow',whichScreen, 127, [], [], [], [],3);
%     [w, wRect] = Screen('OpenWindow', screenNumber, 0.5,[],[],[],[],3);
fixationlengthy=10;
fixationlengthx=10;
end;
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
struct.sz=[screencm(1), screencm(2)];

pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi));
%pix_deg = pi * wRect(3) / atan(screencm(1)/v_d/2) / 360; %pixperdegree
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
pahandle = PsychPortAudio('Open', [], 1, 0, 44100, 2);
pahandle1 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
pahandle2 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    try
        [errorS freq  ] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
        [corrS freq  ] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
    end
    
    try
        [errorS freq  ] = wavread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
        [corrS freq  ] = wavread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
    end;

PsychPortAudio('FillBuffer', pahandle1, corrS' ); % loads data into buffer
PsychPortAudio('FillBuffer', pahandle2, errorS'); % loads data into buffer
bg_index =round(gray*255); %background color

%
imsize=StartSize*pix_deg;

%imsize=StartSize*pix_deg;
[x,y]=meshgrid(-imsize/2:imsize/2,-imsize/2:imsize/2);
%circular mask
xylim = imsize; %radius of circular mask
circle = x.^2 + y.^2 <= xylim^2;
[nrw, ncl]=size(x);

%theLetter=imread('letter_c2.tiff');
theLetter=imread('newletterc22.tiff');
theLetter=theLetter(:,:,1);

[sizx sizy]= size(theLetter);

theLetter=imresize(theLetter,[nrw nrw],'bicubic');
theCircles=theLetter;

theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
theLetter=Screen('MakeTexture', w, theLetter);


theCircles(1:nrw, nrw/2:nrw)=theCircles(nrw:-1:1, (nrw/2+1):-1:1);
theCircles = double(circle) .* double(theCircles)+bg_index * ~double(circle);
theCircles=Screen('MakeTexture', w, theCircles);



theDot=imread('thedot2.tiff');
theDot=theDot(:,:,1);


theDot=imresize(theDot,[nrw nrw],'bicubic');

theDot = double(circle) .* double(theDot)+bg_index * ~double(circle);
theDot=Screen('MakeTexture', w, theDot);
     

% corrS=zeros(size(errorS));
load('S096_marl-nyu');


%% STAIRCASES:

% Acuity
cndt=4;
ca=1;
threshVA(1:cndt, 1:ca)=19;
reversalsVA(1:cndt, 1:ca)=0;
%reversalcounterVA
isreversalsVA(1:cndt, 1:ca)=0;
staircounterVA(1:cndt, 1:ca)=0;
corrcounterVA(1:cndt, 1:ca)=0;

% Threshold -> 79%
sc.up = 1;                          % # of incorrect answers to go one step up
sc.down = 3;                        % # of correct answers to go one step down

max_separation=8; %15
min_separation=StartSize;

Sizelist=log_unit_down(StartSize, 0.01, 64);
%Sizelist=log_unit_down(StartSize, 0.0135, 64)


%Sizelist=fliplr(Separationtlist);


stepsizes=[8 4 3 2 1];
%stepsizes=[2 1 1 1 1];


% Crowding
cndt=4;
ca=2;
threshCW(1:cndt, 1:ca)=29;
reversalsCW(1:cndt, 1:ca)=0;
isreversalsCW(1:cndt, 1:ca)=0;
staircounterCW(1:cndt, 1:ca)=0;
corrcounterCW(1:cndt, 1:ca)=0;

max_separation=8; %15
min_separation=StartSize;

Separationtlist=log_unit_up(StartSize, 0.01, 64);
%Sizelist=log_unit_down(StartSize, 0.0135, 64)


Separationtlist=fliplr(Separationtlist);


stepsizes=[8 4 3 2 1];
%stepsizes=[2 1 1 1 1];




%% stimulus settings
 rand('twister', sum(100*clock));



%% response


KbName('UnifyKeyNames');

    RespType(1) = KbName('LeftArrow');
    RespType(2) = KbName('RightArrow');
    RespType(3) = KbName('UpArrow');
    RespType(4) = KbName('DownArrow');
    

if ispc
    escapeKey = KbName('esc');	% quit key
elseif ismac
    escapeKey = KbName('ESCAPE');	% quit key
end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    

                        KbQueueCreate(deviceIndex);
            KbQueueStart(deviceIndex);

    if EyeTracker==1
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
    save_dir=[cd './dataeyet/'];
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
           % Eyelink('command', 'calibration_type = HV5'); % changed to 5 to correct upper left corner of the screen issue
            % you must send this command with value NO for custom calibration
            % you must also reset it to YES for subsequent experiments
        %    Eyelink('command', 'generate_default_targets = NO');
            
            
            %% Modify target locations
            % due to issues with calibrating the upper left corner of the screen the following lines have been
            % commmented out to change the the sampling from 10 to 5 as
            % listed in line 323
             Eyelink('command','calibration_samples = 10');
             Eyelink('command','calibration_sequence = 0,1,2,3,4,5,6,7,8,9');
            
%             modFactor = 0.183;
%             
%             Eyelink('command','calibration_targets = %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
%                 round(winWidth/2), round(winHeight/2),  round(winWidth/2), round(winHeight*modFactor),  ...
%                 round(winWidth/2), round(winHeight - winHeight*modFactor),  round(winWidth*modFactor), ...
%                 round(winHeight/2),  round(winWidth - winWidth*modFactor), round(winHeight/2), ...
%                 round(winWidth*modFactor), round(winHeight*modFactor), round(winWidth - winWidth*modFactor), ...
%                 round(winHeight*modFactor), round(winWidth*modFactor), round(winHeight - winHeight*modFactor),...
%                 round(winWidth - winWidth*modFactor), round(winHeight - winHeight*modFactor) );
            
          %  Eyelink('command','validation_samples = 5');
             Eyelink('command','validation_samples = 10'); %changed to make
            % it 5 samples instead of 10 to deal with upper left corner of
            % the screem issue
%             Eyelink('command','validation_sequence = 0,1,2,3,4,5,6,7,8,9');
%             Eyelink('command','validation_targets =  %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
%                 round(winWidth/2), round(winHeight/2),  round(winWidth/2), round(winHeight*modFactor),  ...
%                 round(winWidth/2), round(winHeight - winHeight*modFactor),  round(winWidth*modFactor), ...
%                 round(winHeight/2),  round(winWidth - winWidth*modFactor), round(winHeight/2), ...
%                 round(winWidth*modFactor), round(winHeight*modFactor), round(winWidth - winWidth*modFactor), ...
%                 round(winHeight*modFactor), round(winWidth*modFactor), round(winHeight - winHeight*modFactor),...
%                 round(winWidth - winWidth*modFactor), round(winHeight - winHeight*modFactor)  );
            
            % make sure that we get gaze data from the Eyelink
            Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
            Eyelink('OpenFile', eyeTrackerFileName); % open file to record data  & calibration
            EyelinkDoTrackerSetup(elHandle);
            Eyelink('dodriftcorrect');
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
DrawFormattedText(w, 'report the orientation of the gap of the C \n \n using the keyboard arrows \n \n \n \n Press any key to start', 'center', 'center', white);
Screen('Flip', w);
%Speak('You will see a grating tilted left or right. Press Left key when tilted Left. Press Right key when tilted Right. Press any key to start');
KbQueueWait;
%Screen('Flip', w);
%WaitSecs(1.5);
       
[xc, yc] = RectCenter(wRect); % coordinate del centro schermo



        xlocs=[0 PRLecc 0 -PRLecc];
        ylocs=[-PRLecc 0 PRLecc 0 ];
%eccentricity_X=[xlocs(1)*pix_deg xlocs(2)*pix_deg];
%eccentricity_Y=[ylocs(1)*pix_deg ylocs(2)*pix_deg];
eccentricity_X=xlocs*pix_deg;
eccentricity_Y=ylocs*pix_deg;
%mixtr=randi(2,100,2);

%mixtr=randi(2,10,2);
    PRLlocations=4;
   
tr=4;  %50
    
% mixtr=[repmat(1:lr,1,cc*tr)' repmat(ceil((1:(cc*lr))/lr),1, tr)'];
%  mixtr =mixtr(randperm(length(mixtr)),:)

 
 
blocks=1; %12;
n_blocks=round(tr/blocks);   %number of trials per miniblock
    

        mixtrVA=[];
                       for j=1:blocks
                a=[repmat(1:PRLlocations,1,n_blocks)'];
                b=a(randperm(length(a)));
             %   bb=[b ones(length(b),1) ones(length(b),1)];
                mixtrVA=[mixtrVA;b];
        end;
        
mixtrCW=[];
    
        first=Randi(2);
        second=3-first;
        
        for j=1:blocks
                a=[repmat(1:PRLlocations,1,n_blocks)' repmat(first,1, n_blocks*4)'];
                b=a(randperm(length(a)),:);
            %    bb=[b ones(length(b),1)];
                mixtrCW=[mixtrCW;b];
        end;
               for j=1:blocks
                a=[repmat(1:PRLlocations,1,n_blocks)' repmat(second,1, n_blocks*4)'];
                b=a(randperm(length(a)),:);
             %   bb=[b ones(length(b),1)];
                mixtrCW=[mixtrCW;b];
        end;
         

        %mixtr =1 1 % left + radial
        %mixtr =2 2 % right + tangient
        %mixtr =1 2 % left + tangient
        %mixtr =2 2 % right + tangient

        cueloc=5;
        targetloc=4;
        rep=2;
        
        
        mixtrAtt=repmat(fullfact([cueloc targetloc]), rep,1);
        mixtrAttrial=mixtrAtt(randperm(length(mixtrAtt)),:);
        
    
        load('AttMat.mat')
        
        numar=size(fields(AttMat));
    
        dio= [99 99 ];
        while dio(1) == dio(2)
            
            dio=randi(numar(1),1,2);
        end
        
        subMat={'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten'};
        firstPartMat=AttMat.(subMat{dio(1)});
        secondPartMat=AttMat.(subMat{dio(2)});
 
        mixtrAtt= [firstPartMat; secondPartMat];
        
        
        mixtrAtt=mixtrAtt(1:20,:);
        %   totalmixtr = [1 1; 2 1; 3 1; 4 1; 1 2; 2 2; 3 2; 4 2];

    totalmixtr=length(mixtrVA)+length(mixtrCW)+length(mixtrAtt);
    % check EyeTracker status
    if EyeTracker == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        % mark zero-plot time in data file
        Eyelink('message' , 'SYNCTIME');
        
        location =  zeros(length(totalmixtr), 6);
    end
    

    

  %  imageRect = CenterRect([0, 0, size(x)], wRect);
    % widthFactor is news
    % heightFactor is nrw
widthFactor=2.24;
heightFactor=2.69;
%imageRect11 = CenterRect([0, 0, [nrw*heightFactor news*widthFactor ]], wRect);
%   imageRect11 = CenterRect([0, 0, [nrw news ]], wRect);
%imageRect12 = CenterRect([0, 0, [nrw*1.5 nrw*1.5 ]], wRect);
%imageRect11 = CenterRect([0, 0, [nrw nrw ]], wRect);
%imageRect12 = CenterRect([0, 0, [nrw nrw ]], wRect);

    eyetime2=0;
   % waittime=ifi*60;
   waittime=0;
  scotomadeg=10; %0.8;
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
     
for totaltrial=1:totalmixtr
  if totaltrial== length(mixtrVA) || totaltrial== (length(mixtrVA)+length(mixtrCW))      
     interblock_instruction       
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

    end      % if   (mod(trial,tr*2)==1)
%         if trial==1
%             whichInstruction=(mixtr(trial,2))
%             interblock_instruction_crowd;  
%         elseif mixtr(trial,2)~=mixtr(trial-1,2)
%                         whichInstruction=(mixtr(trial,2))
%             interblock_instruction_crowd;  
%         end
     %   end
     
     
%      if  mod(totaltrial,200)==0
%          interblock_instruction
%      end
     
   %  whichTask=3
     
TrialNum = strcat('Trial',num2str(totaltrial));

        
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
        
if whichTask ==1
            %   VAsize = Sizelist(threshVA(mixtrVA(trial,1),mixtrVA(trial,2)));            
        theeccentricity_X=eccentricity_X(mixtrVA(trial));
        theeccentricity_Y=eccentricity_Y(mixtrVA(trial));
                              VAsize = Sizelist(threshVA(mixtrVA(trial)));

                   imageRect = CenterRect([0, 0, VAsize*pix_deg VAsize*pix_deg], wRect);               
elseif whichTask ==2
              
                    VA_thresho=mean(ThreshlistVA-20:ThreshlistVA)*1.3;
                    if VA_thresho<0
                        VA_thresho=1;
                    end
       imageRect = CenterRect([0, 0, VA_thresho*pix_deg VA_thresho*pix_deg], wRect);               
 imageRect11 =imageRect; %CenterRect([0, 0, [nrw nrw ]], wRect);
imageRect12 =imageRect; %CenterRect([0, 0, [nrw nrw ]], wRect);
    sep = Separationtlist(threshCW(mixtrCW(trial,1),mixtrCW(trial,2)));
           
           eccentricita_o=eccentricity_X(mixtrCW(trial,1));
eccentricita_v=eccentricity_Y(mixtrCW(trial,1));
radOrtan=mixtrCW(trial,2);
if radOrtan==1
    angolo=atan((eccentricita_v)/(eccentricita_o));
elseif radOrtan==2 && mixtrCW(trial,1)==2
    angolo=atan((eccentricita_v)/(eccentricita_o))+pi/2;
    
elseif radOrtan==2 && mixtrCW(trial,1)==1
    angolo=atan((eccentricita_v)/(eccentricita_o))-pi/2;
  
    elseif radOrtan==2 && mixtrCW(trial,1)==4
    angolo=atan((eccentricita_v)/(eccentricita_o))+pi/2;
    
elseif radOrtan==2 && mixtrCW(trial,1)==3
    angolo=atan((eccentricita_v)/(eccentricita_o))-pi/2;

end
         [xc, yc] = RectCenter(wRect);
           ecc_r=sep*pix_deg;
           %     ecc_r_poke=(sep*2)*pix_deg
                ecc_r_poke=(sep*pix_deg)+pix_deg;
        %flanker 1
  %      ecc_t=3/4*pi;
        ecc_t=angolo;
            cs= [cos(ecc_t), sin(ecc_t)];
            xxyy=[ecc_r ecc_r].*cs;
            xxyy_poke=[ecc_r_poke ecc_r_poke].*cs;
            ecc_x=xxyy(1);
            ecc_y=xxyy(2);
        eccentricity_X1=ecc_x;
        eccentricity_Y1=ecc_y;
        
        ecc_x_poke=xxyy_poke(1);
            ecc_y_poke=xxyy_poke(2);
        eccentricity_X1_poke=ecc_x_poke;
        eccentricity_Y1_poke=ecc_y_poke;                
                               
        %flanker 2
        
      %  ecc_t2=7/4*pi;
        ecc_t2=-angolo;
         cs= [cos(ecc_t2), sin(ecc_t2)];
            xxyy2=[ecc_r ecc_r].*cs;
            ecc_x2=xxyy2(1);
            ecc_y2=xxyy2(2);       
            eccentricity_X2=ecc_x2;
        eccentricity_Y2=ecc_y2;
  %   t0 = Screen('Flip', w);
%WaitSecs(.8)

        %flanker 1
  %      ecc_t=3/4*pi;
        ecc_t3=angolo+pi/2;
            cs= [cos(ecc_t3), sin(ecc_t3)];
            xxyy3=[ecc_r ecc_r].*cs;
            ecc_x3=xxyy3(1);
            ecc_y3=xxyy3(2);
        eccentricity_X3=ecc_x3;
        eccentricity_Y3=ecc_y3;
        %flanker 2
        
      %  ecc_t2=7/4*pi;
        ecc_t4=-(angolo+pi/2);
         cs= [cos(ecc_t4), sin(ecc_t4)];
            xxyy4=[ecc_r ecc_r].*cs;
            ecc_x4=xxyy4(1);
            ecc_y4=xxyy4(2);       
            eccentricity_X4=ecc_x4;
        eccentricity_Y4=ecc_y4;
        

        theeccentricity_X=eccentricity_X(mixtrCW(trial,1));
        theeccentricity_Y=eccentricity_Y(mixtrCW(trial,1));
        
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
        
        imageRect_offs11 =[imageRect11(1)+theeccentricity_X, imageRect11(2)+theeccentricity_Y,...
            imageRect11(3)+theeccentricity_X, imageRect11(4)+theeccentricity_Y];
        
        imageRect_offs12 =[imageRect12(1)+theeccentricity_X, imageRect12(2)+theeccentricity_Y,...
            imageRect12(3)+theeccentricity_X, imageRect12(4)+theeccentricity_Y];
        
        anglout = radtodeg(angolo+pi/2);
        anglout2=radtodeg(angolo);
        anglout3=radtodeg(angolo+pi);
        angloutp=radtodeg(angolo);        
elseif whichTask == 3
    
               imageRectCue = CenterRect([0, 0, cueSize*pix_deg cueSize*pix_deg], wRect);               

    
    if exist('ThreshlistVA') ==0
        ThreshlistVA = [ones(30,1)];
               imageRect = CenterRect([0, 0, 1*pix_deg 1*pix_deg], wRect);               

    end
    VA_thresho=mean(ThreshlistVA-20:ThreshlistVA)*1.3;
    
                        if VA_thresho<0
                        VA_thresho=1;
                    end
            theeccentricity_X=eccentricity_X(mixtrAtt(trial,1));
        theeccentricity_Y=eccentricity_Y(mixtrAtt(trial,1));
            imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
        
       %     imageRect_offs_cue=imageRect_offs;
       
         %   imageRect_offs_cue= [imageRect_offs_cue(1), imageRect_offs_cue(2)-(cue_spatial_offset*pix_deg), imageRect_offs_cue(3), imageRect_offs_cue(4)-(cue_spatial_offset*pix_deg)];

end


theoris =[-180 0 -90 90]; 

theans(trial)=randi(4); %generates answer for this trial

ori=theoris(theans(trial));
%KbQueueFlush()

 Priority(0);
 buttons=0;
 eyechecked=0;
 KbQueueFlush()
         trial_time=-1000;
        stopchecking=-100;

        trial_time=100000;
        
 pretrial_time=GetSecs;
 while eyechecked<1

  if (eyetime2-pretrial_time)>ifi*35 && (eyetime2-pretrial_time)<ifi*65 && fixating<fixTime/ifi && stopchecking>1
      fixationscript2
  elseif  (eyetime2-pretrial_time)>=ifi*65 && fixating<fixTime/ifi && stopchecking>1
      IsFixating4
      fixationscript2
  elseif (eyetime2-pretrial_time)>ifi*65 && fixating>=fixTime/ifi && fixating<1000 && stopchecking>1
      trial_time = GetSecs;
      fixating=1500;
  end
 

        if (eyetime2-trial_time)>=waittime+ifi*2+cueonset && (eyetime2-trial_time)<waittime+ifi*2+cueonset+cueduration && fixating>400 && stopchecking>1
    if whichTask ==3 
         imageRect_offs_cue =[imageRectCue(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectCue(2)+(newsampley-wRect(4)/2)+theeccentricity_Y-(cue_spatial_offset*pix_deg),...
            imageRectCue(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectCue(4)+(newsampley-wRect(4)/2)+theeccentricity_Y-(cue_spatial_offset*pix_deg)];
imageRect_offs_cue2 =[imageRectCue(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectCue(2)+(newsampley-wRect(4)/2)+theeccentricity_Y+(cue_spatial_offset*pix_deg),...
            imageRectCue(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRectCue(4)+(newsampley-wRect(4)/2)+theeccentricity_Y+(cue_spatial_offset*pix_deg)];
imageRect_offs_cue3 =[imageRectCue(1)+(newsamplex-wRect(3)/2)+theeccentricity_X-(cue_spatial_offset*pix_deg), imageRectCue(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
            imageRectCue(3)+(newsamplex-wRect(3)/2)+theeccentricity_X-(cue_spatial_offset*pix_deg), imageRectCue(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
imageRect_offs_cue4 =[imageRectCue(1)+(newsamplex-wRect(3)/2)+theeccentricity_X+(cue_spatial_offset*pix_deg), imageRectCue(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
            imageRectCue(3)+(newsamplex-wRect(3)/2)+theeccentricity_X+(cue_spatial_offset*pix_deg), imageRectCue(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];

        
        
        if mixtrAtt(trial,2)==1
                     Screen('DrawTexture',w, theDot, [], imageRect_offs_cue,0,[],1); 
                    if oneOrfourCues ==4
                        Screen('DrawTexture',w, theDot, [], imageRect_offs_cue2,0,[],1); 
                     Screen('DrawTexture',w, theDot, [], imageRect_offs_cue3,0,[],1); 
                     Screen('DrawTexture',w, theDot, [], imageRect_offs_cue4,0,[],1); 
                    end
    end
    end
            %show cue
        elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration && (eyetime2-trial_time)<waittime+ifi*2+cueonset+cueduration+cueISI && fixating>400 && stopchecking>1

            %no cue
        elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+cueISI && (eyetime2-trial_time)<waittime+ifi*2+cueonset+cueduration+cueISI+presentationtime && fixating>400 && stopchecking>1
         
         
          
     imageRect_offs =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
            imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
    
         
         
         
                         Screen('DrawTexture', w, theLetter, [], imageRect_offs, ori,[], 1);
                        if whichTask == 2
                            imageRect_offs_flank1 =[imageRect_offs11(1)+(newsamplex-wRect(3)/2)+eccentricity_X1, imageRect_offs11(2)+(newsampley-wRect(4)/2)+eccentricity_Y1,...
        imageRect_offs11(3)+(newsamplex-wRect(3)/2)+eccentricity_X1, imageRect_offs11(4)+(newsampley-wRect(4)/2)+eccentricity_Y1];
    
        imageRect_offs_flank2 =[imageRect_offs11(1)-eccentricity_X2+(newsamplex-wRect(3)/2), imageRect_offs11(2)+(newsampley-wRect(4)/2)+eccentricity_Y2,...
        imageRect_offs11(3)-eccentricity_X2+(newsamplex-wRect(3)/2), imageRect_offs11(4)+(newsampley-wRect(4)/2)+eccentricity_Y2];   
    
imageRect_offs_poke=[imageRect_offs12(1)+eccentricity_X1_poke+(newsamplex-wRect(3)/2), imageRect_offs12(2)+(newsampley-wRect(4)/2)+eccentricity_Y1_poke,...
        imageRect_offs12(3)+eccentricity_X1_poke+(newsamplex-wRect(3)/2), imageRect_offs12(4)+eccentricity_Y1_poke+(newsampley-wRect(4)/2)];
    
                            Screen('DrawTexture',w, theCircles, [],imageRect_offs_flank1,anglout,[],1 ); % lettera a sx del target
                         Screen('DrawTexture',w, theCircles, [], imageRect_offs_flank2,anglout,[],1); % lettera a sx del target
     %                    Screen('DrawTexture',w, theDot, [], imageRect_offs_poke,angloutp,[],1); % lettera a sx del target
                        end

         
         %     Screen('DrawTexture', w, texture(trial), [], imageRect_offs{tloc}, ori,[], contr );
         stim_start = GetSecs;
         
     elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+cueISI+presentationtime && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0 && stopchecking>1; %present pre-stimulus and stimulus
      %   Screen('Close');
         
     elseif (eyetime2-trial_time)>=waittime+ifi*2+cueonset+cueduration+cueISI+presentationtime && fixating>400 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1; %present pre-stimulus and stimulus
         eyechecked=1111111111;
         
         
          thekeys = find(keyCode);
    thetimes=keyCode(thekeys);
     [secs  indfirst]=min(thetimes);
         
     end
     
     eyefixation3
 
     Screen('FillOval', w, scotoma_color, scotoma);
 
 
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
    
    
if whichTask == 1
      staircounterVA(mixtrVA(trial))=staircounterVA(mixtrVA(trial))+1;
    ThreshlistVA(mixtrVA(trial),staircounterVA(mixtrVA(trial)))=VAsize;
      
if foo(theans(trial))
        resp = 1;
        corrcounterVA(mixtrVA(trial))=corrcounterVA(mixtrVA(trial))+1;
                            PsychPortAudio('Start', pahandle1);
        if corrcounterVA(mixtrVA(trial))>=sc.down
            
            if isreversalsVA(mixtrVA(trial))==1
                reversalsVA(mixtrVA(trial))=reversalsVA(mixtrVA(trial))+1;
                isreversalsVA(mixtrVA(trial))=0;
          %      reversalcounterVA=reversalcounterVA+1;
            end
            thestep=min(reversalsVA(mixtrVA(trial))+1,length(stepsizes));
            if thestep>5 
                thestep=5;
            end;                     
            threshVA(mixtrVA(trial))=threshVA(mixtrVA(trial)) +stepsizes(thestep);
            threshVA(mixtrVA(trial))=min(threshVA(mixtrVA(trial)),length(Sizelist));
        end
    elseif (thekeys==escapeKey) % esc pressed
        closescript = 1;
        break;
    else
        resp = 0;
        if  corrcounterVA(mixtrVA(trial))>=sc.down
            isreversalsVA(mixtrVA(trial))=1;
        end
        corrcounterVA(mixtrVA(trial))=0;
                            PsychPortAudio('Start', pahandle2);
        thestep=max(reversalsVA(mixtrVA(trial))+1,length(stepsizes));
              if thestep>5
                thestep=5;
        end;        
        threshVA(mixtrVA(trial))=threshVA(mixtrVA(trial)) -stepsizes(thestep);
        threshVA(mixtrVA(trial))=max(threshVA(mixtrVA(trial)),1);
end

elseif whichTask == 2
    
      staircounterCW(mixtrCW(trial,1),mixtrCW(trial,2))=staircounterCW(mixtrCW(trial,1),mixtrCW(trial,2))+1;
    ThreshlistCW(mixtrCW(trial,1),mixtrCW(trial,2),staircounterCW(mixtrCW(trial,1),mixtrCW(trial,2)))=sep;
  
    if foo(theans(trial))
        resp = 1;
        corrcounterCW(mixtrCW(trial,1),mixtrCW(trial,2))=corrcounterCW(mixtrCW(trial,1),mixtrCW(trial,2))+1;
                            PsychPortAudio('Start', pahandle1);
        if corrcounterCW(mixtrCW(trial,1),mixtrCW(trial,2))>=sc.down
            
            if isreversalsCW(mixtrCW(trial,1),mixtrCW(trial,2))==1
                reversalsCW(mixtrCW(trial,1),mixtrCW(trial,2))=reversalsCW(mixtrCW(trial,1),mixtrCW(trial,2))+1;
                isreversalsCW(mixtrCW(trial,1),mixtrCW(trial,2))=0;
            end
            thestep=min(reversalsCW(mixtrCW(trial,1),mixtrCW(trial,2))+1,length(stepsizes));
            if thestep>5 %Doesn't this negate the step size of 8 in the step size list? --Denton
                thestep=5;
            end;                     
            threshCW(mixtrCW(trial,1),mixtrCW(trial,2))=threshCW(mixtrCW(trial,1),mixtrCW(trial,2)) +stepsizes(thestep);
            threshCW(mixtrCW(trial,1),mixtrCW(trial,2))=min( threshCW(mixtrCW(trial,1),mixtrCW(trial,2)),length(Separationtlist));
        end
    elseif (thekeys==escapeKey) % esc pressed
        closescript = 1;
        break;
    else
        resp = 0;
        if  corrcounterCW(mixtrCW(trial,1),mixtrCW(trial,2))>=sc.down
            isreversalsCW(mixtrCW(trial,1),mixtrCW(trial,2))=1;
        end
        corrcounterCW(mixtrCW(trial,1),mixtrCW(trial,2))=0;
                            PsychPortAudio('Start', pahandle2);
        thestep=max(reversalsCW(mixtrCW(trial,1),mixtrCW(trial,2))+1,length(stepsizes));
              if thestep>5
                thestep=5;
        end;        
        threshCW(mixtrCW(trial,1),mixtrCW(trial,2))=threshCW(mixtrCW(trial,1),mixtrCW(trial,2)) -stepsizes(thestep);
        threshCW(mixtrCW(trial,1),mixtrCW(trial,2))=max(threshCW(mixtrCW(trial,1),mixtrCW(trial,2)),1);
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
    stim_stop=secs;
    time_stim(kk) = stim_stop - stim_start;
    totale_trials(kk)=trial;
    %coordinate(trial).x=ecc_x;
    %coordinate(trial).y=ecc_y;
    
   coordinate(totaltrial).x=theeccentricity_X/pix_deg;
   coordinate(totaltrial).y=theeccentricity_Y/pix_deg;
    
    
    xxeye(totaltrial).ics=[xeye];
    yyeye(totaltrial).ipsi=[yeye];
    vbltimestamp(totaltrial).ix=[VBL_Timestamp];
    flipptime(totaltrial).ix=[fliptime];
    if eyeOrtrack==1
   %     ppupils(trial)=[pupils];
   %     tracktime=[tracktime trackertime];
    end
    rispo(kk)=resp;
    if whichTask==1
        lettersize(kk)=VAsize;
    elseif whichTask ==2
    separation(kk)=sep;
    sizeCrSti(kk)=VA_thresho;
    elseif whichTask ==3
        correx(kk)=resp;
    end
cheis(kk)=thekeys;

    
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
          EyeSummary.(TrialNum).TargetX = theeccentricity_X/pix_deg;
               EyeSummary.(TrialNum).TargetY = theeccentricity_Y/pix_deg;              
             % EyeSummary.(TrialNum).RadOrTan=radOrtan;
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
       
       if (mod(trial,50))==1
    if trial==1
    else
save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    end
end
    
    
    if closescript==1
        break;
    end;
    
    kk=kk+1;
  %  save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    
end;


  
    % shut down EyeTracker
    if EyeTracker==1
        Eyelink('StopRecording');
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    end;
    
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
Screen('Flip', w);
    Screen('TextFont', w, 'Arial');
DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
Screen('Flip', w);
KbQueueWait;
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
%final_threshold=thresho(10,1:length(thresho(1,:,1)),1:length(thresho(1,1,:)));
%total_thresh= [final_threshold(:,:,1) final_threshold(:,:,2)];
%%


catch ME
    psychlasterror()
end

