function centroids = update_centeroids(x,membership)
	% find the unique clusters id's 1,2,3 ...
	%disp('unq')
    unq = unique(membership);
	numOfClusters = max(size(unq));
	
	centroids = [];
	% for each cluster id
	for i=unq'
		% compute the new mean of each cluster
       % disp('the i')
      %  i
		%disp('xi')
        x_i=x(membership==i,:);
		%append the value of centroids, so the new centroids has to be size of 2 by unq
        c = mean(x_i);
		centroids = [centroids; c];
    end
    %disp('centroids >>')
    %centroids
	
end