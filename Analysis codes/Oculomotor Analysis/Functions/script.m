%script
file_Name1 = 'dataset1.txt';
file_Name2 = 'dataset2.txt';
file_Name_test = 'dataset_test.txt';
x = readTrainingData(file_Name2);
k=3;
sizeX = size(x,1);
r = 50
membership=0;
sses = []
for i = 1:r
		centeroid_idx = datasample(1:sizeX,k,'Replace',false);
        % instial centroid keeper.
        centeroid_idx_keeper{i} = centeroid_idx;
		disp('final membership: ')
        centeroid_idx = sort(centeroid_idx);
        centeroid_idx
        [finalmembership,finalcentroids,numOfIterations] = KMEANS_Part1(x,centeroid_idx,i);
        %keep track of centroids and membership arrays to select the one
        %with lowest SSE
        membership_keeper{i} = finalmembership;
        centeroids_keeper{i} = finalcentroids;
        numOfIterations_keeper{i} = numOfIterations;
        
        sse = computeSSE(x,finalcentroids);
        sses = [sses sse]
        %disp('>>membership: ')
        %i
        %membership
end

% now from best r runs we want to find the best cluster with minimum SSE
[minSSE,min_idx] = min(sses);
best_membership = membership_keeper{min_idx};
best_centroids = centeroids_keeper{min_idx};
count = numOfIterations_keeper{min_idx};
doPlot(x,best_membership,best_centroids,r+1,count)


% now plot the result




