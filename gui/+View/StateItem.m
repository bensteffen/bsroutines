classdef StateItem < View.Input.AbstractItem
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
    % Date: 2017-04-26 15:24:34
    % Packaged: 2017-04-27 17:58:32
    methods
        function obj = StateItem(id,model,state_name,varargin)
            obj@View.Input.AbstractItem(id,model,state_name)
            
            obj.addProperty(Input.Function('state2string',@(x) stringify(x)));
            obj.setProperties(varargin{:});
        end
        
        function update(obj)
            state2string = obj.getProperty('state2string');
            str = state2string(obj.inputValue());
            set(obj.valueh,'String',str);
%             obj.valuetxt.setCaption();
%             set(obj.jvalueh,'Editable',false);
        end
    end
    
    methods(Access = 'protected')        
        function valueCallback(obj,h,evdata)

        end
        
        function modifyUi(obj)
            set(obj.labelh,'Callback','');
            set(obj.valueh,'Style','edit','Enable','off','String','');
        end
    end
    
%     properties(Access = 'protected')
%         valuetxt;
%     end
end