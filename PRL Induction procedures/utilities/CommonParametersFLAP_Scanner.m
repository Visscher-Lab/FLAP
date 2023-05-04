%% general visual parameters

stimulusSize = 3.25; %2.5;% size of the stimulus in degrees of visual angle
PRLsize = 6.5; %5; % diameter of the assigned PRL in degrees of visual angle
oval_thick=3;
possibleTRLlocations=[-7.5 7.5]; % possible TRL location with respect to the center of the screen in degrees of visual angle
PRLecc=[possibleTRLlocations(TRLlocation) 0 ]; %eccentricity of PRL in deg

%% general temporal parameters (trial events)
maskthickness=pix_deg*6;
scotomadeg=10; % size of the scotoma in degrees of visual angle
closescript=0; % to allow ESC use
kk=1; % trial counter
%% training type-specific parameters

% training type 1
sigma_deg = stimulusSize/2.5; % sigma of the Gabor in degrees of visual angle
%dotsizedeg=0.5; % size of the fixation dot for Training type 1 and 2

% training type 2
jitterCI=0; % jitter for countour stimuli of training type 2 and 4
possibleoffset=[-1:1]; %location offset for countour stimuli of training type 2 and 4
possibleoffset=[0];

%% visual stimuli common parameters
imsize=(stimulusSize*pix_deg)/2; %Gabor mask (effective stimulus size)
[ax,ay]=meshgrid(-imsize:imsize,-imsize:imsize);
%scotomarect = CenterRect([0, 0, scotomadeg*pix_deg, scotomadeg*pix_deg_vert], wRect); % destination rect for scotoma
imageRect = CenterRect([0, 0, size(ax)], wRect); % initial destination rectangle for the target
%imageRectDot = CenterRect([0, 0, dotsizedeg*pix_deg, dotsizedeg*pix_deg_vert], wRect); % destination rect for fixation dot training type 1 and 2
[xc, yc] = RectCenter(wRect);
%r_lim=((radius*pix_deg)-(imsize))/pix_deg; % visual space limits within which random locations are chosen
%fixwindowPix=fixwindow*pix_deg;

midgray=0.5;

% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
%% scanner task related variables
startdatetime = datestr(now); %Current date and time as date vector. [year month day hour minute seconds]
interTrialIntervals1=[0 0 1 0 1 2 1 2 0 0 2 1 0 0 1 0;1 1 0 0 2 1 0 2 0 1 2 0 0 1 0 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 1 0 0 2 1 0 1 2 0 1 2 0 1 0 0;1 0 1 0 0 2 0 1 2 0 2 1 0 0 0 1];
interTrialIntervals2=[0 1 0 0 2 1 0 2 1 0 2 0 0 1 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 0 1 0 1 2 1 2 0 0 2 1 0 0 1 0;0 1 1 0 0 2 0 1 2 1 2 0 0 1 0 0;1 0 1 0 0 1 2 0 2 0 2 1 0 0 1 0];
interTrialIntervals3=[0 1 1 0 0 2 0 1 2 1 2 0 0 1 0 0;0 0 1 0 1 2 1 2 0 0 2 1 0 1 0 0;0 1 0 0 2 1 0 2 1 0 2 0 0 1 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 1 0 0 2 1 0 2 0 1 2 0 0 1 0 0];
interTrialIntervals4=[1 0 1 0 0 1 2 0 2 0 2 1 0 0 1 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 0 0 1 0 2 1 0 2 2 0 1 0 1 0 0;1 0 1 2 0 1 0 2 1 0 2 0 1 0 0 0;0 1 0 1 2 0 1 2 1 0 2 0 0 1 0 0];
interTrialIntervals5=[1 1 0 1 0 1 2 0 0 1 2 0 2 0 0 0;0 0 1 0 1 2 1 2 0 0 1 2 0 0 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 0 1 2 0 1 0 2 1 0 2 0 1 0 0 0;1 0 0 1 0 2 1 0 2 2 0 1 0 1 0 0];
interTrialIntervals6=[1 0 1 0 0 2 0 1 2 0 2 1 0 0 0 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 1 1 0 0 2 0 1 2 1 2 0 0 1 0 0;1 0 0 1 0 2 1 0 2 0 2 1 0 0 1 0;0 1 0 0 2 1 0 1 2 0 1 2 0 0 0 1];
interTrialIntervals7=[0 1 0 0 2 1 0 1 2 0 1 2 0 1 0 0;0 1 0 1 2 0 1 2 1 0 2 0 0 1 0 0;1 1 0 1 0 1 2 0 0 1 2 0 2 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 0 0 2 1 0 2 0 1 2 0 0 1 0 0 1];
interTrialIntervals8=[1 1 0 0 2 1 0 2 0 1 2 0 0 1 0 0;1 0 1 0 0 1 2 0 2 0 2 1 0 0 1 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;0 1 0 0 2 1 0 2 1 0 2 0 0 1 0 1;0 0 1 0 1 2 1 2 0 0 2 1 0 0 1 0];
%interTrialIntervals2=[3 1 3 1 5 2 1 4 1 7 1 4;0 0 0 0 0 0 0 0 0 0 0 0;2 6 1 3 2 1 7 1 5 1 %1% 3;0 0 0 0 0 0 0 0 0 0 0 0; 3 4 2 %5% 6 1 8 3 2 1 2 1];
%interTrialIntervals6=[1 4 3 1 5 2 1 4 %1% 7 1 3;0 0 0 0 0 0 0 0 0 0 0 0; 3 1 7 1 2 3 6 1 5 1 2 2;0 0 0 0 0 0 0 0 0 0 0 0; 2 8 3 1 4 2 1 3 6 1 2 1];
%intreTrialInterval8=[0 0 0 0 0 0 0 0 0 0 0 0; 5 1 3 1 4 3 1 2 7 1 2 4; 2 1 6 3 1 8 3 2 1 4 2 1;0 0 0 0 0 0 0 0 0 0 0 0;3 4 2 %5% 6 1 8 3 2 1 2 1];

activeblockcue1=[2 1 2 1 1 2 1 1 2 2 2 1 1 2 2 1;1 1 2 1 1 2 1 2 1 1 2 1 2 2 2 2;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;2 1 2 1 2 1 2 1 1 2 1 2 2 1 1 2;1 2 1 1 1 2 2 1 2 2 1 1 2 2 1 2]; %attention location (cue direction) 1:left, 2:right
activeblockcue2=[2 1 1 2 1 2 2 1 1 2 1 2 2 1 1 2;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;2 2 1 1 2 1 2 2 1 1 2 1 1 2 1 2;2 1 1 2 2 1 1 1 2 1 2 1 2 1 2 2;1 2 2 2 1 2 1 1 2 2 2 1 1 1 2 1]; %attention location (cue direction) 1:left, 2:right
activeblockcue3=[1 1 2 1 2 2 1 1 1 2 2 1 2 1 1 2;2 1 1 1 2 1 2 1 1 2 2 1 2 1 2 2;1 2 1 2 2 2 1 2 2 1 1 1 1 2 1 2;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;2 1 2 1 2 2 2 1 1 2 2 1 1 2 1 1]; %attention location (cue direction) 1:left, 2:right
activeblockcue4=[2 1 1 2 1 2 1 2 2 2 1 2 1 2 1 2;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;2 1 2 2 2 1 1 2 2 1 2 1 1 2 1 1;1 1 2 2 1 1 2 2 2 1 1 1 2 1 2 2;2 1 2 2 2 2 1 2 1 1 1 1 2 1 2 1]; %attention location (cue direction) 1:left, 2:right
activeblockcue5=[2 2 1 2 1 1 1 2 2 2 1 1 2 2 1 1;1 2 2 2 1 1 2 1 2 1 1 1 2 2 1 2;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;2 2 1 1 2 1 1 2 1 1 2 2 1 2 2 1;1 2 2 2 1 1 2 1 1 2 1 1 2 1 2 2]; %attention location (cue direction) 1:left, 2:right
activeblockcue6=[2 1 2 2 1 1 1 2 2 2 1 2 1 1 1 2;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 1 2 1 2 2 1 2 2 2 1 2 1 1 1 2;1 2 2 2 1 1 2 2 1 2 1 1 2 1 1 2;2 2 1 2 1 2 1 2 1 1 2 1 1 2 2 1]; %attention location (cue direction) 1:left, 2:right
activeblockcue7=[1 1 1 2 2 1 2 1 2 2 1 2 2 1 1 2;2 2 1 1 2 1 1 1 2 1 2 1 2 2 1 2;2 1 1 2 2 1 2 2 1 2 1 1 1 1 2 2;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 2 2 2 1 2 2 1 2 1 1 2 1 2 1 1]; %attention location (cue direction) 1:left, 2:right
activeblockcue8=[1 1 2 1 2 1 2 2 2 1 2 1 1 2 2 1;2 1 1 1 2 1 2 2 1 1 2 2 2 1 2 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;1 2 1 1 2 1 2 1 1 2 1 2 2 1 2 2;2 1 1 2 2 1 1 2 1 2 1 1 2 1 2 2];
activeblockstimulus1=[2 1;2 2;1 1;2 2;1 2;1 2;2 1;1 1;2 2;2 1;1 2;1 1;2 1; 1 1;2 2;1 2;2 2;1 2;1 1;2 1;2 2;1 1;1 2;2 2;2 1;1 1;1 2;1 1;2 2;2 1;2 1;1 2;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;1 2;1 1;2 2;1 1;2 1;2 2;1 1;2 2;1 2;1 2;2 1;1 1;2 2;2 1;1 2;2 1;2 2;2 1;1 2;2 1;1 1;2 1;2 2;1 2;1 1;1 2;2 1;1 1;2 2;1 2;2 2;1 1];activeblockstimulus2=[1 1;2 2;1 2;1 2;2 2;1 1;1 2;1 1;2 1;2 2;1 2;2 1;2 2;1 1;2 1;2 1;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;2 1;2 2;1 1;2 1;2 2;1 2;1 1;1 2;1 1;2 1;1 2;2 2;1 2;1 1;2 2;2 1;1 2;1 1;1 2;2 2;1 1;2 1;1 1;2 1;1 2;1 2;2 1;2 2;1 1;2 2;2 1;2 2;2 2;1 1;2 1;2 2;2 1;1 2;1 1;1 2;2 2;1 2;2 1;1 2;2 2;1 1;1 1;2 1];activeblockstimulus3=[1 2;2 2;1 1;2 1;1 2;2 2;1 1;2 1;1 2;2 2;2 1;1 2;2 1;1 1;2 2;1 2; 2 1;1 1;2 2;1 2;1 1;1 2;2 2;2 1;1 1;2 2;1 2;2 1;1 2;2 2;2 1;1 1;1 1;2 2;2 1;1 2;2 1;1 1;2 2;2 1;2 2;1 1;2 1;1 2;2 2;1 1;1 2;1 2;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;1 1;2 1;1 2;2 2;2 1;1 1;2 2;1 2;2 1;2 2;2 1;1 1;1 2;1 2;2 2;1 1];activeblockstimulus4=[2 2;1 1;2 1;2 1;1 1;1 2;2 2;2 1;2 2;1 1;1 2;2 1;1 2;1 1;2 2;1 2;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;2 1;2 2;1 2;1 1;2 2;2 1;1 1;2 2;2 1;1 2;1 2;1 1;2 1;1 1;2 1;1 1;1 2;2 2;1 2;2 2;1 1;2 1;2 2;1 2;2 1;1 1;2 2;2 1;1 1;2 1;1 2;1 1;1 2;2 2;1 1;2 1;2 2;2 1;1 1;1 2;1 1;2 1;2 2;1 1;2 2;1 2;1 2;2 1;2 2;1 2];activeblockstimulus5=[1 2;1 1;2 2;2 1;1 1;2 2;1 2;2 1;2 2;1 1;1 2;2 1;2 2;1 2;1 1;2 1;2 2;2 1;1 1;1 2;2 1;1 2;1 1;1 2;2 1;2 2;2 1;1 1;2 2;1 2;1 1;2 2;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;1 1;2 2;2 1;1 2;1 1;2 2;1 2;2 1;1 1;2 1;2 2;1 2;1 1;1 2;2 1;2 2;2 1;2 2;1 1;1 2;1 1;2 2;1 2;2 1;1 2;2 2;1 2;1 1;2 1;2 2;1 1;2 1];activeblockstimulus6=[2 1;2 2;1 1;1 2;1 2;1 1;2 1;2 2;1 1;1 2;1 1;2 1;2 2;1 2;2 1;2 2;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;2 2;2 1;1 1;1 2;2 2;1 2;1 1;2 2;2 1;1 2;1 2;1 1;2 2;2 1;1 1;2 1;1 2;1 1;2 1;2 2;1 2;1 1;1 2;2 1;1 1;1 2;2 2;2 1;1 1;2 2;2 1;2 2;1 1;1 2;2 1;2 2;1 1;1 2;2 1;2 2;1 2;1 1;2 1;2 2;1 2;2 1;1 1;2 2];activeblockstimulus7=[1 1;2 1;1 2;1 2;1 1;2 2;2 1;1 2;2 2;1 1;2 2;2 1;1 2;1 1;2 1;2 2;2 2;1 2;1 1;1 2;1 1;2 2;2 1;1 2;1 1;2 2;1 2;1 1;2 1;2 2;2 1;2 1;1 2;1 1;2 2;2 1;1 1;1 2;2 2;1 2;2 1;1 1;2 2;2 1;1 2;1 1;2 1;2 2;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;2 1;2 2;1 1;1 2;2 2;2 1;1 1;1 2;2 1;2 2;1 1;2 2;1 1;1 2;2 1;1 2];activeblockstimulus8=[1 2;2 1;2 2;1 1;1 2;2 2;2 1;1 1;2 2;2 1;2 1;1 1;1 2;1 1;1 2;2 2;2 1;1 1;2 2;1 2;1 1;2 1;1 2;2 2;1 1;1 2;2 1;2 2;1 2;2 1;1 1;2 2;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;0 0;2 2;1 2;1 1;1 2;2 2;2 1;1 1;2 1;1 1;2 2;2 2;1 2;2 1;1 2;1 1;2 1;1 1;2 1;2 2;2 1;1 1;2 2;1 2;2 2;1 1;1 2;1 1;1 2;2 2;2 1;1 2;2 1];%orientation of gabors/6 or 9 for left and right stimuli
activeblocktype=[1 2 4 3 1;1 4 2 1 3;2 1 3 4 1;2 4 3 1 1;3 2 4 1 1;3 4 1 2 1;3 1 2 4 1;1 3 4 2 1];%1 for gabors, 2 for Egg-CI stimulus, 3 for 6/9-CI stimulus, 4 for rest
%[1 2 4 3 4;1 4 2 4 3;2 4 1 4 3;2 4 3 1 4;3 4 2 1 4;3 4 2 4 1;4 3 4 1 2;4 1 3 4 2];%1 for gabors, 2 for Egg-CI stimulus, 3 for 6/9-CI stimulus, 4 for rest
totalblockfinal=5;totaltrial=16;
TR=1.5;
totaltrialtime=TR*2 - .100;  % units of TRs with 50 ms of give to listen for the next TR