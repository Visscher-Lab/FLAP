%% This script displays the instruction page for the CI Assessment Task

Screen('FillRect', w, gray);
if mixtr(trial,1)==2
    if trial == 1 || mod(trial,trials)==2 && mixtr(trial,2) == 1
        DrawFormattedText(w, 'Lets practice a few trials of the task. Here you will see the target on the LEFT side of the scotoma \n Press the left arrow key if you see a 9 \n Press the right arrow key if you see a 6  \n Press any key to start',...
            'center','center',white);
    else
        if mod(trial,trials) == 2 && mixtr(trial,2) == 2
            DrawFormattedText(w, 'Lets practice a few trials of the task. Here you will see the target on the RIGHT side of the scotoma \n Press the left arrow key if you see a 9 \n Press the right arrow key if you see a 6  \n Press any key to start',...
                'center','center',white);
        end
    end
elseif mixtr(trial,1)==1
    if mod(trial,trials)==1 && mixtr(trial,2) == 1
        DrawFormattedText(w, 'Lets practice a few trials of the task. Here you will see the target on the LEFT side of the scotoma \n Press the left arrow key if you see a d \n Press  the right arrow key if you see a b \n Press any key to start',...
            'center','center',white);
    else
        if mod(trial,trials) == 1 && mixtr(trial,2) == 2
            DrawFormattedText(w, 'Lets practice a few trials of the task. Here you will see the target on the RIGHT side of the scotoma \n Press the left arrow key if you see a d \n Press  the right arrow key if you see a b  \n Press any key to start',...
                'center','center',white);
        end
    end
end
theeccentricity_X_instructions = 6*pix_deg;
imageRect_offsCIinstr =[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X_instructions, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X_instructions,...
    imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X_instructions, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X_instructions]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCIinstr2=[imageRectSmall(1)+eccentricity_XCI'-theeccentricity_X_instructions, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X_instructions,...
    imageRectSmall(3)+eccentricity_XCI'-theeccentricity_X_instructions, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X_instructions]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCI2instr=imageRect_offsCIinstr;
imageRect_offsCI2instr2=imageRect_offsCIinstr2;


Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], Dcontr ); %Dcontr = contrast of the gabors
%here I draw the target contour left egg and 9
imageRect_offsCI2instr(setdiff(1:length(imageRect_offsCIinstr),exampletargetcord),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], 0.88);

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr2' + [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], Dcontr );
%here I draw the target contour right egg and 6
imageRect_offsCI2instr2(setdiff(1:length(imageRect_offsCIinstr2),exampletargetcord2),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr2'+ [examplexJitLoc2; yJitLoc; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], 0.88);
Screen('Flip', w);
KbQueueWait;
WaitSecs(0.5);
