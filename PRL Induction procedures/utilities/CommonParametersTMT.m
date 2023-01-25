%% general visual parameters
%sets colors for stimuli
BackColor=255/2/255;
CircleColorOut=0;
CircleColorFill=BackColor;
CircleColorFillResp=17/255;
LetterColor=0;
LineColor=0;
%Adjusts to ppd, requires  width and distance to screen
center=[wRect(3)/2 wRect(4)/2];

fix_r=0.2;
ppd = round(pi * wRect(3) / atan(screencm(1)/v_d/2) / 360);
fix_cord = [center-fix_r*ppd center+fix_r*ppd];

%if mouse calibration is needed
MouseCalib=1;
xoff=1920; %ucr uses 1920, uab uses 0
Mscreen=[1920 1080];

%sets and saves the random seed
randseedvar=100*clock;
rand('twister',sum(randseedvar));


%sets stimulus details
textsize=20;
Screen('TextSize',w,textsize );
Csize=round(.75*ppd) ; %specifies radius of the circles in ppd
RespTol=3*ppd; %specifies radius of the circles in ppd





    scotomadeg=10; % size of the scotoma in degrees of visual angle
    stimulusSize = 2.5;% size of the stimulus in degrees of visual angle

oval_thick=3; %thickness of the TRL oval (value of the filloval function)

maskthickness=pix_deg*6;
fixwindow=2; % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
scotoma_color=[200 200 200]/255; % color of the scotoma (light gray)
skipforcedfixation=0; %if we want to skip forced fixation for training type 1 and 2
fixdotcolor=[177 177 177]; % color of the fixation dot for training type 1 and 2 (4?)
fixdotcolor2=[0 0 0]; % color of the fixation dot for training type 4 when dot is outside the TRL
skipmasking=1; % if we want to allow masking of the target when it is not within the assigned PRL (default is no masking)
fixationlength=10; % if we don't want the scotoma (pixel size)
colorfixation = [200 200 200]; % if we don't want the scotoma

%% general temporal parameters (trial events)
prefixationsquare=0.5;
preCueISI=0.75; % time between beginning of trial and first event in the trial (fixations, cues or targets)
ExoEndoCueDuration= [0.133 0.05]; % duration of exo/endo cue before target appearance for training type 3 and 4
postCueISI=0.1; % time interval between cue disappearance and next event (forced fixation before target appearance for training type 1 and 2)
forcedfixationISI=0; % ISI between end of forced fixation and stimulus presentation (training type 1 and 2) or flickering (training type 3 and 4)
AnnulusTime = 0.65; %how long do they need to keep fixation near the pre-target element
if exist('test', 'var')
    if test==1
        stimulusduration=2.133; % stimulus duration during debugging
    else
        stimulusduration=0.2; % stimulus duration during actual sessions
    end
end
trialTimeout = 8; % how long (seconds) should a trial last without a response
realtrialTimeout = trialTimeout; % used later for accurate calcuations (need to be updated after fixation criteria satisfied)
    
    eyetime2=0; % trial-based timer, will later be populated with eyetracker data 
    closescript=0; % to allow ESC use
    kk=1; % trial counter
%% training type-specific parameters

% training type 1
sigma_deg = stimulusSize/2.5; % sigma of the Gabor in degrees of visual angle
dotsizedeg=0.5; % size of the fixation dot for Training type 1 and 2

% training type 2
jitterCI=1; % jitter for countour stimuli of training type 2 and 4 (used to be 1)
possibleoffset=[-1:1]; %location offset for countour stimuli of training type 2 and 4
possibleoffset=[0]; %location offset for countour stimuli of training type 2 and 4
JitRat=2; % amount of jit ratio (the larger the value the less jitter)

% training type 3/4
updatecounter = 0; % starts the counter for the blocks in which we evaluate whether it's time to update the TRL size or the persistent flickering duration
holdtrial = 1; %for training type 3 and 4: we force a series of consecutive trials to be in the same location
annulusOrPRL = 2; % in training types in which we force fixation before target appearance, do we want fixation within an annulus (1) or within the assigned PRL (2)? default is PRL
timeflickerallowed=0.2; % time before flicker starts
flickerpersistallowed=0.2; % time away from flicker in which flicker persists
Jitter = [1:0.0167:2.3]; %flickering duration for task type 3 and 4
flickeringrate = 0.25; %rate of flickering (in seconds) for task type 3 and 4
coeffAdj=1; % size of the fixation window for training task 3 and 4 (100% of the TRL size, it is adaptive in training type 3) NOT FULLY IMPLEMENTED YET, DETAILS STILL TO BE DECIDED
CircConts=[0.51,1]*255; %low/high contrast circular cue
radius=12.5;   %radius of the circle in which the target can appear (training type 3 and 4)
cuecontrast=1; % contrast of the cue (0-1)
% trial type-specific time parameters
if exist('test', 'var')
    if trainingType==3 || trainingType==4
    framesbeforeflicker=timeflickerallowed/ifi; % frames before flicker starts
    blankframeallowed=flickerpersistallowed/ifi; % frames away from flicker in which flicker persists
    end
end
%% visual stimuli common parameters
imsize=(stimulusSize*pix_deg)/2; %Gabor mask (effective stimulus size)
[ax,ay]=meshgrid(-imsize:imsize,-imsize:imsize);
scotomarect = CenterRect([0, 0, scotomadeg*pix_deg, scotomadeg*pix_deg_vert], wRect); % destination rect for scotoma
imageRect = CenterRect([0, 0, size(ax)], wRect); % initial destination rectangle for the target
imageRectDot = CenterRect([0, 0, dotsizedeg*pix_deg, dotsizedeg*pix_deg_vert], wRect); % destination rect for fixation dot training type 1 and 2
[xc, yc] = RectCenter(wRect);
r_lim=((radius*pix_deg)-(imsize))/pix_deg; % visual space limits within which random locations are chosen
fixwindowPix=fixwindow*pix_deg;

midgray=0.5;

