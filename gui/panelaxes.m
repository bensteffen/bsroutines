classdef panelaxes < HandleInterface
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
    % Date: 2017-03-14 13:47:16
    % Packaged: 2017-04-27 17:58:26
    properties(SetAccess = 'protected')
        axh;
    end
    
    methods 
        function obj = panelaxes(varargin)
            obj.h = uipanel('BorderType','none','BackgroundColor','w','SizeChangedFcn',@obj.sizeChange);
            obj.axh = axes();
            set(obj.axh,'Parent',obj.h,'LineWidth',2,'Box','on','NextPlot','add','Units','pixels');
            if ~isempty(varargin)
                set(obj.axh,varargin{:});
            end
        end
        
        function sizeChange(obj,varargin)
            p = getpixelposition(obj.h);
            h = -10;
            if ~isempty(get(get(obj.axh,'XLabel'),'String'))
                h = 0;
            end
            set(obj.axh,'OuterPosition',[-30 h p(3:4)+30]);
        end
    end
end