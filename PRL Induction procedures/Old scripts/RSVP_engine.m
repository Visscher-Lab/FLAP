clear all

%sequences of events for each trial (single trial events)
total_array_of_events=[ 1 2 5 2 5 3 5 2 5 2 5 3 5 4; 1 2 5 2 5 3 5 2 5 2 5 3 5 4];

time_of_events=[2 0.2 0.2 0.2 0.5];
%events type
%1= C stays on screen until response
%2= foil
%3= target
%4=cue
%5= blank


mixtr= [1 2; 2 2; 1 2];
counter=0;
counter2=0;
counter3=0;
counter4=0;
counter5=0;

trial_time=GetSecs;
thisclock=GetSecs;
number_of_events=0;
resetflag=1;
mao=[];
   KbQueueCreate;
    KbQueueStart;
    
    KbName('UnifyKeyNames')
            KbQueueFlush();

for trial=1:length(mixtr)
    array_of_events=total_array_of_events(mixtr(trial,1),:);
    while number_of_events<=length(array_of_events)
        if number_of_events==0
            number_of_events=1;
        end
        time_of_this_event(number_of_events)=time_of_events(array_of_events(number_of_events));
        % this looks into the timing of events array, looks at the array
        % of events and the counter of number of events
        cumulativeclock=sum(time_of_this_event);
        %           if  resetflag==1
        %              trial_time=GetSecs-thisclock;
        %               resetflag=0;
        %           end
        thisclock=GetSecs-trial_time;
        mao=[mao thisclock];
        %if thisclock>=time_of_this_event(number_of_events) && thisclock<=time_of_this_event(number_of_events)
        if     (thisclock-trial_time)<=time_of_this_event(number_of_events)
            
            if array_of_events(number_of_events)==1
                disp('C until response')
                counter=counter+1;
            elseif array_of_events(number_of_events)==2
                disp('foil')
                counter2=counter2+1;
                
            elseif array_of_events(number_of_events)==3
                disp('target')
                counter3=counter3+1;
                
            elseif array_of_events(number_of_events)==4
                disp('cue')
                counter4=counter4+1;
            elseif array_of_events(number_of_events)==5
                disp('blank')
                counter5=counter5+1;
            end
            
            %      resetflag=1;
        end
        if thisclock>=time_of_this_event(number_of_events)
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
    end
end