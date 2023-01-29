classdef GuiAlignment < HandleInterface
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
    % Date: 2016-04-07 10:39:03
    % Packaged: 2017-04-27 17:58:22
    properties(Access = 'protected')
        handles = {};
        direction = 1;
        parent;
    end
    
    methods
        function obj = GuiAlignment(direction,parent)
            if nargin > 1
                h = uipanel('Units','normalized','BorderType','none','Parent',parent,'Visible','on');
            else
                h = uipanel('Units','normalized','BorderType','none','Visible','off');
            end
            obj.parent;
            obj.h = h;
            obj.direction = direction;
        end
        
        function add(obj,element)
            set(element,'Parent',obj.h,'Units','normalized','Visible','on');
            pos = get(element,'Position');
            switch obj.direction 
                case 1
                    pos([2 4]) = [0 1];
                case 2
                    pos([1 3]) = [0 1];
            end
            set(element,'Position',pos);
            obj.handles = [obj.handles; {element}];
            obj.realign();
        end
        
        function remove(obj,element)
            i = cellfun(@(x) isequal(x,element),obj.handles);
            if any(i)
                delete(obj.handles{i})
                obj.handles(i) = [];
            end
            obj.realign();
        end
    
        function realign(obj,q)
            if nargin < 2
                q = repmat(1/length(obj.handles),[1 length(obj.handles)]);
            else
                q = q(:)';
                q = q/sum(q);
            end
            switch obj.direction
                case 1
                    s = [0 cumsum(q)];
                    s = s(1:end-1);
                case 2
                    s = 1 - cumsum(q);
            end
            for i = 1:length(obj.handles)
                pos = get(obj.handles{i},'Position');
                pos(obj.direction) = s(i);
                pos(obj.direction + 2) = q(i);
                set(obj.handles{i},'Position',pos);
            end
        end
    end
end