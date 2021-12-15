
%c's
AtheLetter=imread('newletterc22.tiff');

AtheLetter=AtheLetter(:,:,1);

AtheLetter=imresize(AtheLetter,0.7);
[cc rr]=size(AtheLetter);
imagelocation1=[100 350 165 415]; imagelocation2=[200 350 265 415]; imagelocation3=[300 350 365 415]; imagelocation4=[400 350 465 415];

AtheLetter=Screen('MakeTexture', w, AtheLetter); 
ori=90;
Screen('DrawTexture',w,AtheLetter,[],imagelocation1,ori);Screen('DrawTexture',w,AtheLetter,[],imagelocation2,ori+180);Screen('DrawTexture',w,AtheLetter,[],imagelocation3,ori+270);Screen('DrawTexture',w,AtheLetter,[],imagelocation4,ori+90);

%text
DrawFormattedText(w, 'Please keep your eyes at the center of the screen.\n \nTarget stimulus -C- can appear in four main directions: right, left, up and down.\n \nPlease indicate the direction of the gap of the C using the arrow keys as quick and accurate as possible.\n \nAs soon as you respond, you will have an auditory feedback.\n \nPossible stimuli are: \n \n \n  \n \n \n \n Press any key to start', 100, 100, [255 255 255]);

Screen('Flip', w);
KbQueueWait;