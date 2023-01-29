classdef PlotElement < View.Item & Selectable
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
    % Date: 2017-02-23 13:57:18
    % Packaged: 2017-04-27 17:58:31
    properties(SetAccess = 'protected')
        plot_model;
        style_model;
        parent_axes;
        lines;
    end
    
    methods
        function obj = PlotElement(id,plot_element,plot_style,parent_axes)
            obj@View.Item(id);
            obj@Selectable(id);
            if nargin < 4
                pax = panelaxes;
                parent_axes = pax.axh;
            end
            obj.plot_model = plot_element;
            obj.models.add(plot_element);
            obj.style_model = plot_style;
            obj.models.add(plot_style);
            obj.parent_axes = parent_axes;
        end
        
        function update(obj)
            [x,y] = deal(obj.plot_model.getState('xdata'),obj.plot_model.getState('display_ydata'));
            line_properties = obj.style_model.getState('line_properties');
            
            n = size(y,2);
            delete(obj.lines);
            obj.lines = objectmx([n 1],'line','Parent',obj.parent_axes,'XData',x,'ButtonDownFcn',@obj.selectionCallback,'Visible','off',line_properties{:});                
            for j = 1:n, set(obj.lines(j),'YData',y(:,j)); end
            if obj.plot_model.getState('visible')
                for j = obj.plot_model.getState('y_selection'), set(obj.lines(j),'Visible','on'); end
            end
            obj.defineSelectableHandles(obj.lines);
%             obj.updateSelection();
        end
        
        function unshow(obj)
            delete(obj.lines);
%             delete(obj);
        end
    end
    
    methods(Access = 'protected')
        function highlight(obj,flag,i)
            w = obj.style_model.getState('width');
            set(obj.lines(i),'LineWidth',ceil(1.5*flag*w + w));
        end
        
        function open(obj)
        end
    end
end