%% spatial parameters
scotomadeg=6; % scotoma size in deg
scotoma_color=[200 200 200];  % scotoma color in rgb
oval_thick=10; %thickness of TRL ring in pixels
stimulussize=2; % size of the stimulus (C or O) in degrees
circle_size=4.5; % dimension of the TRL rings in degrees
fixationwindow=3; % diameter of fixation window in degrees (outside the box the stimuli disappear)
ContCirc= [150 150 150]; % TRL ring color
targetAlphaValue=0.6; % transparency of the targets/foils (1:opaque, 0: invisible)
scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect);
% background color on line 229
imageRectcircles = CenterRect([0, 0, [circle_size*pix_deg circle_size*pix_deg_vert]], wRect);
fixationwindowRect = CenterRect([0, 0, [fixationwindow*pix_deg fixationwindow*pix_deg_vert]], wRect);
fixwindowPix=fixationwindow*pix_deg; % fixation window
                fixationlength=10; % if we don't want to have a simulated scotoma but a fixation cross
% PRL_x_axis=0; % x eccentricity of TRL rings
% PRL_y_axis=-7.5; % y eccentricity of TRL rings
% 
% 
% [theta,rho] = cart2pol(PRL_x_axis, PRL_y_axis);
% 
% ecc_r=rho;
% ecc_t=theta-pi; % ecc_t=theta+pi/2
% cs= [cos(ecc_t), sin(ecc_t)];
% xxyy=[ecc_r ecc_r].*cs;
% PRL3_x_axis=xxyy(1);
% PRL3_y_axis=xxyy(2);
% 
% %ecc_r=rho;
% ecc_t=theta-pi/2; % ecc_t=theta+3*pi/2
% cs= [cos(ecc_t), sin(ecc_t)];
% xxyy=[ecc_r ecc_r].*cs;
% PRL4_x_axis=xxyy(1);
% PRL4_y_axis=xxyy(2);
% 
% ecc_t=theta+pi/2;
% cs= [cos(ecc_t), sin(ecc_t)];
% xxyy=[ecc_r ecc_r].*cs;
% PRL2_x_axis=xxyy(1);
% PRL2_y_axis=xxyy(2);
% 
% 
% xlocs=[PRL_x_axis PRL2_x_axis PRL3_x_axis ]; % x locations of the TRL rings
% ylocs=[PRL_y_axis PRL2_y_axis PRL3_y_axis ];  % y locations of the TRL rings


 xlocs=[-7.5  7.5 0 ]; % x locations of the TRL rings
 ylocs=[0 0 7.5 ];  % y locations of the TRL rings

%generate visual cue
eccentricity_X=xlocs*pix_deg;
eccentricity_Y=ylocs*pix_deg_vert;
imsize=stimulussize*pix_deg;
        imageRect1 = CenterRect([0, 0, imsize imsize], wRect);

            imageRect_offs1=[imageRect1(1)+eccentricity_X(1), imageRect1(2)+eccentricity_Y(1),...
                imageRect1(3)+eccentricity_X(1), imageRect1(4)+eccentricity_Y(1)];
            imageRect_offs2=[imageRect1(1)+eccentricity_X(2), imageRect1(2)+eccentricity_Y(2),...
                imageRect1(3)+eccentricity_X(2), imageRect1(4)+eccentricity_Y(2)];
            imageRect_offs3=[imageRect1(1)+eccentricity_X(3), imageRect1(2)+eccentricity_Y(3),...
                imageRect1(3)+eccentricity_X(3), imageRect1(4)+eccentricity_Y(3)];
%             imageRect_offs4=[imageRect1(1)+eccentricity_X(4), imageRect1(2)+eccentricity_Y(4),...
%                 imageRect1(3)+eccentricity_X(4), imageRect1(4)+eccentricity_Y(4)];
            
            imageRect_offs={imageRect_offs1 imageRect_offs2 imageRect_offs3};
            
            
    % TRL
    imageRect_circleoffs1=[imageRectcircles(1)+eccentricity_X(1), imageRectcircles(2)+eccentricity_Y(1),...
        imageRectcircles(3)+eccentricity_X(1), imageRectcircles(4)+eccentricity_Y(1)];
    imageRect_circleoffs2=[imageRectcircles(1)+eccentricity_X(2), imageRectcircles(2)+eccentricity_Y(2),...
        imageRectcircles(3)+eccentricity_X(2), imageRectcircles(4)+eccentricity_Y(2)];
    imageRect_circleoffs3=[imageRectcircles(1)+eccentricity_X(3), imageRectcircles(2)+eccentricity_Y(3),...
        imageRectcircles(3)+eccentricity_X(3), imageRectcircles(4)+eccentricity_Y(3)];
  
    
    imageRect_circleoffs1offs={imageRect_circleoffs1 imageRect_circleoffs2 imageRect_circleoffs3};
    
    
%% Temporal parameters
eyetime2=0; % trial-based timer, will later be populated with eyetracker data
trialTimeout = 8; % how long (seconds) should a trial last without a response
realtrialTimeout = trialTimeout; % used later for accurate calcuations (need to be updated after fixation criteria satisfied)
ITI=0.75; % time interval between trial start and forced fixation period
fixationduration=0.5; %duration of forced fixation period

%sequences of events for each trial (single trial events)
time_of_events=[10 0.1 0.1 0.133 .4 0.133];
%time_of_events=[10 0.1 1 0.133 .4 0.133];

%time_of_events=[1 1 1 1 1 1]*5;
calibrationtolerance=5; % accepted time with no eye info before calling for recalibration
%events type
%1= C stays on screen until response
%2= foil
%3= target
%4=cue
%5= blank
%6= post cue ISI
closescript=0; % to allow ESC use
kk=1; % trial counter

practicetrials=5;