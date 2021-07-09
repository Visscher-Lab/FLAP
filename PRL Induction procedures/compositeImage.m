clear all
close all

bg_index=127;

sizedeg=6;
pix_deg=34;
imsize=((sizedeg*pix_deg)/2);
[x,y]=meshgrid(-imsize:imsize,-imsize:imsize);
%circular mask
xylim = imsize; %radius of circular mask
circle = x.^2 + y.^2 <= xylim^2;
[nrw, ncl]=size(x);


angles= [-60 -45 -30 30 45 60];

rotationAngle=angles(randi(length(angles)))
%nrw=906;

    theFolder = [cd '/letter/'];


theLetter=imread([theFolder 'newletterc22.tiff']);
theLetter=theLetter(:,:,1);
theLetter=imresize(theLetter,[nrw nrw],'bicubic');

theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
rotLetter=imrotate(theLetter,rotationAngle);
rotLetter(rotLetter==0)=127;
[rotrw, rotcl]=size(rotLetter);

blankimage = ones(rotrw,rotrw)*bg_index;
%blankimage = ones(1000,1000)*bg_index;


border_one=round((rotrw-nrw)/2)

if mod(border_one,2)==0
    border_two=border_one;    
    border_one=border_one+1;
else
        border_two=border_one;    

end


blankimage3=blankimage;
%blankimage3(43:end-43,43:end-43)=theLetter(1:end,1:end);
blankimage3(border_one:end-border_two,border_one:end-border_two)=theLetter(1:end,1:end);

blankimag3=uint8(blankimage3);
%imshow(uint8(blankimage2))
% imshow(blankimage2)
% blankimage3=blankimage;

% for si=1:640
%     for sei=1:640
%         for ui=1:3
% blankimage3(134+si,134+sei,ui)=img(si,sei,ui);
%         end
%     end
% end
clear imaj
imaj(:,:,1)=rotLetter;
imaj(:,:,2)=blankimage3;
imaj(:,:,3)=blankimage3;
imaj(:,:,4)=blankimage3;
%theLetter=Screen('MakeTexture', w, theLetter);
    out = imtile(imaj,'Frames', 1:4, 'GridSize', [2 2]);
figure
imshow(uint8(out))





%%


clear all
close all

bg_index=127;

sizedeg=6;
pix_deg=34;

separationdeg=3;
separation=separationdeg*pix_deg;
imsize=((sizedeg*pix_deg)/2);
[x,y]=meshgrid(-imsize:imsize,-imsize:imsize);
%circular mask
xylim = imsize; %radius of circular mask
circle = x.^2 + y.^2 <= xylim^2;
[nrw, ncl]=size(x);


angles= [-60 -45 -30 30 45 60];

rotationAngle=angles(randi(length(angles)))
%nrw=906;

    theFolder = [cd '/letter/'];


theLetter=imread([theFolder 'newletterc22.tiff']);
theLetter=theLetter(:,:,1);
theLetter=imresize(theLetter,[nrw nrw],'bicubic');

theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
rotLetter=imrotate(theLetter,rotationAngle);
rotLetter(rotLetter==0)=127;
[rotrw, rotcl]=size(rotLetter);

blankimage = ones(rotrw,rotrw)*bg_index;

largerBlankimage=ones(rotrw+separation,rotrw+separation)*bg_index;

%blankimage = ones(1000,1000)*bg_index;


border_two=round(((rotrw+separation)-nrw)/2)

border_one=border_two+1;
% if mod((rotrw+separation),2)==0
% 
%  if mod(border_one,2)==0
%     border_two=border_one;    
%     border_one=border_one+1;
% else
%         border_two=border_one;    
% 
% end 
% else
%  if mod(border_one,2)==0
%             border_two=border_one;    
% else
% 
%     border_two=border_one;    
%     border_one=border_one+1;
% end 
%     
% end


largerblankimage3=largerBlankimage;
%blankimage3(43:end-43,43:end-43)=theLetter(1:end,1:end);

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

% if border_one==border_one
%     border_two_rot=border_one_rot;
% else
%     border_two_rot=border_one_rot;
%         border_one_rot=border_one_rot+1;
% end

try
largerrotLetter(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetter(1:end,1:end);
end

try
    largerrotLetter(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetter(1:end,1:end);

end

try
largerrotLetter(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetter(1:end,1:end);
end


%imshow(uint8(blankimage2))
% imshow(blankimage2)
% blankimage3=blankimage;

% for si=1:640
%     for sei=1:640
%         for ui=1:3
% blankimage3(134+si,134+sei,ui)=img(si,sei,ui);
%         end
%     end
% end
clear largerimaj

%largerrotLetter=uint8(largerrotLetter);
largerimaj(:,:,1)=largerrotLetter;
largerimaj(:,:,2)=largerblankimage3;
largerimaj(:,:,3)=largerblankimage3;
largerimaj(:,:,4)=largerblankimage3;
%theLetter=Screen('MakeTexture', w, theLetter);
    largerout = imtile(largerimaj,'Frames', 1:4, 'GridSize', [2 2]);
figure
imshow(uint8(largerout))
