classdef GuiMatrix < View.Composite
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
    % Date: 2015-11-26 14:18:32
    % Packaged: 2017-04-27 17:58:30
    properties(SetAccess = 'protected')
        gui_matrix;
        panel_matrix;
    end
    
    methods
        function obj = GuiMatrix(id)
            obj@View.Composite(id);
        end
        
        function addElement(obj,i,j,element)
            panel = uipanel('Units','normalized','BorderType','none','Parent',obj.h);
            set(element,'Parent',panel);
            obj.gui_matrix(i,j) = element;
            obj.panel_matrix(i,j) = panel;
            obj.updatePanels();
        end
        
        function update(obj)
            
        end
    end
    
    methods(Access = 'protected') 
        function createOutput(obj)
            elements = obj.getState('elements');
            plot_elements = {};
            for id = Iter(elements)
                ij = str2num(id);
                element = elements.entry(id);
                if ischar(element)
                    element = uicontrol('Style','text','Visible','off','String',element);
                end
                plot_elements{ij(1),ij(2)} = element;
            end
            obj.setOutput('plot_elements',plot_el);
        end
        
        function updatePanels(obj)
            obj.panel_matrix(obj.panel_matrix(:) == 0) = uipanel('Units','normalized','BorderType','none','Parent',obj.h);
            [li,lj] = size(obj.panel_matrix);
            [dx,dy] = deal(1/li,1/lj);
            for i = 1:li
                for j = 1:lj
                    set(obj.panel_matrix(i,j),'Position',[(j-1)*dx (li-i)*dy dx dy]);
                end
            end
        end
    end
end