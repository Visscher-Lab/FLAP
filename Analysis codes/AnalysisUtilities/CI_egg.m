
xfoo= [-4    -4    -4    -3    -3    -2    -2    -1    -1     0     0     1     1     2     2     2]+1;
yfoo = [-1     0     1    -1     1    -2     2    -2     2    -2     2    -2     2    -1     0 1];

orifoo=    [35     0   -35    50   -45    55   -55    65   -70    90    90   -55    55   -30     0 35];
twoorifoo= [ -35     0    35   -50    45   -55    55   -65    70    90    90    55   -55    30     0 -35];


Xoff=[-0.2198   -0.0122   -0.1954   -0.0855   -0.0488   -0.0122    0.0244         0    0.0367   0         0   -0.0611         0    0.1221    0.0122    0.1587];
Yoff=[ 0.1832   -0.0367    0.0244    0.0977   -0.2320   -0.2198    0.1466   -0.0488   -0.0122    0         0   -0.1221    0.0855    0.0244    0.0122   -0.0732];



% 
%  Xoff=[-0.2  0.2 -0.2 -0.05 -0.05 -0.02  0.02       0       0       0.05  0.05 0 0  0.2 0.0122  0.200];
% %
% Yoff= [0.05 0 -0.05  0.53  -0.53 -0.15  0.15  0.0500 -0.05 0 0 -0.1  0.1  0.1200  0 -0.1200];


  
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
scatter(newxfoo{5}(1,ui), newyfoo{5}(1,ui));
hold on
xlim([-8 8])
ylim([-8 8])
end
set (gca,'YDir','reverse')
pbaspect([1 1 1]);
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
