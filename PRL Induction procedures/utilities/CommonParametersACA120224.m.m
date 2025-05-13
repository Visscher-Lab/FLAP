% added by KMV, Nov 5, 2024
% SUBJECT is a global variable with the subject name.  If it is an MD
% subject, SUBJECT(2) = m.  
if SUBJECT(2) == 'm'
    % it's an MD subject, and we have to choose the PRL locations wisely
    % first, load the PRL locations:   
    participantAssignmentTable = fullfile(cd, ['..\..\datafolder\MDParticipantAssignmentsUAB.csv']); % this is set for UCR or UAB separately (This is set here so that definesite.m does not have to change)
    temp= readtable(participantAssignmentTable);
    tt = temp(find(contains(temp.participant,SUBJECT)),:); % reads as a table or struct
    
    % The TRL for these participants is always 1, so that the PRL is the
    % first location listed below.
    max_separation=8; %max deg for crowding % may want to change later for MD?
    PRLecc=str2double(tt.xTRL);   
    if PRLlocations==4
        xlocs=[str2double(tt.xTRL) str2double(tt.xURL) str2double(tt.xURL2)];
        ylocs=[-str2double(tt.yTRL) -str2double(tt.yURL) -str2double(tt.yURL2)];  % all the y locations are negative, because 0 is at the top of screen
    elseif PRLlocations==2
        xlocs=[str2double(tt.xTRL) str2double(tt.xURL)];
        ylocs=[-str2double(tt.yTRL) -str2double(tt.yURL)]; 
    elseif PRLlocations==3
        xlocs=[str2double(tt.xTRL) str2double(tt.xURL) str2double(tt.xURL2)];
        ylocs=[-str2double(tt.yTRL) -str2double(tt.yURL) -str2double(tt.yURL2)]; 
    end
     [theta rho] = cart2pol(xlocs, ylocs); 

    if (mod(theta(1),(.5)*pi) < (1/3)*pi) && (mod(theta(1),(.5)*pi) > (1/6)*pi) %center wedge with mod of half pi
        fixation_location_prl = 2; %if point is within the x shape around the origin
    else
        fixation_location_prl = 1; %if point is within + shape around origin
    end
    %for url
    if (mod(theta(2),(.5)*pi) < (1/3)*pi) && (mod(theta(2),(.5)*pi) > (1/6)*pi) %center wedge with mod of half pi
        fixation_location_url = 2; %if point is within the x shape around the origin
    else
        fixation_location_url = 1; %if point is within + shape around origin
    end
    % also use general visual parameters consistent with MD participant
    scotomadeg=6; % scotoma size in deg
    scotoma_color=[200 200 200];
    red=[255 0 0];
    attContr= 0.35; % contrast of the target
    %StartSize= 2; %1; %starting size for VA
    %StartCont=1.122; %starting value for contrast
    %StimSize_crowding=0.8; %1 %stimulus size for crowding task
    
    %StimSize_crowding = str2double(tt.stimulus_size_crowding); %should be around 1.5 * their visual acuity.  
    %StimSize = 1; % for contrast sensitivity with the C & exo attention -- NOTE this does not get called.  
    %fixwindow=3;  % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)general visual parameters
    ActualStartSize = str2double(tt.stimulus_size_crowding);
    attContr = 0.35; %contrast of the target
    fixwindow = str2double(tt.fix_window); % variable per participant. usually 3
    StartingElement = 20; % start at this element, and you can get easier element-1 times, and harder 90-element times
    lu_step = 0.1;
    StartSize= ActualStartSize/10^(lu_step)*StartingElement; %1; %starting size for VA array
    StartCont=1.122; %starting value for contrast
    
     if whichTask ~= 1  %determines size of stimulus for crowding and contrast, uses StartSize for acuity and else statement for exo
        StimSize_crowding = str2double(tt.stimulus_size_crowding); %stimulus size for crowding task
        StimSize = str2double(tt.stimulus_size_crowding);% for contrast sensitivity with the C & exo attention
    else
        StimSize_crowding = str2double(tt.stimulus_size_crowding); %stimulus size for crowding task
        StimSize = str2double(tt.stimulus_size_crowding);% for contrast sensitivity with the C & exo attention
     end
else
    %it's a healthy vision participant
    %% general visual parameters
    scotomadeg=6; % scotoma size in deg
    scotoma_color=[200 200 200];
    red=[255 0 0];
    attContr= 0.35; % contrast of the target
    %StartSize= 2; %1; %starting size for VA
    %StartCont=1.122; %starting value for contrast
    StimSize_crowding=0.8; %1 %stimulus size for crowding task
    StimSize = 1; % for contrast sensitivity with the C & exo attention
    fixwindow=3;  % size of fixation window in degrees (for the beginning of trial, in the IsFixating scripts)
    StartingElement = 3; % start at this element, and you can get easier element-1 times, and harder 90-element times
    lu_step = 0.1;
    StartSize= 2; % ActualStartSize/10^(lu_step)*StartingElement; %1; %starting size for VA array
    StartCont=1.122; %starting value for contrast
    
    PRLecc=7.5;         %%eccentricity of PRLs
    max_separation=8; %max deg for crowding
    if PRLlocations==4
        xlocs=[0 PRLecc 0 -PRLecc];
        ylocs=[-PRLecc 0 PRLecc 0 ];
    elseif PRLlocations==2
        xlocs=[-PRLecc  PRLecc];
        ylocs=[0  0];
    elseif PRLlocations==3
        xlocs=[-PRLecc  PRLecc 0];
        ylocs=[0  0 PRLecc];
    end
    
    
end %different PRL locations for MD vs. control

% end edits kmv made nov 5, 2024

fixdotcolor=[177 177 177]; % color of the fixation dot before target appearance
dotsize=0.46; %size of the dots constituting the peripheral diamonds in deg
dotecc=2; %eccentricity of the dot with respect to the center of the TRL in deg
oval_thick=6; %thickness of the cue's oval during the Attention task
ContCirc= [200 200 200];
    oneOrfourCues=4; % 1= 1 cue, 4= 4 cue
if oneOrfourCues==4 % for attention part, do we want 4 dots to briefly signal the exo TLR?
    cueSize=3;
    cue_spatial_offset=2;
end
circleSize=2.5; % cue size
dotsizedeg=0.5; % size of the fixation dot for Training type 1 and 2
imageRectDot = CenterRect([0, 0, dotsizedeg*pix_deg, dotsizedeg*pix_deg_vert], wRect); % destination rect for fixation dot training type 1 and 2

%% general temporal parameters (trial events)


practicetrials=12; % if we run in demo mode, how many trials do I want?
ITI=0.75; % time interval between trial start and forced fixation period
fixationduration=0.5; %duration of forced fixation period
postfixationblank=[0.2 0.1]; % time between end of the forced fixation period and the cue (value works for Acuity and
%crowding, for attention the value is jittered to increase time uncertainty
Jitter=[0.5:0.5:2]; %jitter array for cue onset during Attention part
cueduration=0.05; % cue duration
cueISI=0.05; % cue to target ISI
if whichTask==3
    stimulusduration=0.05; % duration of the C
else
    stimulusduration=0.2; % duration of the C
end
trialTimeout = 8; % how long (seconds) should a trial last without a response
realtrialTimeout = trialTimeout; % used later for accurate calcuations (need to be updated after fixation criteria satisfied)

eyetime2=0; % trial-based timer, will later be populated with eyetracker data
closescript=0; % to allow ESC use
kk=1; % trial counter
    exocuearray=[1, 5];
calibrationtolerance=2;
%% visual stimuli common parameters
bg_index =round(gray*255); %background color
imsize=StartSize*pix_deg; %starting size for acuity
stimulussize=StimSize*pix_deg; %stimulus size for non-acuity tasks (contrast and exo attention)
stimulussize_crowding = StimSize_crowding * pix_deg; % stimulus size for crowding task
scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
fixwindowPix=fixwindow*pix_deg; % fixation window

eccentricity_X=xlocs*pix_deg;
eccentricity_Y=ylocs*pix_deg;

% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
