function [] = Optogenetics_ephys(stim,stimFile,stimType)
% path = 'F:\Liangyu Tao\Electrophys\Liangyu Data\Intensity_Data\';
% stimFile = '170607_1_2_Stim_Train.mat';
% load([path stimFile])
% 
% clearvars -except VBroken60 stimFile
daqreset;

global fromEphys
global DataExp
global s
% define parameters
experiment_number = '1' ;                                                   % experiment number, change
params.numsecs = 360 ; % for each trial
params.sampleRate = 10000 ; % hz

% from params
fromEphys.numberofsamples = params.numsecs*params.sampleRate;

% prep data file
rootdir = [pwd '\' datestr(date, 'yymmdd'),'Data'];
exptag = [datestr(now,'yymmdd') '_' experiment_number];

mkdir(rootdir); % make root directory
mkdir(rootdir,exptag); % make experiment directory
cd([rootdir,'\',exptag]);

% Analog output
outputData = zeros(fromEphys.numberofsamples,1) ;                           % for light stimulus
% Optogenetics Stimulus
%stimType = input('Stim Train #?');
outputData(:,1)= stim;                                                
outputData(end) = 0; outputData(1) = 0;
outputData(isnan(outputData)) = 0;
DataExp.Stimulus = outputData;
DataExp.StimFile = stimFile;
DataExp.StimNum = stimType;

D = dir(['data*.mat']);
if isempty(D)
    n = 1;
else
    n = length(D)+1;
end
fromEphys.dataFile = ['data_' exptag '_' int2str(n)];
fromEphys.n = n;
% daq object for session
s = daq.createSession('ni');
s.Rate= params.sampleRate;

% initialize daq channels
s.addAnalogOutputChannel('Dev1','ao0','Voltage');

s.addAnalogInputChannel( 'Dev1','ai0','voltage');                           % Vout
s.addAnalogInputChannel( 'Dev1','ai1','voltage');
s.addAnalogInputChannel( 'Dev1','ai2','voltage');                           % Im
s.addAnalogInputChannel( 'Dev1','ai3','voltage');
s.addAnalogInputChannel( 'Dev1','ai4','voltage');
s.addAnalogInputChannel( 'Dev1','ai5','voltage');                           % Gain
s.addAnalogInputChannel( 'Dev1','ai6','voltage');                           % mode

s.queueOutputData(outputData) ;

s.NotifyWhenDataAvailableExceeds = fromEphys.numberofsamples ;

lh1 = s.addlistener('DataAvailable', @savedataHKS);

s.startBackground() ;

end