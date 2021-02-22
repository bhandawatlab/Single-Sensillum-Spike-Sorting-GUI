function [] = PlottingFunctionsGUI_PC(app,optionsApp,SpikesAllV,IdxInCluster)
c = distinguishable_colors(app.nClust);

% perform pca
[~,score,~,~,explained,~] = pca(SpikesAllV);
% label each trace by the cluster it belongs to
ClusterGroup = zeros(size(SpikesAllV,1),1);
for i = 1:app.nClust
    ClusterGroup(IdxInCluster{i},1) = i;
end

cla(optionsApp.PCClusterUIAxes,'reset');
gscatter(optionsApp.PCClusterUIAxes,score(:,1),score(:,2),ClusterGroup,c,'o');
xlabel(optionsApp.PCClusterUIAxes,['PC 1: ' num2str(explained(1)) '% var']);
ylabel(optionsApp.PCClusterUIAxes,['PC 2: ' num2str(explained(2)) '% var'])
title(optionsApp.PCClusterUIAxes, 'PC Space')

end