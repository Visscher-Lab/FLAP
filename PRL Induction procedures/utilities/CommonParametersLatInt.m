%% general visual parameters

PRLsize = 5; % diameter of the assigned PRL in degrees of visual angle

scotomadeg=10; % size of the scotoma in degrees of visual angle
smallscotomadeg=1;
stimulusSize = 2.5;% size of the stimulus in degrees of visual angle
scotomarect = CenterRect([0, 0, scotomadeg*pix_deg, scotomadeg*pix_deg_vert], wRect); % destination rect for scotoma
smallscotomarect = CenterRect([0, 0, smallscotomadeg*pix_deg, smallscotomadeg*pix_deg_vert], wRect); % destination rect for scotoma

oval_thick=3; %thickness of the TRL oval (value of the filloval function)

maskthickness=pix_deg*1.85;
fixwindow=2; % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
scotoma_color=[200 200 200]; % color of the scotoma (light gray)
skipforcedfixation=0; %if we want to skip forced fixation for training type 1 and 2
fixdotcolor=[177 177 177]; % color of the fixation dot for training type 1 and 2 (4?)
fixdotcolor2=[0 0 0]; % color of the fixation dot for training type 4 when dot is outside the TRL
skipmasking=1; % if we want to allow masking of the target when it is not within the assigned PRL (default is no masking)
fixationlength=10; % if we don't want the scotoma (pixel size)
colorfixation = [200 200 200]; % if we don't want the scotoma
red=[255 0 0];

PRL_x_axis=-7.5;
PRL_y_axis=0;
NoPRL_x_axis=7.5;
NoPRL_y_axis=0;
flankersContrast=.6;
maxreversals=10;
%% general temporal parameters (trial events)

ITI=0.75; % time interval between trial start and forced fixation period
fixationduration=0.5; %duration of forced fixation period
forcedfixationISI=0; % ISI between end of forced fixation and stimulus presentation (training type 1 and 2) or flickering (training type 3 and 4)
if exist('test', 'var')
    if test==1
        presentationtime=2.133; % stimulus duration during debugging
        ISIinterval=0.5;
    else
        if  taskType==1
            presentationtime=0.2; % stimulus duration during actual sessions
            ISIinterval=0.5; % time interval between two stimulus intervals
        elseif  taskType==2
            presentationtime=0.05; % stimulus duration during actual sessions
            ISIinterval=0.3; % time interval between two stimulus intervals
        end
    end
end
trialTimeout = 8; % how long (seconds) should a trial last without a response
realtrialTimeout = trialTimeout; % used later for accurate calcuations (need to be updated after fixation criteria satisfied)

eyetime2=0; % trial-based timer, will later be populated with eyetracker data
closescript=0; % to allow ESC use
kk=1; % trial counter

dotsizedeg=0.5; % size of the fixation dot for Training type 1 and 2
dotsizedeg2=0.75; % size of the fixation dot ithin the Gabor in noise for Training type 2
fixwindowPix=fixwindow*pix_deg;

%% gabor settings
if taskType==1 % demo
    sf=6; %spatial frequency of the gabor
    lambdaSeparation=3; %flankers distance in lamba (wavelength)
    lambda=1/sf; %lamba (wavelength)
    sigma_deg=lambda; % we set the sigma of the gabor to be equal to the inverse of spatial frequency (the wavelength)
    lambdadeg=lambdaSeparation*lambda*pix_deg;
    ori=0; % Gaboer target orientation
    sigma_pix = sigma_deg*pix_deg;
    imsize=sigma_pix*2.5; %Gabor mask (effective stimulus size)
elseif  taskType==2 %noise
    sf=1; %spatial frequency of the gabor
    sigma_deg=2.5; % from Shibata et al. (2017)
    ori=30; % Gaboer target orientation
    sigma_pix = sigma_deg*pix_deg;
    contr  = 0.5;
    imsize=sigma_pix; %Gabor mask (effective stimulus size)
elseif  taskType==3 % ori
    sigma_deg=0.67; % from Wang et al. (2016)
        refOri=45;
    sigma_pix = sigma_deg*pix_deg;
    contr  = 0.5;
    imsize=sigma_pix; %Gabor mask (effective stimulus size)
elseif  taskType==4 % symmetrical dots
    refOri=deg2rad(135);
end
%
if test==1
    sf=1; %spatial frequency of the gabor
    lambdaSeparation=3; %flankers distance in lamba (wavelength)
    lambda=1/sf; %lamba (wavelength)
    sigma_deg=lambda; % we set the sigma of the gabor to be equal to the inverse of spatial frequency (the wavelength)
    lambdadeg=lambdaSeparation*lambda*pix_deg;
    ori=0; % Gaboer target orientation
    sigma_pix = sigma_deg*pix_deg;
    imsize=sigma_pix*2.5; %Gabor mask (effective stimulus size)
end

[ax,ay]=meshgrid(-imsize:imsize,-imsize:imsize);
imageRect = CenterRect([0, 0, size(ax)], wRect); % initial destination rectangle for the target
imageRectDot = CenterRect([0, 0, dotsizedeg*pix_deg, dotsizedeg*pix_deg_vert], wRect); % destination rect for fixation dot training type 1 and 2
imageRectDot2 = CenterRect([0, 0, dotsizedeg2*pix_deg, dotsizedeg2*pix_deg_vert], wRect); % destination rect for fixation dot within the Gabor in noise

[xc, yc] = RectCenter(wRect);
fixwindowPix=fixwindow*pix_deg;
midgray=0.5;



xlocs=[PRL_x_axis NoPRL_x_axis];
ylocs=[PRL_y_axis NoPRL_y_axis];


if TRLlocation ==1 % left only
    eccentricity_X=[xlocs(1)*pix_deg xlocs(1)*pix_deg];
    eccentricity_Y=[ylocs(1)*pix_deg ylocs(2)*pix_deg];
elseif TRLlocation ==2 %right only
    eccentricity_X=[xlocs(2)*pix_deg xlocs(2)*pix_deg];
    eccentricity_Y=[ylocs(1)*pix_deg ylocs(2)*pix_deg];
elseif TRLlocation ==3 % both sides
    eccentricity_X=[xlocs(1)*pix_deg xlocs(2)*pix_deg];
    eccentricity_Y=[ylocs(1)*pix_deg ylocs(2)*pix_deg];
end
%     if TargetLoc==2 % two sides
%         eccentricity_X=[xlocs(1)*pix_deg xlocs(2)*pix_deg];
%         eccentricity_Y=[ylocs(1)*pix_deg ylocs(2)*pix_deg];
%     elseif TargetLoc==4 % right only
%         eccentricity_X=[xlocs(2)*pix_deg xlocs(2)*pix_deg];
%         eccentricity_Y=[ylocs(1)*pix_deg ylocs(2)*pix_deg];
%     elseif TargetLoc==3 % left only
%         eccentricity_X=[xlocs(1)*pix_deg xlocs(1)*pix_deg];
%         eccentricity_Y=[ylocs(1)*pix_deg ylocs(2)*pix_deg];
%     elseif TargetLoc==1 % center
%         eccentricity_X=[0];
%         eccentricity_Y=[0];
%     end


% response settings

theintervals=[1 2]; % first or second interval? only for task 1 and 2, cause 3 and 4 we always compare the reference in thje first interval with the tagret in the second
plusminus= [-1 1]; % wheter we want the orientation offset in task 3 and 4 to be clockwise or counterclockwsie with respect to the reference
