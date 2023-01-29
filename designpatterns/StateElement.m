classdef StateElement < matlab.mixin.Copyable
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
    % Date: 2017-03-02 16:14:03
    % Packaged: 2017-04-27 17:57:59
    properties(SetAccess = 'protected')
        state_name;
        state_value;
        unset_value;
        was_set = false;
        changed = false;
    end
    
    methods
        function setUnset(obj)
            obj.changed = obj.was_set;
            obj.state_value = obj.unset_value;
            obj.was_set = false;
        end
        
        function resetChanged(obj)
            obj.changed = false;
        end
    end
    
    methods(Access = 'protected')
        function obj = StateElement(state_name,unset_value)
            obj.state_name = state_name;
            if nargin > 1
                obj.unset_value = unset_value;
            end
        end
    end
    
    methods(Abstract = true)
        setValue(obj,value);
        value = getValue(obj);
        show(obj);
    end
end