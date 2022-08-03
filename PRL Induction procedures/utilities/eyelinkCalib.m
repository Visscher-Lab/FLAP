        useEyeTracker = 0; % otherwise will throw error if not UAB run
        
        eyeTrackerBaseName =['0' SUBJECT '0' num2str(expDay)];
  
        if exist('dataeyet')==0
            mkdir('dataeyet');
        end;
        
        save_dir=[cd '/dataeyet/'];
        
        % initialize eyelink
        if EyelinkInit()~= 1
            error('Eyelink initialization failed!');
        end
        % continue with the rest of eyelink initialization
        elHandle=EyelinkInitDefaults(w);
        el=elHandle;
        eyeTrackerFileName = [eyeTrackerBaseName '.edf'];
        % Modify calibration and validation target locations %%
        % it's location here is overridded by EyelinkDoTracker which resets it
        % with display PC coordinates
        Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, winWidth-1, winHeight-1);
        Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, winWidth-1, winHeight-1);
        % set calibration type.
        Eyelink('command', 'calibration_type = HV9');
        % Eyelink('command', 'calibration_type = HV5'); % changed to 5 to correct upper left corner of the screen issue
        % you must send this command with value NO for custom calibration
        % you must also reset it to YES for subsequent experiments
        %    Eyelink('command', 'generate_default_targets = NO');
        %% Modify target locations
        % due to issues with calibrating the upper left corner of the screen the following lines have been
        % commmented out to change the the sampling from 10 to 5 as
        % listed in line 323
        Eyelink('command','calibration_samples = 10');
        Eyelink('command','calibration_sequence = 0,1,2,3,4,5,6,7,8,9');
        
        %             modFactor = 0.183;
        %
        %             Eyelink('command','calibration_targets = %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
        %                 round(winWidth/2), round(winHeight/2),  round(winWidth/2), round(winHeight*modFactor),  ...
        %                 round(winWidth/2), round(winHeight - winHeight*modFactor),  round(winWidth*modFactor), ...
        %                 round(winHeight/2),  round(winWidth - winWidth*modFactor), round(winHeight/2), ...
        %                 round(winWidth*modFactor), round(winHeight*modFactor), round(winWidth - winWidth*modFactor), ...
        %                 round(winHeight*modFactor), round(winWidth*modFactor), round(winHeight - winHeight*modFactor),...
        %                 round(winWidth - winWidth*modFactor), round(winHeight - winHeight*modFactor) );
        
        %  Eyelink('command','validation_samples = 5');
        Eyelink('command','validation_samples = 10'); %changed to make
        % it 5 samples instead of 10 to deal with upper left corner of
        % the screem issue
        %             Eyelink('command','validation_sequence = 0,1,2,3,4,5,6,7,8,9');
        %             Eyelink('command','validation_targets =  %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',...
        %                 round(winWidth/2), round(winHeight/2),  round(winWidth/2), round(winHeight*modFactor),  ...
        %                 round(winWidth/2), round(winHeight - winHeight*modFactor),  round(winWidth*modFactor), ...
        %                 round(winHeight/2),  round(winWidth - winWidth*modFactor), round(winHeight/2), ...
        %                 round(winWidth*modFactor), round(winHeight*modFactor), round(winWidth - winWidth*modFactor), ...
        %                 round(winHeight*modFactor), round(winWidth*modFactor), round(winHeight - winHeight*modFactor),...
        %                 round(winWidth - winWidth*modFactor), round(winHeight - winHeight*modFactor)  );
        
        % make sure that we get gaze data from the Eyelink
        Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
        Eyelink('OpenFile', eyeTrackerFileName); % open file to record data  & calibration
        EyelinkDoTrackerSetup(elHandle);
        Eyelink('dodriftcorrect');