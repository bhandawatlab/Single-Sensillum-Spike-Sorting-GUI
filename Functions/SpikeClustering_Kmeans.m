function [IdxInCluster,OptimalK] = SpikeClustering_Kmeans(SpikesAllV,clust2cons,evalType)

% perform pca on the peak aligned spikes
[~,score,~,~,explained,~] = pca(SpikesAllV);
% use the top PC's that together give at least 99% variance explained
nD = find(cumsum(explained)>95,1);
X = score(:,1:find(cumsum(explained)>99,1));

% set the maximum number of spikes to look at --> otherwise too slow/run
% out of memory
maxSpk = 4000;
nSpikes = size(X,1);

% if using k-means, choose between Silhouette, CalinskiHarabasz, and Jump criteria
switch evalType
    case {'Silhouette','CalinskiHarabasz'}
        clusterType = evalType;
        OptimalK = 0;
        if nSpikes>maxSpk
            for it = 1:ceil(nSpikes./maxSpk)
                X_test = X(randsample(nSpikes,maxSpk),:);
                eva = evalclusters(X_test,'kmeans',clusterType,'KList',clust2cons);%CalinskiHarabasz
                OptimalK = max(eva.OptimalK,OptimalK);
            end
            [ClusterGroup,~] = kmeans(X,OptimalK, 'emptyaction','singleton','replicate',5);
        else
            % otherwise, cluster based on silhouette on all data
            eva = evalclusters(X,'kmeans',clusterType,'KList',clust2cons);%CalinskiHarabasz
            ClusterGroup = eva.OptimalY;
            OptimalK = eva.OptimalK;
        end
        
    case 'Jump'
        if nSpikes>maxSpk
            for it = 1:ceil(nSpikes./maxSpk)
                X_test = X(randsample(nSpikes,maxSpk),:);
                [OptimalK,~] = jumpCriteria(X_test,nD,clust2cons,'Kmeans');
            end
        else
            [OptimalK,~] = jumpCriteria(X,nD,clust2cons,'Kmeans');
        end
        [ClusterGroup,~] = kmeans(X,OptimalK, 'emptyaction','singleton','replicate',5);
end

IdxInCluster = cell(1,OptimalK);
if ~isempty(SpikesAllV)
    %Generating a cell that contains indexes for the clusters
    for k = 1:OptimalK
        IdxInCluster{k} = find(ClusterGroup==k);
    end
end

end