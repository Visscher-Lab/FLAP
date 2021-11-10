 function Propixx10kHzTScopeDemo()
% Propixx10kHzTScopeDemo()
%
% A demonstration of the PROPixx implementing a 10kHz tachistoscope.
%
% History:
%
% Nov 5, 	2014	paa     Written
% Mar 20,	2018	dml		Updated

AssertOpenGL;

% Only runs on PROPixx
Datapixx('Open');
if (Datapixx('IsPropixx') == 0)
    fprintf('\n***This Demo requires a PROPixx DLP projector.\n');
    Datapixx('Close');
    return;
end

Datapixx('SelectDevice', 6);
firmwareRev = Datapixx('GetFirmwareRev');
Datapixx('SelectDevice', -1);
if (firmwareRev < 34)
    fprintf('\n***This Demo requires a PROPixx DLP Revision 34+.\n');
    Datapixx('Close');
    return;
end 
% Download a sequence of T-scope images into PROPixx RAM.
% Multiple sequences could be downloaded before an experiment starts,
% or alternatively, sequences could be uploaded just before they are required.
% This sequence will implement 5 T-scope images onto pages 1-5.
% Cover page has white on top 200 rows white.
% Other 4 pages have top 400/600/800/1000 white.
pageData = zeros(1920/8,1080, 'uint8');
pageData(:,1:200) = 255;
Datapixx('WritePropixxTScopePages', 1, pageData);
pageData(:,201:400) = 255;
Datapixx('WritePropixxTScopePages', 2, pageData);
pageData(:,401:600) = 255;
Datapixx('WritePropixxTScopePages', 3, pageData);
pageData(:,601:800) = 255;
Datapixx('WritePropixxTScopePages', 4, pageData);
pageData(:,801:1000) = 255;
Datapixx('WritePropixxTScopePages', 5, pageData);

% Replace normal video presentation with T-scope presentation.
Datapixx('EnablePropixxTScope');
Datapixx('RegWrRd');
WaitSecs(1.0);

% Configure T-Scope for next presentation.
% We'll show the cover page, then the 4 remaining pages updated at 10kHz.
% The T-Scope will automatically wrap from page 5 back to page 2.
% Setting the maxScheduleFrames arg to 5 will cause   the sequence to only
% run once.
Datapixx('SetPropixxTScopeSchedule', 0, 10000, 0, 1, 5);
Datapixx('RegWrRd');

% Rising edge on TScopePrepRequest will request load of cover page onto DLP
% The cover page is what you want the subject to see when the schedule is
% not yet running.  Could even be completely black.
Datapixx('DisablePropixxTScopePrepRequest');
Datapixx('RegWrRd');
 
Datapixx('EnablePropixxTScopePrepRequest');
Datapixx('RegWrRd');


% Wait until any current DLP processing has terminated, cover page is up,
% and T-scope subsystem is ready to be triggered.
% this usually takes about 100 microseconds.
% Worst case is if we just switched from normal video into T-Scope mode,
% and the DLP just started presenting a 60Hz video frame.
% Then we wait here until that video frame has completed,
% and the delay here could be as much as 17 milliseconds.
while 1
    Datapixx('RegWrRd');
    status = Datapixx('GetVideoStatus');
    if (status.propixxTScopePrepAcknowledge)
        break;
    end
end

% The T-Scope schedule is now ready to be triggered.          
% We'll just wait for user to hit any key, then start the schedule.
% Frames will run continuously at exactly 10kHz.
% Based on the images downloaded above using WritePropixxTScopePages:
%  -rows  100-400  will be always on
%  -rows  401-600  will be on 0.3ms, off 0.1ms
%  -rows  601-800  will be on 0.2ms, off 0.2ms
%  -rows  801-1000 will be on 0.1ms, off 0.3ms
%  -rows 1001-1080 will be always off
fprintf('Showing cover page.  Hit any key to trigger T-scope.\n');
WaitSecs(1);
Datapixx('StartPropixxTScopeSchedule');
Datapixx('RegWrRd');

% If the T-scope scheduler is in count-up mode, the sequence will continue
% until manually stopped.  If the scheduler is in count-down mode, it will
% stop automatically when the schedule counter has decremented to 0  .
% We will just wait for another keypress.
%                         
% The last-shown frame will remain on the display.
fprintf('Showing T-Scope sequence.  Hit any key to stop T-scope.\n');
WaitSecs(1);
Datapixx('StopPropixxTScopeSchedule'); 

Datapixx('DisablePropixxTScopePrepRequest');

% At this point, a new sequence could be downloaded,
% or an already-downloaded sequence could be started,
% beginning with SetPropixxTScopeSchedule.
% Instead, we will just return to normal video processing.

Datapixx('DisablePropixxTScope');
Datapixx('RegWrRd');
WaitSecs(1);
videoStatus = Datapixx('GetVideoStatus');
fprintf('%d frames presented.\n', videoStatus.propixxTScopeScheduleFrame);
Datapixx('Close');
fprintf('T-Scope demo complete.\n');

  return; 