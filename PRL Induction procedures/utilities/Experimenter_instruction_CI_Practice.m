Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 42);
%     Screen('TextStyle', w, 1+2);
Screen('FillRect', w, gray);
colorfixation = white;
if site==4
DrawFormattedText(w, 'Prendi una piccola pausa. \n\n  \n \n \n \n Premi un tasto qualsasi per cotinuare', 'center', 'center', white);
else
DrawFormattedText(w, 'Please call the experimenter for further assistance. \n\n DO NOT PRESS ANY KEY', 'center', 'center', white);
end
Screen('Flip', w);
% KbQueueWait;
keyCode = 0;
while sum(keyCode) == 0
    [keyIsDown, keyCode] = KbQueueCheck;
end
