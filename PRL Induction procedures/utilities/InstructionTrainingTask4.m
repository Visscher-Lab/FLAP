Screen('FillRect', w, gray);

%% Contrast Task
DrawFormattedText(w, 'Press the green (left) or red (right) button \n \n to indicate the orientation of the pattern \n \n Press any key to continue', 'center', 'center', white);
ori1 = -45; ori2 = 45;
Ypos=PRLx*pix_deg_vert;
Xpos=PRLx*pix_deg;
imageRect_left =[imageRect(1)+Xpos, imageRect(2)+Ypos,imageRect(3)+Xpos, imageRect(4)+Ypos];
imageRect_right =[imageRect(1)-Xpos, imageRect(2)+Ypos,imageRect(3)-Xpos, imageRect(4)+Ypos];
Screen('DrawTexture', w, texture(trial), [], imageRect_left , ori1,[], contr );
Screen('DrawTexture', w, texture(trial), [], imageRect_right, ori2,[], contr );
Screen('Flip', w);
KbQueueWait;
WaitSecs(0.5);

%% Contour Task
for s = 1:length(shapeMat)
    if shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the green button if you see a d \n \n Press  the red button if you see a p  \n \n Press any key to continue', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the green button if you see a q \n \n Press  the red button if you see a b  \n \n Press any key to continue', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the green button if you see a d \n \n Press  the red button if you see a b  \n \n Press any key to continue', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the green button if you see a q \n \n Press  the red button if you see a p  \n \n Press any key to continue', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the green button if you see a 9 \n \n Press  the red button if you see a 6  \n \n Press any key to continue', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the green button if you see a 2 \n \n Press  the red button if you see a 5 \n \n Press any key to continue', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the green button if you see a left pointing egg \n \n Press  the red button if you see a right pointing egg  \n \n Press any key to continue', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the green button if the line is horizontal \n \n Press  the red button if the line is vertical  \n \n Press any key to continue', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the left arrow key if the line is horizontal \n \n Press  the right arrow key if the line is vertical  \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the left arrow key if the line is horizontal \n \n Press  the right arrow key if the line is vertical  \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the left arrow key if the line is horizontal \n \n Press  the right arrow key if the line is vertical  \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the left arrow key if the line is horizontal \n \n Press  the right arrow key if the line is vertical  \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the left arrow key if the line is horizontal \n \n Press  the right arrow key if the line is vertical  \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the left arrow key if the line is horizontal \n \n Press  the right arrow key if the line is vertical  \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the left arrow key if the line is horizontal \n \n Press  the right arrow key if the line is vertical  \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif shapeMat(1,s) == 1
        DrawFormattedText(w, 'Press the left arrow key if the line is horizontal \n \n Press  the right arrow key if the line is vertical  \n \n \n \n Press any key to start', 'center', 'center', white);
    end
end

