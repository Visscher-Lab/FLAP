if (counterannulus>=AnnulusTime/ifi) && annulusOrPRL==1 || annulusOrPRL==2
    if mixtr(trial,3) == 1
        imageRect_offscuePRL=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix, imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix,...
            imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix, imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix];
        Screen('FrameOval', w,scotoma_color, imageRect_offscuePRL, oval_thick, oval_thick);
    elseif mixtr(trial,3) == 2
        imageRect_offscuePRL=[imageRectcue(1)+(newsamplex-wRect(3)/2)+(PRLxpix), imageRectcue(2)+(newsampley-wRect(4)/2)+(PRLypix),...
            imageRectcue(3)+(newsamplex-wRect(3)/2)+(PRLxpix), imageRectcue(4)+(newsampley-wRect(4)/2)+(PRLypix)];
        Screen('FrameOval', w,scotoma_color, imageRect_offscuePRL, oval_thick, oval_thick);
    end
end