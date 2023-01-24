%This function specifies intructions for the trails task
%It relies upon Block numbers (1-4)
%Created 10/30/22 by ARS
function [] = TrailsInstructions(Block,w, BackColor,LetterColor)

Screen('FillRect',w,BackColor);
Screen('TextFont',w, 'Arial');
Screen('TextSize',w, 30);
Screen('TextStyle', w, 0);
%Pinar made some changes, originals were commented out
switch Block
    case 1
        Screen('DrawText', w, 'There will be numbers in circles on the next page.',100, 150, LetterColor);
        Screen('DrawText', w, 'Start at number 1, click on the numbers in order.' , 100, 200, LetterColor);
        Screen('DrawText', w, 'Please respond as quickly and accurately as you can.' , 100, 250, LetterColor);
        Screen('DrawText', w, 'Lets practice' , 100, 300, LetterColor);
        Screen('DrawText', w, 'Hit any key to start the next block.', 100, 500, LetterColor);
        %         Screen('DrawText', w, 'Your task is connect the numbers 1 then 2 etc', 100, 150, LetterColor); %these are originals
        %         Screen('DrawText', w, 'Lets practice' , 100, 200, LetterColor);
        %         Screen('DrawText', w, 'When the grid appears first click the 1' , 100, 250, LetterColor);
        %         Screen('DrawText', w, 'Then select the other numbers in sequence as quickly and accurately as you can' , 100, 300, LetterColor);
        %         Screen('DrawText', w, 'Hit any key to start the next block.', 100, 500, LetterColor);
    case 2
        Screen('DrawText', w, 'There will be numbers in circles on the next page.', 100, 150, LetterColor);
        Screen('DrawText', w, 'Start at number 1, click on the numbers in order.' , 100, 200, LetterColor);
        Screen('DrawText', w, 'Please respond as quickly and accurately as you can.' , 100, 250, LetterColor);
        Screen('DrawText', w, 'Hit any key to start the next block.', 100, 500, LetterColor);
        %         Screen('DrawText', w, 'Your task is connect the numbers 1 then 2 then 3, etc', 100, 150, LetterColor);
        %         Screen('DrawText', w, 'Now for real, there will be more numbers this time' , 100, 200, LetterColor);
        %         Screen('DrawText', w, 'When the grid appears first click the 1' , 100, 250, LetterColor);
        %         Screen('DrawText', w, 'Then select the other numbers in sequence as quickly and accurately as you can' , 100, 300, LetterColor);
        %         Screen('DrawText', w, 'Hit any key to start the next block.', 100, 500, LetterColor);
    case 3
        Screen('DrawText', w, 'There will be numbers and letters in circles on the next page.', 100, 150, LetterColor);
        Screen('DrawText', w, 'Please click on the circles alternating in order between letters and numbers.' , 100, 200, LetterColor);
        Screen('DrawText', w, 'Start at number 1, then go to the first letter A.' , 100, 250, LetterColor);
        Screen('DrawText', w, 'Then go to the next number 2, then click on the next letter B. ' , 100, 300, LetterColor);
        Screen('DrawText', w, 'Please respond as quickly and accurately as you ca.n' , 100, 350, LetterColor);
        Screen('DrawText', w, 'Lets practice' , 100, 400, LetterColor);
        Screen('DrawText', w, 'Hit any key to start the next block.', 100, 500, LetterColor);
        %         Screen('DrawText', w, 'Your task is alternate numbers is letters 1 then A then 2 then B, etc', 100, 150, LetterColor);
        %         Screen('DrawText', w, 'Lets practice' , 100, 200, LetterColor);
        %         Screen('DrawText', w, 'When the grid appears first click the 1' , 100, 250, LetterColor);
        %         Screen('DrawText', w, 'Then A and then alternate between numbers and letters as quickly and accurately as you can' , 100, 300, LetterColor);
        %         Screen('DrawText', w, 'Hit any key to start the next block.', 100, 500, LetterColor);
    case 4
        Screen('DrawText', w, 'There will be numbers and letters in circles on the next page.', 100, 150, LetterColor);
        Screen('DrawText', w, 'Please click on the circles alternating in order between letters and numbers.' , 100, 200, LetterColor);
        Screen('DrawText', w, 'Start at number 1, then go to the first letter A.' , 100, 250, LetterColor);
        Screen('DrawText', w, 'Then go to the next number 2, then click on the next letter B. ' , 100, 300, LetterColor);
        Screen('DrawText', w, 'Please respond as quickly and accurately as you can.' , 100, 350, LetterColor);
        Screen('DrawText', w, 'Hit any key to start the next block.', 100, 500, LetterColor);
        %         Screen('DrawText', w, 'Your task is alternate numbers is letters 1 then A then 2 then B, etc', 100, 150, LetterColor);
        %         Screen('DrawText', w, 'Now for real, there will be more numbers and letters this time' , 100, 200, LetterColor);
        %         Screen('DrawText', w, 'When the grid appears first click the 1' , 100, 250, LetterColor);
        %         Screen('DrawText', w, 'Then A and then alternate between numbers and letters as quickly and accurately as you can' , 100, 300, LetterColor);
        %         Screen('DrawText', w, 'Hit any key to start the next block.', 100, 500, LetterColor);
end

vbl = Screen('Flip', w); %draws configuration

KbQueueWait;

% Screen('FillRect',w,127);
% Screen('Flip',w);
