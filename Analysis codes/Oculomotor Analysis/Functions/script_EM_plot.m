         %  scatter((coordinates.(TrialNum).PokeRespectToCenter(ww,1)/pix_deg),(coordinates.(TrialNum).PokeRespectToCenter(ww,2))/pix_deg_vert, 5, 'filled');

           
           
           
                      scatter(AllFix(:,1),AllFix(:,2), 5,[0.2 0.7 0.2], 'filled');

                      
         xlim([-640/pix_deg 640/pix_deg]);
ylim([-512/pix_deg_vert 512/pix_deg_vert]);


viscircles([0 0], scotomadeg/2,'EdgeColor',[.8 .1 .1],'DrawBackgroundCircle',false, 'LineWidth', 3);
 


hold on
the_means=[    8.2984    0.0042
   -1.1067    5.3175
    2.5830    3.5829]
ellli2=   [ 7.4558   -0.3840
   -0.3840    0.4473]
ellli3=[    0.2191   -0.0191
   -0.0191    0.3044]
ellli4=[   53.5460  -13.5454
  -13.5454   12.6993]

%ellli=cov(FixationsX,FixationsY)
ellli=cov(AllFix(:,1), AllFix(:,2))
%data=[FixationsX FixationsY]
%error_ellipse(ellli, mean(AllFix), .68)
%hold on
error_ellipse(ellli2, the_means(1,:), .68);
hold on;
error_ellipse(ellli3, the_means(2,:), .68);
hold on;
error_ellipse(ellli4, the_means(3,:), .68);


[eigenvec, eigenval ] = eig(ellli2);
d=sqrt(eigenval)
areaEll=pi*d(1)*d(4)
areaEllarcmin=3600*areaEll;
caption=round(areaEllarcmin)
%angol=rad2deg(atan2(eigval(2,2),eigval(1,1)))
thetaM=rad2deg(acos(eigenvec(1,1)))
txt10=num2str(caption);
text(the_means(1,1),the_means(1,2), ['area ' txt10, ' arcmin2'], 'FontSize', 20)
txt11=num2str(thetaM);
text(the_means(1,1),the_means(1,2)-1, ['angle ' txt11, ' deg'], 'FontSize', 18)

[eigenvec, eigenval ] = eig(ellli3);
d=sqrt(eigenval)
areaEll=pi*d(1)*d(4)
areaEllarcmin=3600*areaEll;
caption=round(areaEllarcmin)
%angol=rad2deg(atan2(eigval(2,2),eigval(1,1)))
thetaM=rad2deg(acos(eigenvec(1,1)))
txt10=num2str(caption);
text(the_means(2,1),the_means(2,2), ['area ' txt10, ' arcmin2'], 'FontSize', 20)
txt11=num2str(thetaM);
text(the_means(2,1),the_means(2,2)-1, ['angle ' txt11, ' deg'], 'FontSize', 18)

[eigenvec, eigenval ] = eig(ellli4);
d=sqrt(eigenval)
areaEll=pi*d(1)*d(4)
areaEllarcmin=3600*areaEll;
caption=round(areaEllarcmin)
%angol=rad2deg(atan2(eigval(2,2),eigval(1,1)))
thetaM=rad2deg(acos(eigenvec(1,1)))
txt10=num2str(caption);
text(the_means(3,1),the_means(3,2), ['area ' txt10, ' arcmin2'], 'FontSize', 20)
txt11=num2str(thetaM);
text(the_means(3,1),the_means(3,2)-1, ['angle ' txt11, ' deg'], 'FontSize', 18)

 ylabel('degrees of visual angle', 'fontsize', 16);
  xlabel('degrees of visual angle', 'fontsize', 16);
 
%grid on
pbaspect([1.5 1 1]);
