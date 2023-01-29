classdef TextBox < NAgui.GuiElement
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
    % Date: 2014-03-21 16:46:41
    % Packaged: 2017-04-27 17:58:25
    properties
        text_string;
    end
    
    methods
        function obj = TextBox(gui_handle,text_id)
            obj@NAgui.GuiElement(gui_handle,text_id);
            obj.value = uicontrol('Parent',gui_handle,'Style','text','String','');
        end
        
        function show(obj)
            set(obj.value,'String',obj.text_string)
        end
        
        function update(obj)
            if isequal(obj.event_handler.last().child_id,obj.id)
                obj.line_width = 2;
            else
                obj.line_width = 1;
            end
            obj.show();
        end
    end
end