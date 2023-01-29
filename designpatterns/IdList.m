classdef IdList < AbstractIdItem
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
    % Date: 2017-03-15 16:52:39
    % Packaged: 2017-04-27 17:57:58
    methods
        function obj = IdList(id)
            if nargin < 1
                id = '';
            end
            obj@AbstractIdItem(id,cell(0,1));
        end
        
        function value = entry(obj,id)
            i = obj.id2index(id);
            if any(i)
                value = obj.value(i);
                value = value{1};
            else
                throw(MException('IdList:entry',sprintf('Could not find entry with id %s',stringify(id))));
            end
        end
        
        function value = valueOf(obj,id)
            if obj.hasEntry(id)
                value = obj.entry(id).value;
            else
                throw(MException('IdList:valueOf',sprintf('Could not find entry with id %s',stringify(id))));
            end
        end
        
        function entry = lastEntry(obj)
            if obj.length > 0
                id = obj.ids(obj.length());
                id = id{1};
                entry = obj.entry(id);
            else
                throw(MException('IdList:lastEntry','List is empty.'));
            end
        end
        
        function value = last(obj)
            last_id = obj.ids(obj.length());
            last_id = last_id{1};
            i = obj.id2index(last_id);
            value = obj.value{i}.value;
        end
        
        function flag = hasEntry(obj,id)
            if nargin < 2
                flag = obj.length() > 0;
            else
                flag = any(obj.id2index(id));
            end
        end
        
        function flag = hasBranch(obj)
            flag = any(cellfun(@(x) isa(x,'AbstractIdItem'),obj.value));
        end
        
        function add(obj,entry)
            i = obj.id2index(entry.id);
            if any(i)
                obj.value(i) = {entry};
            else
                obj.value = [obj.value; {entry}];
            end
            entry.setParent(obj);
            entry.setRoot(obj.root());
        end

        function remove(obj,id)
            obj.value(obj.id2index(id)) = [];
        end
        
        function apply(obj,function_handle)
            for i = 1:obj.length()
                function_handle(obj.value{i});
            end
        end
        
        function l = length(obj)
            l = length(obj.value);
        end
        
        function id_list = ids(obj,index)
            if nargin < 2
                index = 1:obj.length();
            end
            id_list = cell(obj.length(),1);
            for i = 1:length(id_list)
                id_list{i} = obj.value{i}.id;
            end
            id_list = id_list(index);
        end
        
        function i = iter(obj)
            i = obj.toCell();
        end
        
        function value_cell = toCell(obj,type)
%             value_cell = obj.value;
            if nargin < 2
                type = 'items';
            end
            switch type
                case 'items'
                    value_cell = obj.value;
                case 'values'
                    value_cell = nonunicfun(@(x) x.value,obj.value);
                otherwise
                    error('IdList.toCell: type must be "items" or "values"')
            end
        end
        
        function [value_array,id_cell] = toArray(obj)
            [value_array,id_cell] = obj.toCell();
            value_array = cell2num(value_array);
        end
        
        function move(obj,id,direction)
            i = obj.id2index(id);
            if any(i)
                i = find(i);
                if (direction == -1 && i == 1) || (direction == 1 && i == obj.length)
                    return;
                end
                obj.value([i+direction i]) = obj.value([i i+direction]);
            else
                throw(MException('IdList:valueOf',sprintf('Could not find entry with id %s',stringify(id))));
            end
        end
        
        function moveUp(obj,id)
            obj.move(id,-1);
        end
        
        function moveDown(obj,id)
            obj.move(id,1);
        end
    end
    
    methods(Access = 'protected')
        function index = id2index(obj,id)
            index = cellfun(@(x) isequal(x.id,id),obj.value);
        end
    end
end