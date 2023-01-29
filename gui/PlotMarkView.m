classdef PlotMarkView < Selectable
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
    % Date: 2014-09-25 18:18:05
    % Packaged: 2017-04-27 17:58:23
    properties
        tstartend;
        event_id;
        mark_id;
        label;
        edge_width = 1;
        face_alpha = 0.1;
    end
    
    methods
        function obj = PlotMarkView(controller,model,parent,tstartend,event_id,mark_id)
            obj@Selectable(controller,model,parent);
            obj.h = patch('Visible','off');
            obj.label = text('Visible','off');
            obj.tstartend = tstartend;
            obj.mark_id = mark_id;
            obj.select_id = event_id;
            set(obj.h,'ButtonDownFcn',@obj.selectionCallback);
            
            obj.highlight(false);
            set(obj.h,'Visible','on');
            set(obj.label,'Visible','on');
        end
        
        function highlight(obj,flag)
            flag
            if flag
                obj.edge_width = 2;
                obj.face_alpha = 0.3;
            else
                obj.edge_width = 1;
                obj.face_alpha = 0.1;
            end
            y_lim = get(obj.parent,'YLim');
            y_int = y_lim(2) - y_lim(1);
            [t1,t2] = deal(obj.tstartend(1),obj.tstartend(2));
            set(obj.h,'XData',[t1 t2 t2 t1],'YData',[y_lim(1) y_lim(1) y_lim(2) y_lim(2)],'FaceAlpha',obj.face_alpha,'LineWidth',obj.edge_width);
            set(obj.label,'Position',[t1 + (t2-t1)/2,y_lim(1) + 0.05*y_int],'String',stringify(obj.mark_id));
        end
        
        function open(obj)
        end
    end
end