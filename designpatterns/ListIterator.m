classdef ListIterator < Iterator
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
    % Date: 2014-10-01 10:03:01
    % Packaged: 2017-04-27 17:57:58
    properties(Access = 'protected')
        list;
        index;
    end
    
    methods
        function obj = ListIterator(list)
            obj.list = list;
            obj.first();
        end
        
        function first(obj)
            obj.index = 1;
        end
        
        function next(obj)
            obj.index = obj.index + 1;
        end
        
        function is_done = done(obj)
            is_done = obj.index > obj.list.count();
        end
        
        function current_entry = current(obj)
            if obj.nevoke_current < obj.max_evoke;
                current_entry = obj.list.at(obj.index);
            else
                obj.nevoke_current = obj.nevoke_current + 1;
            end
        end
    end
end