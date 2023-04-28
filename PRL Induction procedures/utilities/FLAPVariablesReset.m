xeye=[]; %x coordinates from eyetracker
yeye=[];   %y coordinates from eyetracker
VBL_Timestamp=[]; %array to collect frame time stamp
FixCount=0;
FixatingNow=0;
EndIndex=0;
fixating=0;
counter=0;
counterannulus=0; %count 'correct fixation' frames during IsfixatingPRL3
counterflicker=0; %count 'correct fixation' frames during ForcedFixation
framecounter=0; %count overall frames during ForedFixation
showtarget=0; % counts how many frames was the target shown
trialTimedout(trial)=0; % counts how many trials timed out before response
countertarget=0; % for constrained fixation in the TRL
stimpresent=0; % starting point for constrained fixation in the TRL (stimulus not presented)
circlefix=0; %counter of frames in which the target is within the PRL
blankcounter=0; % counter of frames n which the target is outside the PRL
countgt =[];
framecont=[];
countblank=[];
blankcounter2=0;
counterflicker2=0;
turnFlickerOn=0;
TrialNum = strcat('Trial',num2str(trial));
Priority(0);
eyechecked=0; % while 0, trial loop is active
KbQueueFlush(); % flushes all the keyboard responses (resets)
stopchecking=-100;
skipcounterannulus=1;
flickerdone=0;
pretrial_time=GetSecs; % trial timing
trial_time=GetSecs;  % trial timing that gets updated later on when we have eye info (if no eye info, the trial won't move on)
newtrialtime=GetSecs; % real value to be assigned later, after flicker is done
caliblock=0;
clear EyeData
clear FixIndex
clear circlestar
clear flickerstar
clear imageRect_offsCirc
clear imageRect_offsCI
clear imageRect_offsCI2
clear imageRectMask
clear imageRect_offsCImask
clear isendo
clear startrial
clear stimstar
clear checktrialstart
clear targetflickerstar
