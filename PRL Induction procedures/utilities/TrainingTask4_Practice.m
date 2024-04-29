%% Training Type 4 - CI blocks practice

Jitpracticearray=[0 1 2 3 4 5 6 7 8 9]; %  stimulus ori practice
stimulusdurationpracticearray=[0.7 0.7 0.5 0.5 0.3 0.3 0.2 0.2 0.2 0.2]; % stimulus duration practice
targethighercontrast=[0 0 0 0 0 0 0 0 0 0]; % target contrast
cuecontrast = [0.51 1 0.51 1 0.51 1 0.51 1 0.51 1]*255; %low/high contrast circular cue
Tscat=0;
practicetrialnum=length(targethighercontrast); %number of trials fro the practice block
Jitter = [1:0.0167:2.3]; %flickering duration for task type 3 and 4
holdtrial = [0 1 1 0 1 0 1 1 0 1];
trialTimeout=8;
gapfeedback= 0.3;
feedbackduration=1;

tracktrialnumber = [];
for practicetrial=1:length(practicetrialnum)
    presentfeedback = 0;
    af = 0;
    Orijit=Jitpracticearray(practicetrial);
    ContCirc= cuecontrast(practicetrial);
    FlickerTime=Jitter(randi(length(Jitter)));
    actualtrialtimeout=realtrialTimeout;
    trialTimeout=realtrialTimeout+5;
            theans(practicetrial)=randi(2);
            CIstimuliModIItest % add the offset/polarity repulsion
tracktrialnumber = [tracktrialnumber; practicetrial];
        if trainingType == 4 
            if practicetrial==1 || holdtrial(practicetrial) == 0 || randomlocationflag == 1
                ecc_r=(r_lim*pix_deg).*rand(1,1);
                ecc_t=2*pi*rand(1,1);
                cs= [cos(ecc_t), sin(ecc_t)];
                xxyy=[ecc_r ecc_r].*cs;
                ecc_x=xxyy(1);
                ecc_y=xxyy(2);
                eccentricity_X(practicetrial)=ecc_x;
                eccentricity_Y(practicetrial)=ecc_y;
                theeccentricity_X=ecc_x;
                theeccentricity_Y=ecc_y;
                %   xlimit=[-8:0.5:8]*pix_deg;
                %  ylimit=xlimit;
                %   theeccentricity_X=xlimit(randi(length(xlimit)));
                %  theeccentricity_Y=ylimit(randi(length(xlimit)));
            elseif randomlocationflag == 0
                eccentricity_X(practicetrial) = eccentricity_X(tracktrialnumber(end - 1));
                eccentricity_Y(practicetrial) = eccentricity_Y(tracktrialnumber(end - 1));
            end
        end

        
        if practicetrial == 1
            InstructionTrainingTask4_Practice
            randomlocationflag = 0;
        end
        %  destination rectangle for the target stimulus
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];

        %  destination rectangle for the fixation dot
        imageRect_offs_dot=[imageRectDot(1)+theeccentricity_X, imageRectDot(2)+theeccentricity_Y,...
            imageRectDot(3)+theeccentricity_X, imageRectDot(4)+theeccentricity_Y];


        %% initializing response box (if needed)

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

            % Configure digital input system for monitoring button box
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
        %% Initialization/reset of several trial-based variables
        FLAPVariablesReset % reset some variables used in each trial
        if practicetrial==1
            startExp=GetSecs; %time at the beginning of the session
            Datapixx('RegWrRd');
            blocktime=Datapixx('GetTime');
        end
        
        if practicetrial>1
            if mixtr(practicetrial, end) ~= mixtr(practicetrial-1, end) %|| mixtr(trial, end) ~= mixtr(end,end)+1 %mixtr(trial, end) == mixtr(end, end)-1
                Datapixx('RegWrRd');
                blocktime=Datapixx('GetTime');
            end
        end
        while eyechecked<1
            if datapixxtime==1
                Datapixx('RegWrRd');
                eyetime2=Datapixx('GetTime');
            end
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            if trainingType<3
                fixationscriptW % visual aids on screen
            end
            fixating=1500;

            if trainingType>2 && practicetrial>1 %if it's training 3 or 4 trial, we evaluate whether it's a cue trial
                %    if mixtr(trial,2)~=mixtr(trial-1,2) || mixtr(trial,2)==2 && mixtr(trial,1)~=mixtr(trial-1,1) % ||  trial==1

                if mixtr(practicetrial,4)~=mixtr(practicetrial-1,4)
                    if mixtr(practicetrial,2)==1 %if it's endogenous cue
                        %calculations for arrow pointing to the next location (endo cue)
                        nexcoordx=(imageRect_offs(1)+imageRect_offs(3))/2;
                        nexcoordy=(imageRect_offs(2)+imageRect_offs(4))/2;
                        previouscoordx=(rectimage{kk-1}(1)+rectimage{kk-1}(3))/2;
                        previouscoordy=(rectimage{kk-1}(2)+rectimage{kk-1}(4))/2;
                        delta=[previouscoordx-nexcoordx previouscoordy-nexcoordy];
                        oriArrow(practicetrial)=atan2d(delta(2), delta(1));
                        oriArrow(practicetrial)=oriArrow(practicetrial)-90;
                    elseif mixtr(practicetrial,2)==2 %if it's exogenous cue (circle flashing to the next location)
                    end
                end
                currentExoEndoCueDuration=ExoEndoCueDuration(mixtr(practicetrial,2));
            else
                currentExoEndoCueDuration=ExoEndoCueDuration(1);
            end
            %% here is where the first time-based trial loop starts (until first forced fixation is satisfied)
            if (eyetime2-trial_time)>=ifi*2 && (eyetime2-trial_time)<ifi*2+preCueISI && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                % pre-event empty space, allows for some cleaning
                if trainingType==1 || trainingType==2 % no flicker type of training trial
                    counterflicker=-10000;
                end

            elseif (eyetime2-trial_time)>=ifi*2+preCueISI && (eyetime2-trial_time)<+ifi*2+preCueISI+currentExoEndoCueDuration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                if exist('startrial') == 0
                    if datapixxtime==1
                        trialstart(practicetrial)=Datapixx('GetTime');
                        trialstart_frame(practicetrial)=eyetime2;
                    else
                        trialstart(practicetrial)=GetSecs;
                        trialstart_frame(practicetrial)=eyetime2;
                        %   startfix(trial)=eyetime2;
                    end
                    startrial=1;
                end
                % HERE I present the cue for training types 3 and 4 or skip
                % this interval for training types 1 and 2

                if trainingType>2 && practicetrial>1
                    %   if mixtr(trial,2)~=mixtr(trial-1,2) || mixtr(trial,3)==2 && mixtr(trial,1)~=mixtr(trial-1,1) % ||  trial==1
                    if mixtr(practicetrial,4)~=mixtr(practicetrial-1,4)
                        if mixtr(practicetrial,2)==1 %endogenous cue
                            newrectimage{kk}=[rectimage{kk-1}(1)-2*pix_deg rectimage{kk-1}(2)-2*pix_deg rectimage{kk-1}(3)+2*pix_deg rectimage{kk-1}(4)+2*pix_deg ];
                            Screen('DrawTexture', w, theArrow, [], rectimage{kk-1}, oriArrow(practicetrial),[], 1);
                            realcuecontrast=cuecontrast*0.1;
                            isendo=1;
                            contrastcounter=0;
                        elseif mixtr(practicetrial,2)==2 %exogenous cue
                            Screen('FrameOval', w,scotoma_color, imageRect_offs, 22, 22);
                            isendo=0;
                        end
                    else
                        isendo=0;
                    end
                elseif trainingType>2 && practicetrial==1
                    isendo=0;
                end
            elseif (eyetime2-trial_time)>=ifi*2+preCueISI+currentExoEndoCueDuration+postCueISI && fixating>400 && stopchecking>1 && flickerdone<1 && counterannulus<=AnnulusTime/ifi && counterflicker<FlickerTime/ifi  && (eyetime2-pretrial_time)<=trialTimeout
                % here I need to reset the trial time in order to preserve
                % timing for the next events (first fixed fixation event)
                % HERE interval between cue disappearance and beginning of
                % next stream of flickering stimuli

                %keyCode(escapeKey) ==0
                if trainingType~=3 % no more dots!
                    Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                end
                if skipforcedfixation==1 % skip the forced fixation
                    counterannulus=(AnnulusTime/ifi)+1;
                    skipcounterannulus=1000;
                else %force fixation for training types 1 and 2
                    if trainingType<3
                        [counterannulus framecounter ]=  IsFixatingSquareNew2(wRect,newsamplex,newsampley,framecounter,counterannulus,fixwindowPix);
                    elseif trainingType>2
                        [counterannulus framecounter ]=  IsFixatingPRL3(newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,EyetrackerType,theeccentricity_X,theeccentricity_Y,framecounter,counterannulus);
                    end
                    if trainingType~=3 % no more dots!
                        %                        Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                    elseif trainingType==3 %force fixation for training types 3
                        if exist('isendo') == 0
                            isendo=0;
                        end
                        if isendo==1 % if is endo trial we slowly increase the visibility of the cue
                            if mod(round(eyetime2-trial_time),100)
                                contrastcounter=contrastcounter+1;
                                realcuecontrast=(cuecontrast*0.45)+(contrastcounter/2000);
                            end
                            Screen('FillOval', w, realcuecontrast, imageRect_offs_dot);
                        elseif isendo==0
                            realcuecontrast=cuecontrast;
                            Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], realcuecontrast);
                        end
                    end
                    if counterannulus==round(AnnulusTime/ifi) % when I have enough frame to satisfy the fixation requirements
                        if datapixxtime==1
                            Datapixx('RegWrRd');
                            newtrialtime=Datapixx('GetTime');
                        else
                            newtrialtime=GetSecs;
                        end
                        skipcounterannulus=1000;
                    end
                end
                if responsebox==0
                    if  keyCode(escapeKey) ~=0   % HERE I exit the script if I press ESC
                        thekeys = find(keyCode);
                        closescript=1;
                        break;
                    end
                end
            end
            %% here is where the second time-based trial loop starts
            if (eyetime2-newtrialtime)>=forcedfixationISI && fixating>400 && stopchecking>1 && skipcounterannulus>10 && counterflicker<=FlickerTime/ifi && flickerdone<1 && (eyetime2-pretrial_time)<=trialTimeout
                % HERE starts the flicker for training types 3 and 4, if
                % training type is 1 or 2, this is skipped

                if exist('flickerstar') == 0 % start flicker timer
                    flicker_time_start(practicetrial)=eyetime2; % beginning of the overall flickering period
                    flickerstar=1;
                    flickswitch=0;
                    flick=1;
                end
                if datapixxtime==1
                    Datapixx('RegWrRd');
                    tempFlickTime=Datapixx('GetTime');
                    flicker_time=tempFlickTime-flicker_time_start(practicetrial);     % timer for the flicker decision
                else
                    flicker_time=GetSecs-flicker_time_start(practicetrial);     % timer for the flicker decision
                end
                if flicker_time>flickswitch % time to flicker?
                    flickswitch= flickswitch+flickeringrate;
                    flick=3-flick; % flicker/non flicker
                end
                if trainingType>2 && demo==2  % Force flicker here (training type 3 and 4)
                    if EyeTracker==1
                        [countgt framecont countblank blankcounter counterflicker turnFlickerOn]=  ForcedFixationFlicker3(w,countgt,countblank, framecont, newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,theeccentricity_X,theeccentricity_Y,blankcounter,framesbeforeflicker,blankframeallowed, EyeData, counterflicker,eyetime2,EyeCode,turnFlickerOn);
                    else
                        %  [countgt framecont countblank blankcounter counterflicker turnFlickerOn eyerunner]=  ForcedFixationFlicker3mouse(w,countgt,countblank, framecont, newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,theeccentricity_X,theeccentricity_Y,blankcounter,framesbeforeflicker,blankframeallowed, counterflicker,eyetime2,turnFlickerOn);
                        ForcedFixationFlicker3mouse
                    end
                end

                % from ForcedFixationFlicker3, should I show the flicker or not?
                if turnFlickerOn(end)==1 %flickering cue
                    if flick==2
                        if trainingType==3
                            Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                        elseif trainingType==4
                            Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                        end
                    end
                elseif turnFlickerOn(end)==0 %non-flickering cue
                    if trainingType==3
                        Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                    elseif trainingType==4
                        Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                    end
                end
                if exist('circlestar')==0
                    if datapixxtime==1
                        Datapixx('RegWrRd');
                        circle_start=Datapixx('GetTime');
                    else
                        circle_start = GetSecs;
                    end
                    circlestar=1;
                end

                if datapixxtime==1
                    Datapixx('RegWrRd');
                    cue_last=Datapixx('GetTime');
                else
                    cue_last=GetSecs;
                end

                if trainingType>2 && counterflicker>=round(FlickerTime/ifi) || trainingType<3 || demo==1
                    if datapixxtime==0
                        newtrialtime=GetSecs; % when fixation constrains are satisfied, I reset the timer to move to the next series of events
                    else
                        Datapixx('RegWrRd');
                        newtrialtime=Datapixx('GetTime');% when fixation constrains are satisfied, I reset the timer to move to the next series of events
                    end
                    flickerdone=10;
                    flicker_time_stop(practicetrial)=eyetime2; % end of the overall flickering period
                end
            elseif (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && stopchecking>1 %present pre-stimulus and stimulus
                % HERE I PRESENT THE TARGET

                if trainingType==3
                    eyechecked=10^4; % if it's training type 3, we exit the trial, good job
                    if skipmasking==0
                        if trainingType~=3
                            assignedPRLpatch
                        end
                    end
                elseif trainingType==1 || (trainingType==4 && mixtr(practicetrial,3)==1)
                    Screen('DrawTexture', w, texture(practicetrial), [], imageRect_offs, ori,[], contr );
                    if skipmasking==0
                        assignedPRLpatch
                    end
                elseif trainingType==2 || (trainingType==4 && mixtr(practicetrial,3)==2)
                    if exist('imageRect_offsCI')==0    % destination rectangle for CI stimuli
%                         if trainingType == 2
                   %         imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(trial),...
                   %             imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(trial)];
                            
                            imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_Y,...
                                imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_Y];  
%                         elseif trainingType == 4
%                             imageRect_offsCI =[imageRect_offs(1)+eccentricity_XCI'+eccentricity_X(trial), imageRect_offs(2)+eccentricity_YCI'+eccentricity_Y(trial),...
%                                 imageRect_offs(3)+eccentricity_XCI'+eccentricity_X(trial), imageRect_offs(4)+eccentricity_YCI'+eccentricity_Y(trial)];
%                         end
                        imageRect_offsCI2=imageRect_offsCI;
                        %   imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                        %          imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)+pix_deg*2 (xs/coeffCI*pix_deg)]+pix_deg*2 ], wRect);
                        %          imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)+pix_deg*2 (xs/coeffCI*pix_deg_vert)]+pix_deg_vert*2 ], wRect);
                        imageRectMask = CenterRect([0, 0,  CIstimulussize+maskthickness CIstimulussize+maskthickness ], wRect);
                        %    imageRectMask = CenterRect([0, 0, [ (stimulusSize*2*pix_deg) (stimulusSize*2*pix_deg_vert)] ], wRect);
                   %     imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
                  %          imageRectMask(3)+eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];
                        
                         imageRect_offsCImask=[imageRectMask(1)+theeccentricity_X, imageRectMask(2)+theeccentricity_Y,...
                            imageRectMask(3)+theeccentricity_X, imageRectMask(4)+theeccentricity_Y];
                        
                    end
                    %here I draw the target contour
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
                    imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
                    if demo==1
                        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], 0.7 );
                    end
                    % here I draw the circle within which I show the contour target
                    Screen('FrameOval', w,[gray], imageRect_offsCImask, maskthickness/2, maskthickness/2);
                    %                    Screen('FrameOval', w,[gray*1.5], imageRect_offsCImask, 1, 1);
                    if trainingType==2
                        fixationscriptW
                    end
                    if skipmasking==0
                        assignedPRLpatch
                    end
                    imagearray{practicetrial}=Screen('GetImage', w);

                end

                if exist('stimstar') == 0
                    stim_startT(practicetrial)=eyetime2;
                    stim_start=eyetime2;
                    stim_startPTB = GetSecs;
                    if EyetrackerType ==2
                        %set a marker to get the exact time the screen flips
                        Datapixx('SetMarker');
                        Datapixx('RegWrVideoSync');
                        %collect marker data
                        Datapixx('RegWrRd');
                        Pixxstruct(practicetrial).TargetOnset = Datapixx('GetMarker');
                        Pixxstruct(practicetrial).TargetOnset2 = Datapixx('GetTime');
                    end

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

                % start counting timeout for the non-fixed time training
                % types 3 and 4
                if trainingType>2
                    if exist('checktrialstart')==0
                        trialTimeout=actualtrialtimeout+(stim_start-pretrial_time);
                        checktrialstart=1;
                    end
                end

            elseif (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout  && stopchecking>1 %present pre-stimulus and stimulus

                if responsebox==0
                    if keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0
                        thekeys = find(keyCode);
                        if length(thekeys)>1
                            thekeys=thekeys(1);
                        end
                        thetimes=keyCode(thekeys);
                        [secs  indfirst]=min(thetimes);

                        if datapixxtime==0
                            [secs  indfirst]=min(thetimes);
                            respTimeT(practicetrial)=secs;
                            respTime=GetSecs;
                        else
                            respTimeT(practicetrial)=eyetime2;
                            respTime=eyetime2;
                        end
                    end
                    eyechecked=10^4; % exit loop for this trial
                elseif responsebox==1
                    if (buttonLogStatus.newLogFrames > 0)
                        actualsecs{practicetrial}= secs;
                        if length(secs)>1
                            if sum(thekeys(1)==RespType)>0
                                thekeys=thekeys(1);
                                secs=secs(1);
                            elseif sum(thekeys(2)==RespType)>0
                                thekeys=thekeys(2);
                                secs=secs(2);
                            end
                        end
                        respTime(practicetrial)=secs;
                        eyechecked=10^4;
                    end
                end
            elseif (eyetime2-newtrialtime)>=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && stopchecking>1 %present pre-stimulus and stimulus
                if responsebox==0
                    if keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0
                        thekeys = find(keyCode);
                        if length(thekeys)>1
                            thekeys=thekeys(1);
                        end
                        thetimes=keyCode(thekeys);
                        [secs  indfirst]=min(thetimes);

                        if datapixxtime==0
                            [secs  indfirst]=min(thetimes);
                            respTimeT(practicetrial)=secs;
                            respTime=GetSecs;
                        else
                            respTimeT(practicetrial)=eyetime2;
                            respTime=eyetime2;
                        end
                    end
                    eyechecked=10^4; % exit loop for this trial
                elseif responsebox==1
                    if (buttonLogStatus.newLogFrames > 0)
                        %em modified on 12/4/2023, added lines 976-982, if length(sec)>1 through eyechecked 10^4; makes sure that the correct value is taken for button press more than one input is received
                        if length(secs)>1
                            if sum(thekeys(1)==RespType)>0
                                thekeys=thekeys(1);
                                secs=secs(1);
                            elseif sum(thekeys(2)==RespType)>0
                                thekeys=thekeys(2);
                                secs=secs(2);
                            end
                        end
                        eyechecked=10^4;
                        respTime(practicetrial)=secs; %em moved to after if statement 12/4/2023
                    end
                end
            elseif (eyetime2-pretrial_time)>=trialTimeout
                stim_stop=eyetime2;
                trialTimedout(practicetrial)=1;
                %    [secs  indfirst]=min(thetimes);
                if responsebox==1
                    Datapixx('StopDinLog');
                end
                eyechecked=10^4; % exit loop for this trial
            end

            %% here I draw the scotoma, elements below are called every frame
            eyefixation5
            if ScotomaPresent == 1 % do we want the scotoma? (default is yes)
                Screen('FillOval', w, scotoma_color, scotoma);
                if trainingType == 3
                    visiblePRLring
                end
                if trainingType == 4
                    visiblePRLring %T4
                end
            else % else we get a fixation cross and no scotoma
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
            end
            if demo==2
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
            dd=49;
            if EyeTracker==1
                GetEyeTrackerDataNew
                GetFixationDecision
                if EyeData(end,1)<8000 && stopchecking<0
                    if datapixxtime==1
                        Datapixx('RegWrRd');
                        trial_time = Datapixx('GetTime');
                    else
                        trial_time = GetSecs; %start timer if we have eye info
                    end
                    stopchecking=10;
                end
                if EyeData(end,1)>8000 && stopchecking<0 && (eyetime2-pretrial_time)>calibrationtolerance
                    trialTimeout=100000;
                    caliblock=1;
                    if responsebox==0
                        DrawFormattedText(w, 'Need calibration: press "c" to continue the study, press "m" to recalibrate, press "esc" to exit ', 'center', 'center', white);
                    else
                        DrawFormattedText(w, 'Need calibration: press "red" to continue the study, press "yellow" to recalibrate, press "green" to exit ', 'center', 'center', white);
                    end
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
                        if (buttonLogStatus.newLogFrames > 0)
                            if  thekeys==RespType(3)
                                DrawFormattedText(w, 'Bye', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                %  KbQueueWait;
                                closescript = 1;
                                eyechecked=10^4;
                            elseif thekeys==RespType(1)
                                DrawFormattedText(w, 'continue', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                %  KbQueueWait;
                                % trial=trial-1;
                                eyechecked=10^4;
                            elseif thekeys==RespType(2)
                                DrawFormattedText(w, 'Calibration!', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                TPxReCalibrationTestingMM(1,screenNumber, baseName)
                                %    KbQueueWait;
                                eyechecked=10^4;
                            end
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
                    [thekeys secs] = Datapixx('ReadDinLog');
                end
                %         [keyIsDown, keyCode] = KbQueueCheck;
            else % AYS: UCR and UAB?
                [keyIsDown, keyCode] = KbQueueCheck;
            end
            
        end
        %% response processing
        if trialTimedout(practicetrial)== 0 && trainingType~=3
            foo=(RespType==thekeys(1)); %em added (1) 11/15/2023

            % staircase update
            if trainingType~=3
                staircounter(mixtr(practicetrial,1),mixtr(practicetrial,3))=staircounter(mixtr(practicetrial,1),mixtr(practicetrial,3))+1;
            end
            if trainingType==1 || (trainingType == 4 && mixtr(practicetrial,3)==1)
                Threshlist(mixtr(practicetrial,1),mixtr(practicetrial,3),staircounter(mixtr(practicetrial,1),mixtr(practicetrial,3)))=contr;
            end
            if trainingType==2 || (trainingType == 4 && mixtr(practicetrial,3)==2)
                Threshlist(mixtr(practicetrial,1),mixtr(practicetrial,3),staircounter(mixtr(practicetrial,1),mixtr(practicetrial,3)))=Orijit;
            end
            if foo(theans(practicetrial)) % if correct response
                resp = 1;
                PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                PsychPortAudio('Start', pahandle);
                if trainingType~=3
                    corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3))=corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3))+1;
                    if  corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3))==sc.down
                        isreversals(mixtr(practicetrial,1),mixtr(practicetrial,3))= 1; %isreversals(mixtr(trial,1),mixtr(trial,3)) + 1;
                    end
                    if corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3))==sc.down  % && reversals(mixtr(trial,1),mixtr(trial,3)) >= 3
                        if isreversals(mixtr(practicetrial,1),mixtr(practicetrial,3))==1
                            reversals(mixtr(practicetrial,1),mixtr(practicetrial,3))=reversals(mixtr(practicetrial,1),mixtr(practicetrial,3))+1;
                            isreversals(mixtr(practicetrial,1),mixtr(practicetrial,3))=0;
                        end
                        thestep=min(reversals(mixtr(practicetrial,1),mixtr(practicetrial,3))+1,length(stepsizes));
                    else
                        if trainingType == 2
                            thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=min(thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)),length(JitList));
                        elseif trainingType == 1
                            thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=min( thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)),length(Contlist));
                        end
                        % the staircase begins as a 1 up 1 down until 3 reversals
                        %                         % have passed
                        %                                                 if reversals(mixtr(trial,1),mixtr(trial,3)) < 3
                        %                                                     if isreversals(mixtr(trial,1),mixtr(trial,3))==1
                        %                                                         reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                        %                                                         isreversals(mixtr(trial,1),mixtr(trial,3))=0;
                        %                                                     end
                        %                                                     thestep=min(reversals(mixtr(trial,1),mixtr(trial,3)),length(stepsizes));
                        %                                                 end
                    end
                end
                if trainingType==1 || (trainingType == 4 && mixtr(practicetrial,3)==1)
                    if corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3))==sc.down % if we have enough consecutive correct responses to
                        %update stimulus intensity
                        if contr<SFthreshmin && currentsf<length(sflist)
                            currentsf=min(currentsf+1,length(sflist));
                            foo=find(Contlist>=SFthreshmin);
                            thresh(:,:)=foo(end)-SFadjust;
                            corrcounter(:,:)=0;
                            thestep=3;
                        else
                            thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)) +stepsizes(thestep);
                            thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=min( thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)),length(Contlist));
                        end
                        corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3))=0;
                    else
                        if corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3)) < sc.down %maintain stimulus intensity
                            if contr<SFthreshmin && currentsf<length(sflist)
                                currentsf=min(currentsf+1,length(sflist));
                                foo=find(Contlist>=SFthreshmin);
                                thresh(:,:)=foo(end)-SFadjust;
                                corrcounter(:,:)=0;
                                thestep=3;
                            else
                                thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=thresh(mixtr(practicetrial,1),mixtr(practicetrial,3));
                                thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=min( thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)),length(Contlist));
                            end
                        end
                    end
                end
                if trainingType==2 || (trainingType == 4 && mixtr(practicetrial,3)==2)
                    if corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3))>=sc.down
                        thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)) +stepsizes(thestep);
                        thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=min( thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)),length(JitList));
                        corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3))=0;
                    else
                        if corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3)) < sc.down
                            thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=thresh(mixtr(practicetrial,1),mixtr(practicetrial,3));
                            thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=min( thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)),length(JitList));
                        end
                    end
                end
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                ListenChar(0);
                break;
            else
                resp = 0; % if wrong response
                PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                PsychPortAudio('Start', pahandle);
                if trainingType~=3
                    if  corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3))>=sc.down && reversals(mixtr(practicetrial,1),mixtr(practicetrial,3)) >= 3
                        isreversals(mixtr(practicetrial,1),mixtr(practicetrial,3))=1;
                        reversals(mixtr(practicetrial,1),mixtr(practicetrial,3))=reversals(mixtr(practicetrial,1),mixtr(practicetrial,3))+1;
                        %                     else
                        %                         if reversals(mixtr(trial,1),mixtr(trial,3)) < 3
                        %                             isreversals(mixtr(trial,1),mixtr(trial,3))=1;
                        %                             reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                        %                         end
                    end
                    corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3))=0;
                    thestep=min(reversals(mixtr(practicetrial,1),mixtr(practicetrial,3))+1,length(stepsizes));
                end
                if trainingType==1 || trainingType == 4 && mixtr(practicetrial,3)==1
                    if contr>SFthreshmax && currentsf>1
                        currentsf=max(currentsf-1,1);
                        thresh(:,:)=StartCont;
                        corrcounter(:,:)=0;
                        thestep=3;
                    else
                        thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)) -stepsizes(thestep);
                        thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=max(thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)),1);
                    end
                end
                if trainingType==2 || trainingType == 4 && mixtr(practicetrial,3)==2
                    thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)) -stepsizes(thestep);
                    thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=max(thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)),1);
                end
            end
        elseif trainingType==3 % no response to be recorded here
            if closescript==1
                %         PsychPortAudio('Start', pahandle2);
            elseif trialTimedout(practicetrial)==1
                PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                PsychPortAudio('Start', pahandle);
            else
                PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                PsychPortAudio('Start', pahandle);
            end
        else % if trial has timed out,
            % staircase update
            if trainingType~=3
                staircounter(mixtr(practicetrial,1),mixtr(practicetrial,3))=staircounter(mixtr(practicetrial,1),mixtr(practicetrial,3))+1;
            end
            if trainingType==1 || (trainingType == 4 && mixtr(practicetrial,3)==1)
                Threshlist(mixtr(practicetrial,1),mixtr(practicetrial,3),staircounter(mixtr(practicetrial,1),mixtr(practicetrial,3)))=contr;
            end
            if trainingType==2 || (trainingType == 4 && mixtr(practicetrial,3)==2)
                Threshlist(mixtr(practicetrial,1),mixtr(practicetrial,3),staircounter(mixtr(practicetrial,1),mixtr(practicetrial,3)))=Orijit;
            end
            resp = 0;
            respTime(practicetrial)=0;
            PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
            PsychPortAudio('Start', pahandle);
            if trainingType~=3
                if  corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3))==sc.down && reversals(mixtr(practicetrial,1),mixtr(practicetrial,3)) >= 3
                    isreversals(mixtr(practicetrial,1),mixtr(practicetrial,3))=1;
                    reversals(mixtr(practicetrial,1),mixtr(practicetrial,3))=reversals(mixtr(practicetrial,1),mixtr(practicetrial,3))+1;
                else
                    if reversals(mixtr(practicetrial,1),mixtr(practicetrial,3)) < 3
                        isreversals(mixtr(practicetrial,1),mixtr(practicetrial,3))=1;
                        reversals(mixtr(practicetrial,1),mixtr(practicetrial,3))=reversals(mixtr(practicetrial,1),mixtr(practicetrial,3))+1;
                    end
                end
                corrcounter(mixtr(practicetrial,1),mixtr(practicetrial,3))=0;
                thestep=min(reversals(mixtr(practicetrial,1),mixtr(practicetrial,3))+1,length(stepsizes));
            end
            if trainingType==1 || trainingType == 4 && mixtr(practicetrial,3)==1
                if contr>SFthreshmax && currentsf>1
                    currentsf=max(currentsf-1,1);
                    thresh(:,:)=StartCont+SFadjust;
                    corrcounter(:,:)=0;
                    thestep=3;
                else
                    thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)) -stepsizes(thestep);
                    thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=max(thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)),1);
                end
            end
            if trainingType==2 || trainingType == 4 && mixtr(practicetrial,3)==2
                thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)) -stepsizes(thestep);
                thresh(mixtr(practicetrial,1),mixtr(practicetrial,3))=max(thresh(mixtr(practicetrial,1),mixtr(practicetrial,3)),1);
            end
        end
        if trainingType~=3 % if the trial didn't time out, save some variables
            if trialTimedout(practicetrial)==0
                stim_stop=secs;
                if length(thekeys)>1
                    cheis(kk)=thekeys(1);  % this is giving an error Dec 4- kmv
                else
                    cheis(kk)=thekeys;  % this is giving an error Dec 4- kmv
                end
            end
           if  exist('stim_start')
               time_stim(kk) = stim_stop - stim_start;
           end
           rispo(kk)=resp;
            %   respTimes(trial)=respTime;
             if  exist('stim_start')
            cueendToResp(kk)=stim_stop-cue_last;
            cuebeginningToResp(kk)=stim_stop-circle_start;
             end
        end
        if trainingType > 2 % if it's a
            %   training type with flicker
            %   fixDuration(trial)=flicker_time_start-trial_time;
            if flickerdone>1
                flickertimetrial(practicetrial)=FlickerTime; %  nominal duration of flicker
                movieDuration(practicetrial)=flicker_time_stop(practicetrial)-flicker_time_start(practicetrial); % actual duration of flicker
                Timeperformance(practicetrial)=movieDuration(practicetrial)-(flickertimetrial(practicetrial)*3); % estimated difference between actual and expected flicker duration
                unadjustedTimeperformance(practicetrial)=movieDuration(practicetrial)-flickertimetrial(practicetrial);
            end
        end
        if trainingType==2
            trackthresh(shapesoftheDay(mixtr,1))=thresh(mixtr,1);
            threshperday(expDay,:)=trackthresh;
        end
        if (mod(practicetrial,150))==1 && practicetrial>1
            save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
        end
        if (mod(practicetrial,10))==1 && practicetrial>1 && trainingType==3
            updatecounter=updatecounter+1;
            %some adaptive measures for the TRL size that counts as 'fixation within the TRL'
            if mean(unadjustedTimeperformance(end-9:end))>8
                if mod(updatecounter,2)==0 && flickerpointerPre ~= 0 && flickerpointerPre ~= 1
                    %here we implement staircase on flicker time
                    flickerpointerPre=flickerpointerPre-1;
                    flickerpointerPost=flickerpointerPost+1;
                end
                sizepointer=sizepointer-1; % increase the size of the TRL region within which the target will be deemed as 'seen through the TRL'
            elseif mean(unadjustedTimeperformance(end-9:end))<5
                if mod(updatecounter,2)==0 && flickerpointerPost ~= 0 && flickerpointerPost ~= 1
                    %here we implement staircase on flicker time
                    flickerpointerPre=flickerpointerPre+1;
                    flickerpointerPost=flickerpointerPost-1;
                end
                if sizepointer~=length(sizeArray)
                    sizepointer=sizepointer+1; % decrease the size of the TRL region within which the target will be deemed as 'seen through the TRL'
                end
            end
            timeflickerallowed=persistentflickerArray(flickerpointerPre); % time before flicker starts
            flickerpersistallowed=persistentflickerArray(flickerpointerPost); % time away from flicker in which flicker persists
            coeffAdj=sizeArray(sizepointer);
        end


        if responsebox==1 && trialTimedout(practicetrial)==0 && trainingType ~= 3
            time_stim3(kk) = respTime(practicetrial) - stim_startBox2(practicetrial);
            time_stim2(kk) = respTime(practicetrial) - stim_startBox(practicetrial);
        else
            if trainingType ~= 3 && exist('stim_start')
                time_stim3(kk) = respTime(practicetrial) - stim_start;
            end
        end
        TRLsize(practicetrial)=coeffAdj;
        flickOne(practicetrial)=timeflickerallowed;
        flickTwo(practicetrial)=flickerpersistallowed;
        totale_trials(kk)=practicetrial;
        coordinate(practicetrial).x=theeccentricity_X/pix_deg;
        coordinate(practicetrial).y=theeccentricity_Y/pix_deg;
        xxeye(practicetrial).ics=[xeye];
        yyeye(practicetrial).ipsi=[yeye];
        vbltimestamp(practicetrial).ix=[VBL_Timestamp];
        if exist('ssf')
            feat(kk)=ssf;
        end
        SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
        rectimage{kk}=imageRect_offs;
        if exist('endExp')
            totalduration=(endExp-startExp)/60;
        end
        %% record eyelink-related variables
        if EyeTracker==1
            EyeSummary.(TrialNum).EyeData = EyeData;
            clear EyeData
            EyeSummary.(TrialNum).EyeData(:,6) = EyeCode';
            clear EyeCode
            if exist('FixIndex')==0
                FixIndex=0;
            end
            EyeSummary.(TrialNum).FixationIndices = FixIndex;
            clear FixIndex
            EyeSummary.(TrialNum).TotalEvents = CheckCount;
            clear CheckCount
            EyeSummary.(TrialNum).TotalFixations = FixCount;
            clear FixCount
            EyeSummary.(TrialNum).TargetX = theeccentricity_X/pix_deg;
            EyeSummary.(TrialNum).TargetY = theeccentricity_Y/pix_deg;
            EyeSummary.(TrialNum).EventData = EvtInfo;
            clear EvtInfo
            EyeSummary.(TrialNum).ErrorData = ErrorData;
            clear ErrorData
            if exist('EndIndex')==0
                EndIndex=0;
            end
            EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
            clear EndIndex
            EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
            EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
            if exist('stim_start')
                EyeSummary.(TrialNum).TimeStamps.Fixation = stim_start;
            end
            if trainingType~=3
                EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;
            end
            clear ErrorInfo
        end
        if closescript==1
            break;
        end
        kk=kk+1;
        if shapecounter>11 && trainingType < 3
            if mod(checkcounter,10) == 0 && sum(Threshlist(mixtr(practicetrial,1),mixtr(practicetrial,3),staircounter(mixtr(practicetrial,1),mixtr(practicetrial,3))-10:staircounter(mixtr(practicetrial,1),mixtr(practicetrial,3))))==0
                DrawFormattedText(w, 'Wake up and call the experimenter', 'center', 'center', white);
                Screen('Flip', w);
                KbQueueWait;
            end
        end
        if trainingType==4
            if eyetime2-blocktime>blockdurationtolerance 
                moveon=mixtr(practicetrial,end);
                nextrials=find(mixtr(:,end) == moveon+1);
                if isempty(nextrials)
                    break
                else
                skiptrial=nextrials(1);
                countertrialskipped=countertrialskipped+1;
                oldtrial(countertrialskipped)=practicetrial;
                skipflag = 1;
                end
            end
        end
    end
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);

    ListenChar(0);
    Screen('Flip', w);

    %% shut down EyeTracker and screen functions
    if EyetrackerType==1
        Eyelink('StopRecording');
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    end

    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    KbQueueWait;

    ShowCursor;
    Screen('CloseAll');
    PsychPortAudio('Close', pahandle);

catch ME
    psychlasterror()
end