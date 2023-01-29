classdef LineView < Selectable
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
    % Date: 2014-11-07 18:17:47
    % Packaged: 2017-04-27 17:58:23
    properties(Access = 'protected')
        line_width = 1;
    end
    
    methods
        function obj = LineView(parent,line_id,xy)
            obj@Selectable(line_id);
            obj.h = line('XData',xy(:,1),'YData',xy(:,2),'Parent',parent,'ButtonDownFcn',@obj.selectionCallback);
        end
        
        function highlight(obj,flag)
            if flag
                obj.line_width = 3;
            else
                obj.line_width = 1;
            end
            obj.set('LineWidth',obj.line_width);
        end
        
        function open(obj)
        end
    end
end