
% Orientation Discrimination and Contour Integration task for scanner
% written by Pinar Demirayak April 2022

close all;
clear;
clc;
commandwindow
addpath([cd '/utilities']); %add folder with utilities files
%% take information from the user
try
    prompt={'Subject Name', 'Baseline(1) or Post(2) Scan','Run Number','site: Bits++(1), Mac Laptop(2), Windows Laptop(3)','demo (0) or session (1)', 'left (1) or right (2) TRL?'};

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
    [ifi, nrValidSamples, stddev] = Screen('GetFlipInterval',w); % inter-flip interval in ms

    %% Stimuli creation
    coeffAdj=1;
    PreparePRLpatch % here I characterize PRL features

    % Gabor stimuli
    createGabors_Scanner

    % CI stimuli
    CIShapes_Scanner
    % define stimulus durations
    cue_duration  = round(.250/ifi) * ifi; % cue duration in units of inter-frame intervals
    stim_duration = round(.200/ifi) * ifi; % stimulus duration in units of inter-frame intervals
    rest_duration = round(15/ifi)*ifi;

    eccentricity_X=[PRLx -PRLx]*pix_deg;
    eccentricity_Y=[PRLy PRLy]*pix_deg;
    k=1;% number of TTLs during active block
    kr=1; %number of TTLs during rest block
    j=1; % number of TTLs recorded in the whole session
    jr=1; %number of TTLs recorded during rests
    %% response

    KbName('UnifyKeyNames');

    leftfingerresp = KbName('b');% left oriented gabor or six
    rightfingerresp = KbName('r');% right oriented gabor or nine
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

    %% draw everything on the instruction page
    HideCursor;
    stimulusdirection_leftstim=1;stimulusdirection_rightstim=2; %what are shown in left and right is set
    stimulusdirection_leftstim_num=1;stimulusdirection_rightstim_num=2;
    CIstimuliMod_Scanner;
    theeccentricity_Y=0;
    theeccentricity_X=PRLx*pix_deg;
    eccentricity_X(1)= theeccentricity_X;
    eccentricity_Y(1) =theeccentricity_Y ;
    InstructionShapeScanner
    Screen('TextFont',w, 'Arial');
    Screen('TextSize',w, 60);
    %% settings for individual small gabors for contour integration stimulus

    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    %locations of the stimulus on the screen
    % gabors
    imageRect_offsleft =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
        imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
    imageRect_offsright =[imageRect(1)-theeccentricity_X, imageRect(2)+theeccentricity_Y,...
        imageRect(3)-theeccentricity_X, imageRect(4)+theeccentricity_Y];
    %egg or d/p stimulus
    imageRect_offsCIleft =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(1), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(1),...
        imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(1), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(1)];
    imageRect_offsCIleft2=imageRect_offsCIleft;
    imageRect_offsCIright =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(2), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(1),...
        imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(2), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(1)];
    imageRect_offsCIright2=imageRect_offsCIright;
    %imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.49 (xs/coeffCI*pix_deg)*1.49]], wRect);
    imageRectMask = CenterRect([0, 0, [CIstimulussize+maskthickness CIstimulussize+maskthickness]], wRect);
    imageRect_offsCImaskleft=[imageRectMask(1)+eccentricity_X(1), imageRectMask(2)+eccentricity_Y(1),...
        imageRectMask(3)+eccentricity_X(1), imageRectMask(4)+eccentricity_Y(1)];
    imageRect_offsCImaskright=[imageRectMask(1)+eccentricity_X(2), imageRectMask(2)+eccentricity_Y(1),...
        imageRectMask(3)+eccentricity_X(2), imageRectMask(4)+eccentricity_Y(1)];
    %6/9 stimulus
    imageRect_offsCIleftnum =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(1), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(1),...
        imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(1), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(1)];
    imageRect_offsCIleftnum2=imageRect_offsCIleftnum;
    imageRect_offsCIrightnum =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(2), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(1),...
        imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(2), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(1)];
    imageRect_offsCIrightnum2=imageRect_offsCIrightnum;
    %%imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56(xs/coeffCI*pix_deg)*1.56]], wRect); %1.49
    imageRectMask = CenterRect([0, 0, [CIstimulussize+maskthickness CIstimulussize+maskthickness]], wRect);
    imageRect_offsCImaskleft=[imageRectMask(1)+eccentricity_X(1), imageRectMask(2)+eccentricity_Y(1),...
        imageRectMask(3)+eccentricity_X(1), imageRectMask(4)+eccentricity_Y(1)];
    imageRect_offsCImaskright=[imageRectMask(1)+eccentricity_X(2), imageRectMask(2)+eccentricity_Y(1),...
        imageRectMask(3)+eccentricity_X(2), imageRectMask(4)+eccentricity_Y(1)];
    %% get trigger t
    ListenChar(2);
    soundsc(sin(1:.5:1000)); % play 'ready' tone
    disp('Ready, waiting for trigger...');
    commandwindow;
    trigger=false;
    %triggercode=84;%t=23 for mac, for windows: t=84, b=66, r=82, y=89, g=71
    if site==2
        startTime = wait4T(tChar);  %wait for 't' from scanner.
    elseif site==1 || site==3
        while ~trigger
            [ keyIsDown, keyTime, keyCode ] = KbCheck; %check this later
            TTL = find(keyCode, 1);
            if keyIsDown==1 && TTL==KbName('t')
                startTime=keyTime;
                clear keyIsDown keyTime keyCode
                trigger=true;
            end
            %end
        end
    end
    disp(['Trigger received - ' startdatetime]);
    fixationscriptW;


    %% Start Trials
    if Isdemo==1
        totalblockfinal=2;
    end
    for totalblock=1:totalblockfinal
        if Isdemo==1
            runnumber=1;
        end
        blocktype=activeblocktype(runnumber,totalblock);
        %totalblockstr=num2str(totalblock);
        if blocktype==4 % rest
            fixationscriptW;
            DrawFormattedText(w, 'x', 'center', xloc, white);%685
            RestTime=Screen('Flip',w);
            clear keyIsDown keyTime keyCode
            restorder=find(activeblocktype(runnumber,:)==4);
            if restorder==1
                while GetSecs < RestTime + rest_duration; %  rest for 15 sec
                    [keyIsDown, keyTime, keyCode] = KbCheck; %during the rest get TTL pulses
                    if  keyIsDown
                        keyr(1,kr) = find(keyCode, 1);
                        keypresstime(1,kr)=keyTime;
                        if keyr==KbName('t');
                            if kr==1 && keypresstime(1,kr)<startTime+TR
                            elseif kr==1 && keypresstime(1,kr)>startTime+TR
                                TTL_timeforrest(jr)=keyTime;
                                kr=kr+1;
                                jr=jr+1;
                            elseif keypresstime(1,kr)-keypresstime(1,kr-1)>=.5 %I added this because kbcheck gets ~30 keypresses since manual testing isn't quick enough
                                TTL_timeforrest(jr)=keyTime;
                                kr=kr+1;
                                jr=jr+1;
                            end
                        end
                    end
                end
            else
                pastexptime=(((restorder-1)*43)+1)*TR;
                %pastexptime2=GetSecs-startTime;
                while GetSecs < RestTime + rest_duration; %  rest for 15 sec
                    [keyIsDown, keyTime, keyCode] = KbCheck; %during the rest get TTL pulses
                    if  keyIsDown
                        keyr(1,kr) = find(keyCode, 1);
                        keypresstime(1,kr)=keyTime;
                        if keyr==KbName('t');
                            if kr==1 && keypresstime(1,kr)<startTime+pastexptime
                            elseif kr==1 && keypresstime(1,kr)>startTime+pastexptime
                                TTL_timeforrest(jr)=keyTime;
                                kr=kr+1;
                                jr=jr+1;
                            elseif keypresstime(1,kr)-keypresstime(1,kr-1)>=.5 %I added this because kbcheck gets ~30 keypresses since manual testing isn't quick enough
                                TTL_timeforrest(jr)=keyTime;
                                kr=kr+1;
                                jr=jr+1
                            end
                        end
                    end
                end
            end
        else
            active=num2str(totalblock);
            runnum=num2str(runnumber);
            activeblockcue=eval(['activeblockcue' runnum]);
            activeblock=activeblockcue(totalblock,:);
            activeblockstim=eval(['activeblockstimulus' runnum]);% direction of gabors or being 6 or9 in both location
            itiforrun=eval(['interTrialIntervals' runnum]);
            %itiforrun=[4 4 2 2 2 2 2 2 2 2 2 2]; % Pinar, remember to take out #kmv
            % LOOP FOR TRIALS %%%%%%%%
            for trial=1:totaltrial
                cue=activeblock(trial); %if it's 1 attend to left, if it's 2 attend right
                kt(totalblock,trial)=1;%counts how many TR is catched in each block
                if trial==1 && totalblock==1 % it's the first trial of the first block
                    %trialcase=1;
                    itiprevious = 1;
                    TimeToStopListening(totalblock,trial)=startTime+((itiprevious-0.5)*TR); %not functioning
                    trialstarttime(totalblock,trial)=startTime+TR;
                    PreviousCueTime=0;
                elseif trial==1 && totalblock>1 && activeblocktype(runnumber,totalblock-1)==4% it's the first trial of the following blocks and previous block is rest
                    %trialcase=2;
                    TimeToStopListening(totalblock,trial)=RestTime+rest_duration; %not functioning
                    trialstarttime(totalblock,trial)=RestTime+rest_duration; %sonradan
                elseif trial==1 && totalblock>1 && activeblocktype(runnumber,totalblock-1)~=4% it's the first trial of the following blocks and previous block is one of the active blocks
                    itiprevious=itiforrun(totalblock-1,totaltrial);
                    PreviousCueTime=CueOnsetTime(totalblock-1,totaltrial);
                    if itiprevious==0
                        %trialcase=31;
                        TimeToStopListening(totalblock,trial)=PreviousCueTime+(2*TR); %not functioning
                        trialstarttime(totalblock,trial)=PreviousCueTime+(2*TR);
                    else
                        % trialcase32;
                        TimeToStopListening(totalblock,trial)=PreviousCueTime+((itiprevious-0.5)*TR);
                        trialstarttime(totalblock,trial)=PreviousCueTime+(2*TR)+itiprevious; %sonradan
                    end
                elseif trial>1 && itiforrun(totalblock,trial-1)>0 %if it's not the first trial of the block and previous iti is greater than 1TR
                    % trialcase=4;
                    itiprevious=itiforrun(totalblock,trial-1);
                    PreviousCueTime=CueOnsetTime(totalblock,trial-1);
                    TimeToStopListening(totalblock,trial)=PreviousCueTime+((itiprevious-0.5)*TR);%maybe functioning
                    trialstarttime(totalblock,trial)=PreviousCueTime+(2*TR)+itiprevious;%sonradan
                elseif trial>1 && itiforrun(totalblock,trial-1)==0 %if it's not the first trial of the block and iti equals 1TR
                    %trialcase=5;
                    itiprevious=itiforrun(totalblock,trial-1);
                    PreviousCueTime=CueOnsetTime(totalblock,trial-1);
                    TimeToStopListening(totalblock,trial)=PreviousCueTime+(2*TR);
                    trialstarttime(totalblock,trial)=PreviousCueTime+(2*TR);%there is no time to collect ttl pulses
                end

                fixationscriptW;

                if cue==1
                    DrawFormattedText(w, '<', 'center',cueloc, white);
                else
                    DrawFormattedText(w, '>', 'center',cueloc, white);
                end
                clear keyIsDown keyTime keyCode
                while GetSecs < TimeToStopListening(totalblock,trial)%resting for previousiti
                    [keyIsDown, keyTime, keyCode] = KbCheck;
                    if  keyIsDown
                        key(1,k) = find(keyCode, 1);
                        keypresstime(1,k)=keyTime;
                        if key==KbName('t');
                            if k==1 && keypresstime(1,k)<startTime+TR
                            elseif k==1 && keypresstime(1,k)>startTime+TR
                                TTL_time(j)=keyTime;
                                k=k+1;
                                j=j+1;
                                kt(totalblock,trial)=k;
                            elseif keypresstime(1,k)-keypresstime(1,k-1)>=.5 %I added this because kbcheck gets ~30 keypresses since manual testing isn't quick enough
                                TTL_time(j)=keyTime;
                                k=k+1;
                                j=j+1;
                                kt(totalblock,trial)=k;
                            end
                        end
                    end
                end
                if exist('TTL_time')
                    %eval(['TTL_time_total_' totalblockstr '=TTL_time']);
                    clear keyIsDown keyTime keyCode % keypresstime key
                end
                if trial==1 && totalblock>1 && activeblocktype(runnumber,totalblock-1)==4
                    trialstarttime(totalblock,trial)=TTL_timeforrest(jr-1)+TR;
                elseif kt(totalblock,trial)>1 %trial>1 && itiprevious>1 && trial<totaltrial
                    trialstarttime(totalblock,trial)=TTL_time(j-1)+TR; % this is when the TTL occurs.  Trials 'start' in sync with the MRI frame
                end

                %if trial==1 && totalblock>1 %we don't have iti for the first trial of the following task blocks
                %else
                    while GetSecs < trialstarttime(totalblock,trial)-0.001 %TimeToStopListening(totalblock,trial)+(TR/2) %leftover iti wait
                    end
                %end
                % show the cue
                CueOnsetTime(totalblock,trial)=Screen('Flip',w);
                % while showing the cue, prepare the stimulus
                if totalblock==1
                    stimulusdirection_leftstim=activeblockstim(trial,1);stimulusdirection_rightstim=activeblockstim(trial,2); %what are shown in left and right is set
                    stimulusdirection_leftstim_num=stimulusdirection_leftstim;stimulusdirection_rightstim_num=stimulusdirection_rightstim; %what are shown in left and right is set
                elseif totalblock>1
                    stimulusdirection_leftstim=activeblockstim(((totalblock-1)*totaltrial)+trial,1);stimulusdirection_rightstim=activeblockstim(((totalblock-1)*totaltrial)+trial,2); %what are shown in left and right is set
                    stimulusdirection_leftstim_num=stimulusdirection_leftstim;stimulusdirection_rightstim_num=stimulusdirection_rightstim; %what are shown in left and right is set
                end
                if blocktype==1 %gabors
                    %createGabors_Scanner

                    if stimulusdirection_leftstim==1 %right oriented
                        Screen('DrawTexture', w, TheGabors, [], imageRect_offsleft, theoris(1),[], gaborcontrast);

                    else %left oriented
                        Screen('DrawTexture', w, TheGabors, [], imageRect_offsleft, theoris(2),[], gaborcontrast);
                    end
                    if stimulusdirection_rightstim==1 %right orited
                        Screen('DrawTexture', w, TheGabors, [], imageRect_offsright, theoris(1),[], gaborcontrast);

                    else %left oriented
                        Screen('DrawTexture', w, TheGabors, [], imageRect_offsright, theoris(2),[], gaborcontrast);
                    end

                    responseScanner2;
                elseif blocktype==2 %egg-CI
                    CIstimuliMod_Scanner
                    %stimulus that is shown on the right side
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIright'+ [xJitLoc; yJitLoc; xJitLoc; yJitLoc], theori,[], Dcontr);
                    imageRect_offsCIright2(setdiff(1:length(imageRect_offsCIright),targetcord),:)=0;
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIright2'+ [xJitLoc; yJitLoc; xJitLoc; yJitLoc], theori,[], Dcontr);
                    %stimulus that is shown on the left side
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIleft'+ [xJitLoc2; yJitLoc2; xJitLoc2; yJitLoc2], theori2,[], Dcontr);
                    imageRect_offsCIleft2(setdiff(1:length(imageRect_offsCIleft),targetcord2),:)=0;
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIleft2'+ [xJitLoc2; yJitLoc2; xJitLoc2; yJitLoc2], theori2,[], Dcontr);

                    Screen('FrameOval', w,gray, imageRect_offsCImaskleft, maskthickness/2, maskthickness/2);
                    Screen('FrameOval', w,gray, imageRect_offsCImaskright, maskthickness/2, maskthickness/2);

                    responseScanner2;

                elseif blocktype==3 %6 or 9
                    CIstimuliMod_Scanner
                    %stimulus that is shown on the right side
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIrightnum'+ [xJitLocnum; yJitLocnum; xJitLocnum; yJitLocnum], theorinum,[], Dcontr);
                    imageRect_offsCIrightnum2(setdiff(1:length(imageRect_offsCIrightnum),targetcordnum),:)=0;
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIrightnum2'+ [xJitLocnum; yJitLocnum; xJitLocnum; yJitLocnum], theorinum,[], Dcontr);

                    %stimulus that is shown on the left side
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIleftnum'+ [xJitLocnum2; yJitLocnum2; xJitLocnum2; yJitLocnum2], theorinum2,[], Dcontr);
                    imageRect_offsCIleftnum2(setdiff(1:length(imageRect_offsCIleftnum),targetcordnum2),:)=0;
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIleftnum2'+ [xJitLocnum2; yJitLocnum2; xJitLocnum2; yJitLocnum2], theorinum2,[], Dcontr);

                    Screen('FrameOval', w,gray, imageRect_offsCImaskleft, maskthickness/2, maskthickness/2);
                    Screen('FrameOval', w,gray, imageRect_offsCImaskright, maskthickness/2, maskthickness/2);

                    responseScanner2;
                    % Begin the rest block jittered times between trials

                end
            end
            if totalblock==totalblockfinal || activeblocktype(runnumber,totalblock+1)==4
                iti=itiforrun(totalblock,trial);
                while GetSecs < CueOnsetTime(totalblock,trial)+(iti*TR)+(2*TR)%TimeToStopListening(totalblock,trial)%% CueOnsetTime(totalblock,trial-1)+iti %resting for iti
                end
            end
            save(baseName,'RTraw','ResponseType','ResponseKey','trialstarttime','-append') %save our variables
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