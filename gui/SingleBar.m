classdef SingleBar < hgsetget
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
    % Date: 2013-07-22 13:36:39
    % Packaged: 2017-04-27 17:58:25
    properties
        Group;
        Condition;
        BarPatch;
    end
    
    methods 
        function obj = SingleBar(group,condition)
            obj.Group = group;
            obj.Condition = condition;
        end
        
        function set.Group(obj,group)
            if isnumeric(group) && isscalar(group) && group > 0
                obj.Group = group;
            else
                MException('SingleBar','Group must be a scalar > 0.');
            end
        end
        
        function set.Condition(obj,condition)
            if isnumeric(condition) && isscalar(condition) && condition > 0
                obj.Condition = condition;
            else
                MException('Gui:SingleBar','Condition must be a scalar > 0.');
            end
        end
        
        function paint(obj,axes_handle)
            patch(obj.BarPatch,'Parent',axes_handle);
        end
    end
end