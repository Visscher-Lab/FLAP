function InstructionFLAP(w,trainingType,gray,white)
    Screen('FillRect', w, gray);
if trainingType==1
        DrawFormattedText(w, 'Press the arrow key (left vs right) \n \n to indicate the orientation of the grating \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif trainingType==2
        DrawFormattedText(w, 'Press the left arrow key if you see a 9 \n \n Press  the right arrow key if you see a 6  \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif trainingType==3
        DrawFormattedText(w, 'keep the target near the border of the scotoma \n \n until it starts flickering. \n \n After few seconds of continuos flickering, the trial will end \n \n \n \n Press any key to start', 'center', 'center', white);
    elseif trainingType==4
        DrawFormattedText(w, 'keep the target near the border of the scotoma \n \n until it starts flickering. \n \n when the target changes into a grating or a contour \n \n Press  the left or right arrow key \n \n to indicate its orientation   \n \n \n \n Press any key to start', 'center', 'center', white);
end
     Screen('Flip', w);  
end