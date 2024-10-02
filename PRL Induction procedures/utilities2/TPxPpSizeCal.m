function TPxPpSizeCal(screenHandle, initRequired)
% TPxPpSizeCal()
%
% This helper function calibrates pupil size by showing a rapid luminance
% change on the screen. Dilation of the pupil in response to the luminance
% change is recorded and used to determine individual pupil shape
% charactertistics. 
%
% ???           ?       Written
% Sep 17, 2019  lef     Commented and revised

%% Step 1 -- Initialize TPx and open display window (if needed)
if nargin < 2
    initRequired = 1;
end

if initRequired
    Datapixx('Open');
    Datapixx('SetTPxAwake');
    Datapixx('SetLedIntensity', 8);
    Datapixx('SetExpectedIrisSizeInPixels', 140)
    Datapixx('HideOverlay');
    Datapixx('RegWrRd');
    
    KbName('UnifyKeyNames');
    [windowPtr, windowRect]=PsychImaging('OpenWindow', 3, 0);
else
    windowPtr = screenHandle;
end

%% Step 2 -- Luminance change and pupil diameter recording

skip_pp_size_cal = 0;
text_to_draw = 'Press any key to start pupil size calibration..\nPress "S" to skip it.' ;
DrawFormattedText(windowPtr, text_to_draw, 'center', 700, 255);
Screen('Flip', windowPtr);

[~, keyCode, ~] = KbWait;
if (keyCode(KbName('s')))
    skip_pp_size_cal = 1;
end

if(~skip_pp_size_cal)
    BackgroundIntensity = 15;
    dotIntensity = 40;
    increment = 240;
    waitTime = 0;
    
    %Display low luminance display with a target in the center
    Screen('FillRect', windowPtr, [BackgroundIntensity BackgroundIntensity BackgroundIntensity]');
    Screen('DrawDots', windowPtr, [960 960; 540 540], [20;6]', [dotIntensity 0 0; 0 dotIntensity 0]', [], 1);
    Screen('Flip', windowPtr);
    WaitSecs(2);
    
    %Record pupil size data
    Datapixx('PpSizeCalGetData');
    Datapixx('RegWrRd');

    %Loop through a rapid luminance change
    while(1)
        t = Datapixx('GetTime');
        t2 = t;
        while(t - t2 < waitTime)
            Datapixx('RegWrRd');
            t = Datapixx('GetTime');
        end
        
        %if luminance change has finished, finish the pupil size
        %calibration and exit the loop
        if(BackgroundIntensity >= 255)
            Datapixx('PpSizeCalGetDataComplete');
            Datapixx('RegWrRd');
            break;
        end
        
        waitTime = 0.8;
        BackgroundIntensity = BackgroundIntensity + increment;
        dotIntensity = dotIntensity + (increment * 0.84314);
        Screen('FillRect', windowPtr, [BackgroundIntensity BackgroundIntensity BackgroundIntensity]');
        Screen('DrawDots', windowPtr, [960 960; 540 540], [20;6]', [dotIntensity 0 0; 0 dotIntensity 0]', [], 1);
        Screen('Flip', windowPtr);

    end
    
    Screen('FillRect', windowPtr, [0 0 0]');
    Screen('Flip', windowPtr);
end

%% Step 3 -- Run linear regression on pupil size data, and plot effect of dilation on recorded x,y position of eyes

if(~skip_pp_size_cal)
    
    Datapixx('PpSizeCalLinearRegression');
    Datapixx('RegWrRd');
    
    %Read buffer of eye data
    status = Datapixx('GetTPxStatus');
    status.currentReadAddr;
    toRead = status.newBufferFrames;

    [bufferData, ~, ~] = Datapixx('ReadTPxData', toRead);
    %bufferData is formatted as follows:
    %Column 
    %1      --- Timetag (in seconds)
    %2      --- Left Eye X (in pixels) 
    %3      --- Left Eye Y (in pixels)
    %4      --- Left Pupil Diameter (in pixels)
    %5      --- Right Eye X (in pixels)
    %6      --- Right Eye Y (in pixels)
    %7      --- Right Pupil Diameter (in pixels)
    %8      --- Digital Input Values (24 bits)
    %9      --- Left Blink Detection (0=no, 1=yes) 
    %10     --- Right Blink Detection (0=no, 1=yes) 
    %11     --- Digital Output Values (24 bits)
    %12     --- Left Eye Fixation Flag (0=no, 1=yes) 
    %13     --- Right Eye Fixation Flag (0=no, 1=yes)  
    %14     --- Left Eye Saccade Flag (0=no, 1=yes) 
    %15     --- Right Eye Saccade Flag (0=no, 1=yes)  
    %16     --- Message code (integer) 
    %17     --- Left Eye Raw X (in pixels) 
    %18     --- Left Eye Raw Y (in pixels)  
    %19     --- Right Eye Raw X (in pixels)  
    %20     --- Right Eye Raw Y (in pixels) 

    %Position values of 9000 indicate that the eye data was unavailable (i.e., the
    %subject blinked. Remove blink data for plotting purposes:
    [l_x_no_blink, l_x_no_blink_count] = Datapixx('RemoveBlinks', bufferData(:,17));
    [l_y_no_blink, l_y_no_blink_count] = Datapixx('RemoveBlinks', bufferData(:,18));
    [l_s_no_blink, l_s_no_blink_count] = Datapixx('RemoveBlinks', bufferData(:,4));
    [r_x_no_blink, r_x_no_blink_count] = Datapixx('RemoveBlinks', bufferData(:,19));
    [r_y_no_blink, r_y_no_blink_count] = Datapixx('RemoveBlinks', bufferData(:,20));
    [r_s_no_blink, r_s_no_blink_count] = Datapixx('RemoveBlinks', bufferData(:,7));

    l_x_no_blink = l_x_no_blink(1:l_x_no_blink_count);
    l_y_no_blink = l_y_no_blink(1:l_y_no_blink_count);
    l_s_no_blink = l_s_no_blink(1:l_s_no_blink_count);
    r_x_no_blink = r_x_no_blink(1:r_x_no_blink_count);
    r_y_no_blink = r_y_no_blink(1:r_y_no_blink_count);
    r_s_no_blink = r_s_no_blink(1:r_s_no_blink_count);

%     %Plot 1: 
%     h = figure;
%     subplot(6,1,[1:5]);
%     hold on;
%     grid on;
%     title 'RIGHT X - pupil size effect on eye data';
%     xlabel('pupil size');
%     ylabel('eye data');
%     scatter(r_s_no_blink, r_x_no_blink, '.');
%     axis([25 60 -inf inf]);
%     P = polyfit(r_s_no_blink, r_x_no_blink,1);
%     fit = P(1) * r_s_no_blink + P(2);
%     plot(r_s_no_blink, fit, '-');
%     correlation_coef_r_x = corr2(r_s_no_blink, r_x_no_blink);
%     sq_correlation_coef_r_x = power(correlation_coef_r_x,2);
%     subplot(6,1,6)
%     set(gca,'visible','off');
%     string = sprintf('fit : %0.5f * x + %0.5f',P(1), P(2));
%     text(0,0,string) 
%     string = sprintf('R^2 = %0.5f', sq_correlation_coef_r_x);
%     text(0.7,0, string);
%     savefig('right_x_pp_size_cal')
%     saveas(h,'right_x_pp_size_cal.bmp')
% 
%     %Plot 2:
%     h = figure;
%     subplot(6,1,[1:5]);
%     hold on;
%     grid on;
%     title 'RIGHT Y - pupil size effect on eye data';
%     xlabel('pupil size');
%     ylabel('eye data');
%     scatter(r_s_no_blink, r_y_no_blink, '.');
%     axis([25 60 -inf inf]);
%     P = polyfit(r_s_no_blink, r_y_no_blink,1);
%     fit = P(1) * r_s_no_blink + P(2);
%     plot(r_s_no_blink, fit, '-');
%     correlation_coef_r_y = corr2(r_s_no_blink, r_y_no_blink);
%     sq_correlation_coef_r_y = power(correlation_coef_r_y,2);
%     subplot(6,1,6)
%     set(gca,'visible','off');
%     string = sprintf('fit : %0.5f * x + %0.5f',P(1), P(2) );
%     text(0,0,string) 
%     string = sprintf('R^2 = %0.5f', sq_correlation_coef_r_y);
%     text(0.7,0, string);
%     savefig('right_y_pp_size_cal');
%     saveas(h,'right_y_pp_size_cal.bmp');
% 
%     %Plot 3:
%     h = figure;
%     subplot(6,1,[1:5]);
%     hold on;
%     grid on;
%     title 'LEFT X - pupil size effect on eye data';
%     xlabel('pupil size');
%     ylabel('eye data');
%     scatter(l_s_no_blink, l_x_no_blink, '.');
%     axis([25 60 -inf inf]);
%     P = polyfit(l_s_no_blink, l_x_no_blink,1);
%     fit = P(1) * l_s_no_blink + P(2);
%     plot(l_s_no_blink, fit, '-');
%     correlation_coef_l_x = corr2(l_s_no_blink, l_x_no_blink);
%     sq_correlation_coef_l_x = power(correlation_coef_l_x,2);
%     subplot(6,1,6);
%     set(gca,'visible','off');
%     string = sprintf('fit : %0.5f * x + %0.5f',P(1), P(2));
%     text(0,0,string) ;
%     string = sprintf('R^2 = %0.5f', sq_correlation_coef_l_x);
%     text(0.7,0, string);
%     savefig('left_x_pp_size_cal');
%     saveas(h,'left_x_pp_size_cal.bmp');
% 
%     %Plot 4:
%     h = figure;
%     subplot(6,1,[1:5]);
%     hold on;
%     grid on;
%     title 'LEFT Y - pupil size effect on eye data';
%     xlabel('pupil size');
%     ylabel('eye data');
%     scatter(l_s_no_blink, l_y_no_blink, '.');
%     axis([25 60 -inf inf]);
%     P = polyfit(l_s_no_blink, l_y_no_blink,1);
%     fit = P(1) * l_s_no_blink + P(2);
%     plot(l_s_no_blink, fit, '-');
%     correlation_coef_l_y = corr2(l_s_no_blink, l_y_no_blink);
%     sq_correlation_coef_l_y = power(correlation_coef_l_y,2);
%     subplot(6,1,6)
%     set(gca,'visible','off');
%     string = sprintf('fit : %0.5f * x + %0.5f',P(1), P(2));
%     text(0,0,string);
%     string = sprintf('R^2 = %0.5f', sq_correlation_coef_l_y);
%     text(0.7,0, string);
%     savefig('left_y_pp_size_cal');
%     saveas(h,'left_y_pp_size_cal.bmp');
    
    %Plot 5:
    h = figure;
    hold on;
    grid on;
    title 'pupil size evolution';
    xlabel('time');
    ylabel('pupil size');
    plot(bufferData(:,1), r_s_no_blink, '.');
    plot(bufferData(:,1), l_s_no_blink, '-');
    savefig('pp_size');
    saveas(h,'pp_size.bmp');
    
end

%% Step 4 -- Close everything, if needed
if initRequired
    Screen('CloseAll');
end

end
