
clear all
close all
            xcord=[-8 0 8];
premat=fullfact([3 3]);
coordmat= xcord(premat);

for ui=1:length(coordmat(:,1))
eyenowx(ui)=[coordmat(ui,1)+(randi(100)-50)/100]
eyenowy(ui)=[coordmat(ui,2)+(randi(100)-50)/100]

end
figure
hold on
scatter(coordmat(:,1), coordmat(:,2), 'filled', 'r')
hold on
scatter(eyenowx, eyenowy, 'filled', 'b')
xlim([-20 20])
ylim([-20 20])