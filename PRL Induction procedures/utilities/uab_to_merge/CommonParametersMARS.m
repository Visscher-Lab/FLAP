%CommonParametersMARS


%% general visual parameters
scotomadeg=10;    % scotoma size in deg

scotoma_color=[200 200 200]/255;
start_size=39;
sizes=[1:-0.02:0.02];

%  sizes=[start_size; sizes]
fixwindow=3;  % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
    fixationlength=50;
letter_size=2.5;
letters_offset=[0:wRect(3)/8:wRect(3)];
letters_offset=letters_offset(2:end-1)
sizearray=length(sizes);
eyetime2=0; % trial-based timer, will later be populated with eyetracker data
closescript=0; % to allow ESC use
kk=1; % trial counter
        theoris =[-180 0 -90 90];

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

imageRect = CenterRect([0, 0, (letter_size*pix_deg) (letter_size*pix_deg)], wRect);
    halfletter=(letter_size*pix_deg)/2;

for ui=1:length(letters_offset)
    newlocationoffset(ui)=letters_offset(ui)-wRect(3)/2 %-halfletter;
    
    
    imageRects{ui}=[imageRect(1)+newlocationoffset(ui) imageRect(2) imageRect(3)+newlocationoffset(ui) imageRect(4)]
    
end
% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);

blocks=10;  %number of blocks in which we want the trials to be divide
fixat=0;
trials=sizearray;
cndt=1;
ca=1;


condlist=fullfact([cndt ca]);

mixtr=(1:trials)';