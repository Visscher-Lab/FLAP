
Screen('FillRect', w, gray);

    DrawFormattedText(w, 'Before each trial, a cue will indicate the location \n \n of the stimulus to attend (right: > or left: < ) \n \n Please look at the center of the screen during the experiment\n \n Use your left index finger for the left oriented stimulus \n Right index finger for the right oriented stimulus \n \n','center', 560, white');


%eggs--------------------
imageRect_offsCIinstr =[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
    imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCIinstr2=[imageRectSmall(1)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
    imageRectSmall(3)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCI2instr=imageRect_offsCIinstr;
imageRect_offsCI2instr2=imageRect_offsCIinstr2;
%6/9--------------------
imageRect_offsCIinstrnum =[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+2*(theeccentricity_X),...
    imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+2*(theeccentricity_X)]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCIinstr2num=[imageRectSmall(1)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+2*(theeccentricity_X),...
    imageRectSmall(3)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+2*(theeccentricity_X)]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCI2instrnum=imageRect_offsCIinstrnum;
imageRect_offsCI2instr2num=imageRect_offsCIinstr2num;

%eggs-------------------------------
Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], Dcontr ); %Dcontr = contrast of the gabors
%here I draw the target contour (9) and other sub types (left egg, left
%diag, 2)
imageRect_offsCI2instr(setdiff(1:length(imageRect_offsCIinstr),exampletargetcord),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], 0.88);


Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr2' + [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], Dcontr );
%here I draw the target contour (6) and other sub types (rught diag, right
%egg, 5...)
imageRect_offsCI2instr2(setdiff(1:length(imageRect_offsCIinstr2),exampletargetcord2),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr2'+ [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], 0.88);
%6/9------------------------------------
Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstrnum' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], Dcontr ); %Dcontr = contrast of the gabors
%here I draw the target contour (9) and other sub types (left egg, left
%diag, 2)
imageRect_offsCI2instrnum(setdiff(1:length(imageRect_offsCIinstrnum),exampletargetcord),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instrnum' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], 0.88);


Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr2num' + [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], Dcontr );
%here I draw the target contour (6) and other sub types (rught diag, right
%egg, 5...)
imageRect_offsCI2instr2num(setdiff(1:length(imageRect_offsCIinstr2num),exampletargetcord2),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr2num'+ [examplexJitLoc2; yJitLoc; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], 0.88);
FirstInstructionOnsetTime=Screen('Flip', w);
%WaitSecs(0.5);
    
    %%
