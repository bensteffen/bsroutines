classdef Element < StateElement
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
    % Date: 2017-03-02 13:22:11
    % Packaged: 2017-04-27 17:58:02
    properties
        value_test;
        children = List();
        parent_2ndarg = [];
        parent_value_test = Input.Test(@(x,parent_x) true,'No parent message');
    end

    properties(SetAccess = 'protected')
        default_value;
        test_message = '';
        dependency = Input.Dependency(Input.Test(@(x) true,'No input dependency message'));
        is_dependent = false;
    end

    methods
        function obj = Element(name,unset_value,default_value,value_test)
            obj@StateElement(name,unset_value);
            obj.setUnset();
            obj.default_value = default_value;
            obj.value_test = value_test;
        end
        
        function flag = valueTest(obj,value)
            if nargin < 2
                value = obj.state_value;
            end
            
            parent_test = obj.parent_value_test.fcn(value,obj.parent_2ndarg);
            self_test = obj.value_test.fcn(value);
            dep_test = obj.dependency.valueTest(obj.state_name,value);

            flag =  self_test && parent_test && dep_test;
            
            if ~self_test
                obj.test_message = obj.value_test.message;
            elseif ~parent_test
                obj.test_message = obj.parent_value_test.message;
            elseif ~dep_test
                obj.test_message = obj.dependency.value_test.message;
            else
                obj.test_message = 'value ok';
            end
        end
        
        function setValue(obj,value)
            if obj.valueTest(value)
                obj.changed = ~isequal(obj.state_value,value);
                obj.state_value = value;
                obj.was_set = true;
                i = ListIterator(obj.children);
                while ~i.done()
                    if ~i.current.valueTest()
                        i.current().setUnset();
                    end
                    i.next();
                end
            else
                obj.setUnset();
                throw(MException('InputElement:setValue',obj.test_message));
            end
        end
        
        function value = getValue(obj)
            value = obj.state_value;
        end
        
        function setDefault(obj,new_default)
            if nargin > 1
                obj.default_value = new_default;
            end
            obj.setValue(obj.default_value);
        end
        
        function setDependency(obj,dependency)
            if isa(dependency,'Input.Dependency')
                obj.dependency = dependency;
                obj.is_dependent = true;
            else
                MException('InputElement:setDependency','Dependency must be of type "InputDependency".');
            end
        end
        
        function addInput(obj,input_element,parent_value_test,parent_2ndarg)
            input_element.parent_value_test = parent_value_test;
            input_element.parent_2ndarg = parent_2ndarg;
            obj.children.append(input_element);
        end
        
        function show(obj)
            fprintf('%s = %s\n',obj.state_name,stringify(obj.state_value));
        end
    end
end