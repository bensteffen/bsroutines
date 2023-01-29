classdef Selectable < View.Item
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
    % Date: 2014-10-23 16:51:43
    % Packaged: 2017-04-27 17:58:31
    properties(SetAccess = 'protected')
        
    end
    
    methods        
        function update(obj)
            obj.checkSelection(obj.model.lastEntry().getState('selected_id'),obj.model.lastEntry().getState('selection_type'));
        end
    end
    
    methods(Access = 'protected')
        function obj = Selectable(selectable_id,selection_model_name)
            obj@View.Item(selectable_id);
            obj.models.add(Model.Empty(selection_model_name));
        end
        
        function selectionCallback(obj)
            obj.sendCommand(Command.Select(obj,obj.models.lastEntry()));
        end

        function checkSelection(obj,selected_id,selection_type)
            was_selected = strcmp(selected_id,obj.select_id);
            switch selection_type
                case 'normal'
                    if obj.is_selected
                        obj.setSelection(false);
                    else
                        obj.setSelection(was_selected);
                    end
                case {'alt','extend'}
                    if obj.is_selected
                        obj.setSelection(~was_selected);
                    else
                        obj.setSelection(was_selected);
                    end
                case 'open'
                    if was_selected
                        obj.open;
                    end
            end
        end

        function setSelection(obj,flag)
            obj.is_selected = flag;
            obj.highlight(flag);
        end
    end
    
    methods(Abstract = true)
        highlight(obj,flag);
        open(obj);
    end
end