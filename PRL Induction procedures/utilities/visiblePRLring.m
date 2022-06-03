% visible PRL ring

%if counterflicker>=FlickerTime/ifi

if trainingType<3 || trainingType>2 && (counterannulus>=AnnulusTime/ifi) && annulusOrPRL==1 || annulusOrPRL==2
    %    for iu=1:length(PRLx)
    
    %                                                         if trainingType==2 || (trainingType==4 && mixtr(trial,1)==2)
    %                                                             imageRect_offscuePRL=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix+(jitterxci*pix_deg), imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix+(jitteryci*pix_deg),...
    %                                                     imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix+(jitterxci*pix_deg), imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix+(jitteryci*pix_deg)];
    %
    %                                                         else
    imageRect_offscuePRL=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix, imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix,...
        imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix, imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix];
    %      end%    if visibleCircle ==1
    Screen('FrameOval', w,scotoma_color, imageRect_offscuePRL, oval_thick, oval_thick);
    %     end
    %   end
    
end