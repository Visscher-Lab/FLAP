function InstructionFLAP(w,trainingType,gray,white)
    Screen('FillRect', w, gray);
if trainingType==1
        DrawFormattedText(w, 'Press the green (left) or red (right) button \n \n to indicate the orientation of the pattern \n \n Press any key to start', 'center', 'center', white);
    elseif trainingType==2
        DrawFormattedText(w, 'This is Find the Shape Task \n\n Press the green or red button to indicate the shape you saw \n \n \n Press any key to start', 'center', 'center', white);
    elseif trainingType==3
        DrawFormattedText(w, 'Keep the target near the border of the gray circle \n \n until it starts flickering. \n \n After few seconds of continuous flickering, the trial will end \n \n \n Press any key to start', 'center', 'center', white);
    elseif trainingType==4
        DrawFormattedText(w, 'Keep the target near the border of the gray circle \n \n until it starts flickering. \n \n when the target changes into a tilted pattern or a shape \n \n Press the green or red button \n \n to indicate the orientation/shape   \n \n \n Press any key to start', 'center', 'center', white);
end
Screen('Flip', w);
KbQueueWait;
WaitSecs(0.5);
end