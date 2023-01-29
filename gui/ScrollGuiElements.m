classdef ScrollGuiElements
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
    % Date: 2013-03-06 18:11:31
    % Packaged: 2017-04-27 17:58:23
    properties
        param_;
        hdl_;
    end
    
    methods
        function obj = ScrollGuiElements(I,J,gui_element_handle)
            if nargin < 3
                obj.param_.gui_element_handle = @uicontrol;
            else
                obj.param_.gui_element_handle = gui_element_handle;
            end
            
            obj.param_.rows = I;
            obj.param_.columns = J;
            
            obj.param_.main_panel.pos = [0 0 1 1];
            obj.param_.slider.min = 0;
            obj.param_.slider.max = 1;
            obj.param_.slider.width = 20;
            obj.param_.cells.pos = cell(I,J);
            obj.param_.cells.height = 50;

            obj.hdl_.cells = zeros(I,J);

            obj.param_.margin.lx = 0.1;
            obj.param_.margin.rx = 0.05;
            obj.param_.margin.uy = 0.01;
            obj.param_.margin.ly = 0.01;
            
            obj.param_.scrolling = true;
        end
        
        function hdls = handles(obj)
            hdls = obj.hdl_.cells;
        end
        
        function h = at(obj,i,j)
            h = obj.hdl_.cells(i,j);
        end
        
        function obj = show(obj,parent_fig)
            if nargin < 2
                obj.hdl_.fig = figure;
            else
                obj.hdl_.fig = parent_fig;
            end
            set(gcf,'WindowScrollWheelFcn',@scroll);
            obj.hdl_.main_panel = uipanel('Parent',obj.hdl_.fig,...
                                   'Position',[0 0 1 1],...
                                   'ResizeFcn',@resize...
                                   );
            
            obj.param_.main_panel.pos = obj.getMainPanelPos();
            obj.hdl_.slider = uicontrol('Parent',obj.hdl_.main_panel,...
                                   'Style','slider',...
                                   'Units','pixels',...
                                   'Position',[obj.param_.main_panel.pos(3)-obj.param_.slider.width 0 obj.param_.slider.width obj.param_.main_panel.pos(4)],...
                                   'Min',obj.param_.slider.min,...
                                   'Max',obj.param_.slider.max,...
                                   'SliderStep',[1/100 1/10],...
                                   'Value',1,...
                                   'Callback',@scroll...
                                   );
            obj.param_.scroll_panel.height = obj.param_.rows*obj.param_.cells.height;
            obj.param_.scroll_panel.pos = -obj.param_.scroll_panel.height;
            obj.hdl_.scroll_panel = uipanel('Parent',obj.hdl_.main_panel,...
                                   'Units','pixels',...
                                   'Position',[0 obj.param_.scroll_panel.pos obj.param_.main_panel.pos(3)-obj.param_.slider.width obj.param_.scroll_panel.height]...
                                   );
                               
            for j = 1:obj.param_.columns
                for i = 1:obj.param_.rows
                    dx = (1 - obj.param_.margin.lx - obj.param_.margin.rx)/obj.param_.columns;
                    dy = (1 - obj.param_.margin.uy - obj.param_.margin.ly)/obj.param_.rows;
                    x0 = (j-1)*dx + obj.param_.margin.lx;
                    y0 = 1 - i*dy - obj.param_.margin.uy;
                    obj.param_.cells.pos{i,j} = [x0 y0 dx dy];
                    obj.hdl_.cells(i,j) = obj.param_.gui_element_handle('Parent',obj.hdl_.scroll_panel,'Units','normalized','Position',obj.param_.cells.pos{i,j});
                end
            end

            function scroll(hd,event_data)
                if obj.param_.scrolling
                    switch hd
                        case obj.hdl_.slider
                            slider_value = get(obj.hdl_.slider,'Value');
                        case obj.hdl_.fig
                            scr_change = event_data.VerticalScrollCount*event_data.VerticalScrollAmount/50;
                            slider_value = get(obj.hdl_.slider,'Value') - scr_change;
                            if slider_value < obj.param_.slider.min
                                slider_value = obj.param_.slider.min;
                            elseif slider_value > obj.param_.slider.max
                                slider_value = obj.param_.slider.max;
                            end
                            set(obj.hdl_.slider,'Value',slider_value);
                    end
                    new_ppos = (obj.param_.main_panel.pos(4)-obj.param_.scroll_panel.height)*(slider_value);
                    obj.setPanelPos(new_ppos);
                end
            end
            
            function resize(hd,event_data)
                obj.param_.main_panel.pos = obj.getMainPanelPos();
                set(obj.hdl_.scroll_panel,'Position',[0 obj.param_.main_panel.pos(4)-obj.param_.scroll_panel.height obj.param_.main_panel.pos(3)-obj.param_.slider.width obj.param_.scroll_panel.height]);
                sppos = get(obj.hdl_.scroll_panel,'Position');
                if obj.param_.main_panel.pos(4) >= obj.param_.scroll_panel.height
                    obj.param_.scrolling = false;
                    set(obj.hdl_.slider,'Position',[obj.param_.main_panel.pos(3)-obj.param_.slider.width sppos(2) obj.param_.slider.width sppos(4)]);
                    set(obj.hdl_.slider,'Enable','off');
                else
                    obj.param_.scrolling = true;
                    set(obj.hdl_.slider,'Position',[obj.param_.main_panel.pos(3)-obj.param_.slider.width 0 obj.param_.slider.width obj.param_.main_panel.pos(4)]);
                    set(obj.hdl_.slider,'Enable','on');
                end
            end
        end
    end
    
    methods(Access = 'protected')   
        function setPanelPos(obj,value)
            pp = get(obj.hdl_.scroll_panel,'Position');
            obj.param_.panel.pos = value;
            pp(2) = obj.param_.panel.pos;
            set(obj.hdl_.scroll_panel,'Position',pp);
        end
        
        function mppos = getMainPanelPos(obj)
            mppos = get(obj.hdl_.main_panel,'Position');
            fpos = get(obj.hdl_.fig,'Position');
            mppos = [mppos(1)*fpos(3) mppos(2)*fpos(4) mppos(3)*fpos(3) mppos(4)*fpos(4)];
        end
    end
end