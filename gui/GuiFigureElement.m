classdef GuiFigureElement < View.UiItem & PropertyObject
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
    % Date: 2017-02-26 00:31:02
    % Packaged: 2017-04-27 17:58:22
    properties(SetAccess = 'protected')
        is_foreground;
    end
    
    properties(Access = 'protected')
        guifigure;
    end
    
    methods
        function obj = GuiFigureElement(id,guifig)
            if nargin < 2
                guifig = GuiFigure();
            end
            obj@View.UiItem(id);
            obj.is_foreground = false;
            obj.setGuiFigure(guifig);
        end
        
        function setGuiFigure(obj,guifig)
            obj.guifigure = guifig;
%             set(obj.h,'parent',guifig.h);
            obj.models.add(Model.Empty('figure_events'));
            obj.guifigure.subscribeView(obj);
        end
        
        function setForeground(obj,flag)
            obj.is_foreground = flag;
        end
    end
    
    methods(Access = 'protected')
        function initShow(obj)
            obj.h = uipanel('Units','normalized','BorderType','none','ButtonDownFcn',@obj.buttonDownCallback);
            obj.buttonDownCallback(obj.h);
        end
        
        function buttonDownCallback(obj,h,varargin)
            obj.models.entry('figure_events').updateOrder(h);
        end
    end
end