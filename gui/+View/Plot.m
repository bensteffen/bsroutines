classdef Plot < GuiFigure
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
    % Date: 2017-04-11 18:13:57
    % Packaged: 2017-04-27 17:58:31
    methods
        function obj = Plot(id)
            obj@GuiFigure(id);
            
            scrs = get(0,'MonitorPositions');
            m = 50;
            set(obj.figh,'Position',scrs + [m m -2*m -2*m]);
            
            obj.plot_ids = IdList();
            obj.elements = Model.List('plot_elements');
            obj.styles = Model.List('plot_styles');
            obj.subscribeModel(obj.elements);
            obj.subscribeModel(obj.styles);
            
            obj.element_counter = 0;
        end
        
        function addPlot(obj,plot_id,varargin)
            
            switch numel(varargin)
                case 1
                    y = varargin{1};
                    if isa(y,'TimeSeries')
                        ts = y;
                        y = ts.x;
                        x = ts.t;
                        plot_type = 'PlotElement';
                    elseif isa(y,'EventOnsets')
                        x = [y.onsets(1) y.onsets(end)+1.2*y.duration(end)];
                        plot_type = 'TimeMarkers';
                    else
                        x = (1:size(y,1))';
                        plot_type = 'PlotElement';
                    end
                case 2
                    [x,y] = deal(varargin{:});
                    plot_type = 'PlotElement';
            end
            obj.addPlotElement(plot_id,plot_type);
            obj.curr_element.setInput('xdata',x);
            obj.curr_element.setInput('ydata',y);
            obj.curr_element.updateOutput();
            obj.updateAxes();
        end
    end
    
    properties(Access = 'protected')
        plot_ids;
        elements;
        element_counter;
        styles;
        curr_element;
        curr_style;
        curr_view;
        total_alignment;
        settings_scrolling;
        axh;
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            obj.h = plainpanel();
            obj.total_alignment = MatrixAlignment(obj.h);
%             obj.total_alignment = SizeChangeAlignment('h',obj);
            
            axalg = MatrixAlignment(obj.h);
            
            a = GuiAxes('axes'); 
            a.show();
            axalg.addElement(1,1,a);
            obj.axh = a.axes_handle;
            
            selection_view = View.SelectionString('selection_view',obj.model_list.entry('selection'),'display_name','selection');
            selection_view.show();
            obj.subscribeView(selection_view);
            axalg.addElement(2,1,selection_view,[40 1]);

            obj.total_alignment.addElement(1,1,axalg);
%             obj.total_alignment.setElement1(axalg);
            
            obj.settings_scrolling = ListScrolling('settings_scrolling',obj);
            obj.total_alignment.addElement(2,1,obj.settings_scrolling.h.h.h);
%             obj.total_alignment.setElement2(obj.settings_scrolling.h.h.h);
%             obj.total_alignment.heights = [1 40 160];
            obj.total_alignment.realign();
        end
        
        function addPlotElement(obj,plot_id,plot_type)
            element_id = [plot_id '.plotelement'];
            style_id = [plot_id '.plotstyle'];
            view_id = plot_id;
            
            if ~obj.elements.hasEntry(element_id)
                pelement = Model.(plot_type)(element_id);
                obj.elements.appendModel(pelement);
                
                pstyle = Model.PlotElementStyle(style_id);
                obj.styles.appendModel(pstyle);
                
                setview1 = View.ModelInputs([plot_id '.setview1'],pelement,'title',plot_id,'orientation',2);
                                
                if strcmp(plot_type,'PlotElement')
                    obj.element_counter = obj.element_counter + 1;
                    pstyle.setDefault('width',1);
                    
                    setview2 = View.ModelInputs([plot_id '.setview2'],pstyle,'orientation',2);
                    
                    setview1.setProperty('input_selection',{'roi','exclude','filter'});
                    setview2.setProperty('input_selection',{'color','width','style'});
                    
                    cmap = [1 0 0; 1 0.5 0.5; 0.5 0 0
                            0 0 1; 0.5 0.5 1; 0 0 0.5
                            0 1 0; 0.5 1 0.5; 0 0.5 0
                            1 0 1; 1 0.5 1; 0.5 0 0.5
                            0.5 0.5 0.5; 0.75 0.75 0.75; 0 0 0];
                    mxs = [3 5];
                    setview2.setViewProperties('color','selectable_colors',cmap,'color_matrix_size',mxs);
                    
                    i2colori = [1:3:size(cmap,1) 2:3:size(cmap,1) 3:3:size(cmap,1)];
                    pstyle.setInput('color',cmap(i2colori(obj.element_counter),:)).updateOutput();
                elseif strcmp(plot_type,'TimeMarkers')
                    setview1.setProperty('input_selection',{'events','exclude_events','conditions'});
                    
                    setview2 = View.TimeMarkersLegend([plot_id '.marker_legend'],pelement);
                    obj.subscribeView(setview2);
                end
                setview1.show();
                setview2.show();
                
                obj.subscribeView(setview1);
                obj.subscribeView(setview2);
                
                line_view = View.(plot_type)(view_id,pelement,pstyle,obj.axh);
                line_view.setStringCreator(SelectionChannelStringCreator);
                obj.subscribeView(line_view);
                
                vis_view = View.Input.Boolean([plot_id 'visview'],pelement,'visible','display_name','','style',0);
                obj.subscribeView(vis_view);
                vis_view.show();
                
                rm_button = UiPush('String','X','FontWeight','bold','Tag',plot_id,'Callback',@obj.rmButtonCallback);
                rm_button.show();
                
                added_view_ids = {vis_view setview1 setview2 rm_button};
                obj.settings_scrolling.appendElement(plot_id,added_view_ids,setview1.getProperty('height'));
                obj.settings_scrolling.mxa.widths = [20 0.7 0.3 20];
                obj.settings_scrolling.mxa.realign();
                
                obj.plot_ids.add(IdItem(plot_id,added_view_ids));
            end

            obj.curr_element = obj.elements.entry(element_id);
            obj.curr_view = obj.views.entry(view_id);
        end
        
        function updateAxes(obj)
            xlims = [];
            for element = Iter(obj.elements)
                x = element.getState('xdata');
                xlims = cat(1,xlims,[x(1) x(end)]);
            end
            xlims = minmax(xlims(:));
            if ~isrange(xlims)
                xlims = [0 1];
            end
            set(obj.axh,'XLim',xlims);
        end
        
        function removePlotElement(obj,plot_id)

            obj.removeElementToDo(plot_id);
            
            element_id = [plot_id '.plotelement'];
            style_id = [plot_id '.plotstyle'];
            view_id = plot_id;
            
            obj.model_list.entry('selection').removeSelectable(obj.views.entry(view_id));
            
            obj.views.entry(view_id).unshow();
%             for vid = Iter(obj.plot_ids.valueOf(plot_id))
%                 obj.unsubscribeView(vid);
%             end
            obj.settings_scrolling.deleteElement(plot_id);
            
            element = obj.elements.entry(element_id);
            if isa(element,'Model.PlotElement')
                obj.element_counter = obj.element_counter - 1;
            end
            obj.elements.removeModel(element_id);
            delete(element);
            
            style = obj.styles.entry(style_id);
            obj.styles.removeModel(style_id);
            delete(style);
            
            obj.unsubscribeView(plot_id);
            obj.plot_ids.remove(plot_id);
            
            obj.updateAxes();
        end
        
        function rmButtonCallback(obj,h,varargin)
            plot_id = get(h,'Tag');
            obj.removePlotElement(plot_id);
        end
        
        function closeToDo(obj)
            for id = Iter(obj.plot_ids.ids)
                obj.removePlotElement(id);
            end
        end
        
        function removeElementToDo(obj,plot_id)
            
        end
    end
end