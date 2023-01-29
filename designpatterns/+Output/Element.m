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
    % Date: 2015-10-23 16:11:23
    % Packaged: 2017-04-27 17:58:02
    methods
        function obj = Element(state_name,unset_value)
            obj@StateElement(state_name,unset_value)
        end
        
        function setValue(obj,value)
            obj.changed = ~isequal(obj.state_value,value);
            obj.state_value = value;
            obj.was_set = true;
        end
        
        function value = getValue(obj)
            value = obj.state_value;
        end
        
        function show(obj)
            fprintf('%s = %s\n',obj.state_name,stringify(state_value));
        end
    end
end