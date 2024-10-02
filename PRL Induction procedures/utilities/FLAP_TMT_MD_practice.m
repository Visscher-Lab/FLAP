 practiceblock=1;
    askcalib=0;
    stimx=round(TheCoords{practiceblock}(:,1)*wRect(3)); %pull out x cords
    stimy=round(TheCoords{practiceblock}(:,2)*wRect(4)); %pull out y cords
    TheCircMat=[stimx-Csize,stimy-Csize, stimx+Csize,stimy+Csize]'; %this is the array for the cricles
    for i=1:(length(stimx)-1) %this is the array for the lines
        TheLinesMat(1,i*2-1)=stimx(i);
        TheLinesMat(2,i*2-1)=stimy(i);
        TheLinesMat(1,i*2)=stimx(i+1);
        TheLinesMat(2,i*2)=stimy(i+1);
    end
    CircFill=ones(3,length(stimx))*CircleColorFill;
    trial=practiceblock;
    FLAPVariablesReset
    HideCursor(); %hides the cursor
    TrailsInstructionsPractice(practiceblock,w,BackColor,LetterColor ) %instruction screen for each block
    
    ShowCursor(); %Show the cursor
    buttons=0;
    contcoord=0;
    numrespCorr=0;
    resp=0;
        Screen('TextSize', w, textsize);
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
                x=round(x*wRect(3)/wRect(3))+xoff; % +xoff for ucr site
                y=round(y*wRect(4)/wRect(4))-yoff; % -yoff for ucr site
            end
            if sum(buttons)~=0
                askcalib=1;
            end
            
        elseif (eyetime2-trial_time)>=prefixationsquare+ifi*3 && askcalib==1 %&& keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0 %present stimulus
            
            if exist('stimstar')==0
                stim_start=GetSecs;
                stimstar=1;
                startblocktime(practiceblock)=GetSecs;
            end
            %Draw Target
            if ( (numrespCorr<length(stimx))&&   (startblocktime(practiceblock)  -GetSecs<Maxtimes(practiceblock) ) )  %loop through trial in each block
                Screen('FillRect',w,BackColor);
                %draw lines
                if numrespCorr>=2
                    Screen('DrawLines',w,TheLinesMat(:,1:2*(numrespCorr-1)) ,2, LineColor)
                end
                %draw circles
                Screen('FillOval',w,CircFill,TheCircMat); %fills circles to cover lines in the middle
         %       Screen('FrameOval',w,CircleColorOut,TheCircMat ); %draws circles
                                        Screen('FrameOval',w,CircleColorOut,TheCircMat, 5, 5 ); %draws circles

                for i=1:length(stimx)  %draws text
                    if practiceblock==1
                        Screen('DrawText', w, num2str(i), stimx(i)-textsize/2, stimy(i)-textsize/2, LetterColor);
                    else
%                         if mod(i,2)
%                             Screen('DrawText', w, num2str(round(i/2)), stimx(i)-textsize/2, stimy(i)-textsize/2, LetterColor);
%                         else
%                             Screen('DrawText', w , Letters(round(i/2)), stimx(i)-textsize/2, stimy(i)-textsize/2, LetterColor);
%                         end
                    end
                end
                
                if  sum(buttons)~=0 && resp(numresp+1)==0
                    contcoord=contcoord+1;
                    zxx(contcoord)=x;
                    zyy(contcoord)=y;
                    
                    numresp=numresp+1; %increment the number of response counter
                    StartTime(numresp,practiceblock)=GetSecs;
                    
                    x
                    y
                    if (  (x>(TheCircMat(1,numresp)-RespTol)) && (y>(TheCircMat(2,numresp)-RespTol)) && (x<(TheCircMat(3,numresp)+RespTol)) && (y< (TheCircMat(4,numresp )+RespTol)) )
                        RespTime(numresp,practiceblock)=GetSecs-StartTime(numresp,practiceblock);
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
            if ScotomaPresent==1
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
        end
        if EyeTracker == 1
            if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                Screen('FillRect', w, white);
            end
        end
        [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
        
        VBL_Timestamp=[VBL_Timestamp eyetime2];
        
        if EyeTracker==1
            
            if site<3
                GetEyeTrackerData
            elseif site ==3
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
        end
        if sum(buttons)>1 && (eyetime2-StartTime(numresp,practiceblock))>2
            [origx,origy,buttons] = GetMouse(); % In while-loop, rapidly and continuously check if mouse button being pressed.
            x=origx-xoff;
            y = origy-yoff;
        elseif sum(buttons)>1 && (eyetime2-StartTime(numresp,practiceblock))<=2
            
        elseif sum(buttons)==0
            [origx,origy,buttons] = GetMouse(); % In while-loop, rapidly and continuously check if mouse button being pressed.
            x=origx-xoff;
            y = origy-yoff;
        end
        if numrespCorr==length(stimx)
            stim_stop=GetSecs;
            eyechecked=10^4;
        end
    end
    
    Screen('Flip',w);
    WaitSecs(0.5)
    
    time_stim(kk) = stim_stop - stim_start;
    total_trials(kk)=practiceblock;
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
    
    vbltimestamp(practiceblock).ix=[VBL_Timestamp];
    
    
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
    kk=kk+1;
        save(baseName)

    clear PKnew2
%     if closescript==1
%         break
%     end