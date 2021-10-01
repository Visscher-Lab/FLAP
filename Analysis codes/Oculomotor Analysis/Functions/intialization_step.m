function [means,converiances] = intialization_step(intailization_strategy,x,k,i,file_used)

display('Instailization');
file_Name1 = 'dataset1.txt';
file_Name2 = 'dataset2.txt';
file_Name_test = 'dataset_test.txt';


sizeX = size(x,1);
if(intailization_strategy == 1)
    %randomnly select centroids from data
    centeroid_idx = datasample(1:sizeX,k,'Replace',false);
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %{
    m=1;
    n=0;
   if strcmp(file_used,file_Name1)
       inc=800;
   else
       inc = 500;
   end
   
    for i=1:k
       m=(i-1)*inc+1;
       n=i*inc;
    centeroid_idx(i) = datasample(m:n,1,'Replace',false);
    end
    %%%%%%%%%%%%%%%
    %}
    centeroid_idx = sort(centeroid_idx);
    means = x(centeroid_idx,:);
    overall_convariance = cov(x);
    for j = 1:k
        converiances{j} = overall_convariance/k;
    end
    
elseif(intailization_strategy == 2)
    
    centeroid_idx = datasample(1:sizeX,k,'Replace',false);
    % instial centroid keeper.
    %%%%%%%%%%%%%%%%%%%%%%
    %if strcmp(file_used,file_Name1)
    %    centeroid_idx(1) = datasample(1:800,1,'Replace',false);
   %     centeroid_idx(2) = datasample(801:1600,1,'Replace',false);
  %  else
   %     centeroid_idx(1) = datasample(1:500,1,'Replace',false);
  %      centeroid_idx(2) = datasample(501:1000,1,'Replace',false);
  % %     centeroid_idx(3) = datasample(1001:1500,1,'Replace',false);
  %  end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    centeroid_idx_keeper{i} = centeroid_idx;
    disp('final membership: ')
    centeroid_idx = sort(centeroid_idx);
    
    [finalmembership,finalcentroids,numOfIterations] = KMEANS_Part1(x,centeroid_idx,i);
    
    means = finalcentroids;
  
    
    for j = 1:k
        converiances{j} = cov(x(finalmembership==j,:));
    end
end
end
