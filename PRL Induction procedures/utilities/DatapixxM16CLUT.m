function DatapixxM16CLUT()
% DatapixxM16CLUT()
%
% A demonstration of the DATAPixx M16 (16-bit monochrome) video mode using the 
% PsychToolbox imaging pipeline. This demo uses Psychtoolbox's Color
% correction to implement a CLUT to modify the values before they are sent
% to the VPixx device instead of using the on hardware CLUT which is used
% for overlay functions.
%
% Please note that for GetVideoLine you need to disable PBT drawing of the
% first line blank, done in PsychDatapixx.m:
% glDrawPixels(size(dpx.blackline, 2), 1, GL.RGB, GL.UNSIGNED_BYTE, dpx.blackline);
%
% History:
%
% Oct 29, 2016  dml     Written
% Mar 7, 2018   dml     Revised


% Prepare configuration
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');
PsychImaging('AddTask', 'General', 'EnableDataPixxM16Output'); % without overlay!
PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'LookupTable'); % Using a CLUT

%Open the screen
screenNumber=max(Screen('Screens'));
[window, wRect] = PsychImaging('OpenWindow', screenNumber, [1 1 0]);

% Load a linear ramp into the graphics card's LUT, such that the graphics
% card does not further modify our pixel values.
Screen('LoadNormalizedGammaTable',window,linspace(0,1,256)'*ones(1,3));


% Define a custom LUT

% You can use a 14 bit CLUT in Psychtoolbox at most. Can be useful
% when you are estimating the colors you will see sent to the display.
% Lmin=0;
% Lmax=1;
% clut(1:16384,1) = linspace(Lmin,Lmax,16384)';

% In this example we want to clamp the full range of color to 0.4 -> 0.6
% (or 26214 to 39321 in 16 bits value)
Lmin=0.4; % Clamping 0.4 -> 0.6 in 256 steps.
Lmax=0.6;
clut(1:256,1) = linspace(Lmin,Lmax,256)';
clut = repmat(clut,1,3);
PsychColorCorrection('SetLookupTable', window, clut); % Set up the CLUT for Psychtoolbox


Screen('FillRect',window, 0); % Set to "black", which will be (0.4, 0.4, 0.4)
Screen('Flip',window);

% We will show from 0.4 to 0.6 in 10 steps. Important to keep the color values
% in the range of 0.0 to 1.0 and not 0 to 255 to keep the full 16 bits+ 
% of precision during calculations. 

x=(linspace(0,1,10));   

for i=1:length(x)
	% Fill full screen such that we may access the top line value to make
	% sure right values are sent
    Screen('FillRect',window,x(i));
    Screen('Flip',window);
    %pause;
    WaitSecs(1);
    % Querry the CLUT to know the color we will  approximetly* present
    % *approximetly because colors are 16 bits and clut is 8 bits.
    size_clut = length(clut);
    value_clut = round(clut(round(x(i)*(size_clut-1))+1)*65535); % +1 because we're not at 0 index
    red_val = bitand(value_clut, 65280)/256;
    green_val = bitand(value_clut, 255); % Value wont be exact because CLUT is not 16 bits like color.
    
    % Check measured values
    Datapixx('RegWrRd');
    measured_data = Datapixx('GetVideoLine', 1); % Check the first pixel value recieved.
    color_16 = measured_data(1)*256+measured_data(2);
    fprintf('Approximation\t 16-bit color: %d,\t M16:(%d,%d,%d)\n', value_clut, red_val, green_val, 0);
    fprintf('Measured\t\t 16-bit color: %d,\t Pixels:(%d,%d,%d)\n\n', color_16, measured_data(1), measured_data(2), measured_data(3));
end


% Restore everything to normal state.
Screen('FillRect',window,0);
Screen('LoadNormalizedGammaTable',window,linspace(0,1,256)'*ones(1,3));
RestoreCluts;
Screen('Flip',window);
sca;

end