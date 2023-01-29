classdef State < handle
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
    % Date: 2017-03-15 18:22:00
    % Packaged: 2017-04-27 17:57:59
    properties(SetAccess = 'protected')
        state;
    end
    
    methods
        function obj = State
            obj.state = IdList();
            obj.state.add(IdList('input'));
            obj.state.add(IdList('output'));
            obj.state.add(IdList('signals'));
        end
        
        function showState(obj,name)
            for s = Iter(obj.state.entry(name))
                s.show();
            end
        end
        
        function flag = inputComplete(obj)
            flag = true;
            i = IdIterator(obj.in,AllTreeIdsCollector());
            while ~i.done()
                flag = flag && i.current().was_set;
                i.next();
            end
        end
        
        function value = getState(obj,name)
            value = obj.getStateItem(name).getValue();
        end
        
        function state1 = copyState(obj,type,varargin)
            state0 = obj.state.entry(type);
            names = ifel(nargin < 3,state0.ids,varargin);
            state1 = IdList(type);
            for n = Iter(names)
                state1.add(copy(state0.entry(n)));
            end
        end
        
        function state1 = copyWholeState(obj)
            state1 = IdList();
            for type = Iter({'input','output','signals'})
                state1.add(obj.copyState(type));
            end
        end
        
        function setWholeState(obj,state)
            if isa(state,'IdList') && all([state.hasEntry('input') state.hasEntry('output') state.hasEntry('signals')])
                obj.state = state;
            end
        end
        
        function value = getStateItem(obj,name)
            if obj.in.hasEntry(name)
                value = obj.in.entry(name);
            elseif obj.out.hasEntry(name)
                value = obj.out.entry(name);
            elseif obj.state.entry('signals').hasEntry(name)
                value = obj.state.entry('signals').entry(name);
            else
                throw(MException('State:getState',sprintf('No state "%s" found',name)));
            end
        end
        
        function value = getFromState(obj,state_name,name)
            if obj.in.hasEntry(state_name)
                value = obj.in.entry(state_name).getValue(name);
            elseif obj.out.hasEntry(state_name)
                value = obj.out.entry(state_name).getValue(name);
            else
                throw(MException('State:getState',sprintf('No state "%s" found',state_name)));
            end
        end
        
        function flag = stateOk(obj,name)
            if obj.in.hasEntry(name)
                flag = obj.in.entry(name).was_set;
            elseif obj.out.hasEntry(name)
                flag = obj.out.entry(name).was_set;
            else
                throw(MException('State:getState',sprintf('No state "%s" found',name)));
            end
        end
        
        function flag = isActive(obj,name)
            if obj.state.entry('signals').hasEntry(name)
                flag = obj.state.entry('signals').entry(name).isActive();
            else
                throw(MException('State:getState',sprintf('No state "%s" found',name)));
            end
        end
        
        function flag = stateChanged(obj,name)
            if obj.in.hasEntry(name)
                flag = obj.in.entry(name).changed;
            elseif obj.out.hasEntry(name)
                flag = obj.out.entry(name).changed;
            else
                throw(MException('State:getState',sprintf('No state "%s" found',name)));
            end
        end

        function flag = statesOkAndChanged(obj,varargin)
            ok_flag = true;
            changed_flag = false;
            for s = Iter(varargin)
                ok_flag = ok_flag && obj.stateOk(s);
                changed_flag = changed_flag || obj.stateChanged(s);
            end
            flag = ok_flag && changed_flag;
        end
        
        function resetChangeState(obj)
            i = IdIterator(obj.in,AllIdsCollector());
            while ~i.done()
                i.current().resetChanged();
                i.next();
            end
            i = IdIterator(obj.out,AllIdsCollector());
            while ~i.done()
                i.current().resetChanged();
                i.next();
            end
        end
        
        function deactivateSignals(obj)
            for signal = Iter(obj.state.entry('signals'))
                signal.deactivate();
            end
        end
    end
    
    methods(Access = 'protected')
        function setState(obj,type,name,value)
            switch type
                case 'output'
                    if obj.out.hasEntry(name)
                        obj.out.entry(name).setValue(value);
                    else
                        throw(MException('State:setState_output',sprintf('No output "%s" found',name)));
                    end
                case 'input'
                    if obj.in.hasEntry(name)
                        obj.in.entry(name).setValue(value);
                    else
                        throw(MException('State:setState_input',sprintf('No input "%s" found',name)));
                    end
                case 'default'     
                    if obj.in.hasEntry(name)
                        if nargin < 4
                            obj.in.entry(name).setDefault();
                        else
                            obj.in.entry(name).setDefault(value);
                        end
                    else
                        throw(MException('State:setState_default',sprintf('No input "%s" found',name)));
                    end
                case 'unset'
                    if obj.in.hasEntry(name)
                        obj.in.entry(name).setUnset();
                    elseif obj.out.hasEntry(name)
                        obj.out.entry(name).setUnset();
                    else
                        throw(MException('State:setState_unset',sprintf('No state "%s" found',name)));
                    end
                case 'signal'
                    if obj.state.entry('signals').hasEntry(name)
                        signal = obj.state.entry('signals').entry(name);
                        signal.activate();
                        signal.setData(value);
                    else
                        throw(MException('State:setState_signal',sprintf('No state "%s" found',name)));
                    end
            end
        end
        
        
        function addToState(obj,type,state_name,name,value)
            name = Iter(ifel(iscell(name),name,{name}));
            value = ifel(iscell(value),value,{value});
            switch type
                case 'input'
                    if obj.in.hasEntry(state_name)
                        for n = name
                            obj.in.entry(state_name).setValue(n,value{name.i});
                        end
                    else
                        throw(MException('State:addToState_input',sprintf('No input "%s" found',state_name)));
                    end
                case 'output'
                    if obj.out.hasEntry(state_name)
                        for n = name
                            obj.out.entry(state_name).setValue(n,value{name.i});
                        end
                    else
                        throw(MException('State:addToState_output',sprintf('No output "%s" found',state_name)));
                    end
            end
        end
        
        function addInput(obj,input_element,set_default)
            if nargin < 3
                set_default = false;
            end
            obj.in.add(input_element);
            if set_default
                input_element.setDefault();
            end
        end
        
        function addOutput(obj,output_element)
            obj.out.add(output_element);
        end
        
        function addSignal(obj,signal)
            obj.state.entry('signals').add(signal);
        end
        
        function i = in(obj)
            i = obj.state.entry('input');
        end
        
        function o = out(obj)
            o = obj.state.entry('output');
        end
    end
end