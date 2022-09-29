function calibrationSuccess = TPxMiniSimpleCalibration()

    calibrationSuccess = 0;
    screenNumber = 1;
    Datapixx('CloseTPxMini');
    Datapixx('OpenTPxMini');
    
    [windowPtr, windowRect]=PsychImaging('OpenWindow', screenNumber, 0);
    cam_rect = [windowRect(3)/2-1280/2 0 windowRect(3)/2+1280/2 1024/2];
    
    KbName('UnifyKeyNames');
    t = GetSecs;
    t2 = GetSecs;
    
    Screen('TextSize', windowPtr, 24);
    
    while (1)
        if ((t2 - t) > 1/60) % Just refresh at 60Hz.
            image = Datapixx('GetEyeImageTPxMini');
            
            textureIndex=Screen('MakeTexture', windowPtr, image');
            Screen('DrawTexture', windowPtr, textureIndex, [], cam_rect);
            
            text_to_draw = [' Press Enter when ready to calibrate '...
                            '(M for manual). Escape to exit'];
            DrawFormattedText(windowPtr, strcat('',text_to_draw), 'center', 700, 255); 
            Screen('Flip', windowPtr);
            t = t2;
            Screen('Close',textureIndex);
        else
            t2  = GetSecs;
        end
        [pressed, ~, keycode] = KbCheck;
        if pressed
            if keycode(KbName('escape'))
                Screen('CloseAll')
                Datapixx('CloseTPxMini');
                Datapixx('Close');
                return;
            else
                break;
            end
        end
    end
    
    [xy, nmb_pts] = Datapixx('InitializeCalibrationTPxMini');
    xy(2,:) = 1080 - xy(2,:);
    
    i = 0;
    Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    t = 0;
    t2 = 0;
    showing_dot = 0;
    
    while(1)
        if ((t2 - t) > 2) % points presented every 2 sec
            Sx = xy(1,mod(i,nmb_pts)+1);
            Sy = xy(2,mod(i,nmb_pts)+1);
            Screen('DrawDots', windowPtr, [xy(:,mod(i,nmb_pts)+1) xy(:,mod(i,nmb_pts)+1)], [20;10]', [255 255 255; 200 0 0]', [], 1);
            Screen('Flip', windowPtr);
            showing_dot = 1;
            t = t2;
        else
            t2 = GetSecs;
        end

        if (showing_dot && (t2 - t) > 0.95)
            i = i + 1; % Next point
            Datapixx('ClearError');
            Datapixx('CalibrateTargetTPxMini', i-1);
            showing_dot = 0;
        end
        
        if (i == nmb_pts)
            WaitSecs(2);
            break;
        end
    end
            
	Datapixx('FinishCalibrationTPxMini');
    Datapixx('SetupTPxMiniRecording', (120*60*10));
    Datapixx('RecordTPxMiniData');

    while(1)
        DrawFormattedText(windowPtr, 'Following your gaze now!', 'center', 700, 255);
        Screen('DrawDots', windowPtr, [xy(1,:)' xy(2,:)']', [20]', [255 255 255]', [], 1);
        
        %[xScreenRightCartesian yScreenRightCartesian xScreenLeftCartesian yScreenLeftCartesian xRawRight yRawRight xRawLeft yRawLeft tt] = Datapixx('GetEyePosition', 1);
        if ((t2 - t) > 1/120) % points presented every 8.333 msec

            eyeData = Datapixx('GetTPxMiniLastEyePosition');
            xScreenLeftCartesian = eyeData(2);
            yScreenLeftCartesian = eyeData(3);
            leftPupilDiameter = eyeData(4);
            xScreenRightCartesian = eyeData(5);
            yScreenRightCartesian = eyeData(6);
            rightPupilDiameter = eyeData(7);

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
            t = t2;
        else
            t2 = GetSecs;
        end

        [pressed dum keycode] = KbCheck;
        if pressed
            if keycode(KbName('escape'))
                Datapixx('StopTPxMiniRecording');
                Datapixx('GetTPxMiniRecordedData');
                Datapixx('CloseTPxMini');
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

    

