function InstructionCIFLAP(w,trainingType,gray,white)
Screen('FillRect', w, gray);
DrawFormattedText(w, 'Please fixate on the center of the screen and use the \n \n left and right arrow keys on the keyboard to respond \n\n Relax and rest your eyes during the breaks provided', 'center', 'center', white);
Screen('Flip', w);
KbQueueWait;
WaitSecs(0.5);
end