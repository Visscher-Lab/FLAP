 % ResponseBoxFlush
 
 
 if responsebox==1
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
            %
            % Datapixx('RegWrRd');
            % buttonLogStatus = Datapixx('GetDinStatus');
            
            % if buttonLogStatus.logRunning~=1 % initialize digital input log if not up already.
            %     Datapixx('SetDinLog'); %added by Jerry
            %     Datapixx('StartDinLog');
            %     Datapixx('RegWrRd');
            %     buttonLogStatus = Datapixx('GetDinStatus');
            %     Datapixx('RegWrRd');
            % end
            % if ~exist('starttime','var') % var added by Jason
            %     Datapixx('RegWrRd');
            %     starttime=Datapixx('GetTime');
            % elseif  isempty(starttime)  % modified by Jerry from else to elseif
            %     Datapixx('RegWrRd');
            %     starttime=Datapixx('GetTime');
            % end
            
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
        end