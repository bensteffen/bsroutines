classdef UiText < Ui
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
    % Date: 2017-04-26 15:21:03
    % Packaged: 2017-04-27 17:58:25
    properties(SetAccess = 'protected')
        caption;
        txth;
        parent;
    end
    
    properties
        options = containers.Map({'HorizontalAlignment'},{'center'});
    end
    
    methods 
        function obj = UiText(parent,caption,varargin)
            if nargin < 1
                parent = gco;
            end
            if nargin < 2
                caption = '';
            end
            obj.parent = parent;
            obj.caption = caption;
            obj.options = cell2map([map2cell(obj.options) varargin]);
        end
        
        function updateText(obj)
            set(obj.txth,'String',obj.caption);
            keys = obj.options.keys;
            if any(strcmp(keys,'HorizontalAlignment'))
                x = containers.Map({'right','left','center'},{0.9 -0.9 0});
                set(obj.txth,'Position',[x(obj.options('HorizontalAlignment')) 0 0]);
            end
            for k = Iter(keys)
                set(obj.txth,k,obj.options(k));
            end
        end
        
        function setCaption(obj,caption)
            if ischar(caption)
                obj.caption = caption;
                obj.updateText();
            else
                error('UiText.setCaption: Caption must be string');
            end
        end
    end
    
    methods(Access = 'protected')
        function initShow(obj)
            obj.h = axes('Parent',obj.parent,'Visible','off','Clipping','off','NextPlot','add','XLim',[-1 1],'YLim',[-1 1]);
        end
        
        function builtUi(obj)
            obj.txth = text('Parent',obj.h);
            obj.updateText();
        end
        
        function updateUi(obj)
            obj.updateText();
        end
    end
end