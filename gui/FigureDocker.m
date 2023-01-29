classdef FigureDocker < handle
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
    % Date: 2016-09-18 00:36:15
    % Packaged: 2017-04-27 17:58:22
    properties(SetAccess = 'protected')
        children;
        counter = 0;
    end
    
    methods
        function obj = FigureDocker()
        end
        
        function addFigure(obj,figure_handle)
            if isempty(obj.handle2index(figure_handle))
                set(figure_handle,'CloseRequestFcn',@obj.closeFigures);
                set(figure_handle,'SizeChangedFcn',@obj.resizeFigures);
                warning off MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
                jFig = get(figure_handle, 'JavaFrame');
                jAxis = jFig.getAxisComponent;
                set(jAxis.getComponent(0),'FocusGainedCallback',@obj.focusFigures);
%                 set(jAxis.getComponent(0),'ComponentMovedCallback',@obj.resizeFigures);
                set(jFig.getAxisComponent)
                set(jAxis,'ComponentMovedCallback',@obj.resizeFigures);
                obj.children = cat(1,obj.children,figure_handle);
            end
        end
        
        function removeFigure(obj,figure_handle)
            i = obj.handle2index(figure_handle);
            if ~isempty(i)
                obj.children(i) = i;
            end
        end
        
        function closeFigures(obj,h,evdata)
            delete(obj.children)
            obj.children = [];
        end
        
        function i = handle2index(obj,figure_handle)
            i = find(figure_handle == obj.children);
        end
    end
    
    methods(Access = 'protected')
        function resizeFigures(obj,h,evdata)
            h
            evdata
            get(h,'Position')
            obj.counter = obj.counter + 1
        end
        
        function focusFigures(obj,h,evdata)
            for f = obj.children
                set(0,'CurrentFigure',f);
            end
            disp focus
        end
    end
end