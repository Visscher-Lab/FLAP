function PPxDraw480HzDots
%This function draws a series of dots around the center of the
%display at 480 Hz. 

% First, we construct a single 1920 x 1080 RGB image, which is passed to
% the PROPixx. The sequencer breaks the image down and shows the quadrants
% as 4 individual 960 x 540 frames, one after the other.
%_______________________________
%|             |                |           
%|     Q1      |       Q2       | 
%|             |                | 
%|_____________|________________|   
%|             |                |         
%|     Q3      |       Q4       |          
%|             |                |          
%|_____________|________________|          


%Quadrants are shown FULL SCREEN, RGB in the order Q1-Q2-Q3-Q4. 

% To create stimuli, we draw our targets as if they were full resolution,
% full screen. The helper script 'convertToQuadrant' reassigns and rescales
% the target positon to the correct quadrant. Remember that each quadrant
% gets blown up to full screen, so your resolution will be halved
% vertically and horizontally.

% Made and tested with:
% -- PROPixx firmware revision 43
% -- DATAPixx3 firmware revision 19 
% -- MATLAB version 9.6.0.1150989 (R2019a) 
% -- Psychtoolbox version 3.0.15 
% -- Datapixx Toolbox version 3.7.5735
% -- Windows 10 version 1903, 64bit

% Sep 27 2019       lef     written
% Mar 26 2020       lef     revised

%Check connection and open Datapixx if it's not open yet
isConnected = Datapixx('isReady');
if ~isConnected
    Datapixx('Open');
end

Datapixx('SetPropixxDlpSequenceProgram', 2);        %Set Propixx to 480Hz refresh (also known as Quad4x)
Datapixx('RegWrRd');                                %Push command to device register

%Open a display on the Propixx
AssertOpenGL;
KbName('UnifyKeyNames')
Screen('Preference', 'SkipSyncTests', 1);
screenID = 2;                                        %Change this value to change display
[windowPtr,rect] = PsychImaging('OpenWindow', screenID, 0);

%Set up some stimulus characteristics
dotRadius = 30;

%Create some positions based on the regular display
center = [rect(3)/2, rect(4)/2];
radius = 200;
positions=[center(1), center(2)-radius;...            %top
           center(1)+radius, center(2);...            %right
           center(1), center(2)+radius;...            %bottom
           center(1)-radius, center(2)];              %left

            
%Start displaying dots
while 1 
    
    %Above center, random colour
    quadrant = 1;
    position = positions(1, :);
    colour = round(rand([1,3])*255);     
    %Convert position to the same position in the quadrant 1 and draw
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
     
    %Right of center, random colour
    quadrant = 2;
    position = positions(2, :);
    colour = round(rand([1,3])*255);     
    %Convert position to the same position in the quadrant 2 and draw
    [x,y] = convertToQuadrant(position, rect, quadrant);
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
     
    %Below center, random colour
    quadrant = 3;
    position = positions(3, :);
    colour = round(rand([1,3])*255);     
    %Convert position to the same position in the quadrant 3 and draw
    [x,y] = convertToQuadrant(position, rect, quadrant); 
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    
    %Left of center, random colour
    quadrant = 4;
    position = positions(4, :);
    colour = round(rand([1,3])*255);     
    %Convert position to the same position in the quadrant 4 and draw
    [x,y] = convertToQuadrant(position, rect, quadrant);  
    Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
      
    %Flip
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

    
    

