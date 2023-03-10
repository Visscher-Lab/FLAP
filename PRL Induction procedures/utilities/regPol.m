%This code implements the 1D polynomial regression method. It uses the least
%square method for the finding of regression polynomial coefficents. 
%Outputs of the script are polynomial regression coefficients, residuals,
%the sum of squared errors, the determination index and the graphical
%comparison of the regression model and input data.
%
%The meaning of input and output parameters.
%
%function [coef rezidua SSE R] = regPol(order,x,y)    
%
%Input:
%x - independent variable
%y - dependent variable, i.e. y = y(x)
%oder - oder of the regression polynomial
%The length of x and y must be the same.
%
%Output:
%coef - array of the regression polynomial coefficients, the first cell of
%       the array corresponds to absolute term
%rezidua - the array of residual values
%SSE - the sum of squared errors (residuals)
%R - the determinantion index
function [coef rezidua SSE R] = regPol(order,x,y)    
    matrix = zeros(order+1,order+1);
    right = zeros(order+1,1);
    
    if order > length(x) 
        error ('There is not enought data for the polynom of required order');
    end
    
    powers = zeros(2*order+1,1);    
    for k = 0:(2*order)
        powers(k+1) = sum(x.^k); 
    end
    
    for k = 0:order
        right(k+1) = sum(y.*(x.^k)); 
    end
    
    for k = 0:order
        matrix(k+1,:) = powers((k+1):(k+1+order)); 
    end
    
    coef = matrix\right; 
    
    plot(x,y,'k*'); 
    
    xx = 0:0.1:max(x);    
    yy = zeros(1,length(xx));
    for k = 1:length(yy) 
        for l = 0:order
            yy(k) = yy(k) + coef(l+1)*(xx(k))^l;
        end
    end
    hold on;
    plot(xx,yy,'b-'); 
    xlabel('{\it x}');
    ylabel('{f(\it x)}');    
    switch order
        case 1
            ord = 'st';
        case 2
            ord = 'nd';
        case 3
            ord = 'rd';
        otherwise
            ord = 'th';
    end    
    title(['The regression by polynom of ',num2str(order),ord,' order.']);
    
    yy = zeros(1,length(x)); 
    rezidua = zeros(1,length(x));
    for k = 1:length(x) 
        for l = 0:order
            yy(k) = yy(k) + coef(l+1)*(x(k))^l;
        end
        rezidua(k) = y(k) - yy(k);
    end
   
    errorbar(x,yy,abs(rezidua),'xr'); 
    SSE = sum(rezidua.^2);
    R = 1 - SSE/var(y);
    if R < 0
        R = 0;
    end