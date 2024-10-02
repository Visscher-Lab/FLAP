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
raw_vector=[1.58472752571106,7.65252709388733,5.31925916671753,9.09553146362305;2.05295991897583,2.80770492553711,5.16385459899902,2.87255859375000;11.4592037200928,9.03103065490723,15.8779797554016,9.69133949279785;1.64066886901855,14.0157184600830,4.95843887329102,15.3202762603760;-7.73538804054260,6.95549893379211,-4.63565969467163,7.43588447570801;11.2235240936279,3.15079331398010,15.6669464111328,4.09883308410645;-6.83865165710449,1.10151863098145,-3.77890777587891,2.20120143890381;11.2682209014893,14.3113632202148,16.1503162384033,16.7249488830566;-8.83890199661255,13.2334923744202,-5.24245071411133,13.6750879287720;6.16277861595154,5.13530182838440,10.4521312713623,6.64059543609619;-2.83881711959839,4.59254407882690,0.198178291320801,5.35454368591309;-3.11083340644836,10.3460788726807,-0.519836425781250,11.2702693939209;6.45490264892578,11.4314870834351,9.65180683135986,12.2333393096924]
raw_vector_sc= [982.725706620572,536.245169665783,949.423918802929,516.718116115085;1021.47958994661,198.827392736367,937.219809145370,122.526805484156;1800,632.251089157974,1778.61308485908,554.459297511178;987.355767083763,979.409812319596,921.088262442904,911.021668626820;211.333815680729,487.700623743550,167.652036546813,411.588552636167;1780.49365896567,222.721793252238,1762.04037974064,200.204590468095;285.553407656554,80,234.933806444400,80;1784.19305034017,1000,1800,1000;120,924.931654461754,120,806.807981980469;1361.63425793796,360.932944861093,1352.51460618078,361.211339781406;616.605088872300,323.132566043626,547.259210994750,279.746992186682;594.091295305255,723.837659475209,490.872642234899,654.475874818023;1385.81229613750,799.430945009236,1289.66415480211,715.481088927999]
%close all
% input data
x_from_eye = [1.2450 1.7453 11.4313 1.1994 -7.8870 11.2800 -7.2230 11.1132 -9.1896 5.8908 -2.8528 -3.1911 6.5344];
y_from_eye =   [5.9377    1.3619   7.5133  12.9373   6.2685   2.3452   0.4560  13.1628  13.0640   4.7474   3.9025   9.9113  10.4464];
x_visual_stimuli = [960 960 1560 960 360 1560 360 1560 360 1260 660 660 1260];
y_visual_stimuli = [540 890 540  190 540 890  890 190  190 715  715 365 365];
xyCartesian= [   0     0
     0  -350
   600     0
     0   350
  -600     0
   600  -350
  -600  -350
   600   350
  -600   350
   300  -175
  -300  -175
  -300   175
   300   175];

            visual_stimuli = [x_visual_stimuli' y_visual_stimuli'];


            visual_stimuli_custom = Datapixx('ConvertCoordSysToCustom', visual_stimuli);

% calibration coordinates system to custom
z1 =visual_stimuli_custom(:,1)';
z2 =visual_stimuli_custom(:,2)';
ti='custom'
%calibration coordinates pixels
% z1 = x_visual_stimuli;
% z2 = y_visual_stimuli;
% ti='pixel'
% %calibration coordinates cartesian
% z1 = xyCartesian(:,1)';
% z2 = xyCartesian(:,2)';
% ti='cartesian'
% % fit polynomial for z1
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

coeff_x= [ -142.9593   69.8900    6.4692         0   -0.2572   -0.0303   -0.6137         0    0.0020];
coeff_y= [ -494.1067   -7.9483   66.9448    0.2318   -0.4199    0.0251         0   -0.0198         0];
% this for x axis
% z1=a+bx+cy+dx^2+ey^2+fx^3+gxy+hx^2y+ixy^2
% and this for y axis
% z2=a+bx+cy+dx^2+ey^2+fxy^2+gxy+hx^2y+ixy^2

% evaluate polynomials on a grid
[Xq,Yq] = meshgrid(min(X):0.5:max(X), min(Y):0.5:max(Y));
Z1q = coeffs1(1) + coeffs1(2)*Xq + coeffs1(3)*Yq + coeffs1(4)*Xq.^2 + coeffs1(5)*Yq.^2 + coeffs1(6)*Xq.^3 + coeffs1(7)*Xq.*Yq + coeffs1(8)*Xq.^2.*Yq + coeffs1(9)*Xq.*Yq.^2;
Z2q = coeffs2(1) + coeffs2(2)*Xq + coeffs2(3)*Yq + coeffs2(4)*Xq.^2 + coeffs2(5)*Yq.^2 + coeffs2(6)*Xq.*Yq.^2 + coeffs2(7)*Xq.*Yq + coeffs2(8)*Xq.^2.*Yq + coeffs2(9)*Xq.*Yq.^2;


[Xq,Yq] = meshgrid(min(X):0.5:max(X), min(Y):0.5:max(Y));
Z1q_ori = coeff_x(1) + coeff_x(2)*Xq + coeff_x(3)*Yq + coeff_x(4)*Xq.^2 + coeff_x(5)*Yq.^2 + coeff_x(6)*Xq.^3 + coeff_x(7)*Xq.*Yq + coeff_x(8)*Xq.^2.*Yq + coeff_x(9)*Xq.*Yq.^2;
Z2q_ori = coeff_y(1) + coeff_y(2)*Xq + coeff_y(3)*Yq + coeff_y(4)*Xq.^2 + coeff_y(5)*Yq.^2 + coeff_y(6)*Xq.*Yq.^2 + coeff_y(7)*Xq.*Yq + coeff_y(8)*Xq.^2.*Yq + coeff_y(9)*Xq.*Yq.^2;

            %evaluate_bestpoly applies raw eye positions to the polynomial
            %and returns calibrated gaze position on screen.
            %Evaluate all the calibration points
            [x_eval_cartesian,y_eval_cartesian] = evaluate_bestpoly(raw_vector(:,1)', raw_vector(:,2)', coeffs1, coeffs2);
            right_eye_eval = [x_eval_cartesian' y_eval_cartesian'];
            %convert back to PsychToolbox coordinate system for display
            xy_eval = Datapixx('ConvertCoordSysToCustom', right_eye_eval);
            %transpose for easier manipulation
            x_eval = xy_eval(:,1)';
            y_eval = xy_eval(:,2)';

  %evaluate_bestpoly applies raw eye positions to the polynomial
            %and returns calibrated gaze position on screen.
            %Evaluate all the calibration points
            [x_eval_cartesian_ori,y_eval_cartesian_ori] = evaluate_bestpoly(raw_vector(:,1)', raw_vector(:,2)', coeff_x, coeff_y);
            right_eye_eval_ori = [x_eval_cartesian_ori' y_eval_cartesian_ori'];
            %convert back to PsychToolbox coordinate system for display
            xy_eval_ori = Datapixx('ConvertCoordSysToCustom', right_eye_eval_ori);
            %transpose for easier manipulation
            x_eval_ori = xy_eval_ori(:,1)';
            y_eval_ori = xy_eval_ori(:,2)';
% plot the data and the polynomials
figure
subplot(2,2,1)
scatter3(X,Y,x_visual_stimuli,'filled')
xlabel('x from eye')
ylabel('y from eye')
zlabel('z1')
title([ti ' Scatter plot of z1 MM'])
hold on
surf(Xq,Yq,Z1q,'FaceAlpha',0.5)
hold off

subplot(2,2,2)
scatter3(X,Y,y_visual_stimuli,'filled')
xlabel('x from eye')
ylabel('y from eye')
zlabel('z2')
title([ti ' Scatter plot of z2 MM'])
hold on
surf(Xq,Yq,Z2q,'FaceAlpha',0.5)
hold off


subplot(2,2,3)
scatter3(X,Y,x_visual_stimuli,'filled')
xlabel('x from eye')
ylabel('y from eye')
zlabel('z1')
title([ti ' Scatter plot of z1 Vpixx'])
hold on
surf(Xq,Yq,Z1q_ori,'FaceAlpha',0.5)
hold off

subplot(2,2,4)
scatter3(X,Y,y_visual_stimuli,'filled')
xlabel('x from eye')
ylabel('y from eye')
zlabel('z2')
title([ ti ' Scatter plot of z2 Vpixx'])
hold on
surf(Xq,Yq,Z2q_ori,'FaceAlpha',0.5)
hold off
print([ti ' one'], '-dpng', '-r300')

% subplot(2,2,3)
% scatter(X,Y)
% xlabel('x from eye')
% ylabel('y from eye')
% title('Scatter plot of x and y from eye')
% 
% subplot(2,2,4)
% scatter(raw_vector_sc(:,1), raw_vector_sc(:,2), 'filled', 'y')
% hold on
%             scatter(x_eval, y_eval, 'filled', 'g')
% hold on
% scatter(z1,z2, 'r')
% legend ('calibrated', 'raw', 'cal grid')
% xlabel('x z')
% ylabel('y z')
% title('compared scaled row data with calibration points')

figure
subplot(2,1,1)
scatter(raw_vector_sc(:,1), raw_vector_sc(:,2), 'filled', 'y')
hold on
            scatter(x_eval, y_eval, 'filled', 'g')
hold on
scatter(x_visual_stimuli,y_visual_stimuli, 'r')
legend ('raw', 'calibrated', 'cal grid')
xlabel('x z')
ylabel('y z')
title([ ti ' MM compared scaled row data with calibration points'])
subplot(2,1,2)
scatter(raw_vector_sc(:,1), raw_vector_sc(:,2), 'filled', 'y')
hold on
            scatter(x_eval_ori, y_eval_ori, 'filled', 'g')
hold on
scatter(x_visual_stimuli,y_visual_stimuli, 'r')
legend ('raw', 'calibrated', 'cal grid')
xlabel('x z')
ylabel('y z')
title([ ti 'Vpixx compared scaled row data with calibration points'])

print([ti ' two'], '-dpng', '-r300')

      figure
      scatter(raw_vector_sc(:,1), raw_vector_sc(:,2), 'filled', 'r')
hold on
      scatter(x_eval, y_eval, 'filled', 'y')
hold on
            scatter(x_eval_ori, y_eval_ori, 'filled', 'g')

%  hold on
%       scatter(x_eval_cartesian, y_eval_cartesian, 'filled', 'r')
legend ('raw', 'MM', 'Vpixx')
xlabel('x z')
ylabel('y z')
title([ ti 'Vpixx MM compared scaled row data with calibration points'])
print([ti ' three'], '-dpng', '-r300')



      figure
      scatter(raw_vector_sc(:,1), raw_vector_sc(:,2), 'filled', 'r')
hold on
   %   scatter(x_eval, y_eval, 'filled', 'y')
hold on
            scatter(x_eval_ori, y_eval_ori, 'filled', 'g')
hold on
scatter(x_visual_stimuli, y_visual_stimuli, 'filled', 'k')
%  hold on
%       scatter(x_eval_cartesian, y_eval_cartesian, 'filled', 'r')
%legend ('raw', 'MM', 'Vpixx', 'cal')
legend ('raw','Vpixx', 'cal')

xlabel('x z')
ylabel('y z')
title([ ti 'Vpixx compared scaled row data with calibration points'])
print([ti ' four'], '-dpng', '-r300')

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