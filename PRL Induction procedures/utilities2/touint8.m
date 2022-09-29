function imguint8 = touint8(img)
%This function mimics subset of im2uint8 and is used by imtile and
%createMontage

%   Copyright 2018 The MathWorks, Inc.
imguint8 = zeros(size(img),'uint8');
switch class(img)
    
    case 'logical'
        imguint8 = uint8(img);
        imguint8(img) = 255;
        
    case 'uint8'
        imguint8 = img;
        
    case 'uint16'
        imguint8 = uint16toUint8(img);
        
    case 'int16'
        img = single(img);
        img = img + 32768;
        img = uint16(img);
        
        imguint8 = uint16toUint8(img);
        
    case 'single'
        val255 = single(255.0);
        val05 = single(0.5);
        imguint8 = singleOrDouble2Uint8(img, val05, val255);
        
    case 'double'
        val255 = 255.0;
        val05 = 0.5;
        imguint8 = singleOrDouble2Uint8(img, val05, val255);
end
        
end
function imguint8 = uint16toUint8(img)

        factor = 1/257;
        imguint8 = floor(double(img)*factor+0.5);
        imguint8 = uint8(imguint8);
end

function imguint8 = singleOrDouble2Uint8(img, val05, val255)

        imguint8 = img*val255 + val05;
        
        idx = isnan(imguint8);
        imguint8(idx) = 0;
        
        imguint8(imguint8>255.0) = 255.0;
        imguint8(imguint8<0.0) = 0.0;
        imguint8 = uint8(floor(imguint8));
end