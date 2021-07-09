
    
    OtherFolder = [cd '/Induction_stimuli/'];
    
    [img, sss, alpha] =imread([OtherFolder '/neutralface.png']);
    img(:, :, 4) = alpha;
    
    neut=img(:,:,1);
    J = imrotate(img,-45);
    J_alpha=imrotate(alpha,-45);
    J(:,:,4)=J_alpha;
   % Distractorface=Screen('MakeTexture', w, img);
    
    
    [img, sss, alpha] =imread([OtherFolder '/neutral.png']);
    img2(:, :, 4) = alpha;
    %Neutralface=Screen('MakeTexture', w, img);
        neut2=img(:,:,1);

    
        imaj(:,:,1)=neut;
        imaj(:,:,2)=neut2
            out = imtile(imaj,'Frames', 1:2, 'GridSize', [2 2]);


            out = imtile([img J],'Frames', 1:2, 'GridSize', [2 2]);


blankimage = ones(906,906,3)*255;
blankimage2=blankimage;
blankimage2(134:end-133,134:end-133,:)=img(1:end,1:end,1:3);
blankimage2=uint8(blankimage2);
imshow(blankimage2)
blankimage3=blankimage;

for si=1:640
    for sei=1:640
        for ui=1:3
blankimage3(134+si,134+sei,ui)=img(si,sei,ui);
        end
    end
end

imaj(:,:,1)=blankimage2(:,:,1);
        imaj(:,:,2)=blankimage2(:,:,1);
               imaj(:,:,3)=J(:,:,1);
            out = imtile(imaj,'Frames', 1:3, 'GridSize', [2 2]);


    out = imtile([neut, neut2, neut2,neut],'Frames', 1:4, 'GridSize', [2 2]);
figure;
imshow(out);


nrw=906;
bg_index=127;

sizedeg=3;
pix_deg=34;
imsize=((sizedeg*pix_deg)/2);
[x,y]=meshgrid(-imsize:imsize,-imsize:imsize);
%circular mask
xylim = imsize; %radius of circular mask
circle = x.^2 + y.^2 <= xylim^2;
[nrw, ncl]=size(x);

nrw=906;

    theFolder = [cd '/letter/'];


theLetter=imread([theFolder 'newletterc22.tiff']);
theLetter=theLetter(:,:,1);


theLetter=imresize(theLetter,[nrw nrw],'bicubic');

theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
rotLetter=imrotate(theLetter,-45);
rotLetter(rotLetter==0)=127;

imaj(:,:,1)=theLetter;
imaj(:,:,2)=theLetter;
imaj(:,:,3)=theLetter;
imaj(:,:,4)=theLetter;
%theLetter=Screen('MakeTexture', w, theLetter);
    out = imtile(imaj,'Frames', 1:4, 'GridSize', [2 2]);

imshow(uint8(theLetter))



103
146



