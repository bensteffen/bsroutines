classdef SetInput < Command.Abstract
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
    % Date: 2017-03-14 17:55:44
    % Packaged: 2017-04-27 17:58:00
    properties(Access = 'protected')
        name;
        value;
        update_output;
    end
    
    methods 
        function obj = SetInput(invoker,reciever,name,value,update_output)
            obj@Command.Abstract(invoker,reciever)
            obj.name = name;
            obj.value = value;
            if nargin > 4
                obj.update_output = update_output;
            else
                obj.update_output = false;
            end
        end
    end
       
    methods(Access = 'protected')
        function executeTodo(obj)
            obj.origin_state = obj.reciever.getState(obj.name);
            obj.reciever.setInput(obj.name,obj.value);
            if obj.update_output
                obj.reciever.updateOutput();
            end
        end
        
        function undoTodo(obj)
            obj.value = obj.origin_state;
            obj.execute();
        end
    end
end