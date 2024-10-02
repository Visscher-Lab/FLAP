%FLAPpractice

Jitpracticearray=[0 0 1 1 2 2 3 3 4 4 5 5]; %  stimulus ori practice
stimulusdurationpracticearray=[0.7 0.7 0.6 0.6 0.5 0.5 0.3 0.3 0.2 0.2 0.2 0.2]; % stimulus duration practice
targethighercontrast=[1 0 1 0 1 0 1 0 1 0 0 0]; % target contrast
Tscat=0;
practicetrialnum=length(targethighercontrast); %number of trials fro the practice block
trialTimeout=20;
FlickerTime=0;
trialTimeout=10;
performanceThresh=0.7;
gapfeedback= 0.5;
feedbackduration=1;
for practicetrial=1:practicetrialnum
    presentfeedback=0;
    respTime=10^6;
    trialTimedout(practicetrial)=0; % counts how many trials timed out before response
    theanspractice(practicetrial)=randi(2);
    
        Orijit=Jitpracticearray(practicetrial);
        stimulusdurationpractice=stimulusdurationpracticearray(practicetrial);
        %         CIstimuliModPracticeAssessment % add the offset/polarity repulsion
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
    %% Initialization/reset of several practicetrial-based variables
    FLAPVariablesReset % reset some variables used in each practicetrial
    currentExoEndoCueDuration=ExoEndoCueDuration(1); % only for Assessment types 3 & 4
    
    while eyechecked<1
        if EyetrackerType ==2
            Datapixx('RegWrRd'); %inbuilt DataPixx function
        end
        fixationscriptW % visual aids on screen       
        fixating=1500;       
        %% here is where the first time-based practicetrial loop starts (until first forced fixation is satisfied)
        if (eyetime2-trial_time)>=ifi*2 && (eyetime2-trial_time)<ifi*2+preCueISI && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout           
            % pre-event empty space, allows for some cleaning            
            counterflicker=-10000;            
        elseif (eyetime2-trial_time)>=ifi*2+preCueISI && (eyetime2-trial_time)<+ifi*2+preCueISI+currentExoEndoCueDuration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
            if exist('startrial') == 0
                startrial=1;
                trialstart(practicetrial)=GetSecs;
                trialstart_frame(practicetrial)=eyetime2;
            end            
        elseif (eyetime2-trial_time)>=ifi*2+preCueISI+currentExoEndoCueDuration+postCueISI && fixating>400 && stopchecking>1 && flickerdone<1 && counterannulus<=AnnulusTime/ifi && keyCode(escapeKey) ==0 && (eyetime2-pretrial_time)<=trialTimeout %&& counterflicker<FlickerTime/ifi
            % here I need to reset the practicetrial time in order to preserve
            % timing for the next events (first fixed fixation event)
            % HERE interval between cue disappearance and beginning of
            % next stream of flickering stimuli
            if skipforcedfixation==1 % skip the force fixation
                counterannulus=(AnnulusTime/ifi)+1;
                skipcounterannulus=1000;
            else %force fixation for Assessment types 1 and 2
                    [counterannulus, framecounter ]=  IsFixatingSquareNew2(wRect,newsamplex,newsampley,framecounter,counterannulus,fixwindowPix);
                    Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                if counterannulus==round(AnnulusTime/ifi) % when I have enough frame to satisfy the fixation requirements
                    newtrialtime=GetSecs;
                    skipcounterannulus=1000;
                    flickerdone=10;
                end
            end
        elseif (eyetime2-trial_time)>=ifi*2+preCueISI+currentExoEndoCueDuration+postCueISI && fixating>400 && stopchecking>1 && counterannulus<AnnulusTime/ifi && flickerdone<1 && counterflicker<FlickerTime/ifi && keyCode(escapeKey) ~=0 && (eyetime2-pretrial_time)<=trialTimeout
            % HERE I exit the script if I press ESC
            thekeys = find(keyCode);
            closescript=1;
            break;
        end
        %% target loop
        if (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusdurationpractice && fixating>400 && skipcounterannulus>10 && (eyetime2-pretrial_time)<=trialTimeout  && stopchecking>1 %present pre-stimulus and stimulus
            % HERE I PRESENT THE TARGET
                if exist('imageRect_offsCI')==0    % destination rectangle for CI stimuli
                    imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(practicetrial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(practicetrial),...
                        imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(practicetrial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(practicetrial)];
                    imageRect_offsCI2=imageRect_offsCI;
                    %                     imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                    imageRectMask = CenterRect([0, 0,  CIstimulussize+maskthickness CIstimulussize+maskthickness ], wRect);
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
                %                 % here I draw the circle within which I show the contour target
                Screen('FrameOval', w,[gray], imageRect_offsCImask, maskthickness/2, maskthickness/2);
                %                 Screen('FrameOval', w,gray, imageRect_offsCImask, 22, 22);
                %                 if skipmasking==0
                %                     assignedPRLpatch
                %                 end           
            imagearray{practicetrial}=Screen('GetImage', w);
            if exist('stimstar')==0
                stim_start = GetSecs;
                stim_start_frame=eyetime2;
                stimstar=1;
            end            
            if  sum(keyCode) ~=0
                thekeys = find(keyCode);
                if length(thekeys)>1
                    thekeys=thekeys(1);
                end
                thetimes=keyCode(thekeys);
                [secs,  indfirst]=min(thetimes);
                respTime=eyetime2;
                foo=(RespType==thekeys);
                if foo(theanspractice(practicetrial)) % if correct response
                    PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                elseif (thekeys==escapeKey) % esc pressed
                    practicePassed=2;
                    closescript = 1;
                    ListenChar(0);
                    break;
                else
                    PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                end
                presentfeedback=1;
            end
            
        elseif (eyetime2-newtrialtime)>=forcedfixationISI+stimulusdurationpractice && fixating>400 && skipcounterannulus>10  && (eyetime2-pretrial_time)<=trialTimeout && stopchecking>1 %present pre-stimulus and stimulus
            
            if  sum(keyCode) ~=0
                thekeys = find(keyCode);
                if length(thekeys)>1
                    thekeys=thekeys(1);
                end
                thetimes=keyCode(thekeys);
                [secs,  indfirst]=min(thetimes);
                respTime=eyetime2;
                foo=(RespType==thekeys);
                if foo(theanspractice(practicetrial)) % if correct response
                    PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                elseif (thekeys==escapeKey) % esc pressed
                    practicePassed=2;
                    closescript = 1;
                    ListenChar(0);
                    break;
                else
                    PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                end
            end
        elseif (eyetime2-newtrialtime)>=trialTimeout
            trialTimedout(practicetrial)=1;
            PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
            PsychPortAudio('Start', pahandle);
            respTime=eyetime2;
        end
        
        if  (eyetime2-respTime)>=gapfeedback && (eyetime2-respTime)<= feedbackduration
            %here I draw the target contour
            Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
            imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
        %    if targethighercontrast(practicetrial)==1
                Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], 0.7, [1.5 .5 .5] );
         %   end
            %                 % here I draw the circle within which I show the contour target
            Screen('FrameOval', w,[gray], imageRect_offsCImask, maskthickness/2, maskthickness/2);
        elseif  (eyetime2-respTime)> feedbackduration
            stim_stop=GetSecs;
            %    [secs  indfirst]=min(thetimes);
            eyechecked=10^4; % exit loop for this practicetrial
        end
        %% here I draw the scotoma, elements below are called every frame
        eyefixation5
        Screen('FillOval', w, scotoma_color, scotoma);
        %   visiblePRLring
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
        else
            if stopchecking<0
                trial_time = eyetime2; %start timer if we have eye info
                stopchecking=10;
            end
        end
        [keyIsDown, keyCode] = KbQueueCheck;
    end
    
    if trialTimedout(practicetrial)== 0
        foo=(RespType==thekeys);
        if foo(theanspractice(practicetrial)) % if correct response
            resp = 1;
  %          PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
   %         PsychPortAudio('Start', pahandle);
        elseif (thekeys==escapeKey) % esc pressed
            practicePassed=2;
            closescript = 1;
            ListenChar(0);
            break;
        else
            resp = 0; % if wrong response
      %      PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
      %      PsychPortAudio('Start', pahandle);
        end
    else
        resp = 0;
        respTime=0;
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