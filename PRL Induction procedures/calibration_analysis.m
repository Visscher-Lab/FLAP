%% the relationship between raw eye data and screen gaze position is 
%determined by 4 different polynomials representing each axis of each eye. 
%The same calibration process will be performed for each independant axis 
%and eye giving four independent calibration processes and results: 
%right eye x axis, right eye y axis, 
%left eye x axis and left eye y axis.

<<<<<<< Updated upstream
%% Coordinate system:
%Psychtoolbox uses a coordinate system having an origin at the top left
%corner of the screen.  We propose functions to convert back and forth 
%between custom coordinate systems and the cartesian coordinate system (origin at center of the screen).

% 1 - 'ConvertCoordSysToCartesian'
% 2 - 'ConvertCoordSysToCustom'

%Both functions take an array of coordinates, the offset of the origin to 
%the center and the scaling for both x and y coordinates as inputs and then return 
%the converted array of coordinates. Using default offset and scaling will
%convert back and forth to the PsychToolbox coordinate system.

%It is NOT MANDATORY to convert between coordinate systems. However, you 
%must pay particular attention to different systems if switching between applications
%or toolboxes using different coordinates systems.

%% xy and 'targets' is the calibration point array. It contains all the points that should
%be calibrated as part of the present calibration. standard 13 points


%raw_vector contains the raw eye information from the tracker. The first
%dimension represents each of the 13 calibration points. The second
%dimension represents each eye and axis.
% 1 - right eye horzontal axis (x)
% 2 - right eye vertical axis (y)
% 3 - left eye horizontal axis (x)
% 4 - left eye vertical axis (y)



                %GetEyeDuringCalibrationRaw acquires eye data from tracker.
                %It also saves that data in memory and is used (once all
                %targets are run) to calculate the formula used to convert 
                %raw eye data to calibrate screen position.

%% raw_vector from 'GetEyeDuringCalibrationRaw' (degree?)

            %Plot the results of the calibrations.  This can be used as
            %part of the calibration evaluation. It displays the raw data
            %distribution gathered during the previous phase. It quickly
            %indicates if one or more points are invalid.
            
%             [xRawRight yRawRight xRawLeft yRawLeft] = Datapixx('GetEyeDuringCalibrationRaw', xScreen, yScreen [,eyeToVerify = 3]);
%             
%             During calibration, tell the tracker to acquire Eye Data NOW with
%             the current marker coordinates (xScreen, yScreen).Returns the raw coordinates
%             that will be used for the calculations.
                        figure('Name','raw_data_right');
            H = scatter(raw_vector(:,1), raw_vector(:,2));
            grid on;
            grid minor;
            %Save the figure for later reference
            saveas(H, 'raw_data_right.fig', 'fig')
            
            figure('Name','raw_data_left');
            H = scatter(raw_vector(:,3), raw_vector(:,4));
            grid on;
            grid minor;
            saveas(H, 'raw_data_left.fig', 'fig')
            
                            %Show raw data scaled to screen proportion
                        figure('Name','scaled raw_data_right');
            H = scatter(raw_vector_sc(:,1), raw_vector_sc(:,2));
            grid on;
            grid minor;
            %Save the figure for later reference
            saveas(H, 'scaledraw_data_right.fig', 'fig')
            
            figure('Name','scaled raw_data_left');
            H = scatter(raw_vector_sc(:,3), raw_vector_sc(:,4));
            grid on;
            grid minor;
            saveas(H, 'scaledraw_data_left.fig', 'fig')

 %% Datapixx('FinishCalibration') uses the data captured in the preceeding steps and
 %runs a mathematical process to determine the formula that
 %will convert raw eye data to a calibrated gaze position on screen.
 
 %% 'GetCalibrationCoeff' returns an array of coefficients
 %calculated by the calibration process. Positions
 % - 1 to 9 are the coefficients for the right eye x axis.
 % - 10 to 18 are the coefficients for the right eye y axis.
 % - 19 to 27 are the coefficients for the left eye x axis.
 % - 28 to 36 are the coefficients for the left eye y axis.
 
 %coeff_x, coeff_y, coeff_x_L and coeff_y_L hold the
 %coefficients of the polynomials determined by the calibration
 %to correlate raw eye data to screen gaze position.
                     
%% evaluate_bestpoly applies raw eye positions to the polynomial and returns calibrated gaze position on screen.
%Evaluate all the calibration points

% 
%          [x_eval_cartesian,y_eval_cartesian] = evaluate_bestpoly(raw_vector(:,1)', raw_vector(:,2)', coeff_x, coeff_y);
%             [x_eval_L_cartesian,y_eval_L_cartesian] = evaluate_bestpoly(raw_vector(:,3)', raw_vector(:,4)', coeff_x_L, coeff_y_L);
%             right_eye_eval = [x_eval_cartesian' y_eval_cartesian'];
%             left_eye_eval = [x_eval_L_cartesian' y_eval_L_cartesian'];
%             %convert back to PsychToolbox coordinate system for display
%             xy_eval = Datapixx('ConvertCoordSysToCustom', right_eye_eval);
%             xy_eval_L = Datapixx('ConvertCoordSysToCustom', left_eye_eval);

%convert back to PsychToolbox coordinate system for display
%             x_eval = xy_eval(:,1)';
%             y_eval = xy_eval(:,2)';
%             x_eval_L = xy_eval_L(:,1)';
%             y_eval_L = xy_eval_L(:,2)';
=======
%%calibration results



% I get raw eye data from calibration procedure
% I estimate coefficients through Datapixx function(Datapixx('GetCalibrationCoeff'))
% I use 'evaluate_bestpoly' to apply raw eye positions to the polynomial and returns calibrated gaze position on screen.


%raw_vector + coeff= x_eval







 %'GetCalibrationCoeff' returns an array of coefficients
                %calculated by the calibration process. Positions 
                % - 1 to 9 are the coefficients for the right eye x axis.
                % - 10 to 18 are the coefficients for the right eye y axis.  
                % - 19 to 27 are the coefficients for the left eye x axis. 
                % - 28 to 36 are the coefficients for the left eye y axis.
%                 calibrations_coeff = Datapixx('GetCalibrationCoeff');
%evaluate_bestpoly applies raw eye positions to the polynomial
%and returns calibrated gaze position on screen.
%Evaluate all the calibration points

>>>>>>> Stashed changes

            %*_interpol_raw* variables contain raw interpolation points
            %between two calibration points.
            %*_interpol* variables hold the corresponding calibrated data
            %*_interpol_cartesian holds the coordinate system converted data
            %*_eye_interpol holds the raw data interpolation points in x
            %and y. Data organisation for convertion
            %xy_interpol* holds the calibrated and converted interpolation
            %data


            %Interpolate raw data between calibration points

            
            %Apply calibration to the interpolated raw data and convert to the
            %PsychToolbox coordinate system
      %       [x_interpol_cartesian(i,:),y_interpol_cartesian(i,:)] = evaluate_bestpoly(x_interpol_raw(i,:)', y_interpol_raw(i,:)', coeff_x, coeff_y);
       %         [x_interpol_L_cartesian(i,:),y_interpol_L_cartesian(i,:)] = evaluate_bestpoly(x_interpol_raw_L(i,:)', y_interpol_raw_L(i,:)', coeff_x_L, coeff_y_L);
  
% this is the same step as x_eval (raw data + coefficient) but on the whole
% grid



<<<<<<< Updated upstream
=======

            %*_interpol_raw* variables contain raw interpolation points
            %between two calibration points.
            %*_interpol* variables hold the corresponding calibrated data
            %*_interpol_cartesian holds the coordinate system converted data
            %*_eye_interpol holds the raw data interpolation points in x
            %and y. Data organisation for convertion
            %xy_interpol* holds the calibrated and converted interpolation
            %data
            % We have 12 segments and create 10 points each (for now)

            
            
            %validation results
>>>>>>> Stashed changes
%results
%target_result = [leftEyeTopLeft(:,1) leftEyeTopLeft(:,2) rightEyeTopLeft(:,1) rightEyeTopLeft(:,2)];

close all



            %first result page to display: scaled raw data
            
                                    figure
            scatter(raw_vector_sc(:,1), raw_vector_sc(:,2), 'r');
            hold on
scatter(raw_vector_sc(:,3), raw_vector_sc(:,4), 'b');
title( 'scaledraw_data');
xlim([0 1920]);
ylim([0 1080]);
set (gca,'YDir','reverse')
            
            

figure
            %2nd result page to display: right eye interpolation
scatter(targets(1,:),targets(2,:), 'filled');
hold on
scatter(x_eval,y_eval, 'filled'); % estimated eye location next to calibration dots
hold on
scatter(interpolated_dots(1,:)',interpolated_dots(2,:)', 'g', 'filled');
title( 'calibration right eye');
xlim([0 1920]);
ylim([0 1080]);
set (gca,'YDir','reverse')


figure
            %3rd result page to display; Left eye interpolation
scatter(targets(1,:),targets(2,:), 'filled');
hold on
scatter(x_eval_L,y_eval_L, 'filled'); % estimated eye location next to calibration dots
hold on
scatter(interpolated_dots_L(1,:)',interpolated_dots_L(2,:)', 'r' ,'filled');
title( 'calibration left eye');
xlim([0 1920]);
ylim([0 1080]);
set (gca,'YDir','reverse')

            %Calculate the error between calibration points and the corresponding gaze position
            %mean_err_r and mean_err_l hold the error at the 13 points of the
            %calibration to calculate the error average 

            figure
scatter(targets(1,:),targets(2,:), 'filled');
hold on
scatter(x_eval_L,y_eval_L, 'filled', 'r');
hold on
scatter(x_eval,y_eval, 'filled', 'g');
hold on
text(x_eval_L,y_eval_L,num2str(mean_err_l));
hold on
text(x_eval,y_eval,num2str(mean_err_r));
set (gca,'YDir','reverse')

xlim([0 1920]);
ylim([0 1080]);

%% Validation

%validation function calls this function to look at eye data
%[x_r_pos y_r_pos x_l_pos y_l_pos xRawRight yRawRight xRawLeft yRawLeft] = Datapixx('GetEyePosition');
% target_results collects the data from 'GetEyePosition' after some
% cartesian transformation









validation_results=results;


matsize=size(validation_results);
%size(results)
%
%
%   800     4    13
%1: points
%2: coordinates (left x, left y, right x, right y)
%3:locations



% nmb_pts=matsize(3);
%    avg_gaze_pos_l_x = zeros(nmb_pts,1);
%         avg_gaze_pos_l_y = zeros(nmb_pts,1);
%         avg_gaze_pos_r_x = zeros(nmb_pts,1);
%         avg_gaze_pos_r_y = zeros(nmb_pts,1);
%         avg_error_l_x = zeros(nmb_pts,1);
%         avg_error_l_y = zeros(nmb_pts,1);
%         avg_error_r_x = zeros(nmb_pts,1);
%         avg_error_r_y = zeros(nmb_pts,1);
%         avg_error_l = zeros(nmb_pts,1);
%         avg_error_r = zeros(nmb_pts,1);
%         std_error_l = zeros(nmb_pts,1);
%         std_error_r = zeros(nmb_pts,1);
%         for i=1:nmb_pts
%             avg_gaze_pos_l_x(i) = nanmean(results(:,1,i));
%             avg_gaze_pos_l_y(i) = nanmean(results(:,2,i));
%             avg_gaze_pos_r_x(i) = nanmean(results(:,3,i));
%             avg_gaze_pos_r_y(i) = nanmean(results(:,4,i));
%             avg_error_l_x(i) = targets(1,i) - avg_gaze_pos_l_x(i);
%             avg_error_l_y(i) = targets(2,i) - avg_gaze_pos_l_y(i);
%             avg_error_r_x(i) = targets(1,i) - avg_gaze_pos_r_x(i);
%             avg_error_r_y(i) = targets(2,i) - avg_gaze_pos_r_y(i);
%             avg_error_l(i) = sqrt(avg_error_l_x(i)^2 + avg_error_l_y(i)^2);
%             avg_error_r(i) = sqrt(avg_error_r_x(i)^2 + avg_error_r_y(i)^2);
%             std_error_l(i) = std(sqrt(results(:,1,i).^2 + results(:,2,i).^2));
%             std_error_r(i) = std(sqrt(results(:,3,i).^2 + results(:,4,i).^2));
%         end

% target locations
figure
scatter(targets(1,:),targets(2,:), 'filled');
hold on
scatter(avg_gaze_pos_l_x,avg_gaze_pos_l_y, 'filled', 'r');
hold on
scatter(avg_gaze_pos_r_x,avg_gaze_pos_r_y, 'filled', 'g');
hold on
text(avg_gaze_pos_l_x,avg_gaze_pos_l_y,num2str(avg_error_l));
hold on
text(avg_gaze_pos_r_x,avg_gaze_pos_r_y,num2str(avg_error_r));
set (gca,'YDir','reverse')

xlim([0 1920]);
ylim([0 1080]);




%% compare calibration with validation


        for i=1:nmb_pts
%             avg_gaze_pos_l_x(i) = nanmean(results(:,1,i));
%             avg_gaze_pos_l_y(i) = nanmean(results(:,2,i));
%             avg_gaze_pos_r_x(i) = nanmean(results(:,3,i));
%             avg_gaze_pos_r_y(i) = nanmean(results(:,4,i));
            cal_val_avg_error_l_x(i) = x_eval_L(i) - avg_gaze_pos_l_x(i);
            cal_val_avg_error_l_y(i) = y_eval_L(i) - avg_gaze_pos_l_y(i);
            cal_val_avg_error_r_x(i) = x_eval(i) - avg_gaze_pos_r_x(i);
            cal_val_avg_error_r_y(i) = y_eval(i) - avg_gaze_pos_r_y(i);
            

            cal_val_avg_error_l(i) = sqrt(cal_val_avg_error_l_x(i)^2 + cal_val_avg_error_l_y(i)^2);
            cal_val_avg_error_r(i) = sqrt(cal_val_avg_error_r_x(i)^2 + cal_val_avg_error_r_y(i)^2);
            std_error_l(i) = std(sqrt(results(:,1,i).^2 + results(:,2,i).^2));
            std_error_r(i) = std(sqrt(results(:,3,i).^2 + results(:,4,i).^2));
        end


figure
scatter(avg_gaze_pos_r_x,avg_gaze_pos_r_y, 'filled', 'g');
hold on
scatter(x_eval,y_eval, 'filled'); % estimated eye location next to calibration dots
hold on
text(avg_gaze_pos_r_x,avg_gaze_pos_r_y,num2str(cal_val_avg_error_r));

title( 'calibration right eye');
xlim([0 1920]);
ylim([0 1080]);
set (gca,'YDir','reverse')


figure
scatter(avg_gaze_pos_l_x,avg_gaze_pos_l_y, 'filled', 'r'); % validation dots

hold on
scatter(x_eval_L,y_eval_L, 'filled'); % estimated eye location next to calibration dots
hold on
text(avg_gaze_pos_l_x,avg_gaze_pos_l_y,num2str(cal_val_avg_error_l));

title( 'calibration left eye');
xlim([0 1920]);
ylim([0 1080]);
set (gca,'YDir','reverse')
