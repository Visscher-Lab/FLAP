close all

        cx = 1920/2; % Point center in x
        cy = 1080/2; % Point center in y
        dx = 300; %200; % How big of a range to cover in X
        dy = 175; %117; % How big of a range to cover in Y     
    xy = [cx cy;...
       cx+dx cy;...
       cx-dx cy;...
       cx cy+dy;...
       cx cy-dy;...
       cx+dx cy+dy;...
       cx+dx cy-dy;...
       cx-dx cy+dy;...
       cx-dx cy-dy;...
       ];
      
        dx = 600; % How big of a range to cover in X
        dy = 350; % How big of a range to cover in Y
       xy2 = [  cx cy;...
        cx cy+dy;...
        cx+dx cy;...
        cx cy-dy;...
        cx-dx cy;...
        cx+dx cy+dy;...
        cx-dx cy+dy;...
        cx+dx cy-dy;...
        cx-dx cy-dy;...
        cx+dx/2 cy+dy/2;...
        cx-dx/2 cy+dy/2;...
        cx-dx/2 cy-dy/2;...
        cx+dx/2 cy-dy/2;];
    
    
    scatter(xy(:,1), xy(:,2))

   hold on
       scatter(xy2(:,1), xy2(:,2), 'r')
       
      figure
      
       for ui=1:length(xy2)
           
                  text(xy2(ui,1), xy2(ui,2), num2str(ui))
hold on
       end
       xlim([0 2000])
              ylim([0 2000])