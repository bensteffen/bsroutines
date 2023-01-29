classdef AbstractItem < View.Input.Abstract & View.UiItem
    
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
    % Date: 2017-04-11 18:14:19
    % Packaged: 2017-04-27 17:58:32
    methods(Access = 'protected')
        function obj = AbstractItem(id,model,input_name,varargin)
            obj@View.UiItem(id);
            obj@View.Input.Abstract(model,input_name);
            obj.models.add(model);
            
            obj.addProperty(Input.Options('style',{1,2,0}));
            obj.addProperty(Input.String('display_name',defaultDisplayName(input_name)));
            obj.addProperty(Input.Boolean('instant_update',true));
            obj.setProperties(varargin{:});
        end
        
        function builtUi(obj)
            obj.valueh = uicontrol(obj.h,'Units','normalized','Callback',@obj.valueCallback);
            obj.createAlginment();
            obj.modifyUi();
        end
        
        function createAlginment(obj)
            switch obj.getProperty('style')
                case {1,2}
                    obj.labelh = uicontrol(obj.h,'Style','PushButton','String',obj.getProperty('display_name'),'Units','normalized','Callback',@obj.resetCallback);
                    obj.alg = GuiAlignment(obj.getProperty('style'),obj.h);
                    obj.alg.add(obj.labelh);
                    obj.alg.add(obj.valueh);
                    obj.alg.realign([0.382 0.618]);
                case 0
                    set(obj.valueh,'Parent',obj.h,'Position',[0 0 1 1]);
            end
        end
        
        function resetCallback(obj,h,evdata)
            obj.sendCommand(Command.ResetInput(obj.input_name,obj,obj.model));
        end
    end
    
    methods(Access = 'protected',Abstract = true)
        valueCallback(obj,h,evdata);
        modifyUi(obj);
    end
end