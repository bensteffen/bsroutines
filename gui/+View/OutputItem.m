classdef OutputItem < View.Input.AbstractItem
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
    % Date: 2017-04-11 18:09:42
    % Packaged: 2017-04-27 17:58:31
    properties
        output2string;
    end
    
    methods
        function obj = OutputItem(varargin)
            obj@View.Input.AbstractItem(varargin{:})
            obj.output2string = @(x) stringify(x);
        end
        
        function update(obj)
            set(obj.valueh,'String',obj.output2string(obj.inputValue()));
        end
    end
    
    methods(Access = 'protected')        
        function valueCallback(obj,h,evdata)

        end
        
        function modifyUi(obj)
            set(obj.labelh,'Callback','');
            set(obj.valueh,'Style','text','String','');
        end
    end
end