%show the image
priorityLevel=MaxPriority(w);
Priority(priorityLevel);
   Screen('DrawTexture', w, texture, [], imageRect_offs, [],[], contr);
        Screen('FrameOval', w,ContCirc, imageRect_offs, 3, 3);
        stim_start = Screen('Flip', w, vbl + SOA);
    KbQueueFlush()
Priority(0);

        