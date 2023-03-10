% % Data
% x_from_eye = [1.2450 1.7453 11.4313 1.1994 -7.8870 11.2800 -7.2230 11.1132 -9.1896 5.8908 -2.8528 -3.1911 6.5344];
% y_from_eye = [-1.7085 2.1552 10.7779 2.0153 3.5325 10.4798 3.0083 10.3373 0.8203 -3.7943 -1.2306 2.1638 0.4417];
% x_visual_stimuli = [960 960 1560 960 360 1560 360 1560 360 1260 660 660 1260];
% y_visual_stimuli = [540 890 540 190 540 890 890 190 190 715 715 365 365];
% z1 = [1.8626 2.8258 2.5629 2.0566 0.2876 2.5991 -0.2747 1.9368 -0.5709 0.9117 1.4103 1.2833 0.9863];
% z2 = [-3.7055 5.4309 -4.0425 1.2904 -4.5904 5.4857 6.3625 -5.3456 1.7711 -1.4252 0.6282 -2.2581 -1.3939];
% 
% % Fit a third degree polynomial to z1
% X1 = [ones(length(x_from_eye),1) x_from_eye' y_from_eye' x_from_eye'.^2 y_from_eye'.^2 x_from_eye'.^3 x_from_eye'.*y_from_eye' x_from_eye'.^2.*y_from_eye' x_from_eye'.*y_from_eye'.^2];
% mdl1 = fitlm(X1, z1');
% coeff1 = mdl1.Coefficients.Estimate;
% 
% % Fit a third degree polynomial to z2
% X2 = [ones(length(x_visual_stimuli),1) x_visual_stimuli' y_visual_stimuli' x_visual_stimuli'.^2 y_visual_stimuli'.^2 x_visual_stimuli'.*y_visual_stimuli'.^2 x_visual_stimuli'.*y_visual_stimuli' x_visual_stimuli'.^2.*y_visual_stimuli' x_visual_stimuli'.*y_visual_stimuli'.^2];
% mdl2 = fitlm(X2, z2');
% coeff2 = mdl2.Coefficients.Estimate;
% 
% % Plot the data and the fits for z1
% figure;
% subplot(2,2,1);
% scatter3(x_from_eye, y_from_eye, z1);
% xlabel('x');
% ylabel('y');
% zlabel('z1');
% title('Data for z1');
% subplot(2,2,2);
% scatter3(x_from_eye, y_from_eye, z1);
% hold on;
% [X,Y] = meshgrid(linspace(min(x_from_eye),max(x_from_eye)), linspace(min(y_from_eye),max(y_from_eye)));
% Z = coeff1(1) + coeff1(2)*X + coeff1(3)*Y + coeff1(4)*X.^2 + coeff1(5)*Y.^2 + coeff1(6)*X.^3 + coeff
% 


%%

close all
% input data
x_from_eye = [1.2450 1.7453 11.4313 1.1994 -7.8870 11.2800 -7.2230 11.1132 -9.1896 5.8908 -2.8528 -3.1911 6.5344];
y_from_eye =   [5.9377    1.3619   7.5133  12.9373   6.2685   2.3452   0.4560  13.1628  13.0640   4.7474   3.9025   9.9113  10.4464];
x_visual_stimuli = [960 960 1560 960 360 1560 360 1560 360 1260 660 660 1260];
y_visual_stimuli = [540 890 540  190 540 890  890 190  190 715  715 365 365];
z1 = x_visual_stimuli;
z2 = y_visual_stimuli;



% fit polynomial for z1
X = x_from_eye';
Y = y_from_eye';
Z = z1';

%%
% z1 = x_from_eye;
% z2 = y_from_eye;
% X = x_visual_stimuli';
% Y = y_visual_stimuli';
%% 


M = [ones(size(X)) X Y X.^2 Y.^2 Y.^3 X.*Y X.^2.*Y X.*Y.^2];
coeffs1 = (M \ Z)';

% fit polynomial for z2
Z = z2';
M = [ones(size(X)) X Y X.^2 Y.^2 X.*Y.^2 X.*Y X.^2.*Y X.*Y.^2];
coeffs2 = (M \ Z)';

coeffs1= [-112.705296940203,69.8382992091422,2.28115981587480,0,0,-0.0389528990383517,-0.572394782073915,-0.0276218288489573,0.00394779623073747];
coeffs2= [-433.216140666276,-7.21153717508769,70.5917049688308,0,-0.837198769390443,0,0.522190465544518,-0.0514525509198078,0.00393309653533196];
% this for x axis
% z1=a+bx+cy+dx^2+ey^2+fx^3+gxy+hx^2y+ixy^2
% and this for y axis
% z2=a+bx+cy+dx^2+ey^2+fxy^2+gxy+hx^2y+ixy^2

% evaluate polynomials on a grid
[Xq,Yq] = meshgrid(min(X):0.5:max(X), min(Y):0.5:max(Y));
Z1q = coeffs1(1) + coeffs1(2)*Xq + coeffs1(3)*Yq + coeffs1(4)*Xq.^2 + coeffs1(5)*Yq.^2 + coeffs1(6)*Xq.^3 + coeffs1(7)*Xq.*Yq + coeffs1(8)*Xq.^2.*Yq + coeffs1(9)*Xq.*Yq.^2;
Z2q = coeffs2(1) + coeffs2(2)*Xq + coeffs2(3)*Yq + coeffs2(4)*Xq.^2 + coeffs2(5)*Yq.^2 + coeffs2(6)*Xq.*Yq.^2 + coeffs2(7)*Xq.*Yq + coeffs2(8)*Xq.^2.*Yq + coeffs2(9)*Xq.*Yq.^2;

% plot the data and the polynomials
figure
subplot(2,2,1)
scatter3(X,Y,z1,'filled')
xlabel('x from eye')
ylabel('y from eye')
zlabel('z1')
title('Scatter plot of z1')
hold on
surf(Xq,Yq,Z1q,'FaceAlpha',0.5)
hold off

subplot(2,2,2)
scatter3(X,Y,z2,'filled')
xlabel('x from eye')
ylabel('y from eye')
zlabel('z2')
title('Scatter plot of z2')
hold on
surf(Xq,Yq,Z2q,'FaceAlpha',0.5)
hold off

subplot(2,2,3)
scatter(X,Y)
xlabel('x from eye')
ylabel('y from eye')
title('Scatter plot of x and y from eye')

subplot(2,2,4)
scatter(raw_vector_sc(:,1), raw_vector_sc(:,2), 'filled', 'y')
hold on
            scatter(x_eval, y_eval, 'filled', 'g')
hold on
scatter(z1,z2, 'r')
legend ('calibrated', 'raw', 'cal grid')
xlabel('x z')
ylabel('y z')
title('compared scaled row data with calibration points')


% figure
% subplot(2,1,1)
% scatter(raw_vector_sc(:,1), raw_vector_sc(:,2))
% hold on
%             scatter(x_eval, y_eval, 'filled', 'r')
%             hold on
%             scatter(xy(1,:), xy(2,:))
% xlabel('x')
% ylabel('y')
% title('compared scaled row data with calibrated points')
% 
% subplot(2,1,2)
% 
%             [x_eval_cartesian,y_eval_cartesian] = evaluate_bestpoly(raw_vector(:,1)', raw_vector(:,2)', coeffs1, coeffs2);
%             right_eye_eval = [x_eval_cartesian' y_eval_cartesian'];
%  %      scatter(raw_vector_sc(:,1), raw_vector_sc(:,2))
%               scatter(raw_vector(:,1), raw_vector(:,2))
% 
% hold on
%             scatter(x_eval_cartesian, y_eval_cartesian, 'filled', 'r')
%             xlim([0 2000])
%             ylim([0 1000])
            
function [x,y] = evaluate_bestpoly(xi,yi,cx,cy)
% Helper function for TPxCalibration
x = cx(1)+...
    cx(2).*xi+...
    cx(3).*yi+...
    cx(4).*xi.*xi+...
    cx(5).*yi.*yi+...
    cx(6).*xi.*xi.*xi+...
    cx(7).*xi.*yi+...
    cx(8).*xi.*xi.*yi+...
    cx(9).*xi.*xi.*yi.*yi;

y = cy(1)+...
    cy(2).*xi+...
    cy(3).*yi+...
    cy(4).*xi.*xi+...
    cy(5).*yi.*yi+...
    cy(6).*xi.*yi.*yi+...
    cy(7).*xi.*yi+...
    cy(8).*xi.*xi.*yi+...c
    cy(9).*xi.*xi.*yi.*yi;
end

% 1 = Cst
% 2 = x
% 3 = y
% 4 = x^2
% 5 = y^2
% 6 = x^3 || xy^2
% 7 = xy
% 8 = x^2y
% 9 = x^2y^2