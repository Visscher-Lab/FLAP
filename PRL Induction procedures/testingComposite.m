 
    %% testing the odd-one out stimuli 

%flick_dur=0.0167      
Screen('preference', 'SkipSyncTests', 1)
whichScreen = max(Screen('Screens'));
   %  [window,screenRect] = PsychImaging('OpenWindow', whichScreen, 0.5,[0 0 640 480],32,2);
          [window,screenRect] = PsychImaging('OpenWindow', whichScreen, 128,[0 0 640 480],32,2);

bg_index =128; %background color
x_offset = 0;


bg_index=127;

sizedeg=3;
pix_deg=34;
separationdeg=2;
separation=separationdeg*pix_deg;
distancedeg=6;
distances=distancedeg*pix_deg;

theta = [3*pi/2  0  pi ];

rho = [distances distances distances];

[elementcoordx,elementcoordy] = pol2cart(theta,rho);


imsize=((sizedeg*pix_deg)/2);
totalstimulussize=separation+imsize*2;
totalstimulussize=[totalstimulussize totalstimulussize];
[x,y]=meshgrid(-imsize:imsize,-imsize:imsize);
xylim = imsize; %radius of circular mask
circle = x.^2 + y.^2 <= xylim^2;
[nrw, ncl]=size(x);

trials= 5;
angles= [-60 -45 -30 30 45 60];

rotationAngle=angles(randi(length(angles)));

    theFolder = [cd '/letter/'];

trials=1;
for i=1:trials
   pos_one(i)=angles(randi(length(angles)));
   pos_two(i)=angles(randi(length(angles))) ;
   pos_three(i)= angles(randi(length(angles)));
   pos_four(i)= angles(randi(length(angles)));
   
   set_dist{i}=[pos_one(i) pos_two(i) pos_three(i) pos_four(i)];
   whichLoc(i)=randi(4);
   
   theset=set_dist{i};
newangles=angles;
newangles(find(theset(whichLoc(i)))) = [];
   
   theset(whichLoc)=newangles(randi(length(newangles)));
   set_tgt{i}=theset;
   %clear theset newangles
%end

%set_tgt{i}
%set_dist{i}


theLetter=imread([theFolder 'newletterc22.tiff']);
theLetter=theLetter(:,:,1);
theLetter=imresize(theLetter,[nrw nrw],'bicubic');


theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
rotLetterone=imrotate(theLetter,rotationAngle);
rotLetter(rotLetter==0)=127;
[rotrw, rotcl]=size(rotLetter);

blankimage = ones(rotrw,rotrw)*bg_index;
largerBlankimage=ones(rotrw+separation,rotrw+separation)*bg_index;

border_two=round(((rotrw+separation)-nrw)/2);
border_one=border_two+1;

largerblankimage3=largerBlankimage;

try
largerblankimage3(border_one:end-border_two,border_one:end-border_two)=theLetter(1:end,1:end);
end
try
    largerblankimage3(border_one:end-border_one,border_one:end-border_one)=theLetter(1:end,1:end);
end

try
largerblankimage3(border_two:end-border_two,border_two:end-border_two)=theLetter(1:end,1:end);
end


largerblankimage3=uint8(largerblankimage3);

[largrotrw, largrotcl]=size(largerBlankimage);

largerrotLetter=largerBlankimage;


border_two_rot =round(largrotrw-rotrw)/2;
        border_one_rot=border_two_rot+1;

try
largerrotLetter(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetter(1:end,1:end);
end

try
    largerrotLetter(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetter(1:end,1:end);

end

try
largerrotLetter(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetter(1:end,1:end);
end


clear largerimaj

largerimaj(:,:,1)=largerrotLetter;
largerimaj(:,:,2)=largerblankimage3;
largerimaj(:,:,3)=largerblankimage3;
largerimaj(:,:,4)=largerblankimage3;
largerout = imtile(largerimaj,'Frames', 1:4, 'GridSize', [2 2]);

    
    clear largerimaj2
    
    largerimaj2(:,:,1)=largerblankimage3;
largerimaj2(:,:,2)=largerblankimage3;
largerimaj2(:,:,3)=largerblankimage3;
largerimaj2(:,:,4)=largerblankimage3;
    largerout2 = imtile(largerimaj2,'Frames', 1:4, 'GridSize', [2 2]);

theLetter=Screen('MakeTexture', window, largerout);
theRegular=Screen('MakeTexture', window, largerout2);



end
r=[0 0 totalstimulussize]; 
rr=CenterRect(r, screenRect); 

rr_Letter=[rr(1)+elementcoordx(1), rr(2)+elementcoordy(1), rr(3)+elementcoordx(1), rr(4)+elementcoordy(1)]; 
rr_Regular_one=[rr(1)+elementcoordx(2), rr(2)+elementcoordy(2), rr(3)+elementcoordx(2), rr(4)+elementcoordy(2)]; 
rr_Regular_two=[rr(1)+elementcoordx(3), rr(2)+elementcoordy(3), rr(3)+elementcoordx(3), rr(4)+elementcoordy(3)]; 


%  
% 

    % get keyboard for the key recording
    deviceIndex = -1; % reset to default keyboard
    [k_id, k_name] = GetKeyboardIndices();
    for i = 1:numel(k_id)
        if strcmp(k_name{i},'Dell Dell USB Keyboard') % unique for your deivce, check the [k_id, k_name]
            deviceIndex =  k_id(i);
        elseif  strcmp(k_name{i},'Apple Internal Keyboard / Trackpad')
            deviceIndex =  k_id(i);
        end
    end

                        KbQueueCreate(deviceIndex);
            KbQueueStart(deviceIndex);
             KbQueueFlush(deviceIndex)

while (1) %  loop 

    Screen('DrawTexture', window, theLetter, [], rr_Letter);
        Screen('DrawTexture', window, theRegular, [], rr_Regular_one);
            Screen('DrawTexture', window, theRegular, [], rr_Regular_two);

Screen('Flip', window);

    if KbQueueCheck (deviceIndex)
        break % exit loop upon key press
    end
end
ShowCursor 
Screen('Close',window);