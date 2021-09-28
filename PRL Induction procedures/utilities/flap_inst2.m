AtheLetter=imread('newletterc22.tiff');

AtheLetter=AtheLetter(:,:,1);

AtheLetter=imresize(AtheLetter,0.7);
screencm=[69.8, 35.5];
v_d=57;
pix_deg=1./((2*atan((screencm(1)/wRect(3))./(2*v_d))).*(180/pi));
e_X=-pix_deg*6;
e_Y=0;
[cc rr]=size(AtheLetter);
aimageRect = CenterRect([0, 0, rr, cc], wRect);
imagelocation1=[100 450 165 515]; imagelocation2=[200 450 265 515]; imagelocation3=[300 450 365 515]; imagelocation4=[400 450 465 515];
%imRect_offs =[aimageRect(1)+e_X, aimageRect(2)+e_Y-30,aimageRect(3)+e_X, aimageRect(4)+e_Y-30];
AtheLetter=Screen('MakeTexture', w, AtheLetter); 
ori=90;
Screen('DrawTexture',w,AtheLetter,[],imagelocation1,ori);Screen('DrawTexture',w,AtheLetter,[],imagelocation2,ori+180);Screen('DrawTexture',w,AtheLetter,[],imagelocation3,ori+270);Screen('DrawTexture',w,AtheLetter,[],imagelocation4,ori+90);
DrawFormattedText(w, 'Please keep your eyes at the center of the screen.\n \nTarget stimulus -C- can appear in four main directions: right, left, up and down.\n \nPlease indicate the direction of the gap of the C using the arrow keys as quick and accurate as possible.\n \nAs soon as you respond, you will have an auditory feedback. \n \n  \n \n \n \n Press any key to start', 100, 100, [255 255 255]);
%DrawFormattedText(w, 'Please keep your eyes at the center of the screen', 200, 100, [255 255 255]);
Screen('Flip', w);
KbQueueWait;