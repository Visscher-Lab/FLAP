% Contrast threshold measurement with randomized position of the target -
% wait until response
close all; clear all; clc;
commandwindow


prompt={'Subject Name'};

name= 'Subject Name';
numlines=1;
defaultanswer={'test' };
answer=inputdlg(prompt,name,numlines,defaultanswer);
if isempty(answer)
    return;
end;

SUBJECT = answer{1,:}; %Gets Subject Name

c = clock; %Current date and time as date vector. [year month day hour minute seconds]
%create a folder if it doesn't exist already
if exist('data')==0
    mkdir('data')
end;
baseName=['./data/' SUBJECT '_CI2_' num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; %makes unique filename

Screen('Preference', 'SkipSyncTests', 1);
PC=getComputerName();

SS=[1.6 .8]
Cont= [1 .3]

numblock=6*4;
blocksize=36; % stimulus presentations per block
numtrial=blocksize*numblock;

screencm=[24 18];
v_d=57;

closescript=0;
stimdur=.5
oval_thick=10; %thickness of oval


KbQueueCreate;
KbQueueStart;


if ispc
    escapeKey = KbName('esc');	% quit key
elseif ismac
    escapeKey = KbName('ESCAPE');	% quit key
end


%% psychtoobox settings
AssertOpenGL;
screenNumber=max(Screen('Screens'));
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput');
[w, wRect]=PsychImaging('OpenWindow',screenNumber, 0,[],32,2);
%debug window
%[w, wRect] = PsychImaging('OpenWindow', screenNumber, 0.5,[0 0 640480],32,2);
%ScreenParameters=Screen('Resolution', screenNumber); %close all
%struct.res=[ScreenParameters.width ScreenParameters.height];
Nlinear_lut = repmat((linspace(0,1,256).^(1/2.2))',1,3);
Screen('LoadNormalizedGammaTable',w,Nlinear_lut);  % linearise the graphics card's LUT

Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
white=WhiteIndex(screenNumber);
black=BlackIndex(screenNumber);
gray=round((white+black)/2);
if gray == white
    gray=white / 2;
end;
inc=1;
theseed=sum(100*clock);
rand('twister',theseed );
ifi = Screen('GetFlipInterval', w);
if ifi==0
    ifi=1/75;
end
% SOUND
InitializePsychSound;
pahandle = PsychPortAudio('Open', [], 1, 1, 44100, 2);
[errorS freq  ] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
[corrS freq  ] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script

%% STAIRCASE
cndt=2;
ca=2;
thresh(1:cndt, 1:ca)=1;
reversals(1:cndt, 1:ca)=0;
isreversals(1:cndt, 1:ca)=0;
%shouldn't 'thresh' start from 5 or 10 to allow for errors to move back along
%the fixedstepsizes?
staircounter(1:cndt, 1:ca)=0;
corrcounter(1:cndt, 1:ca)=0;
wrongcounter(1:cndt, 1:ca)=0;
% Threshold -> 79%
sc.up = 2;                          % # of incorrect answers to go one step up
sc.down = 6;                        % # of correct answers to go one step down

max_transp=0.3; %could be the same as max_contrast if the performance between faces and gabors are
%similar


%% gabor settings and fixation point

fixationlength = 10; % pixels

%Load  images

StimuliFolder='./Stimuli/'; %to be updated! AS now updated.
StimRlist={'d0ori*right*','*right*jit7*','*right*jit9*','*right*jit11*','*right*jit13*'}
StimLlist={'d0ori*left*','*left*jit7*','*left*jit9*','*left*jit11*','*left*jit13*'}


for i=1:length(StimRlist)
    StimL{i}=dir([StimuliFolder StimLlist{i}]);
    StimR{i}=dir([StimuliFolder StimRlist{i}]);
    for j=1:length(StimL{i})
        inputImageL=rgb2gray(imread([StimuliFolder  StimL{i}(j).name]));
        inputImageR=rgb2gray(imread([StimuliFolder  StimR{i}(j).name]));
        TheStim(i,1,j)=Screen('MakeTexture', w, inputImageL-(inputImageL(1,1)-127));
        TheStim(i,2,j)=Screen('MakeTexture', w, inputImageR-(inputImageR(1,1)-127));
    end
end


%% main loop
HideCursor;
counter = 0;

% Select specific text font, style and size:
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
%     Screen('TextStyle', w, 1+2);
Screen('FillRect', w, gray);
colorfixation = white;
DrawFormattedText(w, 'Press Left key when tilted Left  \n \n Press Right key when tilted Right \n \n \n \n Press any key to start', 'center', 'center', white);
Screen('Flip', w);
KbQueueWait;
Screen('Flip', w);

RespType(1) = KbName('LeftArrow');
RespType(2) = KbName('RightArrow');


for trial=1:numtrial
    
    if   (mod(trial,blocksize)==1)
        if trial==1
            
        else
            interblock_instruction;
        end
    end
    
    
    
    theans(trial)=randi(2); %generates answer for this trial
    ts(trial)=randi(j);
    Tc=mod(floor((trial-1)/(2*blocksize)),2)+1;
    Ts=mod(floor((trial-1)/blocksize),2)+1;
    
    contr = Cont(Tc);
    
    sz=SS(Ts);
    y=sz*size(inputImageL,1);
    x=sz*size(inputImageL,2);
    imsize=[(wRect(3)/2-x) (wRect(4)/2-y) (wRect(3)/2+x) (wRect(4)/2+y)]
    
    priorityLevel=MaxPriority(w);
    
    Screen('DrawTexture', w, TheStim(thresh(Ts,Tc),theans(trial),ts(trial)), [], imsize, [],[], contr );
    stim_start = Screen('Flip', w);
    KbQueueFlush()
    
%     stim_end = Screen('Flip', w, stim_start +stimdur);
    Priority(0);
    
    
    % collect the response
    [keyIsDown, keyCode] = KbQueueCheck;
    while keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(escapeKey)== 0
        [keyIsDown, keyCode] = KbQueueCheck;
        WaitSecs(0.001); %Need this in the loop to avoid overloading the system
    end;
        stim_end = Screen('Flip', w);

    thekeys = find(keyCode);
    thetimes=keyCode(thekeys);
    [secs  indfirst]=min(thetimes);
    
    %Screen('Close', texture);
    % code the response
    foo=(RespType==thekeys);
    
    staircounter(Ts,Tc)=staircounter(Ts,Tc)+1;
    Threshlist(Ts,Tc,staircounter(Ts,Tc))=thresh(Ts,Tc);
    
    if foo(theans(trial))
        resp = 1;
        corrcounter(Ts,Tc)=corrcounter(Ts,Tc)+1;
        wrongcounter(Ts,Tc)=0;
        PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
        if corrcounter(Ts,Tc)>=sc.down
            thresh(Ts,Tc)=thresh(Ts,Tc) +1;
            thresh(Ts,Tc)=min( thresh(Ts,Tc),length(StimRlist));
            corrcounter(Ts,Tc)=0;
            wrongcounter(Ts,Tc)=0;
        end
    elseif (thekeys==escapeKey) % esc pressed
        closescript = 1;
        break;
    else
        resp = 0;
        wrongcounter(Ts,Tc)=wrongcounter(Ts,Tc)+1;
        corrcounter(Ts,Tc)=0;
        PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
        if  wrongcounter(Ts,Tc)>=sc.up
            wrongcounter(Ts,Tc)=0;
            thresh(Ts,Tc)=thresh(Ts,Tc) -1;
            thresh(Ts,Tc)=max(thresh(Ts,Tc),1);
        end
    end
        PsychPortAudio('Start', pahandle);
        stim_stop=secs;
        time_stim(trial) = stim_stop - stim_start;
        rispo(trial)=resp;
        
        if closescript==1
            break;
        end;
        
        save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
        
    end;
    
    
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
    Screen('Flip', w);
    KbQueueWait;
    ShowCursor;
    
    
    Screen('Preference', 'SkipSyncTests', 0);
    Screen('LoadNormalizedGammaTable', w , (linspace(0,1,256)'*ones(1,3)));
    Screen('Flip', w);
    Screen('CloseAll');
    PsychPortAudio('Close', pahandle);
    
    %% data analysis (to be completed once we have the final version)
    
    
    %to get each scale in a matrix (as opposite as Threshlist who gets every
    %trial in a matrix)
    % thresho=permute(Threshlist,[3 1 2]);
    
    %to get the final value for each staircase
    % final_threshold=thresho(10,1:length(thresho(1,:,1)),1:length(thresho(1,1,:)));
    % total_thresh= [final_threshold(:,:,1) final_threshold(:,:,2)];
    %%
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    
    
