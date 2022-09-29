function TPxTrackpixxMiniWithChinrestCalibrationTesting()
% TPxTrackpixxMiniWithChinrestCalibrationTesting()
%
% This demo calibrates the current session for the TRACKPixx /mini tracker
% with chinrest and shows you the results of the calibration.  Once the
% calibration is finished, a gaze follower is started to know the results
% of the calibrations. If you wish to reuse the same calibrations, they are
% availible in Matlab as long as you do not call a "clear all; close all;"
%
% Steps are as follow: 
%
% 1- Initialize the TRACKPixx /mini.
%
% 2- Open the Psychtoolbox Window and show the Eye Picture.
%
% To go to the next step, press any key. Escape will exit. M will trigger
% manual calibration (key press between fixations)
%
% 3- Show the calibration dots and the calibration results. 4- Gaze
% following demo to show that the calibration worked fine.
%



clear all;
close all;

%Sets to which screen the calibration will be done, if the platform supports
%multi screen.
screenNumber = 3; %3 originally

TPxCalibrationTesting(0,0,screenNumber,0)

end