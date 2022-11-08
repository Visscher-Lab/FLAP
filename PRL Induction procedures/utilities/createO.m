        
        [x,y]=meshgrid(-imsize/2:imsize/2,-imsize/2:imsize/2);
        %circular mask
        circle = x.^2 + y.^2 <= imsize^2;
        [nrw, ncl]=size(x);
        theLetter=imread('newletterc22.tiff');
        theLetter=theLetter(:,:,1);
        theLetter=imresize(theLetter,[nrw nrw],'bicubic');
        theCircles=theLetter;
        
        theLetter = double(circle) .* double(theLetter)+gray * ~double(circle);
        theLetter=Screen('MakeTexture', w, theLetter);
        
        theArrow=imread('Arrowv3.PNG');
        theArrow=theArrow(:,:,1);
        theArrow=imresize(theArrow,[nrw nrw],'bicubic');
        
        theArrow = double(circle) .* double(theArrow)+gray * ~double(circle);
        theArrow=Screen('MakeTexture', w, theArrow);
        
        if  mod(nrw,2)==0
            theCircles(1:nrw, nrw/2:nrw)=theCircles(nrw:-1:1, (nrw/2+1):-1:1);
        elseif  mod(nrw,2)>0
            theCircles(1:nrw, nrw/2:nrw)=theCircles(nrw:-1:1, round((nrw/2)):-1:1);
        end
        
        theCircles = double(circle) .* double(theCircles)+gray * ~double(circle);
        theCircles=Screen('MakeTexture', w, theCircles);
        
        theTest=imread('target_black.tiff');
        theTest=theTest(:,:,1);
        theTest=Screen('MakeTexture', w, theTest);
        [img, sss, alpha] =imread('neutral21.png');
        img(:, :, 4) = alpha;
        Neutralface=Screen('MakeTexture', w, img);
        
        theDot=imread('thedot2.tiff');
        theDot=theDot(:,:,1);
        
        
        theDot=imresize(theDot,[nrw nrw],'bicubic');
        
        theDot = double(circle) .* double(theDot)+gray * ~double(circle);
        theDot=Screen('MakeTexture', w, theDot);
                    [xc, yc] = RectCenter(wRect);
