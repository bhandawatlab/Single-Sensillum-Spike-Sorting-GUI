function [DataBS,LFP] = BaselineSubtraction(Data,fs)
% this function will conduct baseline subtraction with a spline average 200
% tracks of the signal downsampled by 1000 times.
% Inputs:
%    Data: Structure with the field voltage (mV)
%    Vis: "true" ("false") if you want (don't want) figures plotted
%       -Figures: vFitting (average of the splines used for subtraction)
% Outputs:
%    DataBS: A row vector of the baseline subtracted voltage (baseline
%    should now be near zero)

%
% Liangyu Tao 2017

if isfield(Data, 'fs')
    fs = Data.fs;
end
voltage = Data.voltage;
artDur = floor(5./1000.*fs);% recording initation artifact last for at most 5 ms
voltage(1:artDur) = mode(Data.voltage(artDur+1:ceil(fs./10)));% remove recording initiation artifact with mode
voltagePad = [ones(fs,1).*voltage(1); voltage; ones(fs,1).*voltage(end);];
LFPPad = medfilt1(voltagePad,fs.*0.3);
LFP = LFPPad(fs+1:fs+length(voltage));
DataBS = voltage-LFP;


% for i = 1:200
%     x = 1:1000:length(Data.voltage)-1000;
%     x = x+(i-1)*5+1;
%     fittingDataTemp = Data.voltage(x);
%     LargeChangeNdx = find(abs(diff(fittingDataTemp))>1);
%     fittingDataTemp(LargeChangeNdx(diff(LargeChangeNdx)==1)+1) = fittingDataTemp(LargeChangeNdx(diff(LargeChangeNdx)==1));
%     
%     pp = spline(x,fittingDataTemp);
%     vFitting(i,:) = ppval(pp,[1:500:length(Data.voltage)]);
%     
% end
% 
% x = [1:500:length(Data.voltage)];
% pp = spline(x,mean(vFitting,1));
% LFP = ppval(pp,[1:1:length(Data.voltage)]);
% DataBS = Data.voltage - LFP';
% 
% baselineY = sgolayfilt(DataBS, 1, 1001);
% DataBS = DataBS-baselineY;
% 
% % if vis
% %     figure;sublot(2,1,1);
% %     plot(vFitting(1,:));hold on;plot(vFitting(2,:));plot(vFitting(3,:));
% %     sublot(2,1,2);plot(mean(vFitting,1))
% % end

end