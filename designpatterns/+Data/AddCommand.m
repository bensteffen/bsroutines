classdef AddCommand < Command.Abstract
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
    % Date: 2017-03-14 18:46:57
    % Packaged: 2017-04-27 17:58:01
    methods
        function obj = AddCommand(invoker,reciever)
            obj@Command.Abstract(invoker,reciever)
            obj.indices = indices;
            obj.data = data;
            obj.undo_data = Data.Base('undo_data');
        end
        
        function setUndoData(in_indices,in_data,out_indices,out_data)
            obj.undo_data.addData('in.indices' ,in_indices);
            obj.undo_data.addData('in.data'    ,in_data);
            obj.undo_data.addData('out.indices',out_indices);
            obj.undo_data.addData('out.data'   ,out_data);
        end
        
        function setUndoFunction(obj,fcn)
            obj.undo_fcn = fcn;
        end
    end
    
    methods(Access = 'protected')
        function  executeTodo(obj)
            obj.reciever.addData(obj.indices,obj.data);
        end
        
        function undoTodo(obj)
            restored_data = obj.undo_fcn(obj.undo_data);
            obj.reciever.addData()
        end
    end
    
    properties(Access = 'protected')
        indices;
        data;
        undo_data;
        undo_fcn;
    end
end