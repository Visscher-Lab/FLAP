
Screen('FillRect', w, gray);

    DrawFormattedText(w, 'Before each trial, a cue will indicate the location \n \n of the stimulus to attend (right: > or left: < ) \n \n Please look at the center of the screen during the experiment\n \n Index finger for 6 or left oriented stimulus \n Middle finger for 9 or right oriented stimulus \n \n','center', 100, white');



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
FirstInstructionOnsetTime=Screen('Flip', w);
WaitSecs(0.5);
    
    %%
