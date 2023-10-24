%% general visual parameters

stimulusSize = 2.5;% size of the stimulus in degrees of visual angle
PRLsize = 5; % diameter of the assigned PRL in degrees of visual angle
scotomadeg=10; % size of the scotoma in degrees of visual angle
oval_thick=3; %thickness of the TRL oval (value of the filloval function)
%possibleTRLlocations=[-7.5 7.5]; % possible TRL location with respect to the center of the screen in degrees of visual angle
%  PRLecc = [-7.5,0; 7.5,0];
LocX = [-7.5, 7.5];
LocY = [0, 0];
% PRLecc=[possibleTRLlocations(TRLlocation) 0 ]; %eccentricity of PRL in deg
fixwindow=2; % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
scotoma_color=[200 200 200]; % color of the scotoma (light gray)
skipforcedfixation=0; %if we want to skip forced fixation for training type 1 and 2
fixdotcolor=[177 177 177]; % color of the fixation dot for training type 1 and 2 (4?)
fixdotcolor2=[0 0 0]; % color of the fixation dot for training type 4 when dot is outside the TRL
skipmasking=1; % if we want to allow masking of the target when it is not within the assigned PRL (default is no masking)
fixationlength=10; % if we don't want the scotoma (pixel size)
colorfixation = [200 200 200]; % if we don't want the scotoma
maskthickness = pix_deg*6.25;
theoris =[-45 45];

%% general temporal parameters (trial events)
FlipInt=Screen('GetFlipInterval',w); %Gets Flip Interval. PD moved it to here from the main scrip 8/15/23
preCueISI=0;% time between beginning of trial and first event in the trial PD:It was 0.2, PD changed it to 0 8/15/23
postCueISI=0; % time interval between cue disappearance and next event (forced fixation before target appearance for training type 1 and 2) PD changed it to 0 8/15/23
StimulusDuration= round(0.200/FlipInt) *FlipInt; % stimulus duration, PD has changed it from 0.2 to this equation 8/15/23
% stimulusduration=StimulusDuration;
% StimulusDuration = 5;

CueDuration=0.25;
PostStimulusDuration=2.55;
%poststimulustime=PostStimulusDuration;
RestDuration=15;
eyetime2=0; % trial-based timer, will later be populated with eyetracker data
closescript=0; % to allow ESC use
kk=1; % trial counter
%% TTL counts
k=1;% number of TTLs during active block
    kr=1; %number of TTLs during rest block
    j=1; % number of TTLs recorded in the whole session
    jr=1; %number of TTLs recorded during rests
%% assessment type-specific parameters
% type 1
contr=0.5; % gabor contrast
sigma_deg = stimulusSize/2.5; % sigma of the Gabor in degrees of visual angle
dotsizedeg=0.5; % size of the fixation dot for Training type 1 and 2
spat_freq=4; % spatial frequency of the Gabor in the orientation discrimination task in dva

% type 2
jitterCI=1; % jitter for countour stimuli of training type 2 and 4
possibleoffset=[-1:1]; %location offset for countour stimuli of training type 2 and 4
JitRat = 4;
Orijit=0;
Tscat=0;
shapeMat(:,1)= [7 1];
    
%% visual stimuli common parameters
imsize=(stimulusSize*pix_deg); %Gabor mask (effective stimulus size)
[ax,ay]=meshgrid(-imsize:imsize,-imsize:imsize);
scotomarect = CenterRect([0, 0, scotomadeg*pix_deg, scotomadeg*pix_deg_vert], wRect); % destination rect for scotoma
imageRect = CenterRect([0, 0, size(ax)], wRect); % initial destination rectangle for the target
imageRectDot = CenterRect([0, 0, dotsizedeg*pix_deg, dotsizedeg*pix_deg_vert], wRect); % destination rect for fixation dot training type 1 and 2
[xc, yc] = RectCenter(wRect);
fixwindowPix=fixwindow*pix_deg;

midgray=0.5;

% Select specific text font, style and size:
% Screen('TextFont',w, 'Arial');
% Screen('TextSize',w, 42);


% Trial structure

 activeblocktype=[1 2 4 3 1;1 4 2 1 3;2 1 3 4 1;2 4 3 1 1;3 2 4 1 1;3 4 1 2 1;3 1 2 4 1;1 3 4 2 1];
 %1 for gabors, 2 for Egg-CI stimulus, 3 for 6/9-CI stimulus, 4 for rest


interTrialIntervals{1}=[0 0 1 0 1 2 1 2 0 0 2 1 0 0 1 0;1 1 0 0 2 1 0 2 0 1 2 0 0 1 0 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 1 0 0 2 1 0 1 2 0 1 2 0 1 0 0;1 0 1 0 0 2 0 1 2 0 2 1 0 0 0 1];
interTrialIntervals{2}=[0 1 0 0 2 1 0 2 1 0 2 0 0 1 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 0 1 0 1 2 1 2 0 0 2 1 0 0 1 0;0 1 1 0 0 2 0 1 2 1 2 0 0 1 0 0;1 0 1 0 0 1 2 0 2 0 2 1 0 0 1 0];
interTrialIntervals{3}=[0 1 1 0 0 2 0 1 2 1 2 0 0 1 0 0;0 0 1 0 1 2 1 2 0 0 2 1 0 1 0 0;0 1 0 0 2 1 0 2 1 0 2 0 0 1 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 1 0 0 2 1 0 2 0 1 2 0 0 1 0 0];
interTrialIntervals{4}=[1 0 1 0 0 1 2 0 2 0 2 1 0 0 1 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 0 0 1 0 2 1 0 2 2 0 1 0 1 0 0;1 0 1 2 0 1 0 2 1 0 2 0 1 0 0 0;0 1 0 1 2 0 1 2 1 0 2 0 0 1 0 0];
interTrialIntervals{5}=[1 1 0 1 0 1 2 0 0 1 2 0 2 0 0 0;0 0 1 0 1 2 1 2 0 0 1 2 0 0 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 0 1 2 0 1 0 2 1 0 2 0 1 0 0 0;1 0 0 1 0 2 1 0 2 2 0 1 0 1 0 0];
interTrialIntervals{6}=[1 0 1 0 0 2 0 1 2 0 2 1 0 0 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 1 1 0 0 2 0 1 2 1 2 0 0 1 0 0;1 0 0 1 0 2 1 0 2 0 2 1 0 0 1 0;0 1 0 0 2 1 0 1 2 0 1 2 0 0 0 1];
interTrialIntervals{7}=[0 1 0 0 2 1 0 1 2 0 1 2 0 1 0 0;0 1 0 1 2 0 1 2 1 0 2 0 0 1 0 0;1 1 0 1 0 1 2 0 0 1 2 0 2 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 0 0 2 1 0 2 0 1 2 0 0 1 0 0 1];
interTrialIntervals{8}=[1 1 0 0 2 1 0 2 0 1 2 0 0 1 0 0;1 0 1 0 0 1 2 0 2 0 2 1 0 0 1 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 1 0 0 2 1 0 2 1 0 2 0 0 1 0 1;0 0 1 0 1 2 1 2 0 0 2 1 0 0 1 0];
