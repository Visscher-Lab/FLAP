function calibrationSuccess = TPxSimpleCalibration()
    calibrationSuccess = 0;
    screenNumber = 2;
    ledIntensity = 8;
    approximateIrisSize = 140;
    
    Datapixx('Open');
    Datapixx('HideOverlay');
    Datapixx('ClearCalibration');
    Datapixx('RegWrRd');
    Datapixx('SetTPxAwake');
    Datapixx('RegWrRd');
    Datapixx('SetLedIntensity', ledIntensity);
    Datapixx('SetExpectedIrisSizeInPixels', approximateIrisSize)
    Datapixx('RegWrRd');

    [windowPtr, windowRect]=PsychImaging('OpenWindow', screenNumber, 0);
    cam_rect = [windowRect(3)/2-1280/2 0 windowRect(3)/2+1280/2 1024];

    KbName('UnifyKeyNames');

    t = Datapixx('GetTime');
    t2 = Datapixx('GetTime');

    Screen('TextSize', windowPtr, 24);
    while (1)
        if ((t2 - t) > 1/60) % Just refresh at 60Hz.
            Datapixx('RegWrRd');
            image = Datapixx('GetEyeImage');

            textureIndex=Screen('MakeTexture', windowPtr, image');
            Screen('DrawTexture', windowPtr, textureIndex, [], cam_rect);
            text_to_draw = ['Instructions:\n\n 1- Focus the eyes.'...
                            '\n\n 2- Press Enter when ready to calibrate. '...
                            ' Escape to exit'];
            DrawFormattedText(windowPtr, strcat('',text_to_draw), 'center', 700, 255); 
            Screen('Flip', windowPtr);
            t = t2;
            Screen('Close',textureIndex);
        else
            Datapixx('RegWrRd');
            t2 = Datapixx('GetTime');
        end

        [pressed, ~, keycode] = KbCheck;
        if pressed
            if keycode(KbName('escape'))
                Screen('CloseAll')
                Datapixx('Uninitialize');
                Datapixx('Close');
                return;
            else
                break;
            end
        end
    end

    cx = 1920/2; % Point center in x
    cy = 1080/2; % Point center in y
    dx = 600; % How big of a range to cover in X
    dy = 350; % How big of a range to cover in Y
    
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
        
    xyCartesian = Datapixx('ConvertCoordSysToCartesian', xy);
    xyCartesian = xyCartesian';
    xy = xy';
    nmb_pts = size(xy);
    nmb_pts = nmb_pts(2);

    Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    i = 0;
    raw_vector = zeros(13,4);
    showing_dot = 0;
    t = 0;
    t2 = 0;
    while (1)
        if ((t2 - t) > 2) % points presented every 2 sec
            Sx = xyCartesian(1,mod(i,nmb_pts)+1);
            Sy = xyCartesian(2,mod(i,nmb_pts)+1);
            Screen('DrawDots', windowPtr, [xy(:,mod(i,nmb_pts)+1) xy(:,mod(i,nmb_pts)+1)], [30;8]', [0 200 0; 200 0 0]', [], 1);
            Screen('Flip', windowPtr);
            t = t2;
            showing_dot = 1;
        else
            Datapixx('RegWrRd');
            t2 = Datapixx('GetTime');
        end
        if (showing_dot && (t2 - t) > 0.95)
            i = i + 1; % Next point
            fprintf('geyEye Raw')
            [xRawRight, yRawRight, xRawLeft, yRawLeft] = Datapixx('GetEyeDuringCalibrationRaw', Sx, Sy); % Raw Values from TPx to verify
            fprintf('geteye rawdon')
            raw_vector(i,:) = [xRawRight yRawRight xRawLeft yRawLeft]
            showing_dot = 0;
        end
        if (i == nmb_pts)
            WaitSecs(2);
            break;
        end
    end
    
    Datapixx('FinishCalibration');
    
    while (1)
        DrawFormattedText(windowPtr, 'Following your gaze now!', 'center', 700, 255);
        Screen('DrawDots', windowPtr, [xy(1,:)' xy(2,:)']', [20]', [255 255 255]', [], 1);
        Datapixx('RegWrRd');
        [xScreenRightCartesian yScreenRightCartesian xScreenLeftCartesian yScreenLeftCartesian xRawRight yRawRight xRawLeft yRawLeft] = Datapixx('GetEyePosition');
        
        rightEyeCartesian = [xScreenRightCartesian yScreenRightCartesian];
        leftEyeCartesian = [xScreenLeftCartesian yScreenLeftCartesian];
        rightEyeTopLeft = Datapixx('ConvertCoordSysToCustom', rightEyeCartesian);
        leftEyeTopLeft = Datapixx('ConvertCoordSysToCustom', leftEyeCartesian);
        xScreenRight = rightEyeTopLeft(1);
        yScreenRight = rightEyeTopLeft(2);
        xScreenLeft = leftEyeTopLeft(1);
        yScreenLeft = leftEyeTopLeft(2);
        
        Screen('DrawDots', windowPtr, [xScreenRight; yScreenRight], [15]', [255 0 0]', [], 1);
        Screen('DrawDots', windowPtr, [xScreenLeft; yScreenLeft], [15]', [0 0 255]', [], 1);
        Screen('Flip', windowPtr);
        
        [pressed dum keycode] = KbCheck;
        if pressed
            if keycode(KbName('escape'))
                Datapixx('Uninitialize');
                Screen('CloseAll');
                Datapixx('Close');
                break;
            else
                calibrationSuccess = 1;
                break;
            end
        end
    end
end

    
  
            

        
        
