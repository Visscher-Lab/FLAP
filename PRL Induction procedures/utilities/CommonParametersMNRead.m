%CommonParametersMNRead


%% general visual parameters
scotomadeg=10;    % scotoma size in deg

scotoma_color=[200 200 200]/255;
start_size=39;
sizes=log_unit_down(start_size, 0.1, 20);

%  sizes=[start_size; sizes]
fixwindow=3;  % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
    fixationlength=50;
onscreenstartsize=3;
onscreensizes=log_unit_down(start_size, 0.1, 15);
sizearray=length(sizes);
eyetime2=0; % trial-based timer, will later be populated with eyetracker data
closescript=0; % to allow ESC use
kk=1; % trial counter

%% general temporal parameters (trial events)


practicetrials=5; % if we run in demo mode, how many trials do I want?
prefixationsquare=0.5; % time interval between trial start and forced fixation period


subcondmat=repmat(fullfact(3),5,1);
subcondmixmat=subcondmat(randperm(15));
%% visual stimuli common parameters
bg_index =round(gray*255); %background color
%imsize=StartSize*pix_deg; %stimulus size

scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
fixwindowPix=fixwindow*pix_deg; % fixation window



% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);

blocks=10;  %number of blocks in which we want the trials to be divide
fixat=0;
trials=sizearray;
cndt=1;
ca=1;


condlist=fullfact([cndt ca]);

mixtr=(1:trials)'