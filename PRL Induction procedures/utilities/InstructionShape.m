
Screen('FillRect', w, gray);
if shapesoftheDay(mixtr(trial,1))==1
    DrawFormattedText(w, 'Press the left arrow key if you see a 9 \n \n Press  the right arrow key if you see a 6  \n \n \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==2
    DrawFormattedText(w, 'Press the left arrow key if you see a 2 \n \n Press  the right arrow key if you see a 5  \n \n \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==3
    DrawFormattedText(w, 'Press the left arrow key if you see a q \n \n Press  the right arrow key if you see a p  \n \n \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==4
    DrawFormattedText(w, 'Press the left arrow key if you see a d \n \n Press  the right arrow key if you see a b  \n \n \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==5
    DrawFormattedText(w, 'Press the left arrow key if the shape points left \n \n Press  the right arrow key if the shape points right  \n \n \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==6
    DrawFormattedText(w, 'Press the left arrow key if the line is tilted left \n \n Press  the right arrow key if the line is tilted right  \n \n \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==7
    DrawFormattedText(w, 'Press the left arrow key if the line is horizontal \n \n Press  the right arrow key if the line is vertical  \n \n \n \n Press any key to start', 'center', 'center', white);
end


%                 CIexample1=Targori{shapesoftheDay(mixtr(trial,1))}(1,:);
%                CIexample2=Targori{shapesoftheDay(mixtr(trial,1))}(2,:);
%
%
% tp=Targy{shapesoftheDay(mixtr(trial,1))};
% tp2=Targx{shapesoftheDay(mixtr(trial,1))};
%             exampletargetcord =tp(1,:)+yTrans  + (tp2(1,:)+xTrans - 1)*ymax;
%             exampletargetcord2 =tp(2,:)+yTrans  + (tp2(2,:)+xTrans - 1)*ymax;

imageRect_offsCIinstr =[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
    imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCIinstr2=[imageRectSmall(1)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
    imageRectSmall(3)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCI2instr=imageRect_offsCIinstr;
imageRect_offsCI2instr2=imageRect_offsCIinstr2;


Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], Dcontr ); %Dcontr = contrast of the gabors
%here I draw the target contour (9) and other sub types (left egg, left
%diag, 2)
imageRect_offsCI2instr(setdiff(1:length(imageRect_offsCIinstr),exampletargetcord),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], 0.88);


Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr2' + [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], Dcontr );
%here I draw the target contour (6) and other sub types (rught diag, right
%egg, 5...)
imageRect_offsCI2instr2(setdiff(1:length(imageRect_offsCIinstr2),exampletargetcord2),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr2'+ [examplexJitLoc2; yJitLoc; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], 0.88);
Screen('Flip', w);
KbQueueWait;
WaitSecs(0.5);
    
    %%