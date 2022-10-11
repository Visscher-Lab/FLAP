function DatapixxVSyncPSyncDemo()
% This functions is a small demo to know exactly when something is
% displayed on the screen. It is done in two ways: Vsync and Psync. 
%
% While Vsync is usually sufficient for most cases, if you want to need a 
% mid-frame timing or to keep perfect synchronisation with frame drop, you may
% use Psync instead.
%
% Please take a look at the documentation for Datapixx('RegWrRdVideoSync')
% as well as the documentation for Datapixx('RegWrPixelSync') for more
% information on this. 
%
% On a PROPixx an image starts only to be displayed when the whole frame is
% recieved, therefore you will need to add a 1000/FRAME_RATE ms deterministic
% delay if you use Vsync or if you put your psync at the start of your frame.
%
% June 22, 2016   	dml     Written
% Mar 20, 2018		dml		Revised
% Mar 26, 2020		dml		Updated

global GL; % Define GL variable as global.
Datapixx('Open');
screenid = max(Screen('Screens'));
[windowPtr, windowRect]=PsychImaging('OpenWindow', screenid, 0);
Screen('Flip', windowPtr); % Initial flip

Datapixx('RegWrRd');
t0 = Datapixx('GetTime'); % Initial time

% METHOD 1: VSYNC
% Relaying on flips to be accurate (usually fine for 99.9% of cases)
while ~KbCheck
    Datapixx('SetMarker');
    Datapixx('RegWrVideoSync'); % Read the time on next flip
    Screen('FillRect', windowPtr, [255 255 rand()*255]);
    Screen('Flip', windowPtr);
    Datapixx('RegWrRd'); % Read back our marker
    t1 = Datapixx('GetMarker');
    t = (t1 - t0)*1000 % Difference of time between previous frame, in ms
    t0 = t1;
end
fprintf('Switching to Psync\n');
WaitSecs(2);

% METHOD 2: PSYNC
psync = [ 255 0 0 ; 0 255 0 ; 0 0 255 ; 255 255 0 ; 255 0 255 ; 0 255 255 ; 255 255 255 ; 0 0 0 ]'; 
while ~KbCheck
    psync(2,8) = mod(psync(2,8) + 1, 256); % modify psync every frame
    Screen('FillRect', windowPtr, [255 rand()*255 255]);
    
    glRasterPos2i(10, 1); % draw psync
    glDrawPixels(size(psync, 2), 1, GL.RGB, GL.UNSIGNED_BYTE, uint8(psync));
    Datapixx('SetMarker'); % Set a marker to log the time
    Datapixx('RegWrPixelSync', psync); % Can only WRITE so it does not hang 
    
    Screen('Flip', windowPtr);
    
    Datapixx('RegWrRd'); % Read back our marker
    %Datapixx('GetVideoLine', 10)
    t1 = Datapixx('GetMarker');
    
    t = (t1 - t0)*1000 % Difference of time between previous frame, in seconds
    if (t > 9)
        fprintf('FAIL');
    end
    t0 = t1;
end

Screen('CloseAll');
Datapixx('Close');

end