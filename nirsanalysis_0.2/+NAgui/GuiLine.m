classdef GuiLine < NAgui.GuiElement & NAgui.Selectable
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
    % Date: 2014-03-25 14:52:37
    % Packaged: 2017-04-27 17:58:50
    properties
        line_width = 1;
    end
    
    methods
        function obj = GuiLine(gui_handle,x_axis,y_values,data_names,roi_name)
            if ~iscell(data_names)
                data_names = {data_names};
            end
            obj@NAgui.GuiElement(gui_handle,sprintf('%s(%s)',roi_name,cell2str(data_names,',')));
            n = size(y_values,2);
            obj.value = zeros(n,1);
            for j = 1:n
                obj.value(j) = line('XData',x_axis,'YData',y_values(:,j));
            end
            set(obj.value,'ButtonDownFcn',@obj.buttonDown);
        end
        
        function show(obj)
            set(obj.value,'LineWidth',obj.line_width);
        end
        
        function highlight(obj,flag)
            if flag
                obj.line_width = 3;
            else
                obj.line_width = 1;
            end
            obj.show();
        end
        
        function open(obj)
            fprintf('double click\n');
        end
        
        function update(obj)
            last_event = obj.event_handler.last();
            switch last_event.event_type
                case 'button_down'
                    obj.checkSelection(last_event);
            end
        end
    end
end