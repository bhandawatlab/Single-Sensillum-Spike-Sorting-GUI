function [peakAll,SpikesAllV,Stimulus,IdxInCluster,window,fs] = SpikeClustering(voltageTrace,Stimulus,fs,vis)
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

if isempty(voltageTrace)
    load('TrialData.mat')
    voltageTrace = DataBS;
end
if isempty(fs)
    fs = 10000;
end
% conduct baseline subtraction
baselineLen = 10000; peakAll= [];
for i = 1:length(voltageTrace)/baselineLen
    [~,tmpPeak] = findpeaks(-voltageTrace((i-1)*baselineLen+1:i*baselineLen),'MinPeakHeight',0.8,'MinPeakDistance',50);
    [~,noise] = findpeaks(-voltageTrace((i-1)*baselineLen+1:i*baselineLen),'MinPeakHeight',10,'MinPeakDistance',50);
    peakAll = [peakAll;setdiff(tmpPeak,noise)+(i-1)*baselineLen];
end

% Aligning spikes
window = 31;
SpikesAll = zeros(length(peakAll),window);
SpikesAll(:,ceil(window/2)) = peakAll;
for i = 1:floor(window/2)
    SpikesAll(:,ceil(window/2)-i) = peakAll-i;
    SpikesAll(:,ceil(window/2)+i) = peakAll+i;
end
SpikesAll(SpikesAll <1) = 1;
SpikesAll(SpikesAll >length(voltageTrace)) = length(voltageTrace);
SpikesAllV = voltageTrace(SpikesAll);

% apply extra criterium
spkPeak = SpikesAllV(:,16);
spkBegin = SpikesAllV(:,1);
spkNear = SpikesAllV(:,[14,18]);
spkMin = min(SpikesAllV,[],2);

c1 = spkBegin-spkPeak>1.5;
c2 = (spkNear-spkPeak)<1.5;
c3 = spkPeak==spkMin;

ndx = c1 & c2(:,1) & c2(:,2) & c3;
SpikesAllV = SpikesAllV(ndx,:);
peakAll = peakAll(ndx);

%waveletTransform
dirDec = 'r';                               % Direction of decomposition
level  = round(log2(size(SpikesAllV,1)));   % Level of decomposition
wname  = 'sym4';                            % Near symmetric wavelet
IdxInCluster = cell(1,6);
if ~isempty(SpikesAllV)
    decROW = mdwtdec(dirDec,SpikesAllV,level,wname);
    
    %Clustering based on wavelet transform
    P1 = mdwtcluster(decROW,'lst2clu',{'s','ca7'},'maxclust',6);
    Clusters = [P1.IdxCLU];

    %Generating a cell that contains indexes for the clusters
    for k = 1:6
        IdxInCluster{k} = find(P1.IdxCLU(:,2)==k);
    end
end


%plotting function
if vis
	Plotting(voltageTrace,peakAll,SpikesAllV,Stimulus,Clusters,IdxInCluster,window,fs)
end

end

%Plotting functions
function [] = Plotting(DataBS,peakAll,SpikesAllV,Stimulus,Clusters,IdxInCluster,window,fs)
%plotting all spikes overlayed on top of one another
figure;plot(0:1/fs:(window-1)/fs,SpikesAllV(:,:)','r')
title('BSSpikeTraces');
xlabel('Time(s)');
ylabel('Voltage(mv)');
set(gcf,'position',[962 42 958 1074])
%print('-dpsc2',['Figures/WaveletSorting.ps'],'-loose','-append');

%stem plot of spikes based on clusters
figure('Color','w')
stem(Clusters,'filled','b:')
title('Clustering of Spikes');
xlabel('Signal indices');
ylabel('Index of cluster');
ax = gca;
xlim([1 35]);
ylim([0.5 4.1]);
ax.YTick = 1:3;
set(gcf,'position',[962 42 958 1074])
%print('-dpsc2',['Figures/WaveletSorting.ps'],'-loose','-append');

%Plotting spikes overlayed on top of one another by cluster
figure('Color','w','Units','normalized','Position',[0.2 0.2 0.6 0.6])
for k = 1:4
    idxK = IdxInCluster{k};
    subplot(2,2,k);
    plot(SpikesAllV(idxK,:)','r');
    axis tight
    ax = gca;
    ax.XTick = [200 800 1400];
    if k==1
        title('Original signals');
    end
    xlabel(['Cluster: ' int2str(k) ' (' int2str(length(idxK)) ')']);
end
set(gcf,'position',[0.0250 0.0667 0.4818 0.8242])
%print('-dpsc2',['Figures/WaveletSorting.ps'],'-loose','-append');

% Plotting voltage trace with the different types of spikes overlayed in 
% different color *.
figure;plot(DataBS);
hold on;c = {'r','g','m'};
for i = 1:3
    idxK = IdxInCluster{i};
    plot(peakAll(idxK),DataBS(peakAll(idxK)),[ c{i} '*'])
end
set(gcf,'position',[962 42 958 1074])
if ~isempty(Stimulus)
    plot(Stimulus)
end
%print('-dpsc2',['Figures/WaveletSorting.ps'],'-loose','-append');

end


