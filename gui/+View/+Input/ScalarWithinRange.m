classdef ScalarWithinRange < View.Input.AbstractComposite
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
    % Date: 2017-03-22 11:26:24
    % Packaged: 2017-04-27 17:58:34
    properties(SetAccess = 'protected')

    end

    methods
        function obj = ScalarWithinRange(id,model,input_name,varargin)
            obj@View.Input.AbstractComposite(id,model,input_name,varargin{:});
        end
    end
    
    methods(Access = 'protected')
        function valueCallback(obj,h,evdata)
%             switch h
%                 case obj.slider
%                     v = get(h,'Value');
%             end
%             obj.updateUi();
%             obj.sendCommand(Command.SetInput(obj,obj.models.lastEntry(),obj.input_name,v,true));
%             disp valueCallback
%             obj.update();
        end
        
        function composeUi(obj)
            edit = View.Input.Edit([obj.id '.edit'],obj.model,obj.input_name,'style',0);
            obj.add(edit);
            edit.show();
            
            slider = View.Input.Slider([obj.id '.slider'],obj.model,obj.input_name,'style',0);
            obj.add(slider);
            slider.show();
            
            obj.value_alg.add(slider.h);
            obj.value_alg.add(edit.h);
        end
        
        function updateUiElements(obj)

        end
    end
end