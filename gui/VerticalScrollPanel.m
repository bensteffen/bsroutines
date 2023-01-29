classdef VerticalScrollPanel < ScrollPanel
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
    % Date: 2016-04-14 10:24:49
    % Packaged: 2017-04-27 17:58:25
    properties(SetAccess = 'protected')
        element_alg;
    end
    
    methods
        function obj = VerticalScrollPanel(id,parent)
            obj@ScrollPanel(id,parent);
            obj.element_alg = MatrixAlignment(obj.scroll_panel);
            set(obj.element_alg,'Parent',obj.scroll_panel);
            obj.setProperty('scroll_size',[-1 1]);
        end
        
        function addElement(obj,element)
            n = size(obj.element_alg.children,1);
            esize = round(getpixelposition(element));
            
            obj.element_alg.heights = [obj.element_alg.heights esize(4)];
            obj.element_alg.addElement(n+1,1,element);
            
%             obj.element_alg.heights(n+1) = esize(4);
%             obj.element_alg.realign();
            
            psize = getpixelposition(obj.element_alg.h);
            obj.setProperty('scroll_size',obj.getProperty('scroll_size')+[0 esize(4)]);
        end
    end
end