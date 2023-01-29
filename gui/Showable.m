classdef Showable < handle & Observer
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
    % Date: 2014-03-23 15:31:40
    % Packaged: 2017-04-27 17:58:25
    properties(Access = 'protected')
        event_handler;
        gui_parent;
        figure_parent;
    end
    
    properties(SetAccess = 'protected')
        gui_handle;
    end
   
    methods
        function setEventHandler(obj,event_handler)
            obj.event_handler = event_handler;
            event_handler.addObserver(obj);
        end
    end
    
    methods(Access = 'protected')
        function obj = Showable(gui_parent)
            obj.gui_parent = gui_parent;
            obj.figure_parent = NAgui.findFigureParent(gui_parent);
        end
        
        function buttonDown(obj,h,evd)
            event = NAgui.GuiEvent(obj.id,obj.parent().id,h,'button_down',evd);
            event.selection_type = get(obj.figure_parent,'SelectionType');
            obj.event_handler.addEvent(event);
        end
    end
    
    methods(Abstract = true)
        show(obj);
        update(obj);
    end 
end