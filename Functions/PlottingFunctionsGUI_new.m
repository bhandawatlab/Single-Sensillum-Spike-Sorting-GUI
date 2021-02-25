%Plotting functions
function [] = PlottingFunctionsGUI_new(app,peakAll,SpikesAllV,Stimulus,IdxInCluster)
c = distinguishable_colors(app.nClust);

nCluster = numel(IdxInCluster);
npt = numel(app.LFP);

%% main plot
% Plotting voltage trace with the different types of spikes overlayed in 
% different color *.
tt = (1:numel(app.voltageBS))./app.fs;
cla(app.axMain,'reset')
yyaxis(app.axMain,'left');hold(app.axMain,'on');
plot(app.axMain,tt,app.voltageBS./app.Scale_fact);
hold(app.axMain,'on');
for i = 1:nCluster
    idxK = IdxInCluster{i};
    plot(app.axMain,tt(peakAll(idxK)),app.voltageBS(peakAll(idxK))./app.Scale_fact,'*','Color',c(i,:))
end
xlabel(app.axMain,'Time (s)');ylabel(app.axMain,'mV')
if ~isempty(Stimulus)
    yyaxis(app.axMain,'right');
    plot(app.axMain,tt,Stimulus,'k','Linewidth',2)
    ylabel(app.axMain,'Stim (V)')
    ylim(app.axMain,[min(app.voltageBS./app.Scale_fact) 5])
end
title(app.axMain,app.fileName, 'interpreter', 'none')
hold(app.axMain,'off');

app.axMain.YAxis(1).Color = 'b';
app.axMain.YAxis(2).Color = 'k';

%% LFP plot
% Plotting voltage trace with the different types of spikes overlayed in 
% different color *.
tt = (1:npt)./app.fs;
cla(app.axLFP,'reset')
yyaxis(app.axLFP,'left');hold(app.axLFP,'on');
for k = 1:nCluster
    idxK = IdxInCluster{k};
    spkTime = peakAll(idxK);
    
    [optN, ~, ~] = sshist(spkTime,1:50);
    optN = ceil(optN./(max(spkTime)-min(spkTime)).*npt);
    edges = linspace(0,npt,optN);  % Optimal segmentation
    curr_psth = histcounts(spkTime,edges)./(edges(2)-edges(1)).*app.fs;
    stairs(app.axLFP,(edges(1:end-1)+edges(2:end))./2./app.fs,curr_psth,'-','Color',c(k,:));
end
xlabel(app.axLFP,'Time (s)');ylabel(app.axLFP,'PSTH (Hz)')
yyaxis(app.axLFP,'left');hold(app.axLFP,'off');

yyaxis(app.axLFP,'right');plot(app.axLFP,tt,app.LFP,'k-');
xlabel(app.axLFP,'Time (s)');ylabel(app.axLFP,'LFP (mV)')

app.axLFP.YAxis(1).Color = 'k';
app.axLFP.YAxis(2).Color = 'k';

%% Plotting spikes overlayed on top of one another by cluster (waveform)
% tempFHandle = {fHandle.axS1,fHandle.axS2,fHandle.axS3,fHandle.axS4,fHandle.axS5,fHandle.axS6};
nDelay = floor(size(SpikesAllV,2)./2);
tt = (-nDelay:1:nDelay)./app.fs.*1000;% time in ms
increment = (nDelay*2+1)./app.fs.*1000;
%xtics = [-nDelay./2:nDelay./2:tt(end)+increment.*(nCluster-1)].*1000:nDelay;
xtics = [];xticLab = [];tt_Inc = 1;
cla(app.axWaveform,'reset');
if ~isempty(SpikesAllV)
    hold(app.axWaveform,'on');
    for k = 1:nCluster
        tt_Inc = tt+increment.*(k-1);
        if ~isempty(IdxInCluster{k})
            idxK = IdxInCluster{k};
            plot(app.axWaveform,tt_Inc,SpikesAllV(idxK,:)','Color',c(k,:));
            
            xtics = [xtics, [-nDelay./2 0 nDelay./2]./app.fs.*1000+increment.*(k-1)];
            xticLab = [xticLab [-nDelay./2 0 nDelay./2]./app.fs.*1000];
        end
        text(app.axWaveform,increment.*(k-1),ceil(max(SpikesAllV(:))),['n=' int2str(length(idxK))]);
    end
    ylim(app.axWaveform,[floor(min(SpikesAllV(:))).*1.1 ceil(max(SpikesAllV(:))).*1.1])
    xlim(app.axWaveform,[tt(1) tt_Inc(end)])
    
    xticks(app.axWaveform,xtics);
    xticklabels(app.axWaveform,cellstr(num2str(xticLab')))
	xlabel(app.axWaveform,'Time (ms)');ylabel(app.axWaveform,'mV')
    hold(app.axWaveform,'off');
end

end