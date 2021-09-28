fixationlength=10;
Screen('DrawLine', w,[255 255 255], wRect(3)/2, 3*wRect(4)/4-fixationlength, wRect(3)/2, 3*wRect(4)/4+fixationlength, 4);
Screen('DrawLine', w,[255 255 255], wRect(3)/2-fixationlength, 3*wRect(4)/4, wRect(3)/2+fixationlength, 3*wRect(4)/4, 4);

AtheLetter=imread('newletterc22.tiff');

AtheLetter=AtheLetter(:,:,1);

AtheLetter=imresize(AtheLetter,0.7);
[cc rr]=size(AtheLetter);
imagelocation1=[100 450 165 515]; imagelocation2=[200 450 265 515]; imagelocation3=[300 450 365 515]; imagelocation4=[400 450 465 515];
imagelocation=[(wRect(3)/2)-(3*cc)-cc/2 (3*wRect(4)/4)-cc/2 (wRect(3)/2)-(3*cc)+cc/2 (3*wRect(4)/4)+cc/2];

AtheLetter=Screen('MakeTexture', w, AtheLetter); 
ori=90;
Screen('DrawTexture',w,AtheLetter,[],imagelocation1,ori);Screen('DrawTexture',w,AtheLetter,[],imagelocation2,ori+180);Screen('DrawTexture',w,AtheLetter,[],imagelocation3,ori+270);Screen('DrawTexture',w,AtheLetter,[],imagelocation4,ori+90);
Screen('DrawTexture',w,AtheLetter,[],imagelocation,ori);
DrawFormattedText(w, 'Please keep your eyes at the center of the screen.\n \nTarget stimulus -C- can appear in four main directions: right, left, up and down.\n \nPlease indicate the direction of the gap of the C using the arrow keys as quick and accurate as possible.\n \nAs soon as you respond, you will have an auditory feedback. \n \n  \n \n \n \n Press any key to start', 100, 100, [255 255 255]);
Screen('Flip', w);
KbQueueWait;