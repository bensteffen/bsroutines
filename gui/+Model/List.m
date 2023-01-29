classdef List < Model.Abstract & IdList
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
    % Date: 2017-04-26 17:31:05
    % Packaged: 2017-04-27 17:58:28
    properties(SetAccess = 'protected')
        controller;
    end
    
    methods
        function obj = List(id)
            obj@IdList(id);
        end
        
        function setController(obj,controller)
            if isa(controller,'Controller')
                obj.controller = controller;
                for m = Iter(obj)
                    obj.controller.subscribeModel(m);
                end
            end
        end
        
        function appendModel(obj,model)
            obj.add(model);
            obj.appendToDo(model);
            if ~isempty(obj.controller)
                obj.controller.subscribeModel(model);
            end
            obj.notifyObservers();
        end
        
        function removeModel(obj,id)
            obj.remove(id);
            obj.controller.unsubscribeModel(id);
            obj.notifyObservers();
        end
        
        function loadModels(obj,fname)
            load(fname);
            for memento = Iter(model_list)
                constructor = eval(sprintf('@(varargin)%s(varargin{:});',memento.class));
                m = constructor(memento.id,memento.constructor_input{:});
                m.setWholeState(memento.state);
                obj.appendModel(m);
            end
            obj.notifyObservers();
        end
        
        function saveModels(obj,fname)
            model_list = List();
            for m = Iter(obj)
                m.id
                memento = m.createMemento();
                model_list.append(memento);
            end
            save(fname,'model_list');
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            obj.createListOutput();
            for m = Iter(obj)
                m.createOutput();
            end
        end
        
        function createListOutput(obj)
            
        end
        
        function appendToDo(obj,m)
        end
    end
end