                %GetEyeDuringCalibrationRaw acquires eye data from tracker.
                %It also saves that data in memory and is used (once all
                %targets are run) to calculate the formula used to convert 
                %raw eye data to calibrate screen position.
 %-->           %It is mandatory to call this function to gather eye 
                %information for all targets included in the calibration
                [xRawRight, yRawRight, xRawLeft, yRawLeft] = Datapixx('GetEyeDuringCalibrationRaw', Sx, Sy, eyeToVerify);
                raw_vector(i,:) = [xRawRight yRawRight xRawLeft yRawLeft];
                
                
                    %========================== Chinrest ==============================
        %'FinishCalibration' uses the data captured in the preceeding steps and
        %runs a mathematical process to determine the formula that
        %will convert raw eye data to a calibrated gaze position on screen.
%-->    %It is MANDATORY to call FinishCalibration in order to calibrate
        %the tracker for a chinrest calibration

        
        
               %evaluate_bestpoly applies raw eye positions to the polynomial
            %and returns calibrated gaze position on screen.
            %Evaluate all the calibration points
            [x_eval_cartesian,y_eval_cartesian] = evaluate_bestpoly(raw_vector(:,1)', raw_vector(:,2)', coeff_x, coeff_y);
            [x_eval_L_cartesian,y_eval_L_cartesian] = evaluate_bestpoly(raw_vector(:,3)', raw_vector(:,4)', coeff_x_L, coeff_y_L);
            right_eye_eval = [x_eval_cartesian' y_eval_cartesian'];
            left_eye_eval = [x_eval_L_cartesian' y_eval_L_cartesian'];
            %convert back to PsychToolbox coordinate system for display
            xy_eval = Datapixx('ConvertCoordSysToCustom', right_eye_eval);
            xy_eval_L = Datapixx('ConvertCoordSysToCustom', left_eye_eval);