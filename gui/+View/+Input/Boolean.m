classdef Boolean < View.Input.AbstractItem
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
    % Date: 2017-02-23 16:56:19
    % Packaged: 2017-04-27 17:58:33
    methods
        function obj = Boolean(id,model,input_name,varargin)
            obj@View.Input.AbstractItem(id,model,input_name,varargin{:});
        end
        
        function update(obj)
            val = obj.inputValue();
            if isempty(val)
                val = 0;
            end
            set(obj.valueh,'Value',logical(val));
        end
    end
    
    methods(Access = 'protected')
        function valueCallback(obj,h,evdata)
            obj.sendCommand(Command.SetInput(obj,obj.model,obj.input_name,logical(get(obj.valueh,'Value')),true));
        end
        
        function modifyUi(obj)
            set(obj.valueh,'Style','check');
        end
        
        function updateUiElements(obj)
        end
    end
end