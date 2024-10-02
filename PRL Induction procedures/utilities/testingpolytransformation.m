raw_vector=[    2.0395    7.5599    5.5756    8.5289
    2.5732    2.4746    5.6342    2.9981
   11.9299    9.1079   15.4481    9.4482
    1.7989   14.1323    4.6968   14.7554
   -7.2005    6.8316   -4.6811    6.6574
   12.2186    3.1355   15.4061    3.7073
   -6.1862    1.3287   -3.7825    1.7862
   11.7901   14.3799   15.1184   16.2513
   -8.7770   13.7566   -5.5004   13.3973
    6.4136    5.2196    9.2472    5.8057
   -2.8467    4.5309   -0.3784    4.6917
   -2.8923   10.6316   -0.8869   10.5973
    6.3397   11.3111    9.1259   11.9288];

raw_vector=raw_vector*100000000;

xy= [         960         540
    960         890
    1560         540
    960         190
    360         540
    1560         890
    360         890
    1560         190
    360         190
    1260         715
    660         715
    660         365
    1260         365]';

xy=ones(2,13);
raw_vector=ones(4,13);
        %'FinishCalibration' uses the data captured in the preceeding steps and
        %runs a mathematical process to determine the formula that
        %will convert raw eye data to a calibrated gaze position on screen.
%-->    %It is MANDATORY to call FinishCalibration in order to calibrate
        %the tracker for a chinrest calibration
                Datapixx('FinishCalibration');

                %'GetCalibrationCoeff' returns an array of coefficients
                %calculated by the calibration process. Positions 
                % - 1 to 9 are the coefficients for the right eye x axis.
                % - 10 to 18 are the coefficients for the right eye y axis.  
                % - 19 to 27 are the coefficients for the left eye x axis. 
                % - 28 to 36 are the coefficients for the left eye y axis.
                calibrations_coeff = Datapixx('GetCalibrationCoeff');
                 coeff_x = calibrations_coeff(1:9);
                coeff_y = calibrations_coeff(10:18);
                coeff_x_L = calibrations_coeff(19:27);
                coeff_y_L = calibrations_coeff(28:36);
                
                
                
                
                
%                 calibrations_coeff'
% 
% ans =
% 
%  -191.5165
%    70.8804
%    13.3566
%          0
%    -0.5557
%    -0.0508
%    -0.5660
%          0
%     0.0020
%  -480.2185
%    -4.7727
%    67.5730
%          0
%    -0.6041
%     0.0689
%    -0.7370
%    -0.0038
%          0
%  -390.1602
%    64.5183
%    21.6840
%          0
%    -0.9119
%          0
%    -0.3248
%    -0.0729
%     0.0042
%  -523.4175
%   -10.6438
%    77.8564
%     0.3512
%    -1.1525
%     0.0217
%          0
%    -0.0253
%          0
