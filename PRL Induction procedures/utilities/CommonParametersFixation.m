%% general visual parameters
    scotomadeg=10;    % scotoma size in deg
        PRLsize =10; % diameter PRL in deg   

scotoma_color=[200 200 200];
red=[255 0 0];
fixwindow=3;  % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
    PRLecc=10;  %eccentricity of target locations in deg

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
    stimulusSize=1.5;
    flickeringrate=0.25;
%% general temporal parameters (trial events)

    precircletime=0.55;    

practicetrials=5; % if we run in demo mode, how many trials do I want?
prefixationsquare=0.5; % time interval between trial start and forced fixation period
cueonset=0.2; % time between end of the forced fixation period and the cue (value works for Acuity and
%crowding, for attention the value is jittered to increase time uncertainty
JitterFlicker=[0.5:0.5:2]; %jitter array for flicker duration
fixTime=0.5/3;
trialTimeout = 8; % how long (seconds) should a trial last without a response
realtrialTimeout = trialTimeout; % used later for accurate calcuations (need to be updated after fixation criteria satisfied)
AnnulusDuration=2;  
    AnnulusTime=AnnulusDuration/3;
eyetime2=0; % trial-based timer, will later be populated with eyetracker data
closescript=0; % to allow ESC use
kk=1; % trial counter



timeflickerallowed=0.2; % time before flicker starts
flickerpersistallowed=0.2; % time away from flicker in which flicker persists
framesbeforeflicker=timeflickerallowed/ifi; % frames before flicker starts
blankframeallowed=flickerpersistallowed/ifi; % frames away from flicker in which flicker persists


%% visual stimuli common parameters
bg_index =round(gray*255); %background color
imsize=stimulusSize*pix_deg; %stimulus size

scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
fixwindowPix=fixwindow*pix_deg; % fixation window

% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);



[sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);



    % here I define the annulus around the scotoma which allows for a
    % fixation to count as 'valid', i.e., the flickering is on when a
    % fixation is within this region
   smallradius=(PRLsize/2)*pix_deg;

    radiusPRL=smallradius+3*pix_deg; %outer circle (3 degrees from the border of the scotoma
    
    circlePixels=sx.^2 + sy.^2 <= radiusPRL.^2;
    circlePixels2=sx.^2 + sy.^2 <= smallradius.^2;
    
    d=(circlePixels2==1);
    newfig=circlePixels;
    newfig(d==1)=0;
    circlePixels=newfig;
    
    imageRectcue = CenterRect([0, 0, [smallradius*2 ((smallradius/pix_deg)*pix_deg_vert)*2]], wRect);