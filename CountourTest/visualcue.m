
eccentricity_X=ecc_x*pix_deg;
eccentricity_Y=ecc_y*pix_deg;

    imageRect = CenterRect([0, 0, size(x)], wRect);    
    imageRect_offs =[imageRect(1)+eccentricity_X, imageRect(2)+eccentricity_Y,...
    imageRect(3)+eccentricity_X, imageRect(4)+eccentricity_Y];




 %clear the screen
        [vbl,cueonset]=Screen('Flip', w); %
%Fill the buffer and play our sound
cueontime=vbl + (ifi * 0.5);
% t1 = PsychPortAudio('Start', pahandle);
            PsychPortAudio('Start', pahandle,1,inf); %starts sound at infinity
            PsychPortAudio('RescheduleStart', pahandle, cueontime, 0) %reschedules startime to

        Screen('FrameOval', w,ContCirc, imageRect_offs, 3, 3);
        vbl = Screen('Flip', w,cueontime);

    
WaitSecs(SOA);