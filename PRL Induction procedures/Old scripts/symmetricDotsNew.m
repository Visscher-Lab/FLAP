close all 
clear all
%%
rect= [ 0 0 34 34];
    refOri=deg2rad(135);

dotDiameter = 0.1; % in degrees
compartmentSize = 0.16; % in degrees
jitterSize = 0.04; % in degrees
numDots = 18;

% calculate positions for one side of symmetric pattern
cols = setdiff(1:9, 9); % exclude middle column
rows = randperm(18, numDots);
numDotsPerCol = [3 3 2 2 2 2 2 2];
numDotsPerCol = numDotsPerCol(randperm(8));
dotPositions = zeros(18, 9);
for c = 1:length(cols)
    colIdx = cols(c);
    colRows = find(dotPositions(:, colIdx));
    if length(colRows) < numDotsPerCol(c)
        % place dots in empty rows
        emptyRows = setdiff(1:18, colRows);
        newRows = emptyRows(randperm(length(emptyRows), numDotsPerCol(c)-length(colRows)));
        dotPositions(newRows, colIdx) = 1;
    end
end
rowIdx = find(dotPositions);
rowIdx = rowIdx(randperm(length(rowIdx)));
dotPositions(rowIdx(1:18)) = rows;

% jitter dot positions
[x, y] = meshgrid((0:17)*compartmentSize, (0:17)*compartmentSize);

 x=x(:,2:end);
 y=y(:,2:end);

x=x(dotPositions~=0);
y=y(dotPositions~=0);
x = x + (rand(size(x))-0.5)*jitterSize*2;
y = y + (rand(size(y))-0.5)*jitterSize*2;
%dotX = x(dotPositions~=0);
%dotY = y(dotPositions~=0);

dotX = x;
dotY = y;


% generate symmetric pattern by mirroring
%dotX = [dotX; 2*compartmentSize - dotX];
dotX = [dotX; - dotX];
dotY = [dotY; dotY];

% apply orientation offset of 45 degrees
theta = refOri;
rotationMatrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
rotcompens=(90-mod(rad2deg(theta), 90))/100;
dotPositions = rotationMatrix * [dotX'; dotY'];

dotX = dotPositions(1,:)';
dotY = dotPositions(2,:)';
% dotX=dotX(2:end)
% dotY=dotY(2:end)

Xc=(max(dotX)+min(dotX))/2;
Yc=(max(dotY)+min(dotY))/2;

newXc=rotcompens*Xc;
newYc=1-rotcompens*Yc;

Xr =  (dotX)*cos(theta) + (dotY)*sin(theta) + Xc;
Yr = -(dotX)*sin(theta) + (dotY)*cos(theta) + Yc;

% convert positions to pixels
dotXpix = dotX * rect(3);
dotYpix = dotY * rect(4);

% plot dots
dotColor = [1 1 1];
dotSizePix = round(dotDiameter * rect(4));
% figure
% for i = 1:length(dotX)
% %    Screen('DrawDots', win, [dotX(i) dotY(i)], dotSizePix, dotColor, [], 1);
%     scatter(dotX(i), dotY(i), dotSizePix,'filled', 'r');
%     hold on
% end
% hold on
%     scatter(Xc, Xc, dotSizePix,'filled', 'y');

figure
for i = 1:length(dotX)
%    Screen('DrawDots', win, [dotX(i) dotY(i)], dotSizePix, dotColor, [], 1);
    scatter(dotX(i), dotY(i), dotSizePix,'filled', 'w');
    hold on
end
set(gca,'color',[0.5 0.5 0.5])
xlim([-5 5])
ylim([-5 5])
title('sym')
hold on
    scatter(Xc, Yc, dotSizePix,'filled', 'r');

print('symmetric_dots', '-dpng', '-r300'); %<-Save as PNG with 300 DPI

figure
for i = 1:length(dotX)
%    Screen('DrawDots', win, [dotX(i) dotY(i)], dotSizePix, dotColor, [], 1);
    scatter(dotX(i)-Xc, dotY(i)-Yc, 35,'filled', 'w');
    hold on
end
set(gca,'color',[0.5 0.5 0.5])
xlim([-5 5])
ylim([-5 5])
title('sym translated to center coord')
hold on
    scatter(0, 0, dotSizePix,'filled', 'r');

print('symmetric_dots_transf', '-dpng', '-r300'); %<-Save as PNG with 300 DPI

% 
% figure
% for i = 1:length(dotX)
% %    Screen('DrawDots', win, [dotX(i) dotY(i)], dotSizePix, dotColor, [], 1);
%     scatter(Xr(i), Yr(i), 35,'filled', 'w');
%     hold on
% end
% set(gca,'color',[0.5 0.5 0.5])
% xlim([-5 5])
% ylim([-5 5])

%% figure 2: comparisons


% apply orientation offset of 45 degrees
theta = refOri+deg2rad(0);
rotationMatrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
dotPositions = rotationMatrix * [dotX'; dotY'];
dotX = dotPositions(1,:)';
dotY = dotPositions(2,:)';
% dotX=dotX(2:end)
% dotY=dotY(2:end)
% convert positions to pixels
dotX = dotX * rect(3);
dotY = dotY * rect(4);

% plot dots
dotColor = [1 1 1];
dotSizePix = round(dotDiameter * rect(4));
% figure
% for i = 1:length(dotX)
% %    Screen('DrawDots', win, [dotX(i) dotY(i)], dotSizePix, dotColor, [], 1);
%     scatter(dotX(i), dotY(i), dotSizePix,'filled', 'r');
%     hold on
% end


figure
for i = 1:length(dotX)
%    Screen('DrawDots', win, [dotX(i) dotY(i)], dotSizePix, dotColor, [], 1);
    scatter(dotX(i), dotY(i), 35,'filled', 'w');
    hold on
    title ('dots zoomed in')
end
set(gca,'color',[0.5 0.5 0.5])
