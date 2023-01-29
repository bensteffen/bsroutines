classdef ElementList < StateElement & IdList
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
    % Date: 2015-10-23 16:08:11
    % Packaged: 2017-04-27 17:58:02
    properties(SetAccess = 'protected')
        dummy_input;
    end
    
    methods
        function obj = ElementList(name,dummy_input)
            obj@IdList(name);
            obj@StateElement(name,dummy_input);
            obj.dummy_input = dummy_input;
        end
        
        function setValue(obj,name,value)
            if obj.dummy_input.valueTest(value)
                if any(obj.id2index(name)) && isequal(obj.getValue(name),value)
                    this_changed = false;
                else
                    this_changed = true;
                end
                obj.changed = this_changed || obj.changed;
                obj.add(IdItem(name,value));
                obj.was_set = true;
            else
                throw(MException('InputElement:setValue',obj.dummy_input.test_message));
            end
        end
        
        function removeValue(obj,name)
            if any(obj.id2index(name))
                obj.remove(name);
                obj.changed = true;
                if obj.length() == 0
                    obj.was_set = false;
                end
            end
        end
        
        function value = getValue(obj,name)
            if nargin < 2
                value = obj;
            else
                value = obj.entry(name).value;
            end
        end
        
        function show(obj)
            for i = Iter(obj)
                i.show();
            end
        end
    end
end