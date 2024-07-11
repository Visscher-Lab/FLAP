if trial==1 || trial== 71 || trial== 211 || trial== 351
Screen('FillRect', w, gray);
DrawFormattedText(w, 'Now that you have practiced, we will begin the task. \n \n Using your eyes, move the white circle over the dot until the dot starts flickering. \n \n When the dot changes into a tilted blob or a shape, \n \n press the left/green or right/red button \n \n to indicate the orientation of the tilted blob or shape   \n \n \n Press any key to start', 'center', 'center', white);
Screen('Flip', w);
KbQueueWait;
end




%% Contrast Task
if trial == 1
    if mixtr(trial,3) == 1
          DrawFormattedText(w, 'Press the left/green or right/red button \n \n to indicate the orientation of the tilted blob \n \n Press any key to start', 'center', 'center', white);
        ori1 = -45; ori2 = 45;
        Ypos=PRLx*pix_deg_vert;
        Xpos=PRLx*pix_deg;
        fase=randi(4);
        texture(trial)=TheGabors(currentsf, fase);
        imageRect_left =[imageRect(1)+Xpos, imageRect(2)+Ypos,imageRect(3)+Xpos, imageRect(4)+Ypos];
        imageRect_right =[imageRect(1)-Xpos, imageRect(2)+Ypos,imageRect(3)-Xpos, imageRect(4)+Ypos];
        Screen('DrawTexture', w, texture(trial), [], imageRect_right , ori1,[], 1); %changed 5-29 MGR so gabor on correct side
        Screen('DrawTexture', w, texture(trial), [], imageRect_left, ori2,[], 1); % changed 5-29 MGR so gabor on correct side
        Screen('Flip', w);
        KbQueueWait;
        WaitSecs(0.5);
       
        
    elseif mixtr(trial,3) == 2
        if shapesoftheDay(mixtr(trial,1))==1
            DrawFormattedText(w, 'Press the left/green button if you see a d \n \n Press  the right/red button if you see a p  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==2
            DrawFormattedText(w, 'Press the left/green button if you see a q \n \n Press  the right/red button if you see a b  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==3
            DrawFormattedText(w, 'Press the left/green button if you see a q \n \n Press  the right/red button if you see a p  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==4
            DrawFormattedText(w, 'Press the left/green button if you see a d \n \n Press  the right/red button if you see a b  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==5
            DrawFormattedText(w, 'Press the left/green button if you see a 9 \n \n Press  the right/red button if you see a 6  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==6
            DrawFormattedText(w, 'Press the left/green button if you see a 2 \n \n Press  the right/red button if you see a 5  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==7
            DrawFormattedText(w, 'Press the left/green button if you see an egg pointing left \n \n Press  the right/red button if you see an egg pointing right  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==8
            DrawFormattedText(w, 'Press the left/green button if you see a horizontal line \n \n Press  the right/red button if you see a vertical line  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==9
            DrawFormattedText(w, 'Press the left/green button if you see a sleeping d (line on top) \n \n Press  the right/red button if you see a sleeping p (line on bottom) \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==10
            DrawFormattedText(w, 'Press the left/green button if you see a sleeping q (line on top) \n \n Press  the right/red button if you see a sleeping b (line on bottom)  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==11
            DrawFormattedText(w, 'Press the left/green button if you see a sleeping q (line on top) \n \n Press  the right/red button if you see a sleeping p (line on bottom) \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==12
            DrawFormattedText(w, 'Press the left/green button if you see a sleeping d (line on top) \n \n Press  the right/red button if you see a sleeping b (line on bottom) \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==13
            DrawFormattedText(w, 'Press the left/green button if you see a sleeping 9 \n \n Press  the right/red button if you see a sleeping 6 \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==14
            DrawFormattedText(w, 'Press the left/green button if you see a slanted 2 \n \n Press  the right/red button if you see a slanted 5 \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==15
            DrawFormattedText(w, 'Press the left/green button if you see a downward pointing egg \n \n Press the right/red button if you see an upward pointing egg \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==16
            DrawFormattedText(w, 'Press the left/green button if you see a line tilted left \n \n Press the right/red button if you see a line tilted right  \n \n Press any key to start', 'center', 'center', white);
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

% CI Task
else
    if mixtr(temptrial+1,3) == 1
        DrawFormattedText(w, 'Press the left/green or right/red button \n \n to indicate the orientation of the pattern \n \n Press any key to continue', 'center', 'center', white);
        ori1 = -45; ori2 = 45;
        Ypos=PRLx*pix_deg_vert;
        Xpos=PRLx*pix_deg;
        imageRect_left =[imageRect(1)+Xpos, imageRect(2)+Ypos,imageRect(3)+Xpos, imageRect(4)+Ypos];
        imageRect_right =[imageRect(1)-Xpos, imageRect(2)+Ypos,imageRect(3)-Xpos, imageRect(4)+Ypos];
        Screen('DrawTexture', w, texture(temptrial), [], imageRect_right , ori1,[], 1 );
        Screen('DrawTexture', w, texture(temptrial), [], imageRect_left, ori2,[], 1);
        Screen('Flip', w);
        KbQueueWait;
        WaitSecs(0.5);
    elseif mixtr(temptrial+1,3) == 2
      if shapesoftheDay(mixtr(trial,1))==1
            DrawFormattedText(w, 'Press the left/green button if you see a d \n \n Press  the right/red button if you see a p  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==2
            DrawFormattedText(w, 'Press the left/green button if you see a q \n \n Press  the right/red button if you see a b  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==3
            DrawFormattedText(w, 'Press the left/green button if you see a q \n \n Press  the right/red button if you see a p  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==4
            DrawFormattedText(w, 'Press the left/green button if you see a d \n \n Press  the right/red button if you see a b  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==5
            DrawFormattedText(w, 'Press the left/green button if you see a 9 \n \n Press  the right/red button if you see a 6  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==6
            DrawFormattedText(w, 'Press the left/green button if you see a 2 \n \n Press  the right/red button if you see a 5  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==7
            DrawFormattedText(w, 'Press the left/green button if you see an egg pointing left \n \n Press  the right/red button if you see an egg pointing right  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==8
            DrawFormattedText(w, 'Press the left/green button if you see a horizontal line \n \n Press  the right/red button if you see a vertical line  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==9
            DrawFormattedText(w, 'Press the left/green button if you see a sleeping d (line on top) \n \n Press  the right/red button if you see a sleeping p (line on bottom) \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==10
            DrawFormattedText(w, 'Press the left/green button if you see a sleeping q (line on top) \n \n Press  the right/red button if you see a sleeping b (line on bottom)  \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==11
            DrawFormattedText(w, 'Press the left/green button if you see a sleeping q (line on top) \n \n Press  the right/red button if you see a sleeping p (line on bottom) \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==12
            DrawFormattedText(w, 'Press the left/green button if you see a sleeping d (line on top) \n \n Press  the right/red button if you see a sleeping b (line on bottom) \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==13
            DrawFormattedText(w, 'Press the left/green button if you see a sleeping 9 \n \n Press  the right/red button if you see a sleeping 6 \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==14
            DrawFormattedText(w, 'Press the left/green button if you see a slanted 2 \n \n Press  the right/red button if you see a slanted 5 \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==15
            DrawFormattedText(w, 'Press the left/green button if you see a downward pointing egg \n \n Press the right/red button if you see an upward pointing egg \n \n Press any key to start', 'center', 'center', white);
        elseif shapesoftheDay(mixtr(trial,1))==16
            DrawFormattedText(w, 'Press the left/green button if you see a line tilted left \n \n Press the right/red button if you see a line tilted right  \n \n Press any key to start', 'center', 'center', white);
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