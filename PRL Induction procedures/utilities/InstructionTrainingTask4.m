Screen('FillRect', w, gray);
DrawFormattedText(w, 'Keep the target near the border of the gray circle \n \n until it starts flickering. \n \n when the target changes into a tilted pattern or a shape \n \n Press the green or red button \n \n to indicate the orientation/shape   \n \n \n Press any key to start', 'center', 'center', white);
Screen('Flip', w);
KbQueueWait;

%% Contrast Task
if trial == 1
    if mixtr(trial,3) == 1
        DrawFormattedText(w, 'Press the green (left) or red (right) button \n \n to indicate the orientation of the pattern \n \n Press any key to continue', 'center', 'center', white);
        ori1 = -45; ori2 = 45;
        Ypos=PRLx*pix_deg_vert;
        Xpos=PRLx*pix_deg;
        imageRect_left =[imageRect(1)+Xpos, imageRect(2)+Ypos,imageRect(3)+Xpos, imageRect(4)+Ypos];
        imageRect_right =[imageRect(1)-Xpos, imageRect(2)+Ypos,imageRect(3)-Xpos, imageRect(4)+Ypos];
        Screen('DrawTexture', w, texture(trial), [], imageRect_right , ori1,[], contr ); %changed 5-29 MGR so gabor on correct side 
        Screen('DrawTexture', w, texture(trial), [], imageRect_left, ori2,[], contr ); % changed 5-29 MGR so gabor on correct side 
        Screen('Flip', w);
        KbQueueWait;
        WaitSecs(0.5);
    elseif mixtr(trial,3) == 2
        if shapesoftheDay(mixtr(trial,1))==1
            DrawFormattedText(w, 'Press the green button if you see a d \n \n Press  the red button if you see a p  \n \n Press any key to start', 'center', 'center', white);
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
%             imageRect_offsCI2instr=imageRect_offsCIinstr;
%             imageRect_offsCI2instr2=imageRect_offsCIinstr2;
              imageRect_offsCI2instr=imageRect_offsCIinstr2;
            imageRect_offsCI2instr2=imageRect_offsCIinstr;
        else
            imageRect_offsCIinstr =[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
                imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
            imageRect_offsCIinstr2=[imageRectSmall(1)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
                imageRectSmall(3)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
%             imageRect_offsCI2instr=imageRect_offsCIinstr;
%             imageRect_offsCI2instr2=imageRect_offsCIinstr2;
            imageRect_offsCI2instr=imageRect_offsCIinstr2;
            imageRect_offsCI2instr2=imageRect_offsCIinstr;
        end
        
        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr2' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], Dcontr ); %Dcontr = contrast of the gabors
        %here I draw the target contour (9) and other sub types (left egg, left
        %diag, 2)
        imageRect_offsCI2instr(setdiff(1:length(imageRect_offsCIinstr2),exampletargetcord),:)=0;  
        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[],0.7, [1.5 .5 .5]);
        
        
        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr' + [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], Dcontr );
        %here I draw the target contour (6) and other sub types (rught diag, right
        %egg, 5...)
        imageRect_offsCI2instr2(setdiff(1:length(imageRect_offsCIinstr),exampletargetcord2),:)=0
        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr2'+ [examplexJitLoc2;exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], 0.7, [1.5 .5 .5]);
%        

        
%         Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], Dcontr ); %Dcontr = contrast of the gabors
%         %here I draw the target contour (9) and other sub types (left egg, left
%         %diag, 2)
%         imageRect_offsCI2instr(setdiff(1:length(imageRect_offsCIinstr),exampletargetcord),:)=0;  
%         Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[],0.7, [1.5 .5 .5]);
%         
%         
%         Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr2' + [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], Dcontr );
%         %here I draw the target contour (6) and other sub types (rught diag, right
%         %egg, 5...)
%         imageRect_offsCI2instr2(setdiff(1:length(imageRect_offsCIinstr2),exampletargetcord2),:)=0
%         Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr2'+ [examplexJitLoc2;exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], 0.7, [1.5 .5 .5]);
%        

          Screen('Flip', w);
        KbQueueWait;
        WaitSecs(0.5);
        
    end
else
    if mixtr(temptrial+1,3) == 1
        DrawFormattedText(w, 'Press the green (left) or red (right) button \n \n to indicate the orientation of the pattern \n \n Press any key to continue', 'center', 'center', white);
        ori1 = -45; ori2 = 45;
        Ypos=PRLx*pix_deg_vert;
        Xpos=PRLx*pix_deg;
        imageRect_left =[imageRect(1)+Xpos, imageRect(2)+Ypos,imageRect(3)+Xpos, imageRect(4)+Ypos];
        imageRect_right =[imageRect(1)-Xpos, imageRect(2)+Ypos,imageRect(3)-Xpos, imageRect(4)+Ypos];
        Screen('DrawTexture', w, texture(temptrial), [], imageRect_right , ori1,[], contr );
        Screen('DrawTexture', w, texture(temptrial), [], imageRect_left, ori2,[], contr );
        Screen('Flip', w);
        KbQueueWait;
        WaitSecs(0.5);
    elseif mixtr(temptrial+1,3) == 2
        if shapesoftheDay(mixtr(temptrial+1,1))==1
            DrawFormattedText(w, 'Press the green button if you see a d \n \n Press  the red button if you see a p  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==2
            DrawFormattedText(w, 'Press the green button if you see a q \n \n Press  the red button if you see a b  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==3
            DrawFormattedText(w, 'Press the green button if you see a q \n \n Press  the red button if you see a p  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==4
            DrawFormattedText(w, 'Press the green button if you see a d \n \n Press  the red button if you see a b  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==5
            DrawFormattedText(w, 'Press the green button if you see a 9 \n \n Press  the red button if you see a 6  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==6
            DrawFormattedText(w, 'Press the green button if you see a 2 \n \n Press  the red button if you see a 5  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==7
            DrawFormattedText(w, 'Press the green button if you see an egg pointing left \n \n Press  the red button if you see an egg pointing right  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==8
            DrawFormattedText(w, 'Press the green button if you see a horizontal line \n \n Press  the red button if you see a vertical line  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==9
            DrawFormattedText(w, 'Press the green button if you see a sleeping d \n \n Press  the red button if you see a sleeping p  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==10
            DrawFormattedText(w, 'Press the green button if you see a sleeping q \n \n Press  the red button if you see a sleeping b  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==11
            DrawFormattedText(w, 'Press the green button if you see a sleeping q \n \n Press  the red button if you see a sleeping p  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==12
            DrawFormattedText(w, 'Press the green button if you see a sleeping d \n \n Press  the red button if you see a sleeping b  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==13
            DrawFormattedText(w, 'Press the green button if you see a sleeping 9 \n \n Press  the red button if you see a sleeping 6  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==14
            DrawFormattedText(w, 'Press the green button if you see a slanted 2 \n \n Press  the red button if you see a slanted 5 \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==15
            DrawFormattedText(w, 'Press the green button if you see a downward pointing egg \n \n Press  the red button if you see an upward pointing egg \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(temptrial+1,1))==16
            DrawFormattedText(w, 'Press the green button if you see a line tilted left \n \n Press  the red button if you see a line tilted right  \n \n Press any key to start', 'center', 'center', white);
        end
        
        theeccentricity_X = 7*pix_deg;
        if TRLlocation == 1
            imageRect_offsCIinstr =[imageRectSmall(1)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
                imageRectSmall(3)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
            imageRect_offsCIinstr2=[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
                imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
%             imageRect_offsCI2instr=imageRect_offsCIinstr;
%             imageRect_offsCI2instr2=imageRect_offsCIinstr2;
             imageRect_offsCI2instr=imageRect_offsCIinstr2;
             imageRect_offsCI2instr2=imageRect_offsCIinstr;
        else
            imageRect_offsCIinstr =[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
                imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
            imageRect_offsCIinstr2=[imageRectSmall(1)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
                imageRectSmall(3)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
%             imageRect_offsCI2instr=imageRect_offsCIinstr;
%             imageRect_offsCI2instr2=imageRect_offsCIinstr2;
            imageRect_offsCI2instr=imageRect_offsCIinstr2;
            imageRect_offsCI2instr2=imageRect_offsCIinstr;

        end
        
       
        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr2' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], Dcontr ); %Dcontr = contrast of the gabors
        %here I draw the target contour (9) and other sub types (left egg, left
        %diag, 2)
        imageRect_offsCI2instr(setdiff(1:length(imageRect_offsCIinstr2),exampletargetcord),:)=0;
        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[],0.7, [1.5 .5 .5]);
        
        
        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr' + [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], Dcontr );
        %here I draw the target contour (6) and other sub types (rught diag, right
        %egg, 5...)
        imageRect_offsCI2instr2(setdiff(1:length(imageRect_offsCIinstr),exampletargetcord2),:)=0;
        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr2'+ [examplexJitLoc2;exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], 0.7, [1.5 .5 .5]);
%         
        
        Screen('Flip', w);
        KbQueueWait;
        WaitSecs(0.5);
        
    end
end