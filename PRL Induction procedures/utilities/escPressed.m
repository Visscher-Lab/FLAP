function pressed = escPressed(keybs)
%escPressed
%
%Returns 1 if escape key is pressed, 0 otherwise
%useful for stimulus termination by user

% 2011/09/22 modified for macs (Paola)
% add ESCAPE & listen to all connected keyboards (default=listen only to
% the response box => no escape!)

% a = cd;
% if a(1)=='/'
%     a = PsychHID('Devices');
%     for i = 1:length(a), d(i) = strcmp(a(i).usageName, 'Keyboard'); end
%     keybs = find(d);
% else
%     keybs = 1;
% end


[keyIsDown,~,keyCode] = KbCheck(keybs);
if keyIsDown
    WaitSecs(0.001);
    keyPressed = KbName(keyCode);
    if iscell(keyPressed)
        for i = 1:length(keyPressed)
            pressed = ~isempty(strfind(keyPressed{i},'esc')) || ~isempty(strfind(keyPressed{i},'ESC'));
        end
    else
        pressed = ~isempty(strfind(keyPressed,'esc')) || ~isempty(strfind(keyPressed,'ESC'));
    end
    %     pressed = strcmp(keyPressed(1),'E')  ||  strcmp(keyPressed(1),'e') ;
else
    pressed = 0;
end
