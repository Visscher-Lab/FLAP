%creates a circular mask


%mean_img=mean(image_temp(:));
%image_temp_new=double(image_temp)-double(mean_img);
% maxi=max(abs(image_temp_new(:)));
% mini=min(abs(image_temp_new(:)));
% image_temp_new = -1 + 2.*(image_temp_new - mini)./(maxi - mini);
%image_temp_new=image_temp_new*0.5;
%image_temp_new=image_temp_new*bg_index+bg_index;

%image_temp(circle)


texture=Screen('MakeTexture', w, image_temp);
