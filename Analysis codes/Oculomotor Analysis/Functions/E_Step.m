function [P,log_p] = E_Step(x,liklihood,means,converiances)

noOfClusters = size(liklihood,2);
%for j = 1:noOfClusters
%    detr_r(j) = det(converiances{j})^(-0.5);
%end
sizeX = size(x,1);
P(1:sizeX,1:noOfClusters)=0;

for i = 1:sizeX
    sum_dm=0;
    X = x(i,:);
    for j = 1:noOfClusters
        
        %P(i,j) = detr_r(j)*exp((x(i,:)'-means(j,:)')'*((x(i,:)'-means(j,:)')));
        %sum_d=sum_d + P(i,j);
        M = means(j,:);
        SIGMA = converiances{j};
        %P(i,j) =
        tmp = liklihood(j) * myPDF2D(X,M,SIGMA);
        %tmp = liklihood(j) * mvnpdf(X',M',SIGMA);
        P(i,j) = tmp;
   
        sum_dm=sum_dm + tmp;
    end
    % Normalize
    for j = 1:noOfClusters
        P(i,j)= P(i,j)/ sum_dm;
    end
    
end

end