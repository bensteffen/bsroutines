classdef SelectableAxes < View.UiItem & Selectable
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
    % Date: 2017-02-06 19:21:55
    % Packaged: 2017-04-27 17:58:24
    properties(SetAccess = 'protected')
        axh;
    end
    
    methods
        function obj = SelectableAxes(id,varargin)
            obj@View.UiItem(id);
            obj@Selectable(id);
        end
        
        function update(obj)
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            obj.h = uipanel('BorderType','none','BackgroundColor','w');
            obj.axh = axes();
            set(obj.axh,'Parent',obj.h,'LineWidth',2,'Box','on','NextPlot','add')
        end
        
        function highlight(obj,flag,i)
        end
        
        function open(obj)
        end
    end
end