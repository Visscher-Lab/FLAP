fixationscriptW;
if cue==1 % we are showing cue during the stimulus presentation
    DrawFormattedText(w, '<', 'center',cueloc, white);%688
else
    DrawFormattedText(w, '>', 'center',cueloc, white);
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
            conditions(1)=logical(cue==1 && stimulusdirection_leftstim_num==1 && responsekey==leftfingerresp);conditions(2)=logical(cue==1 && stimulusdirection_leftstim_num==2 && responsekey==rightfingerresp);conditions(3)=logical(cue==2 && stimulusdirection_rightstim_num==1 && responsekey==leftfingerresp);conditions(4)=logical(cue==2 && stimulusdirection_rightstim_num==2 && responsekey==rightfingerresp); %conditions that are true
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
            conditions(1)=logical(cue==1 && stimulusdirection_leftstim==1 && responsekey==rightfingerresp);conditions(2)=logical(cue==1 && stimulusdirection_leftstim==2 && responsekey==leftfingerresp);conditions(3)=logical(cue==2 && stimulusdirection_rightstim==1 && responsekey==rightfingerresp);conditions(4)=logical(cue==2 && stimulusdirection_rightstim==2 && responsekey==leftfingerresp); %conditions that are true
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
            conditions(1)=logical(cue==1 && stimulusdirection_leftstim==1 && responsekey==rightfingerresp);conditions(2)=logical(cue==1 && stimulusdirection_leftstim==2 && responsekey==leftfingerresp);conditions(3)=logical(cue==2 && stimulusdirection_rightstim==1 && responsekey==rightfingerresp);conditions(4)=logical(cue==2 && stimulusdirection_rightstim==2 && responsekey==leftfingerresp); %conditions that are true
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
if exist ('responsekey','var');
clear responsekey;
end