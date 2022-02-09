% visible PRL ring


                                                        %    for iu=1:length(PRLx)
                                                imageRect_offscuePRL=[imageRectcue(1)+(newsamplex-wRect(3)/2)+PRLxpix, imageRectcue(2)+(newsampley-wRect(4)/2)+PRLypix,...
                                                    imageRectcue(3)+(newsamplex-wRect(3)/2)+PRLxpix, imageRectcue(4)+(newsampley-wRect(4)/2)+PRLypix];
                                            %    if visibleCircle ==1
                                                    Screen('FrameOval', w,200, imageRect_offscuePRL, oval_thick, oval_thick);
                                           %     end
                                         %   end