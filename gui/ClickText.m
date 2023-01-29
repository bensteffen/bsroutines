classdef ClickText < NAgui.GuiElement
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
    % Date: 2014-03-24 17:17:43
    % Packaged: 2017-04-27 17:58:22
    properties
        text_string;
    end
    
    methods
        function obj = ClickText(gui_handle,text_id)
            obj@NAgui.GuiElement(gui_handle,text_id);
            obj.value = uicontrol('Parent',gui_handle ...
                                 ,'Style','text' ...
                                 ,'String','' ...
                                 ,'Units','normalized' ...
                                 ,'Position',[0 0 1 1] ...
                                 ,'FontSize',12 ...
                                 ,'HorizontalAlignment','center' ...
                                 );
        end
        
        function show(obj)
            set(obj.value,'String',obj.text_string)
        end
        
        function update(obj)
            last_event = obj.event_handler.last();
            if strcmp(last_event.event_type,'button_down')
                obj.text_string = '';
                i = IdIterator(obj.parent(),AllTreeIdsCollector());
                while ~i.done();
                    current_item = i.current();
                    if isa(current_item,'NAgui.Selectable')
                        if current_item.is_selected
                            obj.text_string = [obj.text_string ' ' current_item.id];
                        end
                    end
                    i.next();
                end
            end
            obj.show();
        end
    end
end