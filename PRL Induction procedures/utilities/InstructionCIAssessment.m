%% This script displays the instruction page for the CI Assessment Task

Screen('FillRect', w, gray);
if mixtr(trial,1)==1
    if (trial == 1 && mixtr(trial,2) == 1) || mixtr(trial,2) == 1
        DrawFormattedText(w, 'Here you will see the target on the LEFT side of the scotoma \n Press the green button if you see a d \n Press the red button if you see a p  \n Press any key to start',...
            'center','center',white);
    else
        if (trial == 1 && mixtr(trial,2) == 2) || mixtr(trial,2) == 2
            DrawFormattedText(w, 'Here you will see the target on the RIGHT side of the scotoma \n Press the green button if you see a d \n Press the red button if you see a p  \n Press any key to start',...
                'center','center',white);
        end
    end
elseif mixtr(trial,1)==2
    if (trial == 1 && mixtr(trial,2) == 1) || mixtr(trial,2) == 1
        DrawFormattedText(w, 'Here you will see the target on the LEFT side of the scotoma \n Press the green button if you see a left pointing egg \n Press  the red button if you see a right pointing egg \n Press any key to start',...
            'center','center',white);
    else
        if (trial == 1 && mixtr(trial,2) == 2) || mixtr(trial,2) == 2
            DrawFormattedText(w, 'Here you will see the target on the RIGHT side of the scotoma \n Press the green button if you see a left pointing egg \n Press the red button if you see a right pointing egg \n Press any key to start',...
                'center','center',white);
        end
    end
end
theeccentricity_X_instructions = 10*pix_deg;

imageRect_offsCIinstr =[imageRectSmall(1)+eccentricity_XCI'-theeccentricity_X_instructions, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X_instructions,...
    imageRectSmall(3)+eccentricity_XCI'-theeccentricity_X_instructions, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X_instructions]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCIinstr2=[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X_instructions, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X_instructions,...
    imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X_instructions, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X_instructions]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCI2instr=imageRect_offsCIinstr;
imageRect_offsCI2instr2=imageRect_offsCIinstr2;

%Draw right egg, 6, b, p, 5 (right side image)
Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], Dcontr ); %Dcontr = contrast of the gabors
imageRect_offsCI2instr(setdiff(1:length(imageRect_offsCIinstr),exampletargetcord),:)=0;
Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], 0.7, [1.5 .5 .5] );

%Draw left egg, 9, d, q, 2 (left side image)
Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr2' + [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], Dcontr );
imageRect_offsCI2instr2(setdiff(1:length(imageRect_offsCIinstr2),exampletargetcord2),:)=0;
Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr2'+ [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], 0.7, [1.5 .5 .5] );

Screen('Flip', w);
KbQueueWait;
WaitSecs(0.5);

