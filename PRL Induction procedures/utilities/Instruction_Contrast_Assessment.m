Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
%     Screen('TextStyle', w, 1+2);
Screen('FillRect', w, gray);
colorfixation = white;
if mixtr(trial,2) == 1
    DrawFormattedText(w, 'Here you will see the target on the LEFT side of the scotoma \n \n Press any key to start', 'center', 'center', white);
else
    if mixtr(trial,2) == 2
        DrawFormattedText(w, 'Here you will see the target on the RIGHT side of the scotoma \n \n Press any key to start', 'center', 'center', white);
    end
end
Screen('Flip', w);
KbQueueWait;