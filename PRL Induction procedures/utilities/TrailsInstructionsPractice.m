%This function specifies intructions for the trails task
%It relies upon Block numbers (1-4)
%Created 10/30/22 by ARS
function [] = TrailsInstructionsPractice(Block,w, BackColor,LetterColor)

Screen('FillRect',w,BackColor);
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 30);
Screen('TextStyle', w, 0);

% switch Block
%     case 1       

DrawFormattedText(w, 'There will be numbers in circles on the next page. \n \n Start at number 1, click on the numbers in order. \n \n Please respond as quickly and accurately as you can. \n \n Lets practice \n \n \n \n Hit any key to start the next block.', 'center', 'center', LetterColor);
% Screen('DrawText', w, 'There will be numbers in circles on the next page.', 100, 150, LetterColor);
% Screen('DrawText', w, 'Start at number 1, click on the numbers in order.' , 100, 200, LetterColor);
% Screen('DrawText', w, 'Please respond as quickly and accurately as you can.' , 100, 250, LetterColor);
% Screen('DrawText', w, 'Lets practice.' , 100, 300, LetterColor);
% Screen('DrawText', w, 'Hit any key to start the next block.', 100, 500, LetterColor);
%     case 2
% Screen('DrawText', w, 'There will be numbers and letters in circles on the next page.', 100, 150, LetterColor);
% Screen('DrawText', w, 'Please click on the circles alternating in order between letters and numbers.' , 100, 200, LetterColor);
% Screen('DrawText', w, 'Start at number 1, then go to the first letter A.' , 100, 250, LetterColor);
% Screen('DrawText', w, 'Then go to the next number 2, then click on the next letter B. ' , 100, 300, LetterColor);
% Screen('DrawText', w, 'Please respond as quickly and accurately as you can.' , 100, 350, LetterColor);
% Screen('DrawText', w, 'Lets practice.' , 100, 400, LetterColor);
% Screen('DrawText', w, 'Hit any key to start the next block.', 100, 500, LetterColor);
% 
% end

vbl = Screen('Flip', w); %draws configuration
Screen('TextFont',w, 'Courier Bold');
KbQueueWait;
              
% Screen('FillRect',w,127);
% Screen('Flip',w);
