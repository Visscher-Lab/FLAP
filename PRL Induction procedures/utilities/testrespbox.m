 clear all
 responsebox=1;
 Datapixx('Close');

      
% Open Datapixx, and stop any schedules which might already be running
Datapixx('Open');

% Configure digital input system for monitoring button box
Datapixx('SetDinDataDirection', hex2dec('1F0000'));     % Drive 5 button lights
Datapixx('EnableDinDebounce');                          % Debounce button presses
Datapixx('SetDinLog');                                  % Log button presses to default address
Datapixx('StartDinLog');                                % Turn on logging
Datapixx('RegWrRd');
    % Wait until all buttons are up
    while (bitand(Datapixx('GetDinValues'), hex2dec('FFFF')) ~= hex2dec('FFFF'))
        Datapixx('RegWrRd');
    end
        % Flush any past button presses
    Datapixx('SetDinLog');
    Datapixx('RegWrRd');
      stup=0;
      
%       
%     % Wait up to 1 second for a keypress
%     while (Datapixx('GetTime') >1)
%         Datapixx('RegWrRd');
%         buttonLogStatus = Datapixx('GetDinStatus');
%         if (buttonLogStatus.newLogFrames > 0)
%                 stup=1
%   break;
%         end
%     end

     
      
      % 
%       
%       
%       
%      while stup==0
%       buttonLogStatus = Datapixx('GetDinStatus')
%    
%       
%                 if (buttonLogStatus.newLogFrames > 0)
%                     [thekeys timetags] = Datapixx('ReadDinLog');
%                 end    
%       
%       if exist('thekeys')==1
%         stup=1  
%       end
%      end

timetags=-2
while timetags<0
            if responsebox==1 % DATApixx AYS 5/4/23 I added some documentation for WaitForEvent_Jerry - let me know if you have questions.
                %  [Bpress, RespTime, TheButtons] = WaitForEvent_Jerry(0, TargList);
                Datapixx('RegWrRd');
        buttonLogStatus = Datapixx('GetDinStatus');
                if (buttonLogStatus.newLogFrames > 0)
                    [thekeys timetags] = Datapixx('ReadDinLog');
                end              
       %         [keyIsDown, keyCode] = KbQueueCheck;
            else % AYS: UCR and UAB?
                [keyIsDown, keyCode] = KbQueueCheck;
            end
end


      Datapixx('Close');
