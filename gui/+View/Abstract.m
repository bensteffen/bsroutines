classdef Abstract < handle
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
    % Date: 2017-03-15 12:02:39
    % Packaged: 2017-04-27 17:58:29
    properties(SetAccess = 'protected')
        controller;
        models;
    end
    
    methods
        function subscribe(obj,controller)
            controller.views.add(obj);
            obj.controller = controller;
            obj.subscribeToDo();
        end
        
        function unsubscribe(obj)
            if ~isempty(obj.controller)
                obj.unsubscribeToDo();
                obj.controller.views.remove(obj.id);
                obj.controller = [];
            end
        end
        
%         function delete(obj)
%             if ~isempty(obj.controller)
%                 obj.controller.unsubscribeView(obj.id);
%             end
%             for m = Iter(obj.models)
%                 m.removeObserver(obj.id);
%             end
%         end
    end
    
    methods(Access = 'protected')
        function obj = Abstract()
            obj.models = IdList();
        end
        
        function sendCommand(obj,command)
            if ~isempty(obj.controller)
                obj.controller.recieveCommand(command);
            else
                error('View.Abstract.sendCommand: This view is not subscribed to a controller.')
            end
        end
        
        function connectToModels(obj)
            model_names = obj.models.ids();
            for m = Iter(obj.controller.model_list)
                if any(strcmp(m.id,model_names))
                    obj.models.add(m);
                    m.addObserver(obj);
                end
            end
        end
        
        function disconnectFromModels(obj)
            for m = Iter(obj.models)
                m.removeObserver(obj);
            end
        end
        
        function subscribeToDo(obj)
            obj.connectToModels();
        end
        
        function unsubscribeToDo(obj)
            obj.disconnectFromModels();
        end
    end
    
    methods(Abstract = true)
        update(obj);
    end
end