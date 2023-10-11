function [Bpress, RespTime, TheButtons, bin_buttonpress, inter_buttonpress,PTBRespTime] = DontWaitForEvent_Jerry4(TargList, Bpress, TheButtons, RespTime,timestamp, binaryvals,inter_buttonpress, bin_buttonpress, inter_timestamp,PTBRespTime)
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
% TargList (REQUIRED): list of values to restrict what button/trigger to take, where:
%   1=red button, 2=yellow, 3=green 4=blue, 5=white, 11=MRI trigger
%      - For example, to restrict to only red and green, Targlist = [1 3]
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

dinRed      = hex2dec('1'); % 1
dinYellow   = hex2dec('2'); % 2
dinGreen    = hex2dec('4'); % 4
dinBlue     = hex2dec('8'); % 8
mri_trigger = hex2dec('400'); % 1024


    
Datapixx('RegWrRd');
buttonLogStatus = Datapixx('GetDinStatus');
Datapixx('RegWrRd');
if ~Bpress
    if (buttonLogStatus.newLogFrames > 0)
        fofo=buttonLogStatus.newLogFrames;
        [buttonpress, timestamp] = Datapixx('ReadDinLog');
        for counter=1:buttonLogStatus.newLogFrames
            binaryvals=dec2bin(buttonpress(counter)); %convert triggers to binary values Jerry : should use (counter) index
            binaryvals=binaryvals(end:-1:1); %reorder to left to right
            inter_buttonpress{counter}=buttonpress(counter); %actual output : bits order: "Right to Left"
            bin_buttonpress{counter}=binaryvals; %saved output: bits order : "Left to Right"
            inter_timestamp{counter}=timestamp;
            if (bitand(buttonpress(counter),dinRed+dinYellow+dinGreen+dinBlue+mri_trigger) ~=0) && any(str2num(binaryvals(TargList)))
                Bpress=1;
                TheButtons=find(binaryvals(TargList)=='1');
                RespTime=timestamp(counter);
                PTBRespTime=GetSecs;
            end
        end % for counter
    end % for newLogFrames > 0
    Datapixx('RegWrRd');
    buttonLogStatus = Datapixx('GetDinStatus');
    %   initialValues = Datapixx('GetDinValues')
    WaitSecs(.002); % avoids tight loop Jerry: DO NOT understand
    Datapixx('RegWrRd');
end
end
