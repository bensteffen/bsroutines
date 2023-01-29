classdef IndexIterator < Iterator
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
    % Date: 2017-01-30 13:42:41
    % Packaged: 2017-04-27 17:57:58
    properties(SetAccess = 'protected')
        current_index;
        max_index;
        iteration_data;
    end
    
    methods
        function obj = IndexIterator(data)
            if nargin > 0
                obj.setIterationData(data);
            end
        end
        
        function setIterationData(obj,data)
            obj.iteration_data = data;
            obj.max_index = numel(data);
            obj.first();
        end
        
        function first(obj)
            obj.current_index = 1;
        end
        
        function next(obj)
            obj.current_index = obj.current_index + 1;
        end
        
        function is_done = done(obj)
            is_done = obj.current_index > obj.max_index;
            if is_done
                obj.first;
            end
        end
    end
    
    methods(Abstract = true)
        current_item = current(obj);
    end
end