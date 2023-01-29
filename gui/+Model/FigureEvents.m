classdef FigureEvents < Model.Item
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
    % Date: 2017-03-22 10:54:16
    % Packaged: 2017-04-27 17:58:28
    methods
        function obj = FigureEvents(figh)
            obj@Model.Item('figure_events');
            obj.figh = figh;
            set(obj.figh,'WindowScrollWheelFcn',@obj.scrollWheelCallback);
            set(obj.figh,'WindowButtonMotionFcn',@obj.mouseMotionCallback);
            set(obj.figh,'WindowButtonDownFcn',@obj.mouseDownCallback);
            set(obj.figh,'WindowButtonUpFcn',@obj.mouseUpCallback);
            
            obj.addOutput(Output.ElementItem('mouse_down_elements',{}));
            obj.addOutput(Output.ElementItem('mouse_up_elements',{}));
            obj.addOutput(Output.ElementItem('drag_mode',false));
            obj.addOutput(Output.ElementItem('signal_data',struct));
            obj.addOutput(Output.ElementItem('mouse_over_elements',{}));
            obj.addSignal(StateSignal('mouse_wheel'));
            obj.addSignal(StateSignal('mouse_move'));
            obj.addSignal(StateSignal('mouse_button'));
        end
        
        function updateOrder(obj,h)
            for v = Iter(obj.observers)
                v.setForeground(v.h == h)
            end
        end
    end
    
    properties(Access = 'protected')
        figh;
        last_ploc;
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            
        end
        
        function scrollWheelCallback(obj,h,d)
            obj.setOutput('signal_data',d);
            obj.sendSignal('mouse_wheel');
        end
        
        function mouseMotionCallback(obj,h,d)
            ploc = get(0,'PointerLocation');
            obj.last_ploc = ifel(isempty(obj.last_ploc),ploc,obj.last_ploc);
            
            d = struct('curr_pointer_location',ploc,'last_pointer_location',obj.last_ploc);
            obj.last_ploc = ploc;
            figp = get(obj.figh,'Position');
            
            mouse_over_elements = {};
            for v = Iter(obj.observers)
                h = guih(v);
%                 p = childpixelposition(h) + [figp(1:2) 0 0];
                p = childpixelposition(h);
%                 p = round(getpixelposition(h)) + [figp(1:2) 0 0];
                dx = [p(1) p(1)+p(3)];
                dy = [p(2) p(2)+p(4)];
%                 if strcmp(v.id,'size_changer')
%                     ploc
%                     p
%                 end
                if all([withinrange(ploc(1),dx) withinrange(ploc(2),dy)])
                    mouse_over_elements = cat(2,mouse_over_elements,v.id);
                end
            end
            
            obj.setOutput('signal_data',d);
            obj.setOutput('mouse_over_elements',mouse_over_elements);
            obj.sendSignal('mouse_move');
        end
        
        function mouseDownCallback(obj,h,d)
            d = struct('curr_handle',h);
            
            e = obj.getState('mouse_over_elements');
            obj.setOutput('signal_data',d);
            obj.setOutput('mouse_down_elements',e);
            obj.setOutput('drag_mode',true);
            obj.sendSignal('mouse_button');
        end
        
        function mouseUpCallback(obj,h,d)
            d = struct('curr_handle',h);
            
            e = obj.getState('mouse_over_elements');
            obj.setOutput('signal_data',d);
            obj.setOutput('mouse_up_elements',e);
            obj.setOutput('drag_mode',false);
            obj.sendSignal('mouse_button');
        end
    end
end