% Contrast threshold measurement with randomized position of the target -
% wait until response
close all; clear all; clc;
commandwindow


prompt={'Subject Name'};

name= 'Subject Name';
numlines=1;
defaultanswer={'test' };
answer=inputdlg(prompt,name,numlines,defaultanswer);
if isempty(answer)
    return;
end;

SUBJECT = answer{1,:}; %Gets Subject Name

c = clock; %Current date and time as date vector. [year month day hour minute seconds]
%create a folder if it doesn't exist already
if exist('data')==0
    mkdir('data')
end;
baseName=['./data/' SUBJECT '_CAT_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename

Screen('Preference', 'SkipSyncTests', 1);
PC=getComputerName();
max_contrast=.4;
n_blocks=2;
reps=10;
screencm=[28.5 18];
v_d=57;
sigma_deg = 1; %4;
sfs=8;
BITS=0; %0;
randomizzato=0;
CircConts=1;
fixat=1;
SOA=.4;
closescript=0;
kk=1;

cuedir=.1;
oval_thick=10; %thickness of oval


KbQueueCreate;
KbQueueStart;


if ispc
    escapeKey = KbName('esc');	% quit key
elseif ismac
    escapeKey = KbName('ESCAPE');	% quit key
end

if BITS==1
    %% psychtoobox settings
    
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
    %lut_12bits= repmat((linspace(0,1,4096).^(1/2.2))',1,3);
    %PsychColorCorrection('SetLookupTable', w, lut_12bits); --Denton-Disabled until calibration is done, moved to before OpenWindow, if initialized afterwards it won't have any effect until after the first flip
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[],32,2);
    %if you want to open a small window for debug
    %   [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
    %    Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
    %Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
else
    
    %% psychtoobox settings
    AssertOpenGL;
    screenNumber=max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
    [w, wRect]=PsychImaging('OpenWindow',screenNumber, 0,[],32,2);
    %debug window
    %[w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640480],32,2);
    %ScreenParameters=Screen('Resolution', screenNumber); %close all
    %struct.res=[ScreenParameters.width ScreenParameters.height];
    Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
    Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
end;
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
struct.res=[1024 768];
struct.sz=[screencm(1), screencm(2)];

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

% corrS=zeros(size(errorS));
load('S096_marl-nyu');

%% STAIRCASE
cndt=2;
ca=2;
thresh(1:cndt, 1:ca)=10;
reversals(1:cndt, 1:ca)=0;
isreversals(1:cndt, 1:ca)=0;
%shouldn't 'thresh' start from 5 or 10 to allow for errors to move back along
%the fixedstepsizes?
staircounter(1:cndt, 1:ca)=0;
corrcounter(1:cndt, 1:ca)=0;

% Threshold -> 79%
sc.up = 1;                          % # of incorrect answers to go one step up
sc.down = 3;                        % # of correct answers to go one step down

max_transp=0.3; %could be the same as max_contrast if the performance between faces and gabors are
%similar
Contlist = log_unit_down(max_contrast, 0.05, 64);

stepsizes=[8 4 3 2 1];

%% gabor settings and fixation point

sigma_pix = sigma_deg*pix_deg;
imsize=sigma_pix*2.5;
[x,y]=meshgrid(-imsize:imsize,-imsize:imsize);
G = exp(-((x/sigma_pix).^2)-((y/sigma_pix).^2));
fixationlength = 10; % pixels
[r, c] = size(G);

%creating gabor images

rot=0*pi/180; %redundant but theoretically correct
maxcontrast=1; %same
for i=1:(length(sfs));
    f_gabor=(sfs(i)/pix_deg)*2*pi;
    a=cos(rot)*f_gabor;
    b=sin(rot)*f_gabor;
    m=maxcontrast*sin(a*x+b*y+phase(j)).*G;
    TheGabors(i)=Screen('MakeTexture', w, gray+inc*m,[],[],2);
end


%set the limit for stimuli position along x and y axis
xLim=((wRect(3)-(2*imsize))/pix_deg)/2;
yLim=((wRect(4)-(2*imsize))/pix_deg_vert)/2;

bg_index =round(gray*255); %background color

%circular mask
xylim = imsize; %radius of circular mask
circle = x.^2 + y.^2 <= xylim^2;
[nrw, ncl]=size(x);

%% main loop
HideCursor;
counter = 0;

WaitSecs(1);
% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
%     Screen('TextStyle', w, 1+2);
Screen('FillRect', w, gray);
colorfixation = white;
DrawFormattedText(w, 'Press Left key when tilted Left  \n \n Press Right key when tilted Right \n \n \n \n Press any key to start', 'center', 'center', white);
Screen('Flip', w);
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

xlocs=[-5 5];
ylocs=[0 0];
  %generate visual cue
    eccentricity_X=xlocs*pix_deg;
    eccentricity_Y=ylocs*pix_deg;
    imageRect = CenterRect([0, 0, size(x)], wRect);
    imageRect_offs{1} =[imageRect(1)+eccentricity_X(1), imageRect(2)+eccentricity_Y(1),...
        imageRect(3)+eccentricity_X(1), imageRect(4)+eccentricity_Y(1)];
    imageRect_offs{2} =[imageRect(1)+eccentricity_X(2), imageRect(2)+eccentricity_Y(2),...
        imageRect(3)+eccentricity_X(2), imageRect(4)+eccentricity_Y(2)];


RespType(1) = KbName('RightArrow');
RespType(2) = KbName('LeftArrow');

mixtr=randi(2,100,2);
for trial=1:length(mixtr)
    
    contr = Contlist(thresh(mixtr(trial,1),mixtr(trial,2)));
    
    if fixat==1;
        
        Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
        Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
        vbl = Screen('Flip', w); % show fixation
        WaitSecs(1);
    else
        vbl = Screen('Flip', w); % show fixation
        
        WaitSecs(1);
    end;
    %get the sf of the stimuli
    %  sf=conditionMat(mixtr(trial,1));
    sf=1;
    
    
    %%get the feature of the stimuli
    %     feat=conditionMat(mixtr(trial,1));%
    %contrast of the cue
    ContCirc= CircConts(1);
    
    
    
        cloc=mixtr(trial,1);
        tloc=mixtr(trial,2);
        ecc_x=xlocs(cloc);
  ecc_y=0;
        audiocue %generates audio cue
    
    theans(trial)=randi(2); %generates answer for this trial
        ori_i(trial)=2*theans(trial) +randi(2)-2;
        ori= theoris(ori_i(trial));
        texture(trial)=TheGabors(sf);

        
    priorityLevel=MaxPriority(w);
    
    % Presents Cue
    [vbl,cueonset]=Screen('Flip', w); %clear the screen
    %Fill the buffer and play our sound
    cueontime=vbl + (ifi * 0.5);
    % t1 = PsychPortAudio('Start', pahandle);
    PsychPortAudio('Start', pahandle,1,inf); %starts sound at infinity
    PsychPortAudio('RescheduleStart', pahandle, cueontime, 0) %reschedules startime to
    Screen('FrameOval', w,ContCirc, imageRect_offs{cloc}, oval_thick, oval_thick);
    vbl = Screen('Flip', w,cueontime);
    Screen('Flip', w,cueontime + cuedir);
    
    %Draw Target
    Screen('DrawTexture', w, texture(trial), [], imageRect_offs{tloc}, ori,[], contr );
    stim_start = Screen('Flip', w, vbl + SOA);
    KbQueueFlush()
    Priority(0);
    
    
    % collect the response
    [keyIsDown, keyCode] = KbQueueCheck;
    while keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0
        [keyIsDown, keyCode] = KbQueueCheck;
        WaitSecs(0.001); %Need this in the loop to avoid overloading the system
    end;
    thekeys = find(keyCode);
    thetimes=keyCode(thekeys);
    [secs  indfirst]=min(thetimes);
    
    
    Screen('Flip', w);
    %Screen('Close', texture);
    % code the response
    foo=(RespType==thekeys);
    
    staircounter(mixtr(trial,1),mixtr(trial,2))=staircounter(mixtr(trial,1),mixtr(trial,2))+1;
    Threshlist(mixtr(trial,1),mixtr(trial,2),staircounter(mixtr(trial,1),mixtr(trial,2)))=contr;
    
    
    
 

    if foo(theans(trial))
        resp = 1;
        corrcounter(mixtr(trial,1),mixtr(trial,2))=corrcounter(mixtr(trial,1),mixtr(trial,2))+1;
        PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
        if corrcounter(mixtr(trial,1),mixtr(trial,2))>=sc.down
            
            if isreversals(mixtr(trial,1),mixtr(trial,2))==1
                reversals(mixtr(trial,1),mixtr(trial,2))=reversals(mixtr(trial,1),mixtr(trial,2))+1;
                isreversals(mixtr(trial,1),mixtr(trial,2))=0;
            end
            thestep=max(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
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
        PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
        thestep=max(reversals(mixtr(trial,1),mixtr(trial,2))+1,length(stepsizes));
       thresh(mixtr(trial,1),mixtr(trial,2))=thresh(mixtr(trial,1),mixtr(trial,2)) -stepsizes(thestep);
        thresh(mixtr(trial,1),mixtr(trial,2))=max(thresh(mixtr(trial,1),mixtr(trial,2)),1);
    end
    
    PsychPortAudio('Start', pahandle);
    stim_stop=secs;
    time_stim(kk) = stim_stop - stim_start;
    totale_trials(kk)=trial;
    coordinatex(kk)=ecc_x;
    coordinatey(kk)=ecc_y;
    rispo(kk)=resp;
    feat(kk)=sf;
    contrcir(kk)=ContCirc;
    contrasto(kk)=contr;
    
    if closescript==1
        break;
    end;
    
    kk=kk+1;
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    
end;


DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
Screen('Flip', w);
KbWait;
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
thresho=permute(Threshlist,[3 1 2]);

%to get the final value for each staircase
final_threshold=thresho(10,1:length(thresho(1,:,1)),1:length(thresho(1,1,:)));
total_thresh= [final_threshold(:,:,1) final_threshold(:,:,2)];
%%
save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');


