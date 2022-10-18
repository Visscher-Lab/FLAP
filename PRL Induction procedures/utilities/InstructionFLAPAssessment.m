function InstructionFLAP(w,AssessmentType,gray,white)
    Screen('FillRect', w, gray);
    if AssessmentType==1
        DrawFormattedText(w, 'Press the arrow key (left vs right) \n \n to indicate the orientation of the grating \n \n \n \n Press any key to start', 'center', 'center', white);
    else
        DrawFormattedText(w, 'Please fixate on the center of the screen and use the \n \n left and right arrow keys on the keyboard to respond \n\n Relax and rest your eyes during the breaks provided', 'center', 'center', white);
    end
Screen('Flip', w);
KbQueueWait;
WaitSecs(0.5);
end