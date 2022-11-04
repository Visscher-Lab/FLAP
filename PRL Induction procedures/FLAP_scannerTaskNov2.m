
% Orientation Discrimination and Contour Integration task for scanner
% written by Pinar Demirayak April 2022
close all;
clear;
clc;
commandwindow
addpath([cd '/utilities']); %add folder with utilities files
%% take information from the user
try
    prompt={'Subject Name', 'Pre or Post Scan','Run Number','site Mac Laptop(2)','demo (0) or session (1)', 'left (1) or right (2) TRL?'};

    name= 'Subject Name';
    numlines=1;
    defaultanswer={'test','1', '1', '2','1','1'};
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
    coeffAdj=1;
    PreparePRLpatch % here I characterize PRL features

    % Gabor stimuli
    createGabors_Scanner

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

    %% settings for individual small gabors for contour integration stimulus

    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');

    %% draw everything on the instruction page

    stimulusdirection_leftstim=1;stimulusdirection_rightstim=2; %what are shown in left and right is set
    CIstimuliMod_ScannerIns;
    theeccentricity_Y=0;
    theeccentricity_X=PRLx*pix_deg;
    eccentricity_X(1)= theeccentricity_X;
    eccentricity_Y(1) =theeccentricity_Y ;
    InstructionShapeScanner

    %% get trigger t
    ListenChar(2);
    soundsc(sin(1:.5:1000)); % play 'ready' tone
    disp('Ready, waiting for trigger...');
    commandwindow;
    startTime = wait4T(tChar);  %wait for 't' from scanner.
    disp(['Trigger received - ' startdatetime]);

    fixationlength=10;
    fixationscriptW;
    WaitSecs(TR);
    %% Start Trials
    if Isdemo==1
        totalactiveblock=2;
    end
    for totalblock=1:totalactiveblock
        if Isdemo==1
            runnumber=1;
        end
        active=num2str(totalblock);
        activeblock=activeblockcue(totalblock,:);
        activeblockstim=eval(['activeblockstimulus' active]);% direction of gabors or being 6 or9 in both location
        runnum=num2str(runnumber);
        blocktype=activeblocktype(runnumber,totalblock);
        for trial=1:10
            trialstarttime(totalblock,trial)=GetSecs;
            Screen('TextFont',w, 'Arial');
            Screen('TextSize',w, 42);
            fixationscriptW;
            cue=activeblock(trial); %if it's 1 attend to left, if it's 2 attend right
            if cue==1
                DrawFormattedText(w, '<', 'center',540, white);
            else
                DrawFormattedText(w, '>', 'center',540, white);
            end
            CueOnsetTime=Screen('Flip',w);
            WaitSecs(0.250);
            stimulusdirection_leftstim=activeblockstim(trial,1);stimulusdirection_rightstim=activeblockstim(trial,2); %what are shown in left and right is set
            if blocktype==1 %gabors
                gaborcontrast=0.35;
                theoris =[-45 45];
                imageRect_offsleft =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
                    imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];
                imageRect_offsright =[imageRect(1)-theeccentricity_X, imageRect(2)+theeccentricity_Y,...
                    imageRect(3)-theeccentricity_X, imageRect(4)+theeccentricity_Y];
              
                if stimulusdirection_leftstim==1 %1 means right
                    Screen('DrawTexture', w, TheGabors, [], imageRect_offsleft, theoris(2),[], gaborcontrast);

                else
                    Screen('DrawTexture', w, TheGabors, [], imageRect_offsleft, theoris(1),[], gaborcontrast);
                end
                if stimulusdirection_rightstim==1 %1 means right
                    Screen('DrawTexture', w, TheGabors, [], imageRect_offsright, theoris(2),[], gaborcontrast);

                else
                    Screen('DrawTexture', w, TheGabors, [], imageRect_offsright, theoris(1),[], gaborcontrast);
                end
 
                fixationscriptW;
            else %numbers

                imageRect_offsCIleft =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(1), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(1),...
                    imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(1), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(1)];
                imageRect_offsCIleft2=imageRect_offsCIleft;
                imageRect_offsCIright =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(2), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(1),...
                    imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(2), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(1)];
                imageRect_offsCIright2=imageRect_offsCIright;
                imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);

                if stimulusdirection_rightstim==1 %1 means right
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIright'+ [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr);
                    imageRect_offsCIright2(setdiff(1:length(imageRect_offsCIright),targetcord),:)=0;
                else
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIright'+ [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr);
                    imageRect_offsCIright2(setdiff(1:length(imageRect_offsCIright),targetcord),:)=0;
                end
                if stimulusdirection_leftstim==1 %1 means right
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIleft'+ [xJitLoc2+xModLoc; yJitLoc2+yModLoc; xJitLoc2+xModLoc; yJitLoc2+yModLoc], theori2,[], Dcontr);
                    imageRect_offsCIleft2(setdiff(1:length(imageRect_offsCIleft),targetcord2),:)=0;
                else
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIleft'+ [xJitLoc2+xModLoc; yJitLoc2+yModLoc; xJitLoc2+xModLoc; yJitLoc2+yModLoc], theori2,[], Dcontr);
                    imageRect_offsCIleft2(setdiff(1:length(imageRect_offsCIleft),targetcord2),:)=0;
                end

                fixationscriptW; %fixation aids
                if cue==1 % we are showing cue during the stimulus presentation
                    DrawFormattedText(w, '<', 'center',540, white);%560
                else
                    DrawFormattedText(w, '>', 'center',540, white);
                end

            end

            StimulusOnsetTime=Screen('Flip',w); %show stimulus
            WaitSecs(10); %0.200
            fixationscriptW; %fixation aids
            ResponseFixationOnsetTime=Screen('Flip',w); %start of response time
            MaximumResponseTime=totaltrialtime-(ResponseFixationOnsetTime-trialstarttime); % maximum time to response
            ListenChar(2);
            timedout=false;
            RT(totalblock,trial)=0;ResponseType{totalblock,trial}='miss';
            if site==2
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
            elseif site==1
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
        Screen('TextSize',w, 42);
        Screen('FillRect', w, gray);
        fixationscriptW;
        DrawFormattedText(w, 'x', 'center', 550, white);%558
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