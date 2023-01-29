classdef SelectionStringCreator
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
    % Date: 2017-02-16 16:49:47
    % Packaged: 2017-04-27 17:58:25
    properties(SetAccess = 'protected')
        selectable;
        selected_strcell;
    end
    
    methods
        function obj = SelectionStringCreator(selectable)
            if nargin > 0
                obj.setSelectable(selectable);
            end
            obj.selected_strcell = {};
        end
        
        function obj = setSelectable(obj,selectable)
            obj.selectable = selectable;
        end
        
        function str = createString(obj,flag)
            if nargin < 2
                flag = true;
            end
            obj.selected_strcell = obj.createIdCell(flag);
            str = obj.compileString();
        end
    end
    
    methods(Access = 'protected')
        function c = createIdCell(obj,flag)
            c = {};
            if ~isempty(obj.selectable)
                c = createNames('%d',1:length(obj.selectable.selectable_handles));
                c = c(obj.selectable.is_selected == flag);
            end
        end
        
        function s = compileString(obj)
            switch numel(obj.selected_strcell)
                case 0
                    prefix = '';
                case 1
                    prefix = 'element ';
                otherwise
                    prefix = 'elements ';
            end
            s = [prefix strjoin(obj.selected_strcell,',')];
        end
    end
end