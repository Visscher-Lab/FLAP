% Trailmaking.m
% An example of AB trailmaking task with practice screens
% Respond by clicking each target location
% written for Psychtoolbox 3  by AS 10/30/2022

clear;close all
Screen('Preference', 'SkipSyncTests', 1) %if needed
commandwindow;
AssertOpenGL;

%Gets Subject and Session Info and Creates a Unique File Name
SUBJECT=InputName('Subect');
SESSION=InputName('Session');
uhr = clock;
c = uhr;
baseName=[SUBJECT 'Trails' '_' SESSION '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];

%sets colors for stimuli
BackColor=255;
CircleColorOut=0;
CircleColorFill=BackColor;
CircleColorFillResp=127;
LetterColor=0;
LineColor=0;

%Sets up the screen
screens=Screen('Screens');
screenNumber=max(screens);
[w, rect]=Screen('OpenWindow',screenNumber,BackColor);
center=[rect(3)/2 rect(4)/2];

%Adjusts to ppd, requires  width and distance to screen
mon_width= 69.8;
v_dist=70;
fix_r=0.2;
ppd = round(pi * rect(3) / atan(mon_width/v_dist/2) / 360);
fix_cord = [center-fix_r*ppd center+fix_r*ppd];

%if mouse calibration is needed
MouseCalib=0;
% oldResolution=Screen( 'Resolution',screenNumber,1920,1080);
% Mscreen=SetResolution(screenNumber, oldResolution);
Mscreen=[1920 1080];

%sets and saves the random seed
randseedvar=100*clock;
rand('twister',sum(randseedvar));

%Calls the script that has the stimulus details for the trails task
StimDetailsTrails;

%sets times for each phase [A_demo, A, B_demo, B]
Maxtimes=[2 5 2 5]*60; %specified in minutes converted to seconds

%sets stimulus details
textsize=20;
Screen('TextSize',w,textsize );
Csize=round(.75*ppd) ; %specifies radius of the circles in ppd
RespTol=1*ppd; %specifies radius of the circles in ppd
%sets up keyboard
KbName('UnifyKeyNames');
KbQueueCreate;
KbQueueStart;
escapeKey = KbName('ESCAPE');

Screen('FillRect',w,BackColor);
for block=1:4  %loo through the 4 phases
    
    %figu res out locations
    stimx=round(TheCoords{block}(:,1)*rect(3)); %pull out x cords
    stimy=round(TheCoords{block}(:,2)*rect(4)); %pull out y cords
    TheCircMat=[stimx-Csize,stimy-Csize, stimx+Csize,stimy+Csize]'; %this is the array for the cricles
    for i=1:(length(stimx)-1) %this is the array for the lines
        TheLinesMat(1,i*2-1)=stimx(i);
        TheLinesMat(2,i*2-1)=stimy(i);
        TheLinesMat(1,i*2)=stimx(i+1);
        TheLinesMat(2,i*2)=stimy(i+1);
    end
    CircFill=ones(3,length(stimx))*CircleColorFill;
    
    
    HideCursor(); %hides the cursor
    TrailsInstructions(block,w,BackColor,LetterColor ) %instruction screen for each block
    ShowCursor(); %Show the cursor
    
    %sets up the main task loop
    numresp=0; %reset number of responses entered
    startblocktime(block)=GetSecs;
    while ( (numresp<length(stimx))&&   (startblocktime(block)  -GetSecs<Maxtimes(block) ) )  %loop through trial in each block
        Screen('FillRect',w,BackColor);
        %draw lines
        if numresp>=2
            Screen('DrawLines',w,TheLinesMat(:,1:2*(numresp-1)) ,2, LineColor)
        end
        %draw circles
        Screen('FillOval',w,CircFill,TheCircMat); %fills circles to cover lines in the middle
        Screen('FrameOval',w,CircleColorOut,TheCircMat ); %draws circles
        for i=1:length(stimx)  %draws text
            if block<=2
                Screen('DrawText', w, num2str(i), stimx(i)-textsize/2, stimy(i)-textsize/2, LetterColor);
            else
                if mod(i,2)
                    Screen('DrawText', w, num2str(round(i/2)), stimx(i)-textsize/2, stimy(i)-textsize/2, LetterColor);
                else
                    Screen('DrawText', w , Letters(round(i/2)), stimx(i)-textsize/2, stimy(i)-textsize/2, LetterColor);
                end
            end
        end
        numresp=numresp+1; %increment the number of response counter
        StartTime(numresp,block)=Screen('Flip',w) %now everything goes onto the screen
        %now get the response
        resp = 0;
        while (~resp  && (startblocktime(block) -GetSecs<Maxtimes(block) ) )
            [x,y,buttons] = GetMouse(); % In while-loop, rapidly and continuously check if mouse button being pressed.
            
            if MouseCalib
                x=round(x*rect(3)/Mscreen(1));
                y=round(y*rect(4)/Mscreen(2));
            end
            if any(buttons)
                if (  (x>(TheCircMat(1,numresp)-RespTol)) && (y>(TheCircMat(2,numresp)-RespTol)) && (x<(TheCircMat(3,numresp)+RespTol)) && (y< (TheCircMat(4,numresp )+RespTol)) )
                    RespTime(numresp,block)=GetSecs-StartTime(numresp,block);
                    CircFill(:,1:numresp)=CircleColorFillResp; %changes circle fill to show response
                    resp=1;
                else
                    beep; %alert poor response
                    %wait for the button to be lifted
                end
            end
            while (any(buttons) == 1  && (startblocktime(block)     -GetSecs<Maxtimes(block) ) )
                [x,y,buttons] = GetMouse(); % In while-loop, rapidly and continuously check if mouse button being pressed.
                WaitSecs(.002);
            end
            WaitSecs(.002);
            
        end
    end
    %thank them at the end of each block
    oldTextSize=Screen('TextSize', w, 80);
    DrawFormattedText(w,'Great Job','center','center',LetterColor);
    oldTextSize=Screen('TextSize', w, oldTextSize);
    Screen('Flip',w)
    WaitSecs(1)
    Screen('Flip',w)
    save(baseName) %at the end of each block save the data
end


ShowCursor(); %shows the cursor
Screen('CloseAll'); %Closes Screen

