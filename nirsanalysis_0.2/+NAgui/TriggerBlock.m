classdef TriggerBlock < NAgui.GuiElement & NAgui.Selectable
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
    % Date: 2014-05-30 18:56:21
    % Packaged: 2017-04-27 17:58:50
    properties
        tstartend;
        event_id;
        category_id;
        label;
        edge_width = 1;
        face_alpha = 0.1;
    end
    
    methods
        function obj = TriggerBlock(gui_handle,tstartend,event_id,category_id)
            obj@NAgui.GuiElement(gui_handle,sprintf('EV%d',event_id));
            obj.value = patch('Visible','off');
            obj.label = text('Visible','off');
            obj.tstartend = tstartend;
            obj.category_id = category_id;
            set(obj.value,'ButtonDownFcn',@obj.buttonDown);
        end
        
        function show(obj)
            y_lim = get(obj.parent().figure_axes,'YLim');
            y_int = y_lim(2) - y_lim(1);
            [t1,t2] = deal(obj.tstartend(1),obj.tstartend(2));
            set(obj.value,'XData',[t1 t2 t2 t1],'YData',[y_lim(1) y_lim(1) y_lim(2) y_lim(2)],'FaceAlpha',obj.face_alpha,'LineWidth',obj.edge_width);
            set(obj.label,'Position',[t1 + (t2-t1)/2,y_lim(1) + 0.05*y_int],'String',stringify(obj.category_id));
            set(obj.value,'Visible','on');
            set(obj.label,'Visible','on');
        end
        
        function highlight(obj,flag)
            if flag
                obj.edge_width = 2;
                obj.face_alpha = 0.3;
            else
                obj.edge_width = 1;
                obj.face_alpha = 0.1;
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