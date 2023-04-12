function calib_appected = TPxValidateCalibrationMM(targets, isTPX, screenHandle, baseName,initRequired)
    if nargin < 5
        initRequired = 1;
    end
    
    if initRequired
        if isTPX
            Datapixx('Open');
            Datapixx('SetTPxAwake');
            Datapixx('SetLedIntensity', 8);
            Datapixx('SetExpectedIrisSizeInPixels', 140)
            Datapixx('HideOverlay');
            Datapixx('RegWrRd');
            image = Datapixx('GetEyeImage');
        else
            Datapixx('Uninitialize');
            Datapixx('Initialize', 0);
            image = Datapixx('GetEyeImageTPxMini');
        end
        KbName('UnifyKeyNames');
        [windowPtr, windowRect]=PsychImaging('OpenWindow', 1, 0);
    else
        windowPtr = screenHandle;
    end
    nmb_pts = size(targets);
    nmb_pts = nmb_pts(2);
    if(isTPX)
        toRead = 800;
        results = zeros(toRead, 4, nmb_pts);
    else
        toRead = 50;
        results = zeros(toRead, 4, nmb_pts);
    end
    skip_validation = 0;
    text_to_draw = 'Press any key to start validation.\nPress "S" to skip it.' ;
    DrawFormattedText(windowPtr, text_to_draw, 'center', 700, 255);
    Screen('Flip', windowPtr);
    pause(2)
    [secs, keyCode, deltaSecs] = KbWait;
    if (keyCode(KbName('s')))
        skip_validation = 1;
        calib_appected = 1;
    end

    if(~skip_validation)
        Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

        HideCursor();

        t2 = 0;
        t3 = 0;
        i = 1;
        update_dot = 0;
        recording = 0;

        big_circle = 60;
        small_circle = 26;
        circle_colour = 230;

        target_temp = []
        while (1)
            if isTPX
                Datapixx('RegWrRd');
                t = Datapixx('GetTime');
            else
                t = GetSecs;
            end
            if ((t - t2) > 2.05) 
                update_dot = 1;
                t2 = t;
            end
            if (update_dot) 
                Screen('DrawDots', windowPtr, [targets(:,i) targets(:,i)], [big_circle;small_circle]', [230 230 230; circle_colour 0 0]', [], 1);
                Screen('DrawLine', windowPtr, [0,190,0], targets(1,i) + small_circle/2, targets(2,i), targets(1,i) - small_circle/2, targets(2,i),2);
                Screen('DrawLine', windowPtr, [0,190,0], targets(1,i), targets(2,i) + small_circle/2, targets(1,i), targets(2,i) - small_circle/2,2);
                Screen('Flip', windowPtr);
            end                
            if (t - t3 >= 0.05)
                if(update_dot)
                    if ~(big_circle <= 3 || small_circle <= 1)
                        big_circle = big_circle - 3;
                        small_circle = small_circle - 1;
                    end
                    if (mod(big_circle,2))
                        circle_colour = 230;
                    else
                        circle_colour = 0;
                    end
                end
                t3 = t;
            end

            if (update_dot && (t - t2) > 0.85)
                if isTPX
                    Datapixx('SetupTPxSchedule');
                    Datapixx('RegWrRd');
                    Datapixx('StartTPxSchedule');
                    Datapixx('RegWrRd');
                end
                update_dot = 0;
                recording = 1;
            end
            
            if(recording)
                Screen('DrawDots', windowPtr, [targets(:,i) targets(:,i)], [14;9]', [230 230 230; 230 0 0]', [], 1);
                Screen('DrawLine', windowPtr, [0,190,0], targets(1,i) + small_circle/2, targets(2,i), targets(1,i) - small_circle/2, targets(2,i),2);
                Screen('DrawLine', windowPtr, [0,190,0], targets(1,i), targets(2,i) + small_circle/2, targets(1,i), targets(2,i) - small_circle/2,2);
                Screen('Flip', windowPtr);
                if ~isTPX
                    target_res_size = size(target_temp)
                    if (target_res_size(1)<toRead)
                        [x_r_pos y_r_pos x_l_pos y_l_pos xRawRight yRawRight xRawLeft yRawLeft] = Datapixx('GetEyePosition');
                        gaze_pos = [x_l_pos y_l_pos x_r_pos y_r_pos];
                        target_temp = [target_temp;gaze_pos];%[traget_result;gaze_pos]
                    end
                end
            end
            
            if (recording && (t - t2) > 2)
                if(isTPX)
                    Datapixx('StopTPxSchedule');
                    Datapixx('RegWrRd');
                    [bufferData, underflow, overflow] = Datapixx('ReadTPxData', toRead);

                    rightEyeCartesian = [bufferData(:,5) bufferData(:,6)];
                    leftEyeCartesian = [bufferData(:,2) bufferData(:,3)];
                else
                    % Acquire any missing data
                    while (size(target_temp) < toRead)
                        [x_r_pos y_r_pos x_l_pos y_l_pos xRawRight yRawRight xRawLeft yRawLeft] = Datapixx('GetEyePosition', 1);
                        gaze_pos = [x_l_pos y_l_pos x_r_pos y_r_pos];
                        target_temp = [target_temp;gaze_pos];%[traget_result;gaze_pos]
                    end
                    rightEyeCartesian = [target_temp(:,3) target_temp(:,4)];
                    leftEyeCartesian  = [target_temp(:,1) target_temp(:,2)];
                    target_temp = [];
                end
                rightEyeTopLeft = Datapixx('ConvertCoordSysToCustom', rightEyeCartesian);
                leftEyeTopLeft = Datapixx('ConvertCoordSysToCustom', leftEyeCartesian);
                target_result = [leftEyeTopLeft(:,1) leftEyeTopLeft(:,2) rightEyeTopLeft(:,1) rightEyeTopLeft(:,2)];
                results(:,:,i) = target_result;
                recording = 0;
                i = 1 + i;
                big_circle = 60;
                small_circle = 26;
                circle_colour = 230;

            end

            if (i > nmb_pts) 
                WaitSecs(2);
                ShowCursor();
                break;
            end
        end
        file_recorded = 0;
        i = 1;
        avg_gaze_pos_l_x = zeros(nmb_pts,1);
        avg_gaze_pos_l_y = zeros(nmb_pts,1);
        avg_gaze_pos_r_x = zeros(nmb_pts,1);
        avg_gaze_pos_r_y = zeros(nmb_pts,1);
        avg_error_l_x = zeros(nmb_pts,1);
        avg_error_l_y = zeros(nmb_pts,1);
        avg_error_r_x = zeros(nmb_pts,1);
        avg_error_r_y = zeros(nmb_pts,1);
        avg_error_l = zeros(nmb_pts,1);
        avg_error_r = zeros(nmb_pts,1);
        std_error_l = zeros(nmb_pts,1);
        std_error_r = zeros(nmb_pts,1);
        for i=1:nmb_pts
            avg_gaze_pos_l_x(i) = nanmean(results(:,1,i));
            avg_gaze_pos_l_y(i) = nanmean(results(:,2,i));
            avg_gaze_pos_r_x(i) = nanmean(results(:,3,i));
            avg_gaze_pos_r_y(i) = nanmean(results(:,4,i));
            avg_error_l_x(i) = targets(1,i) - avg_gaze_pos_l_x(i);
            avg_error_l_y(i) = targets(2,i) - avg_gaze_pos_l_y(i);
            avg_error_r_x(i) = targets(1,i) - avg_gaze_pos_r_x(i);
            avg_error_r_y(i) = targets(2,i) - avg_gaze_pos_r_y(i);
            avg_error_l(i) = sqrt(avg_error_l_x(i)^2 + avg_error_l_y(i)^2);
            avg_error_r(i) = sqrt(avg_error_r_x(i)^2 + avg_error_r_y(i)^2);
            std_error_l(i) = std(sqrt(results(:,1,i).^2 + results(:,2,i).^2));
            std_error_r(i) = std(sqrt(results(:,3,i).^2 + results(:,4,i).^2));
        end
        while (1)
            DrawFormattedText(windowPtr, '\n Validation results 1 of 3. \n Showing left and right eyes average error in blue and red respectively. If one dot seems off, calibration might be bad.\n Press any key to continue.', 'center', 100, 255);
            Screen('DrawDots', windowPtr, [targets(1,:)' targets(2,:)']', [30]', [255 255 255]', [], 1);
            Screen('DrawDots', windowPtr, [avg_gaze_pos_l_x(:) avg_gaze_pos_l_y(:)]', [20]', [0 150 255]', [], 1);
            Screen('DrawDots', windowPtr, [avg_gaze_pos_r_x(:) avg_gaze_pos_r_y(:)]', [20]', [255 0 30]', [], 1);
            for i = 1:nmb_pts
                Screen('DrawText', windowPtr, sprintf('%.1f', avg_error_l(i)), targets(1,i) + 15, targets(2,i) + 20, [0 150 255]);
                Screen('DrawText', windowPtr, sprintf('%.1f', avg_error_r(i)), targets(1,i) + 15, targets(2,i) - 20, [255 0 30]);
            end
            
            Screen('DrawText', windowPtr, sprintf('Right eye mean error = %.2f', nanmean(avg_error_r)), 800, 1000, [255 0 30]);
            Screen('DrawText', windowPtr, sprintf('Left eye mean error  = %.2f', nanmean(avg_error_l)), 800, 1040, [0 150 255]);
            Screen('Flip', windowPtr);
            WaitSecs(0.3);
            
            if (~file_recorded)
                imageArray = Screen('GetImage', windowPtr);
                titlename=[baseName ' average_error.jpg'];
                imwrite(imageArray,  titlename)
            end
            
            [secs, keyCode, deltaSecs] = KbWait;
            if (keyCode(KbName('Y'))) % good calib
                calib_appected = 1;
                break;
            elseif keyCode(KbName('N')) % bad calib
                calib_appected = 0;
                break;
            end
            
            DrawFormattedText(windowPtr, '\n Calibration results 2 of 3. \n Showing calibration dots and left eye gaze position recorded during validation. \n This gives an idea of the dispersion, noise and error. \n Press any key to continue. Y to acccept, N to restart.', 'center', 100, 255);
            Screen('DrawDots', windowPtr, [targets(1,:)' targets(2,:)']', [30]', [255 255 255]', [], 1);
            for i = 1:nmb_pts
                Screen('DrawDots', windowPtr, [results(:,1,i) results(:,2,i)]', [3]', [0 150 255]', [], 1);
                Screen('FrameOval',windowPtr, [0 255 0],[(avg_gaze_pos_l_x(i) - 2*std_error_l(i)) (avg_gaze_pos_l_y(i) - 2*std_error_l(i)) (avg_gaze_pos_l_x(i) + 2*std_error_l(i)) (avg_gaze_pos_l_y(i) + 2*std_error_l(i))], 2);
            end
            Screen('Flip', windowPtr);
            WaitSecs(0.3);
            if(~file_recorded)
                imageArray = Screen('GetImage', windowPtr);
                titlename=[baseName ' reported_gaze_left.jpg'];
                imwrite(imageArray,  titlename)
            end
            [secs, keyCode, deltaSecs] = KbWait;
            if keyCode(KbName('Y'))
                calib_appected = 1;
                break;
            elseif keyCode(KbName('N'))
                calib_appected = 0;
                break;
            end
            
            %3rd result page to display; Left eye interpolation
            DrawFormattedText(windowPtr, '\n Calibration results 3 of 3. \n Showing calibration dots and right eye gaze position recorded during validation. \n This gives an idea of the dispersion, noise and error. \n Press any key to continue. Y to accept, N to restart.', 'center', 100, 255);
            Screen('DrawDots', windowPtr, [targets(1,:)' targets(2,:)']', [30]', [255 255 255]', [], 1);
            for i = 1:nmb_pts
                Screen('DrawDots', windowPtr, [results(:,3,i) results(:,4,i)]', [3]', [255 0 30]', [], 1);
                Screen('FrameOval',windowPtr, [0 255 0],[(avg_gaze_pos_r_x(i) - 2*std_error_r(i)) (avg_gaze_pos_r_y(i) - 2*std_error_r(i)) (avg_gaze_pos_r_x(i) + 2*std_error_r(i)) (avg_gaze_pos_r_y(i) + 2*std_error_r(i))], 2);
            end
            Screen('Flip', windowPtr);
            WaitSecs(0.3);
            if(~file_recorded)
                imageArray = Screen('GetImage', windowPtr);
                titlename=[baseName ' reported_gaze_right.jpg'];
                imwrite(imageArray,  titlename)
                file_recorded = 1;
            end
            [secs, keyCode, deltaSecs] = KbWait;
            if keyCode(KbName('Y'))
                calib_appected = 1;
                break;
            elseif keyCode(KbName('N'))
                calib_appected = 0;
                break;
            end
        end
        if initRequired
            Screen('CloseAll');
        end
    end
    
    if exist('avg_gaze_pos_l_x')
    validation_left_x=avg_gaze_pos_l_x;
    validation_left_y=avg_gaze_pos_l_y;
    validation_right_x=avg_gaze_pos_r_x;
    validation_right_y=avg_gaze_pos_r_y;
    validation_results=results;
    end
    save([baseName 'validationoutcome']) %at the end of each block save the data
end