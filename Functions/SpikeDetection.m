function [spkNdx,SpikesAllV] = SpikeDetection(app)
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
voltageBS = app.voltageBS./app.Scale_fact;
fs = app.fs;
thresh = app.thresh;
peakDist = app.peakDist./app.fs;
window = app.window.*app.fs./1000+1;

smoothVBS = smooth(voltageBS,fs.*0.001);
[~,spkNdx] = findpeaks(-smoothVBS,fs,'MinPeakHeight',-thresh,'MinPeakDistance',peakDist);
spkNdx = round(spkNdx.*fs);

% Aligning spikes
SpikesAll = zeros(length(spkNdx),window);
SpikesAll(:,ceil(window/2)) = spkNdx;
for i = 1:floor(window/2)
    SpikesAll(:,ceil(window/2)-i) = spkNdx-i;
    SpikesAll(:,ceil(window/2)+i) = spkNdx+i;
end
SpikesAll(SpikesAll <1) = 1;
SpikesAll(SpikesAll >length(voltageBS)) = length(voltageBS);
SpikesAllV = voltageBS(SpikesAll);
if numel(spkNdx)==1
    SpikesAllV = SpikesAllV';
end
% baseline subtract average of each spike
SpikesAllV = SpikesAllV-mean(SpikesAllV,2);


end


