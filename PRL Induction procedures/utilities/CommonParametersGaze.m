%CommonParametersMNRead
fixat=0;

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
facepresentationduration=5;
%% general temporal parameters (trial events)


practicetrials=5; % if we run in demo mode, how many trials do I want?
prefixationsquare=0.5; % time interval between trial start and forced fixation period



  %  picture_size_deg=10;
  %      imsize = picture_size_deg*pix_deg;
%% visual stimuli common parameters
bg_index =round(gray*255); %background color
%imsize=StartSize*pix_deg; %stimulus size

scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
fixwindowPix=fixwindow*pix_deg; % fixation window
   picsize=13*pix_deg; % 13 deg horizontal size, 19 deg vertical size
   picsizex=19*pix_deg;
   imageoffset=2;
   pixOff=imageoffset*pix_deg;
   imageRectI{1} = CenterRect([0, 0, round(picsize), round(picsizex) ], wRect); % initial destination rectangle for the target
   imageRectI{2}=[imageRectI{1}(1) imageRectI{1}(2)-pixOff imageRectI{1}(3) imageRectI{1}(4)-pixOff];
   imageRectI{3}=[imageRectI{1}(1) imageRectI{1}(2)+pixOff imageRectI{1}(3) imageRectI{1}(4)+pixOff];
%     
%     actors=3;
%     offsets=7;
%     premixtr=fullfact([actors offsets]);
%                     
%     mixtr=premixtr(randperm(length(premixtr)),:);
% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
% 
% blocks=10;  %number of blocks in which we want the trials to be divide
% fixat=0;
% trials=sizearray;
% cndt=1;
% ca=1;
% 
% 
% condlist=fullfact([cndt ca]);
% 
% mixtr=(1:trials)';