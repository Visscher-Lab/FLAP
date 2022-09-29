function PPxDraw1440HzDots
%This function draws a circle of 12 dots refreshing at 1440Hz. 

% First, we construct a single 1920 x 1080 RGB image, which is passed to
% the PROPixx. The sequencer breaks the image down and shows the quadrants
% and colour channels as 12 individual frames. These frames are 960 x 540
% resolution, shown full screen:
%_______________________________
%|             |                |           
%|     Q1      |       Q2       | 
%|             |                | 
%|_____________|________________|   
%|             |                |         
%|     Q3      |       Q4       |          
%|             |                |          
%|_____________|________________|          


%Quadrants are shown FULL SCREEN, GREYSCALE in the order: 
% Quadrant 1 red channel
% Quadrant 2 red channel
% Quadrant 3 red channel
% Quadrant 4 red channel
% Quadrant 1 green channel
% Quadrant 2 green channel
% Quadrant 3 green channel
% Quadrant 4 green channel
% Quadrant 1 blue channel
% Quadrant 2 blue channel
% Quadrant 3 blue channel
% Quadrant 4 blue channel

%In this demo we draw dots as if they were full screen. The helper function
%'convertToQuadrant' reassigns the positon of the dot (based on full
%display) to the correct quadrant.

% 2020 Mar 18       lef     written
% 2020 Mar 26       lef     revised

%Check connection and open Datapixx if it's not open yet
isConnected = Datapixx('isReady');
if ~isConnected
    Datapixx('Open');
end

Datapixx('SetPropixxDlpSequenceProgram', 5);        %Set Propixx to 1440Hz refresh (also known as Quad12x)
Datapixx('RegWrRd');                                %Push command to device register

%Open a display on the Propixx
AssertOpenGL;
KbName('UnifyKeyNames')
Screen('Preference', 'SkipSyncTests', 1);
screenID = 2;                                        %Change this value to change display
[windowPtr,rect] = Screen('OpenWindow', screenID, 0);

%Set up some stimulus characteristics
dotRadius = 15;
targetRadius = 200; 
center = [rect(3)/2, rect(4)/2];

%Let's define the 12 locations around a circle where we want to draw our
%stimuli
position = [-180:30:180];
locations = nan(12,2);
for k=1:12
    angle = position(k);
    locations(k, 1) = center(1) + targetRadius * cos(-angle*pi/180);
    locations(k, 2) = center(2) + targetRadius * sin(-angle*pi/180);
end
            
%Start displaying dots
while 1 
    
    %DRAW RED
    %Q1 red
    quadrant = 1;
    colour = [255,0,0];
    position = locations(1,:);
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    %Q2 red
    quadrant = 2;
    colour = [255,0,0];
    position = locations(2,:);
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    %Q3 red
    quadrant = 3;
    colour = [255,0,0];
    position = locations(3,:);
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    %Q4 red
    quadrant = 4;
    colour = [255,0,0];
    position = locations(4,:);
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    
    %DRAW GREEN
    %Q1 green
    quadrant = 1;
    colour = [0,255,0];
    position = locations(5,:);
    [x,y] = convertToQuadrant(position, rect, quadrant);  
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    %Q2 green
    quadrant = 2;
    colour = [0,255,0];
    position = locations(6,:);
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    %Q3 green
    quadrant = 3;
    colour = [0,255,0];
    position = locations(7,:);
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    %Q4 green
    quadrant = 4;
    colour = [0,255,0];
    position = locations(8,:);
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    
    %DRAW BLUE    
    %Q1 blue
    quadrant = 1;
    colour = [0,0,255];
    position = locations(9,:);
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    %Q2 blue
    quadrant = 2;
    colour = [0,0,255];
    position = locations(10,:);
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    %Q3 blue
    quadrant = 3;
    colour = [0,0,255];
    position = locations(11,:);
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    %Q4 blue
    quadrant = 4;
    colour = [0,0,255];
    position = locations(12,:);
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);

    
    %Now that we have drawn content to all 12 frames, it is time to flip.
    %The graphics card sends this as a single 1920 x 1080 image at 120 Hz,
    %which the sequencer breaks down into the 12 frames, presented in the
    %order they were drawn.
    Screen('Flip',windowPtr);

    
    %Keypress to exit
    [keyIsDown, ~, ~, ~] = KbCheck;
    if keyIsDown
        break
    end 
end
        
Screen('Closeall');
Datapixx('SetPropixxDlpSequenceProgram', 0);         %Revert to standard 120Hz refresh rate
Datapixx('RegWrRd');
Datapixx('Close');

end

function [x,y] = convertToQuadrant(position, displaySize, quad)
%This scales an x, y position into a specific quadrant of the screen    
scale = 0.5;

switch quad
    case 1; xOffset = 0; yOffset = 0;
    case 2; xOffset = displaySize(3)/2; yOffset = 0; 
    case 3; xOffset = 0; yOffset = displaySize(4)/2;
    case 4; xOffset = displaySize(3)/2; yOffset = displaySize(4)/2;
end
    
x = (position(1)*scale)+xOffset;
y = (position(2)*scale)+yOffset;

end

    
    

