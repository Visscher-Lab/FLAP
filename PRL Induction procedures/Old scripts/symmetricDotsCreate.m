% close all 
% clear all
%%
%pix_deg=34;
%pix_deg=1;

%ori=5;

% orientation of the two cinfigurations per trial
    refOri=deg2rad(45);
    diffOri=deg2rad(45) + (plusORminus* deg2rad(ori));
  %  refOri=deg2rad(0);
  %  refOri=deg2rad(90);

  
  % how many dots in one half ot the symmetrical configuration
numDots = 18;
% calculate positions for one side of symmetric pattern
cols = setdiff(1:9, 9); % exclude middle column
rows = randperm(18, numDots);
numDotsPerCol = [3 3 2 2 2 2 2 2];
numDotsPerCol = numDotsPerCol(randperm(8));
dotDiameter = 0.1; % dot size in degrees
dotSizePix = round(dotDiameter * pix_deg); % dot size in pixels
dotSizePix=5;
compartmentSize = 0.16; % in degrees
jitterSize = 0.04; % in degrees

% offsetx= 5;
% offsety= 0;
% theeccentricity_X= offsetx*pix_deg;
% theeccentricity_Y= offsety*pix_deg;



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

% generate grid
[x, y] = meshgrid((0:17)*compartmentSize, (0:17)*compartmentSize);

 x=x(:,2:end);
 y=y(:,2:end);

x=x(dotPositions~=0);
y=y(dotPositions~=0);

% jitter dot positions within the grid
dotX = x + (rand(size(x))-0.5)*jitterSize*2;
dotY = y + (rand(size(y))-0.5)*jitterSize*2;

% generate symmetric pattern by mirroring
dotX = [dotX; - dotX];
dotY = [dotY; dotY];

% apply orientation offset of 45 degrees
theta = refOri;
theta2 = diffOri;

rotationMatrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
rotationMatrix2 = [cos(theta2) -sin(theta2); sin(theta2) cos(theta2)];

% to recenter the configuration after the rotation
rotcompens=(90-mod(rad2deg(theta), 90))/100;
dotPositions = rotationMatrix * [dotX'; dotY'];

rotcompens2=(90-mod(rad2deg(theta2), 90))/100;
dotPositions2 = rotationMatrix2 * [dotX'; dotY'];


dotX = dotPositions(1,:)';
dotY = dotPositions(2,:)';

dotX2 = dotPositions2(1,:)';
dotY2 = dotPositions2(2,:)';

% center of the configuration
Xc=(max(dotX)+min(dotX))/2;
Yc=(max(dotY)+min(dotY))/2;

newXc=rotcompens*Xc;
newYc=1-rotcompens*Yc;

% center of the comparison configuration
X2c=(max(dotX2)+min(dotX2))/2;
Y2c=(max(dotY2)+min(dotY2))/2;

newX2c=rotcompens2*X2c;
newY2c=1-rotcompens2*Y2c;


Xr =  (dotX)*cos(theta) + (dotY)*sin(theta) + Xc;
Yr = -(dotX)*sin(theta) + (dotY)*cos(theta) + Yc;

% convert positions to pixels
dotXpix = dotX * pix_deg;
dotYpix = dotY * pix_deg;

dotX2pix = dotX2 * pix_deg;
dotY2pix = dotY2 * pix_deg;

%convert configuration center to pixels
Xcpix=Xc*pix_deg;
Ycpix=Yc*pix_deg;

X2cpix=X2c*pix_deg;
Y2cpix=Y2c*pix_deg;

% subtracxting Xc and Yc from coordinates centers the configuration to [0,
% 0]. Once you have this, you can add x and y offsets



% add a specific ofsset center for the configuration

% figure
%     scatter(dotXpix-Xcpix+theeccentricity_X, dotYpix-Ycpix+theeccentricity_Y, dotSizePix,'filled', 'w');
% hold on
% set(gca,'color',[0.5 0.5 0.5])
% xlim([-1920/2 1920/2])
% ylim([-1080/2 1080/2])
% title('sym translated to center coord no loop')
% hold on
%     scatter(theeccentricity_X, theeccentricity_Y, dotSizePix,'filled', 'r');
% % hold on
% %     scatter(dotX-Xc, dotY-Yc, dotSizePix,'filled', 'w');
% % hold on
% %     scatter(Xc, Yc, dotSizePix,'filled', 'g');
% 
% print('symmetric_dots_transfOffset', '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% 
% 
% figure
%     scatter(dotX-Xc+theeccentricity_X/pix_deg, dotY-Yc+theeccentricity_Y/pix_deg, dotSizePix,'filled', 'w');
% hold on
% set(gca,'color',[0.5 0.5 0.5])
% xlim([-10 10])
% ylim([-10 10])
% title('sym translated to center coord no loop')
% hold on
%     scatter(theeccentricity_X/pix_deg, theeccentricity_Y/pix_deg, dotSizePix,'filled', 'r');
% % hold on
% %     scatter(dotX-Xc, dotY-Yc, dotSizePix,'filled', 'w');
% % hold on
% %     scatter(Xc, Yc, dotSizePix,'filled', 'g');
% 
% print('symmetric_dots_transfOffsetdeg', '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% 
% 
% 
% figure
%     scatter(dotXpix-Xcpix+theeccentricity_X, dotYpix-Ycpix+theeccentricity_Y, dotSizePix,'filled', 'w');
% hold on
% 
% title('sym translated to center coord no loop')
% hold on
%     scatter(theeccentricity_X, theeccentricity_Y, dotSizePix,'filled', 'r');
%  hold on
%      scatter(dotX2pix-X2cpix+theeccentricity_X, dotY2pix-Y2cpix+theeccentricity_Y, dotSizePix,'filled', 'b');
% %hold on
%    %  scatter(Xc, dotY-Yc, dotSizePix,'filled', 'w');
% % hold on
% %     scatter(Xc, Yc, dotSizePix,'filled', 'g');
% set(gca,'color',[0.5 0.5 0.5])
% xlim([-1920/2 1920/2])
% ylim([-1080/2 1080/2])
% print('2config_symmetric_dots_transfOffset', '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%theeccentricity_X=0;

predotcoord=[dotXpix-Xcpix+theeccentricity_X dotYpix-Ycpix+theeccentricity_Y];
predotcoord2=[dotX2pix-X2cpix+theeccentricity_X  dotY2pix-Y2cpix+theeccentricity_Y];

dotcoord(:,1)=predotcoord(:,1)+wRect(3)/2;
dotcoord(:,2)=predotcoord(:,2)+wRect(4)/2;

dotcoord2(:,1)=predotcoord2(:,1)+wRect(3)/2;
dotcoord2(:,2)=predotcoord2(:,2)+wRect(4)/2;


figure
scatter(dotcoord2(:,1), dotcoord2(:,2), 'k')
hold on
scatter(dotcoord(:,1), dotcoord(:,2), 'r')


figure
subplot(1,2,1)
scatter(dotcoord2(:,1), dotcoord2(:,2), 'k')
subplot(1,2,2)
scatter(dotcoord(:,1), dotcoord(:,2), 'r')
