
Screen('FillRect', w, gray);
if shapesoftheDay(mixtr(trial,1))==1
    DrawFormattedText(w, 'Press the green button if you see a p \n \n Press  the red button if you see a d  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==2
    DrawFormattedText(w, 'Press the green button if you see a q \n \n Press  the red button if you see a b  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==3
    DrawFormattedText(w, 'Press the green button if you see a q \n \n Press  the red button if you see a p  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==4
    DrawFormattedText(w, 'Press the green button if you see a d \n \n Press  the red button if you see a b  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==5
    DrawFormattedText(w, 'Press the green button if you see a 9 \n \n Press  the red button if you see a 6  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==6
    DrawFormattedText(w, 'Press the green button if you see a 2 \n \n Press  the red button if you see a 5  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==7
    DrawFormattedText(w, 'Press the green button if you see an egg pointing left \n \n Press  the red button if you see an egg pointing right  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==8
    DrawFormattedText(w, 'Press the green button if you see a horizontal line \n \n Press  the red button if you see a vertical line  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==9
    DrawFormattedText(w, 'Press the green button if you see a sleeping d \n \n Press  the red button if you see a sleeping p  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==10
    DrawFormattedText(w, 'Press the green button if you see a sleeping q \n \n Press  the red button if you see a sleeping b  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==11
    DrawFormattedText(w, 'Press the green button if you see a sleeping q \n \n Press  the red button if you see a sleeping p  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==12
    DrawFormattedText(w, 'Press the green button if you see a sleeping d \n \n Press  the red button if you see a sleeping b  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==13
    DrawFormattedText(w, 'Press the green button if you see a sleeping 9 \n \n Press  the red button if you see a sleeping 6  \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==14
    DrawFormattedText(w, 'Press the green button if you see a slanted 2 \n \n Press  the red button if you see a slanted 5 \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==15
    DrawFormattedText(w, 'Press the green button if you see a downward pointing egg \n \n Press  the red button if you see an upward pointing egg \n \n Press any key to start', 'center', 'center', white);
elseif shapesoftheDay(mixtr(trial,1))==16
    DrawFormattedText(w, 'Press the green button if you see a line tilted left \n \n Press  the red button if you see a line tilted right  \n \n Press any key to start', 'center', 'center', white);
end



theeccentricity_X = 7*pix_deg;
if TRLlocation == 1
    imageRect_offsCIinstr =[imageRectSmall(1)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
        imageRectSmall(3)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
    imageRect_offsCIinstr2=[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
        imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
    imageRect_offsCI2instr=imageRect_offsCIinstr;
    imageRect_offsCI2instr2=imageRect_offsCIinstr2;
else
    imageRect_offsCIinstr =[imageRectSmall(1)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
        imageRectSmall(3)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
    imageRect_offsCIinstr2=[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
        imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
    imageRect_offsCI2instr=imageRect_offsCIinstr;
    imageRect_offsCI2instr2=imageRect_offsCIinstr2;
end

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], Dcontr ); %Dcontr = contrast of the gabors
%here I draw the target contour (9) and other sub types (left egg, left
%diag, 2)
imageRect_offsCI2instr(setdiff(1:length(imageRect_offsCIinstr),exampletargetcord),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[],0.7, [1.5 .5 .5]);


Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr2' + [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], Dcontr );
%here I draw the target contour (6) and other sub types (rught diag, right
%egg, 5...)
imageRect_offsCI2instr2(setdiff(1:length(imageRect_offsCIinstr2),exampletargetcord2),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr2'+ [examplexJitLoc2; yJitLoc; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], 0.7, [1.5 .5 .5]);



Screen('Flip', w);
KbQueueWait;
WaitSecs(0.5);
    
    %%
