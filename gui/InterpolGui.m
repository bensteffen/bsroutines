classdef InterpolGui < Gui
    %
    % Disclaimer of Warranty (from http://www.gnu.org/licenses/):
    %  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
    %  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
    %  PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
    %  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    %  A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
    %  IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
    %  SERVICING, REPAIR OR CORRECTION.
    %  
    % Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
    % Date: 2015-05-20 11:39:08
    % Packaged: 2017-04-27 17:58:22
    properties
        subject_data;
        subjects;
        probesets;
        variance_thresh;
        data_names;
        probe_names;
        interp_data;
    end
    
    methods
        function obj = InterpolGui()
        end
        
        function obj = show(obj)
            obj.prm.reset_data = obj.interp_data;
            obj.mrg.between = 0.1;
            obj.hdl.plot_fig = figure('Position',[350 500 obj.mrg.screen_size(3)-350 obj.mrg.screen_size(4)-600],'CloseRequestFcn',@closeFigure);
            subplot1(1,2);
            obj.hdl.intpplot = valueat(get(gcf,'children'),2);
            obj.hdl.preview = valueat(get(gcf,'children'),1);
            obj.hdl.contr_fig = figure('Position',[25 500 300 obj.mrg.screen_size(4)-600],'CloseRequestFcn',@closeFigure);
                obj.hdl.layout.control = uiextras.VBox('Parent',obj.hdl.contr_fig);
                    obj.hdl.text.subject = uicontrol('Parent',obj.hdl.layout.control,'Style','text','String','Subject:');
                    obj.hdl.control.subject = uicontrol('Parent',obj.hdl.layout.control,'Style','popupmenu','String',obj.subjects,'Callback',@control);
                    obj.hdl.text.data = uicontrol('Parent',obj.hdl.layout.control,'Style','text','String','Data:');
                    obj.hdl.control.data = uicontrol('Parent',obj.hdl.layout.control,'Style','popupmenu','String',obj.data_names,'Callback',@control);
                    obj.hdl.text.probeset = uicontrol('Parent',obj.hdl.layout.control,'Style','text','String',sprintf('Probeset: %s',obj.probe_names{1}));
                    obj.hdl.control.space1 = uicontrol('Parent',obj.hdl.layout.control,'Style','text');
                    obj.hdl.chtab = uitable('Parent',obj.hdl.layout.control,...
                                            'ColumnFormat',{'numeric', 'numeric', 'logical'},...
                                            'ColumnName',{'Channel ID', 'var', 'interpolate?'},...
                                            'ColumnEditable',[false false true],...
                                            'CellEditCallback',@selectChannel...
                                            );
                    obj.hdl.control.space2 = uicontrol('Parent',obj.hdl.layout.control,'Style','text');
                    obj.hdl.layout.addrm = uiextras.HBox('Parent',obj.hdl.layout.control);
                        obj.hdl.control.push_add = uicontrol('Parent',obj.hdl.layout.addrm,'Style','pushbutton','String','Add','Callback',@add);
                        obj.hdl.control.push_remove = uicontrol('Parent',obj.hdl.layout.addrm,'Style','pushbutton','String','Remove','Callback',@remove);
                    obj.hdl.control.interp_list = uitable('Parent',obj.hdl.layout.control,...
                                                          'ColumnFormat',{'numeric','char','char','char'},...
                                                          'ColumnName',{'Subject ID','Data','Probeset','Channels'},...
                                                          'ColumnEditable',[false false false false],...
                                                          'RowStriping','off',...
                                                          'Data',obj.interp_data,...
                                                          'CellSelectionCallback',@interpListSelection...
                                                          );
                    obj.hdl.layout.close = uiextras.HBox('Parent',obj.hdl.layout.control);
                        obj.hdl.control.push_interp = uicontrol('Parent',obj.hdl.layout.close,'Style','pushbutton','String','Done','Callback',@done);
                        obj.hdl.control.push_cancel = uicontrol('Parent',obj.hdl.layout.close,'Style','pushbutton','String','Reset','Callback',@reset);
                set(obj.hdl.layout.control,'Sizes',[20 20 20 20 20 20 -1 10 20 -1 20]);
            control();
            uiwait(obj.hdl.contr_fig);
            function control(h,evdata)
                obj.prm.curr_subject = obj.subjects(get(obj.hdl.control.subject,'Value'));
                obj.prm.curr_data_name = obj.data_names{get(obj.hdl.control.data,'Value')};
                obj.prm.curr_probe_name = obj.probe_names{get(obj.hdl.control.data,'Value')};
                set(obj.hdl.text.probeset,'String',obj.prm.curr_probe_name);
                obj.prm.curr_probeset = obj.probesets.get({obj.prm.curr_probe_name,'probeset'});
                obj = obj.plotData();
            end
            
            function selectChannel(h,evdate)
                chdata = get(obj.hdl.chtab,'Data');
                obj = obj.setchs2interp(cell2mat(chdata(:,3)));
            end
            
            function add(h,evdata)
                tabdata = get(obj.hdl.control.interp_list,'Data');
                if isempty(tabdata)
                    tabdata = cell(1,4);
                    index = 1;
                else
                    subj_index = cellfun(@(x) x == obj.prm.curr_subject,tabdata(:,1));
                    data_index = strcmp(obj.prm.curr_data_name,tabdata(:,2));
                    index = subj_index & data_index;
                    index = ifel(any(index),find(index),size(tabdata,1) + 1);
                end
                tabdata{index,1} = obj.prm.curr_subject;
                tabdata{index,2} = obj.prm.curr_data_name;
                tabdata{index,3} = obj.prm.curr_probe_name;
                tabdata{index,4} = num2str(obj.prm.chs2interp');
                tabdata = sortrows(tabdata,1);
                set(obj.hdl.control.interp_list,'Data',tabdata);
            end
            
            function remove(h,evdata)
                tabdata = get(obj.hdl.control.interp_list,'Data');
                tabdata(obj.prm.curr_selected_interp,:) = [];
                set(obj.hdl.control.interp_list,'Data',tabdata);
            end
            
            function interpListSelection(h,evdata)
                if ~isempty(evdata.Indices)
                    obj.prm.curr_selected_interp = evdata.Indices(1);
                end
            end
            
            function done(h,evdata)
                obj.interp_data = get(obj.hdl.control.interp_list,'Data');
                delete(obj.hdl.plot_fig);
                delete(obj.hdl.contr_fig);
            end
            
            function reset(h,evdata)
                set(obj.hdl.control.interp_list,'Data',obj.prm.reset_data);
            end
            
            function closeFigure(h,evdata)
                reset();
                delete(obj.hdl.plot_fig);
                delete(obj.hdl.contr_fig);
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = plotData(obj)
            obj.prm.curr_raw = obj.subject_data.getSubjectData(obj.prm.curr_subject,obj.prm.curr_data_name);
            obj.prm.curr_chn = size(obj.prm.curr_raw,2);
            s2 = var(obj.prm.curr_raw);
            s2n = s2/std(s2);
            
            obj.prm.tabdat = [(1:obj.prm.curr_chn)' s2n'];
            chdat = flipud(sortrows(obj.prm.tabdat,2));
            obj.prm.tabdat = chdat;
            obj.prm.tabdat = num2cell(chdat);
            obj.prm.tabdat = [obj.prm.tabdat num2cell(chdat(:,2) >= obj.variance_thresh)];
            set(obj.hdl.chtab,'Data',obj.prm.tabdat);
            obj = obj.setchs2interp(cell2mat(obj.prm.tabdat(:,3)));
        end
        
        function obj = setchs2interp(obj,ch_vec)
            obj.prm.chs2interp = cell2mat(obj.prm.tabdat(ch_vec,1));
            chsrest = cell2mat(obj.prm.tabdat(~ch_vec,1));
            good = NaN(size(obj.prm.curr_raw)); good(:,chsrest) = obj.prm.curr_raw(:,chsrest);
            bad = NaN(size(obj.prm.curr_raw)); bad(:,obj.prm.chs2interp) = obj.prm.curr_raw(:,obj.prm.chs2interp);
            axes(obj.hdl.intpplot);
            figure(obj.hdl.plot_fig);
            plot1Axis({1:size(obj.prm.curr_raw,1),1:size(obj.prm.curr_raw,1)},{good,bad},1:obj.prm.curr_chn,{'good','bad'},{'k','r'},'Channel');
            
            obj.prm.curr_interp = NAfilt.gaussianNirsInterp(obj.prm.curr_raw,obj.prm.curr_probeset.channelMatrix(),obj.prm.chs2interp,obj.prm.curr_probeset.getProperty('optode_distance'));
            axes(obj.hdl.preview);
            plot1Axis({1:size(obj.prm.curr_interp,1),1:size(obj.prm.curr_interp,1)},{obj.prm.curr_interp},1:obj.prm.curr_chn,{'interp'},{'k'},'Channel');
        end
    end
end