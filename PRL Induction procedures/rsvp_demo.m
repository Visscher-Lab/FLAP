close all; clear all; clc;
psycfolder='/Users/pinardemirayak/Documents/MATLAB/Psychtoolbox';
addpath(genpath(psycfolder));
addpath([cd '/utilities']);
screenNumber=0;
[w, wRect] = PsychImaging('OpenWindow', screenNumber,0.5,[0 0 1280 960],32,2);
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
%HideCursor;
KbName('UnifyKeyNames');
ori_ex=90;
imagelocation1_ex=[100 350 165 415]; imagelocation2_ex=[200 350 265 415]; imagelocation3_ex=[300 350 365 415]; imagelocation4_ex=[400 350 465 415];%example stimulus locations
Screen('DrawTexture',w,AtheLetter,[],imagelocation1_ex,ori_ex);Screen('DrawTexture',w,AtheLetter,[],imagelocation2_ex,ori_ex+180);Screen('DrawTexture',w,AtheLetter,[],imagelocation3_ex,ori_ex+270);Screen('DrawTexture',w,AtheLetter,[],imagelocation4_ex,ori_ex+90);
DrawFormattedText(w, 'Please keep your eyes at the center of the screen.\n \nThere will be four circles at right, left, up and down.\n \nA visual cue on a circle will indicate the next location of the target.\n \nA series of stimuli including Os and Cs will be shown in one of the circles.\n \nPlease indicate the direction of the gap of the C using the arrow keys as quick and accurate as possible.\n \nAs soon as you respond, you will have a auditory feedback.\n\n  \n \n \n \n Press any key to start', 100, 100, white);
Screen('Flip', w);
KbQueueWait;
KbQueueFlush();
circle1=[(wRect(3)/2)-(7*cc)-cc/2 (wRect(4)/2)-(2*cc)-cc/2 (wRect(3)/2)-(2*cc)-cc/2 (wRect(4)/2)+(2*cc)+cc/2];%left
circle2=[(wRect(3)/2)+(2*cc)+cc/2 (wRect(4)/2)-(2*cc)-cc/2 (wRect(3)/2)+(7*cc)+cc/2 (wRect(4)/2)+(2*cc)+cc/2];%right
circle3=[(wRect(3)/2)-(2*cc)-cc/2 (wRect(4)/2)-(7*cc)-cc/2 (wRect(3)/2)+(2*cc)+cc/2 (wRect(4)/2)-(2*cc)-cc/2];%up
circle4=[(wRect(3)/2)-(2*cc)-cc/2 (wRect(4)/2)+(2*cc)+cc/2 (wRect(3)/2)+(2*cc)+cc/2 (wRect(4)/2)+(7*cc)+cc/2];%down
Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
Screen('FrameOval', w,white, circle1, 5, 5);
Screen('FrameOval', w,white, circle2, 5, 5);
Screen('FrameOval', w,white, circle3, 5, 5);
Screen('FrameOval', w,white, circle4, 5, 5);
Screen('Flip', w);
WaitSecs(3);
for t=1:5
    r=randi([1 4],1); % randomly assign PRL locations for stimulus
    if r==1
        imagelocation1=[(wRect(3)/2)-(5*cc)-cc/2 (wRect(4)/2)-(3*cc)-cc/2 (wRect(3)/2)-(5*cc)+cc/2 (wRect(4)/2)-(3*cc)+cc/2];%left
        imagelocation2=[(wRect(3)/2)-(5*cc)-cc/2 (wRect(4)/2)-cc/2 (wRect(3)/2)-(5*cc)+cc/2 (wRect(4)/2)+cc/2];
        imagelocation3=[(wRect(3)/2)-(5*cc)-cc/2 (wRect(4)/2)+(3*cc)-cc/2 (wRect(3)/2)-(5*cc)+cc/2 (wRect(4)/2)+(3*cc)+cc/2];
    elseif r==2
        imagelocation1=[(wRect(3)/2)+(5*cc)-cc/2 (wRect(4)/2)-(3*cc)-cc/2 (wRect(3)/2)+(5*cc)+cc/2 (wRect(4)/2)-(3*cc)+cc/2];%right
        imagelocation2=[(wRect(3)/2)+(5*cc)-cc/2 (wRect(4)/2)-cc/2 (wRect(3)/2)+(5*cc)+cc/2 (wRect(4)/2)+cc/2];
        imagelocation3=[(wRect(3)/2)+(5*cc)-cc/2 (wRect(4)/2)+(3*cc)-cc/2 (wRect(3)/2)+(5*cc)+cc/2 (wRect(4)/2)+(3*cc)+cc/2];
    elseif r==3
        imagelocation1=[(wRect(3)/2)-(3*cc)-cc/2 (wRect(4)/2)-(5*cc)-cc/2 (wRect(3)/2)-(3*cc)+cc/2 (wRect(4)/2)-(5*cc)+cc/2];%up
        imagelocation2=[(wRect(3)/2)-cc/2 (wRect(4)/2)-(5*cc)-cc/2 (wRect(3)/2)+cc/2 (wRect(4)/2)-(5*cc)+cc/2];
        imagelocation3=[(wRect(3)/2)+(3*cc)-cc/2 (wRect(4)/2)-(5*cc)-cc/2 (wRect(3)/2)+(3*cc)+cc/2 (wRect(4)/2)-(5*cc)+cc/2];
    else
        imagelocation1=[(wRect(3)/2)-(3*cc)-cc/2 (wRect(4)/2)+(5*cc)-cc/2 (wRect(3)/2)-(3*cc)+cc/2 (wRect(4)/2)+(5*cc)+cc/2];%down
        imagelocation2=[(wRect(3)/2)-cc/2 (wRect(4)/2)+(5*cc)-cc/2 (wRect(3)/2)+cc/2 (wRect(4)/2)+(5*cc)+cc/2];
        imagelocation3=[(wRect(3)/2)+(3*cc)-cc/2 (wRect(4)/2)+(5*cc)-cc/2 (wRect(3)/2)+(3*cc)+cc/2 (wRect(4)/2)+(5*cc)+cc/2];
    end
    ro=randi([0 3],1);%randomly assign to which side should C look at to
    ori=ro*90;
    
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('FrameOval', w,white, circle1, 5, 5);
    Screen('FrameOval', w,white, circle2, 5, 5);
    Screen('FrameOval', w,white, circle3, 5, 5);
    Screen('FrameOval', w,white, circle4, 5, 5);
    Screen('Flip', w);
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('FrameOval', w,white, circle1, 5, 5);
    Screen('FrameOval', w,white, circle2, 5, 5);
    Screen('FrameOval', w,white, circle3, 5, 5);
    Screen('FrameOval', w,white, circle4, 5, 5);
    Screen('Flip', w);
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('FrameOval', w,white, circle1, 5, 5);
    Screen('FrameOval', w,white, circle2, 5, 5);
    Screen('FrameOval', w,white, circle3, 5, 5);
    Screen('FrameOval', w,white, circle4, 5, 5);
    Screen('DrawTexture',w, theCircles, [], imagelocation2,0,[],1);
    Screen('Flip', w);
    WaitSecs(0.3)
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('FrameOval', w,white, circle1, 5, 5);
    Screen('FrameOval', w,white, circle2, 5, 5);
    Screen('FrameOval', w,white, circle3, 5, 5);
    Screen('FrameOval', w,white, circle4, 5, 5);
    Screen('Flip', w);
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('FrameOval', w,white, circle1, 5, 5);
    Screen('FrameOval', w,white, circle2, 5, 5);
    Screen('FrameOval', w,white, circle3, 5, 5);
    Screen('FrameOval', w,white, circle4, 5, 5);
    Screen('DrawTexture',w, AtheLetter, [], imagelocation2,ori,[],1);
    Screen('Flip', w);
    WaitSecs(0.3)
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('FrameOval', w,white, circle1, 5, 5);
    Screen('FrameOval', w,white, circle2, 5, 5);
    Screen('FrameOval', w,white, circle3, 5, 5);
    Screen('FrameOval', w,white, circle4, 5, 5);
    Screen('Flip', w);
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('FrameOval', w,white, circle1, 5, 5);
    Screen('FrameOval', w,white, circle2, 5, 5);
    Screen('FrameOval', w,white, circle3, 5, 5);
    Screen('FrameOval', w,white, circle4, 5, 5);
    Screen('DrawTexture',w, theCircles, [], imagelocation2,0,[],1);
    Screen('Flip', w);
    WaitSecs(0.3)
    StimTime=GetSecs;
    Screen('DrawLine', w, white, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
    Screen('DrawLine', w, white, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
    Screen('FrameOval', w,white, circle1, 5, 5);
    Screen('FrameOval', w,white, circle2, 5, 5);
    Screen('FrameOval', w,white, circle3, 5, 5);
    Screen('FrameOval', w,white, circle4, 5, 5);
    Screen('Flip', w);
    WaitSecs(0.5);
    %Response and feedback
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
