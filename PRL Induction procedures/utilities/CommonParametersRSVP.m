%% spatial parameters
scotomadeg=6; % scotoma size in deg
scotoma_color=[200 200 200];  % scotoma color in rgb
oval_thick=10; %thickness of TRL ring in pixels
stimulussize=2; % size of the stimulus (C or O) in degrees
circle_size=4.5; % dimension of the TRL rings in degrees
fixationwindow=6; % diameter of fixation window in degrees (outside the box the stimuli disappear)
ContCirc= [150 150 150]; % TRL ring color

% background color on line 229
imageRectcircles = CenterRect([0, 0, [circle_size*pix_deg circle_size*pix_deg_vert]], wRect);
fixationwindowRect = CenterRect([0, 0, [fixationwindow*pix_deg fixationwindow*pix_deg_vert]], wRect);


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


 xlocs=[-7.5 0 7.5 ]; % x locations of the TRL rings
 ylocs=[0 7.5 0 ];  % y locations of the TRL rings

%generate visual cue
eccentricity_X=xlocs*pix_deg;
eccentricity_Y=ylocs*pix_deg_vert;


            imageRect_offs1=[imageRect1(1)+eccentricity_X(1), imageRect1(2)+eccentricity_Y(1),...
                imageRect1(3)+eccentricity_X(1), imageRect1(4)+eccentricity_Y(1)];
            imageRect_offs2=[imageRect1(1)+eccentricity_X(2), imageRect1(2)+eccentricity_Y(2),...
                imageRect1(3)+eccentricity_X(2), imageRect1(4)+eccentricity_Y(2)];
            imageRect_offs3=[imageRect1(1)+eccentricity_X(3), imageRect1(2)+eccentricity_Y(3),...
                imageRect1(3)+eccentricity_X(3), imageRect1(4)+eccentricity_Y(3)];
%             imageRect_offs4=[imageRect1(1)+eccentricity_X(4), imageRect1(2)+eccentricity_Y(4),...
%                 imageRect1(3)+eccentricity_X(4), imageRect1(4)+eccentricity_Y(4)];
            
            imageRect_offs={imageRect_offs1 imageRect_offs2 imageRect_offs3 imageRect_offs4};
%% Temporal parameters
targetAlphaValue=0.6; % transparency of the targets/foils (1:opaque, 0: invisible)

%sequences of events for each trial (single trial events)
time_of_events=[10 0.2 0.2 0.2 0.5];
%events type
%1= C stays on screen until response
%2= foil
%3= target
%4=cue
%5= blank


practicetrials=5;