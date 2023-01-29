classdef GuiFigure < View.UiComposite & Controller
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
    % Date: 2017-03-08 16:49:16
    % Packaged: 2017-04-27 17:58:22
    properties
        event;
    end
    
    properties(SetAccess = 'protected')
        figh;
    end
    
    methods
        function obj = GuiFigure(id,fig,varargin)
            if nargin < 2
                fig = plainfig();
            end
            if nargin < 1
                id = 'gui';
            end
%             obj@Model.Item(id);
            obj@View.UiComposite(id);
            set(fig,'Name',id ...
                   ...,'CloseRequestFcn',@obj.closeFigure ...
                   );
            obj.figh = fig;
            if ~isempty(varargin)
                set(obj.figh,varargin{:});
            end
            obj.subscribeModel(Model.FigureEvents(obj.figh));
            obj.model_list.entry('selection').setInput('figure',obj.figh);
        end
        
        function closeFigure(obj,varargin)
%             obj.closeToDo();
%             for id = Iter(obj.views.ids)
%                 obj.unsubscribeView(id);
%             end
%             delete(obj.figh);
        end
    end
    
    methods(Access = 'protected')
        function closeToDo(obj)
        end
    end
end