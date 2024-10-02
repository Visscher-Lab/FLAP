%% general visual parameters
% written by Marcello Maniglia
% Modified by Kristina Visscher on Octobber 19, 2023 to include capability
% to run SPOT08
%

scotomadeg=14;    % scotoma size in deg
resonsebox = 0;

whichMD=str2num(SUBJECT(5:end));

if whichMD==1     %SPOT 1
    scotomadegx=14;    % scotoma size in deg
    scotomadegy=14;    % scotoma size in deg
    theeccentricity_X_scotoma=1.7*pix_deg;
    theeccentricity_Y_scotoma=0.3*pix_deg;
    [img, ~, alpha] = imread('Scotoma_01.png');
elseif whichMD==2  %SPOT 2
    scotomadegx=6.6;    % scotoma size in deg
    scotomadegy=2.7;    % scotoma size in deg
    theeccentricity_X_scotoma=-0.6*pix_deg;
    theeccentricity_Y_scotoma=0*pix_deg;
    [img, ~, alpha] = imread('Scotoma_02.png');
elseif whichMD==3  %SPOT 3
    scotomadegx=12.83;    % scotoma size in deg
    scotomadegy=14.78;    % scotoma size in deg
    theeccentricity_X_scotoma=-1*pix_deg;
    theeccentricity_Y_scotoma=1.95*pix_deg;
    [img, ~, alpha] = imread('Scotoma_03.png');
elseif whichMD==4  %SPOT 4
    scotomadegx=10.87;    % scotoma size in deg
    scotomadegy=14.44;    % scotoma size in deg
    theeccentricity_X_scotoma=6*pix_deg;
    theeccentricity_Y_scotoma=0.5*pix_deg;
    [img, ~, alpha] = imread('Scotoma_04.png');
elseif whichMD==5
    scotomadegx=17.56;    % scotoma size in deg
    scotomadegy=12.58;    % scotoma size in deg
    theeccentricity_X_scotoma=0.63*pix_deg;
    theeccentricity_Y_scotoma=-6*pix_deg;
    [img, ~, alpha] = imread('Scotoma_05.png');
elseif whichMD==6
    'Participant ID not found'
    scotomadegx=0;
    scotomadegy=0;
elseif whichMD==7
    scotomadegx=23.85;    % scotoma size in deg
    scotomadegy=15.32;    % scotoma size in deg
    theeccentricity_X_scotoma=-0.19*pix_deg;
    theeccentricity_Y_scotoma=-6.3*pix_deg;
    [img, ~, alpha] = imread('Scotoma_07.png');
elseif whichMD==8
    scotomadegx=23.85;    % scotoma size in deg
    scotomadegy=15.32;    % scotoma size in deg
    theeccentricity_X_scotoma=-0.19*pix_deg;
    theeccentricity_Y_scotoma=-6.3*pix_deg;
    [img, ~, alpha] = imread('Scotoma_07.png');
    % scotoma 7 because this is a control participant.
    elseif whichMD==9
    scotomadegx=16.88;    % scotoma size in deg
    scotomadegy=18.58;    % scotoma size in deg
    theeccentricity_X_scotoma=1.51*pix_deg;
    theeccentricity_Y_scotoma=2.15*pix_deg;
    [img, ~, alpha] = imread('Scotoma_09.png');
    % scotoma 7 because this is a control participant.
else
    'Participant ID not found'
    scotomadegx=0;
    scotomadegy=0;
end
scotomax=scotomadegx*pix_deg;
scotomay=scotomadegy*pix_deg;

size(img);
% 2557 x 1993 x 3 (rgb)
% We'll make one texture without the alpha channel, and one with.
[y, x, c]=size(img);
scale_fact=scotomax/x;
img2=imresize(img,scale_fact);
alpha2=imresize(alpha,scale_fact);

texture1 = Screen('MakeTexture', w, img2); %  image without the alpha channel.
img2(:, :, 4) = alpha2;
texture2 = Screen('MakeTexture', w, img2); %image with the alpha channel.

PRLsize =10; % diameter PRL in deg
attContr= 1; % contrast of the target

scotoma_color=[200 200 200];
red=[255 0 0];
fixwindow=6;  % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
PRLecc=10;  %eccentricity of target locations in deg

dotsizedeg=0.21; %size of the dots for no scotoma cases
fixdotsizedeg=0.5;
randdegarray=[-11:0.5:11]; % randomize stimulus location
stimulusSize=3.72;


%% general temporal parameters (trial events)

precircletime=0.55;

practicetrials=5; % if we run in demo mode, how many trials do I want?
prefixationsquare=0.5; % time interval between trial start and forced fixation period
cueonset=0.2; % time between end of the forced fixation period and the cue (value works for Acuity and
%crowding, for attention the value is jittered to increase time uncertainty
Jitter=[0.5:0.5:2]; %jitter array for trial start in seconds
fixTime=0.5;
effectivetrialtimeout=20; %max time duration for a trial (otherwise it counts as elapsed)

eyetime2=0; % trial-based timer, will later be populated with eyetracker data
closescript=0; % to allow ESC use
kk=1; % trial counter

%% visual stimuli common parameters
bg_index =round(gray*255); %background color
imsize=stimulusSize*pix_deg; %stimulus size

scotomasize=[scotomadegx*pix_deg scotomadegy*pix_deg];
dotsize=[dotsizedeg*pix_deg dotsizedeg*pix_deg];
imageRectDot = CenterRect([0, 0, fixdotsizedeg*pix_deg, fixdotsizedeg*pix_deg_vert], wRect); % destination rect for fixation dot

scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
dotrect = CenterRect([0, 0, dotsize(1), dotsize(2)], wRect);

fixwindowPix=fixwindow*pix_deg; % fixation window

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


 