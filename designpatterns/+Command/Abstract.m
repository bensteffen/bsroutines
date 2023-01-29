classdef Abstract< handle
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
    % Date: 2016-04-28 15:05:44
    % Packaged: 2017-04-27 17:57:59
    properties(Access = 'protected')
        invoker;
        reciever;
    end
    
    properties(SetAccess = 'protected')
        execute_exc;
        error_occured = false;
        origin_state;
    end
    
    methods
        function execute(obj)
%             try
                obj.executeTodo()
%             catch exc
%                 obj.error_occured = true;
%                 obj.execute_exc = exc;
%                 errordlg(exc.message);
% %                 throw(exc);
%             end
        end
        
        function undo(obj)
            obj.undoTodo();
        end
        
        function setInvoker(obj,invoker)
            obj.invoker = invoker;
        end
        
        function setReciever(obj,reciever)
            obj.reciever = reciever;
        end
    end
    
    methods(Access = 'protected')
        function obj = Abstract(invoker,reciever)
            if nargin > 0
                obj.setInvoker(invoker);
                obj.setReciever(reciever);
            end
        end
    end
    
    methods(Access = 'protected',Abstract = true)
        executeTodo(obj);
        undoTodo(obj);
    end
end