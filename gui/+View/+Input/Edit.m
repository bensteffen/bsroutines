classdef Edit < View.Input.AbstractItem
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
    % Date: 2017-03-07 15:51:25
    % Packaged: 2017-04-27 17:58:33
    methods
        function obj = Edit(id,model,input_name,varargin)
            obj@View.Input.AbstractItem(id,model,input_name,varargin{:});
        end
        
        function update(obj)
            set(obj.valueh,'String',stringify(obj.inputValue()));
        end
    end
    
    methods(Access = 'protected')        
        function valueCallback(obj,h,evdata)
            val = obj.convert(get(obj.valueh,'String'));
            obj.sendCommand(Command.SetInput(obj,obj.models.lastEntry(),obj.input_name,val,obj.getProperty('instant_update')));
        end
        
        function modifyUi(obj)
            set(obj.valueh,'Style','edit' ...
                          ,'String','' ...
                          ,'FontName','FixedWidth' ...
                          ... ,'FontName',get(0,'FixedWidthFontName') ...
                          );
        end
        
        function updateUiElements(obj)
        end
    end
    
    methods(Access = 'protected',Static = true)
        function val = convert(str)
            eval(sprintf('val = %s;',str));
        end
    end
end