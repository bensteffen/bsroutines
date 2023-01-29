classdef AbstractMapSelection < View.Input.AbstractComposite
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
    % Date: 2017-03-08 11:12:36
    % Packaged: 2017-04-27 17:58:32
    properties(Access = 'protected')
        map;
        popup;
        other_value;
    end
    
    methods        
        function update(obj)
            obj.map = obj.getMap();
            v = obj.inputValue();
            if isempty(obj.other_value)
                obj.other_value = v;
            end
            i = cellfun(@(x) isequal(v,x),obj.map.values);
            if any(i)
                set(obj.popup,'Value',find(i)+1);
            else
                obj.other_value = v;
                set(obj.popup,'Value',1);
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = AbstractMapSelection(varargin)
            obj@View.Input.AbstractComposite(varargin{:});
        end
        
        function composeUi(obj)
            edit = View.Input.Edit([obj.id '.edit'],obj.model,obj.input_name,'style',0);
            obj.add(edit);
            edit.show();
            
            obj.popup = uicontrol('Style','popupmenu','Callback',@obj.valueCallback);
            
            obj.value_alg.add(obj.popup);
            obj.value_alg.add(edit.h);
        end
        
        function valueCallback(obj,h,evdata)
            i = get(obj.popup,'Value');
            s = get(obj.popup,'String');
            if strcmp(s{i},'<other>')
                v = obj.other_value;
            else
                v = obj.map(s{i});
            end
            obj.sendCommand(Command.SetInput(obj,obj.model,obj.input_name,v,true));
        end
        
        function updateUiElements(obj)
            set(obj.popup,'String',[{'<other>'} obj.map.keys],'Value',2);
        end
    end
    
    methods(Access = 'protected',Abstract = true)
        map = getMap(obj);
    end
end