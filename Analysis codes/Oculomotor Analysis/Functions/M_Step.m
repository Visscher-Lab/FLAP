function [new_means,covs,liklihood,log_p]=M_Step(P,x,mu)

k = size(P,2);
sizeX =  size(x,1);
new_means(1:k,1:2) = 0;
%P(1:sizeX,1:k) = 1/3;

sum_d(1:k)=0;
for i=1: sizeX
    sum_d = sum_d + P(i,:);
end

for j=1:k
    sum_n(1:2)=0;
    
    for i=1:sizeX
        sum_n= sum_n + P(i,j)*x(i,:);
    end
    new_means(j,:) = sum_n/sum_d(j);
end








for j = 1:k
    sum_n(1:2,1:2) = 0;
    sum_d = 0;
    
    for i=1:sizeX
        sum_d = sum_d + P(i,j);
        sum_n = sum_n + P(i,j)*((x(i,:)-mu(j,:))'*(x(i,:)-mu(j,:)));
    end
    covs{j} = sum_n /sum_d ;
end

liklihood(1:k) =0; 

%P(1:sizeX,1:k) = 1/3;

    for i=1:sizeX
        liklihood = liklihood + P(i,:);
    end
    liklihood = liklihood/sizeX;

log_p= ComputeLogLiklihood(x,new_means,covs,liklihood);


end