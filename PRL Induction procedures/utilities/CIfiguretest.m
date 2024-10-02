clear all
close all


%% 6 vs 9 with 19 elements
%xfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -2 -1];

xfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1 -2];


%yfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  4 5];
yfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  5 4 ];

%orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 150 90] ;
orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 90 150 ] ;
Xoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0 1/4 ];
Yoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 -1/4 0];

%Xoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 1/4 0];

%Xoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0];
%Yoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 1/4];

Targx{1}= [xfoo; -xfoo];
Targy{1}= [yfoo; -yfoo];

Targori{1}=[orifoo; orifoo];

offsetx{1}= [Xoff; -Xoff];
offsety{1}=[Yoff; -Yoff];
newxfoo{1}=[Targx{1}(1,:)+offsetx{1}(1,:); Targx{1}(2,:)+offsetx{1}(2,:)]
newyfoo{1}=[Targy{1}(1,:)+offsety{1}(1,:); Targy{1}(2,:)+offsety{1}(2,:)]

figure
subplot(2,2,1)

scatter(newxfoo{1}(1,:), newyfoo{1}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,2)
scatter(newxfoo{1}(2,:), newyfoo{1}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,3)
scatter(newxfoo{1}(1,:), newyfoo{1}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{1}(2,:), newyfoo{1}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

% subplot(2,2,4)
% for ui=1:length(eccentricity_X)
% text(eccentricity_X(ui), eccentricity_Y(ui),num2str(ui))
% hold on
% xlim([-8 8])
% ylim([-8 8])
% end
% set (gca,'YDir','reverse')

%      print(['CI_six_nine19'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
figure

for ui=1:length(newxfoo{1}(1,:))
text(newxfoo{1}(1,ui), newyfoo{1}(1,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end

for ui=1:length(newxfoo{1}(2,:))
text(newxfoo{1}(2,ui), newyfoo{1}(2,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')

clear all


%% 6 vs 9 with 18 elements

xfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1];
yfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  5];

orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 90] ;
Xoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0];
Yoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 -1/4];


Targx{1}= [xfoo; -xfoo];
Targy{1}= [yfoo; -yfoo];

Targori{1}=[orifoo; orifoo];

offsetx{1}= [Xoff; -Xoff];
offsety{1}=[Yoff; -Yoff];
newxfoo{1}=[Targx{1}(1,:)+offsetx{1}(1,:); Targx{1}(2,:)+offsetx{1}(2,:)]
newyfoo{1}=[Targy{1}(1,:)+offsety{1}(1,:); Targy{1}(2,:)+offsety{1}(2,:)]

figure
subplot(2,2,1)

scatter(newxfoo{1}(1,:), newyfoo{1}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,2)
scatter(newxfoo{1}(2,:), newyfoo{1}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,3)
scatter(newxfoo{1}(1,:), newyfoo{1}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{1}(2,:), newyfoo{1}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

     print(['CI_six_nine18'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%% 2 vs 5

Targx{2}= [2    2    2   1   1   0   0   -1  -1  -2  -2  -2     0   -1      1
          -2   -2   -2  -1  -1   0   0    1   1   2   2   2     0    1     -1];
Targy{2} =[-1   0   1   -2   2  -2   2    2   6   3   5   4     6   -2      6
           -1   0   1   -2   2  -2   2    2   6   3   5   4     6   -2      6];

Targori{2} =[150    0   30      120     60      90      90      60      120   30     150      0     90      60     60
             30     0   150     60      120     90      90      120     60   150      30      0     90     120      120];

Xoff=[0 0.2193  0 0 0   0        0      0       0 0 0 -0.2193   0       0   0];
Yoff=[0 0       0 0 0 0.1096 -0.1827 -0.1827    0 0 0   0    -0.1827    0   0];

offsetx{2}= [Xoff; -Xoff];
offsety{2}=[-Yoff; -Yoff];


newxfoo{2}=[Targx{2}(1,:)+offsetx{2}(1,:); Targx{2}(2,:)+offsetx{2}(2,:)]
newyfoo{2}=[Targy{2}(1,:)+offsety{2}(1,:); Targy{2}(2,:)+offsety{2}(2,:)]

figure
subplot(2,2,1)

scatter(newxfoo{2}(1,:), newyfoo{2}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,2)
scatter(newxfoo{2}(2,:), newyfoo{2}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,3)
scatter(newxfoo{2}(1,:), newyfoo{2}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{2}(2,:), newyfoo{2}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

     print(['CI_shape2'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI



%% p and q
clear all
angl= [0:30:360];
ecc_r=2.25;

    for ui=1:length(angl)
        ecc_t=deg2rad(angl(ui));
        cs= [cos(ecc_t), sin(ecc_t)];
        xxyy=[ecc_r ecc_r].*cs;
        ecc_x=xxyy(1);
        ecc_y=xxyy(2);
        eccentricity_X(ui)=ecc_x;
        eccentricity_Y(ui)=ecc_y;
    end
    
    eccentricity_X=eccentricity_X(1:end-1);
    eccentricity_Y=eccentricity_Y(1:end-1);
    Targx{3}= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1
        2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
    Targy{3} =[-1	0	1	-2	2	-2	2	-2	2	0	1	-1	3	4	5
        -1	0	1	-2	2	-2	2	-2	0	-1	1	2	3	4	5];

Targori{3} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
             150     0       30     120      60     90      90      0       0       0       0       0       0       0       0];

Xoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0];
Yoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0];


Xoff=-[0.051442841	-0.25	0.051442841	-0.125	-0.125	0	0	0.125	0.125 zeros(1,6)];
Yoff=-[-0.125	0	0.125	0.051442841	-0.051442841	-0.25	0.25	0.051442841	-0.051442841 zeros(1,6)];
Xoff(10:end)=Xoff(10:end)-0.125;
offsetx{3}= [-Xoff; Xoff];
offsety{3}=[-Yoff; -Yoff];




newxfoo{3}=[Targx{3}(1,:)+offsetx{3}(1,:); Targx{3}(2,:)+offsetx{3}(2,:)];
newyfoo{3}=[Targy{3}(1,:)+offsety{3}(1,:); Targy{3}(2,:)+offsety{3}(2,:)];

figure
subplot(2,2,1)

scatter(newxfoo{3}(1,:), newyfoo{3}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,2)
scatter(newxfoo{3}(2,:), newyfoo{3}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,3)
scatter(newxfoo{3}(1,:), newyfoo{3}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{3}(2,:), newyfoo{3}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
hold on
set (gca,'YDir','reverse')

scatter(eccentricity_X, eccentricity_Y, 'k');
subplot(2,2,4)
% scatter(eccentricity_X, eccentricity_Y, 'k');
% xlim([-8 8])
% ylim([-8 8])
% pbaspect([1 1 1]);
% 
% figure
for ui=1:length(eccentricity_X)
text(eccentricity_X(ui), eccentricity_Y(ui),num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')


     print(['CI_shape3'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


figure

for ui=1:length(newxfoo{3}(1,:))
text(newxfoo{3}(1,ui), newyfoo{3}(1,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')



     print(['CI_shape3_coord'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

% %% p and q less elements
% clear all
% angl= [0:30:360];
% ecc_r=2.25;
% 
%     for ui=1:length(angl)
%         ecc_t=deg2rad(angl(ui));
%         cs= [cos(ecc_t), sin(ecc_t)];
%         xxyy=[ecc_r ecc_r].*cs;
%         ecc_x=xxyy(1);
%         ecc_y=xxyy(2);
%         eccentricity_X(ui)=ecc_x;
%         eccentricity_Y(ui)=ecc_y;
%     end    
%     eccentricity_X=eccentricity_X(1:end-1);
%     eccentricity_Y=eccentricity_Y(1:end-1);
%     Targx{3}= [-2       -2      -2      -1      -1             1       1       1       1       1       1       1       1
%                 2        2       2       1       1             -1      -1      -1      -1      -1      -1      -1      -1];
%     Targy{3} =[-1	0	1	-2	2		-2	2	0	1	-1	3	4	5
%                -1	0	1	-2	2		-2	0	-1	1	2	3	4	5];
% 
% Targori{3} =[30     0       150     60      120          0       0       0       0       0       0       0       0
%              150     0       30     120      60           0       0       0       0       0       0       0       0];
% 
% Targx{3}(1,6:end)=Targx{3}(1,6:end)-1-0.125;
% Targx{3}(2,6:end)=Targx{3}(2,6:end)+1+0.125;
% 
% Xoff=-[0.05	-0.25	0.05	-0.125	-0.125	0	0	0.125	0.125 zeros(1,6)];
% Yoff=-[-0.125	0	0.125	0.05	-0.05	-0.25	0.25	0.05	-0.05 zeros(1,6)];
% Xoff(10:end)=Xoff(10:end)-0.125;
% 
% Xoff=[Xoff(1:5) Xoff(8:end) ];
% Yoff=[Yoff(1:5) Yoff(8:end) ]
% 
% offsetx{3}= [-Xoff; Xoff];
% offsety{3}=[-Yoff; -Yoff];
% 
% offsety{3}(1,6)=-0.25;
% offsety{3}(1,7)=0.25;
% 
% offsety{3}(2,6)=-0.25;
% offsety{3}(2,10)=0.25;
% figure; scatter(Targx{3}(1,:), Targy{3}(1,:), 'filled', 'r'); hold on ; scatter(Targx{3}(2,:), Targy{3}(2,:), 'filled', 'k')
% xlim([-8 8])
% ylim([-8 8])
% pbaspect([1 1 1]);
% set (gca,'YDir','reverse')
% 
% newxfoo{3}=[Targx{3}(1,:)+offsetx{3}(1,:); Targx{3}(2,:)+offsetx{3}(2,:)];
% newyfoo{3}=[Targy{3}(1,:)+offsety{3}(1,:); Targy{3}(2,:)+offsety{3}(2,:)];
% 
% figure
% subplot(2,2,1)
% 
% scatter(newxfoo{3}(1,:), newyfoo{3}(1,:), 'filled')
% xlim([-8 8])
% ylim([-8 8])
% pbaspect([1 1 1]);
% set (gca,'YDir','reverse')
% 
% subplot(2,2,2)
% scatter(newxfoo{3}(2,:), newyfoo{3}(2,:), 'filled')
% 
% xlim([-8 8])
% ylim([-8 8])
% pbaspect([1 1 1]);
% set (gca,'YDir','reverse')
% 
% subplot(2,2,3)
% scatter(newxfoo{3}(1,:), newyfoo{3}(1,:), 'filled', 'r')
% hold on
% scatter(newxfoo{3}(2,:), newyfoo{3}(2,:), 'filled', 'b')
% xlim([-8 8])
% ylim([-8 8])
% pbaspect([1 1 1]);
% hold on
% set (gca,'YDir','reverse')
% 
% scatter(eccentricity_X, eccentricity_Y, 'k');
% subplot(2,2,4)
% 
% 
%      print(['CI_shapeP_q_2_cc'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% % scatter(eccentricity_X, eccentricity_Y, 'k');
% % xlim([-8 8])
% % ylim([-8 8])
% % pbaspect([1 1 1]);
% % 
% % figure
% for ui=1:length(eccentricity_X)
% text(eccentricity_X(ui), eccentricity_Y(ui),num2str(ui))
% hold on
% xlim([-8 8])
% ylim([-8 8])
% end
% set (gca,'YDir','reverse')
% 
% 
%      print(['CI_shapeP_q_2_cc'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% 
% figure
% subplot(2,1,1)
% 
% for ui=1:length(newxfoo{3}(1,:))
% text(newxfoo{3}(1,ui), newyfoo{3}(1,ui), num2str(ui))
% hold on
% xlim([-8 8])
% ylim([-8 8])
% end
% set (gca,'YDir','reverse')
% 
% 
% subplot(2,1,2)
% for ui=1:length(newxfoo{3}(2,:))
% text(newxfoo{3}(2,ui), newyfoo{3}(2,ui), num2str(ui))
% hold on
% xlim([-8 8])
% ylim([-8 8])
% end
% set (gca,'YDir','reverse')
% 
%      print(['CI_shapeP_Q_2_coord'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
%      
     
     
     %% d and b
clear all
angl= [0:30:360];
ecc_r=2.25;


    for ui=1:length(angl)
        ecc_t=deg2rad(angl(ui));
        cs= [cos(ecc_t), sin(ecc_t)];
        xxyy=[ecc_r ecc_r].*cs;
        ecc_x=xxyy(1);
        ecc_y=xxyy(2);
        eccentricity_X(ui)=ecc_x;
        eccentricity_Y(ui)=ecc_y;
    end
    
    eccentricity_X=eccentricity_X(1:end-1);
    eccentricity_Y=eccentricity_Y(1:end-1);
    Targx{4}= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1
        2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
    Targy{4} =[-1	0	1	-2	2	-2	2	-2	2	0	1	-1	-3	-4	-5
        -1	0	1	-2	2	-2	2	-2	0	-1	1	2	-3	-4	-5];

Targori{4} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
             150     0       30     120      60     90      90      0       0       0       0       0       0       0       0];

Xoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0];
Yoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0];


Xoff=-[0.051442841	-0.25	0.051442841	-0.125	-0.125	0	0	0.125	0.125 zeros(1,6)];
Yoff=-[-0.125	0	0.125	0.051442841	-0.051442841	-0.25	0.25	0.051442841	-0.051442841 zeros(1,6)];
Xoff(10:end)=Xoff(10:end)-0.125;
offsetx{4}= [-Xoff; Xoff];
offsety{4}=[-Yoff; -Yoff];

newxfoo{4}=[Targx{4}(1,:)+offsetx{4}(1,:); Targx{4}(2,:)+offsetx{4}(2,:)];
newyfoo{4}=[Targy{4}(1,:)+offsety{4}(1,:); Targy{4}(2,:)+offsety{4}(2,:)];

figure
subplot(2,2,1)

scatter(newxfoo{4}(1,:), newyfoo{4}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,2)
scatter(newxfoo{4}(2,:), newyfoo{4}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,3)
scatter(newxfoo{4}(1,:), newyfoo{4}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{4}(2,:), newyfoo{4}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
hold on
set (gca,'YDir','reverse')

scatter(eccentricity_X, eccentricity_Y, 'k');
subplot(2,2,4)
% scatter(eccentricity_X, eccentricity_Y, 'k');
% xlim([-8 8])
% ylim([-8 8])
% pbaspect([1 1 1]);
% 
% figure
for ui=1:length(eccentricity_X)
text(eccentricity_X(ui), eccentricity_Y(ui),num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')


     print(['CI_shape3DP'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


figure

for ui=1:length(newxfoo{4}(1,:))
text(newxfoo{4}(1,ui), newyfoo{4}(1,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')



     print(['CI_shape3_coordDP'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

     
     %% d and p more elements

     clear all
angl= [0:30:360];
ecc_r=2.25;


    for ui=1:length(angl)
        ecc_t=deg2rad(angl(ui));
        cs= [cos(ecc_t), sin(ecc_t)];
        xxyy=[ecc_r ecc_r].*cs;
        ecc_x=xxyy(1);
        ecc_y=xxyy(2);
        eccentricity_X(ui)=ecc_x;
        eccentricity_Y(ui)=ecc_y;
    end
    
    eccentricity_X=eccentricity_X(1:end-1);
    eccentricity_Y=eccentricity_Y(1:end-1);
    Targx{4}= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1 0 0
        2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1 0 0];
    Targy{4} =[-1	0	1	-2	2	-2	2	-2	2	0	1	-1	-3	-4	-5 -2 2
        -1	0	1	-2	2	-2	2	-2	0	-1	1	2	-3	-4	-5 -2 2];

    
    Targx{4}(1,1:7)=Targx{4}(1,1:7)-1;
    Targx{4}(2,1:7)=Targx{4}(2,1:7)+1;
Targori{4} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0 180 180
             150     0       30     120      60     90      90      0       0       0       0       0       0       0       0 180 180];

%Xoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0 0 0];
%Yoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0 0 0];


Xoff=-[0.051442841	-0.25	0.051442841	-0.125	-0.125	0	0	0.125	0.125 zeros(1,8)];
Yoff=-[-0.125	0	0.125	0.051442841	-0.051442841	-0.25	0.25	0.051442841	-0.051442841 zeros(1,8)];
Xoff(10:end-2)=Xoff(10:end-2)-0.125;

Yoff(6:7)=0;
offsetx{4}= [-Xoff; Xoff];
offsety{4}=[-Yoff; -Yoff];

newxfoo{4}=[Targx{4}(1,:)+offsetx{4}(1,:); Targx{4}(2,:)+offsetx{4}(2,:)];
newyfoo{4}=[Targy{4}(1,:)+offsety{4}(1,:); Targy{4}(2,:)+offsety{4}(2,:)];

figure
subplot(2,2,1)

scatter(newxfoo{4}(1,:), newyfoo{4}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,2)
scatter(newxfoo{4}(2,:), newyfoo{4}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,3)
scatter(newxfoo{4}(1,:), newyfoo{4}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{4}(2,:), newyfoo{4}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
hold on
set (gca,'YDir','reverse')

scatter(eccentricity_X, eccentricity_Y, 'k');
subplot(2,2,4)
scatter(eccentricity_X, eccentricity_Y, 'k');
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

% figure
% for ui=1:length(eccentricity_X)
% text(eccentricity_X(ui), eccentricity_Y(ui),num2str(ui))
% hold on
% xlim([-8 8])
% ylim([-8 8])
% end
% set (gca,'YDir','reverse')


     print(['CI_shape3DP_more'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


figure
subplot(2,1,1)
for ui=1:length(newxfoo{4}(1,:))
text(newxfoo{4}(1,ui), newyfoo{4}(1,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')

subplot(2,1,2)
for ui=1:length(newxfoo{4}(1,:))
text(newxfoo{4}(2,ui), newyfoo{4}(2,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')


     print(['CI_shape3_coordDP_more'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

% %% d and p less elements
% clear all
% angl= [0:30:360];
% ecc_r=2.25;
% 
%     for ui=1:length(angl)
%         ecc_t=deg2rad(angl(ui));
%         cs= [cos(ecc_t), sin(ecc_t)];
%         xxyy=[ecc_r ecc_r].*cs;
%         ecc_x=xxyy(1);
%         ecc_y=xxyy(2);
%         eccentricity_X(ui)=ecc_x;
%         eccentricity_Y(ui)=ecc_y;
%     end    
%     eccentricity_X=eccentricity_X(1:end-1);
%     eccentricity_Y=eccentricity_Y(1:end-1);
%     Targx{4}= [-2       -2      -2      -1      -1             1       1       1       1       1       1       1       1
%                 2        2       2       1       1             -1      -1      -1      -1      -1      -1      -1      -1];
%     Targy{4} =[-1	0	1	-2	2		-2	2	0	1	-1	-3	-4	-5
%                -1	0	1	-2	2		-2	0	-1	1	2	-3	-4	-5];
% 
% Targori{4} =[30     0       150     60      120          0       0       0       0       0       0       0       0
%              150     0       30     120      60           0       0       0       0       0       0       0       0];
% 
% Targx{4}(1,6:end)=Targx{4}(1,6:end)-1-0.125;
% Targx{4}(2,6:end)=Targx{4}(2,6:end)+1+0.125;
% 
% Xoff=-[0.05	-0.25	0.05	-0.125	-0.125	0	0	0.125	0.125 zeros(1,6)];
% Yoff=-[-0.125	0	0.125	0.05	-0.05	-0.25	0.25	0.05	-0.05 zeros(1,6)];
% Xoff(10:end)=Xoff(10:end)-0.125;
% 
% Xoff=[Xoff(1:5) Xoff(8:end) ];
% Yoff=[Yoff(1:5) Yoff(8:end) ]
% 
% offsetx{4}= [-Xoff; Xoff];
% offsety{4}=[-Yoff; -Yoff];
% 
% offsety{4}(1,6)=-0.25;
% offsety{4}(1,7)=0.25;
% 
% offsety{4}(2,6)=-0.25;
% offsety{4}(2,10)=0.25;
% figure; scatter(Targx{4}(1,:), Targy{4}(1,:), 'filled', 'r'); hold on ; scatter(Targx{4}(2,:), Targy{4}(2,:), 'filled', 'k')
% xlim([-8 8])
% ylim([-8 8])
% pbaspect([1 1 1]);
% set (gca,'YDir','reverse')
% 
% newxfoo{4}=[Targx{4}(1,:)+offsetx{4}(1,:); Targx{4}(2,:)+offsetx{4}(2,:)];
% newyfoo{4}=[Targy{4}(1,:)+offsety{4}(1,:); Targy{4}(2,:)+offsety{4}(2,:)];
% 
% figure
% subplot(2,2,1)
% 
% scatter(newxfoo{4}(1,:), newyfoo{4}(1,:), 'filled')
% xlim([-8 8])
% ylim([-8 8])
% pbaspect([1 1 1]);
% set (gca,'YDir','reverse')
% 
% subplot(2,2,2)
% scatter(newxfoo{4}(2,:), newyfoo{4}(2,:), 'filled')
% 
% xlim([-8 8])
% ylim([-8 8])
% pbaspect([1 1 1]);
% set (gca,'YDir','reverse')
% 
% subplot(2,2,3)
% scatter(newxfoo{4}(1,:), newyfoo{4}(1,:), 'filled', 'r')
% hold on
% scatter(newxfoo{4}(2,:), newyfoo{4}(2,:), 'filled', 'b')
% xlim([-8 8])
% ylim([-8 8])
% pbaspect([1 1 1]);
% hold on
% set (gca,'YDir','reverse')
% 
% scatter(eccentricity_X, eccentricity_Y, 'k');
% subplot(2,2,4)
% 
% 
%      print(['CI_shapeD_P_2_cc'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% % scatter(eccentricity_X, eccentricity_Y, 'k');
% % xlim([-8 8])
% % ylim([-8 8])
% % pbaspect([1 1 1]);
% % 
% % figure
% for ui=1:length(eccentricity_X)
% text(eccentricity_X(ui), eccentricity_Y(ui),num2str(ui))
% hold on
% xlim([-8 8])
% ylim([-8 8])
% end
% set (gca,'YDir','reverse')
% 
% 
%      print(['CI_shapeD_P_2_cc2'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% 
% figure
% subplot(2,1,1)
% 
% for ui=1:length(newxfoo{4}(1,:))
% text(newxfoo{4}(1,ui), newyfoo{4}(1,ui), num2str(ui))
% hold on
% xlim([-8 8])
% ylim([-8 8])
% end
% set (gca,'YDir','reverse')
% 
% 
% subplot(2,1,2)
% for ui=1:length(newxfoo{4}(2,:))
% text(newxfoo{4}(2,ui), newyfoo{4}(2,ui), num2str(ui))
% hold on
% xlim([-8 8])
% ylim([-8 8])
% end
% set (gca,'YDir','reverse')
% 
%      print(['CI_shapeD_P_2_cc_coord'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%% p and q more elements

     %% d and p more elements

     clear all
angl= [0:30:360];
ecc_r=2.25;


    for ui=1:length(angl)
        ecc_t=deg2rad(angl(ui));
        cs= [cos(ecc_t), sin(ecc_t)];
        xxyy=[ecc_r ecc_r].*cs;
        ecc_x=xxyy(1);
        ecc_y=xxyy(2);
        eccentricity_X(ui)=ecc_x;
        eccentricity_Y(ui)=ecc_y;
    end
    
    eccentricity_X=eccentricity_X(1:end-1);
    eccentricity_Y=eccentricity_Y(1:end-1);
    Targx{4}= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1 0 0
        2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1 0 0];
    Targy{4} =[-1	0	1	-2	2	-2	2	-2	2	0	1	-1	3	4	5 -2 2
        -1	0	1	-2	2	-2	2	-2	0	-1	1	2	3	4	5 -2 2];

    
    Targx{4}(1,1:7)=Targx{4}(1,1:7)-1;
    Targx{4}(2,1:7)=Targx{4}(2,1:7)+1;
Targori{4} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0 180 180
             150     0       30     120      60     90      90      0       0       0       0       0       0       0       0 180 180];

%Xoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0 0 0];
%Yoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0 0 0];


Xoff=-[0.051442841	-0.25	0.051442841	-0.125	-0.125	0	0	0.125	0.125 zeros(1,8)];
Yoff=-[-0.125	0	0.125	0.051442841	-0.051442841	-0.25	0.25	0.051442841	-0.051442841 zeros(1,8)];
Xoff(10:end-2)=Xoff(10:end-2)-0.125;

Yoff(6:7)=0;
offsetx{4}= [-Xoff; Xoff];
offsety{4}=[-Yoff; -Yoff];

newxfoo{4}=[Targx{4}(1,:)+offsetx{4}(1,:); Targx{4}(2,:)+offsetx{4}(2,:)];
newyfoo{4}=[Targy{4}(1,:)+offsety{4}(1,:); Targy{4}(2,:)+offsety{4}(2,:)];

figure
subplot(2,2,1)

scatter(newxfoo{4}(1,:), newyfoo{4}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,2)
scatter(newxfoo{4}(2,:), newyfoo{4}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,3)
scatter(newxfoo{4}(1,:), newyfoo{4}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{4}(2,:), newyfoo{4}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
hold on
set (gca,'YDir','reverse')

%scatter(eccentricity_X, eccentricity_Y, 'k');
subplot(2,2,4)
scatter(eccentricity_X, eccentricity_Y, 'k');
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

% figure
% for ui=1:length(eccentricity_X)
% text(eccentricity_X(ui), eccentricity_Y(ui),num2str(ui))
% hold on
% xlim([-8 8])
% ylim([-8 8])
% end
% set (gca,'YDir','reverse')
% 

     print(['CI_shapePQ_more'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


figure
subplot(2,1,1)
for ui=1:length(newxfoo{4}(1,:))
text(newxfoo{4}(1,ui), newyfoo{4}(1,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')

subplot(2,1,2)
for ui=1:length(newxfoo{4}(1,:))
text(newxfoo{4}(2,ui), newyfoo{4}(2,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')


     print(['CI_shape3_coordPQ_more'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


%%

xfoo= [-4    -4    -4    -3    -3    -2    -2    -1    -1     0     0     1     1     2     2     2]+1;
yfoo = [-1     0     1    -1     1    -2     2    -2     2    -2     2    -2     2    -1     0 1];

orifoo=    [35     0   -35    50   -45    55   -55    65   -70    90    90   -55    55   -30     0 35];
twoorifoo= [ -35     0    35   -50    45   -55    55   -65    70    90    90    55   -55    30     0 -35];


Xoff=[   -0.2198   -0.0122   -0.1954   -0.0855   -0.0488   -0.0122    0.0244         0    0.0367   0         0   -0.0611         0    0.1221    0.0122    0.1587];
Yoff=[   -0.1832   -0.0367    0.0244    0.0977   -0.2320   -0.2198    0.1466   -0.0488   -0.0122    0         0   -0.1221    0.0855    0.0244    0.0122   -0.0732];

Targx{5}= [xfoo; -xfoo];
Targy{5}= [yfoo; yfoo];
Targori{5}=[orifoo;twoorifoo];

offsetx{5}= [-Xoff; Xoff];
offsety{5}=[-Yoff; -Yoff];

newxfoo{5}=[Targx{5}(1,:)+offsetx{5}(1,:); Targx{5}(2,:)+offsetx{5}(2,:)]
newyfoo{5}=[Targy{5}(1,:)+offsety{5}(1,:); Targy{5}(2,:)+offsety{5}(2,:)]

figure
subplot(2,2,1)

scatter(newxfoo{5}(1,:), newyfoo{5}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

subplot(2,2,2)
scatter(newxfoo{5}(2,:), newyfoo{5}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

subplot(2,2,3)
scatter(newxfoo{5}(1,:), newyfoo{5}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{5}(2,:), newyfoo{5}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

     print(['CI_shape5'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

     
     %%
     xfoo=[-3  -2    -1     0     1     2  3];
yfoo= xfoo;
Xoff=[-0.0850   -0.0850   -0.0850         0    0.0850    0.0850  0.0850];
Yoff=Xoff;
orifoo=[45  45    45    45    45    45  45];
Targx{6}= [xfoo; -xfoo];
Targy{6}= [yfoo; yfoo];
Targori{6}=[-orifoo;orifoo];

offsetx{6}= [Xoff; Xoff];
offsety{6}=[Yoff; Yoff];

newxfoo{6}=[Targx{6}(1,:)+offsetx{6}(1,:); Targx{6}(2,:)+offsetx{6}(2,:)]
newyfoo{6}=[Targy{6}(1,:)+offsety{6}(1,:); Targy{6}(2,:)+offsety{6}(2,:)]

figure
subplot(2,2,1)

scatter(newxfoo{6}(1,:), newyfoo{6}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

subplot(2,2,2)
scatter(newxfoo{6}(2,:), newyfoo{6}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

subplot(2,2,3)
scatter(newxfoo{6}(1,:), newyfoo{6}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{6}(2,:), newyfoo{6}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

     print(['CI_shape6'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

     %%
     
matr=[90  -3     0     0     0
    90    -2     0     0     0
    90    -1     0     0     0
    90     0     0     0     0
    90     1     0     0     0
    90     2     0     0     0
    90     3     0     0     0];

xfoo=matr(:,2);
yfoo=matr(:,3);
orifoo=matr(:,1);


Xoff=matr(:,4);
Yoff=matr(:,5);

orifoo= [ 90   90    90    90    90    90   90];
xfoo=[-3  -2    -1     0     1      2   3];
yfoo = [0     0     0     0     0  0   0];
Xoff=[ 0    0     0     0     0     0  0];
Yoff=Xoff;
Targx{7}= [xfoo; yfoo];
Targy{7}= [yfoo; xfoo];
Targori{7}=[orifoo;orifoo+90];

offsetx{7}= [Xoff; Xoff];
offsety{7}=[Yoff; Yoff];



newxfoo{7}=[Targx{7}(1,:)+offsetx{7}(1,:); Targx{7}(2,:)+offsetx{7}(2,:)]
newyfoo{7}=[Targy{7}(1,:)+offsety{7}(1,:); Targy{7}(2,:)+offsety{7}(2,:)]

figure
subplot(2,2,1)

scatter(newxfoo{7}(1,:), newyfoo{7}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

subplot(2,2,2)
scatter(newxfoo{7}(2,:), newyfoo{7}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

subplot(2,2,3)
scatter(newxfoo{7}(1,:), newyfoo{7}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{7}(2,:), newyfoo{7}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

     print(['CI_shape7'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
     
     %%
     
     yfoo= [-4    -4    -4    -3    -3    -2    -2    -1    -1     0     0     1     1     2     2     2]+1;
xfoo = [-1     0     1    -1     1    -2     2    -2     2    -2     2    -2     2    -1     0 1];

twoorifoo=    [35     0   -35    50   -45    55   -55    65   -70    90    90   -55    55   -30     0 35];
orifoo= [ -35     0    35   -50    45   -55    55   -65    70    90    90    55   -55    30     0 -35];

twoorifoo=twoorifoo+90;
orifoo=orifoo+90;
Yoff=[   -0.2198   -0.0122   -0.1954   -0.0855   -0.0488   -0.0122    0.0244         0    0.0367   0         0   -0.0611         0    0.1221    0.0122    0.1587];
Xoff=[   -0.1832   -0.0367    0.0244    0.0977   -0.2320   -0.2198    0.1466   -0.0488   -0.0122    0         0   -0.1221    0.0855    0.0244    0.0122   -0.0732];

Targx{8}= [xfoo; xfoo];
Targy{8}= [yfoo; -yfoo];
Targori{8}=[orifoo;twoorifoo];

offsetx{8}= [-Xoff; -Xoff];
offsety{8}=[-Yoff; Yoff];

newxfoo{8}=[Targx{8}(1,:)+offsetx{8}(1,:); Targx{8}(2,:)+offsetx{8}(2,:)]
newyfoo{8}=[Targy{8}(1,:)+offsety{8}(1,:); Targy{8}(2,:)+offsety{8}(2,:)]

figure
subplot(2,2,1)

scatter(newxfoo{8}(1,:), newyfoo{8}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

subplot(2,2,2)
scatter(newxfoo{8}(2,:), newyfoo{8}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

subplot(2,2,3)
scatter(newxfoo{8}(1,:), newyfoo{8}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{8}(2,:), newyfoo{8}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

     print(['CI_shape8'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


     
     
     
     
     %% rotated 6/9

     %invert x and y
     %invert ori
     %add 90 deg to ori
     % invert - and + from targx and targy

     
  
     %% 6 vs 9 with 19 elements
clear all
close all
yfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1 -2];


xfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  5 4 ];

orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 90 150 ]+90 ;
Yoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0 1/4 ];
Xoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 -1/4 0];


Targx{9}= [xfoo; -xfoo];
Targy{9}= [yfoo; -yfoo];

Targori{9}=[orifoo; orifoo];

offsetx{9}= [Xoff; -Xoff];
offsety{9}=[Yoff; -Yoff];
newxfoo{9}=[Targx{9}(1,:)+offsetx{9}(1,:); Targx{9}(2,:)+offsetx{9}(2,:)];
newyfoo{9}=[Targy{9}(1,:)+offsety{9}(1,:); Targy{9}(2,:)+offsety{9}(2,:)];

figure
subplot(2,2,1)

scatter(newxfoo{9}(1,:), newyfoo{9}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,2)
scatter(newxfoo{9}(2,:), newyfoo{9}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,3)
scatter(newxfoo{9}(1,:), newyfoo{9}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{9}(2,:), newyfoo{9}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

     print(['CI_six_ninerotated'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
figure

for ui=1:length(newxfoo{9}(1,:))
text(newxfoo{9}(1,ui), newyfoo{9}(1,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end



     print(['CI_shaperotated9'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


     
     %% rotated d and b
     %invert x and y
     %invert ori
     %add 90 deg to ori
     % invert - and + from targx and targy

     
     
     Targy{10}= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1   
            2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
Targx{10} =[-1      0       1       -2      2       -2      2       -2      -1      0       1       2       3       4       5 
           -1      0       1       -2      2       -2      2       -2       2      -1       1       0       3       4       5];

Targori{10} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
             150     0       30     120      60     90      90      0       0       0       0       0       0       0       0];

Yoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0];
Xoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0];


offsetx{10}= [-Xoff; -Xoff];
offsety{10}=[-Yoff; Yoff];


newxfoo{10}=[Targx{10}(1,:)+offsetx{10}(1,:); Targx{10}(2,:)+offsetx{10}(2,:)];
newyfoo{10}=[Targy{10}(1,:)+offsety{10}(1,:); Targy{10}(2,:)+offsety{10}(2,:)];

figure
subplot(2,2,1)

scatter(newxfoo{10}(1,:), newyfoo{10}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

subplot(2,2,2)
scatter(newxfoo{10}(2,:), newyfoo{10}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
subplot(2,2,3)
scatter(newxfoo{10}(1,:), newyfoo{10}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{10}(2,:), newyfoo{10}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

     print(['CI_shape10'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

     
     %% rotated p and q
     
     Targy{11}= [-2       -2      -2      -1      -1      0       0       1       1       1       1       1       1       1       1   
            2        2       2       1       1      0       0       -1      -1      -1      -1      -1      -1      -1      -1];
Targx{11} =[-1      0       1       -2      2       -2      2       -2      -1      0       1       2       -3       -4       -5 
           -1      0       1       -2      2       -2      2       -2       2      -1       1       0       -3       -4       -5];

Targori{11} =[30     0       150     60      120     90      90      0       0       0       0       0       0       0       0
             150     0       30     120      60     90      90      0       0       0       0       0       0       0       0]+90;

Yoff=[0     0.2193      0       0       0       0       0       0       0       0       0       0       0       0       0];
Xoff=[0     0           0       0       0       0.1096  -0.1827 0       0       0       0       0       0       0       0];

offsetx{11}= [-Xoff; -Xoff];
offsety{11}=[-Yoff; Yoff];

newxfoo{11}=[Targx{11}(1,:)+offsetx{11}(1,:); Targx{11}(2,:)+offsetx{11}(2,:)]
newyfoo{11}=[Targy{11}(1,:)+offsety{11}(1,:); Targy{11}(2,:)+offsety{11}(2,:)]

figure
subplot(2,2,1)

scatter(newxfoo{11}(1,:), newyfoo{11}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

subplot(2,2,2)
scatter(newxfoo{11}(2,:), newyfoo{11}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);

subplot(2,2,3)
scatter(newxfoo{11}(1,:), newyfoo{11}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{11}(2,:), newyfoo{11}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);


     print(['CI_shape11'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
     
     
     
     
     
     %% 2 vs 5 
clear all

Xoff=[    0       0     0    -0.25  0   -0.25   0     0     0         0.25    0         0.25 -0.25  0     0     0 0.25 ];
Yoff=[    0.25    0     0.25  0     0     0     0   -0.25   0.25     0           0          0     0   -0.25   0   -0.25 0];
yfoo=[   -4      -4    -4    -3    -2    -1     0     0     0          1           2          3     3     4     4     4 -3];
xfoo=[   -1       0     1     2     2     2     0     1    -1         -2          -2         -2     2    -1     0     1 -2];
orifoo =[ 60     90   120   150     0    30    90    60    60       30   150      0        150    30   120    90    60];% 4 6 8
% 17 19 21


Targx{10}= [xfoo; -xfoo];
Targy{10}= [yfoo; yfoo];

Targori{10}=[orifoo; orifoo];

offsetx{10}= [Xoff; -Xoff];
offsety{10}=[Yoff; Yoff];
newxfoo{10}=[Targx{10}(1,:)+offsetx{10}(1,:); Targx{10}(2,:)+offsetx{10}(2,:)]
newyfoo{10}=[Targy{10}(1,:)+offsety{10}(1,:); Targy{10}(2,:)+offsety{10}(2,:)]

figure
subplot(2,2,1)

scatter(newxfoo{10}(1,:), newyfoo{10}(1,:), 'filled')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,2)
scatter(newxfoo{10}(2,:), newyfoo{10}(2,:), 'filled')

xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

subplot(2,2,3)
scatter(newxfoo{10}(1,:), newyfoo{10}(1,:), 'filled', 'r')
hold on
scatter(newxfoo{10}(2,:), newyfoo{10}(2,:), 'filled', 'b')
xlim([-8 8])
ylim([-8 8])
pbaspect([1 1 1]);
set (gca,'YDir','reverse')

     print(['CI_2vs59'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
figure
subplot(2,1,1)
for ui=1:length(newxfoo{10}(1,:))
text(newxfoo{10}(1,ui), newyfoo{10}(1,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')

subplot(2,1,2)
for ui=1:length(newxfoo{10}(1,:))
text(newxfoo{10}(2,ui), newyfoo{10}(2,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
   set (gca,'YDir','reverse')

   print(['CI_2vs59coord'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
   
   
   
   
   %%  rotated 6-9 %%
   
   
   
yfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1 -2];
xfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  5 4 ];

% orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 90 150 ]+90 ;
% 
% orifoo(1)=orifoo(1)-45;
% orifoo(3)=orifoo(3)-45;
% orifoo(4)=orifoo(4)-45;
% orifoo(5)=orifoo(5)-45;
% orifoo(8)=orifoo(8)-45;
% orifoo(9)=orifoo(9)-45;
% orifoo(10)=orifoo(10)-45;
% orifoo(12)=orifoo(12)-45;
% orifoo(15)=orifoo(15)-45;
% orifoo(19)=orifoo(19)-45;



orifoo= [60   180   165   120   150    90    90   150    75   120   180   150    90    90    15   150   180   180   240];



% 
% orifoo(1)=orifoo(1)-45;
% orifoo(8)=orifoo(8)-45;
% orifoo(10)=orifoo(10)-45;
% orifoo(4)=orifoo(4)+45;
% orifoo(12)=orifoo(12)+45;
% orifoo(5)=orifoo(5)-45;
% orifoo(15)=orifoo(15)-45;
% orifoo(15)=orifoo(15)-15;
% orifoo(19)=orifoo(19)+45;


Yoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0 1/4 ];
Xoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 -1/4 0];

Targx{11}= [xfoo; -xfoo];
Targy{11}= [yfoo; -yfoo];

Targori{11}=[orifoo; orifoo];

offsetx{11}= [Xoff; -Xoff];
offsety{11}=[Yoff; -Yoff];

newxfoo{11}=[Targx{11}(1,:)+offsetx{11}(1,:); Targx{11}(2,:)+offsetx{11}(2,:)]
newyfoo{11}=[Targy{11}(1,:)+offsety{11}(1,:); Targy{11}(2,:)+offsety{11}(2,:)]

figure
subplot(2,1,1)
for ui=1:length(newxfoo{11}(1,:))
text(newxfoo{11}(1,ui), newyfoo{11}(1,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')
pbaspect([1 1 1]);

subplot(2,1,2)
for ui=1:length(newxfoo{11}(1,:))
text(newxfoo{11}(2,ui), newyfoo{11}(2,ui), num2str(ui))
hold on
xlim([-8 8])
ylim([-8 8])
end
pbaspect([1 1 1]);

   set (gca,'YDir','reverse')
   
   
   
   
   
   %% eggs ---------------------------------------------------------------------

xfoo= [-4    -4    -4    -3    -3    -2    -2    -1    -1     0     0     1     1     2     2     2]+1;
yfoo = [-1     0     1    -1     1    -2     2    -2     2    -2     2    -2     2    -1     0 1];

orifoo=    [35     0   -35    50   -45    55   -55    65   -70    90    90   -55    55   -30     0 35];
twoorifoo= [ -35     0    35   -50    45   -55    55   -65    70    90    90    55   -55    30     0 -35];


Xoff=[-0.2198   -0.0122   -0.1954   -0.0855   -0.0488   -0.0122    0.0244         0    0.0367   0         0   -0.0611         0    0.1221    0.0122    0.1587];
Yoff=[ 0.1832   -0.0367    0.0244    0.0977   -0.2320   -0.2198    0.1466   -0.0488   -0.0122    0         0   -0.1221    0.0855    0.0244    0.0122   -0.0732];
%
Yoff(1)=0.15
Yoff(3)=0.15
 Yoff(4)=0.15
 Yoff(5)=-0.15
 Yoff(15)=0
 Yoff(2)=0
Targx{5}= [xfoo; -xfoo];
Targy{5}= [yfoo; yfoo];
Targori{5}=[orifoo;twoorifoo];

offsetx{5}= [-Xoff; Xoff];
offsety{5}=[-Yoff; -Yoff];

newxfoo{5}=[Targx{5}(1,:)+offsetx{5}(1,:); Targx{5}(2,:)+offsetx{5}(2,:)];
newyfoo{5}=[Targy{5}(1,:)+offsety{5}(1,:); Targy{5}(2,:)+offsety{5}(2,:)];

figure
subplot(2,1,1)
for ui=1:length(newxfoo{5}(1,:))
text(newxfoo{5}(1,ui), newyfoo{5}(1,ui), num2str(ui));
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')
pbaspect([1 1 1]);

subplot(2,1,2)
for ui=1:length(newxfoo{5}(1,:))
text(newxfoo{5}(2,ui), newyfoo{5}(2,ui), num2str(ui));
hold on
xlim([-8 8])
ylim([-8 8])
end
pbaspect([1 1 1]);

   set (gca,'YDir','reverse')
   
%clear Xoff Yoff xfoo yfoo orifoo
   

