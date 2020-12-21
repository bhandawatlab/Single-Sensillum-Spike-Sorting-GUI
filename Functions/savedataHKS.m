function savedataHKS(s,event)

% parameters
HSgain = 10^4 ; %(pA/V) headstage gain with amp set at LOW probe gain 
extFixedVoltageGain = 5 ; % the gain set on the external filter 
extFixedCurrentGain = 10 ; % THESE GAINS HAVE TO BE MANUALLY SET  ON THE WARNER FILTER

% load global and persistent variables
global fromEphys
persistent voltage current
global DataExp

% define voltage and current gains based on AM systems amplifier
gain = mean(event.Data(:,6));
mode = mean(event.Data(:,7));

% gain values - amp output in V but data saved as mV and pA
variableGains = [1,2,5,10,20,50,100] ;

if mode<=2 ; % voltage clamp modes (Vtest, Vcomp, Vclamp)
     tempcurrent = event.Data(:,1) ;% current from variable output to channel A of amplifier to AI0
     tempvoltage = event.Data(:,2) ;
     voltagegain = 1000/(extFixedVoltageGain*10) ; % bessell filter gain at extFixedVoltageGain with fixed ouputs x10Vm
    
     [minV,minI] = min(abs(([1.5:.5:4.5]-gain))) ; 
     currentgain = HSgain/(variableGains(minI)*extFixedCurrentGain) ;
     
elseif mode>2 ; % current clamp (I=0, Iclamp, Iresist, Ifollow)
     tempvoltage = event.Data(:,1) ;
     tempcurrent = event.Data(:,3) ;
     currentgain = HSgain/10  ; % bessell filter gain at extFixedCurrentGain (*10 may be issue on JC rig only)
     
     [minV,minI] = min(abs(([3:.5:6]-gain))) ;
     voltagegain = 1000/(2*variableGains(minI)*extFixedVoltageGain) ;  
end
DataExp.preGainVoltage = tempvoltage;
DataExp.preGainCurrent = tempcurrent;

% % correct gain for voltage and current
tempvoltage = tempvoltage*voltagegain ;
tempcurrent = tempcurrent*currentgain ;

% concatinate previous event data with current event data
voltage = [voltage;tempvoltage];
current = [current;tempcurrent];

% analog outputs
Ao0 = event.Data(:,4) ;
%Ao1 = event.Data(:,5) ;

% trigger time
Trigtime = event.TriggerTime ;

% % figure
% subplot(5,1,1:2)
% plot(event.TimeStamps,tempvoltage)
% hold on
% title(['trial = ',num2str(fromEphys.n)])
% xlabel('time (sec)')
% ylabel('mV')
% xlim([0,fromEphys.numberofsamples/s.Rate]) 
% 
% subplot(5,1,3:4)
% plot(event.TimeStamps,tempcurrent)
% hold on
% xlabel('time (sec)')
% ylabel('pA')
% xlim([0,fromEphys.numberofsamples/s.Rate]) 
% 
% subplot(5,1,5)
% plot(event.TimeStamps,DataExp.Stimulus,'k-')
% hold on
% xlabel('time (sec)')
% ylabel('Voltage (volts)')
% xlim([0,fromEphys.numberofsamples/s.Rate]) 
% ylim([0 5])
display('Finished Running')

% save if scan is complete (output can be <200 points from input so 300 is
% buffer - this will be problematic if trial have remainders of 300 points)
if length(tempvoltage) == fromEphys.numberofsamples ;
    % save data
    DataExp.voltage = tempvoltage;
    DataExp.current = current;
    DataExp.Ao0 = Ao0;
    DataExp.trigtime = Trigtime;
    DataExp.voltagegain = voltagegain;
    DataExp.currentgain = currentgain;
    %save([fromEphys.dataFile],'DataExp');
    
    % clear peristent variables
    %clear voltage current
    
    % hold off plots
%     subplot(5,1,1:2)
%     hold off
%     subplot(5,1,3:4)
%     hold off
%     subplot(5,1,5)
%     hold off
    
%     % mark notes that trial has been run
%     Note = [datestr(Trigtime),' Trial ',num2str(fromEphys.n)] ;
%     fid = fopen(fromEphys.NotesFile,'a');
%     fprintf(fid,'%s \r\n',Note);
%     fclose(fid);
    
end
    
end
 

