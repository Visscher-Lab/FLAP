%% FLAPpractice

Jitpracticearray=[0 0 1 1 2 2 3 3 4 4 5 5]; %  stimulus ori practice
stimulusdurationpracticearray=[0.7 0.7 0.6 0.6 0.5 0.5 0.3 0.3 0.2 0.2 0.2 0.2]; % stimulus duration practice
targethighercontrast=[1 0 1 0 1 0 1 0 1 0 0 0]; % target contrast
Tscat=0;
practicetrialnum=length(targethighercontrast); %number of trials fro the practice block
FlickerTime=0;
trialTimeout=10;
performanceThresh=0.7;
gapfeedback= 0.5;
feedbackduration=1;

for practicetrial=1:practicetrialnum
    presentfeedback=0;
%         respTimeprac=10^6;
    theanspractice(practicetrial)=randi(2);
    Orijit=Jitpracticearray(practicetrial);
    stimulusdurationpractice=stimulusdurationpracticearray(practicetrial);
    %CIstimuliModPracticeAssessment % add the offset/polarity repulsion
    CIstimuliModIIIPractice
    theeccentricity_Y=0;
    theeccentricity_X=LocX(mixtr(trial,2))*pix_deg; % identifies if the stimulus needs to be presented in the left or right side
    eccentricity_X(practicetrial)= theeccentricity_X;
    eccentricity_Y(practicetrial) =theeccentricity_Y ;
    if practicetrial==1
        InstructionCIAssessmentPractice
    end
    %  destination rectangle for the target stimulus
    imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
        imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
    %  destination rectangle for the fixation dot
    imageRect_offs_dot=[imageRectDot(1)+theeccentricity_X, imageRectDot(2)+theeccentricity_Y,...
        imageRectDot(3)+theeccentricity_X, imageRectDot(4)+theeccentricity_Y];
        if EyetrackerType ==2
            %start logging eye data
            Datapixx('RegWrRd');
            Pixxstruct(trial).TrialStart = Datapixx('GetTime');
            Pixxstruct(trial).TrialStart2 = Datapixx('GetMarker');
        end
    
    if responsebox==1
        Bpress=0;
        timestamp=-1;
        TheButtons=-1;
        inter_buttonpress{1}=[]; % added by Jason because matlab was throwing and error
        % saying that inter_buttonpress was not assigned.
        % 26 June 2018
        RespTime=[];
        binaryvals=[];
        bin_buttonpress{1}=[]; % Jerry:use array instead of cell
        inter_timestamp{1}=[]; % JERRY: NEVER USED, DO NOT UNDERSTAND WHAT IT STANDS FOR
        %
        % Datapixx('RegWrRd');
        % buttonLogStatus = Datapixx('GetDinStatus');
        
        % if buttonLogStatus.logRunning~=1 % initialize digital input log if not up already.
        %     Datapixx('SetDinLog'); %added by Jerry
        %     Datapixx('StartDinLog');
        %     Datapixx('RegWrRd');
        %     buttonLogStatus = Datapixx('GetDinStatus');
        %     Datapixx('RegWrRd');
        % end
        % if ~exist('starttime','var') % var added by Jason
        %     Datapixx('RegWrRd');
        %     starttime=Datapixx('GetTime');
        % elseif  isempty(starttime)  % modified by Jerry from else to elseif
        %     Datapixx('RegWrRd');
        %     starttime=Datapixx('GetTime');
        % end
        
%         Configure digital input system for monitoring button box
                Datapixx('SetDinDataDirection', hex2dec('1F0000'));     % Drive 5 button lights
                Datapixx('EnableDinDebounce');                          % Debounce button presses
                Datapixx('SetDinLog');                                  % Log button presses to default address
                Datapixx('StartDinLog');                                % Turn on logging
                Datapixx('RegWrRd');
                % Wait until all buttons are up
                while (bitand(Datapixx('GetDinValues'), hex2dec('FFFF')) ~= hex2dec('FFFF'))
                    Datapixx('RegWrRd');
                end
                % Flush any past button presses
                Datapixx('SetDinLog');
                Datapixx('RegWrRd');
    end
    %Initialization/reset of several practicetrial-based variables
    FLAPVariablesReset % reset some variables used in each practicetrial
    trialTimedout(practicetrial)=0; % counts how many trials timed out before response

    while eyechecked<1
        if datapixxtime==1
            eyetime2=Datapixx('GetTime');
        end
        if EyetrackerType ==2
            Datapixx('RegWrRd');
        end
        fixationscriptW % visual aids on screen
        %             fixating=1500;
        
        %% here is where the first time-based trial loop starts (until first forced fixation is satisfied)
        if (eyetime2-pretrial_time)>=ITI  && fixating<fixationduration/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
            if exist('startrial') == 0
                startrial=1;
                trialstart(practicetrial)=GetSecs;
                trialstart_frame(practicetrial)=eyetime2;
            end
            [fixating, counter, framecounter] = IsFixatingSquareNew(wRect,xeye,yeye,fixating,framecounter,counter,fixwindowPix);
            if exist('starfix') == 0
                if datapixxtime==1
                    startfix(practicetrial)=Datapixx('GetTime');
                else
                    startfix(practicetrial)=eyetime2;
                end
            end
            Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
            Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
        elseif (eyetime2-pretrial_time)>ITI && fixating>=fixationduration/ifi && stopchecking>1 && fixating<1000  && (eyetime2-pretrial_time)<=trialTimeout %&& keyCode(escapeKey) ==0 && counterflicker<FlickerTime/ifi
            % here I need to reset the trial time in order to preserve
            % timing for the next events (first fixed fixation event)
            % HERE interval between cue disappearance and beginning of
            % next stream of flickering stimuli
            if datapixxtime==1
                trial_time = Datapixx('GetTime');
            else
                trial_time = GetSecs;
            end
            if EyetrackerType ==2
                Datapixx('SetMarker');
                Datapixx('RegWrVideoSync');
                %collect marker data
                Datapixx('RegWrRd');
                Pixxstruct(trial).TrialOnset = Datapixx('GetMarker');
            end
            fixating = 1500;
        end
        %% here is where the second time-based trial loop starts
        if (eyetime2-trial_time)>=postfixationblank && (eyetime2-trial_time)< postfixationblank+stimulusdurationpractice && fixating>400 && (eyetime2-pretrial_time)<=trialTimeout && stopchecking>1 %present pre-stimulus and stimulus  && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0
            % HERE I PRESENT THE TARGET
            if exist('imageRect_offsCI')==0    % destination rectangle for CI stimuli
                imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(practicetrial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(practicetrial),...
                    imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(practicetrial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(practicetrial)];
                imageRect_offsCI2=imageRect_offsCI;
                imageRectMask = CenterRect([0, 0,  CIstimulussize+maskthickness CIstimulussize+maskthickness], wRect);
                imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(practicetrial), imageRectMask(2)+eccentricity_Y(practicetrial),...
                    imageRectMask(3)+eccentricity_X(practicetrial), imageRectMask(4)+eccentricity_Y(practicetrial)];
            end

            %here I draw the target contour
            Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
            imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
            if targethighercontrast(practicetrial)==1
                Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], 1 );
            end
            % here I draw the circle within which I show the contour target
            Screen('FrameOval', w,[gray], imageRect_offsCImask, maskthickness/2, maskthickness/2);
            Screen('FrameOval', w,gray, imageRect_offsCImask, 22, 22);
            imagearray{practicetrial}=Screen('GetImage', w);
            
            if exist('stimstar')==0
                %                     stim_start = GetSecs;
                stim_start_frame=eyetime2;
                if responsebox==1
                    Datapixx('SetMarker');
                    Datapixx('RegWrVideoSync');
                    %collect marker data
                    Datapixx('RegWrRd');
                    stim_startBox2(practicetrial)= Datapixx('GetMarker');
                    stim_startBox(practicetrial)=Datapixx('GetTime');
                end
                stimstar=1;
            end
            if responsebox==0
                if    keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0
                    thekeys = find(keyCode);
                    if length(thekeys)>1
                        thekeys=thekeys(1);
                    end
                    thetimes=keyCode(thekeys);
                    [secs  indfirst]=min(thetimes);
                    respTime=GetSecs;
                    %                     eyechecked=10^4; % exit loop for this trial
                end
            elseif responsebox==1
                if (buttonLogStatus.newLogFrames > 0)
                    respTimeprac(practicetrial)=secs;
                    respt = respTimeprac(practicetrial);
                    presentfeedback = 1;
%                                         eyechecked=10^4;
                end 
            end
        elseif (eyetime2-trial_time)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusdurationpractice && fixating>400 && skipcounterannulus>10  && (eyetime2-pretrial_time)<=trialTimeout && stopchecking>1 %present pre-stimulus and stimulus
            if responsebox==0
                if    keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0
                    thekeys = find(keyCode);
                    if length(thekeys)>1
                        thekeys=thekeys(1);
                    end
                    thetimes=keyCode(thekeys);
                    [secs  indfirst]=min(thetimes);
                    respTime=GetSecs;
                    %                     eyechecked=10^4; % exit loop for this trial
                end
            elseif responsebox==1
                if (buttonLogStatus.newLogFrames > 0)
                    respTimeprac(practicetrial)=secs;
                    respt = respTimeprac(practicetrial);
                    presentfeedback = 1;
%                                         eyechecked=10^4;
                end  
            end
            
        elseif (eyetime2-trial_time)>=postfixationblank+stimulusdurationpractice && fixating>400 && (eyetime2-pretrial_time)<=trialTimeout && stopchecking>1 %present pre-stimulus and stimulus
            if responsebox==0
                if    keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0
                    thekeys = find(keyCode);
                    if length(thekeys)>1
                        thekeys=thekeys(1);
                    end
                    thetimes=keyCode(thekeys);
                    [secs  indfirst]=min(thetimes);
                    respTime=GetSecs;
                    %                     eyechecked=10^4; % exit loop for this trial
                end
            elseif responsebox==1
                if (buttonLogStatus.newLogFrames > 0)
                    respTimeprac(practicetrial)=secs;
                    respt = respTimeprac(practicetrial);
                    presentfeedback = 1;
%                                         eyechecked=10^4;
                end
            end
            
        elseif (eyetime2-pretrial_time)>=trialTimeout
            stim_stop=GetSecs;
            trialTimedout(practicetrial)=1;
            %    [secs  indfirst]=min(thetimes);
            if responsebox==1
                Datapixx('StopDinLog');
            end
            eyechecked=10^4; % exit loop for this trial
        end
         if presentfeedback == 1 && (eyetime2-respt)>=gapfeedback && (eyetime2-respt)< feedbackduration
                %here I draw the target contour
                Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
                imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
                Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], 0.7, [1.5 .5 .5] );
                % here I draw the circle within which I show the contour target
                Screen('FrameOval', w,[gray], imageRect_offsCImask, maskthickness/2, maskthickness/2);
                %                 trialTimedout(practicetrial) = 99;
            elseif presentfeedback == 1 && (eyetime2-respt)> feedbackduration
                stim_stop=GetSecs;
                eyechecked=10^4; % exit loop for this practicetrial
            end
        
        %% here I draw the scotoma, elements below are called every frame
        eyefixation5
        if ScotomaPresent == 1 % do we want the scotoma? (default is yes)
            Screen('FillOval', w, scotoma_color, scotoma);
        else % else we get a fixation cross and no scotoma
            Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
            Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
        end
        if demo==1
            if penalizeLookaway>0
                if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                    Screen('FillRect', w, gray);
                end
            end
        end
        if datapixxtime==1
            [eyetime3, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
            VBL_Timestamp=[VBL_Timestamp eyetime3];
        else
            [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
            VBL_Timestamp=[VBL_Timestamp eyetime2];
        end
        %% process eyedata in real time (fixation/saccades)
        if EyeTracker==1
            if EyetrackerType==1
                GetEyeTrackerData
            elseif EyetrackerType==2
                GetEyeTrackerDatapixx
            end
            GetFixationDecision
            if EyeData(end,1)<8000 && stopchecking<0
                trial_time = GetSecs; %start timer if we have eye info
                stopchecking=10;
            end
            if EyeData(end,1)>8000 && stopchecking<0 && (eyetime2-pretrial_time)>calibrationtolerance
                trialTimeout=100000;
                caliblock=1;
                DrawFormattedText(w, 'Need calibration', 'center', 'center', white);
                Screen('Flip', w);
                %   KbQueueWait;
                if responsebox==0
                    if  sum(keyCode)~=0
                        thekeys = find(keyCode);
                        if  thekeys==escapeKey
                            DrawFormattedText(w, 'Bye', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            %  KbQueueWait;
                            closescript = 1;
                            eyechecked=10^4;
                        elseif thekeys==RespType(5)
                            DrawFormattedText(w, 'continue', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            %  KbQueueWait;
                            % trial=trial-1;
                            eyechecked=10^4;
                        elseif thekeys==RespType(6)
                            DrawFormattedText(w, 'Calibration!', 'center', 'center', white);
                            Screen('Flip', w);
                            WaitSecs(1);
                            TPxReCalibrationTestingMM(1,screenNumber, baseName)
                            %    KbQueueWait;
                            eyechecked=10^4;
                        end
                    end
                elseif responsebox==1
                    if  thekeys(practicetrial)==escapeKey
                        DrawFormattedText(w, 'Bye', 'center', 'center', white);
                        Screen('Flip', w);
                        WaitSecs(1);
                        %  KbQueueWait;
                        closescript = 1;
                        eyechecked=10^4;
                    elseif thekeys(practicetrial)==RespType(5)
                        DrawFormattedText(w, 'continue', 'center', 'center', white);
                        Screen('Flip', w);
                        WaitSecs(1);
                        %  KbQueueWait;
                        % trial=trial-1;
                        eyechecked=10^4;
                    elseif thekeys(practicetrial)==RespType(6)
                        DrawFormattedText(w, 'Calibration!', 'center', 'center', white);
                        Screen('Flip', w);
                        WaitSecs(1);
                        TPxReCalibrationTestingMM(1,screenNumber, baseName)
                        %    KbQueueWait;
                        eyechecked=10^4;
                    end
                end
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
        
        if responsebox==1 % DATApixx AYS 5/4/23 I added some documentation for WaitForEvent_Jerry - let me know if you have questions.
            %  [Bpress, RespTime, TheButtons] = WaitForEvent_Jerry(0, TargList);
            Datapixx('RegWrRd');
            buttonLogStatus = Datapixx('GetDinStatus');
            if (buttonLogStatus.newLogFrames > 0)
                [thekeys(practicetrial) secs] = Datapixx('ReadDinLog');
            end
            %         [keyIsDown, keyCode] = KbQueueCheck;
        else % AYS: UCR and UAB?
            [keyIsDown, keyCode] = KbQueueCheck;
        end
    end
    if trialTimedout(practicetrial)== 0 
        foo=(RespType==thekeys(practicetrial));
        if foo(theanspractice(practicetrial))==1 % if correct response
            resp = 1;
            PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
            PsychPortAudio('Start', pahandle);
        elseif foo(theanspractice(practicetrial))==0
            resp = 0; % if wrong response
            nswrprac(practicetrial) = 0;
            PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
            PsychPortAudio('Start', pahandle);
        end
    else
        resp = 0;
        respTimeprac=0;
        PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
        PsychPortAudio('Start', pahandle);
    end
    practiceresp(practicetrial)=resp;
end
% do we exit the practice loop?
if practicePassed~=2
    performance=sum(practiceresp)/practicetrial;
    if performance>=performanceThresh
        practicePassed=1;
    end
end
