%% general visual parameters
stimulusSize=3; %size of the stimulus (in degrees visual angle)
separationdeg=2; % distance among elements within each stimulus
triangleformation= 1; % three stimuli if 1, four stimuli if 0
randomfix = 0; %initial fixation in a random location
distancedeg=9; % distance among stimuli
PRLpossibleecc=[-7.5 7.5];
PRLecc=PRLpossibleecc(PRLlocations); %eccentricity of PRLs
PRLsize =5;  % diameter of the assigned PRL in degrees of visual angle

% if inductionType ==1
%     PRLxx=[0 PRLecc 0 -PRLecc];
%     PRLyy=[-PRLecc 0 PRLecc 0 ];
%     %    PRLxx=[0 2 0 -2];
%     %    PRLyy=[-2 0 2 0 ];
% else
%     PRLxx=0;
%     PRLyy=0;
% end

angolo=pi/2;

if TRLnumber==1
    PRLx=PRLecc;
    PRLy=0;
elseif TRLnumber==4
    PRLx=[0 PRLecc 0 -PRLecc];
    PRLy=[-PRLecc 0 PRLecc 0 ];
end

PRLxpix=PRLx*pix_deg;
PRLypix=PRLy*pix_deg;
oval_thick=5; %thickness of the TRL oval (value of the filloval function)
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

distances=round(distancedeg*pix_deg);
jitterAngle= [-35 35];
jitterDistanceDeg= [-9 1.5];
jitterDistance=jitterDistanceDeg*pix_deg;

%% general temporal parameters (trial events)
ITI= 0.75; %inter trial interval
postfixationISI=0.5; % interval between satisfied fxation constraints and target appearance
trialTimeout=15;    % max duration of each trial in seconds. If the participant doesn't respond, it assigns the response as wrong
actualtrialtimeout=trialTimeout;
preCueISIarray=[0 1.5 3 15]; % time between beginning of trial and first event in the trial (fixations, cues or targets)
ExoEndoCueDuration= [0.133 0.05]; % duration of exo/endo cue before target appearance for training type 3 and 4
postCueISI=0; % time interval between cue disappearance and next event (forced fixation before target appearance for training type 1 and 2)
stimulusduration= 0.2; %0.133; % stimulus duration
CueDuration=0.25;
poststimulustime=2.55;
eyetime2=0; % trial-based timer, will later be populated with eyetracker data
closescript=0; % to allow ESC use
kk=1; % trial counter
fixTime=1.5;
fixTime2=0.5;
%% assessment type-specific parameters
contr=0.5; % gabor contrast
sigma_deg = stimulusSize/2.5; % sigma of the Gabor in degrees of visual angle
dotsizedeg=0.5; % size of the fixation dot for Training type 1 and 2
spat_freq=4; % spatial frequency of the Gabor in the orientation discrimination task in dva

%% visual stimuli common parameters
imsize=(stimulusSize*pix_deg)/2; %Gabor mask (effective stimulus size)
[ax,ay]=meshgrid(-imsize:imsize,-imsize:imsize);
scotomarect = CenterRect([0, 0, scotomadeg*pix_deg, scotomadeg*pix_deg_vert], wRect); % destination rect for scotoma
imageRect = CenterRect([0, 0, size(ax)], wRect); % initial destination rectangle for the target
imageRectDot = CenterRect([0, 0, dotsizedeg*pix_deg, dotsizedeg*pix_deg_vert], wRect); % destination rect for fixation dot training type 1 and 2
[xc, yc] = RectCenter(wRect);
fixwindowPix=fixwindow*pix_deg;

radius = (scotomadeg*pix_deg)/2; %radius of circular mask
%    smallradius=(scotomasize(1)/2)+1.5*pix_deg;
% smallradius=radius+pix_deg/2 %+1*pix_deg;
[sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);

if inductionType == 1 % 1 = assigned, 2 = annulus
    radiusPRL=(PRLsize/2)*pix_deg;
    circlePixels=sx.^2 + sy.^2 <= radiusPRL.^2;
else
    smallradius=radiusPRL; %+pix_deg/2 %+1*pix_deg;
    radiusPRL=radiusPRL+3*pix_deg;
    
    circlePixels=sx.^2 + sy.^2 <= radiusPRL.^2;
    circlePixels2=sx.^2 + sy.^2 <= smallradius.^2;
    d=(circlePixels2==1);
    newfig=circlePixels;
    newfig(d==1)=0;
    circlePixels=newfig; %Marcello - what kind of shape is being created here? % this is the circular PRL region within which the target would be visible
    %later on in the code I 'move' it around with each PRL location and when it is aligned
    %with the target location,it shows the target.
    
end

imageRectcue = CenterRect([0, 0, [radiusPRL*2 ((radiusPRL/pix_deg)*pix_deg)*2]], wRect);
midgray=0.5;

% Select specific text font, style and size:
% Screen('TextFont',w, 'Arial');
% Screen('TextSize',w, 42);

trials=350;%500;