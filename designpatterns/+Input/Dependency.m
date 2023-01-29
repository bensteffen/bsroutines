classdef Dependency < handle    
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
    % Date: 2014-10-01 11:30:07
    % Packaged: 2017-04-27 17:58:02
    properties(SetAccess = 'protected')
        dependent_elements;
        value_test;
    end
    methods
        function obj = Dependency(value_test)
            obj.dependent_elements = List();
            obj.value_test = value_test;
        end
        
        function add(obj,element)
            element.setDependency(obj);
            obj.dependent_elements.append(element);
        end
        
        function flag = valueTest(obj,name,value)
            m = containers.Map;
            all_set = true;
            for i = 1:obj.dependent_elements.count()
                element = obj.dependent_elements.at(i);
                if strcmp(element.state_name,name)
                    m(name) = value;
                else
                    all_set = all_set & element.was_set;
                    m(element.state_name) = element.state_value;
                end
            end

            if all_set
                flag = obj.value_test.fcn(m);
            else
                flag = true;
            end
        end
    end
end