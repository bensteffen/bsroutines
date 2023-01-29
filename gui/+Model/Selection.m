classdef Selection < Model.Item
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
    % Date: 2017-02-15 13:49:35
    % Packaged: 2017-04-27 17:58:29
    properties
        selection_observers;
    end
    
    methods
        function obj = Selection()
            obj@Model.Item('selection')
            
            obj.addInput(Input.ElementItem('figure',0,1,Input.Test(@isfigure,'Parent figure must be a valid figure handle')));
            obj.addInput(Input.ElementItem('selected_id','','',Input.Test(@ischar,'Selected ID must be a string')));
            obj.addInput(Input.ElementItem('selection_type','','normal',Input.Test(@ischar,'Selection type must be a string')));
            
            obj.addOutput(Output.ElementItem('selection_string',{''}));
            
            obj.selection_observers = IdList();
        end
        
        function addSelectable(obj,selectable)
            obj.selection_observers.add(IdItem(selectable.select_id,selectable));
        end
        
        function removeSelectable(obj,selectable)
            obj.selection_observers.remove(selectable.select_id);
        end
        
        function selectionUpdate(obj)
            for s = Iter(obj.selection_observers)
                s.value.updateSelection();
            end
            obj.updateOutput();
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            sel_str = {};
            for s = Iter(obj.selection_observers)
                sel_str = [sel_str; {s.value.getSelectionString()}];
            end
            obj.setOutput('selection_string',sel_str);
        end
    end
end