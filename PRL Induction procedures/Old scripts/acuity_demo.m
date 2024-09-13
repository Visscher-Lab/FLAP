close all; clear all; clc;
psycfolder='/Users/pinardemirayak/Documents/MATLAB/Psychtoolbox';
addpath(genpath(psycfolder));
addpath([cd '/utilities']);
screenNumber=0;
[w, wRect] = Screen('OpenWindow', screenNumber,0.5,[0 0 1280 960],32,2);
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 20);
Screen('FillRect', w, [128 128 128]);

StartSize=2;
screencm=[69.8, 35.5];
v_d=57;
pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi));
imsize=StartSize*pix_deg;
[x,y]=meshgrid(-imsize/2:imsize/2,-imsize/2:imsize/2);
white=WhiteIndex(screenNumber);
black=BlackIndex(screenNumber);
gray=round((white+black)/2);
bg_index =round(gray*255);

%circular mask
xylim = imsize; %radius of circular mask
circle = x.^2 + y.^2 <= xylim^2;
[nrw, ncl]=size(x);
ori=90;

%C Letter
AtheLetter=imread('newletterc22.tiff');
AtheLetter=AtheLetter(:,:,1);
AtheLetter=imresize(AtheLetter,0.7);
[ll tt]=size(AtheLetter);
AtheLetter=imresize(AtheLetter,[nrw nrw],'bicubic');
theCircles=AtheLetter;
AtheLetter = double(circle) .* double(AtheLetter)+bg_index * ~double(circle);
AtheLetter=Screen('MakeTexture', w, AtheLetter);

%Circle Flanker

theCircles(1:nrw, round(nrw/2):nrw)=theCircles(nrw:-1:1, round(nrw/2):-1:1);
theCircles = double(circle) .* double(theCircles)+bg_index * ~double(circle);
theCircles=Screen('MakeTexture', w, theCircles);

%Dot Cue
theDot=imread('thedot2.tiff');
theDot=theDot(:,:,1);
[cc rr]=size(theDot);
theDot=Screen('MakeTexture', w, theDot);

%Fixation
fixationlength=10;
Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
Screen('Flip', w);

%Sound
InitializePsychSound;
pahandle = PsychPortAudio('Open', [], 1, 0, 44100, 2);
pahandle1 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
pahandle2 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
try
    [errorS freq  ] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
    [corrS freq  ] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
end

PsychPortAudio('FillBuffer', pahandle1, corrS' ); % loads data into buffer
PsychPortAudio('FillBuffer', pahandle2, errorS');

%Keyboard
[k_id, k_name] = GetKeyboardIndices();
deviceIndex =  k_id;
KbQueueCreate(deviceIndex);
KbQueueStart(deviceIndex);

%Experiment
KbName('UnifyKeyNames');
ori_ex=90;
imagelocation1_ex=[100 330 165 395]; imagelocation2_ex=[200 330 265 395]; imagelocation3_ex=[300 330 365 395]; imagelocation4_ex=[400 330 465 395];%example stimulus locations
Screen('DrawTexture',w,AtheLetter,[],imagelocation1_ex,ori_ex);Screen('DrawTexture',w,AtheLetter,[],imagelocation2_ex,ori_ex+180);Screen('DrawTexture',w,AtheLetter,[],imagelocation3_ex,ori_ex+270);Screen('DrawTexture',w,AtheLetter,[],imagelocation4_ex,ori_ex+90);
DrawFormattedText(w, 'Please keep your eyes at the center of the screen.\n \nTarget stimulus -C- can appear in four main directions: right, left, up and down.\n \nPlease indicate the direction of the gap of the C using the arrow keys as quick and accurate as possible.\n \nAs soon as you respond, you will have an auditory feedback.\n \nPossible stimuli are: \n \n \n  \n \n \n \n Press any key to start', 100, 100, white);
Screen('Flip', w);
KbQueueWait;
KbQueueFlush();
for t=1:10
    
    r=randi([1 4],1); % randomly assign PRL locations
    if r==1
        imagelocation=[(wRect(3)/2)-(3*cc)-cc/2 (wRect(4)/2)-cc/2 (wRect(3)/2)-(3*cc)+cc/2 (wRect(4)/2)+cc/2];%left
    elseif r==2
        imagelocation=[(wRect(3)/2)+(3*cc)-cc/2 (wRect(4)/2)-cc/2 (wRect(3)/2)+(3*cc)+cc/2 (wRect(4)/2)+cc/2];%right
    elseif r==3
        imagelocation=[(wRect(3)/2)-cc/2 (wRect(4)/2)-(3*cc)-cc/2 (wRect(3)/2)+cc/2 (wRect(4)/2)-(3*cc)+cc/2];%up
    else
        imagelocation=[(wRect(3)/2)-cc/2 (wRect(4)/2)+(3*cc)-cc/2 (wRect(3)/2)+cc/2 (wRect(4)/2)+(3*cc)+cc/2];%down
    end
    ro=randi([0 3],1);%randomly assign ori
    ori=ro*90;
    
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('Flip', w);
    WaitSecs(0.05);
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('DrawTexture',w, theDot, [], imagelocation,0,[],1);
    Screen('Flip', w);
    WaitSecs(0.05);
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('Flip', w);
    WaitSecs(0.5);
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('DrawTexture',w, AtheLetter, [], imagelocation,ori,[],1);
    Screen('Flip', w);
    WaitSecs(0.5);
    StimTime=GetSecs;
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('Flip', w);
    WaitSecs(0.5);
    %Response
    [keyIsDown,keysecs,keyCode] = KbQueueCheck;
    conditions(1)=logical(ori==180 && keyCode(KbName('LeftArrow')));conditions(2)=logical(ori==0 && keyCode(KbName('RightArrow')));conditions(3)=logical(ori==270 && keyCode(KbName('UpArrow'))); conditions(4)=logical(ori==90 && keyCode(KbName('DownArrow')));
    if keyIsDown==1
        if any(conditions==1)
            PsychPortAudio('Start', pahandle1);
            KbQueueFlush();
        elseif keyCode(KbName('ESCAPE'))
            Screen('CloseAll');
        else
            PsychPortAudio('Start', pahandle2);
            KbQueueFlush();
        end
    end
    TrialEndTime=GetSecs;
    WaitSecs(3-(TrialEndTime-StimTime));
    KbQueueFlush();
end
WaitSecs(2);
PsychPortAudio('Close', pahandle);
Screen('CloseAll');
