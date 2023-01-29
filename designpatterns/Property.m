classdef Property < IdItem    
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
    % Date: 2016-04-28 09:45:49
    % Packaged: 2017-04-27 17:57:58
    properties(SetAccess = 'protected')
        default;
        was_set = true;
    end
    
    properties(SetAccess = 'immutable')
        test = @(x) true;
        test_msg = 'Value not accepted';
        description = '';
    end
    
    methods
        function obj = Property(id,default,test,test_msg,description)
            obj@IdItem(id);
            if nargin > 2
                try
                    func2str(test);
                    obj.test = test;
                catch exc
                    throw(exc);
                end
            end
            if nargin > 3
                if ischar(test_msg)
                    obj.test_msg = test_msg;
                else
                    throw(MException('Property:Property','Test massage must be a string.'));
                end
            end
            if nargin > 1
                obj.valueTest(default);
                obj.default = default;
            end
            if nargin > 4
                if ischar(description)
                    obj.description = description;
                else
                    throw(MException('Property:Property','Description must be a string.'));
                end
            end
            obj.reset();
        end
        
        function value = getValue(obj)
            value = obj.value;
        end
        
        function setValue(obj,value)
            obj.valueTest(value);
            obj.value = value;
        end
        
        function reset(obj,new_default)
            if nargin > 1
                obj.default = new_default;
                obj.reset();
            end
            obj.setValue(obj.default);
        end
    end
    
    methods(Access = 'protected')
        function valueTest(obj,value)
            if ~obj.test(value)
                throw(MException('Property:valueTest','%s.',obj.test_msg));
            end
        end
    end
end