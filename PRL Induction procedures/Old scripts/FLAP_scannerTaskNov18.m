
% Orientation Discrimination and Contour Integration task for scanner
% written by Pinar Demirayak April 2022
close all;
clear;
clc;
commandwindow
addpath([cd '/utilities']); %add folder with utilities files
%% take information from the user
try
    prompt={'Subject Name', 'Pre or Post Scan','Run Number','site: Bits++(1), Mac Laptop(2), Windows Laptop(3)','demo (0) or session (1)', 'left (1) or right (2) TRL?'};

    name= 'test';
    numlines=1;
    defaultanswer={'test','1', '1', '3','1','1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end

    SUBJECT = answer{1,:}; %Gets Subject Name
    prepost=str2num(answer{2,:});
    runnumber= str2num(answer{3,:});
    site= str2num(answer{4,:});  % 0=UAB disp++;1=UCR;2=Anymac;3=Datapixx
    Isdemo=answer{5,:};
    TRLlocation= str2num(answer{6,:}); %1=left, 2=right

    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data');
    end
    defineSite_Scanner %Screen parameters
    trainingType=0;
    CommonParametersFLAP_Scanner % define common parameters

    %% Stimuli creation
    %coeffAdj=1;
    %PreparePRLpatch % here I characterize PRL features

    % Gabor stimuli
    createGabors
TheGabors=TheGabors(3,1);

    % CI stimuli
    CIShapes_Scanner

    %% response

    KbName('UnifyKeyNames');

    indexfingerresp = KbName('b');% left oriented gabor or six
    middlefingerresp = KbName('r');% right oriented gabor or nine
    escapeKey = KbName('ESCAPE');	% quit key

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

    %% main loop
    HideCursor;
    eccentricity_X=[PRLx -PRLx]*pix_deg;
    eccentricity_Y=[PRLy PRLy]*pix_deg;

    %% draw everything on the instruction page

    stimulusdirection_leftstim=1;stimulusdirection_rightstim=2; %what are shown in left and right is set
    CIstimuliMod_ScannerIns;
    theeccentricity_Y=0;
    theeccentricity_X=PRLx*pix_deg;
    eccentricity_X(1)= theeccentricity_X;
    eccentricity_Y(1) =theeccentricity_Y ;
    InstructionShapeScanner

%     %% get trigger t
%     ListenChar(2);
%     soundsc(sin(1:.5:1000)); % play 'ready' tone
%     disp('Ready, waiting for trigger...');
%     commandwindow;
%     if site==1
%         tChar=KbName('t');
%         KbWait;
%         startTime=GetSecs;
%     elseif site==2
%         startTime = wait4T(tChar);  %wait for 't' from scanner.
%     elseif site==3
%         tChar=KbName('t');
%         [TTLtime, keyCode]=KbWait;
%         startTime=TTLtime;
%     end
%     disp(['Trigger received - ' startdatetime]);

%     n=1; %we need to collect ttl pulses from the scanner
%     TTLpulse = find(keyCode, 1);
%     TTL{n,1}=KbName(TTLpulse);TTL{n,2}=TTLtime;
%     ttlpulses=false;

    fixationscriptW;
    WaitSecs(TR);
    %% Start Trials
    if Isdemo==1
        totalactiveblock=2;
    end
    for totalblock=1:totalactiveblock
%         while ~ttlpulses
%              [keyisdown,keytime,keycode]=KbCheck; %collect possible pulses from the scanner

            if Isdemo==1
                runnumber=1;
            end
            active=num2str(totalblock);
            activeblock=activeblockcue(totalblock,:);
            activeblockstim=eval(['activeblockstimulus' active]);% direction of gabors or being 6 or9 in both location
            runnum=num2str(runnumber);
            blocktype=activeblocktype(runnumber,totalblock);
%             if keyisdown
%                 possibleTTLpulse=find(keycode, 1);
%                 TTL{n+1,1}=KbName(possibleTTLpulse);TTL{n+1,2}=keytime;
%                 ttlpulses=true;
%             end
%             FlushEvents;
%             break;
%         end
        for trial=1:10
            trialstarttime(totalblock,trial)=GetSecs;
            Screen('TextFont',w, 'Arial');
            Screen('TextSize',w, 60);
            fixationscriptW;
            cue=activeblock(trial); %if it's 1 attend to left, if it's 2 attend right

            if cue==1
                DrawFormattedText(w, '<', 'center',cueloc, white);%688
            else
                DrawFormattedText(w, '>', 'center',cueloc, white);
            end
            CueOnsetTime=Screen('Flip',w);
            while GetSecs<CueOnsetTime+0.250
            end
            stimulusdirection_leftstim=activeblockstim(trial,1);stimulusdirection_rightstim=activeblockstim(trial,2); %what are shown in left and right is set
            if blocktype==1 %gabors
                gaborcontrast=0.35;
                theoris =[-45 45]; % whether right or left oriented gabor
                %trl locations
                imageRect_offsleft =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
                    imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
                imageRect_offsright =[imageRect(1)-theeccentricity_X, imageRect(2)+theeccentricity_Y,...
                    imageRect(3)-theeccentricity_X, imageRect(4)+theeccentricity_Y];

                if stimulusdirection_leftstim==1
                    Screen('DrawTexture', w, TheGabors, [], imageRect_offsleft, theoris(1),[], gaborcontrast);

                else
                    Screen('DrawTexture', w, TheGabors, [], imageRect_offsleft, theoris(2),[], gaborcontrast);
                end
                if stimulusdirection_rightstim==1
                    Screen('DrawTexture', w, TheGabors, [], imageRect_offsright, theoris(1),[], gaborcontrast);

                else
                    Screen('DrawTexture', w, TheGabors, [], imageRect_offsright, theoris(2),[], gaborcontrast);
                end

                fixationscriptW;
            else %numbers
                CIstimuliMod_ScannerIns
                imageRect_offsCIleft =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(1), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(1),...
                    imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(1), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(1)];
                imageRect_offsCIleft2=imageRect_offsCIleft;
                imageRect_offsCIright =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(2), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(1),...
                    imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(2), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(1)];
                imageRect_offsCIright2=imageRect_offsCIright;
                imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                imageRect_offsCImaskleft=[imageRectMask(1)+eccentricity_X(1), imageRectMask(2)+eccentricity_Y(1),...
                    imageRectMask(3)+eccentricity_X(1), imageRectMask(4)+eccentricity_Y(1)];
                imageRect_offsCImaskright=[imageRectMask(1)+eccentricity_X(2), imageRectMask(2)+eccentricity_Y(1),...
                    imageRectMask(3)+eccentricity_X(2), imageRectMask(4)+eccentricity_Y(1)];

                if stimulusdirection_rightstim==1 %1 points left
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIright'+ [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr);
                    imageRect_offsCIright2(setdiff(1:length(imageRect_offsCIright),targetcord),:)=0;
                else %2 points right
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIright'+ [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr);
                    imageRect_offsCIright2(setdiff(1:length(imageRect_offsCIright),targetcord),:)=0;
                end
                if stimulusdirection_leftstim==1 %1 points left
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIleft'+ [xJitLoc2+xModLoc; yJitLoc2+yModLoc; xJitLoc2+xModLoc; yJitLoc2+yModLoc], theori2,[], Dcontr);
                    imageRect_offsCIleft2(setdiff(1:length(imageRect_offsCIleft),targetcord2),:)=0;
                else %1 points right
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIleft'+ [xJitLoc2+xModLoc; yJitLoc2+yModLoc; xJitLoc2+xModLoc; yJitLoc2+yModLoc], theori2,[], Dcontr);
                    imageRect_offsCIleft2(setdiff(1:length(imageRect_offsCIleft),targetcord2),:)=0;
                end
                Screen('FrameOval', w,gray, imageRect_offsCImaskleft, 22, 22);
                Screen('FrameOval', w,gray, imageRect_offsCImaskright, 22, 22);
                fixationscriptW; %fixation aids
                if cue==1 % we are showing cue during the stimulus presentation
                    DrawFormattedText(w, '<', 'center',cueloc, white);%688
                else
                    DrawFormattedText(w, '>', 'center',cueloc, white);
                end

            end

            StimulusOnsetTime=Screen('Flip',w); %show stimulus
            while GetSecs<StimulusOnsetTime+0.200 %stimulus presentation time is 200 ms
            end
            fixationscriptW; %fixation aids
            ResponseFixationOnsetTime=Screen('Flip',w); %start of response time
            MaximumResponseTime=totaltrialtime-(ResponseFixationOnsetTime-trialstarttime(totalblock,trial)); % maximum time to response
            ListenChar(2);
            timedout=false;
            RT(totalblock,trial)=0;ResponseType{totalblock,trial}='miss';RTraw=0;%Resp_TTL{totalblock,trial}='no'
            if site==1
                while ~timedout
                    [ keyIsDown, keyTime, keyCode ] = KbCheck;
                    responsekey = find(keyCode, 1);
                    if keyIsDown
                        RTraw(totalblock,trial)=keyTime;
                        RT(totalblock,trial)=keyTime-ResponseFixationOnsetTime;
                        conditions(1)=logical(cue==1 && stimulusdirection_leftstim==1 && responsekey==middlefingerresp);conditions(2)=logical(cue==1 && stimulusdirection_leftstim==2 && responsekey==indexfingerresp);conditions(3)=logical(cue==2 && stimulusdirection_rightstim==1 && responsekey==middlefingerresp);conditions(4)=logical(cue==2 && stimulusdirection_rightstim==2 && responsekey==indexfingerresp); %conditions that are true
                        if any(conditions)==1
                            PsychPortAudio('Start', pahandle1); % feedback for true response
                            ResponseType{totalblock,trial}='correct';
                        else
                            PsychPortAudio('Start', pahandle2); %feedback for false response
                            ResponseType{totalblock,trial}='false';
                        end
                        clear conditions;
                        FlushEvents;
                        break;
                    end;
                    if((keyTime-ResponseFixationOnsetTime)>MaximumResponseTime),timedout=true;
                    end
                end
            elseif   site==2
                while ~timedout
                    keyTime=GetSecs;
                    if CharAvail
                        [ch, keyTime] = GetChar;
                        responsekey=KbName(ch);
                        RTraw(totalblock,trial)=keyTime.secs;
                        RT(totalblock,trial)=abs(keyTime.secs-ResponseFixationOnsetTime); %reaction time
                        conditions(1)=logical(cue==1 && stimulusdirection_leftstim==1 && responsekey==middlefingerresp);conditions(2)=logical(cue==1 && stimulusdirection_leftstim==2 && responsekey==indexfingerresp);conditions(3)=logical(cue==2 && stimulusdirection_rightstim==1 && responsekey==middlefingerresp);conditions(4)=logical(cue==2 && stimulusdirection_rightstim==2 && responsekey==indexfingerresp); %conditions that are true
                        if any(conditions)==1
                            PsychPortAudio('Start', pahandle1); % feedback for true response
                            ResponseType{totalblock,trial}='correct';
                        else
                            PsychPortAudio('Start', pahandle2); %feedback for false response
                            ResponseType{totalblock,trial}='false';
                        end
                        clear conditions;
                        FlushEvents;
                        break;
                    end

                    if((keyTime-ResponseFixationOnsetTime)>MaximumResponseTime),timedout=true;
                    end

                end
            elseif site==3
                while ~timedout
                    [ keyIsDown, keyTime, keyCode ] = KbCheck;
                    responsekey = find(keyCode, 1);
                    if keyIsDown
                        RTraw(totalblock,trial)=keyTime;
                        RT(totalblock,trial)=keyTime-ResponseFixationOnsetTime;
                        TTL{totalblock,trial}=KbName(responsekey);
                        conditions(1)=logical(cue==1 && stimulusdirection_leftstim==1 && responsekey==middlefingerresp);conditions(2)=logical(cue==1 && stimulusdirection_leftstim==2 && responsekey==indexfingerresp);conditions(3)=logical(cue==2 && stimulusdirection_rightstim==1 && responsekey==middlefingerresp);conditions(4)=logical(cue==2 && stimulusdirection_rightstim==2 && responsekey==indexfingerresp); %conditions that are true
                        if any(conditions)==1
                            PsychPortAudio('Start', pahandle1); % feedback for true response
                            ResponseType{totalblock,trial}='correct';
                        else
                            PsychPortAudio('Start', pahandle2); %feedback for false response
                            ResponseType{totalblock,trial}='false';
                        end
                        clear conditions;
                        FlushEvents;
                        break;
                    end;
                    if((keyTime-ResponseFixationOnsetTime)>MaximumResponseTime),timedout=true;
                    end
                end
            end
            % Begin the rest block jittered times between trials

            itiforrun=eval(['interTrialIntervals' runnum]);
            iti=itiforrun(totalblock,trial)*TR;
            WaitSecs(iti);
        end
        if responsekey == escapeKey
            break;
        end
        clear responsekey;
        Screen('TextFont',w, 'Arial');
        Screen('TextSize',w, 60);
        Screen('FillRect', w, gray);
        fixationscriptW;
        DrawFormattedText(w, 'x', 'center', xloc, white);%685
        RestTime=Screen('Flip',w);
        save(baseName,'RT','RTraw','ResponseType','trialstarttime','-append') %save our variables

        while GetSecs < RestTime + 15; %  rest for 15 sec

        end
    end


    %% Clean up
    DrawFormattedText(w, 'Task completed', 'center', 'center', white);
    ListenChar(0);
    Screen('Flip', w);

    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    ShowCursor;
    Screen('CloseAll');
    PsychPortAudio('Close', pahandle1);
    PsychPortAudio('Close', pahandle2);

catch ME
    'There was an error caught in the main program.'
    psychlasterror()
end