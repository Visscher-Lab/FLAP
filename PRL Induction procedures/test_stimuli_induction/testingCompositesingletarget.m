              
    %% testing the odd-one out stimuli 

%flick_dur=0.0167      
Screen('preference', 'SkipSyncTests', 1)
whichScreen = max(Screen('Screens'));
   %  [window,screenRect] = PsychImaging('OpenWindow', whichScreen, 0.5,[0 0 640 480],32,2);
          [window,screenRect] = PsychImaging('OpenWindow', whichScreen, 128,[0 0 640 480],32,2);

       %             [window,screenRect] = PsychImaging('OpenWindow', whichScreen, 128,[ ],32,2);

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
%angles= [-60 -45 -30 30 45 60];
angles= [0 45 90 135 180 225 270 315];
%angles=angles-90;
%rotationAngle=angles(randi(length(angles)));

    theFolder = [cd '/letter/'];

trials=1;
for i=1:trials
   pos_one(i)=angles(randi(length(angles)));
   pos_two(i)=angles(randi(length(angles))) ;
   pos_three(i)= angles(randi(length(angles)));
   pos_four(i)= angles(randi(length(angles)));
   
   set_dist{i}=[pos_one(i) pos_two(i) pos_three(i) pos_four(i)];
   whichLoc(i)=randi(4);   
   thesetDist=set_dist{i};
newangles=angles;
newangles(find(thesetDist(whichLoc(i)))) = [];
   thesetTgt=thesetDist
   thesetTgt(whichLoc)=newangles(randi(length(newangles)));
   set_tgt{i}=thesetTgt;
   %clear theset newangles
%end

%set_tgt{i}
%set_dist{i}


theLetter=imread([theFolder 'newletterc22.tiff']);
theLetter=theLetter(:,:,1);
theLetter=imresize(theLetter,[nrw nrw],'bicubic');
theLetter=imrotate(theLetter,90);


theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
rotLetterone=imrotate(theLetter,thesetDist(1));
rotLetterone(rotLetterone==0)=127;
[rotrwi, rotcli]=size(rotLetterone);

rotLettertwo=imrotate(theLetter,thesetDist(2));
rotLettertwo(rotLettertwo==0)=127;
[rotrwii, rotclii]=size(rotLettertwo);

rotLetterthree=imrotate(theLetter,thesetDist(3));
rotLetterthree(rotLetterthree==0)=127;
[rotrwiii, rotcliii]=size(rotLetterthree);

rotLetterfour=imrotate(theLetter,thesetDist(4));
rotLetterfour(rotLetterfour==0)=127;
[rotrwiv, rotcliv]=size(rotLetterfour);

thesizes= [rotrwi rotrwii rotrwiii rotrwiv];

thisize=max(thesizes)

blankimage = ones(thisize,thisize)*bg_index;
largerBlankimage=ones(thisize+separation,thisize+separation)*bg_index;

border_two=round(((thisize+separation)-nrw)/2);
border_one=border_two+1;

[largrotrw, largrotcl]=size(largerBlankimage);

largerrotLetterone=largerBlankimage;

border_two_rot =round(largrotrw-rotrwi)/2;
border_one_rot=border_two_rot+1;

try
    largerrotLetterone(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetterone(1:end,1:end);
end

try
    largerrotLetterone(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetterone(1:end,1:end);
end

try
    largerrotLetterone(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterone(1:end,1:end);
end

largerrotLettertwo=largerBlankimage;

border_two_rot =round(largrotrw-rotrwii)/2;
border_one_rot=border_two_rot+1;

try
largerrotLettertwo(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLettertwo(1:end,1:end);
end

try
    largerrotLettertwo(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLettertwo(1:end,1:end);

end

try
largerrotLetterone(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterone(1:end,1:end);
end


largerrotLetterthree=largerBlankimage;
border_two_rot =round(largrotrw-rotrwiii)/2;
border_one_rot=border_two_rot+1;

try
largerrotLetterthree(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetterthree(1:end,1:end);
end

try
 largerrotLetterthree(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetterthree(1:end,1:end);
end

try
largerrotLetterthree(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterthree(1:end,1:end);
end


largerrotLetterfour=largerBlankimage;
border_two_rot =round(largrotrw-rotrwiv)/2;
border_one_rot=border_two_rot+1;

try
largerrotLetterfour(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetterfour(1:end,1:end);
end

try
largerrotLetterfour(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetterfour(1:end,1:end);
end

try
largerrotLetterfour(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterfour(1:end,1:end);
end


clear largerimaj

largerimaj(:,:,1)=largerrotLetterone;
largerimaj(:,:,2)=largerrotLettertwo;
largerimaj(:,:,3)=largerrotLetterthree;
largerimaj(:,:,4)=largerrotLetterfour;
largerout = imtile(largerimaj,'Frames', 1:4, 'GridSize', [2 2]);

    
theLetter_stim{i}=Screen('MakeTexture', window, largerout);

end
r=[0 0 totalstimulussize]; 
rr=CenterRect(r, screenRect); 

rr_Letter=[rr(1)+elementcoordx(1), rr(2)+elementcoordy(1), rr(3)+elementcoordx(1), rr(4)+elementcoordy(1)]; 


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

             i=1;
while (1) %  loop 

    Screen('DrawTexture', window, theLetter_stim{i}, [], rr_Letter);

Screen('Flip', window);

    if KbQueueCheck (deviceIndex)
        if i<10
            i=i+1
        elseif i==10
        break % exit loop upon key press
        end
    end
end
ShowCursor 
Screen('Close',window);
