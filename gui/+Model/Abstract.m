classdef Abstract < State & IdItemSubject & StatusReporter
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
    % Date: 2017-04-26 15:30:46
    % Packaged: 2017-04-27 17:58:27
    properties(SetAccess = 'protected')
        status;
        view_factory;
    end
    
    properties(Access = 'protected')
        constructor_input;
    end
    
    methods(Access = 'protected')
        function obj = Abstract(varargin)
            obj.view_factory = ViewFactory(obj);
            obj.setInput(varargin{:});
            obj.status = IdList();
            obj.constructor_input = {};
        end
        
        function setOutput(obj,name,value)
            obj.setState('output',name,value);
        end
        
        function memento_state = modifyMementoState(obj,memento_state)
            memento_state = memento_state;
        end
    end
    
    methods
        function varargout = setInput(obj,varargin)
            for i = 1:2:length(varargin)
                obj.setState('input',varargin{i},varargin{i+1});
            end
            obj.notifyObservers();
            if nargout > 0
                varargout{1} = obj;
            end
        end
        
        function addToInput(obj,input_name,name,value)
            obj.addToState('input',input_name,name,value);
            obj.notifyObservers();
        end
        
        function setDefault(obj,name,value)
            if nargin == 1
                for name = Iter(obj.state.entry('input').ids)
                    obj.setState('default',name);
                end
            elseif nargin == 2
                obj.setState('default',name);
            else
                obj.setState('default',name,value);
            end
            obj.notifyObservers();
        end
        
        function setUnset(obj,name)
            obj.setState('unset',name);
            obj.notifyObservers();
        end
        
        function sendSignal(obj,name,data)
            if nargin < 3
                data = [];
            end
            obj.setState('signal',name,data);
            obj.updateOutput();
            obj.deactivateSignals();
        end
        
        function updateOutput(obj)
            obj.createOutput();
            obj.notifyObservers();
            obj.resetChangeState();
        end
        
        function view = makeView(obj,id,varargin)
            view = obj.view_factory.makeModelView(id,varargin{:});
        end
        
        function view = makeInputView(obj,id,varargin)
            view = obj.view_factory.makeInputView(id,varargin{:});
        end
        
        function m = createMemento(obj)
            m.class = class(obj);
            m.id = obj.id;
            m.constructor_input = obj.constructor_input;
            s = obj.copyWholeState();
            s = obj.modifyMementoState(s);
            m.state = s;
        end
        
        function mcopy = copy(obj,copy_id)
            memento = obj.createMemento();
            constructor = eval(sprintf('@(varargin)%s(varargin{:});',memento.class));
            mcopy = constructor(copy_id,memento.constructor_input{:});
            mcopy.setWholeState(memento.state);
        end
    end
    
    methods(Access = 'protected',Abstract = true)
        createOutput(obj);
    end
end