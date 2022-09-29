function [pos]= calPt(sc_size, cal_ratio, index)
% Helper function used in TPxCalibration
if abs(cal_ratio) > 1  
    error('Error, cal_ratio must be a value between 0 and 1')
end
cal_size = round(sc_size*cal_ratio);
margin = (sc_size - cal_size)/2;
column_size = cal_size/11;

pos = margin + (column_size/2) + (column_size * index);
end

