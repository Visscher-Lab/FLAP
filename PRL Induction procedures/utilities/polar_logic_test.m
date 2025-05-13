

for i = 1:10
    signs = randsample([-1 1], 2, true);
    xcoord(i) = randi([3 8],1);
    ycoord(i) = xcoord(i) - randi([0 3],1);
    xcoord(i) = xcoord(i)*signs(1);
    ycoord(i) = ycoord(i)*signs(2);
    plot(xcoord(i),ycoord(i),'o');
    
    hold on
    
end
    axis([-10 10 -10 10]);
close all
figure;

for i = 1:100
        signs = randsample([-1 1], 2, true);
    xcoord(i) = randi([3 8],1);
    ycoord(i) = xcoord(i) - randi([0 3],1);
    xcoord(i) = xcoord(i)*signs(1);
    ycoord(i) = ycoord(i)*signs(2);
    [theta(i) rho(i)] = cart2pol(xcoord(i), ycoord(i));
    if (mod(theta(i),(.5)*pi) < (1/3)*pi) && (mod(theta(i),(.5)*pi) > (1/6)*pi)
        polarplot(theta(i), rho(i),'bo');
    else
        polarplot(theta(i), rho(i),'ro');
    end
    hold on
    
end
axis([0 360 0 10]);
