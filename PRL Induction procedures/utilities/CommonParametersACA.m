%% general visual parameters
scotomadeg=6; % scotoma size in deg
scotoma_color=[200 200 200];
red=[255 0 0];
attContr= 0.35; % contrast of the target
StartSize=2; %starting size for VA
fixwindow=3;  % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
PRLecc=7.5;         %%eccentricity of PRLs
if PRLlocations==4
    xlocs=[0 PRLecc 0 -PRLecc];
    ylocs=[-PRLecc 0 PRLecc 0 ];
elseif PRLlocations==2
    xlocs=[PRLecc  -PRLecc];
    ylocs=[0  0];
end
dotsize=0.6; %size of the dots constituting the peripheral diamonds in deg
dotecc=2; %eccentricity of the dot with respect to the center of the TRL in deg
oval_thick=6; %thickness of the cue's oval during the Attention task
ContCirc= [200 200 200];
    oneOrfourCues=4; % 1= 1 cue, 4= 4 cue
if oneOrfourCues==4 % for attention part, do we want 4 dots to briefly signal the exo TLR?
    cueSize=3;
    cue_spatial_offset=2;
end
circleSize=2.5; % cue size
%% general temporal parameters (trial events)


practicetrials=5; % if we run in demo mode, how many trials do I want?
prefixationsquare=0.5; % time interval between trial start and forced fixation period
cueonset=0.2; % time between end of the forced fixation period and the cue (value works for Acuity and
%crowding, for attention the value is jittered to increase time uncertainty
Jitter=[0.5:0.5:2]; %jitter array for cue onset during Attention part
cueduration=[0.05 0.05 0.133 0.133]; % cue duration
cueISI=[ 0.05 0.05 0.133 0.133]; % cue to target ISI
stimulusduration=0.133; % duration of the C
fixTime=0.5/3;
trialTimeout = 8; % how long (seconds) should a trial last without a response
realtrialTimeout = trialTimeout; % used later for accurate calcuations (need to be updated after fixation criteria satisfied)

eyetime2=0; % trial-based timer, will later be populated with eyetracker data
closescript=0; % to allow ESC use
kk=1; % trial counter

%% visual stimuli common parameters
bg_index =round(gray*255); %background color
imsize=StartSize*pix_deg; %stimulus size

scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
fixwindowPix=fixwindow*pix_deg; % fixation window

eccentricity_X=xlocs*pix_deg;
eccentricity_Y=ylocs*pix_deg;

% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
