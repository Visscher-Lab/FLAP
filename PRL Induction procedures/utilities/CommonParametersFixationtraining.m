%% general visual parameters
scotomadeg=10;    % scotoma size in deg
scotoma=scotomadeg*pix_deg;
PRLsize =10; % diameter PRL in deg
attContr= 1; % contrast of the target

scotoma_color=[200 200 200];
red=[255 0 0];
%fixwindow_values=[3 2 1 0.5];  % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
fixwindow_values=[5 2.5 1 ];  % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)

PRLecc=10;  %eccentricity of target locations in deg

dotsize=0.6; %size of the dots constituting the peripheral diamonds in deg
dotecc=2; %eccentricity of the dot with respect to the center of the TRL in deg
randdegarray=[-12:0.5:12]; % randomize stimulus location
randdegarray=randdegarray(randdegarray>scotomadeg/2 | randdegarray<-scotomadeg/2);
stimulusSize=1.5;
theeccentricity_X_scotoma=0*pix_deg;
theeccentricity_Y_scotoma=0*pix_deg;
%% general temporal parameters (trial events)

precircletime=0.55;
ITI = 0.5;
practicetrials=5; % if we run in demo mode, how many trials do I want?
prefixationsquare=0.5; % time interval between trial start and forced fixation period
cueonset=0.2; % time between end of the forced fixation period and the cue (value works for Acuity and
%crowding, for attention the value is jittered to increase time uncertainty
Jitter=[0.5:0.5:2]; %jitter array for trial start in seconds
%fixTime_values=[0.5 1 1.5 2];
fixTime_values=[5 10]; % consecutive time to spend with the scotoma in the box in seconds

effectivetrialtimeout=20; %max time duration for a trial (otherwise it counts as elapsed)

eyetime2=0; % trial-based timer, will later be populated with eyetracker data
closescript=0; % to allow ESC use
kk=1; % trial counter

%% visual stimuli common parameters
bg_index =round(gray*255); %background color
imsize=stimulusSize*pix_deg; %stimulus size

scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
%fixwindowPix=fixwindow*pix_deg; % fixation window

% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);

[sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);

imageRect = CenterRect([0, 0, (stimulusSize*pix_deg) (stimulusSize*pix_deg)], wRect);


[img, sss, alpha] = imread('happyface.png');
img(:, :, 4) = alpha;
Happyface= Screen('MakeTexture', w, img);

[img, sss, alpha] = imread('sadface.png');
img(:, :, 4) = alpha;
Sadface= Screen('MakeTexture', w, img);

% from http://pngimg.com/upload/cat_PNG100.png
[img, ~, alpha] = imread('imagescotoma.png');
size(img);
% 2557 x 1993 x 3 (rgb)
% We'll make one texture without the alpha channel, and one with.
[y, x, c]=size(img);
scale_fact=scotoma/x;
img2=imresize(img,scale_fact);


texture1 = Screen('MakeTexture', w, img); %  image without the alpha channel.
img(:, :, 4) = alpha;
texture2 = Screen('MakeTexture', w, img); %image with the alpha channel.


 