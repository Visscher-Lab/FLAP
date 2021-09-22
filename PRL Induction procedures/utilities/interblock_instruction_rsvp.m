Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
%     Screen('TextStyle', w, 1+2);
Screen('FillRect', w, gray);
colorfixation = white;
DrawFormattedText(w, 'Please keep your eyes at the center of the screen. There will be four circles at right, left, up and down. There won?t be a visual cue to indicate the next location of the target. A series of stimuli including Os and Cs will be shown in one of the circles. Please indicate the direction of the gap of the C using the arrow keys as quick and accurate as possible. As soon as you respond, you will have an auditory feedback. \n\n  \n \n \n \n Press any key to start', 'center', 'center', white);
Screen('Flip', w);
KbQueueWait;
