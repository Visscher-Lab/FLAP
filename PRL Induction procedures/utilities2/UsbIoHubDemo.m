function UsbIoHubDemo()
%Function to demonstrate how to use the gamepad device and serial port interface.
% The demo will print up to 10 detection events on the connected RESPONSEPixx.
% The IO Hub enumerates as two devices: 1. Gamepad Controller, 2. Serial interface
% The gamepad interface is polled for keypress events.
% Whenever a keypress is detected, the serial interface is used to get the event time.
% The serial interface can also be used to get the current time.
% This is useful to set the referece time of an experiment.
% Another use of the serial interface is to set the button LED intensity ranging from 0 to 100. 

% Presently, whenever a button is pressed, the function prints the color of
% the button as well as the timestamp. The button is also illuminated at
% 50% intensity.

% Adjust id to correspond to the gamepad assigned by OS. If only 1 gamepad connected, then id = 1.
% If you do not have the VRJoystick toolbox, which comes as a Simulink module in Matlab 2015+,
% you can download the freely available Hebi Joystick library from: https://github.com/HebiRobotics/MatlabInput

id = 1;

% Adjust communication port as detected by OS
serPort = 'COM4';

s = serial(serPort, 'StopBits', 1, 'TimeOut', 1, 'Terminator', 'CR');
joy = HebiJoystick(id);
fopen(s);

[axes, buttons0, povs] = read(joy);
captureEnd = 0;
endvar = 0;
buttonNames = {'Blue', 'Yellow', 'White', 'Green', 'Red'};

fprintf(s,'GetVersion');
IOHubVersion = fscanf(s);

fprintf(s,'GetCurrentTime');
time0 = fscanf(s);

sprintf('USB IO Hub test')
sprintf('Current Time %s', time0)
sprintf('Current Version %s', IOHubVersion)

fprintf(s,'SetLedAllOn');
pause(2)
fprintf(s,'SetLedAllOff');

while (endvar == 0)
    pause(0.001);
    [axes, buttons, povs] = read(joy);
    buttonChange = xor(buttons, buttons0);
    if any(buttonChange) > 0
        if buttons(find(buttonChange==1)) == 1
            sprintf('%s pushed', buttonNames{find(buttonChange==1)})
            fprintf(s,'GetEventTime');
            time1 = fscanf(s);
            sprintf('Pressed Time: %s', time1)
        else
            sprintf('%s released', buttonNames{find(buttonChange==1)})
            fprintf(s,'GetReleaseTime');
            time1 = fscanf(s);
            sprintf('Released Time: %s', time1)
        end
        
        if buttonChange(3) == 1
            if (captureEnd == 0)
                captureEnd = 1;
            else
                endvar = 1;
            end            
        end
        
    end
    buttons0 = buttons;
end

sprintf('Demo end')
fclose(s);
    