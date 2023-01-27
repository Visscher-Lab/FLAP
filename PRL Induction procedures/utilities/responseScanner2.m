% This script gets responses from response box of the scanner
% written by Pinar Demirayak, Dec 2022-Jan 2023
fixationscriptW;
%RT(totalblock,trial)=0;
ResponseType{totalblock,trial}='miss';
RTraw(totalblock,trial)=0;
ResponseKey{totalblock,trial}=0;
if cue==1 % we are showing cue during the stimulus presentation
    DrawFormattedText(w, '<', 'center',cueloc, white);%688
else
    DrawFormattedText(w, '>', 'center',cueloc, white);
end
                    while GetSecs<trialstarttime(totalblock,trial)+0.250
                    end
StimulusOnsetTime(totalblock,trial)=Screen('Flip',w); %show stimulus
ListenChar(2);
%while GetSecs<StimulusOnsetTime(totalblock,trial)+0.200 %stimulus presentation time is 200 ms
while GetSecs<trialstarttime(totalblock,trial)+0.450 %stimulus presentation time is 200 ms
    [ keyIsDown, keyTime, keyCode ] = KbCheck;
    responsekey = find(keyCode, 1);
    if keyIsDown && responsekey==leftfingerresp ||keyIsDown && responsekey==rightfingerresp %if participant gives a response during presentation time
        RTraw(totalblock,trial)=keyTime;
        %RT(totalblock,trial)=keyTime-StimulusOnsetTime(totalblock,trial);
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
        %while GetSecs<200-(keyTime-StimulusOnsetTime(totalblock,trial))
        while GetSecs<450-(RTraw(totalblock,trial)-trialstarttime(totalblock,trial))
        end
        break;
    end
end
fixationscriptW; %fixation aids
ResponseFixationOnsetTime(totalblock,trial)=Screen('Flip',w); %start of response time
%MaximumResponseTime=totaltrialtime-(ResponseFixationOnsetTime-trialstarttime(totalblock,trial)); % maximum time to response
MaximumResponseTime(totalblock,trial)=totaltrialtime-(StimulusOnsetTime(totalblock,trial)-trialstarttime(totalblock,trial)); % maximum time to response if they respond during stimulus presentation
MaximumResponseTime2(totalblock,trial)=totaltrialtime-(ResponseFixationOnsetTime(totalblock,trial)-trialstarttime(totalblock,trial)); % maximum time to response if they wait for the response slide
timedout=false;
if RTraw(totalblock,trial)==0 %no key press during stimulus presentation
    %     if   site==2
    %         while ~timedout
    %             keyTime=GetSecs;
    %             responsekey=KbName(ch);
    %             if CharAvail && responsekey==leftfingerresp ||CharAvail && responsekey==rightfingerresp
    %                 [ch, keyTime] = GetChar;
    %                 %responsekey=KbName(ch);
    %                 RTraw(totalblock,trial)=keyTime.secs;
    %                 RT(totalblock,trial)=abs(keyTime.secs-StimulusOnsetTime(totalblock,trial)); %reaction time
    %                 ResponseKey{totalblock,trial}=responsekey;
    %                 conditions(1)=logical(cue==1 && stimulusdirection_leftstim==1 && responsekey==rightfingerresp);conditions(2)=logical(cue==1 && stimulusdirection_leftstim==2 && responsekey==leftfingerresp);conditions(3)=logical(cue==2 && stimulusdirection_rightstim==1 && responsekey==rightfingerresp);conditions(4)=logical(cue==2 && stimulusdirection_rightstim==2 && responsekey==leftfingerresp); %conditions that are true
    %                 if any(conditions)==1
    %                     PsychPortAudio('Start', pahandle1); % feedback for true response
    %                     ResponseType{totalblock,trial}='correct';
    %                 else
    %                     PsychPortAudio('Start', pahandle2); %feedback for false response
    %                     ResponseType{totalblock,trial}='false';
    %                 end
    %                 clear conditions;
    %                 FlushEvents;
    %                 %break;
    %             end
    %
    %             if((keyTime-ResponseFixationOnsetTime(totalblock,trial))>MaximumResponseTime2(totalblock,trial)),timedout=true;
    %             end
    %
    %         end
    %     elseif site==1 || site==3
    %     while ~timedout
    while GetSecs<(ResponseFixationOnsetTime(totalblock,trial)+MaximumResponseTime2(totalblock,trial))
        [ keyIsDown, keyTime, keyCode ] = KbCheck;
        responsekey = find(keyCode, 1);
        if keyIsDown && responsekey==leftfingerresp ||keyIsDown && responsekey==rightfingerresp
            RTraw(totalblock,trial)=keyTime;
            %RT(totalblock,trial)=keyTime-ResponseFixationOnsetTime;
            %RT(totalblock,trial)=keyTime-StimulusOnsetTime(totalblock,trial);
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

            %break;
            while GetSecs<RTraw(totalblock,trial)+(MaximumResponseTime2(totalblock,trial)-(RTraw(totalblock,trial)-ResponseFixationOnsetTime(totalblock,trial)))
            end
            break;
        end
        %         if((keyTime-ResponseFixationOnsetTime(totalblock,trial))>MaximumResponseTime2(totalblock,trial)),timedout=true;
        %         end
        %         if GetSecs>(ResponseFixationOnsetTime+MaximumResponseTime2)
        %            % timedout=true;
        %             break;
        %         end
    end
    %end
else % key was pressed during stimulus presentation
    while GetSecs<(ResponseFixationOnsetTime(totalblock,trial)+MaximumResponseTime2(totalblock,trial))
    end
    afterafterresponseduringpresentation(totalblock,trial)=GetSecs;
end
%%% end
if exist ('responsekey','var')
    clear responsekey keyIsDown keyTime keyCode;
end