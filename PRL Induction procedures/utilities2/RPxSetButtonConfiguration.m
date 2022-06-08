function RPxSetButtonConfiguration
%
%This demo records button presses and assigns the 24- and 16-bit digital input values
%custom labels entered by the user. The demo saves the input as a .csv
%table which you can load in your own experiment.


% Tested with:
% -- DATAPixx3 firmware revision 19 
% -- MATLAB version 9.6.0.1150989 (R2019a) 
% -- Psychtoolbox version 3.0.15 
% -- Datapixx Toolbox version 3.7.6015
% -- Windows 10 version 1903, 64bit

% Mar 3  2020   lef     written
% Mar 26 2020   lef     tested & commented

fprintf('\n---------------------------------------------------------');
fprintf('\n\nWelcome to the button configuration demo!'); 
fprintf('\n---------------------------------------------------------');
fprintf('\nThis demo will create and save a .csv file in the current directory.');
fprintf('\nThe file contains a lookup table of digital input codes from the digital in port, and their custom labels.');
fprintf('\nWe save two input codes, one for the DinSchedule (24-bit) and one for the DinLog (16-bit)'); 

fprintf('\n\nIn your own experiment script, simply use the appropriate lookup column to interpret the digital input codes from your VPixx device.');
fprintf('\nYou can save multiple custom button labels in different files.');

fprintf('\n\nThe first entry in the table is always the code for "NothingPressed". After that, you can enter as many button labels as you want.');
fprintf('\nSimply enter the name of the button (or button combination) you desire. Then press that button (or buttons) and hit Enter.') ;
fprintf('\nAt the end of the demo, you will see a summary of your lookup table contents. You can also run a test to check your values.');

fprintf('\n\nYou will need to have a RESPONSEPixx is plugged in to a VPixx device, with the device turned on.');

input('\n\nHit Enter to start', 's'); 

%% 
fprintf('\n---------------------------------------------------------\n');

KbName('UnifyKeyNames');

%Connect to VPixx device
Datapixx('Open');

%Turn on Debounce, which suppresses inputs caused by oscillations on button
%press. Lasts for 30 milliseconds following initial press. 
Datapixx('EnableDinDebounce');

%Get a filename for the table
filename = input('Please enter the name of your table: ', 's');
filename = [filename '.csv'];

%First entry is always "Nothing Pressed", which is helpful when we want to
%log button releases
fprintf('\nFirst, we will create an entry for "NothingPressed." Please ensure no RESPONSEPixx buttons are down, then hit spacebar');
waitForConfirm('space');

%Read the current state of the VPixx device
Datapixx('RegWrRd');

%Record the last values on the digital input. DinValues and the DinSchedule
%measure all 24 digital inputs. However, the DinLog only measures 16 bits,
%and we'd like to keep track of this code as well for maximum flexibility
%in our table. To get the 16 bit value, we convert convert 24 bits to
%binary to get the state of each digital output (from 24 --> 0). Then we
%convert the last 16 values back to decimal.
Din24 = Datapixx('GetDinValues');
Din24Binary = dec2bin(Din24);
try
    Din16 = bin2dec(Din24Binary(end-15:end));
catch
    Din16 = bin2dec(Din24Binary);
end

%Let's create our table with our first entry 
lookupTable = table(Din24, Din16, {'NothingPressed'});
lookupTable.Properties.VariableNames = {'codes24Bit', 'codes16Bit', 'ButtonName'};

fprintf('\nEntry added! Now we will start adding your custom button names. \nYou can also create names for multiple simultaneous button presses\n');

%Start a data entry loop
while 1
    entry = input('\nPlease enter the name of your custom button: ', 's');
    fprintf('\nHold down the desired button(s) and hit spacebar');
    
    waitForConfirm('space');
    Datapixx('RegWrRd');
    
    Din24 = Datapixx('GetDinValues');
    Din24Binary = dec2bin(Din24);
    Din16 = bin2dec(Din24Binary(9:24));
    
    %Add new entry
    lookupTable = [lookupTable; {Din24, Din16, entry}];
    fprintf('\nEntry logged as: %s\n', entry);    
    
    cont = input('\nWould you like to add another entry? y/n', 's');
    if strcmp(cont, 'n')
        break 
    end
end

%Print results and save them to a .csv
fprintf('\n\nsDemo finished! Table summary:');
lookupTable(:,:)
writetable(lookupTable, filename);
fprintf('\nTable saved as %s', filename);


%Launch button testing (optional)
test = input('\n\nLaunch test? y/n', 's');
if strcmp(test, 'y')
    runButtonTest(filename);
end

%Disconnect from DATAPixx
Datapixx('Close');

end

function waitForConfirm(keyname)
%Just a little helper function to check for a press of a specific key.
%Ues ListenChar to suppress output to the command line while waiting for input.

KbReleaseWait;
ListenChar(2)

while 1
    [~, ~, keyCode] = KbCheck();
    if strcmp(KbName(keyCode), keyname)
        ListenChar(0);
        break
    end
end

end

function runButtonTest(filename)
%Our button tester!

%Let's load our table
lookupTable = readtable(filename);

%Some instructions
fprintf('\nFor this test, we will use the Digital Input Log, which registers changes in button states (16 bits).');
fprintf('\nWe sample the log every 1/4 second and print any new events, and the time they occurred.');
fprintf('\nPress "Escape" to end the test.');

%Let's start out DinLog and keep track of the start time
Datapixx('SetDinLog');
Datapixx('StartDinLog');
Datapixx('RegWrRd');
startTime = Datapixx('GetTime');

%We are going to log continuously and check for new updates every 0.25
%seconds. LastCheckFrame keeps track of where we are in the log.
lastCheckFrame = 0;

while 1
    %Read most recent status of the device
    Datapixx('RegWrRd');
    status = Datapixx('getDInStatus');
    
    %Get current log frame and compare it to our last check frame. Any
    %discrepancy indicates new events have been logged!
    currentFrame = status.currentWriteFrame;
    newEntries = currentFrame - lastCheckFrame;
    
    if newEntries>0
        %Let's read our new entries
        [logData, logTimetags, ~] = Datapixx('ReadDinLog', newEntries);
        for k = 1:newEntries
            
            if logData(k)==lookupTable.codes16Bit(1)
                %One common event is a button release (e.g., a new instance of
                %"NothingPressed.")
                buttonName = 'Button Release';
            else
                %If we have an even that is NOT a release, assume it is
                %unregistered.
                buttonName=['Unregistered button or button combination, (' num2str(logData(k)) ')'];
                
                for m=2:height(lookupTable)
                    %Check our lookup table and correct the buttonName if
                    %we have a 16 bit code for it.
                    if logData(k)==lookupTable.codes16Bit(m)
                        buttonName = lookupTable.ButtonName{m};
                    end
                end
            end
            %Let's record the event timetag and get the time of the press,
            %relative to when the test started. Print this info to the
            %screen.
            pressTime = logTimetags(k) - startTime;
            fprintf('\nTime %.2f: %s', pressTime, buttonName);
        end
        %Once we've read our entire log, update lastCheckFrame to the
        %current read frame.
        lastCheckFrame = currentFrame;
    end
    
    %Check to see if user wants to end test
    [~, ~, keyCode] = KbCheck();
    if strcmp(KbName(keyCode), 'ESCAPE')
        break
    end
    
    %Add a small delay before the next check
    WaitSecs(0.25);
end

%Stop logging and pass this command to the device
Datapixx('StopDinLog');
Datapixx('RegWr');

end



