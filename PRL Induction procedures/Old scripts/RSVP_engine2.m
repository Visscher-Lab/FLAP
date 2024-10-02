clear all
addpath([cd '/utilities']); %add folder with utilities files


load RSVPmx.mat

% %sequences of events for each trial (single trial events)
% total_array_of_events=[ 1 2 5 2 5 3 5 2 5 2 5 3 5 4; 1 2 5 2 5 3 5 2 5 2 5 3 5 4];
% 
 time_of_events=[2 0.2 0.2 0.2 0.5];
% %events type
% %1= C stays on screen until response
% %2= foil
% %3= target
% %4=cue
% %5= blank
% 
% 
% mixtr= [1 2; 2 2; 1 2];
counter=0;
counter2=0;
counter3=0;
 counter4=0;
counter5=0;
% 
 trial_time=GetSecs;
 eyetime2=GetSecs;
% resetflag=1;
 mao=[];
   KbQueueCreate;
    KbQueueStart;
    
    KbName('UnifyKeyNames')
            KbQueueFlush();
% trialArray
for trial=1:length(mixtr)
   % array_of_events=total_array_of_events(mixtr(trial,1),:);
   array_of_events=trialArray{trial};
  % number_of_events=length(array_of_events)
    number_of_events=0;
   clear time_of_this_event
    while number_of_events<=length(array_of_events)
        if number_of_events==0
            number_of_events=1;
        end
        time_of_this_event(number_of_events)=time_of_events(array_of_events(number_of_events));
        % this looks into the timing of events array, looks at the array
        % of events and the counter of number of events
        cumulativeclock=sum(time_of_this_event);
        %           if  resetflag==1
        %              trial_time=GetSecs-eyetime2;
        %               resetflag=0;
        %           end
        eyetime2=GetSecs-trial_time;
        mao=[mao eyetime2];
        %if eyetime2>=time_of_this_event(number_of_events) && eyetime2<=time_of_this_event(number_of_events)
        if     (eyetime2-trial_time)<=time_of_this_event(number_of_events)
            
            if array_of_events(number_of_events)==1
                todisplay='C until response';
                counter=counter+1;
            elseif array_of_events(number_of_events)==2
                todisplay='foil';
                counter2=counter2+1;               
            elseif array_of_events(number_of_events)==3
                todisplay='target';
                counter3=counter3+1;               
            elseif array_of_events(number_of_events)==4
                todisplay='cue';
                counter4=counter4+1;
            elseif array_of_events(number_of_events)==5
                todisplay='blank';
                counter5=counter5+1;
            end
            
            %      resetflag=1;
        end
        if eyetime2>=time_of_this_event(number_of_events)
            number_of_events=number_of_events+1;
            trial_time=GetSecs;
        end
        
        [keyIsDown, keyCode] = KbQueueCheck;
        
        if sum(keyCode) ~=0
            disp('RESP')
            thekeys = find(keyCode);
            if length(thekeys)>1
                thekeys=thekeys(1);
            end
            thetimes=keyCode(thekeys);
            [secs  indfirst]=min(thetimes);
            respTime(trial)=secs;
        end
        disp(todisplay)
        
    end
end