% TMT task
% written by Marcello A. Maniglia October 2022 %2017/2022
close all; clear; clc;
commandwindow


addpath([cd '/utilities']);
addpath([cd '/trailtask']);
try
    prompt={'Participant name', 'day','site? UCR(1), UAB(2), Vpixx(3)','Scotoma? yes (1), no(0)','scotoma Vpixx active', 'demo (0) or session (1)',  'eye? left(1) or right(2)', 'Calibration? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?','Site with Vpixx? UCR(1), UAB(2)'};

    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '3', '1','0', '1','2','0','1','2' };
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end

    SUBJECT = answer{1,:}; %Gets Subject Name
    expDay=str2num(answer{2,:});
    site= str2num(answer{3,:});  %0; 1=bits++; 2=display++
    ScotomaPresent= str2num(answer{4,:}); % 0 = no scotoma, 1 = scotoma
    scotomavpixx= str2num(answer{5,:});
    Isdemo=str2num(answer{6,:}); % full session or demo/practice
    whicheye=str2num(answer{7,:}); % which eye to track (vpixx only)
    calibration=str2num(answer{8,:}); % do we want to calibrate or do we skip it? only for Vpixx
    EyeTracker = str2num(answer{9,:}); %0=mouse, 1=eyetracker
    sitevpixx = str2num(answer{10,:}); %1=UCR, 2=UAB PD: I added this to take care of screen differences between the sites 7/26/23

    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end

    if Isdemo==0
        filename='_FLATMTpractice';
    elseif Isdemo==1
        filename='_FLAPTMT';
    end
        folder=cd;
        folder=fullfile(folder, '..\..\datafolder\');

    if site==1
        baseName=[folder SUBJECT filename '_' expDay num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[folder SUBJECT filename '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[folder SUBJECT filename 'Pixx_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];

    datapixxtime = 1;
    responsebox = 0;
    defineSite % initialize Screen function and features depending on OS/Monitor
    CommonParametersTMT % load parameters for time and space

    %% eyetracker initialization (eyelink)
    if EyeTracker==1
        if site==3
            EyetrackerType=2; %1 = Eyelink, 2 = Vpixx
        else
            EyetrackerType=1; %1 = Eyelink, 2 = Vpixx
        end
        eyetrackerparameters % set up Eyelink eyetracker
    else
        EyetrackerType=0;
    end

    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    %% Keys definition/kb initialization

    % get keyboard for the key recording
    deviceIndex = -1; % reset to default keyboard
    [k_id, k_name] = GetKeyboardIndices();
    for i = 1:numel(k_id)
        if strcmp(k_name{i},'Dell Dell USB Keyboard') % unique for your deivce, check the [k_id, k_name]
            deviceIndex =  k_id(i);
        elseif  strcmp(k_name{i},'Apple Internal Keyboard / Trackpad')
            deviceIndex =  k_id(i);
        end
    end

    KbQueueCreate(deviceIndex);
    KbQueueStart(deviceIndex);


    %%
    %Calls the script that has the stimulus details for the trails task
    StimDetailsTrails;

    %sets times for each phase [A_demo, A, B_demo, B]
    Maxtimes=[2 5 2 5]*60; %specified in minutes converted to seconds

    %% Keys definition/kb initialization

    KbName('UnifyKeyNames');

    RespType(1) = KbName('LeftArrow');
    RespType(2) = KbName('RightArrow');
    RespType(3) = KbName('UpArrow');
    RespType(4) = KbName('DownArrow');
    escapeKey = KbName('ESCAPE');	% quit key

    corrkey=RespType(1);
    wrongkey=RespType(2);

    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    end

    %% main loop
    HideCursor(0);
    counter = 0;

    %%
    % check EyeTracker status
    if EyetrackerType == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        % mark zero-plot time in data file
        Eyelink('message' , 'SYNCTIME');
        location =  zeros(length(mixtr), 6);
    elseif EyetrackerType == 2
        %Connect to TRACKPixx3
        Datapixx('Open');
        Datapixx('SetTPxAwake');
        Datapixx('SetupTPxSchedule');
        Datapixx('RegWrRd');
        % %set up recording to start on the same frame flip that shows the image.
        % %We also get the time of the flip using a Marker which saves a time of the
        % %frame flip on the DATAPixx clock
        Datapixx('StartTPxSchedule');
        Datapixx('SetMarker');
        Datapixx('RegWrVideoSync');
    end
    if Isdemo==0
        FLAP_TMT_practice
    else
        FLAP_TMT_practice
        for block=1:4
            askcalib=0;
            %figu res out locations
            stimx=round(TheCoords{block}(:,1)*wRect(3));
            stimy=round(TheCoords{block}(:,2)*wRect(4));
            TheCircMat=[stimx-Csize,stimy-Csize, stimx+Csize,stimy+Csize]'; %this is the array for the cricles
            for i=1:(length(stimx)-1) %this is the array for the lines
                TheLinesMat(1,i*2-1)=stimx(i);
                TheLinesMat(2,i*2-1)=stimy(i);
                TheLinesMat(1,i*2)=stimx(i+1);
                TheLinesMat(2,i*2)=stimy(i+1);
            end
            CircFill=ones(3,length(stimx))*CircleColorFill;
            trial=block;
            FLAPVariablesReset
            HideCursor(); %hides the cursor
            TrailsInstructions(block,w,BackColor,LetterColor ) %instruction screen for each block

            ShowCursor('Arrow'); %Show the cursor
            buttons=0;
            contcoord=0;
            numrespCorr=0; %mm
            resp=0; %mm
            while eyechecked<1
                if EyetrackerType ==2
                    Datapixx('RegWrRd');
                end
                if (eyetime2-trial_time)>0 && (eyetime2-trial_time)<prefixationsquare+ifi && askcalib==0

                    cont=0;
                elseif (eyetime2-trial_time)>=prefixationsquare+ifi*3 && askcalib==0 %&& keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0 %present stimulus
                    numrespCorr=0;%reset number of responses entered
                    numresp=0;
                    resp(length(stimx)) = 0;

                    if MouseCalib
                        x=round(x*wRect(3)/wRect(3))+xoff; % add +xoff for ucr site
                        y=round(y*wRect(4)/wRect(4))-yoff; % add -yoff for ucr site
                    end
                    if sum(buttons)~=0
                        askcalib=1;
                    end

                elseif (eyetime2-trial_time)>=prefixationsquare+ifi*3 && askcalib==1 %&& keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0 %present stimulus

                    if exist('stimstar')==0
                        stim_start=GetSecs;
                        stimstar=1;
                        startblocktime(block)=GetSecs;
                    end
                    %Draw Target
                    if ( (numrespCorr<length(stimx))&&   (startblocktime(block)  -GetSecs<Maxtimes(block) ) )  %loop through trial in each block
                        Screen('FillRect',w,BackColor);
                        %draw lines
                        if numrespCorr>=2
                            Screen('DrawLines',w,TheLinesMat(:,1:2*(numrespCorr-1)) ,2, LineColor)
                        end
                        %draw circles
                        Screen('FillOval',w,CircFill,TheCircMat); %fills circles to cover lines in the middle
                        Screen('FrameOval',w,CircleColorOut,TheCircMat ); %draws circles
                        for i=1:length(stimx)  %draws text
                            if block<=2
                                if i<10
                                    Screen('DrawText', w, num2str(i), stimx(i)-textsize/2, stimy(i)-textsize/2, LetterColor);
                                else
                                    Screen('DrawText', w, num2str(i), stimx(i)-textsize, stimy(i)-textsize/2, LetterColor);
                                end
                            else
                                if mod(i,2)
                                    Screen('DrawText', w, num2str(round(i/2)), stimx(i)-textsize/2, stimy(i)-textsize/2, LetterColor);
                                else
                                    Screen('DrawText', w , Letters(round(i/2)), stimx(i)-textsize/2, stimy(i)-textsize/2, LetterColor);
                                end
                            end
                            %Screen('TextStyle', w, 1);
                        end

                        if  sum(buttons)~=0 && resp(numresp+1)==0;
                            contcoord=contcoord+1;
                            zxx(contcoord)=x;
                            zyy(contcoord)=y;

                            numresp=numresp+1; %increment the number of response counter
                            StartTime(numresp,block)=GetSecs;

                            if (  (x>(TheCircMat(1,numresp)-RespTol)) && (y>(TheCircMat(2,numresp)-RespTol)) && (x<(TheCircMat(3,numresp)+RespTol)) && (y< (TheCircMat(4,numresp )+RespTol)) )
                                RespTime(numresp,block)=startblocktime(block)-StartTime(numresp,block);
                                CircFill(:,1:numresp)=CircleColorFillResp; %changes circle fill to show response
                                resp(numresp)=1;
                                numrespCorr=numrespCorr+1;
                                PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                                PsychPortAudio('Start', pahandle);
                                while any(buttons)
                                    [xcoor,ycoor,buttons]=GetMouse;%wait for the button to be lifted--Pinar added
                                end
                            else
                                beep; %alert poor response
                                while any(buttons)
                                    [xcoor,ycoor,buttons]=GetMouse; %wait for the button to be lifted--Pinar added
                                end
                                numresp=numresp-1;
                            end

                            buttons=zeros(3,1)';
                        end
                    end
                end
                eyefixation5

                if EyetrackerType==2

                    if scotomavpixx==1
                        Datapixx('EnableSimulatedScotoma')
                        Datapixx('SetSimulatedScotomaMode',2) %[~,mode = 0]);
                        scotomaradiuss=round(pix_deg*6);
                        Datapixx('SetSimulatedScotomaRadius',scotomaradiuss) %[~,mode = 0]);
                        mode=Datapixx('GetSimulatedScotomaMode');
                        status= Datapixx('IsSimulatedScotomaEnabled');
                        radius= Datapixx('GetSimulatedScotomaRadius');

                    end
                end
                if EyeTracker==1
                    if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                        Screen('FillRect', w, white);
                    else
                        Screen('FillOval', w, scotoma_color, scotoma);
                    end
                end
                [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);

                VBL_Timestamp=[VBL_Timestamp eyetime2];
                %% process eyedata in real time (fixation/saccades)

                if EyeTracker==1
                    if EyetrackerType==1
                        GetEyeTrackerData
                    elseif EyetrackerType==2
                        GetEyeTrackerDatapixx
                    end
                    GetFixationDecision

                    if EyeData(end,1)<8000 && stopchecking<0
                        trial_time = GetSecs;
                        stopchecking=10;
                    end

                    if CheckCount > 1
                        if (EyeCode(CheckCount) == 0) && (EyeCode(CheckCount-1) > 0)
                            TimerIndex = FixOnsetIndex;
                            FixCount = FixCount + 1;
                            FixIndex(FixCount,1) = FixOnsetIndex;
                            FixatingNow = 1;
                        end
                        if (EyeCode(CheckCount) ~= 0) && (FixatingNow == 1)
                            if FixCount == 0
                                FixCount = 1;
                                FixIndex(FixCount,1) = EndIndex+1;
                            end
                            FixIndex(FixCount,2) = CheckCount-1;
                            FixatingNow = 0;
                        end
                    end
                else
                    if stopchecking<0
                        trial_time = eyetime2; %start timer if we have eye info
                        stopchecking=10;
                    end
                end
                if sum(buttons)>1 && (eyetime2-StartTime(numresp,block))>2
                    [origx,origy,buttons] = GetMouse(); % In while-loop, rapidly and continuously check if mouse button being pressed.
                    x=origx-xoff;
                    if sitevpixx==1 %PD: I added this if statement that is related to screen size at UCR 7/26/23
                        y=origy-yoff; % uncomment this line for ucr
                    end%PD: I added this if statement that is related to screen size at UCR 7/26/23
                elseif sum(buttons)>1 && (eyetime2-StartTime(numresp,block))<=2

                elseif sum(buttons)==0
                    if sitevpixx == 2
                    [origx,y,buttons] = GetMouse(); % In while-loop, rapidly and cscaontinuously check if mouse button being pressed. PD: It was  [origx,origy,buttons] = GetMouse(); it doesn't work at UAB so I changed origy to y 7/28/23
                    elseif sitevpixx == 1
                        [origx,origy,buttons] = GetMouse();
                    end
                    x=origx-xoff;
                    if sitevpixx==1 %PD: I added this if statement that is related to screen size at UCR 7/26/23
                        y=origy-yoff; % uncomment this line for ucr
                    end %PD: I added this if statement that is related to screen size at UCR 7/26/23
                end
                if numrespCorr==length(stimx)
                    stim_stop=GetSecs;
                    eyechecked=10^4;
                end
            end

            Screen('Flip',w);
            WaitSecs(0.5)

            save(baseName)
            time_stim(kk) = stim_stop - stim_start;
            total_trials(kk)=block;
            %Since it has only ones, I dont think we need this:
            if kk==1
                rispo1(kk,:)=resp;
            elseif kk==2
                rispo2(kk,:)=resp;
            elseif kk==3
                rispo3(kk,:)=resp;
            elseif kk==4
                rispo4(kk,:)=resp;
            end

            vbltimestamp(block).ix=[VBL_Timestamp];


            if EyeTracker==1
                EyeSummary.(TrialNum).EyeData = EyeData;
                clear EyeData
                EyeSummary.(TrialNum).EyeData(:,6) = EyeCode';
                clear EyeCode
                if exist('FixIndex')==0
                    FixIndex=0;
                end;
                EyeSummary.(TrialNum).FixationIndices = FixIndex;
                clear FixIndex
                EyeSummary.(TrialNum).TotalEvents = CheckCount;
                clear CheckCount
                EyeSummary.(TrialNum).TotalFixations = FixCount;
                clear FixCount

                EyeSummary.(TrialNum).EventData = EvtInfo;
                clear EvtInfo
                EyeSummary.(TrialNum).ErrorData = ErrorData;
                clear ErrorData
                EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
                EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
                EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
                EyeSummary.(TrialNum).TimeStamps.Stimulus = stim_start;
                EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;
                clear ErrorInfo
            end
            if EyetrackerType==2
                %read in eye data
                Datapixx('RegWrRd');
                status = Datapixx('GetTPxStatus');
                toRead = status.newBufferFrames;
                [bufferData, ~, ~] = Datapixx('ReadTPxData', toRead);

                %bufferData is formatted as follows:
                %1      --- Timetag (in seconds)
                %2      --- Left Eye X (in pixels)
                %3      --- Left Eye Y (in pixels)
                %4      --- Left Pupil Diameter (in pixels)
                %5      --- Right Eye X (in pixels)
                %6      --- Right Eye Y (in pixels)
                %7      --- Right Pupil Diameter (in pixels)
                %8      --- Digital Input Values (24 bits)
                %9      --- Left Blink Detection (0=no, 1=yes)
                %10     --- Right Blink Detection (0=no, 1=yes)
                %11     --- Digital Output Values (24 bits)
                %12     --- Left Eye Fixation Flag (0=no, 1=yes)
                %13     --- Right Eye Fixation Flag (0=no, 1=yes)
                %14     --- Left Eye Saccade Flag (0=no, 1=yes)
                %15     --- Right Eye Saccade Flag (0=no, 1=yes)
                %16     --- Message code (integer)
                %17     --- Left Eye Raw X (in pixels)
                %18     --- Left Eye Raw Y (in pixels)
                %19     --- Right Eye Raw X (in pixels)
                %20     --- Right Eye Raw Y (in pixels)

                %IMPORTANT: "RIGHT" and "LEFT" refer to the right and left eyes shown
                %in the console overlay. In tabletop and MEG setups, this view is
                %inverted. This means "RIGHT" in our labelling convention corresponds
                %to the participant's left eye. Similarly "LEFT" in our convention
                %refers to left on the screen, which corresponds to the participant's
                %right eye.

                %If you are using an MRI setup with an inverting mirror, "RIGHT" will
                %correspond to the participant's right eye.

                %save eye data from trial as a table in the trial structure
                Pixxstruct(trial).EyeData = array2table(bufferData, 'VariableNames', {'TimeTag', 'LeftEyeX', 'LeftEyeY', 'LeftPupilDiameter', 'RightEyeX', 'RightEyeY', 'RightPupilDiameter',...
                    'DigitalIn', 'LeftBlink', 'RightBlink', 'DigitalOut', 'LeftEyeFixationFlag', 'RightEyeFixationFlag', 'LeftEyeSaccadeFlag', 'RightEyeSaccadeFlag',...
                    'MessageCode', 'LeftEyeRawX', 'LeftEyeRawY', 'RightEyeRawX', 'RightEyeRawY'});
                %interim save
                % save(baseName, 'Pixxstruct');
                % Pixxstruct(trial).EyeData.TimeTag-Pixxstruct(trial).TargetOnset2
            end
            kk=kk+1;
            clear PKnew2
            if closescript==1
                break
            end
        end
    end
    %thank them at the end of the experiment
    oldTextSize=Screen('TextSize', w, 80);
    DrawFormattedText(w,'Great Job','center','center',LetterColor);
    oldTextSize=Screen('TextSize', w, oldTextSize);
    Screen('Flip',w)
    WaitSecs(1)
    Screen('Flip',w)
    save(baseName) %at the end of each block save the data
    DrawFormattedText(w, 'Task completed', 'center', 'center', white);
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    ListenChar(0);
    KbQueueWait;
    Screen('Flip', w);
    % shut down EyeTracker
    if EyetrackerType==1
        Eyelink('StopRecording');
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    elseif EyetrackerType==2
        Datapixx('SetTPxSleep');
        Datapixx('RegWrRd');
        Datapixx('Close');
    end
    Screen('Flip', w);
    Screen('TextFont', w, 'Arial');


    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];


    KbQueueWait;
    ShowCursor('Arrow');

    if site==1
        Screen('CloseAll');
        Screen('Preference', 'SkipSyncTests', 0);
        PsychPortAudio('Close', pahandle);

    else
        Screen('Preference', 'SkipSyncTests', 0);
        Screen('LoadNormalizedGammaTable', w , (linspace(0,1,256)'*ones(1,3)));
        Screen('Flip', w);
        Screen('CloseAll');
    end


    %% data analysis (to be completed once we have the final version)


    %to get each scale in a matrix (as opposite as Threshlist who gets every
    %trial in a matrix)
    %thresho=permute(Threshlist,[3 1 2]);

    %to get the final value for each staircase
    %  final_threshold=thresho(numel(thresho(:,:,1)),1:length(thresho(1,:,1)),1:length(thresho(1,1,:)));
    %total_thresh= [final_threshold(:,:,1) final_threshold(:,:,2)];
    %%
    %save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|ax|ay|xxx|yyyy|circle|azimuths|corrS|errorS|Allimg)$).');


catch ME
    psychlasterror()
end