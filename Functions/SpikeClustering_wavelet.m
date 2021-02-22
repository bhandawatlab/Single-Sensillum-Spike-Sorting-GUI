function [IdxInCluster] = SpikeClustering_wavelet(app,SpikesAllV)
% this function will calculate the spike rate of a given given signal and
% index of spiking
%    voltageTrace: Vector of the Baseline subtracted voltage (mV)
%    Stimulus: Vector of the Stimulus associated with the voltage trace
%    fs: Sampling frequency
%    Vis: "true" ("false") if you want (don't want) figures plotted
%       -Figures: Histogram
% Outputs:
%    spkFreq: Matrix of spiking frequency (row = individual tracks).
%    midTime: Time indexes of middle of sliding bin

%
% Liangyu Tao 2017

%waveletTransform
dirDec = 'r';                               % Direction of decomposition
level  = round(log2(size(SpikesAllV,1)));   % Level of decomposition
wname  = 'sym4';                            % Near symmetric wavelet
IdxInCluster = cell(1,app.nClust);
if ~isempty(SpikesAllV)
    %Clustering based on wavelet transform
    P1 = mdwtcluster(SpikesAllV,'maxclust',app.nClust,'wname',wname,'level',level,'dirDec',dirDec);
    %decROW = mdwtdec(dirDec,SpikesAllV,level,wname);
    %P1 = mdwtcluster(decROW,'lst2clu',{'s','ca7'},'maxclust',app.nClust);
    Clusters = [P1.IdxCLU(:,min(numel(P1.Corr),5))];

    %Generating a cell that contains indexes for the clusters
    for k = 1:app.nClust
        IdxInCluster{k} = find(P1.IdxCLU(:,2)==k);
    end
end