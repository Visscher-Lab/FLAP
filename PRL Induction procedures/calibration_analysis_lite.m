
%% Summary
% we present 13 dots in a pre-arranged display
% we collect 13 eye positions using DataPixx('GetEyeDuringCalibrationRaw')
% we have now 13 'raw data' locations
% 'raw data' is in deg coordinates, calibration dots are in screen
% coordinates (see 'coordinate system' below)
% we run two scripts in the general DataPixx MEX file:
%1: Datapixx('FinishCalibration') uses the data captured in the preceeding steps and
%runs a mathematical process to determine the formula that
%will convert raw eye data to a calibrated gaze position on screen.
% 2: Datapixx('GetCalibrationCoeff') returns an array of coefficients
%calculated by the calibration process.
% each axis has 9 coefficients.
%the relationship between raw eye data and screen gaze position is
%determined by 4 different polynomials representing each axis of each eye.
%The same calibration process will be performed for each independent axis
%and eye giving four independent calibration processes and results
% evaluate_bestpoly () evaluates a polynomial based on the raw data and the coefficient
%we apply the polynomial transformation to a linear grid derived by the 13
%points captured during calibration ('raw data' coordinates)
% we estimate error as the distance between the 13 dots in a pre-arranged
% display and the estimated location from polynomial
% we convert the scores back to PsychToolbox coordinate system for display
% for validation, we show again the 13 dots in a pre-arranged display and record eye
% movements with Datapixx('GetEyePosition') (unlike during calibration) and
% we estimate error



%% Calibration
% DataPixx('GetEyeDuringCalibrationRaw') acquires eye data from tracker
%It also saves that data in memory and is used (once all
%targets are run) to calculate the formula used to convert
%raw eye data to calibrate screen position.
%raw_vector contains the raw eye information from the tracker. 
% 1 - right eye horzontal axis (x)
% 2 - right eye vertical axis (y)
% 3 - left eye horizontal axis (x)
% 4 - left eye vertical axis (y)

%% plot calibration results
%Plot the results of the calibrations (raw data
%distribution gathered during calibration)

close all
figure
subplot(2,1,1)
scatter(raw_vector(:,1), raw_vector(:,2), 'b');
xlabel('x dva')
xlabel('y dva')
title('right eye raw calib')
pbaspect([1.5 1 1]);

subplot(2,1,2)
scatter(raw_vector(:,3), raw_vector(:,4), 'r');
xlabel('x dva')
xlabel('y dva')
title('left eye raw calib')
pbaspect([1.5 1 1]);

print('raw calib points', '-dpng', '-r300'); %<-Save as PNG with 300 DPI

figure
scatter(raw_vector(:,1), raw_vector(:,2), 'b');
hold on
scatter(raw_vector(:,3), raw_vector(:,4), 'r');
xlabel('x dva')
xlabel('y dva')
title('bino raw calib')
pbaspect([1.5 1 1]);
legend('right eye', 'left eye')

print('raw calib points bino', '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%% interpolated raw data:
%raw interpolation points between two calibration points.

figure
scatter(x_interpol_raw(:),y_interpol_raw(:),'b', 'filled')
hold on
scatter(raw_vector(:,1), raw_vector(:,2), 'k', 'filled');
title( 'interpolated raw_data right');

print('interpolated raw data right', '-dpng', '-r300'); %<-Save as PNG with 300 DPI

figure
scatter(x_interpol_raw_L(:),y_interpol_raw_L(:), 'r', 'filled')
hold on
scatter(raw_vector(:,3), raw_vector(:,4), 'k', 'filled');
title( 'interpolated raw_data left');

print('interpolated raw data left', '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%% 1st result page from Vpixx calibration script: scaled raw data
% this is just for representation purposes
figure
scatter(targets(1,:),targets(2,:), 140, 'd');
hold on
scatter(raw_vector_sc(:,1), raw_vector_sc(:,2), 'b', 'filled');
hold on
scatter(raw_vector_sc(:,3), raw_vector_sc(:,4), 'r', 'filled');
xlabel('x dva')
xlabel('y dva')
legend('coord', 'right eye', 'left eye')
title('bino raw scaled calib')
print('raw calib points scaled bino', '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%% Calibration procedure
% 1: Datapixx('FinishCalibration') uses the data captured in the preceeding steps and
%runs a mathematical process to determine the formula that
%will convert raw eye data to a calibrated gaze position on screen.
% 2: Datapixx('GetCalibrationCoeff') returns an array of coefficients
%calculated by the calibration process. Positions
% - 1 to 9 are the coefficients for the right eye x axis.
% - 10 to 18 are the coefficients for the right eye y axis.
% - 19 to 27 are the coefficients for the left eye x axis.
% - 28 to 36 are the coefficients for the left eye y axis.

%coeff_x, coeff_y, coeff_x_L and coeff_y_L hold the
%coefficients of the polynomials determined by the calibration
%to correlate raw eye data to screen gaze position.
%3: evaluate_bestpoly () applies raw eye positions to the polynomial and returns calibrated gaze position on screen.
%Evaluate all the calibration points
%the relationship between raw eye data and screen gaze position is
%determined by 4 different polynomials representing each axis of each eye.
%The same calibration process will be performed for each independant axis
%and eye giving four independent calibration processes and results:
%right eye x axis, right eye y axis,
%left eye x axis and left eye y axis.


% xy_eval is the raw eye position adjusted by the 9 element polynomial
% function plus coefficients


figure
scatter(targets(1,:),targets(2,:), 140, 'k', 'd');
hold on
scatter(x_eval,y_eval, 'b', 'filled'); % estimated eye location next to calibration dots
hold on
scatter(x_eval_L,y_eval_L, 'r','filled'); % estimated eye location next to calibration dots
legend('coord', 'right eye', 'left eye')
title('Calibrated coordinates')
print(' calib points bino', '-dpng', '-r300'); %<-Save as PNG with 300 DPI


%% 2nd result page from Vpixx calibration script: right eye interpolation

% this is the same step as x_eval (raw data + coefficient) but on the whole
% interpolated grid
figure

scatter(targets(1,:),targets(2,:), 'k','filled');
hold on
scatter(x_eval,y_eval, 'filled'); % estimated eye location next to calibration dots
hold on
scatter(interpolated_dots(1,:)',interpolated_dots(2,:)', 'b', 'filled');
title( 'calibration right eye');
xlim([0 1920]);
ylim([0 1080]);
set (gca,'YDir','reverse')

print('interpolated right eye data', '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%% 3rd result page from Vpixx calibration script:Left eye interpolation
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
print('interpolated left eye data', '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%% 4th result page from Vpixx calibration script:Calibration error
% difference between calibration dots an eye data collected with DataPixx('GetEyeDuringCalibrationRaw')
figure
scatter(targets(1,:),targets(2,:), 140,'d','k');
hold on
scatter(x_eval_L,y_eval_L, 'filled', 'r');
hold on
scatter(x_eval,y_eval, 'filled', 'b');
hold on
mean_err_l_round=round(mean_err_l,1)';
text(x_eval_L,y_eval_L,num2str(mean_err_l_round));
hold on
mean_err_r_round=round(mean_err_r,1)';
text(x_eval,y_eval,num2str(mean_err_r_round));
set (gca,'YDir','reverse')
title('Cal error')
legend('coord', 'right eye', 'left eye')

xlim([0 1920]);
ylim([0 1080]);
text(1200, 950,['right eye mean error = ' num2str(nanmean(mean_err_r_round))]);
text(1200, 1000,['left eye mean error = ' num2str(nanmean(mean_err_l_round))]);

print('cal points and error', '-dpng', '-r300'); %<-Save as PNG with 300 DPI


%% Validation
%[x_r_pos y_r_pos x_l_pos y_l_pos xRawRight yRawRight xRawLeft yRawLeft] = Datapixx('GetEyePosition');
% target_results collects the data from 'GetEyePosition' after some
% cartesian transformation. this function is the same used in the gaze
% contingent studies (it's the 'calibrated' eye position)

%% 4th result page from Vpixx calibration script: average error validation
figure
scatter(targets(1,:),targets(2,:), 140,'d','k');
hold on
scatter(avg_gaze_pos_l_x,avg_gaze_pos_l_y, 'filled', 'r');
hold on
scatter(avg_gaze_pos_r_x,avg_gaze_pos_r_y, 'filled', 'b');
hold on
avg_error_l_round=round(avg_error_l,1);
text(avg_gaze_pos_l_x,avg_gaze_pos_l_y,num2str(avg_error_l_round));
hold on
avg_error_r_round=round(avg_error_r,1);
text(avg_gaze_pos_r_x,avg_gaze_pos_r_y,num2str(avg_error_r_round));
set (gca,'YDir','reverse')
title('validation error')
legend('coord', 'right eye', 'left eye', 'southeast')

xlim([0 1920]);
ylim([0 1080]);
text(1200, 950,['right eye mean error = ' num2str(nanmean(avg_error_r_round))]);
text(1200, 1000,['left eye mean error = ' num2str(nanmean(avg_error_l_round))]);

print('average error validation', '-dpng', '-r300'); %<-Save as PNG with 300 DPI



% extract coefficients through least square regression

% P = polyfit(X,Y,N) finds the coefficients of a polynomial P(X) of
%     degree N that fits the data Y best in a least-squares sense. P is a
%     row vector of length N+1 containing the polynomial coefficients in
%     descending powers, P(1)*X^N + P(2)*X^(N-1) +...+ P(N)*X + P(N+1).

scatter(targets(1,:),targets(2,:), 140, 'd');

P = polyfit(targets(1,:)',raw_vector(:,1),3)
% 1 = Cst
% 2 = x
% 3 = y
% 4 = x^2
% 5 = y^2
% 6 = x^3 || xy^2
% 7 = xy
% 8 = x^2y
% 9 = x^2y^2

%% Coordinate system:
%Psychtoolbox uses a coordinate system having an origin at the top left
%corner of the screen.  Functions are used  to convert back and forth
%between custom coordinate systems and the cartesian coordinate system (origin at center of the screen).

% 1 - 'ConvertCoordSysToCartesian'
% 2 - 'ConvertCoordSysToCustom'

%Both functions take an array of coordinates, the offset of the origin to
%the center and the scaling for both x and y coordinates as inputs and then return
%the converted array of coordinates. Using default offset and scaling will
%convert back and forth to the PsychToolbox coordinate system.


% Input data
x = [960 960 1560 960 360 1560 360 1560 360 1260 660 660 1260];
y = [540 890 540 190 540 890 890 190 190 715 715 365 365];
z = [1.2450 1.7453 11.4313 1.1994 -7.8870 11.2800 -7.2230 11.1132 -9.1896 5.8908 -2.8528 -3.1911 6.5344];

z2= [5.9377
    1.3619
    7.5133
   12.9373
    6.2685
    2.3452
    0.4560
   13.1628
   13.0640
    4.7474
    3.9025
    9.9113
   10.4464];
% Create polynomial features up to degree 3
X = [ones(size(x)), x, y, x.^2, y.^2, x.*y, x.^2.*y, x.*y.^2, x.^3];
X = [ones(size(x)), x, y, x.^2, y.^2, x.*y, x.^2.*y, y.^2.*x.^2, x.^3, y.^3];
% Perform linear regression
coeff = X\z2';

% Print coefficients
disp(coeff');


%% find x and y from coefficient (reverse-engineering datapixx script to generate x and y from their coefficients)
% define the coefficients
coeff = [-112.7053; 69.8383; 2.2812; 0; 0; -0.0390; -0.5724; -0.0276; 0.0039];

% define the z values
z = [1.2450; 1.7453; 11.4313; 1.1994; -7.8870; 11.2800; -7.2230; 11.1132; -9.1896; 5.8908; -2.8528; -3.1911; 6.5344];

% create the matrix X
x = [960; 960; 1560; 960; 360; 1560; 360; 1560; 360; 1260; 660; 660; 1260];
y = [540; 890; 540; 190; 540; 890; 890; 190; 190; 715; 715; 365; 365];
X = [ones(size(x)), x, y, x.^2, y.^2, x.*y, x.^2.*y, x.*y.^2, x.^3];


% estimate x and y
xy_est = X * coeff;
x_est = xy_est(1:length(xy_est)/2);
y_est = xy_est(length(xy_est)/2+1:end);