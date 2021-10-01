%script
clear;
file_Name1 = 'dataset1.txt';
file_Name2 = 'dataset2.txt';
file_Name_test = 'dataset_test.txt';

prompt = 'Please enter 1 for dataset1 and 2 for dataset2 ->>> ';
fileNumber = sscanf(input(prompt, 's'), '%d');

if fileNumber == 1
    file_used = file_Name1;
else
  file_used = file_Name2;
end

prompt = 'Select k value ->>> ';
k =  sscanf(input(prompt, 's'), '%d');

prompt = 'Select r value ->>> ';
r=  sscanf(input(prompt, 's'), '%d');


x = readTrainingData(file_used);

sizeX = size(x,1);

membership=0;
sses = []
for i = 1:r
		centeroid_idx = datasample(1:sizeX,k,'Replace',false);
        % instial centroid keeper.
        centeroid_idx_keeper{i} = centeroid_idx;
		%disp('final membership: ')
        centeroid_idx = sort(centeroid_idx);
       
        [finalmembership,finalcentroids,numOfIterations,sse_self] = KMEANS_Part1(x,centeroid_idx,i);
        %keep track of centroids and membership arrays to select the one
        %with lowest SSE
        membership_keeper{i} = finalmembership;
        centeroids_keeper{i} = finalcentroids;
        numOfIterations_keeper{i} = numOfIterations;
        sse_tracker{i} = sse_self;
        sse = computeSSE(x,finalcentroids);
        sses = [sses sse];
       
end

% now from best r runs we want to find the best cluster with minimum SSE
[minSSE,min_idx] = min(sses);
best_membership = membership_keeper{min_idx};
best_centroids = centeroids_keeper{min_idx}
count = numOfIterations_keeper{min_idx};
doPlot(x,best_membership,best_centroids,r+1,count)
sse=sse_tracker{min_idx};
%Plot best results:
figure
SSEBySample = [sse minSSE]/sizeX
plot(0:(count),SSEBySample,'-');
xlabel('i')
ylabel('SSE/NumberoOfSamples');


% now plot the result
%{

   if strcmp(file_used,file_Name1)
        membership_ideal = [];
        membership_ideal(1:800) = 1;
        membership_ideal(801:1600) = 2;
    else
        membership_ideal = [];
        membership_ideal(1:500) = 1;
        membership_ideal(501:1000) = 2;
        membership_ideal(1001:1500) = 3;
    end
    

r=r+1
doPlot(x,membership_ideal',best_centroids,r+1,count);
%}

