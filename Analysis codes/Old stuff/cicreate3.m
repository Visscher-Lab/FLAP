% Contrast threshold measurement with randomized position of the target -
% wait until response
close all; clear all; clc;
commandwindow


prompt={'File Name'};

name= 'File Name';
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
baseName=['./data/' SUBJECT '_CI_shapes_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename

Screen('Preference', 'SkipSyncTests', 1);
% PC=getComputerName();
max_contrast=.8;
n_blocks=2;
reps=10;
        screencm=[40.6 30];
v_d=57;
sigma_deg = .1; %4;
sfs=6;
BITS=0; %0;

cuedir=.05;
oval_thick=10; %thickness of oval


KbQueueCreate;
KbQueueStart;


if ispc
    escapeKey = KbName('esc');	% quit key
elseif ismac
    escapeKey = KbName('ESCAPE');	% quit key
end
try
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
    %[w, wRect]=PsychImaging('OpenWindow',screenNumber, 0,[],32,2);
    %debug window
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640 480],32,2);
    %ScreenParameters=Screen('Resolution', screenNumber); %close all
    %struct.res=[ScreenParameters.width ScreenParameters.height];
    Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
    Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT
end;
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
struct.res=[1024 768];
struct.sz=[screencm(1), screencm(2)];

pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi));
pix_deg_vert=1./((2*atan((screencm(2)/wRect(4))./(2*v_d))).*(180/pi));

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
    m=maxcontrast*sin(a*x+b*y+pi).*G;
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
Screen('TextSize',w, 24);
%     Screen('TextStyle', w, 1+2);
Screen('FillRect', w, gray);
colorfixation = white;
% DrawFormattedText(w, 'Press Left key when tilted Left  \n \n Press Right key when tilted Right \n \n \n \n Press any key to start', 'center', 'center', white);
Screen('Flip', w);
% KbQueueWait;
Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
Screen('Flip', w);
% KbWait;
Screen('Flip', w);
%possible orientations
% theoris=[22.5 67.5 -22.5 -67.5 ];
theoris=[22.5 45 -22.5 -45  ];


[x1,y1]=meshgrid(-8:8,-6:6);


xlocs=x1(:)';
ylocs=y1(:)';
%generate visual cue
eccentricity_X=xlocs*pix_deg;
eccentricity_Y=ylocs*pix_deg;
imageRect = CenterRect([0, 0, size(x)], wRect);
%     for i=1:length(xlocs)
imageRect_offs =[imageRect(1)+eccentricity_X', imageRect(2)+eccentricity_Y',...
    imageRect(3)+eccentricity_X', imageRect(4)+eccentricity_Y'];
%     end
Ex=eccentricity_X+wRect(3)/2;
Ey=eccentricity_Y+wRect(4)/2;

RespType(1) = KbName('RightArrow');
RespType(2) = KbName('LeftArrow');

AdjustType(1) = KbName('RightArrow');
AdjustType(2) = KbName('LeftArrow');
AdjustType(3) = KbName('UpArrow');
AdjustType(4) = KbName('DownArrow');
AdjustType(5) = KbName('a');
AdjustType(6) = KbName('s');
AdjustType(7) = KbName('Delete');
AdjustType(8) = KbName('Space');
Return=KbName('Return');
mixtr=randi(2,100,2);


lr=2;
cc=3;
tr=5;

%stmloc cueloc
trmat1=[repmat([1],1,2*tr)' repmat(ceil((1:lr)),1, tr)'];
trmat2=[repmat(2:lr +1,1,cc*tr)' repmat(ceil((1:(cc*lr))/lr),1, tr)'];

mixtr = [trmat1(randperm(length(trmat1)),:) ; trmat2(randperm(length(trmat2)),:)] ;
blocksize=length(mixtr)/4; % stimulus presentations per block
response=zeros(length(mixtr),2)-1; %intialize response matrix with -1

[keyIsDown, keyCode] = KbQueueCheck;
trial=0;

yfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  ];
xfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  ];
orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90] ;

Xoff= [0 0 0 pix_deg/4 -pix_deg/4 0 0 pix_deg/4 -pix_deg/4 0 0 0     0 0  -pix_deg/4 0 0]
Yoff= [pix_deg/4 0 pix_deg/4 0 0  0 0   0 0  -pix_deg/4 0 -pix_deg/4 0 0 0 -pix_deg/4 0]

for kk=1:length(orifoo)
    GL=find(x1==xfoo(kk) & y1==yfoo(kk))
       TheTargetloc(GL,:) =[imageRect(1)+eccentricity_X(GL)+Xoff(kk), imageRect(2)+eccentricity_Y(GL)+Yoff(kk),...
                    imageRect(3)+eccentricity_X(GL)+Xoff(kk), imageRect(4)+eccentricity_Y(GL)+Yoff(kk)];  
TheTargetori(GL,:)=orifoo(kk)
end

 keyCode=zeros(size(keyCode));
        while any(keyCode(escapeKey))== 0
    
  trial=trial+1;
    
    
    contr = 1;%Contlist(thresh(mixtr(trial,1),mixtr(trial,2)));

    %get the sf of the stimuli
    %  sf=conditionMat(mixtr(trial,1));
    sf=1;
    
    
    %%get the feature of the stimuli
    %     feat=conditionMat(mixtr(trial,1));%
    %contrast of the cue
    
    
    theans(trial)=randi(2); %generates answer for this trial
    ori_i(trial)=2*theans(trial) +randi(2)-2;
    ori= theoris(ori_i(trial));
    texture(trial)=TheGabors(sf);
    
    
    priorityLevel=MaxPriority(w);
   
    
        %         maketarget=1;
        %     end
        %     if maketarget==1
        ShowCursor
%         TheTargetloc=zeros(size(imageRect_offs));
%         TheTargetori=zeros(1,length(imageRect_offs));
%         
        [keyIsDown, keyCode] = KbQueueCheck;
        MousePress=0; %initializes flag to indicate no response
        curo=1
        while (any(keyCode(Return))== 0 & any(keyCode(escapeKey))== 0)
            curo=curo+1;
            [keyIsDown, keyCode] = KbQueueCheck;
            [x,y,buttons]=GetMouse();  %waits for a key-press
            MousePress=any(buttons); %sets to 1 if a button was pressed
            if MousePress
                GL=find((Ex-pix_deg/2)<x & (Ex+pix_deg/2)>x & (Ey-pix_deg/2)<y & (Ey+pix_deg/2)>y );
                TheRect=[(Ex(GL)-pix_deg/2) (Ey(GL)-pix_deg/2) (Ex(GL)+pix_deg/2) (Ey(GL)+pix_deg/2)];
                r=1;
                ciro=1
            elseif keyCode(AdjustType(1))
                TheTargetloc(GL,:)=TheTargetloc(GL,:) + [1 0 1 0];
            elseif keyCode(AdjustType(2))
                TheTargetloc(GL,:)=TheTargetloc(GL,:) - [1 0 1 0];
            elseif keyCode(AdjustType(3))
                TheTargetloc(GL,:)=TheTargetloc(GL,:) - [0 1 0 1];
            elseif keyCode(AdjustType(4))
                TheTargetloc(GL,:)=TheTargetloc(GL,:) + [0 1 0 1];
            elseif keyCode(AdjustType(5))
                coro=1;
                TheTargetori(GL)=TheTargetori(GL) -5;
            elseif keyCode(AdjustType(6))
                core=1;
                TheTargetori(GL)=TheTargetori(GL) +5;
            elseif keyCode(AdjustType(7))
                TheTargetloc(GL,:)=[0 0 0 0];
            elseif keyCode(AdjustType(8))
                imagearray{trial}=Screen('GetImage', w)
                TheTargetloc(GL,:) =[imageRect(1)+eccentricity_X(GL), imageRect(2)+eccentricity_Y(GL),...
                    imageRect(3)+eccentricity_X(GL), imageRect(4)+eccentricity_Y(GL)];                
                OriginalTheTargetloc(GL,:) =[imageRect(1)+eccentricity_X(GL), imageRect(2)+eccentricity_Y(GL),...
                    imageRect(3)+eccentricity_X(GL), imageRect(4)+eccentricity_Y(GL)];
            end
            if r==1
                Screen('FrameRect', w,[1], round(TheRect));
            end
Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);

Screen('DrawText', w, 'Make your pattern, click select, space to appear, delete to delete, arrows to move, a s to rotate, return to accept', 0, 0, 255);
Screen('DrawText', w, 'return to accept, escape when finished with last one', 0, 50, 255);
            Screen('DrawTextures', w, texture(trial), [], TheTargetloc' , TheTargetori,[], contr );
            Screen('Flip', w)
        end
        
        
        
        TC{trial}=find(TheTargetloc(:,1));
        TCloc{trial}=TheTargetloc(TheTargetloc(:,1)>1,:);
        OriginalTCloc{trial}=OriginalTheTargetloc(TheTargetloc(:,1)>1,:);
                OriginalTClocdeg{trial}=OriginalTheTargetloc(TheTargetloc(:,1)>1,:)/pix_deg;
        DC{trial}=find(TheTargetloc(:,1)==0);
        % orientation of the target Gabors
        TO{trial}=TheTargetori(find(TheTargetloc(:,1)));

      diffmat{trial}=OriginalTCloc{1}-TCloc{1};
      diffmatdeg{trial}=diffmat{trial}/pix_deg;
    Priority(0);
             %                
xx{trial}=((OriginalTCloc{trial}(:,3)+OriginalTCloc{trial}(:,1))/2)-(wRect(3)/2)';
yy{trial}=((OriginalTCloc{trial}(:,4)+OriginalTCloc{trial}(:,2))/2)-(wRect(4)/2)';
% target coordinates in deg (spacein the grid)
Targx{trial}=round(xx{trial}/pix_deg)';
Targy{trial}=round(yy{trial}/pix_deg)';

% offset to add as jitter to draw the smooth figure (offset in proportion
% of grid length to be added as x and y to each target element)
%offsetMatrix=diffmatdeg{trial};
offsetx{trial}=diffmatdeg{trial}(:,1)';
offsety{trial}=diffmatdeg{trial}(:,2)';

    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    
end;

% wde=OriginalTCloc{1};
% wx=((wde(:,3)+wde(:,1))/2)-(wRect(3)/2);
% wy=((wde(:,4)+wde(:,2))/2)-(wRect(4)/2);
% wTargx=round(wx/pix_deg)';
% wTargy=round(wy/pix_deg)';
% 
% 
% woffsetMatrix=diffmatdeg{1};
% woffsetx=woffsetMatrix(:,1)';
% woffsety=woffsetMatrix(:,2)';
% woritarg=TO{1};

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
    
else
    Screen('Preference', 'SkipSyncTests', 0);
    Screen('LoadNormalizedGammaTable', w , (linspace(0,1,256)'*ones(1,3)));
    Screen('Flip', w);
    Screen('CloseAll');
end;

%%
save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');

catch ME
    psychlasterror()
end

% yfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  ];
% 
% xfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  ];
% 
% orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90] ;
% 
%  
% 
% Xoff= [0 0 0 pix_deg/4 -pix_deg/4 0 0 pix_deg/4 -pix_deg/4 0 0 0     0 0  -pix_deg/4 0 0]
% 
% Yoff= [pix_deg/4 0 pix_deg/4 0 0  0 0   0 0  -pix_deg/4 0 -pix_deg/4 0 0 0 -pix_deg/4 0]

