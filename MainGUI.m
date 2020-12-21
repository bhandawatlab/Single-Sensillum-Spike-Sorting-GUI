function [] = MainGUI()
% SpikeSortingGUI Comments/Documentations

%  Create and then hide the UI as it is being constructed.

% hsurf    = uicontrol('Style','pushbutton',...
%     'String','Surf','Position',[x*1.2,y,70,25]);
currentFolder = pwd;
addpath(genpath(currentFolder))
close all
fileName = [];fileNameStim = [];IdxInClusterUpdated = cell(1,6);
fileNameStim_name = [];fs = [];
global fromEphys
global DataExp
global tog
global Data

hs = addcomponents;
    function hs = addcomponents
        hs.fig = figure('Visible','off','Tag','fig','SizeChangedFcn',@resizeui);
        set(gcf,'position',[10 150 1000 800])
        hs.ax = axes('Parent',hs.fig,'Units','pixels', 'Tag','ax');
        hs.axS1 = axes('Parent',hs.fig,'Units','pixels', 'Tag','ax');
        hs.axS2 = axes('Parent',hs.fig,'Units','pixels', 'Tag','ax');
        hs.axS3 = axes('Parent',hs.fig,'Units','pixels', 'Tag','ax');
        hs.axS4 = axes('Parent',hs.fig,'Units','pixels', 'Tag','ax');
        hs.axS5 = axes('Parent',hs.fig,'Units','pixels', 'Tag','ax');
        hs.axS6 = axes('Parent',hs.fig,'Units','pixels', 'Tag','ax');
        
        hs.btn = uicontrol(hs.fig,'String',...
            'Load Data',...
            'Callback',@loadData,...
            'Tag','button');
        
        hs.btn2 = uicontrol(hs.fig,'String',...
            'Plot Results',...
            'Callback',@plotData,...
            'Tag','button');
        
        hs.btn3 = uicontrol(hs.fig,'String',...
            'updateCluster',...
            'Callback',@updateCluster,...
            'Tag','button');
        
        hs.btn4 = uicontrol(hs.fig,'String',...
            'Load Stim File',...
            'Callback',@loadStim,...
            'Tag','button');
        
        hs.btn5 = uicontrol(hs.fig,'String',...
            'Preview Stim',...
            'Callback',@PreviewStim,...
            'Tag','button');
        
        hs.btn6 = uicontrol(hs.fig,'String',...
            'Run Experiment',...
            'Callback',@runOpt,...
            'Tag','button');
        
        hs.btn7 = uicontrol(hs.fig,'String',...
            'Plot Experiment',...
            'Callback',@plotOpt,...
            'Tag','button');
        
        hs.btn8 = uicontrol(hs.fig,'String',...
            'Save Experiment',...
            'Callback',@saveOpt,...
            'Tag','button');
        
        hs.txtbox1 = uicontrol(hs.fig,'Style','edit',...
            'String','Enter True Cluster 1 Here');
        
        hs.txtbox2 = uicontrol(hs.fig,'Style','edit',...
            'String','Enter True Cluster 2 Here');
        
        hs.txtbox3 = uicontrol(hs.fig,'Style','edit',...
            'String','Enter True Cluster 3 Here');
        
        hs.txtbox4 = uicontrol(hs.fig,'Style','edit',...
            'String','Enter True Cluster 4 Here');
        
        hs.pm = uicontrol(hs.fig,'Style','popupmenu',...
            'String',{'1','2','3','4','5','6','7','8','9','10'},...
            'Value',1);
        
        hs.t = uicontrol(hs.fig,'Style','text',...
                'String','Current Status: Standby',...
                'FontSize',12);
        
    end

    function resizeui(hObject,event)
        % Get figure width and height
        figwidth = hs.fig.Position(3);
        figheight = hs.fig.Position(4);
        
        % Set button position
        bleftedge = 10;
        
        % Set axes position
        axheight1 = .45*figheight;
        axbottomedge1 = max(0,figheight - axheight1 - 30);
        axleftedge1 = bleftedge + 40;
        axwidth1 = max(0,(figwidth - axleftedge1)/2.5);
        hs.ax.Position = [axleftedge1 axbottomedge1 axwidth1 axheight1];
        
        % Set axes position S1
        axheight = .18*figheight;
        axbottomedge = max(0,figheight - axheight - 30);
        axwidth = max(0,(figwidth - axleftedge1)/5.2);
        axleftedge = bleftedge + (figwidth)/2+20;
        hs.axS1.Position = [axleftedge axbottomedge axwidth axheight];
        
        % Set axes position S2
        axheight = .18*figheight;
        axbottomedge = max(0,figheight - axheight - 30);
        axwidth = max(0,(figwidth - axleftedge1)/5.2);
        axleftedge = bleftedge + (figwidth)/1.3;
        hs.axS2.Position = [axleftedge axbottomedge axwidth axheight];
        
        % Set axes position S3
        axheight = .18*figheight;
        axbottomedge = axbottomedge1;
        axwidth = max(0,(figwidth - axleftedge1)/5.2);
        axleftedge = bleftedge + (figwidth)/2+20;
        hs.axS3.Position = [axleftedge axbottomedge axwidth axheight];
        
        % Set axes position S4
        axheight = .18*figheight;
        axbottomedge = axbottomedge1;
        axwidth = max(0,(figwidth - axleftedge1)/5.2);
        axleftedge = bleftedge + (figwidth)/1.3;
        hs.axS4.Position = [axleftedge axbottomedge axwidth axheight];
        
        % Set axes position S5
        axheight = .18*figheight;
        axbottomedge = max(0,figheight - axheight - 55)-axbottomedge1;
        axwidth = max(0,(figwidth - axleftedge1)/5.2);
        axleftedge = bleftedge + (figwidth)/2+20;
        hs.axS5.Position = [axleftedge axbottomedge axwidth axheight];
        
        % Set axes position S6
        axheight = .18*figheight;
        axbottomedge = max(0,figheight - axheight - 55)-axbottomedge1;
        axwidth = max(0,(figwidth - axleftedge1)/5.2);
        axleftedge = bleftedge + (figwidth)/1.3;
        hs.axS6.Position = [axleftedge axbottomedge axwidth axheight];
        
        axwidth = figwidth./3;
        
        y = axbottomedge1-90;
        x = axleftedge1;
        hs.btn.Position = [x y axwidth1./3 hs.btn.Position(4)];
        
        y = axbottomedge1-90;
        x = axleftedge1+axwidth1/3;
        hs.btn2.Position = [x y axwidth1./3 hs.btn.Position(4)];
        
        y = axbottomedge1-90;
        x = axleftedge1+2*axwidth1/3;
        hs.btn3.Position = [x y axwidth1./3 hs.btn.Position(4)];
        
        y = axbottomedge1-120;
        x = axleftedge1;
        hs.btn4.Position = [x y axwidth1./3 hs.btn.Position(4)];
        
        y = axbottomedge1-120;
        x = axleftedge1+2*axwidth1/3;
        hs.btn5.Position = [x y axwidth1./3 hs.btn.Position(4)];
        
        y = axbottomedge1-150;
        x = axleftedge1;
        hs.btn6.Position = [x y axwidth1./3 hs.btn.Position(4)];
        
        y = axbottomedge1-150;
        x = axleftedge1+axwidth1/3;
        hs.btn7.Position = [x y axwidth1./3 hs.btn.Position(4)];
        
        y = axbottomedge1-150;
        x = axleftedge1+2*axwidth1/3;
        hs.btn8.Position = [x y axwidth1./3 hs.btn.Position(4)];
        
        y = axbottomedge1-120;
        x = axleftedge1+axwidth1/3;
        hs.pm.Position = [x*1.1 y axwidth1./4 hs.btn.Position(4)];
        
        y = axbottomedge1-1.1*axbottomedge1/1.5;
        x = bleftedge + (figwidth)/2+20;
        hs.txtbox1.Position =  [x y axwidth hs.txtbox1.Position(4)];
        
        y = axbottomedge1-1.2*axbottomedge1/1.5;
        x = bleftedge + (figwidth)/2+20;
        hs.txtbox2.Position =  [x y axwidth hs.txtbox2.Position(4)];
        
        y = axbottomedge1-1.3*axbottomedge1/1.5;
        x = bleftedge + (figwidth)/2+20;
        hs.txtbox3.Position =  [x y axwidth hs.txtbox3.Position(4)];
        
        y = axbottomedge1-1.4*axbottomedge1/1.5;
        x = bleftedge + (figwidth)/2+20;
        hs.txtbox4.Position =  [x y axwidth hs.txtbox4.Position(4)];
        
        y = axbottomedge1-200;
        x = axleftedge1+axwidth1/12;
        hs.t.Position =  [x y axwidth hs.txtbox4.Position(4)];
        
    end

    function loadData(hObject,event)
        prompt = {'Enter data File and Location'};
        dlg_title = 'Input';
        num_lines = 1;
        if isempty(fileName)
            defaultans = {'C:\Liangyu\Liangyu Data\AllData\data_171205_2_3.mat'};
        else
            defaultans = fileName;
        end
        %fileName = inputdlg(prompt,dlg_title,num_lines,defaultans);
        %[FileName,PathName] = uigetfile('*.mat','Select the Stim file','C:\Liangyu\Liangyu Data\AllData\');
        [FileName,PathName] = uigetfile('*.mat','Select the Stim file','F:\Liangyu Tao\Electrophys\Liangyu Data\180124Data\180124_0');
        
        fileName = {[PathName FileName]};
        fileNameStim_name = FileName;
    end

    function loadStim(hObject,event)
        prompt = {'Enter data File and Location'};
        dlg_title = 'Input';
        num_lines = 1;
        if isempty(fileNameStim)
            defaultans = {'F:\Liangyu Tao\Electrophys\IntensityData\170607_1_2_Stim_Train.mat'};
        else
            defaultans = fileNameStim;
        end
        %fileNameStim = inputdlg(prompt,dlg_title,num_lines,defaultans);
        [FileName,PathName] = uigetfile('*.mat','Select the Stim file','F:\Liangyu Tao\Electrophys\IntensityData\');
        fileNameStim = {[PathName FileName]};
        fileNameStim_name = FileName;
    end

    function [voltageBS,peakAll,SpikesAllV,Stimulus,IdxInCluster] = plotData(hObject,event)
        D = load(fileName{1});
        if isfield(D, 'Data')
            Data = D.Data;
            fs = 10000;vis = false;
            fHandle = hs;
            [voltageBS] = BaselineSubtraction(Data);
            [peakAll,SpikesAllV,Stimulus,IdxInCluster] = SpikeClustering(voltageBS,Data.Stimulus,fs,vis);
            PlottingFunctionsGUI(voltageBS,peakAll,SpikesAllV,Stimulus,IdxInCluster,fHandle,fs,fileNameStim_name);
            Data.voltageBS = voltageBS;
        elseif isfield(D, 'DataExp')
            Data = D.DataExp;
            fs = 10000;vis = false;
            fHandle = hs;
            [voltageBS] = BaselineSubtraction(Data);
            [peakAll,SpikesAllV,Stimulus,IdxInCluster] = SpikeClustering(voltageBS,Data.Stimulus,fs,vis);
            PlottingFunctionsGUI(voltageBS,peakAll,SpikesAllV,Stimulus,IdxInCluster,fHandle,fs,fileNameStim_name);
            Data.voltageBS = voltageBS;
        end
        tog = 1;
    end

    function [currStim] = PreviewStim(hObject,event)
        S = load(fileNameStim{1});
        StimType = hs.pm.Value;
        currStim = [];
        if isfield(S,'V')
            cla(hs.ax)
            
            if isfield(S,'fs')
                fs = S.fs;
            else
                fs = 10000;
            end
            if iscell(S.V)
                currStim = S.V{StimType};
            else
                currStim = S.V;
            end
            plot(hs.ax,(1:numel(currStim))./fs,currStim,'Linewidth',2);
            xlabel(hs.ax,'time (s)');ylabel(hs.ax,'stimulus (V)')
            xlim(hs.ax,[0 numel(currStim)./fs])
        end
        
%         if isfield(S,'V')%VBroken
%             cla(hs.ax)
%             %currStim = S.VBroken{StimType};
%             %currStim = S.trackRecord{StimType};
%             %currStim = S.VBroken604;
%             if isfield(S,'fs')
%                 fs = S.fs;
%             else
%                 fs = 10000;
%             end
%             currStim = S.V;
%             plot(hs.ax,currStim)
%         end
    end

    function updateCluster(hObject,event)
        C{1} = get(hs.txtbox1,'String');
        C{2} = get(hs.txtbox2,'String');
        C{3} = get(hs.txtbox3,'String');
        C{4} = get(hs.txtbox4,'String');
        [DataBS,peakAll,SpikesAllV,Stimulus,IdxInCluster] = plotData(hObject,event);
        IdxInClusterUpdated = cell(1,6);
        Data.peakAll = peakAll;
        for i = 1:4
            temp = strsplit(C{i},',');
            for j = 1:length(temp)
                temp2 = str2double(temp{j});
                if ~isnan(temp2)
                    IdxInClusterUpdated{i} = [IdxInClusterUpdated{i};IdxInCluster{temp2}];
                end
            end
        end
        fHandle = hs;
        if ~all(cellfun('isempty',IdxInClusterUpdated))
            PlottingFunctionsGUI(DataBS,peakAll,SpikesAllV,Stimulus,IdxInClusterUpdated,fHandle,fs,fileNameStim_name);
            %PlottingFunctionsGUI(DataBS,peakAll,SpikesAllV,Stimulus,IdxInClusterUpdated,fHandle);
        end
    end

    function runOpt(hObject,event)
        currStim = PreviewStim(hObject,event);
        if ~isempty(currStim)
            DataExp = []; fromEphys = [];
            display('running')
            set(hs.t, 'String', 'Current Status: Running');
            %Optogenetics_ephys(currStim,fileNameStim{1},hs.pm.Value);
            Optogenetics_ephys(currStim,fileNameStim{1},hs.pm.Value);
        end
        pause(1);
        set(hs.t, 'String', 'Current Status: Standby');
    end

    function plotOpt(hObject,event)
        if ~isempty(DataExp)
            fs = 10000;vis = false;
            fHandle = hs;
            [voltageBS] = BaselineSubtraction(DataExp);
            [peakAll,SpikesAllV,Stimulus,IdxInCluster] = SpikeClustering(voltageBS,DataExp.Stimulus,fs,vis);
            PlottingFunctionsGUI(voltageBS,peakAll,SpikesAllV,Stimulus,IdxInCluster,fHandle,fs,'Recent Experiment');
            DataExp.IdxInCluster = IdxInCluster;
            DataExp.voltageBS = voltageBS;
            DataExp = orderfields(DataExp);
            tog = 0;
        end
    end

    function saveOpt(hObject,event)
        if ~isempty(DataExp)
            %save([fromEphys.dataFile],'DataExp');
            DataExp.IdxInClusterUpdated = IdxInClusterUpdated;
            if tog == 1
                DataExp = Data;
                DataExp.IdxInClusterUpdated = IdxInClusterUpdated;
                fromEphys.dataFile = fileName{1};
            end
            save([fromEphys.dataFile],'DataExp')
        end
    end


hs.fig.Visible = 'on';
end




