classdef AbstractOptions < View.Input.AbstractItem
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
    % Date: 2017-02-23 16:44:04
    % Packaged: 2017-04-27 17:58:33
    properties(SetAccess = 'protected')
        options;
    end
    
    methods
        function update(obj)
            obj.options = obj.getOptions();
            set(obj.valueh,'String',nonunicfun(@stringify,obj.options));
            set(obj.valueh,'Value',obj.value2index());
        end
    end
    
    methods(Access = 'protected')
        function obj = AbstractOptions(varargin)
            obj@View.Input.AbstractItem(varargin{:});
        end
        
        function modifyUi(obj)
            set(obj.valueh,'Style','popupmenu');
        end
        
        function valueCallback(obj,varargin)
            i = get(obj.valueh,'Value');
            obj.sendCommand(Command.SetInput(obj,obj.models.lastEntry(),obj.input_name,obj.options{i},true));
        end
        
        function i = value2index(obj)
            i = find(cellfun(@(x) isequal(obj.inputValue(),x),obj.options));
        end
        
        function updateUiElements(obj)
        end
    end
    
    methods(Access = 'protected',Abstract = true)
        options = getOptions(obj);
    end
end