function [Bpress RespTime TheButtons bin_buttonpress inter_buttonpress] = getEventPixx(TargList,starttime)
%% Documentation added AYS 5/3/2023
% This function has several uses:
% 1. record RESPONSEpixx button presses and reaction times
% 2a. start a task with an MRI trigger/pulse (11)
% 2b. sync the start of a trial on an MRI trigger/pulse (11)
%
% In short, this function will look out for TargList from starttime until
% starttime+responseduration. See arguments below for details.
%
% INPUT ARGUMENTS
% responseduration (REQUIRED): time in secs to wait for a button press or trigger
% TargList (REQUIRED): list of values to restrict what button/trigger to take, where:
%   1=red button, 2=yellow, 3=green 4=blue, 5=white, 11=MRI trigger
%      - For example, to restrict to only red and green, Targlist = [1 3]
% starttime (OPTIONAL): when this function should start recording. If empty, starttime
% is set to when the function is called.
%
%
% OUTPUT ARGUMENTS
% Bpress: whether a button/trigger was recorded (0 or 1)
% RespTime: response time in secs of button/trigger after starttime
% TheButtons: an index for the list , where
%    1=red button, 2=yellow, 3=green 4=blue, 5=white, 11=MRI trigger
% bin_buttonpress: reversed binary representation of the button pressed
%     for example, here possible values for 4 buttons:
%       - red =    '1000101011111111' 
%       - yellow = '0100101011111111'
%       - green =  '0010101011111111'
%       - blue =   '0001101011111111'
% inter_butonpress: binary representation of the button pressed

% outside function?
dinRed      = hex2dec('1'); % 1
dinYellow   = hex2dec('2'); % 2
dinGreen    = hex2dec('4'); % 4
dinBlue     = hex2dec('8'); % 8
mri_trigger = hex2dec('400'); % 1024

%% Initialize deafult values
Bpress=0;
timestamp=-1;
TheButtons=-1;
inter_buttonpress{1}=[]; % added by Jason because matlab was throwing and error 
                         % saying that inter_buttonpress was not assigned. 
                         % 26 June 2018
RespTime=[];
binaryvals=[];
bin_buttonpress{1}=[]; % Jerry:use array instead of cell
inter_timestamp{1}=[]; % JERRY: NEVER USED, DO NOT UNDERSTAND WHAT IT STANDS FOR
                         
Datapixx('RegWrRd');
buttonLogStatus = Datapixx('GetDinStatus');

if buttonLogStatus.logRunning~=1 % initialize digital input log if not up already.
    Datapixx('SetDinLog'); %added by Jerry
    Datapixx('StartDinLog');
    Datapixx('RegWrRd');
    buttonLogStatus = Datapixx('GetDinStatus');
    Datapixx('RegWrRd');
end
if ~exist('starttime','var') % var added by Jason 
    Datapixx('RegWrRd');
    starttime=Datapixx('GetTime');
elseif  isempty(starttime)  % modified by Jerry from else to elseif
    Datapixx('RegWrRd');
    starttime=Datapixx('GetTime');
end

%counter=0;
Datapixx('RegWrRd');
%while ( (Datapixx('GetTime') < (starttime) ) && ~Bpress)

if ~Bpress
    if (buttonLogStatus.newLogFrames > 0)
        [buttonpress, timestamp] = Datapixx('ReadDinLog');
        for counter=1:buttonLogStatus.newLogFrames
            binaryvals=dec2bin(buttonpress(counter)); %convert triggers to binary values Jerry : should use (counter) index
            binaryvals=binaryvals(end:-1:1); %reorder to left to right
            inter_buttonpress{counter}=buttonpress(counter); %actual output : bits order: "Right to Left"
            bin_buttonpress{counter}=binaryvals; %saved output: bits order : "Left to Right"
            inter_timestamp{counter}=timestamp;
            if (bitand(buttonpress(counter),dinRed+dinYellow+dinGreen+dinBlue+mri_trigger) ~=0) && any(str2num(binaryvals(TargList)))
                Bpress=1;
                TheButtons=TargList(find(binaryvals(TargList)=='1'));
                RespTime=timestamp(counter)-starttime;       
            end    
        end % for counter
    end % for newLogFrames > 0
    Datapixx('RegWrRd');
    buttonLogStatus = Datapixx('GetDinStatus');
%   initialValues = Datapixx('GetDinValues')
    WaitSecs(.002); % avoids tight loop Jerry: DO NOT understand
    Datapixx('RegWrRd');
end
%end
Datapixx('StopDinLog');  % maybe outside function?
