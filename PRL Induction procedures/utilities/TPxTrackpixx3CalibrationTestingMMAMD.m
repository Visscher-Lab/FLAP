function TPxTrackpixx3CalibrationTestingMMAMD(baseName, original, pix_deg)
% TPxTrackpixx3CalibrationTesting()
%
% This demo calibrates the current session for the TRACKPixx tracker and 
% shows you the results of the calibration. Once the calibration is
% finished, a gaze follower is started to know the results of the
% calibrations. If you wish to reuse the same calibrations, they are
% availible in Matlab as long as you do not call a "clear all; close all;"
%
% Steps are as follow: 
% 1- Initialize the TRACKPixx. You need to set the LED itensity and the

% Iris size in pixel. Usual values are 70 for 25mm lens, 140 for 50mm lens
% and 150 for MRI.
% 2- Open the Psychtoolbox Window and show the Eye Picture for focusing of
% 
% the TRACKPixx. To go to the next step, press any key. Escape will exit.
% M will trigger manual calibration (key press between fixations)
% 3- Show the calibration dots and the calibration results.
% 4- Gaze following demo to show that the calibration worked fine.
%
% Once this demo is done, if you call the data recording schedule, the eye
% data will be calibrated.



%clear all;
%close all;

%Sets to which screen the calibration will be done, if the platform supports
%multi screen.
%Screen('Preference', 'SkipSyncTests', 1); 
 
screenNumber = 2; %3 originally

TPxCalibrationTestingMMAMD(1,screenNumber, baseName,original, pix_deg)

end