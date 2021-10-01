function p= myPDF2D(X,M,SIGMA)
d=2;
 p = (((((2*pi)^(d))*det(SIGMA))^(-(1/2)))   *  exp((-1/2)*(X-M) * inv(SIGMA) * (X-M)'));
end