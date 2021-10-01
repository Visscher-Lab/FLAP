function doPlot_EM(x,membership,centroids_old,centroids,intial_cov,cov,r,count,k)

symbs= {'yo','g*','mo','ko','bv'}; 
unq = unique(membership);
%set(Fig,'Position', [4, 4, 4, 4]);
%axis( [4, 4, 4, 4]);
%axis([xmin xmax ymin ymax])
%axes;
f1=figure(1);
clf(f1,'reset')
hold off;
title(strcat('KMean-1: Number of iterations: ', int2str(count)));
xlabel('X1');
ylabel('X2');

plot(x(:,1),x(:,2),'yo');
hold on;

for i = 1:k;
    plot_gaussian_ellipsoid( centroids_old(i,:),intial_cov{i} );
   hold on;
  
end
 hold off;

f2=figure(2);
clf(f2,'reset')
hold off;
title(strcat('KMean-1: Number of iterations: ', int2str(count)));
xlabel('X1');
ylabel('X2');
for i = unq';
hold on;
    tmp_x = x(membership==i,:);
    plot(tmp_x(:,1),tmp_x(:,2), symbs{i});
  
    hold on;
end


for i = 1:k;
    hold on;
   plot_gaussian_ellipsoid( centroids(i,:),cov{i} );
end
   hold on;
hold on;
plot(centroids(:,1),centroids(:,2),'square','Color','k','MarkerSize', 20);
hold on;
plot(centroids(:,1),centroids(:,2),'X','Color','k','MarkerSize', 20);

end