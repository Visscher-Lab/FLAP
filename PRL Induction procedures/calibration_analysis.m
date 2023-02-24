% calibration default locations
% targets

%%calibration results
%evaluate_bestpoly applies raw eye positions to the polynomial
%and returns calibrated gaze position on screen.
%Evaluate all the calibration points

%convert back to PsychToolbox coordinate system for display
%             x_eval = xy_eval(:,1)';
%             y_eval = xy_eval(:,2)';
%             x_eval_L = xy_eval_L(:,1)';
%             y_eval_L = xy_eval_L(:,2)';


%validation results
%results
%target_result = [leftEyeTopLeft(:,1) leftEyeTopLeft(:,2) rightEyeTopLeft(:,1) rightEyeTopLeft(:,2)];

close all
figure
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
scatter(targets(1,:),targets(2,:), 'filled');
hold on
scatter(x_eval_L,y_eval_L, 'filled'); % estimated eye location next to calibration dots
hold on
scatter(interpolated_dots_L(1,:)',interpolated_dots_L(2,:)', 'r' ,'filled');
title( 'calibration left eye');
xlim([0 1920]);
ylim([0 1080]);
set (gca,'YDir','reverse')


%% Validation
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
