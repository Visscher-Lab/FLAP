function log_p = ComputeLogLiklihood(x,means,converiances,liklihood)
sum_prr=0;
sizeX = size(x,1);
noOfClusters = size(means,1);
for i = 1:sizeX
    X = x(i,:);
    sum_trr=0;
    for j=1:noOfClusters
      
        
        M = means(j,:);
        SIGMA = converiances{j};
        
        
        sum_trr = sum_trr + liklihood(j)* myPDF2D(X,M,SIGMA);
    end
    sum_prr = sum_prr + log(sum_trr);
end
log_p = sum_prr;
end