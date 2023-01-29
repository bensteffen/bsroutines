classdef InputElement < handle
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
    % Date: 2014-09-29 17:39:43
    % Packaged: 2017-04-27 17:57:56
    properties
        value_test_handle = @(x) x;
    end
    
    properties(SetAccess = 'protected')
        was_set = false;
        default_value;
        fail_value;
        test_message = 'value not ok.';
    end
    
    properties(Access = 'protected')
        dependent_elements = DependentInput();
    end
    
    methods
        function setValue(obj,value)
            if obj.valueTest(value)
                obj.setDependentTests();
                if obj.hasParent()
                    obj.parent().dependentTest();
                end
                i = IdIterator(obj.dependent_elements,AllIdsCollector());
                while ~i.done()
                    element = i.current();
                    if element.was_set
                        if ~element.valueTest(element.value)
                            element.setUnset();
                        end
                    end
                    i.next();
                end
                
            else
                obj.was_set = false;
                obj.value = obj.fail_value;
                throw(MException('InputElement:setValue',obj.test_message));
            end
        end
        
        function setDefaultValue(obj,value)
            if obj.valueTest(value)
                obj.default = value;
            else
                throw(MException('AbstractInputElement.setDefaultValue:',obj.test_message));
            end
        end
        
        function setFailValue(obj,value)
            obj.fail_value = value;
        end
        
        function setUnset(obj)
            obj.was_set = false;
            obj.value = obj.fail_value;
        end
    end
    
    methods(Access = 'protected')
        function obj = AbstractInputElement(default_value,fail_value,value_test_handle,test_message)
            obj.default_value = default_value;
            obj.fail_value = fail_value;
            obj.value_test_handle = value_test_handle;
            obj.test_message = test_message;
        end
        
        function addDependent(element)
            obj.dependent_element.add(element);
        end
    end
    
    methods(Abstract = true)
        valueTest(obj);
        setDependentTests(obj);
    end
end