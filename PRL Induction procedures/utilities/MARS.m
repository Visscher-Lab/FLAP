

log_steps=[0.02:0.02:1];
% set up Psychtoolbox

% compute alpha value for 0.4 log contrast
contrast = 0.4; % in log units
contrast_ratio = 10^(contrast);
alpha = sqrt(contrast_ratio); % square root of contrast ratio

PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
screen_number = max(Screen('Screens'));
[window_pointer, window_rect] = Screen('OpenWindow', screen_number, 0);

% set stimulus properties
stimulus_size = 100; % in pixels
background_luminance = 0.5;
max_luminance = 1; % full contrast
min_luminance = 0;

% create stimulus image
stimulus_image = ones(stimulus_size, stimulus_size) * max_luminance;

% display stimulus
destination_rect = [0 0 stimulus_size stimulus_size];
alpha = 10^(0.4)^(1/alpha); % compute alpha value for 0.4 log contrast
Screen('DrawTexture', window_pointer, stimulus_image, [], destination_rect, 0, alpha);
Screen('Flip', window_pointer);

% wait for response
KbWait;

% clean up
Screen('CloseAll');
