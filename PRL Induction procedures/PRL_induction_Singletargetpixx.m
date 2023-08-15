% PRL induction procedure with simulated scotoma, single target
% written by Marcello A. Maniglia 2017/2021

close all; clear; clc;
commandwindow
try
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    KbName('UnifyKeyNames');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    
    prompt={'Subject Number:'...
        'Day:', 'site (UCR = 1; UAB = 2; Vpixx = 3)', 'eye? left(1) or right(2)', 'eyetracker', 'calibration'};
    
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1', '3','2', '1', '1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    
    addpath([cd '/utilities']);
    
    SUBJECT = answer{1,:}; %Gets Subject Name
    expDay = str2num(answer{2,:});
    expdayeye = answer{2,:};
    site= str2num(answer{3,:});
    whicheye=str2num(answer{4,:}); % which eye to track (vpixx only)
    EyeTracker = str2num(answer{5,:}); %0=mouse, 1=eyetracker
    calibration=str2num(answer{6,:}); %
    scotomavpixx=0;
    datapixxtime=0;
    responsebox=0;
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data')
    end
    
    folder=cd;
    folder=fullfile(folder, '..\..\datafolder\');
    
    inductionType = 2; % 1 = assigned, 2 = annulus
    if inductionType ==1
        filename = 'Assigned';
    elseif inductionType == 2
        filename = 'Annulus';
    end
    
    if site==1
        baseName=[folder SUBJECT filename  '_' expDay num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename
    elseif site==2
        baseName=[folder SUBJECT filename  '_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    elseif site==3
        baseName=[folder SUBJECT '_PRL_induction_' filename 'Pixx_' num2str(expDay) num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '.mat'];
    end
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    theseed=sum(100*clock);
    rand('twister',theseed); %used to randomize the seed for the random number generator to ensure higher chances of different randomization across sessions
    
    trials=50;%500;
    
    defineSite
    
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
    
    
    
    
    %%
    CreateInductionStimuli
    
    
    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    end
    
    %%
    
    %% main loop
    HideCursor(0);
    ListenChar(2);
    counter = 0;
    
    WaitSecs(1);
    
    %     Screen('TextStyle', w, 1+2);
    Screen('FillRect', w, gray);
    colorfixation = white;
    
    RespType(1) = KbName('leftArrow');
    RespType(2) = KbName('rightArrow');
    
    %%
    
    DrawFormattedText(w, 'Report the overall orientation of the C stimuli \n \n left (left key) or right (right key) \n \n \n \n Press any key to start', 'center', 'center', white);
    Screen('Flip', w);
    KbWait;
    
    Screen('Flip', w);
    %possible orientations
    
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
    
    
    waittime=ifi*50; %ifi is flip interval of the screen
    
    
    scotoma_color=[200 200 200];
    
    
    
    angolo=pi/2;
    
    
    PRLx=[0 PRLecc 0 -PRLecc];
    PRLy=[-PRLecc 0 PRLecc 0 ];
    PRLxpix=PRLx*pix_deg;
    PRLypix=PRLy*pix_deg;
    
    fixwindow=2;
    fixTime=0.5;
    fixTime2=0.5;
    
    fixwindowPix=fixwindow*pix_deg;
    
    radius = scotomasize(1)/2; %radius of circular mask
    %    smallradius=(scotomasize(1)/2)+1.5*pix_deg;
    
    % smallradius=radius+pix_deg/2 %+1*pix_deg;
    
    [sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);
    
    
    if inductionType == 1 % 1 = assigned, 2 = annulus
        radiusPRL=(PRLsize/2)*pix_deg;
        circlePixels=sx.^2 + sy.^2 <= radiusPRL.^2;
    else
        
        
        smallradius=radiusPRL; %+pix_deg/2 %+1*pix_deg;
        radiusPRL=radiusPRL+3*pix_deg;
        
        circlePixels=sx.^2 + sy.^2 <= radiusPRL.^2;
        circlePixels2=sx.^2 + sy.^2 <= smallradius.^2;
        
        d=(circlePixels2==1);
        newfig=circlePixels;
        newfig(d==1)=0;
        circlePixels=newfig; %Marcello - what kind of shape is being created here? % this is the circular PRL region within which the target would be visible
        %later on in the code I 'move' it around with each PRL location and when it is aligned
        %with the target location,it shows the target.
        
    end
    
    counterleft=0;
    counterright=0;
    counteremojisize=0;
    
    
    
    for trial=1:trials
        FLAPVariablesReset
        
        TrialNum = strcat('Trial',num2str(trial));
        
        
        
        distances=round(distancedeg*pix_deg);
        jitterAngle= [-35 35];
        jitterDistanceDeg= [-9 1.5];
        jitterDistance=jitterDistanceDeg*pix_deg;
        
        
        
        angle1= randi(360); %anglearray(randi(length(anglearray)))
        angle2= angle1+120+(jitterAngle(2)-jitterAngle(1).*rand(1,1)+jitterAngle(1));
        angle3= angle1-120+(jitterAngle(2)-jitterAngle(1).*rand(1,1)+jitterAngle(1));
        
        
        theta = [angle1  angle2  angle3 ];
        theta= deg2rad(theta);
        distanceArray= [distances+(jitterDistance(2)-jitterDistance(1).*rand(1,1)+jitterDistance(1)) distances+(jitterDistance(2)-jitterDistance(1).*rand(1,1)+jitterDistance(1)) distances+(jitterDistance(2)-jitterDistance(1).*rand(1,1)+jitterDistance(1))];
        rho = [distanceArray];
        
        [elementcoordx,elementcoordy] = pol2cart(theta,rho);
        
        
        clear fixind
        clear EyeData
        clear FixIndex
        xeye=[];
        yeye=[];
        pupils=[];
        VBL_Timestamp=[];
        stimonset=[ ];
        fliptime=[ ];
        mss=[ ];
        %    tracktime=[];
        FixCount=0;
        FixatingNow=0;
        EndIndex=0;
        fixating=0;
        counter=0;
        framecounter=0;
        x=0;
        y=0;
        area_eye=0;
        xeye2=[];
        yeye2=[];
        mostratarget=0;
        countertarget=0;
        oval_thick=5;
        fixating2=0;
        imageRectcue = CenterRect([0, 0, [radiusPRL*2 ((radiusPRL/pix_deg)*pix_deg)*2]], wRect);
        
        %Every 50 trials, pause to allow subject to rest eyes
        if (mod(trial,50))==1
            if trial==1
                
            else
                Screen('TextFont',w, 'Arial');
                Screen('TextSize',w, 42);
                %     Screen('TextStyle', w, 1+2);
                Screen('FillRect', w, gray);
                colorfixation = white;
                %      DrawFormattedText(w, 'Take a short break and rest your eyes \n\n  \n \n \n \n Press any key to start', 'center', 'center', white);
                
                percentagecompleted= round(trial/trials);
                textSw=sprintf( 'Take a short break and rest your eyes  \n \n You completed %d percent of the session \n \n \n \n Press any key to start', percentagecompleted);
                
                DrawFormattedText(w, textSw, 'center', 'center', white);
                
                
                
                Screen('Flip', w);
                KbQueueWait;
            end
        end
        
        if trial==1
            eyetime2=0;
        end;
        
        %Marcello we commented this if statement out since it doesn't
        %appear
        if randomfix ==1 %Marcello - it doesn't look like randomfix/xcrand/ycrand/etc are used. Are these important?
            possibleXdeg=[-8 -6 -4 -2 2 4 6 8];
            possibleYdeg= [-8 -6 -4 -2 2 4 6 8];
            
            possibleX=possibleXdeg*pix_deg;
            possibleY=possibleYdeg*pix_deg;
            xcrand= xc+possibleX(randi(length(possibleX)));
            ycrand= yc+possibleX(randi(length(possibleY)));
        else
            
            xcrand=xc;
            ycrand=yc;
        end
        
        if totalelements==4
            tgtpos=randi(length(posmatrix));
            
            
        elseif totalelements==3
            posmatrix=[elementcoordx' elementcoordy'];
            tgtpos=randi(length(posmatrix));
        end
        
        
        newpos=posmatrix;
        newpos(tgtpos,:)=[];
        
        
        if totalelements == 3
            targetlocation(trial)=randi(3); %generates answer for this trial
        elseif totalelements == 4
            targetlocation(trial)=randi(4); %generates answer for this trial
        end
        
        
        if totalelements == 4
            target_ecc_x=positionmatrix(posmatrix(targetlocation(trial),1));
            target_ecc_y=positionmatrix(posmatrix(targetlocation(trial),2));
            newnewpos=posmatrix;
            newnewpos(targetlocation(trial),:)=[];
            
            for gg=1:(totalelements-1)
                newdistpos(gg)=randi(length(newnewpos(:,1)));
                newecc_xd(gg)=positionmatrix(newnewpos(newdistpos(gg),1));
                newecc_yd(gg)=positionmatrix(newnewpos(newdistpos(gg),2));
                newnewpos(newdistpos(gg),:)=[];
            end
            
            neweccentricity_X=target_ecc_x*pix_deg;
            neweccentricity_Y=target_ecc_y*pix_deg;
        elseif totalelements == 3
            target_ecc_x=posmatrix(targetlocation(trial),1);
            target_ecc_y=posmatrix(targetlocation(trial),2);
            newnewpos=posmatrix;
            newnewpos(targetlocation(trial),:)=[];
            
            for gg=1:(totalelements-1)
                newdistpos(gg)=randi(length(newnewpos(:,1)));
                newecc_xd(gg)=newnewpos(newdistpos(gg),1);
                newecc_yd(gg)=newnewpos(newdistpos(gg),2);
                newnewpos(newdistpos(gg),:)=[];
            end
            
            neweccentricity_X=elementcoordx(1);
            neweccentricity_Y=elementcoordy(1);
        end
        
        neweccentricity_X=target_ecc_x;
        neweccentricity_Y=target_ecc_y;
        imageRect = CenterRect([0, 0, [imsize imsize]], wRect);
        imageRect_offs =[imageRect(1)+neweccentricity_X, imageRect(2)+neweccentricity_Y,...
            imageRect(3)+neweccentricity_X, imageRect(4)+neweccentricity_Y];
        
        
        if totalelements == 3
            relementcoordx=elementcoordx;
            relementcoordy=elementcoordy;
            relementcoordx(find(relementcoordx==target_ecc_x))=[];
            relementcoordy(find(relementcoordy==target_ecc_y))=[];
            for gg = 1:totalelements-1
                
                neweccentricity_Xd(gg)=round(relementcoordx(gg));
                neweccentricity_Yd(gg)=round(relementcoordy(gg));
                imageRect_offsDist{gg}= [imageRect(1)+round(relementcoordx(gg)), imageRect(2)+round(relementcoordy(gg)),...
                    imageRect(3)+round(relementcoordx(gg)), imageRect(4)+round(relementcoordy(gg))];
                circlefix2(gg)=0;
            end
        elseif totalelements == 4
            for gg = 1:totalelements-1
                neweccentricity_Xd(gg)=newecc_xd(gg)*pix_deg;
                neweccentricity_Yd(gg)=newecc_yd(gg)*pix_deg;
                imageRect_offsDist{gg}= [imageRect(1)+neweccentricity_Xd(gg), imageRect(2)+neweccentricity_Yd(gg),...
                    imageRect(3)+neweccentricity_Xd(gg), imageRect(4)+neweccentricity_Yd(gg)];
                circlefix2(gg)=0;
            end
            
            
        end
        
        audiocue2 %generates audio cue
        
        
        %type of target
        
        theans(trial)=randi(2); %generates answer for this trial
        if theans(trial)==1 %present
            counterleft=counterleft+1;
            texture(trial)=theTargets_left{counterleft};
        else % absent
            counterright=counterright+1;
            texture(trial)=theTargets_right{counterright};
        end
        
        
        Priority(1);
        eyechecked=0;
        KbQueueFlush();
        stopchecking=-100;
        trial_time=100000;
        
        
        pretrial_time=GetSecs;
        stimpresent=0;
        nn=0;
        circlefix=0;
        trialTimedout(trial)=0;
        actualtrialtimeout=realtrialTimeout;
        trialTimeout=400000;
        while eyechecked<1
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            if (eyetime2-pretrial_time)>ifi*35 && (eyetime2-pretrial_time)<ifi*75 && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                fixationscriptrand
                stopone(trial)=99;
            elseif  (eyetime2-pretrial_time)>=ifi*75 && fixating<fixTime/ifi && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                stoptwo(trial)=99;
                IsFixating4
                stopthree(trial)=99;
                fixationscriptrand
                stopfour(trial)=99;
            elseif (eyetime2-pretrial_time)>ifi*75 && fixating>=fixTime/ifi && fixating<1000 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                trial_time = GetSecs;
                stopfive(trial)=99;
                fixating=1500;
                
            end
            if (eyetime2-trial_time)>=0 && (eyetime2-trial_time)<waittime+ifi*2 && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                stopsix(trial)=99;
                
            end
            
            if (eyetime2-trial_time)>=waittime+ifi*2 && (eyetime2-trial_time)<waittime+ifi*4 && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                stopseven(trial)=99;
                
                %here i present the stimuli+acoustic cue
            elseif (eyetime2-trial_time)>waittime+ifi*4 && (eyetime2-trial_time)<waittime+ifi*6 && (eyetime2-pretrial_time)<=trialTimeout&& fixating>400 && stopchecking>1 && keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0 %present pre-stimulus and stimulus
                stopeight(trial)=99;
                
                %  cueonset=GetSecs
                
                vbl=GetSecs;
                cueontime=vbl + (ifi * 0.5);
                PsychPortAudio('Start', pahandle,1,inf); %starts sound at infinity
                PsychPortAudio('RescheduleStart', pahandle, cueontime, 0) %reschedules startime to
                
                %Draw Target
                Screen('DrawTexture', w, texture(trial), [], imageRect_offs );
                
                stim_start=GetSecs;
                stimpresent=1111;
                trialTimeout=actualtrialtimeout+(stim_start-pretrial_time);
                checktrialstart(trial)=1;
            elseif (eyetime2-trial_time)>=waittime+ifi*6 && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout&& keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0 %present pre-stimulus and stimulus
                
                if exist('stim_start')==0
                    
                    % start counting timeout for the non-fixed time training
                    % types
                    %       if exist('checktrialstart')==0
                    trialTimeout=actualtrialtimeout+(stim_start-pretrial_time);
                    checktrialstart(trial)=1;
                    %     end
                    
                    
                    stim_start = GetSecs;
                    
                end
                stimpresent=1111;
                Screen('DrawTexture', w, texture(trial), [], imageRect_offs );
                
                
                
            elseif (eyetime2-trial_time)>=waittime+ifi*7 && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout&& keyCode(RespType(1)) + keyCode(RespType(2))  + keyCode(escapeKey)~= 0 && mostratarget>10 % wait for response
                
                stim_stop=GetSecs;
                thekeys = find(keyCode);
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
                eyechecked=1111111111;
                cicci=100;
            elseif (eyetime2-trial_time)>=waittime+ifi*8 && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout&& keyCode(escapeKey)~= 0 % wait for response
                stim_stop=GetSecs;
                thekeys = find(keyCode);
                thetimes=keyCode(thekeys);
                [secs  indfirst]=min(thetimes);
                eyechecked=1111111111;
                
            elseif (eyetime2-pretrial_time)>=trialTimeout
                stim_stop=GetSecs;
                trialTimedout(trial)=1;
                eyechecked=1111111111;
                
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
            if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                Screen('FillRect', w, gray);
            else
                
                if  stimpresent>0
                    % here to force fixations with the PRL
                    for aux= 1:length(PRLxpix)
                        
                        for aup= 1:length(PRLxpix)
                            if round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aup))<=size(circlePixels,1) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix(aup))<=size(circlePixels,2) ...
                                    &&  round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aup))> 0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix(aup))> 0
                                
                                
                                codey(aup)=round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aup));
                                codex(aup)=round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X))+PRLxpix(aup));
                                activePRLT(aup) =1;
                            else
                                codey(aup)= 1; %round(1025/2); %
                                codex(aup)= 1; %round(1281/2);%
                                activePRLT(aup) = 0;
                                activePRLT(aup) = 0;
                                
                            end
                        end
                        
                        if  stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux))<wRect(4) && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux))>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux)))<wRect(3) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux)))>0
                            
                            % if the stimulus should be present and the
                            % eye position is within the limits of the
                            % screen
                            if   circlePixels(codey(1), codex(1))<0.81 && circlePixels(codey(2), codex(2))<0.81 && circlePixels(codey(3), codex(3))<0.81 ...
                                    && circlePixels(codey(4), codex(4))<0.81
                                
                                
                                % if the stimulus should be present and the
                                % eye position is within the limits of the
                                % screen but the stimulus is outside the
                                % PRL(s)
                                
                                Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                                
                                
                                circlefix=0;
                                
                            else
                                %if we have the EyeCode element, which
                                %tracks the frames for which we have eye position recorded (even if the eye position is missing)
                                if  exist('EyeCode','var')
                                    if length(EyeCode)>6 %&& circlefix>6
                                        circlefix=circlefix+1;
                                        %if we have at least 6 frames
                                        %within this trial
                                        if sum(EyeCode(end-6:end))~=0
                                            %if we don't have 6 consecutive frames with no eye movement (aka, with
                                            %fixation)
                                            Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                                            
                                        elseif sum(EyeCode(end-5:end))==0
                                            %If we have at least 5
                                            %consecutive frames with
                                            %fixation
                                            %HERE WE SHOW THE TARGET
                                            countertarget=countertarget+1;
                                            framefix(countertarget)=length(EyeData(:,1));
                                            if exist('FixIndex','var')
                                                fixind(countertarget)=FixIndex(end,1);
                                            end
                                            mostratarget=100;
                                            timeprevioustarget(countertarget)=GetSecs;
                                        end
                                    elseif length(EyeCode)<=5 %&& circlefix<=6
                                        %if we don't have at least 5 frames
                                        %per trial
                                        Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                                        
                                        circlefix=circlefix+1;
                                    elseif length(EyeCode)>5 %&& circlefix<=6
                                        Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                                        
                                        circlefix=circlefix+1;
                                    end
                                end
                            end
                            
                            
                        elseif stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux))>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Y))+PRLypix(aux))<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux)))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_X)+PRLxpix(aux)))<0 %...
                            
                            
                            circlefix=0;
                            % If this texture is active it will make the target visible only if all the PRLs are within the screen. If one of themis outside the target won't be visible
                            %       Screen('DrawTexture', w, Neutralface, [], imageRect_offs);
                            
                        end
                    end
                    for gg=1:totalelements-1
                        
                        for aux=1:length(PRLxpix)
                            for uso= 1:totalelements-1
                                for aup= 1:length(PRLxpix)
                                    if round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(uso)))+PRLypix(aup))<=size(circlePixels,1) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(uso)))+PRLxpix(aup))<=size(circlePixels,2) ...
                                            &&  round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(uso)))+PRLypix(aup))> 0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(uso)))+PRLxpix(aup))> 0;
                                        
                                        
                                        coodey(uso,aup)=round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(uso)))+PRLypix(aup));
                                        coodex(uso,aup)=round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(uso)))+PRLxpix(aup));
                                        activePRL(uso,aup) =1;
                                    else
                                        coodey(uso,aup)= 1; %round(1025/2);
                                        coodex(uso,aup)= 1; %round(1281/2);
                                        activePRL(uso,aup) = 0;
                                        
                                    end
                                end
                                
                            end
                            
                            if stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux))<wRect(4) && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux))>0 && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux)))<wRect(3) && round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux)))>0 %|| ...
                                if   circlePixels(coodey(gg,1), coodex(gg,1))<0.81 && circlePixels(coodey(gg,2), coodex(gg,2))<0.81 && circlePixels(coodey(gg,3), coodex(gg,3))<0.81 ...
                                        && circlePixels(coodey(gg,4), coodex(gg,4))<0.81
                                    
                                    circlefix2(gg)=0;
                                else
                                    if  exist('EyeCode','var')
                                        if length(EyeCode)>5 && circlefix2(gg)>5
                                            circlefix2(gg)=circlefix2(gg)+1;
                                            if sum(EyeCode(end-5:end))~=0
                                                circlefix2(gg)=circlefix2(gg)+1;
                                                
                                            elseif   sum(EyeCode(end-5:end))==0
                                                %show target
                                                countertargettt(aux,nn)=1;
                                            end
                                        elseif length(EyeCode)<5 && circlefix2(gg)<=5
                                            
                                            circlefix2(gg)=circlefix2(gg)+1;
                                        elseif length(EyeCode)>5 && circlefix2(gg)<=5
                                            circlefix2(gg)=circlefix2(gg)+1;
                                            
                                        end
                                    end
                                end
                            elseif stimpresent>0 && round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux))>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux))<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux)))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux)))<0  %|| ...
                                %    round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux2))>wRect(4) || round(wRect(4)/2+(newsampley-(wRect(4)/2+neweccentricity_Yd(gg)))+PRLypix(aux2))<0 || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux2)))>wRect(3) || round(wRect(3)/2+(newsamplex-(wRect(3)/2+neweccentricity_Xd(gg))+PRLxpix(aux2)))<0
                                
                                
                                circlefix2(gg)=0;
                                %                                 for iu=1:length(PRLx)
                                %                                     imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
                                %                                         imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
                                %                                     if visibleCircle ==1
                                %                                         Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
                                %                                     end
                                %                                 end
                            end
                        end
                    end
                    
                    
                    
                end
                Screen('FillOval', w, scotoma_color, scotoma);
                for iu=1:length(PRLx)
                    imageRect_offscue{iu}=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix(iu),...
                        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix(iu), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix(iu)];
                    if visibleCircle ==1
                        Screen('FrameOval', w,200, imageRect_offscue{iu}, oval_thick, oval_thick);
                    end
                end
            end
            
            
            %    save time and other stuff from flip    equal Screen('Flip', w,vbl plus desired time half of framerate);
            %    [eyetime, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w, eyetime-(ifi * 0.5));
            
            [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
            
            VBL_Timestamp=[VBL_Timestamp eyetime2];
            %    stimonset=[stimonset StimulusOnsetTime];
            %    fliptime=[fliptime FlipTimestamp];
            %      mss=[mss Missed];
            
            if EyeTracker==1
                if site<3
                    GetEyeTrackerData
                elseif site ==3
                    GetEyeTrackerDatapixx
                end
                if ~exist('EyeData','var')
                    EyeData = ones(1,5)*9001;
                end
                GetFixationDecision
                
                %                 if EyeData(1)<8000 && stopchecking<0
                %                     trial_time = GetSecs;
                %                     stopchecking=10;
                %                 end
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
            [keyIsDown, keyCode] = KbQueueCheck;
            %  toc
            %    disp('fine')
            nn=nn+1;
        end
        
        
        if trialTimedout(trial)== 0
            foo=(RespType==thekeys);
            if foo(theans(trial))
                resp = 1;
                PsychPortAudio('Start', pahandle1);
                
                if stim_stop - stim_start<5
                    respTime=1;
                    
                    
                    
                else
                    respTime=0;
                    counteremojisize=0;
                    
                end
                
                
            elseif (thekeys==escapeKey) % esc pressed
                closescript = 1;
                if EyetrackerType==2
                    Datapixx('DisableSimulatedScotoma')
                    Datapixx('RegWrRd')
                end
                ListenChar(0);
                break;
            else
                resp = 0;
                respTime=0;
                PsychPortAudio('Start', pahandle2);
                
            end
        else
            
            resp = 0;
            respTime=0;
            PsychPortAudio('Start', pahandle2);
        end
        
        %  stim_stop=secs;
        time_stim(kk) = stim_stop - stim_start;
        totale_trials(kk)=trial;
        %     coordinate(trial).x=ecc_x;
        %    coordinate(trial).y=ecc_y;
        rispoTotal(kk)=resp;
        rispoInTime(kk)=respTime;
        %  distraktor(trial)=distnum;
        xxeye(trial).ics=[xeye];
        yyeye(trial).ipsi=[yeye];
        vbltimestamp(trial).ix=[VBL_Timestamp];
        % answer(trial)=theans %1 = present
        TGT_loc(trial)=targetlocation(trial);
        TGT_x(trial)=target_ecc_x;
        TGT_y(trial)=target_ecc_y;
        
        tutti{trial} =imageRect_offs;
        
        
        if EyeTracker==1
            
            
            EyeSummary.(TrialNum).EyeData = EyeData;
            clear EyeData
            if exist('EyeCode')==0
                EyeCode = 888;
            end
            EyeSummary.(TrialNum).EyeData(:,6) = EyeCode';
            clear EyeCode
            
            
            
            if exist('FixIndex')==0
                FixIndex=0;
            end
            if exist('fixind')==0
                fixind=0;
            end
            EyeSummary.(TrialNum).FixationIndices = FixIndex;
            clear FixIndex
            EyeSummary.(TrialNum).TotalEvents = CheckCount;
            clear CheckCount
            EyeSummary.(TrialNum).TotalFixations = FixCount;
            clear FixCount
            EyeSummary.(TrialNum).TargetX = target_ecc_x;
            EyeSummary.(TrialNum).TargetY = target_ecc_y;
            
            
            EyeSummary.(TrialNum).EventData = EvtInfo;
            clear EvtInfo
            EyeSummary.(TrialNum).ErrorData = ErrorData;
            clear ErrorData
            %  EyeSummary(trial).GetFixationInfo.DriftCorrIndices = DriftCorrIndices;
            EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
            EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
            EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
            %FixStamp(TrialCounter,1);
            EyeSummary.(TrialNum).TimeStamps.Stimulus = stim_start;
            EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;
            EyeSummary.(TrialNum).StimulusSize=imsize;
            EyeSummary.(TrialNum).Target.App = mostratarget;
            EyeSummary.(TrialNum).Target.counter=countertarget;
            EyeSummary.(TrialNum).Target.FixInd=fixind;
            EyeSummary.(TrialNum).Target.Fixframe=framefix;
            EyeSummary.(TrialNum).PRL.x=PRLx;
            EyeSummary.(TrialNum).PRL.y=PRLy;
            EyeSummary.(TrialNum).targetlocation =targetlocation;
            %StimStamp(TrialCounter,1);
            clear ErrorInfo
            %    fliptime(trial)=[VBL_Timestamp];
            %thresharray(kk)=tresh;
        end
        
        kk=kk+1;
        
        %
        %             if trial==100 | 200 | 300 | 400 | 500 | 600 | 700
        %             save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|ax|ay|xxx|yyyy|circle|azimuths|corrS|errorS|Allimg)$).');
        %             end;
        
        if (mod(trial,100))==1
            if trial==1
            else
                save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
            end
        end
        
        if closescript==1
            break;
        end
        
    end
    
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
    if trial>1
        comparerisp=[rispoTotal' rispoInTime']; %Marcello - is this for debugging/needed for anything? % it's just a quick summary of the response (correct/incorrect) and the RT per trial
    end
    
    TimeSop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    DrawFormattedText(w, 'Task completed - Please inform the experimenter', 'center', 'center', white);
    ListenChar(0);
    Screen('Flip', w);
    KbWait;
    ShowCursor;
    
    if site==1
        Screen('CloseAll');
        Screen('Preference', 'SkipSyncTests', 0);
        %     s1 = serial('COM3');     % set the Bits mode back so the screen
        %     is in colour
        %     fopen(s1);
        %     fprintf(s1, ['$BitsPlusPlus' 13]); %one day we might use the bits# so better not to get rid of these lines
        %     fclose(s1);
        PsychPortAudio('Close', pahandle);
        
    else
        Screen('Preference', 'SkipSyncTests', 0);
        Screen('LoadNormalizedGammaTable', w , (linspace(0,1,256)'*ones(1,3)));
        Screen('Flip', w);
        Screen('CloseAll');
        PsychPortAudio('Close', pahandle);
    end
    
    
    
    
catch ME
    psychlasterror()
end