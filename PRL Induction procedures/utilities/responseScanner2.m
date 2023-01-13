fixationscriptW;
RT(totalblock,trial)=0;ResponseType{totalblock,trial}='miss';RTraw=0;ResponseKey{totalblock,trial}=0;
if cue==1 % we are showing cue during the stimulus presentation
    DrawFormattedText(w, '<', 'center',cueloc, white);%688
else
    DrawFormattedText(w, '>', 'center',cueloc, white);
end
StimulusOnsetTime=Screen('Flip',w); %show stimulus
ListenChar(2);
while GetSecs<StimulusOnsetTime+0.200 %stimulus presentation time is 200 ms
    [ keyIsDown, keyTime, keyCode ] = KbCheck;
    responsekey = find(keyCode, 1);
    if keyIsDown
        RTraw(totalblock,trial)=keyTime;
        RT(totalblock,trial)=keyTime-StimulusOnsetTime;
        ResponseKey{totalblock,trial}=KbName(responsekey);
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
        if exist ('responsekey','var')
            clear responsekey;
        end
        break;
    end
end
fixationscriptW; %fixation aids
ResponseFixationOnsetTime=Screen('Flip',w); %start of response time
%MaximumResponseTime=totaltrialtime-(ResponseFixationOnsetTime-trialstarttime(totalblock,trial)); % maximum time to response
MaximumResponseTime=totaltrialtime-(StimulusOnsetTime-trialstarttime(totalblock,trial)); % maximum time to response if they respond during stimulus presentation
MaximumResponseTime2=totaltrialtime-(ResponseFixationOnsetTime-trialstarttime(totalblock,trial)); % maximum time to response if they wait for the response slide
timedout=false;
if RTraw==0
    if site==1
        while ~timedout
            [ keyIsDown, keyTime, keyCode ] = KbCheck;
            responsekey = find(keyCode, 1);
            if keyIsDown
                RTraw(totalblock,trial)=keyTime;
                RT(totalblock,trial)=keyTime-StimulusOnsetTime;
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
            if((keyTime-ResponseFixationOnsetTime)>MaximumResponseTime2),timedout=true;
            end
        end
    elseif   site==2
        while ~timedout
            keyTime=GetSecs;
            if CharAvail
                [ch, keyTime] = GetChar;
                responsekey=KbName(ch);
                RTraw(totalblock,trial)=keyTime.secs;
                RT(totalblock,trial)=abs(keyTime.secs-StimulusOnsetTime); %reaction time
                ResponseKey{totalblock,trial}=responsekey;
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

            if((keyTime-ResponseFixationOnsetTime)>MaximumResponseTime2),timedout=true;
            end

        end
    elseif site==3
        while ~timedout
            [ keyIsDown, keyTime, keyCode ] = KbCheck;
            if keyIsDown && responsekey==leftfingerresp ||responsekey==rightfingerresp
                responsekey = find(keyCode, 1);
                RTraw(totalblock,trial)=keyTime;
                %RT(totalblock,trial)=keyTime-ResponseFixationOnsetTime;
                RT(totalblock,trial)=keyTime-StimulusOnsetTime;
                ResponseKey{totalblock,trial}=KbName(responsekey);
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
            if((keyTime-ResponseFixationOnsetTime)>MaximumResponseTime2),timedout=true;
            end
        end
    end
else
    while (keyTime-StimulusOnsetTime)>MaximumResponseTime
    end
end
% end
if exist ('responsekey','var');
    clear responsekey;
end