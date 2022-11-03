%FLAPpractice

Jitpracticearray=[0 0  15 0 0  15 0 0  15]; %  stimulus ori practice
% stimulusdurationpracticearray=ones(1,9); % Sam's testing
stimulusdurationpracticearray=[0.7 0.7 0.7 0.5 0.5 0.5 0.25 0.25 0.25]; % stimulus duration practice
targethighercontrast=[1 1 0 1 0 0 1 0 0]; % target contrast
FlickerTime=0;
Tscat=0;
performanceThresh=0.75;
practicetrialnum=length(targethighercontrast); %number of trials fro the practice block

trialTimeout=20;
for practicetrial=1:practicetrialnum
    trialTimedout(practicetrial)=0; % counts how many trials timed out before response
    theans(practicetrial)=randi(2);
    Orijit=Jitpracticearray(practicetrial);
    stimulusdurationpractice=stimulusdurationpracticearray(practicetrial);
    CIstimuliModPractice % add the offset/polarity repulsion
    theeccentricity_Y=0;
    theeccentricity_X=PRLx*pix_deg; % if training type 1 or 2, stimulus always presented in the center
    eccentricity_X(practicetrial)= theeccentricity_X;
    eccentricity_Y(practicetrial) =theeccentricity_Y;
    
    if practicetrial==1
        InstructionCIAssessment
    end
    
    %  destination rectangle for the target stimulus
    imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
        imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
    
    %  destination rectangle for the fixation dot
    imageRect_offs_dot=[imageRectDot(1)+theeccentricity_X, imageRectDot(2)+theeccentricity_Y,...
        imageRectDot(3)+theeccentricity_X, imageRectDot(4)+theeccentricity_Y];
    %% Initialization/reset of several practicetrial-based variables
    FLAPVariablesReset % reset some variables used in each practicetrial
    
    while eyechecked<1
        if EyetrackerType ==2
            Datapixx('RegWrRd'); %inbuilt DataPixx function
        end
        fixationscriptW % visual aids on screen
        
        fixating=1500;
        preFixation = 6;
        %% here is where the first time-based practicetrial loop starts (until first forced fixation is satisfied)
        if (eyetime2-trial_time)>=ifi*2 && (eyetime2-trial_time)<ifi*2+preFixation && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
            
            % pre-event empty space, allows for some cleaning
            
            counterflicker=-10000;
            
        elseif (eyetime2-trial_time)>=ifi*2+preFixation && fixating>400 && stopchecking>1 && flickerdone<1 && counterannulus<=round(AnnulusTime/ifi) && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ==0 && (eyetime2-pretrial_time)<=trialTimeout
            if exist('startrial') == 0
                startrial=1;
                trialstart(practicetrial)=GetSecs;
                trialstart_frame(practicetrial)=eyetime2;
            end
            if skipforcedfixation==1 % skip the force fixation
                counterannulus=(AnnulusTime/ifi)+1;
                skipcounterannulus=1000;
            else
                %force fixation for training types 1 and 2
                [counterannulus, framecounter ]=  IsFixatingSquareNew2(wRect,newsamplex,newsampley,framecounter,counterannulus,fixwindowPix);
            end
                Screen('FillOval', w, fixdotcolor, imageRect_offs_dot); % for the cue
                if counterannulus==round(AnnulusTime/ifi) % when I have enough frame to satisfy the fixation requirements
                    newtrialtime=GetSecs;
                    skipcounterannulus=1000;
                    flickerdone=10;
                end
        elseif (eyetime2-trial_time)>=ifi*2+preFixation && fixating>400 && stopchecking>1 && counterannulus<AnnulusTime/ifi && flickerdone<1 && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ~=0 && (eyetime2-pretrial_time)<=trialTimeout
            % HERE I exit the script if I press ESC
            thekeys = find(keyCode);
            closescript=1;
            break;
        end
        %% target loop
        if (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusdurationpractice && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ==0 && stopchecking>1 %present pre-stimulus and stimulus
            % HERE I PRESENT THE TARGET
            if exist('imageRect_offsCI')==0    % destination rectangle for CI stimuli
                imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(practicetrial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(practicetrial),...
                    imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(practicetrial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(practicetrial)];
                imageRect_offsCI2=imageRect_offsCI;
                imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(practicetrial), imageRectMask(2)+eccentricity_Y(practicetrial),...
                    imageRectMask(3)+eccentricity_X(practicetrial), imageRectMask(4)+eccentricity_Y(practicetrial)];
                created(practicetrial)=99;
            end
            created2(practicetrial)=99;
            
            %here I draw the target contour
            Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
            imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
            if targethighercontrast(practicetrial)==1
                Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], 0.7 );
            end
            
            
            imagearray{practicetrial}=Screen('GetImage', w);
            if exist('stimstar')==0
                stim_start = GetSecs;
                stim_start_frame=eyetime2;
                stimstar=1;
            end
        elseif (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusdurationpractice && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 %present pre-stimulus and stimulus
            eyechecked=10^4; % exit loop for this practicetrial
            thekeys = find(keyCode);
            if length(thekeys)>1
                thekeys=thekeys(1);
            end
            thetimes=keyCode(thekeys);
            [secs  indfirst]=min(thetimes);
            respTime=GetSecs;
        elseif (eyetime2-newtrialtime)>=forcedfixationISI+stimulusdurationpractice && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0 && stopchecking>1 %present pre-stimulus and stimulus
            eyechecked=10^4; % exit loop for this practicetrial
            thekeys = find(keyCode);
            if length(thekeys)>1
                thekeys=thekeys(1);
            end
            thetimes=keyCode(thekeys);
            [secs  indfirst]=min(thetimes);
            respTime=GetSecs;
        elseif (eyetime2-pretrial_time)>=trialTimeout
            stim_stop=GetSecs;
            trialTimedout(practicetrial)=1;
            %    [secs  indfirst]=min(thetimes);
            eyechecked=10^4; % exit loop for this practicetrial
        end
        %% here I draw the scotoma, elements below are called every frame
        eyefixation5
        Screen('FillOval', w, scotoma_color, scotoma);
        if penalizeLookaway>0
            if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                Screen('FillRect', w, gray);
            end
        end
        [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
        
        VBL_Timestamp=[VBL_Timestamp eyetime2];
        %% process eyedata in real time (fixation/saccades)
        if EyeTracker==1
            if site<3
                GetEyeTrackerData
            elseif site ==3
                GetEyeTrackerDatapixx
            end
            GetFixationDecision
            if EyeData(end,1)<8000 && stopchecking<0
                trial_time = GetSecs; %start timer if we have eye info
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
        end
        [keyIsDown, keyCode] = KbQueueCheck;
    end
    
    if trialTimedout(practicetrial)== 0
        foo=(RespType==thekeys);
        if foo(theans(practicetrial)) % if correct response
            resp = 1;
            PsychPortAudio('Start', pahandle1); % sound feedback
        elseif (thekeys==escapeKey) % esc pressed
            closescript = 1;
            ListenChar(0);
            break;
        else
            resp = 0; % if wrong response
            PsychPortAudio('Start', pahandle2); % sound feedback
        end
    else
        resp = 0;
        respTime=0;
        PsychPortAudio('Start', pahandle2);
    end
    practiceresp(practicetrial)=resp;
end
% do we exit the practice loop?
performance=sum(practiceresp)/practicetrial;
if performance>=performanceThresh
    practicePassed=1;
end
