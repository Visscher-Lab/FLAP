function PPxDraw1440HzDots2
%This function draws a central dot refreshing at 1440Hz. It demonstrates how to
%use blending to ensure textures drawn to different colour channels are
%integrated properly in the final 1440Hz display

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

%In this demo we draw dots as normal. The helper function 'convertToQuadrant'
%reassigns the positon of the dot (based on full display) to the correct
%quadrant.

%The dot is always in the center of the display. To prevent colours from
%overwriting each other, we use blending to add the colour maps together as
%they are drawn. Drawing three dots (1=R, 2=G and 3=B) in a quadrant and
%blending is functionally equivalent to drawing a single dot with colour =
%[R, G, B] in each quadrant. For example, if we draw a [255, 255, 255] dot 
%in the top left quadrant, this would produce white dots on frame 1, 5 and
%10. Here, we draw the dots separately in each colour channel to make the
%process a bit more transparent and demonstrate how to use blending.

% 2020 Mar 27       lef     written

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
center = [rect(3)/2, rect(4)/2];
   
%Start drawing dots 
while 1 
    
    %DRAW RED
    Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, [1 0 0 0]);
    colour = [255,0,0];
    for k=1:4
        quadrant = k;
        [x,y] = convertToQuadrant(center, rect, quadrant); 
        Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    end
    

    %DRAW GREEN
    Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, [0 1 0 0]);
    colour = [0,255,0];
    for k=1:4
        quadrant = k;
        [x,y] = convertToQuadrant(center, rect, quadrant); 
        Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    end
    
    
    %DRAW BLUE
    Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, [0 0 1 0]);
    colour = [0,0,255];
    for k=1:4
        quadrant = k;
        [x,y] = convertToQuadrant(center, rect, quadrant); 
        Screen('FillOval', windowPtr, colour, [x-dotRadius, y-dotRadius, x+dotRadius, y+dotRadius]);
    end

    
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

    
    

