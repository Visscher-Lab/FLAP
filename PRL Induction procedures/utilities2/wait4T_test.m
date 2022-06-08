function startTime = wait4T(tChar)

%% Waits for a trigger from the scanner
%
%   Usage:
%   startTime = wait4T(tChar);
%
%   Defaults:
%   tChar = {'t'};
%
%   Written by Andrew S Bock Aug 2016

%% set defaults
if ~exist('tChar','var')
    tChar = {'t'};
end
ch = '';
FlushEvents;
while ~sum(strcmp(ch,tChar));
   % ch = GetChar;
   ch = KbCheck
    pause(0.001);
end
startTime = GetSecs;  %read the clock
