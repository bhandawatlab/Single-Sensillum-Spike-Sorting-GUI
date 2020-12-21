function [] = SpikeSorting()
close all
spkTrain = []; spkFreq= cell(1,4);
matFile = dir;

fs = 10000;
baselineLen = 10000;
window = 5000; numOverlap = 2500;
%StimType = cell(1,10);
n = 1;kk = 1;startNdx = 26;current_fig = 1;

for i = 3+startNdx:length(matFile)
    fName = matFile(i).name;
    load(fName)
    
    if i == startNdx+3
        StimType{1} = Data.Stimulus;
        spkStmNdx = 1;
    else
        FirstInstance = [];
        for j = 1:length(StimType)
            FirstInstance = [FirstInstance ~isequal(Data.Stimulus,StimType{j})];
        end
        
        if all(FirstInstance)
            n = n+1;
            StimType{n} = Data.Stimulus;
            spkStmNdx = [spkStmNdx,n];
        else
            spkStmNdx = [spkStmNdx,find(FirstInstance == 0)];
        end
        
    end
    
    x = 0:1/fs:(length(Data.voltage)-1)/fs;
    [DataBS] = BaselineSubtraction(Data);
    
    %plot the sorted voltage trace
    figure(current_fig);subplot(3,1,kk)
    [spkTrain,peaks,peakType] = SpikeDetection(DataBS,Data.Stimulus,baselineLen,spkTrain,1);
    
    %plot the unsorted voltage trace
    figure(current_fig+100);subplot(3,1,kk)
    plot(Data.voltage);hold on;plot(Data.Stimulus-40);
    xlabel('Frames');ylabel('Voltage(mv)')
    
    for j = 1:3
        [spkFreq{j},~] = SpikeRate(x,peaks(peakType == j),window,numOverlap,fs,spkFreq{j},0);
    end
    [spkFreq{4},midTime] = SpikeRate(x,peaks,window,numOverlap,fs,spkFreq{4},0);
    kk = kk+1;
    if kk == 4 || i == length(matFile)
        figure(current_fig)
        set(gcf,'position',[962 42 958 1074])
        print('-dpsc2',['Figures/ProcessedVoltageTrace.ps'],'-loose','-append');
        figure(current_fig+100)
        set(gcf,'position',[962 42 958 1074])
        print('-dpsc2',['Figures/RecordedVoltageTrace.ps'],'-loose','-append');
        current_fig = current_fig+1;
        kk = 1;
    end
end
lowSpkNdx = sum(spkFreq{4},2)./20<5;
highSpkNdx = sum(spkFreq{2},2)./20>50;
if ~isempty([lowSpkNdx,highSpkNdx])
    spkStmNdx([lowSpkNdx | highSpkNdx]) = [];
    for i = 1:4
        spkFreq{i}([lowSpkNdx | highSpkNdx],:) = [];
        spkTrain{i}([lowSpkNdx | highSpkNdx],:) = [];
    end
end

close all
for i = 1:max(spkStmNdx)
    currStimNdx = find(spkStmNdx == i);
    if length(currStimNdx)>1
        currSpkTrain = spkTrain{2}(currStimNdx,:);
        %plot Raster plots
        figure;
        plotSpikeRaster(logical(currSpkTrain),'PlotType','vertline');
        hold on;plot(-StimType{i});ylim([-4 size(currSpkTrain,1)+1])
        xlabel('Samples');title(['Stimulus Type: ' num2str(i) ', Neuron Type: ' num2str(2)])
        set(gcf,'position',[962 42 958 1074])
        print('-dpsc2',['Figures/RasterPlots.ps'],'-loose','-append');
        %plot Histograms
        figure;
        for j = 1:length(currStimNdx)
            subplot(4,ceil(length(currStimNdx)./4),j)
            bar(midTime,spkFreq{2}(currStimNdx(j),:));hold on;plot(x,StimType{i},'r')
            xlabel('Time (s)');ylabel('Freq (Hz)');title(['Moving Bin: W=' num2str(window./fs) 's noverlap=' num2str(numOverlap./fs) 's'])
        end
        set(gcf,'position',[962 42 958 1074])
        print('-dpsc2',['Figures/Histograms.ps'],'-loose','-append');
    end
end


end