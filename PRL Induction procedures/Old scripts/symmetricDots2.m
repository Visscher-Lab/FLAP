
clear
% Define the dimensions of the compartments and dots
compartmentWidth = 0.16;
compartmentHeight = 0.16;
dotDiameter = 0.1;

% Define the number of compartments and dots
numCompartments = 18;
numDots = 18;

% Define the symmetry axis offset
symmetryAxisOffset = compartmentWidth * 5;

% Define the maximum jitter to be added to the dot positions
maxJitter = 0.04;

% Initialize the dot positions matrix
dotPositions = zeros(numDots, 2);

% Select the columns that will hold 3 dots each
cols3dots = randsample(2:9, 2);

% Select the columns that will hold 2 dots each
cols2dots = setdiff(2:9, cols3dots);

% Loop through each column that holds 3 dots and assign the dot positions
for i = 1:length(cols3dots)
    % Select the available rows for this column
    dotRowsAvailable = setdiff(1:numDots, dotPositions(:, cols3dots(i))');
    % Randomly select 3 rows from the available rows
    dotRows = randsample(dotRowsAvailable, 3);
    % Assign the dot positions for this column
    dotPositions(dotRows, cols3dots(i)) = [cols3dots(i)*compartmentWidth, dotRows*compartmentHeight] - [symmetryAxisOffset/2, 0];
end

% Loop through each column that holds 2 dots and assign the dot positions
for i = 1:length(cols2dots)
    % Select the available rows for this column
    dotRowsAvailable = setdiff(1:numDots, dotPositions(:, cols2dots(i))');
    % Randomly select 2 rows from the available rows
    dotRows = randsample(dotRowsAvailable, 2);
    % Assign the dot positions for this column
    dotPositions(dotRows, cols2dots(i)) = [cols2dots(i)*compartmentWidth, dotRows*compartmentHeight] - [symmetryAxisOffset/2, 0];
end

% Randomly assign rows to the remaining dots
dotRowsAvailable = setdiff(1:numDots, dotPositions(:, 2:9)');
dotRows = randsample(dotRowsAvailable, 8);
dotPositions(dotRows, 2:9) = repmat([2:9]*compartmentWidth, 8, 1) - [symmetryAxisOffset/2, zeros(8, 7)];

% Add jitter to the dot positions
dotJitter = maxJitter * (rand(size(dotPositions)) - 0.5);
dotPositions = dotPositions + dotJitter;

% Mirror the dot positions to create the symmetrical pattern
symmetricDotPositions = [dotPositions(:, 1:9), fliplr(dotPositions(:, 10:18))];

% Convert the dot positions to pixel values
pixelPositions = round(symmetricDotPositions * 100);

% % Initialize the PTB window
% window = Screen('OpenWindow', 0, [0 0 0]);
% 
% % Draw the dots on the screen
% for i = 1:numDots
%     Screen('FillOval', window, [255 255 255], [pixelPositions(i, 1)-dotDiameter/2, pixelPositions(i, 2)-dotDiameter/2, pixelPositions(i, 1)+dotDiameter/2, pixelPositions(i, 2)+dotDiameter/2]);
% end

% Flip the screen to display the dots



scatter(dotPositions', dotSize, dotColor);
scatter(dotX,dotY, dotSize, dotColor);

