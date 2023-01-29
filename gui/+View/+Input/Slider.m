classdef Slider < View.Input.AbstractItem
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
    % Date: 2017-02-23 16:56:47
    % Packaged: 2017-04-27 17:58:34
    methods
        function obj = Slider(id,model,input_name,varargin)
            obj@View.Input.AbstractItem(id,model,input_name,varargin{:});
        end
        
        function update(obj)
            set(obj.valueh,'Value',obj.inputValue());
        end
    end
    
    methods(Access = 'protected')        
        function valueCallback(obj,h,evdata)
            val = get(obj.valueh,'Value');
            obj.sendCommand(Command.SetInput(obj,obj.models.lastEntry(),obj.input_name,val,true));
        end
        
        function modifyUi(obj)
            set(obj.valueh,'Style','Slider');
        end
        
        function updateUiElements(obj)
        end
    end
end