% % symmetric dots
% clear
% % set up Psychtoolbox window
% % Screen('Preference', 'SkipSyncTests', 1); % only for testing purposes
% % 
% %           [w, rect] = PsychImaging('OpenWindow', 0, 0.5,[0 0 640 480],32,2);
% % 
% % Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% rect= [ 0 0 400 800]
% % define dot characteristics
% dotDiameter = 0.1; % in degrees
% compartmentSize = 0.16; % in degrees
% jitterSize = 0.04; % in degrees
% numDots = 18;
% 
% % calculate positions for one side of symmetric pattern
% cols = setdiff(1:9, 5); % exclude middle column
% rows = randperm(18, numDots);
% numDotsPerCol = [3 3 2 2 2 2 2 2];
% numDotsPerCol = numDotsPerCol(randperm(8));
% dotPositions = zeros(18, 9);
% for c = 1:length(cols)
%     colIdx = cols(c);
%     colRows = find(dotPositions(:, colIdx));
%     if length(colRows) < numDotsPerCol(c)
%         % place dots in empty rows
%         emptyRows = setdiff(1:18, colRows);
%         newRows = emptyRows(randperm(length(emptyRows), numDotsPerCol(c)-length(colRows)));
%         dotPositions(newRows, colIdx) = 1;
%     end
% end
% rowIdx = find(dotPositions);
% dotPositions(rowIdx) = rows(randperm(length(rows)));
% 
% % jitter dot positions
% [x, y] = meshgrid((0:17)*compartmentSize, (0:17)*compartmentSize);
% x = x + (rand(size(x))-0.5)*jitterSize*2;
% y = y + (rand(size(y))-0.5)*jitterSize*2;
% dotX = x(dotPositions~=0);
% dotY = y(dotPositions~=0);
% 
% % generate symmetric pattern by mirroring
% dotX = [dotX; 2*compartmentSize - dotX];
% dotY = [dotY; dotY];
% 
% % apply orientation offset of 45 degrees
% theta = deg2rad(-45);
% rotationMatrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
% dotPositions = rotationMatrix * [dotX'; dotY'];
% dotX = dotPositions(1,:)';
% dotY = dotPositions(2,:)';
% 
% % convert positions to pixels
% dotX = dotX * rect(3);
% dotY = dotY * rect(4);
% 
% % plot dots
% dotColor = [1 1 1];
% dotSizePix = round(dotDiameter * rect(4));
% for i = 1:length(dotX)
% %    Screen('DrawDots', win, [dotX(i) dotY(i)], dotSizePix, dotColor, [], 1);
%     scatter(dotX(i), dotY(i));
%     hold on
% end
% %Screen('Flip', win);
% 
% % wait for key press to exit
%   
% %%
% 
% dotDiameter = 0.1; % in degrees
% compartmentSize = 0.16; % in degrees
% jitterSize = 0.04; % in degrees
% numDots = 18;
% 
% % calculate positions for one side of symmetric pattern
% cols = setdiff(1:9, 5); % exclude middle column
% rows = randperm(18, numDots);
% numDotsPerCol = [3 3 2 2 2 2 2 2];
% numDotsPerCol = numDotsPerCol(randperm(8));
% dotPositions = zeros(18, 9);
% for c = 1:length(cols)
%     colIdx = cols(c);
%     colRows = find(dotPositions(:, colIdx));
%     if length(colRows) < numDotsPerCol(c)
%         % place dots in empty rows
%         emptyRows = setdiff(1:18, colRows);
%         newRows = emptyRows(randperm(length(emptyRows), numDotsPerCol(c)-length(colRows)));
%         dotPositions(newRows, colIdx) = 1;
%     end
% end
% rowIdx = find(dotPositions);
% dotPositions(rowIdx) = rows(randperm(length(rows)));
% 
% % jitter dot positions
% [x, y] = meshgrid((0:17)*compartmentSize, (0:17)*compartmentSize);
% x = x + (rand(size(x))-0.5)*jitterSize*2;
% y = y + (rand(size(y))-0.5)*jitterSize*2;
% dotX = x(dotPositions~=0);
% dotY = y(dotPositions~=0);
% 
% % generate symmetric pattern by mirroring
% dotX = [dotX; 2*compartmentSize - dotX];
% dotY = [dotY; dotY];
% 
% % apply orientation offset of 45 degrees
% theta = deg2rad(-45);
% rotationMatrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
% dotPositions = rotationMatrix * [dotX'; dotY'];
% dotX = dotPositions(1,:)';
% dotY = dotPositions(2,:)';
% 
% % convert positions to pixels
% dotX = dotX * rect(3);
% dotY = dotY * rect(4);
% 
% % plot dots
% dotColor = [1 1 1];
% dotSizePix = round(dotDiameter * rect(4));
% for i = 1:length(dotX)
%     scatter(dotX(i), dotY(i));
%     hold on
% end
% 
% 
% 
% %%
% % Define constants
% dotSize = 0.1; % in degrees
% compartmentSize = 0.16; % in degrees
% jitterRange = 0.04; % in degrees
% numDots = 18;
% 
% % Create dot positions on one side of the symmetry axis
% dotPositions = zeros(numDots, 2);
% cols = randperm(9) + 1;
% for i = 1:2
%     dotPositions(:, cols(i)) = repmat([1; 2; 3], 1, 2);
% end
% for i = 3:9
%     dotPositions(:, cols(i)) = repmat([1; 2], 1, 3);
% end
% dotRows = randperm(numDots)';
% dotPositions(:, 1) = dotRows;
% 
% % Create mirrored dot positions on the other side of the symmetry axis
% mirroredDotPositions = [dotPositions(:, 1), 10 - dotPositions(:, 2)];
% 
% % Jitter dot positions
% dotPositions = dotPositions + jitterRange * randn(size(dotPositions));
% mirroredDotPositions = mirroredDotPositions + jitterRange * randn(size(mirroredDotPositions));
% 
% % Combine dot positions
% dotPositions = [dotPositions; mirroredDotPositions];
% 
% % Add orientation offset of 45 degrees to the dot positions
% theta = deg2rad(45);
% rotMatrix = [cos(theta), -sin(theta); sin(theta), cos(theta)];
% dotPositions = dotPositions * rotMatrix;
% 
% % Draw dots
% for i = 1:size(dotPositions, 1)
%     x = (dotPositions(i, 1) - 1) * compartmentSize;
%     y = (dotPositions(i, 2) - 1) * compartmentSize;
%    % Screen('DrawDots', window, [x, y], dotSize, [255 255 255]);
%     scatter(x,y,dotSize)
%     hold on
% end
% 
% % Flip window to show dots
% %Screen('Flip', window);
% 
% % Wait for a key press
% KbWait();
% 
% % Clear screen and close window
% sca();




%%
rect= [ 0 0 34 34]

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

 x=x(:,2:end)
 y=y(:,2:end)

x=x(dotPositions~=0);
y=y(dotPositions~=0);
x = x + (rand(size(x))-0.5)*jitterSize*2;
y = y + (rand(size(y))-0.5)*jitterSize*2;
%dotX = x(dotPositions~=0);
%dotY = y(dotPositions~=0);

dotX = x
dotY = y


% generate symmetric pattern by mirroring
%dotX = [dotX; 2*compartmentSize - dotX];
dotX = [dotX; - dotX];

dotY = [dotY; dotY];

% apply orientation offset of 45 degrees
theta = deg2rad(45);
rotationMatrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
dotPositions = rotationMatrix * [dotX'; dotY'];
dotX = dotPositions(1,:)';
dotY = dotPositions(2,:)';
% dotX=dotX(2:end)
% dotY=dotY(2:end)
% convert positions to pixels
dotXpix = dotX * rect(3);
dotYpix = dotY * rect(4);

% plot dots
dotColor = [1 1 1];
dotSizePix = round(dotDiameter * rect(4));
figure
for i = 1:length(dotX)
%    Screen('DrawDots', win, [dotX(i) dotY(i)], dotSizePix, dotColor, [], 1);
    scatter(dotX(i), dotY(i), dotSizePix,'filled', 'r');
    hold on
end
close all

figure
for i = 1:length(dotX)
%    Screen('DrawDots', win, [dotX(i) dotY(i)], dotSizePix, dotColor, [], 1);
    scatter(dotX(i), dotY(i), 35,'filled', 'w');
    hold on
end
set(gca,'color',[0.5 0.5 0.5])
xlim([-5 5])
ylim([-5 5])
print('symmetric_dots', '-dpng', '-r300'); %<-Save as PNG with 300 DPI


%% figure 2: comparisons


% apply orientation offset of 45 degrees
theta = deg2rad(55);
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
end
set(gca,'color',[0.5 0.5 0.5])
