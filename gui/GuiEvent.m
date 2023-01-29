classdef GuiEvent
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
    % Date: 2014-03-23 13:20:28
    % Packaged: 2017-04-27 17:58:22
    properties
        child_id;
        gui_handle;
        parent_id;
        event_type;
        event_data;
        selection_type;
    end
    
    methods
        function obj = GuiEvent(child_id,parent_id,gui_handle,event_type,event_data)
            obj.child_id = child_id;
            obj.gui_handle = gui_handle;
            obj.parent_id = parent_id;
            obj.event_type = event_type;
            obj.event_data = event_data;
        end
    end
end