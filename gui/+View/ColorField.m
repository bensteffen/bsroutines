classdef ColorField < View.Input.AbstractItem
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
    % Date: 2017-02-23 18:34:38
    % Packaged: 2017-04-27 17:58:29
    methods
        function obj = ColorField(id,model,input_name,varargin)
            obj@View.Input.AbstractItem(id,model,input_name,varargin{:});
        end
        
        function update(obj)
            if obj.model.stateOk(obj.input_name)
                set(obj.valueh,'BackgroundColor',obj.inputValue());
            end
        end
    end
    
    methods(Access = 'protected')        
        function valueCallback(obj,h,evdata)
            set(obj.valueh,'BackgroundColor',obj.inputValue());
        end
        
        function modifyUi(obj)
            if obj.model.stateOk(obj.input_name)
                set(obj.valueh,'BackgroundColor',obj.inputValue(),'String','');
            end
        end
        
        function updateUiElements(obj)
        end
    end
end