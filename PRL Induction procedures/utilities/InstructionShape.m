
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
     Screen('Flip', w);  
     
         KbQueueWait;
    WaitSecs(0.5);
