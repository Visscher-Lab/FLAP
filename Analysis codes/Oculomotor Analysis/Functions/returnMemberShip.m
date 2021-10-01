function membership = returnMemberShip(x,centeroid)
	sizeX = size(x,1);
	numOfClusters = size(centeroid,1);
	membership = zeros(sizeX,1);
	for  i = 1 : sizeX
		distances =[];
		% compute distances from a point x to all centroids
		for j = 1:numOfClusters
			newVal = euclidean_distance(centeroid(j,:),x(i,:));
			distances = [distances newVal];
		end
		% select the cluster number whcih centroid is the closest to this point x
		membership(i)=nearestCenteroid(distances);
	end
end