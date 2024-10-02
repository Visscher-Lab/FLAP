function HitKeyToContinue(prompt)
% HitKeyToContinue([prompt='\nPress any key to continue...'])
%
% Print a prompt to the console, then wait for user to press a key
%
% Optional arguments:
%
% prompt = String to print to console before waiting for keypress.
%
% History:
%
% 8/1/09	paa		Written
if nargin > 0
    fprintf(prompt);
else
    fprintf('\nPress any key to continue...');
end
if (exist('OCTAVE_VERSION'))
    fflush(stdout);
end
KbReleaseWait;
while ~KbCheck
    WaitSecs(0.05);      % Don't hog CPU
end
fprintf('\n');
