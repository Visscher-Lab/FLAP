%% general visual parameters

stimulusSize = 2.5;% size of the stimulus in degrees of visual angle
PRLsize = 5; % diameter of the assigned PRL in degrees of visual angle
scotomadeg=10; % size of the scotoma in degrees of visual angle
oval_thick=3; %thickness of the TRL oval (value of the filloval function)
possibleTRLlocations=[-7.5 7.5]; % possible TRL location with respect to the center of the screen in degrees of visual angle
PRLecc=[possibleTRLlocations(TRLlocation) 0 ]; %eccentricity of PRL in deg
fixwindow=2; % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
scotoma_color=[200 200 200]; % color of the scotoma (light gray)
skipforcedfixation=0; %if we want to skip forced fixation for training type 1 and 2
fixdotcolor=[177 177 177]; % color of the fixation dot for training type 1 and 2 (4?)
fixdotcolor2=[0 0 0]; % color of the fixation dot for training type 4 when dot is outside the TRL
skipmasking=1; % if we want to allow masking of the target when it is not within the assigned PRL (default is no masking)
fixationlength=10; % if we don't want the scotoma (pixel size)
colorfixation = [200 200 200]; % if we don't want the scotoma

%% general temporal parameters (trial events)

preCueISI=0.75; % time between beginning of trial and first event in the trial (fixations, cues or targets)
ExoEndoCueDuration= [0.133 0.05]; % duration of exo/endo cue before target appearance for training type 3 and 4
postCueISI=0.1; % time interval between cue disappearance and next event (forced fixation before target appearance for training type 1 and 2)
forcedfixationISI=0; % ISI between end of forced fixation and stimulus presentation (training type 1 and 2) or flickering (training type 3 and 4)

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
jitterCI=1; % jitter for countour stimuli of training type 2 and 4
possibleoffset=[-1:1]; %location offset for countour stimuli of training type 2 and 4


%% visual stimuli common parameters
imsize=(stimulusSize*pix_deg)/2; %Gabor mask (effective stimulus size)
[ax,ay]=meshgrid(-imsize:imsize,-imsize:imsize);
scotomarect = CenterRect([0, 0, scotomadeg*pix_deg, scotomadeg*pix_deg_vert], wRect); % destination rect for scotoma
imageRect = CenterRect([0, 0, size(ax)], wRect); % initial destination rectangle for the target
imageRectDot = CenterRect([0, 0, dotsizedeg*pix_deg, dotsizedeg*pix_deg_vert], wRect); % destination rect for fixation dot training type 1 and 2
[xc, yc] = RectCenter(wRect);
%r_lim=((radius*pix_deg)-(imsize))/pix_deg; % visual space limits within which random locations are chosen
fixwindowPix=fixwindow*pix_deg;

midgray=0.5;

% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
    %% scanner task related variables
    startdatetime = datestr(now); %Current date and time as date vector. [year month day hour minute seconds]
    interTrialIntervals1=[1 4 1 2 7 2 2 8 2 1; 3 7 1 1 3 4 1 4 5 1; 1 5 3 1 7 1 3 1 6 2; 2 5 1 2 1 8 3 4 1 3];
    interTrialIntervals2=[4 1 1 2 8 2 3 1 6 2; 1 7 1 5 2 2 3 2 6 1; 2 1 5 2 8 1 3 4 2 2; 3 1 7 2 6 2 1 4 2 2];
    activeblockcue=[2 2 1 2 1 1 2 2 2 1; 1 1 2 1 2 2 1 2 2 1; 1 1 2 2 2 1 2 1 1 1; 1 2 2 1 1 2 1 2 1 2]; %attention location (cue direction) 1:left, 2:right
    activeblockstimulus1=[2 1;1 1;2 2;2 2;1 2;2 1;1 2;2 2;1 2;2 2];activeblockstimulus2=[2 1;1 2;2 1;2 1;1 1;1 2;1 1;1 1;1 1;2 1];activeblockstimulus3=[1 2;1 1;2 2;2 1;2 2;2 2;1 2;2 1;2 2;1 2];activeblockstimulus4=[1 1;1 2;1 2;2 1;1 2;2 1;1 2;2 2;1 1;2 1];%orientation of gabors/6 or 9 for left and right stimuli
    activeblocktype=[2 2 2 1;2 2 1 1;2 1 2 1;2 1 1 2;1 1 2 2]; %1 for gabors 2 for CI stimulus
    totalactiveblock=4;
    TR=1.5;
    totaltrialtime=TR*2;