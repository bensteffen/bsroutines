classdef ScrollHoricontalAlignment < ScrollPanel
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
    % Date: 2017-03-08 16:56:38
    % Packaged: 2017-04-27 17:58:23
    methods
        function obj = ScrollHoricontalAlignment(id,guifig)
            obj@ScrollPanel(id,guifig);
            obj.setProperty('scroll_size',[-1 1]);
            obj.alg = MatrixAlignment(obj.scroll_panel);
        end
        
        function appendElement(obj,element,height)
            i = obj.alg.children_size(1);
            element.appendDeleteToDo(@(x) obj.removeElement(element));
            element.setProperty('height',height);
            obj.alg.addElement(i+1,1,element,[height 1]);
            obj.setProperty('scroll_size',[-1 round(obj.totalHeight)]);
        end
    end
    
    methods(Access = 'protected')
        function h = totalHeight(obj)
            h = 0;
            for child = Iter(obj.alg.children)
                if ishandle(child)
                    p = getpixelposition(child);
                    h = h + p(4);
                end
            end
        end
        
        function removeElement(obj,element,varargin)
            if ishandle(obj.h.h)
                obj.setProperty('scroll_size',[-1 obj.totalHeight-element.getProperty('height')]);
            end
        end
    end
    
    properties(Access = 'protected')
        alg;
        heights;
    end
end