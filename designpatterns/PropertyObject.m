classdef PropertyObject < handle
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
    % Date: 2017-03-02 11:40:19
    % Packaged: 2017-04-27 17:57:59
    properties(Access = 'protected')
        props;
        prop_set_todos;
    end
    
    methods
        function obj = PropertyObject()
            obj.props = IdList('props');
            obj.prop_set_todos = IdList('prop_todos');
        end
        
        function value = getProperty(obj,id)
            value = obj.props.entry(id).getValue();
        end
        
        function setProperty(obj,id,value)
            obj.props.entry(id).setValue(value);
            if obj.props.entry(id).was_set
                todo_fcnh = obj.prop_set_todos.entry(id).value;
                todo_fcnh(obj);
            end
        end
        
        function setProperties(obj,varargin)
            for i = 1:2:numel(varargin)
                obj.setProperty(varargin{i},varargin{i+1});
            end
        end
    end
    
    methods(Access = 'protected')        
        function addProperty(obj,input_element,todo_fcnh)
            if nargin < 3
                todo_fcnh = @(o,v) 0;
            end
            if ~input_element.was_set
                input_element.setDefault();
            end
            obj.props.add(input_element);
            obj.prop_set_todos.add(IdItem(input_element.id,todo_fcnh));
        end
    end
end