%% Testing how the contour shapes used in Assessments look like on the screen
v_d=55; % viewing distance
BITS = 0;
AssertOpenGL;
screenNumber=max(Screen('Screens'));
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
[w, wRect]=PsychImaging('OpenWindow',screenNumber, 0,[],32,2);
Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT

screencm=[28.5, 17.85];


CommonParametersFLAP % define common parameters

PRLecc=[0 7.5 0 -7.5; -7.5 0 7.5 0]; %eccentricity of PRL in deg

%% Stimuli creation

% This part characterizes the PRL ------------------------------------
PRLx= PRLecc(1,:);
PRLy=-PRLecc(2,:);
PRLxpix=PRLx*pix_deg*coeffAdj;
PRLypix=PRLy*pix_deg*coeffAdj;
PRLsize=5;
[sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);
radiusPRL=(PRLsize/2)*pix_deg;
circlePixelsPRL=sx.^2 + sy.^2 <= radiusPRL.^2;
imageRectcue = CenterRect([0, 0, [radiusPRL*2 ((radiusPRL/pix_deg)*pix_deg_vert)*2]], wRect);
% mask to cover the target when outside the TRL (if needed)
[img, sss, alpha] =imread('neutral21.png');
img(:, :, 4) = alpha;
Neutralface=Screen('MakeTexture', w, img);
mask_color= [170 170 170];
% ---------------------------------------------------------------------

CIAssessmentShapes % Isolating the 2 shapes using which we want to perform the assessment

%% Trial matrix definition

% initialize jitter matrix
shapes=2; % how many shapes per day?
JitList = 0:2:90;
StartJitter=1;

%define number of trials per condition

conditionOne=shapes; % shapes (training type 2)
conditionTwo=2; %locations (left and right - TRL and URL)
if demo==1
    trials=5; %total number of trials per staircase (per shape)
else
    trials=100;  %total number of trials per staircase (per shape)
end

mixcond=fullfact([conditionOne conditionTwo]); %full factorial design
mixtr=[];
for ui=1:conditionOne
    mixtr=[mixtr; repmat(mixcond(ui,:),trials,1) ];
end
mixtr=[mixtr ones(length(mixtr(:,1)),1)];

%% STAIRCASE
nsteps=70; % elements in the stimulus intensity list (contrast or jitter or TRL size in training type 3)
stepsizes=[4 4 3 2 1]; % step sizes for staircases
% Threshold -> 79%
sc.up = 1;   % # of incorrect answers to go one step up
sc.down = 3;  % # of correct answers to go one step down
shapesoftheDay= [1 2];

AllShapes=size((Targy));
trackthresh=ones(AllShapes(2),1)*StartJitter; %assign initial jitter to shapes
thresh=trackthresh(shapesoftheDay);
reversals(1:conditionOne, 1:conditionTwo)=0;
isreversals(1:conditionOne, 1:conditionTwo)=0;
staircounter(1:conditionOne, 1:conditionTwo)=0;
corrcounter(1:conditionOne, 1:conditionTwo)=0;

%% Trial structure

if annulusOrPRL==1 % annulus for pre-target fixation (default is NOT this)
    % here I define the annulus around the scotoma which allows for a
    % fixation to count as 'valid', i.e., the flickering is on when a
    % fixation is within this region
    [sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);
    smallradiusannulus=(scotomadeg/2)*pix_deg; % inner circle: scotoma eccentricity
    largeradiusannulus=smallradiusannulus+3*pix_deg; %outer circle (3 degrees from the border of the scotoma
    circlePixels=sx.^2 + sy.^2 <= largeradiusannulus.^2;
    circlePixels2=sx.^2 + sy.^2 <= smallradiusannulus.^2;
    d=(circlePixels2==1);
    newfig=circlePixels;
    newfig(d==1)=0;
    circlePixelsPRL=newfig;
end

%% Initialize trial loop
HideCursor;
if demo==2
    ListenChar(2);
end
ListenChar(0);

% general instruction TO BE REWRITTEN
InstructionCIAssessment(w,shapesoftheDay,gray,white) % Probably need to change it for the assessment type
