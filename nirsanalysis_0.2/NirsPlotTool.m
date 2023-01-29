classdef NirsPlotTool < NirsObject
    % This class is used to create plot and map data.
    %
    % Example:
    % Maps values given by the 'values2map' property of the
    % NirsPlotTool object P.
    %   P.map('values');
    % Maps statsitic values stored in a NirsStatistics object T under
    % the names given by the 'tests2map' property of the NirsPlotTool
    % object P.
    %   P = P.map('statistics',T);
    % Check for further information the brain mapping tutorial
    %
    % WikiReplacements:
    % {'reference manual','[[routines:manual:referenceman#NirsPlotTool|reference manual]]'
    % ;'brain mapping tutorial','[[routines:manual:userman#brain_mapping|brain mapping tutorial]]'}
    %
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
    % Date: 2016-12-09 16:52:51
    % Packaged: 2017-04-27 17:58:44

    properties
        curr_figure_;
        ax_handles_;
        channel_number_;
        plot_figure = -1;
        plot_raster;
        plot_nirs_figure;
    end
    
    methods
        function obj = NirsPlotTool(varargin)
            obj = obj@NirsObject(varargin);
        end
        
        function obj = saveCurrentFigure(obj, file_name)
            [p, n, e] = fileparts(file_name);
            if isempty(e)
                e = '.jpg';
            end
            fN = length(obj.curr_figure_);
            if isempty(p)
                p = '.\';
            end
            if ~isdir(p)
                mkdir(p);
            end
            if fN == 1
                saveas(obj.curr_figure_, [p filesep n e]);
            else
                for i = 1:fN
                        saveas(obj.curr_figure_(i), [p filesep n '_part' num2str(i) 'of' num2str(fN) e]);
                end
            end
        end

        function obj = plotChannels(obj, subject_list, subject, ch_roi, data_name,line_color,line_style)
            dn = numel(data_name);
            nr = length(ch_roi);
            standard_score_flag = onoff2flag(obj.getProperty('standard_score'));
            
            ts_data = obj.getProperty('experiment').getProperty('time_series');
            ts_available = ts_data.tags(1);
            
            flag = true;
            for i = 1:dn
                flag = flag & any(strcmp(data_name{1},ts_available));
            end
            if ~flag
                error('NirsPlotTool.plotChannels: No time series found with name "%s", available -> %s',cell2str(data_name,','),cell2str(ts_available,','));
            end
            
            ns = size(subject_list.getSubjectData(subject,data_name{1}),1);
            data = zeros(ns,dn,nr);
            data_start = find(subject_list.getSubjectData(subject,ts_data.get({data_name{1},'trigger_name'})),1);
            time_axis = ((-data_start:ns - data_start - 1)/ts_data.get({data_name{1},'sample_rate'}))';
            for i = 1:dn
                d = subject_list.getSubjectData(subject,data_name{i});
                d = ifel(standard_score_flag,zscore(d),d);
                for r = 1:nr
                    data(:,i,r) = d(:,ch_roi(r));
                end
            end
            obj = obj.createNirsFigure();

            for r = 1:nr
                tsline = NAgui.GuiLine(obj.plot_raster.panels(1),time_axis,data(:,:,r),data_name,sprintf('SID%dCH%d',subject,ch_roi(r)));
                for i = 1:dn
                    set(tsline.value(i),'Color',line_color{i},'LineStyle',line_style{i});
                end
                obj.plot_nirs_figure.addGuiElement(tsline);
            end
            set(gca,'XLim',minmax(time_axis));
            obj.plot_nirs_figure.addGuiElement(NAgui.ClickText(obj.plot_raster.panels(2),'click_text'));
            obj.plot_nirs_figure.show();
        end
        
        function obj = showTrigger(obj,subject_list,subject_number,data_name,duration)
            time_series = obj.getProperty('experiment').getProperty('time_series');
            trigger_name = time_series.get({data_name,'trigger_name'});
            sample_rate = time_series.get({data_name,'sample_rate'});
            tr = subject_list.getSubjectData(subject_number,trigger_name);
            Tx = find(tr);
            Tvalue = double(tr(Tx));
            Tx = (Tx - Tx(1))/sample_rate;
            cmap = lines(max(Tvalue));
            
            obj = obj.createNirsFigure();
            for e = 1:length(Tx)
                trigger_block = NAgui.TriggerBlock(obj.plot_raster.panels(1),[Tx(e) Tx(e)+duration],e,Tvalue(e));
                set(trigger_block.value,'FaceColor',cmap(Tvalue(e),:));
                obj.plot_nirs_figure.addGuiElement(trigger_block);
            end
            obj.plot_nirs_figure.addGuiElement(NAgui.ClickText(obj.plot_raster.panels(2),'click_text'));
            obj.plot_nirs_figure.show();
        end
        
        function obj = plotSubjects(obj, subject_list, subjects, channel, data_names, plot_styles, figure_style)
            if nargin == 6
                figure_style = 'boxes';
            end
            standard_score_flag = onoff2flag(obj.getProperty('standard_score'));
            
            ts_data = obj.getProperty('experiment').getProperty('time_series');
            ts_available = ts_data.tags(1);
            
            data_number = length(data_names);
            time_axis = cell(1,data_number);
            D = cell(1,data_number);
            
            subject_number = length(subjects);
            for d = 1:data_number
                if any(strcmp(data_names{d},ts_available))
                    subj_data = cell(1,subject_number);
                    trigger_data = cell(1,subject_number);
                    for s = 1:subject_number
                        single_subj_data = subject_list.getSubjectData(subjects(s),data_names{d});
                        if standard_score_flag
                            subj_data{s} = toStandardScore(single_subj_data(:,channel));
                        else
                            subj_data{s} = single_subj_data(:,channel);
                        end
                        trigger_data{s} = subject_list.getSubjectData(subjects(s),ts_data.get({data_names{d},'trigger_name'}));
                    end
                    data_start = cellfun(@(x) find(x,1),trigger_data);
                    last_start = max(data_start);
                    data_length = cellfun(@(x) size(x,1) ,subj_data);
                    ch_data = NaN(max(data_start) + max(data_length - data_start),length(subjects));
                    for s = 1:subject_number
                        this_start = last_start-data_start(s)+1;
                        ch_data(this_start:this_start+data_length(s)-1,s) = subj_data{s};
                    end
                    D{d} = ch_data;
                    time_axis{d} = ((-last_start:size(D{d},1) - last_start - 1)/ts_data.get({data_names{d},'sample_rate'}))';
                else
                    error(['NirsPlotTool.plotChannels: No time series found with name "' data_names{d} '"']);
                end
            end
            
            obj = obj.createFigures(1,'single');
            plot1Axis(time_axis,D,subjects,data_names,plot_styles,'Subject');
        end        
        
        function obj = plotEra(obj,era_object,plot_styles,varargin)
            era_plot_style = obj.getProperty('era_plot_style');
            global_scale = obj.getProperty('global_scale');
            
            names_needed = {'data','contrasts','group','rois'};
            test_info(1).test_fcn_handle = @(x) iscellstr(x);
            test_info(1).error_str = 'Data names must be a string cell.';
            test_info(3).test_fcn_handle = @(x) ischar(x);
            test_info(3).error_str = 'Group name must be a string.';
            switch era_plot_style
                case 'scroll'
                    test_info(2).test_fcn_handle = @(x) iscellstr(x);
                    test_info(2).error_str = 'Contrast names must be a string cell.';
                    test_info(4).test_fcn_handle = @(x) iscellstr(x);
                    test_info(4).error_str = 'ROI names must be a string cell.';
                case 'probeset'
                    probesets = obj.getProperty('probesets');
                    probesets_available = probesets.tags(1);
                    test_info(2).test_fcn_handle = @(x) ischar(x);
                    test_info(2).error_str = 'Contrast name must be a string.';
                    test_info(4).test_fcn_handle = @(x) ischar(x) && any(strcmp(x,probesets_available));
                    test_info(4).error_str = 'ROI name must be a probeset name.';
            end
            era_plot_style
            [~,values,error_str] = parsePropertyCell(varargin,names_needed,test_info);
            if ~isempty(error_str)
                error('NirsPlotTool.plotEra: %s',error_str);
            end
            [dnames,cnames,gname,rnames] = deal(values{:});
            [datan,contn,roin] = deal(length(dnames),length(cnames),length(rnames));
            
            exp_data = era_object.getProperty('experiment');
            t = cell(1,datan);
            if isa(era_object,'NirsEventRelatedAverage')
                T = era_object.getProperty('interval');
                pre_T = era_object.getProperty('pre_time');
                for d = 1:datan
                    fs = exp_data.getProperty('time_series').get({dnames{d},'sample_rate'});
                    t{d} = (-pre_T + T(1):1/fs:T(2))';
                end
            else
                subs = era_object.tags(4);
                for d = 1:datan
                    if iscell(cnames)
                        t{d} = era_object.get({'taxis',dnames{d},cnames{1},subs{1}});
                    else
                        t{d} = era_object.get({'taxis',dnames{d},cnames,subs{1}});
                    end
                end
            end
            switch era_plot_style
                case 'scroll'
                    obj = obj.createFigures([roin contn],'scroll');
                    pdata = cell([roin contn datan 2]);
                    gname = strsplit(gname,'.'); gname = gname{1};
                    for d = 1:datan
                        for c = 1:contn
                            for r = 1:roin
                                pdata{r,c,d,1} = era_object.getParameter('parameter','era.avg','data',dnames{d},'contrast',cnames{c},'group',[gname '.average'],'roi',rnames{r});
                                pdata{r,c,d,2} = era_object.getParameter('parameter','era.avg','data',dnames{d},'contrast',cnames{c},'group',[gname '.ste'],'roi',rnames{r});
                            end
                        end
                    end
                case {'probeset'}
                    channel_matrix = obj.getProperty('probesets').get({rnames,'probeset'}).channelMatrix();
                    ch_number = sum(~isnan(channel_matrix(:)));
                    contn = 1;
                    roin = ch_number;
                    obj = obj.createFigures(ch_number,'probeset',channel_matrix);
                    roi_str = sprintf('1:%d.select',ch_number);
                    pdata = cell([roin contn datan 2]);
                    gname = strsplit(gname,'.'); gname = gname{1};
                    for d = 1:datan
                        for c = 1:contn
                            era.avg = era_object.getParameter('parameter','era.avg','data',dnames{d},'contrast',cnames,'group',[gname '.average'],'roi',roi_str);
                            era.std = era_object.getParameter('parameter','era.avg','data',dnames{d},'contrast',cnames,'group',[gname '.ste'],'roi',roi_str);
                            for r = 1:roin
                                pdata{r,c,d,1} = era.avg(:,r);
                                pdata{r,c,d,2} = era.std(:,r);
                            end
                        end
                    end
            end
            standard_score_flag = onoff2flag(obj.getProperty('standard_score'));
            
            nplots = roin*contn;
            ylimits = zeros(nplots,2);
            set(obj.ax_handles_,'NextPlot','add');
%             axescross(obj.ax_handles_);
            set(obj.ax_handles_,'Visible','off','Clipping','off');
            for r = 1:roin
                for c = 1:contn
                    ca = obj.ax_handles_(r,c);
                    set(ca,'XLim',minmax(t{1}));
                    for d = 1:datan
                        pData = pdata{r,c,d,1};
                        sData = pdata{r,c,d,2};
                        if standard_score_flag
                            p_std = std(pData);
                            pData = pData/p_std;
                            sData = sData/p_std;    
                        end
                        if ~any(isnan(pData)) || ~any(isnan(sData))
                            patch(errortube(t{d},pData,sData,'FaceColor',plot_styles{d},'FaceAlpha',0.15),'Parent',ca);
                        end
                        plot(ca,t{d},pData,'Color',plot_styles{d},'LineWidth',2,'Clipping','off');
                        if isempty(global_scale)
                            ylimits(voxel2index([c r],[2 nplots]),:) = get(ca,'YLim');
                        else
                            ylimits(voxel2index([c r],[2 nplots]),:) = global_scale;
                        end
                    end
                    switch era_plot_style
                        case 'scroll'
                            if c == 1, set(get(ca,'YLabel'),'String',rnames{r}); else set(ca,'YTickLabel',[]); end
                            if r == 1, set(get(ca,'Title'),'String',cnames{c}); end
                        case 'probeset'
                    end
                end
            end
            ylim = [min(ylimits(:,1)) max(ylimits(:,2))];
            set(obj.ax_handles_,'Ylim',ylim);
            ytlbs = get(obj.ax_handles_(1),'YTickLabel');
            ytlbs(1,:) = {repmat(' ',[1 size(ytlbs,2)])};
            set(obj.ax_handles_(:,1),'YTickLabel',ytlbs);
            if ~isempty(obj.getProperty('era_mark'))
                x = obj.getProperty('era_mark');
                for a = 1:numel(obj.ax_handles_)
                    ylim = get(obj.ax_handles_(a),'YLim');
                    for m = 1:size(x,1)
                        patch([x(m,1) x(m,2) x(m,2) x(m,1)],[ylim(1) ylim(1) ylim(2) ylim(2)],[0.5 1 0.5],'EdgeColor','None','FaceAlpha',0.2,'Parent',obj.ax_handles_(a));
                        set(obj.ax_handles_(a),'LineWidth',2);
                        set(obj.ax_handles_(a),'Box','on');
                    end
                end
            end
            set(obj.curr_figure_,'Color','w');
        end

        
        function obj = showAnatomicAssignment(obj,probeset_name)
            probesets = obj.getProperty('probesets');
            probesets_available = probesets.tags(1);
            if any(strcmp(probeset_name,probesets_available))
                ps = probesets.get({probeset_name,'probeset'});
                showLabelTab(ps.coordData(),lower(ps.getProperty('anatomic_assignment_type')));
            else
                error('NirsPlotTool.showAnatomicAssignment: Probe set ''%s'' not found.',probeset_name);
            end
        end
        
        function obj = map(obj,map_type,stats)
        % Creates figures of spatial maps. Check the plot-tool property table in the reference
        % manual for possible settings.
        %
        
            show_probeset = onoff2flag(obj.getProperty('show_probeset'));
            cmap_str = obj.getProperty('color_map');
            gap_vec = obj.getProperty('color_gap');
            climit = obj.getProperty('color_limit');
            switch map_type
                case 'values'
                    values = obj.getProperty('values2map');
                    noncell_entries = ~cellfun(@iscell,values);
                    values(noncell_entries) = cellfun(@(x) {x},values(noncell_entries),'UniformOutput',false);
                    bold_channels = cell(size(values));
                    for i = 1:numel(values)
                        bold_channels{i} = cellfun(@(x) [],values{i},'UniformOutput',false);
                    end
                    values = cellfun(@(x) cellfun(@(y) y(:)',x,'UniformOutput',false),values,'UniformOutput',false);
                    if onoff2flag(obj.getProperty('standard_score'))
                        values = cellfun(@(x) cellfun(@(y) (y-nanmean(y))/nanstd(y),x,'UniformOutput',false),values,'UniformOutput',false);
                    end
                case 'statistics'
                    test_names = obj.getProperty('tests2map');
                    noncell_entries = ~cellfun(@iscell,test_names);
                    test_names(noncell_entries) = cellfun(@(x) {x},test_names(noncell_entries),'UniformOutput',false);
                    values = cellfun(@(x) cellfun(@(x) stats.getStats(x,obj.getProperty('statistic_map_values')),x,'UniformOutput',false),test_names,'UniformOutput',false);
                    bold_channels = cellfun(@(x) cellfun(@(x) stats.isSignificant(x),x,'UniformOutput',false),test_names,'UniformOutput',false);
            end
            if isempty(climit)
                v = cell2num(cellfun(@(x) cell2num(x,'column_wise'),values,'UniformOutput',false),'column_wise')';
                climit = [min(v) max(v)];
            end
            if strcmp(cmap_str,'gap')
                nan_color = ifel(strcmp(obj.getProperty('map_type'),'map'),[1 1 1],[0.6 0.6 0.6]);
                cmap = gap(normValue(gap_vec,climit),17,nan_color);
            else
                eval(['cmap = ' cmap_str '(17);']);
            end
            
            probesets = obj.getProperty('probesets');
            probesets_available = probesets.tags(1);
            probeset_names = obj.getProperty('probesets2map');
            probeset_names = ifel(isempty(probeset_names),probesets_available(1),probeset_names);
            if ischar(probeset_names)
                probeset_names = cellfun(@(x) repmat({probeset_names},size(x)),values,'UniformOutput',false);
            elseif iscellstr(probeset_names)
                probeset_names = repmat({probeset_names},size(values));
            end
            if ~isequal(size(values),size(probeset_names))
                error('NirsPlotTool.map: Bad probeset name cell.');
            end
            switch obj.getProperty('map_type')
                case 'map'
                    obj = obj.createFigures(size(values));
                    if iscellstr(probeset_names)
                        chmxs = cellfun(@(x) probesets.get({x,'probeset'}).channelMatrix(),probeset_names,'UniformOutput',false);
                    else
                        chmxs = cellfun(@(x) cellfun(@(y) probesets.get({y,'probeset'}).channelMatrix(),x,'UniformOutput',false),probeset_names,'UniformOutput',false);
                    end
%                     [values,chmxs,bold_channels] = deal(values',chmxs',bold_channels');
                    for i = 1:numel(values)
                        map2d(values{i}{1},chmxs{i}{1},'color_map',cmap,'color_limit',climit,'show_probeset',show_probeset,'significance',bold_channels{i}{1},'axes_handle',obj.ax_handles_.main(i));
                    end
                case {'brain_map','head_map','brain_blobs'}
                    show_head = onoff2flag(obj.getProperty('show_head'));
                    obj = obj.createFigures(size(values));
                    s = fliplr(size(values));
                    l = 800/max(s);
                    set(obj.curr_figure_,'Color','w','Position',[50 70 s.*l]);
                    if iscellstr(probeset_names)
                        coord_data = cellfun(@(x) probesets.get({x,'probeset'}).coordData(),probeset_names,'UniformOutput',false);
                    else
                        coord_data = cellfun(@(x) cellfun(@(y) probesets.get({y,'probeset'}).coordData(),x,'UniformOutput',false),probeset_names,'UniformOutput',false);
                    end
                    view_angles = obj.getProperty('view_angles');
                    view_angles = ifel(isnumeric(view_angles),repmat({view_angles},size(values)),view_angles);
                    if iscellstr(probeset_names)
                        template_names = cellfun(@(x) probesets.get({x,'probeset'}).getProperty('template_name'),probeset_names,'UniformOutput',false);
                    else
%                         template_names = cellfun(@(x) probesets.get({x,'probeset'}).getProperty('template_name'),probeset_names,'UniformOutput',false);
                        template_names = cellfun(@(x) cellfun(@(y) probesets.get({y,'probeset'}).getProperty('template_name'),x,'UniformOutput',false),probeset_names,'UniformOutput',false);
                    end
                    
                    
                    mapping_input = {'color_map',cmap ...
                                    ,'color_limit',climit ...
                                    ,'show_probeset',show_probeset ...
                                    };
                    switch obj.getProperty('map_type')
                        case 'brain_map'
                            mapping_input = [mapping_input {'show_head',show_head}];
                        case 'brain_blobs'
                            mapping_input = [mapping_input {'map_type','blobs','show_head',show_head}];
                        case 'head_map'
                            mapping_input = [mapping_input {'show_on_head',true}];
                    end
                    for i = 1:numel(values)
                        mapping_input_current = [mapping_input {'significance',bold_channels{i},'axes_handle',obj.ax_handles_.main(i),'template_name',template_names{i}{1}}];
                        map3d(values{i},coord_data{i},mapping_input_current{:});
%                         set(gca,'View',view_angles{i});
                        set(obj.ax_handles_.main(i),'View',view_angles{i});
                    end
                otherwise
                    error('NirsPlotTool.map: Unkown map type "%s".',obj.getProperty('map_type'));
            end
            if ~strcmp(obj.getProperty('show_colorbar'),'off')
                tag = obj.getProperty('show_colorbar');
                obj.ax_handles_.addElement('legend',showColorbar(cmap,'color_limit',climit,'tag',tag));
            end
        end
        
        function obj = bar(obj,value_type,stat)
            cmap = obj.getProperty('color_map');
            eval(sprintf('cmap = %s(64);',cmap));
            switch value_type
                case 'values'
                    values = obj.getProperty('values2map');
                    values = nonunicfun(@(x) x(:),values);
                    mdata = cell2mat(nonunicfun(@mean,values));
                    sdata = cell2mat(nonunicfun(@(x) std(x)/sqrt(length(x)),values));
                    figure;
                    barwebplot(mdata,sdata,'color_map',cmap,'data_cloud',values);
                case 'statistics'
                    stat_names = obj.getProperty('tests2map');
                    values = cell2mat(nonunicfun(@(x) stat.getStats(x,'test_statistic'),stat_names));
                    figure;
                    barwebplot(values,zeros(size(values)),'color_map',cmap);
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = createNirsFigure(obj)
            if ~ishandle(obj.plot_figure)
                obj.plot_figure = figure();
                obj.plot_raster = PanelRaster(obj.plot_figure,[2 1]);
%                 obj.plot_raster.panel_posratio = [0.9 0.1];
                evh = NAgui.EventHandler();
                obj.plot_nirs_figure = NAgui.NirsFigure(obj.plot_raster.panels(1),'plot');
                obj.plot_nirs_figure.setEventHandler(evh);
                obj.plot_nirs_figure.remove('click_text');
            end
        end
        
        function obj = createFigures(obj,N,style,varargin)
            if nargin == 2
                style = 'boxes';
            end
            switch lower(style)
                case 'single'
                    curr_figure = figure;
                    obj.ax_handles_ = gca;
                case 'boxes'
                    figure_number = 1;
                    obj.ax_handles_ = [];
                    parent = obj.getProperty('plot_parent');
                    if isempty(parent)
                        parent = figure;
                    end
                    obj.ax_handles_ = View.Matrix('brainmx');
                    obj.ax_handles_.show();
                    obj.ax_handles_.addElement('col_names',obj.getProperty('column_names'));
                    obj.ax_handles_.addElement('row_names',obj.getProperty('row_names'));
                    hdls = [];
                    for i = 1:N(1)
                        for j = 1:N(2)
                            hdls(i,j) = axes('Parent',parent);
                        end
                    end
                    obj.ax_handles_.addElement('main',hdls);
                    curr_figure = gcf;
                case 'eeg'
                    subplot1(N,1,'XTickL','Margin','Gap',[0 0]);
                    set(gcf,'Position', get(gcf,'Position').*[0 0 2 2] + [100 100 0 0]);
                    curr_figure = gcf;
                    obj.ax_handles_ = sort(get(gcf, 'Children'));
                case 'scroll'
                    SP = ScrollGuiElements(N(1),N(2),@axes);
                    SP.param_.cells.height = 150;
                    SP = SP.show();
                    obj.ax_handles_ = SP.handles();
                    curr_figure = gcf;
                case 'probeset'
                    parent = obj.getProperty('plot_parent');
                    if isempty(parent)
                        parent = figure;
                    end
                    PA = NirsProbesetAxes(varargin{1},parent);
                    PA = PA.show();
                    obj.ax_handles_ = PA.handles();
                    curr_figure = gcf;
            end
            obj.curr_figure_ = curr_figure;
        end
        
        function obj = update(obj,prop_name,prop_value)
        end
    end
    
    methods(Static = true)
        function prop_info = getPropertyInfos()
            prop_info.probesets.sub_names = {'name','probeset'};
            prop_info.probesets.test_fcn_handle = {@(x) ischar(x),@(x) isa(x,'NirsProbeset')};
            prop_info.probesets.error_str = {'Probeset name must be a string.','Probeset must be a NirsProbeset'};
            
            prop_info.standard_score.test_fcn_handle = @(x) any(strcmpi(x,{'on','off'}));
            prop_info.standard_score.error_str = 'Standard score must be ''on'' or ''off''.';
            
            value_types = {'test_statistic','p-values','effect_size'};
            prop_info.statistic_map_values.test_fcn_handle = @(x) any(strcmpi(x,value_types));
            prop_info.statistic_map_values.error_str = sprintf('Switch from t-values to effect sizes must be ''%s''.',cell2str(value_types,', '));
            
            prop_info.era_plot_style.test_fcn_handle = @(x) any(strcmpi(x,{'scroll','probeset'}));
            prop_info.era_plot_style.error_str = sprintf('ERA plot style must be ''%s'' or ''%s''.','scroll','probeset');
            
            prop_info.global_scale.test_fcn_handle = @(x) isnumeric(x) && (isempty(x) || (isvector(x) && length(x) == 2 && x(1) < x(2)));
            prop_info.global_scale.error_str = 'Global scale must be empty or a vector with 2 ascending entries.';
            
            prop_info.era_mark.test_fcn_handle = @(x) isnumeric(x) && (isempty(x) || (size(x,2) == 2 && all(x(:,1) < x(:,2)) ));
            prop_info.era_mark.error_str = 'ERA mark must be empty or a vector with 2 ascending entries.';
            
            prop_info.show_peaks.test_fcn_handle = @(x) any(strcmpi(x,{'on','off'}));
            prop_info.show_peaks.error_str = 'Show peaks must be ''on'' or ''off''.';
            
            prop_info.show_probeset.test_fcn_handle = @(x) any(strcmpi(x,{'on','off'}));
            prop_info.show_probeset.error_str = 'Standard score must be ''on'' or ''off''.';
            
            prop_info.show_head.test_fcn_handle = @(x) any(strcmpi(x,{'on','off'}));
            prop_info.show_head.error_str = 'Show head must be ''on'' or ''off''.';
            
            prop_info.show_colorbar.test_fcn_handle = @ischar;
            prop_info.show_colorbar.error_str = 'Show colorbar must be a string.';
            
            prop_info.color_map.test_fcn_handle = @(x) ischar(x);
            prop_info.color_map.error_str = 'Color map must be must a name of a color map.';
            
            prop_info.color_limit.test_fcn_handle = @(x) isnumeric(x) && (isempty(x) || (isvector(x) && length(x) == 2 && x(1) < x(2)));
            prop_info.color_limit.error_str = 'Color limit must be empty or a vector with 2 ascending entries.';
            
            prop_info.color_gap.test_fcn_handle = @(x) (ischar(x) && strcmp(x,'significant')) || (isnumeric(x) && (isempty(x) || (isvector(x) && length(x) == 2 && x(1) < x(2))));
            prop_info.color_gap.error_str = 'Color gap must be either ''significant'' or empty or a vector with 2 ascending entries.';
            
            map_types = {'map','brain_map','brain_blobs','head_map'};
            prop_info.map_type.test_fcn_handle = @(x) any(strcmp(x,map_types));
            prop_info.map_type.error_str = ['Map type must be one of these: ''' cell2str(map_types,''', ') ''''];
            
            prop_info.values2map.test_fcn_handle = @(x) iscell(x) && (isempty(x) || all(cellfun(@iscell,x(:)) | cellfun(@isnumeric,x(:))));
            prop_info.values2map.error_str = 'Values to map must be a cell with only numeric entries or a cell of cells';
            
            prop_info.tests2map.test_fcn_handle = @(x) iscell(x) && (isempty(x) || all(cellfun(@iscellstr,x(:)) | cellfun(@ischar,x(:))));
            prop_info.tests2map.error_str = 'Names of tests to map must be a string cell or cell of string cells.';
            
            prop_info.probesets2map.test_fcn_handle = @(x) ischar(x) || (iscell(x) && (isempty(x) || all(cellfun(@iscellstr,x(:)) | cellfun(@ischar,x(:)))));
            prop_info.probesets2map.error_str = 'Names of probesets to map must be a string, a string cell or cell of string cells.';
            
            prop_info.row_names.test_fcn_handle = @(x) all(cellfun(@(y) ischar(y) || iscellstr(y),x));
            prop_info.row_names.error_str = 'Row names must be a string cell.';
            
            prop_info.column_names.test_fcn_handle = @(x) iscellstr(x);
            prop_info.column_names.error_str = 'Column names must be a string cell.';
            
            prop_info.view_angles.test_fcn_handle = @(x) iscell(x) || (isnumeric(x) && isvector(x) && length(x) == 2);
            prop_info.view_angles.error_str = 'View angles must be a two element vector.';
            
            prop_info.plot_parent.test_fcn_handle = @(x) isempty(x) || ishandle(x);
            prop_info.plot_parent.error_str = 'Parent handle must be empty or a handle.';
            
            prop_info = NirsObject.addHelpTexts('plot_tool',prop_info);
        end
    end
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'plot_tool';
        end
    end
end