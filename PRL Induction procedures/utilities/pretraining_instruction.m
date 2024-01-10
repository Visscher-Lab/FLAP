%pretraining_instruction

Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
%     Screen('TextStyle', w, 1+2);
Screen('FillRect', w, gray);
colorfixation = white;
if mixtr(trial,1)==1
DrawFormattedText(w, 'Keep the circle within the box for 5 seconds \n \n \n \n Press a key to start', 'center', 'center', white);
elseif mixtr(trial,1)==2
DrawFormattedText(w, 'NOW IT GETS TRICKY! \n\n  \n \n \n \n Keep the circle within the box for 10 seconds \n \n \n \n Press a key to start', 'center', 'center', white);
end
Screen('Flip', w);
KbQueueWait;
