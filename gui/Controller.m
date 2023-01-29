classdef Controller < handle
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
    % Date: 2017-04-18 18:11:04
    % Packaged: 2017-04-27 17:58:22
    properties(SetAccess = 'protected')
        model_list;
        views;
        command_history = List();
    end
    
    methods
        function obj = Controller()
            obj.model_list = IdList();
            obj.model_list.add(Model.Status('main_status'));
            obj.model_list.add(Model.Selection());
            obj.views = IdList();
        end
        
        function recieveCommand(obj,command)
            obj.command_history.append(command);
%             try
                command.execute();
%             catch exc
%                 disp('error while executing command');
%                 throw(exc)
%             end
%             if command.error_occured
%                 disp('error while executing command');
%                 obj.models.entry('error_model').setInput('failed_command',command);
%                 throw(command.execute_exc)
%             end
        end
        
        function subscribeModel(obj,model)
            if isa(model,'Model.List')
                for m = Iter(model)
                    obj.addModel(m);
                end
                obj.addModel(model);
                model.setController(obj);
            else
                obj.addModel(model);
            end
        end
        
        function subscribeView(obj,view)
%             if isa(view,'View.Composite')
%                 for v = Iter(view)
%                     v.subscribe(obj);
%                 end
%             end
            view.subscribe(obj);
            if isa(view,'Selectable')
                view.setSelectionModel(obj.model_list.entry('selection'));
                obj.model_list.entry('selection').addSelectable(view);
            end
        end
        
        function unsubscribeView(obj,view)
            if isa(view,'View.Abstract')
                id = view.id;
            else
                id = view;
            end
            if obj.views.hasEntry(id)
                obj.views.entry(id).unsubscribe();
            end
        end
        
        function unsubscribeModel(obj,id)
            model = obj.model_list.entry(id);
            if isa(model,'View.Abstract')
                obj.unsubscribeView(id);
            end
            obj.model_list.remove(id);
        end
        
        
    end
    
    methods(Access = 'protected')
        function addModel(obj,model)
            if isa(model,'View.Abstract')
                obj.subscribeView(model);
            end
            model.addStatus(obj.model_list.entry('main_status'));
            obj.model_list.add(model);
        end
    end
end