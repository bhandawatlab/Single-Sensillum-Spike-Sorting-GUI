%Plotting functions
function [] = PlottingFunctionsGUI(DataBS,peakAll,SpikesAllV,Stimulus,IdxInCluster,fHandle)
%plotting all spikes overlayed on top of one another
%plot(fHandle.ax,0:1/fs:(window-1)/fs,SpikesAllV(:,:)','r')
% title('BSSpikeTraces');
% xlabel('Time(s)');
% ylabel('Voltage(mv)');

%Plotting spikes overlayed on top of one another by cluster
tempFHandle = {fHandle.axS1,fHandle.axS2,fHandle.axS3,fHandle.axS4,fHandle.axS5,fHandle.axS6};
c = {'r','g','m','k','y','c'};
if ~isempty(SpikesAllV)
    for k = 1:6
        cla(tempFHandle{k})
        idxK = IdxInCluster{k};
        plot(tempFHandle{k},SpikesAllV(idxK,:)',c{k});
        ylim(tempFHandle{k},[floor(min(SpikesAllV(:))) ceil(max(SpikesAllV(:)))])
        xlim(tempFHandle{k},[1 size(SpikesAllV,2)])
        xlabel(tempFHandle{k},'Frames');ylabel(tempFHandle{k},'mV')
        title(tempFHandle{k},['Cluster: ' int2str(k) ' (' int2str(length(idxK)) ')']);
    end
end

% Plotting voltage trace with the different types of spikes overlayed in 
% different color *.
cla(fHandle.ax)
plot(fHandle.ax,DataBS);
hold(fHandle.ax,'on');
for i = 1:6
    idxK = IdxInCluster{i};
    plot(fHandle.ax,peakAll(idxK),DataBS(peakAll(idxK)),[ c{i} '*'])
end
if ~isempty(Stimulus)
    plot(fHandle.ax,Stimulus)
end
xlabel(fHandle.ax,'Frames');ylabel(fHandle.ax,'mV')
hold(fHandle.ax,'off');

end