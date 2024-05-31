Screen('FillRect', w, gray);

DrawFormattedText(w, 'Welcome! \n \n  Today you will complete "Training Type 4" \n \n Before each task, you will be asked to complete a few practice trials. \n \n For these practice trials, you will not move your eyes \n \n Press any key to start', 'center', 'center', white);
Screen('Flip', w);
KbQueueWait;
WaitSecs(0.5);