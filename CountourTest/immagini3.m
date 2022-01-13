
%image database
bg_index =128; %background color

xylim = imsize;
circle = x.^2 + y.^2 <= xylim^2; 
[nrw, ncl]=size(x);
 
imagefolder=zeros(nrw,ncl,1,20);
StimuliFolder='/Users/marcellomaniglia/Downloads/NimStim/NimStim images/Crop-White background/'; %tells us where to look for image
namme= '02F_HA_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,1)=inputImage;

%imshow(uint8(imagefolder(:,:,1,1)))
namme='03F_HA_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,3)=inputImage;

namme='08F_HA_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,5)=inputImage;

namme='11F_HA_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,7)=inputImage;

namme='18F_HA_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,9)=inputImage;

namme='02F_AN_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,11)=inputImage;

namme='03F_AN_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,13)=inputImage;

namme='08F_AN_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,15)=inputImage;

namme='11F_AN_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,17)=inputImage;

namme='18F_AN_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,19)=inputImage;

namme='32M_HA_C.bmp';

% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,2)=inputImage;

namme='34M_HA_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,4)=inputImage;

namme='36M_HA_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,6)=inputImage;

namme='38M_HA_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,8)=inputImage;

namme='42M_HA_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,10)=inputImage;

namme='32M_AN_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,12)=inputImage;

namme='34M_AN_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,14)=inputImage;

namme='36M_AN_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,16)=inputImage;

namme='38M_AN_C.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);
imagefolder(:,:,1,18)=inputImage;

namme='42M_AN_o.bmp';
% Acquire image
inputImage = rgb2gray(imread([StimuliFolder namme]));
inputImage =imresize(inputImage,[nrw nrw],'bicubic');
inputImage = double(circle) .* double(inputImage)+bg_index * ~double(circle);

imagefolder(:,:,1,20)=inputImage;
