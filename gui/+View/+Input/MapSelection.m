classdef MapSelection < View.Input.Abstract
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
    % Date: 2017-02-23 16:02:49
    % Packaged: 2017-04-27 17:58:34
    properties(SetAccess = 'protected')
        map;
    end
    
    methods
        function obj = MapSelection(id,model,input_name,display_name,map)
            obj@View.Input.Abstract(id,model,input_name,display_name);
            obj.map = map;
            set(obj.valueh,'Style','popupmenu','String',[{'<other>'} obj.map.keys],'Value',2);
        end
        
        function update(obj)
            v = obj.inputValue();
            i = cellfun(@(x) isequal(v,x),obj.map.values);
            if any(i)
                set(obj.valueh,'Value',find(i)+1);
            else
                obj.map('<other>') = v;
                set(obj.valueh,'Value',1);
            end
        end
    end
    
    methods(Access = 'protected')
        function valueCallback(obj,h,evdata)
            i = get(obj.valueh,'Value');
            s = get(obj.valueh,'String');
            obj.sendCommand(Command.SetInput(obj,obj.models.entry(obj.model_name),obj.input_name,obj.map(s{i}),true));
        end
    end
end