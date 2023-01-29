classdef EditInput < View.Item
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
    % Date: 2014-10-05 12:40:34
    % Packaged: 2017-04-27 17:58:22
    properties(Access = 'protected')
        input_name;
        display_name;
        edith;
        labelh;
    end
    
    methods
        function obj = EditInput(id,model_name,input_name,display_name)
            obj@View.Item(id,controller);
            obj.Models.add(Model.Empty(model_name));
            obj.input_name = input_name;
            if nargin < 4
                display_name = input_name;
            end
            obj.display_name = display_name;
            
            obj.h = uipanel('Units','normalized','BorderType','none');
            obj.edith = uicontrol(obj.h,'Style','edit','String','','Units','normalized','Position',[0.5 0 0.5 1],'Callback',@editCallback);
            obj.labelh = uicontrol(obj.h,'Style','PushButton','String',sprintf('%s =',obj.display_name),'Units','normalized','Position',[0 0 0.5 1],'Callback',@resetCallback);
            obj.update();
            function editCallback(h,evdata)
                obj.sendCommand(Command.SetInput(obj,obj.models.last(),obj.name,eval(stringify(get(obj.edith,'String'))),true));
            end
            function resetCallback(h,evdata)
%                 obj.sendCommand(Command.ResetInput(obj,obj.model,obj.name));
            end
        end
        
        function update(obj)
            set(obj.edith,'String',stringify(obj.models.last().getState(obj.name)));
        end
    end
end