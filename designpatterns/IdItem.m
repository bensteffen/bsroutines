classdef IdItem < AbstractIdItem    
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
    % Date: 2017-01-30 18:18:36
    % Packaged: 2017-04-27 17:57:58
    methods
        function obj = IdItem(id,value)
            obj@AbstractIdItem(id);
            if nargin > 1
                obj.value = value;
            end
        end
        
        function value = entry(obj)
            value = obj;
        end
        
        function flag = hasEntry(obj,id)
            flag = false;
        end
        
        function flag = hasBranch(obj)
            flag = false;
        end
        
        function c = iter(obj)
            c = {obj};
        end
    end
end