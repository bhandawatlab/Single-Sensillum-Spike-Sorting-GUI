%Plotting functions
function [] = PlottingFunctionsGUI(DataBS,peakAll,SpikesAllV,Stimulus,IdxInCluster,fHandle,fs,fileName)
%plotting all spikes overlayed on top of one another
%plot(fHandle.ax,0:1/fs:(window-1)/fs,SpikesAllV(:,:)','r')
% title('BSSpikeTraces');
% xlabel('Time(s)');
% ylabel('Voltage(mv)');

%Plotting spikes overlayed on top of one another by cluster
tempFHandle = {fHandle.axS1,fHandle.axS2,fHandle.axS3,fHandle.axS4,fHandle.axS5,fHandle.axS6};
c = {'r','g','m','k','y','c'};
nDelay = floor(size(SpikesAllV,2)./2);
tt = (-nDelay:1:nDelay)./fs.*1000;% time in ms
if ~isempty(SpikesAllV)
    for k = 1:6
        if ~isempty(IdxInCluster{k})
            cla(tempFHandle{k})
            idxK = IdxInCluster{k};
            plot(tempFHandle{k},tt,SpikesAllV(idxK,:)',c{k});
            ylim(tempFHandle{k},[floor(min(SpikesAllV(:))) ceil(max(SpikesAllV(:)))])
            xlim(tempFHandle{k},[tt(1) tt(end)])
            xlabel(tempFHandle{k},'Time (ms)');ylabel(tempFHandle{k},'mV')
            title(tempFHandle{k},['Cluster: ' int2str(k) ' (' int2str(length(idxK)) ')']);
        else
            cla(tempFHandle{k})
        end
    end
end

% Plotting voltage trace with the different types of spikes overlayed in 
% different color *.
tt = (1:numel(DataBS))./fs;
cla(fHandle.ax)
plot(fHandle.ax,tt,DataBS);
hold(fHandle.ax,'on');
for i = 1:6
    idxK = IdxInCluster{i};
    plot(fHandle.ax,tt(peakAll(idxK)),DataBS(peakAll(idxK)),[ c{i} '*'])
end
if ~isempty(Stimulus)
    plot(fHandle.ax,tt,Stimulus,'k','Linewidth',2)
end
xlabel(fHandle.ax,'Time (s)');ylabel(fHandle.ax,'mV')
title(fHandle.ax,fileName, 'interpreter', 'none')
hold(fHandle.ax,'off');

end