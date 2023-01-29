classdef PlotElement < Model.Item
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
    % Date: 2017-02-23 13:57:50
    % Packaged: 2017-04-27 17:58:28
    methods
        function obj = PlotElement(id,varargin)
            obj@Model.Item(id);
            
            obj.addInput(Input.ElementItem('xdata',[],[],Input.Test(@(x) isnumeric(x),'YData must be numeric')));
            obj.addInput(Input.ElementItem('ydata',[],[],Input.Test(@(x) isnumeric(x),'YData must be numeric')));
            obj.addInput(Input.ElementItem('mark_data',[],EventOnsets(1),Input.Test(@(x) isa(x,'EventOnsets'),'Mark data must be of type EventOnsets')));
            
            obj.addInput(Input.ElementItem('filter',[],@(x) x,Input.Test(@(x) isfunction(x),'Filter must be a function handle')));
            
            obj.addInput(Input.ElementItem('roi',[],'all',Input.Test(@(x) strcmp(x,'all') || isnumeric(x) ,'ROI must be numeric or ''all''')));
            obj.addInput(Input.ElementItem('exclude',[],[],Input.Test(@(x) isnumeric(x) ,'X exclude must be numeric')));
            
            obj.addInput(Input.Boolean('visible',true));
            
            obj.setDefault();
            obj.addOutput(Output.ElementItem('display_ydata',[]));
            obj.addOutput(Output.ElementItem('y_selection',[]));
            
            for i = 1:2:numel(varargin)
                obj.setInput(varargin{i},varargin{i+1});
            end
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            [x,y] = deal(obj.getState('xdata'),obj.getState('ydata'));
            f = obj.getState('filter');
            obj.setOutput('display_ydata',f(y));
            if numel(x) ~= size(y,1)
                x = 1:size(obj.getState('ydata'),1);
            end
            obj.setInput('xdata',x(:));
            
            roi = obj.getState('roi');
            if strcmp(roi,'all')
                roi = 1:size(y,2);
            else
                roi = sort(roi(:))';
                roi = roi(withinrange(roi,[1 size(y,2)]));
            end
            obj.setOutput('y_selection',exclude(roi,obj.getState('exclude')));
        end
    end
end