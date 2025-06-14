%% general visual parameters

stimulusSize = str2double(tt.stimulus_size_crowding);% size of the stimulus in degrees of visual angle
PRLsize = 5; % diameter of the assigned PRL in degrees of visual angle
scotomadeg=10; % size of the scotoma in degrees of visual angle
oval_thick=3; %thickness of the TRL oval (value of the filloval function)


% possibleTRLlocations=[-7.5 7.5]; % possible TRL location with respect to the center of the screen in degrees of visual angle
% PRLecc=[possibleTRLlocations(TRLlocation) 0 ]; %eccentricity of PRL in deg

if SUBJECT(2) == 'm'
    % it's an MD subject, and we have to choose the PRL locations wisely
    % first, load the PRL locations:
    participantAssignmentTable = fullfile(cd, ['..\..\datafolder\MDParticipantAssignmentsUAB.csv']); % this is set for UCR or UAB separately (This is set here so that definesite.m does not have to change)
    temp= readtable(participantAssignmentTable);
    tt = temp(find(contains(temp.participant,SUBJECT)),:); % reads as a table or struct
    
    % The TRL for these participants is always 1, so that the PRL is the
    % first location listed below.
    PRLecc=str2double(tt.xTRL);
    xlocs=[str2double(tt.xTRL) str2double(tt.xURL2) str2double(tt.xURL2)];
    ylocs=[-str2double(tt.yTRL) -str2double(tt.yURL2) -str2double(tt.yURL2)];  % all the y locations are negative, because 0 is at the top of screen
    
    [theta rho] = cart2pol(xlocs, ylocs);
    %for prl
    if (mod(theta(1),(.5)*pi) < (1/3)*pi) && (mod(theta(1),(.5)*pi) > (1/6)*pi) %center wedge with mod of half pi
        fixation_location_prl = 2; %if point is within the x shape around the origin
    else
        fixation_location_prl = 1; %if point is within + shape around origin
    end
    %for url
    if (mod(theta(2),(.5)*pi) < (1/3)*pi) && (mod(theta(2),(.5)*pi) > (1/6)*pi) %center wedge with mod of half pi
        fixation_location_url = 2; %if point is within the x shape around the origin
    else
        fixation_location_url = 1; %if point is within + shape around origin
    end
    % also use general visual parameters consistent with MD participant
    scotomadeg=0.25; % scotoma size in deg
    %fixwindow=3;  % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)general visual parameters
    fixwindow = str2double(tt.fix_window); % variable per participant. usually 3
else
    %it's a healthy vision participant
    %% general visual parameters
    scotomadeg=10;  % scotoma size in deg noted for healthy
    fixwindow=3;  % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts) 
    PRLecc=7.5;         %%eccentricity of PRLs
    xlocs=[str2double(tt.xTRL) str2double(tt.xURL)];
    ylocs=[-str2double(tt.yTRL) -str2double(tt.yURL)]; 
end %different PRL locations for MD vs. control


%fixwindow=3; % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
scotoma_color=[200 200 200]; % color of the scotoma (light gray)
skipforcedfixation=0; %if we want to skip forced fixation for training type 1 and 2
fixdotcolor=[177 177 177]; % color of the fixation dot for training type 1 and 2 (4?)
fixdotcolor2=[0 0 0]; % color of the fixation dot for training type 4 when dot is outside the TRL
skipmasking=1; % if we want to allow masking of the target when it is not within the assigned PRL (default is no masking)
fixationlength=10; % if we don't want the scotoma (pixel size)
colorfixation = [200 200 200]; % if we don't want the scotoma
maskthickness = pix_deg*7.25;
%% general temporal parameters (trial events)

ITI=0.75; % time between beginning of trial and first event in the trial (fixations, cues or targets)
fixationduration=0.5; %duration of forced fixation period
postfixationblank=0.2;
ExoEndoCueDuration= [0.133 0.05]; % duration of exo/endo cue before target appearance for training type 3 and 4
postCueISI=0.1; % time interval between cue disappearance and next event (forced fixation before target appearance for training type 1 and 2)
forcedfixationISI=0; % ISI between end of forced fixation and stimulus presentation (training type 1 and 2) or flickering (training type 3 and 4)
stimulusduration= 0.2; %0.133; % stimulus duration during actual sessions
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
JitRat = 4;
% training type 3/4
updatecounter = 0; % starts the counter for the blocks in which we evaluate whether it's time to update the TRL size or the persistent flickering duration
holdtrial = 1; %for training type 3 and 4: we force a series of consecutive trials to be in the same location
annulusOrPRL = 2; % in training types in which we force fixation before target appearance, do we want fixation within an annulus (1) or within the assigned PRL (2)? default is PRL
timeflickerallowed=0.2; % time before flicker starts
flickerpersistallowed=0.2; % time away from flicker in which flicker persists
AnnulusTime = 2/3; %how long do they need to keep fixation near the pre-target element
Jitter = [3:0.05:7]/3; %flickering duration for task type 3 and 4
flickeringrate = 0.25; %rate of flickering (in seconds) for task type 3 and 4
coeffAdj=1; % size of the fixation window for training task 3 and 4 (100% of the TRL size, it is adaptive in training type 3) NOT FULLY IMPLEMENTED YET, DETAILS STILL TO BE DECIDED
CircConts=[0.51,1]*255; %low/high contrast circular cue
radius=12.5;   %radius of the circle in which the target can appear (training type 3 and 4)
cuecontrast=1; % contrast of the cue (0-1)
% trial type-specific time parameters
calibrationtolerance=2;
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

% Select specific text font, style and size:
% Screen('TextFont',w, 'Arial');
% Screen('TextSize',w, 42);
