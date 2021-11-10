function TPxGazeFollow()
% TPxGazeFollow()
%
% This shows your current gaze position.
% Press L to load a calibration.
%
% Further Comments will be added on the next release.
%
% History:
%
% Dec 22, 2017  gm     Written

clear all;
close all;
dummy = 0;
screen = 2;
KbName('UnifyKeyNames');
[windowPtr, windowRect]=PsychImaging('OpenWindow', screen, 0);
cx = 1920/2;
cy = 1080/2;
dx = 400;
dy = 250;
xy = [  cx cy;...
        cx cy+dy;...
        cx+dx cy;...
        cx cy-dy;...
        cx-dx cy;...
        cx+dx cy+dy;...
        cx-dx cy+dy;...
        cx+dx cy-dy;...
        cx-dx cy-dy;...
        cx+dx/2 cy+dy/2;...
        cx-dx/2 cy+dy/2;...
        cx-dx/2 cy-dy/2;...
        cx+dx/2 cy-dy/2;];
    
xy = xy';
Datapixx('Open');
Datapixx('HideOverlay');
Datapixx('SetTPxAwake');
Datapixx('RegWrRd');
fileID = fopen('gaze_measure.csv', 'a');
fileID2 = fopen('gaze_raw_compare.csv', 'a');
fprintf(fileID, 'mouse X,mouse Y,right eye x,right eye y,left eye x,left eye y,error rigth x,error right y,error left x,error left y\n');
visible = 1;
mfilter = 0;
xAvgRight = [];
yAvgRight = [];
xAvgLeft = [];
yAvgLeft = [];
xErrRight = [];
yErrRight = [];
xErrLeft = [];
yErrLeft = [];
while (1)
    % 1- Get Eye position
    % 2- Put that in array
    % 3- Draw it on screen
    DrawFormattedText(windowPtr, 'Following your gaze now!\n Press L to load calibrations', 'center', 700, 255);
    Screen('DrawDots', windowPtr, [xy(1,:)' xy(2,:)']', [30]', [255 255 255]', [], 1);
    if ~dummy
        Datapixx('RegWrRd');
        [xScreenRight yScreenRight xScreenLeft yScreenLeft xRawRight yRawRight xRawLeft yRawLeft] = Datapixx('GetEyePosition');     
        
        
        array = [xScreenRight yScreenRight];
        array = Datapixx('ConvertCoordSysToCustom', array);
        xScreenRight = array(1);
        yScreenRight = array(2);
        array = [xScreenLeft yScreenLeft];
        array = Datapixx('ConvertCoordSysToCustom', array);
        xScreenLeft = array(1);
        yScreenLeft = array(2);

    else 
       [X,Y] = GetMouse();
    end
    
    if (size(xAvgRight,1) < 10)
        xAvgRight = [xScreenRight;xAvgRight];
        yAvgRight = [yScreenRight;yAvgRight];
        xAvgLeft = [xScreenLeft;xAvgLeft];
        yAvgLeft = [yScreenLeft;yAvgLeft];
    else
        xAvgRight = circshift(xAvgRight,1);
        xAvgRight(1) = xScreenRight;
        yAvgRight = circshift(yAvgRight,1);
        yAvgRight(1) = yScreenRight;
        xAvgLeft = circshift(xAvgLeft,1);
        xAvgLeft(1) = xScreenLeft;
        yAvgLeft = circshift(yAvgLeft,1);
        yAvgLeft(1) = yScreenLeft;
    end
    
    if ~dummy
        if visible
            if mfilter
                Screen('DrawDots', windowPtr, [mean(xAvgRight); mean(yAvgRight)], [15]', [255 0 0]', [], 1);
                Screen('DrawDots', windowPtr, [mean(xAvgLeft); mean(yAvgLeft)], [15]', [0 0 255]', [], 1);
            else
                Screen('DrawDots', windowPtr, [xScreenRight; yScreenRight], [15]', [255 0 0]', [], 1);
                Screen('DrawDots', windowPtr, [xScreenLeft; yScreenLeft], [15]', [0 0 255]', [], 1);
            end
        end
    else
        Screen('DrawDots', windowPtr, [X; Y], [15]', [255 0 255]', [], 1);
        
    end
    
    
    [X, Y, buttons] = GetMouse(windowPtr);
    if buttons(1)
        if reset_error
            xErrRight = [];
            yErrRight = [];
            xErrLeft = [];
            yErrLeft = [];
            reset_error = 0;
        end
        fprintf(fileID, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',...
        X, Y, xScreenRight, yScreenRight, xScreenLeft, yScreenLeft,...
        (X - xScreenRight), (Y - yScreenRight), (X - xScreenLeft), (Y - yScreenLeft));
        fprintf(fileID2, '%f,%f,%f,%f,%f,%f,\n', X, Y, xRawRight, yRawRight, xRawLeft, yRawLeft);
        if (size(xErrRight,1) < 20)
            xErrRight = [X - xScreenRight;xErrRight];
            yErrRight = [Y - yScreenRight;yErrRight];
            xErrLeft = [X - xScreenLeft;xErrLeft];
            yErrLeft = [Y - yScreenLeft;yErrLeft];
        else
            xErrRight = circshift(xErrRight,1);
            xErrRight(1) = X - xScreenRight;
            yErrRight = circshift(yErrRight,1);
            yErrRight(1) = Y - yScreenRight;
            xErrLeft = circshift(xErrLeft,1);
            xErrLeft(1) = X - xScreenLeft;
            yErrLeft = circshift(yErrLeft,1);
            yErrLeft(1) = Y - yScreenLeft;
        end
        Screen('TextSize', windowPtr, 16);
        Screen('Preference', 'TextAlphaBlending', 1);
        Screen('TextBackgroundColor', windowPtr, [250 248 200]);
        DrawFormattedText(windowPtr, sprintf('    %f  |  %f\n    %f  |  %f', mean(xErrRight),mean(yErrRight),mean(xErrLeft),mean(yErrLeft)), 'right', [], 10);
        Screen('Preference', 'TextAlphaBlending', 0);
    elseif buttons(3)
        Screen('TextSize', windowPtr, 16);
        Screen('Preference', 'TextAlphaBlending', 1);
        Screen('DrawText', windowPtr, sprintf('    %d  |  %d', X,Y), X, Y, 10, [250 248 200]);
        Screen('Preference', 'TextAlphaBlending', 0);
    else
        reset_error = 1;
    end
    
    Screen('TextSize', windowPtr, 14);
    Screen('Preference', 'TextAlphaBlending', 1);
    Screen('TextBackgroundColor', windowPtr, [250 248 200]);
    if (size(xErrRight,1) > 10)
        newX = 10;
        newY = 920;
        for i=1:10
            [newX,newY] = DrawFormattedText(windowPtr, sprintf('  %7.2f  |  %7.2f  |  %7.2f  |  %7.2f\n', xErrRight(i), yErrRight(i), xErrLeft(i), yErrLeft(i)), newX, newY, 5);
        end
    end
    Screen('TextBackgroundColor', windowPtr, [0 0 0 0]);
    Screen('Preference', 'TextAlphaBlending', 0);
    Screen('TextSize', windowPtr, 24);
    
    Screen('Flip', windowPtr);         
    [pressed dum keycode] = KbCheck;
    if pressed
        if keycode(KbName('escape'))
            Datapixx('ShowOverlay');
            Datapixx('SetAsleepPictureRequest');
            Datapixx('RegWrRd');
            Screen('CloseAll');
            Datapixx('Close');
%            fclose(fileID);
%            fclose(fileID2);
            break;
        end
        if keycode(KbName('h'))
            visible = 0;
        end
        if keycode(KbName('u'))
            visible = 1;
        end
        if keycode(KbName('f'))
            mfilter = 1;
        end
        if keycode(KbName('d'))
            mfilter = 0;
        end
        if keycode(KbName('l'))
            Datapixx('LoadCalibration');
        end

    end

end

fclose(fileID);
fclose(fileID2);

end
