function doPlot(x,membership,centroids,r,count)

symbs= {'yo','g*','mo','ko','bv'}; 
unq = unique(membership);
%set(Fig,'Position', [4, 4, 4, 4]);
%axis( [4, 4, 4, 4]);
%axis([xmin xmax ymin ymax])
%axes;
f=figure(r);
clf(f,'reset')
hold off;
title(strcat('KMean-1: Number of iterations: ', int2str(count)));
xlabel('X1');
ylabel('X2');


for i = unq';
    hold on;
    tmp_x = x(membership==i,:);
    plot(tmp_x(:,1),tmp_x(:,2), symbs{i});
   
    
end
hold on;
plot(centroids(:,1),centroids(:,2),'square','Color','k','MarkerSize', 20);
hold on;
plot(centroids(:,1),centroids(:,2),'X','Color','k','MarkerSize', 20);


hold off;
end