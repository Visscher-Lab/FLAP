function varargout = KbQueue(cmd, param)
% KbQueueXXX series functions have some good features: 
%  1. detect short key event, like those from fOPR KbCheck may miss; 
%  2. detect only interested keys; 
%  3. buffer key event while code is running. 
% 
% But the syntax of KbQueueXXX is a little inconvenient due to the flexibility.
% 
% This code tries to provide a convenient wrapper for practical purpose, by
% sacrificing some flexibility, like deviceIndex etc. By default, KbQueue
% detects events for the first device (this doesn't seem the case for Windows,
% where it detects all devices). If you have more than one keyboard, and like to
% detect a different one, you have to add following in your code: 
% 
% global KbQueueDevice; KbQueueDevice = 2; 
% 
% where 2 means the second device. You need to find this index for your target
% keyboard.
% 
% KbQueue('start', keys); 
% - Create a queue and start it. The second input specify the keys to be queued.
% The default are numbers 1~5, both keyboard and keypad numbers. The key names
% adopt those with KbName('UnifyKeyNames'). The 'start' command can be called
% more than once to update new keys. If it is not called, other subfunctions
% will call it with the default keys automatically. 
% 
% Example:
% KbQueue('start', {'LeftArrow' 'RightArrow'}); % start to queue 2 arrows
% 
% The input keys can also be 256-element keyCode, such as that returned by
% KbCheck etc. It can also be the index in the keyCode, such as that returned by
% KbQueue('wait') etc.
% 
% nEvents = KbQueue('nEvents' [, 'type']);
% - Return number of events in the queue. The default event type is 'press',
% which returns the number of keypress. It can be 'release' or 'all', which will
% return number of release events or all events.
% 
% [pressTime, pressCode] = KbQueue('wait' [, secs or keys]);
% - Wait for a new event, and return key press time and keycode. During the
% wait, pressing Escape will abort code execution, unless 'Escape' is included
% in defined keys.
% 
% If there is no second input, this will wait forever till a defined key by
% previous 'start' command is detected.
% 
% If the second input is numeric, it will be interpreted as the seconds to wait,
% and wait for a key defined by previous 'start' command is pressed, or the
% seconds has elapsed, whichever is earlier. If there is no any event during the
% time window, both output will be empty. For example:
% 
% [t, key] = KbQueue('wait', 1); % wait for 1 sec or a key is detected
% 
% If the second input is a string or cellstr, it will be interpreted as the
% key(s) to detect. The provided keys here affects only this call, i.e. it has
% no effect on the queue keys defined by previous 'start' command. For example:
% 
% t = KbQueue('wait', {'5%' '5'}); % wait till 5 is pressed
% 
% [pressCodeTime, releaseCodeTime] = KbQueue('check' [, t0]);
% - Return first and last press keycode and times for each queued key, and
% optionally release keycode and times. The output will be empty if there is no
% buffered response. Both output are two row vector, with the first row for the
% keycode and second row for times. If the second input t0, default 0, is
% provided, the returned times will be relative to t0. For example:
% 
% press = KbQueue('check'); % return 1st and last key press in the queue 
% pressedKey = KbName(press(1, :); % convert keycode into key names
% 
% KbQueue('flush');
% - Flush events in the current queue.
% 
% t = KbQueue('until', whenSecs);
% - This is the same as WaitSecs('UntilTime', whenSecs), but allows to exit by
% pressing ESC. If whenSecs is not provided or is already passed, this still
% checks ESC, so allows use to quit. For example:
% KbQueue('until', GetSecs+5); % wait for 5 secs from now
% KbQueue('until'); % only check ESC exit
% 
% [pressCodeTime, releaseCodeTime] = KbQueue('stop' [, t0]);
% - This is similar to 'check' command, but it returns all queued events since
% last 'flush', or since the queue was  started. It also stops and releases the
% queue. This provides a way to check response in the end of a session. For
% example: 
% KbQueue('start', {'5%' '5'}); % start to queue 5 at beginning of a session
% KbQueue('flush'); % optionally remove unwanted events at a time point 
% t0 = GetSecs; % the start time of your experiment 
% % run your experiment
% pressCodeTime = KbQueue('stop', t0); % get all keycode and time

% 10/2012   wrote it, xiangrui.li@gmail.com
% 12/2012   try to release queue from GetChar etc, add nEvents
% 11/2014   try to use response device for OSX and Linux

persistent kCode started evts;
global KbQueueDevice; % allow to change in user code
if isempty(started), started = false; end
if nargin<1 || isempty(cmd), cmd = 'start'; end
if any(cmd=='?'), subFuncHelp('KbQueue', cmd); return; end

if strcmpi(cmd, 'start')
    if started, BufferEvents; end
    if nargin<2
        param = {'1' '2' '3' '4' '5' '1!' '2@' '3#' '4$' '5%'};
    end
    KbName('UnifyKeyNames');
    if ischar(param) || iscellstr(param) % key names
        kCode = zeros(256, 1);
        kCode(KbName(param)) = 1;
    elseif length(param)==256 % full keycode
        kCode = param;
    else
        kCode = zeros(256, 1);
        kCode(param) = 1;        
    end
    if isempty(KbQueueDevice), KbQueueDevice = responseDevice; end
    try KbQueueReserve(2, 1, KbQueueDevice); end %#ok
    KbQueueCreate(KbQueueDevice, kCode);
    KbQueueStart(KbQueueDevice);
    started = true;
    return;
end

if ~started, KbQueue('start'); end

if strcmpi(cmd, 'nEvents')
    BufferEvents;
    n = length(evts);
    if n, nPress = sum([evts.Pressed] == 1);
    else nPress = 0;
    end
    if nargin<2, param = 'press'; end
    if strncmpi(param, 'press', 5)
        varargout{1} = nPress;
    elseif strncmpi(param, 'release', 7)
        varargout{1} = n - nPress;
    else
        varargout{1} = n;
    end
elseif strcmpi(cmd, 'check')
    [down, p1, r1, p2, r2] = KbQueueCheck(KbQueueDevice);
    if ~down 
        varargout = repmat({[]}, 1, nargout);
        return;
    end
    if nargin<2, param = 0; end
    i1 = find(p1); i2 = find(p2);
    varargout{1} = [i1 i2; [p1(i1) p2(i2)]-param];
    if nargout>1
        i1 = find(r1); i2 = find(r2);
        varargout{2} = [i1 i2; [r1(i1) r2(i2)]-param];
    end
elseif strcmpi(cmd, 'wait')
    endSecs = GetSecs;
    secs = inf; % wait forever unless secs provided
    newCode = kCode; % use old keys unless new keys provided
    if nargin>1 % new keys or secs provided
        if isempty(param), param = inf; end
        if isnumeric(param) % input is secs
            secs = param;
        else % input is keys
            newCode = zeros(256, 1);
            newCode(KbName(param)) = 1;
        end
    end
    esc = KbName('Escape');
    escExit = ~newCode(esc);
    newCode(esc) = 1;
    changed = any(newCode~=kCode);
    if changed % change it so we detect new keys
        BufferEvents;
        KbQueueCreate(KbQueueDevice, newCode);
        KbQueueStart(KbQueueDevice); % Create and Start are twins here :)
    else
        KbQueueFlush(KbQueueDevice, 1); % flush KbQueueCheck buffer
    end
    endSecs = endSecs+secs;
    while 1
        [down, p1] = KbQueueCheck(KbQueueDevice);
        if down || GetSecs>endSecs, break; end
        WaitSecs('YieldSecs', 0.005);
    end
    if changed % restore original keys if it is changed
        BufferEvents;
        KbQueueCreate(KbQueueDevice, kCode);
        KbQueueStart(KbQueueDevice);
    end
    if isempty(p1)
        varargout = repmat({[]}, 1, nargout);
        return;
    end
    ind = find(p1);
    if escExit && any(ind==esc)
        error('User pressed ESC. Exiting ...'); 
    end
    varargout = {p1(ind) ind};
elseif strcmpi(cmd, 'flush')
    KbQueueFlush(KbQueueDevice, 3); % flush both buffers
    evts = [];
elseif strcmpi(cmd, 'until')
    if nargin<2 || isempty(param), param = 0; end
    while 1
        [down, t, kc] = KbCheck(-1);
        if down && kc(KbName('Escape'))
            error('User pressed ESC. Exiting ...'); 
        end
        if t>=param, break; end
        WaitSecs('YieldSecs', 0.005);
    end
    if nargout, varargout = {t}; end
elseif strcmpi(cmd, 'stop')
    KbQueueStop(KbQueueDevice);
    started = false;
    if nargout
        BufferEvents;
        if isempty(evts)
            varargout = repmat({[]}, 1, nargout);
            return;
        end

        isPress = [evts.Pressed] == 1;
        if nargin<2, param = 0; end
        varargout{1} = [[evts(isPress).Keycode] 
                        [evts(isPress).Time]-param];
        if nargout>1
            varargout{2} = [[evts(~isPress).Keycode] 
                            [evts(~isPress).Time]-param];
        end
    end
    KbQueueRelease(KbQueueDevice);
else 
    error('Unknown command: %s.', cmd);
end

    function BufferEvents % buffer events so we don't lose them
        n = KbEventAvail(KbQueueDevice);
        if n<1, return; end
        for ic = 1:n
            foo(ic) = KbEventGet(KbQueueDevice); %#ok
        end
        if isempty(evts), evts = foo;
        else evts = [evts foo];
        end
    end

end

function idx = responseDevice
    if IsWin, idx = []; return; end % all keyboards

    clear PsychHID; % refresh
    [ind, pName] = GetKeyboardIndices;
    if IsOSX
        idx = ind(1); % based on limited computers
    else % Linux
        for i = length(ind):-1:1
            if ~isempty(strfind(pName{i}, 'HIDKeys')) || ...
                ~isempty(strfind(pName{i}, 'fORP')) % faked, need to update
                idx = ind(i);
                return;
            end
            idx = ind(end); % based on limited computers
        end
    end
end
