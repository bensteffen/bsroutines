classdef ItemList < Model.Item
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
    % Date: 2016-08-04 16:58:49
    % Packaged: 2017-04-27 17:58:28
    properties(SetAccess = 'protected')
        list = IdList();
    end
    
    methods 
        function obj = ItemList(id)
            obj@Model.Item(id);
            
            
            obj.addInput(Input.ElementItem('column_name',[],'',Input.Test(@(x) ischar(x) || iscellstr(x),'Column names must be a string or string cell')));

            obj.addOutput(Output.ElementItem('column',[]));
            obj.addOutput(Output.ElementItem('row_names',[]));
        end
        
        function addItem(obj,item)
            if isa(item.model,'Model.Abstract')
                obj.list.add(item);
            else
                error('Model.ItemList.addItem: Item must be a Model');
            end
            obj.updateOutput();
        end
        
        function removeItem(obj,item_id)
            obj.list.remove(item_id);
            obj.updateOutput();
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            ids = obj.list.ids;
            obj.setOutput('row_names',ids);
            column_name = obj.getState('column_name');
            
            list_it = Iter(ids);
            col_data = cell(list_it.n,1);
            for i = list_it
                col_data{list_it.i} = obj.list.entry(i).getState(column_name);
            end
            obj.setOutput('column',col_data);
        end
    end
end