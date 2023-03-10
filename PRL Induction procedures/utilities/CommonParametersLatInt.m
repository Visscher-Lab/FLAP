%% general visual parameters

PRLsize = 5; % diameter of the assigned PRL in degrees of visual angle

    scotomadeg=10; % size of the scotoma in degrees of visual angle
    stimulusSize = 2.5;% size of the stimulus in degrees of visual angle
   scotomarect = CenterRect([0, 0, scotomadeg*pix_deg, scotomadeg*pix_deg_vert], wRect); % destination rect for scotoma

oval_thick=3; %thickness of the TRL oval (value of the filloval function)
if exist('TRLlocation', 'var')
    possibleTRLlocations=[-7.5 7.5]; % possible TRL location with respect to the center of the screen in degrees of visual angle
PRLecc=[possibleTRLlocations(TRLlocation) 0 ]; %eccentricity of PRL in deg
end
maskthickness=pix_deg*6;
fixwindow=2; % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
scotoma_color=[200 200 200]; % color of the scotoma (light gray)
skipforcedfixation=0; %if we want to skip forced fixation for training type 1 and 2
fixdotcolor=[177 177 177]; % color of the fixation dot for training type 1 and 2 (4?)
fixdotcolor2=[0 0 0]; % color of the fixation dot for training type 4 when dot is outside the TRL
skipmasking=1; % if we want to allow masking of the target when it is not within the assigned PRL (default is no masking)
fixationlength=10; % if we don't want the scotoma (pixel size)
colorfixation = [200 200 200]; % if we don't want the scotoma
red=[255 0 0];



PRL_x_axis=-4;
PRL_y_axis=0;
NoPRL_x_axis=4;
NoPRL_y_axis=0;
flankersContrast=.6;

presentationtime=.333;
ISIinterval=0.5;

%% general temporal parameters (trial events)

ITI=0.75; % time interval between trial start and forced fixation period
fixationduration=0.5; %duration of forced fixation period
ISIinterval=0.5; % time interval between two stimulus intervals
forcedfixationISI=0; % ISI between end of forced fixation and stimulus presentation (training type 1 and 2) or flickering (training type 3 and 4)
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

dotsizedeg=0.5; % size of the fixation dot for Training type 1 and 2

%% gabor settings 
sf=3; %spatial frequency of the gabor
lambdaSeparation=4; %flankers distance in lamba (wavelength)
lambda=1/sf; %lamba (wavelength)
sigma_deg=lambda; % we set the sigma of the gabor to be equal to the inverse of spatial frequency (the wavelength)
sigma_pix = sigma_deg*pix_deg;
lambdadeg=lambdaSeparation*lambda*pix_deg;
imsize=sigma_pix*2.5; %Gabor mask (effective stimulus size)
[ax,ay]=meshgrid(-imsize:imsize,-imsize:imsize);
imageRect = CenterRect([0, 0, size(ax)], wRect); % initial destination rectangle for the target
imageRectDot = CenterRect([0, 0, dotsizedeg*pix_deg, dotsizedeg*pix_deg_vert], wRect); % destination rect for fixation dot training type 1 and 2
[xc, yc] = RectCenter(wRect);
fixwindowPix=fixwindow*pix_deg;
midgray=0.5;
ori=0; % Gaboer target orientation
