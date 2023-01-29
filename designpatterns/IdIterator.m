classdef IdIterator < Iterator
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
    % Date: 2016-01-29 13:14:35
    % Packaged: 2017-04-27 17:57:58
    properties
        is_creator = false;
    end
    
    properties(SetAccess = 'protected')
        ids = {};
        length = 0;
        current_index = 0;
        current_id = '';
        id_object;
    end
    
    methods
        function obj = IdIterator(id_object,id_collector,is_creator)
            obj.id_object = id_object;
            obj.ids = id_collector.collect(obj.id_object);
            obj.length = length(obj.ids);
            if nargin > 2
                obj.is_creator = is_creator;
            end
            obj.first();
        end
        
        function first(obj)
            obj.current_index = 1;
            if obj.length > 0
                obj.current_id = obj.ids{1};
                if ~iscell(obj.current_id)
                        obj.current_id = {obj.current_id};
                end
            end
        end
        
        function next(obj)
            obj.current_index = obj.current_index + 1;
            if ~obj.done()
                obj.current_id = obj.ids{obj.current_index};
                if ~iscell(obj.current_id)
                    obj.current_id = {obj.current_id};
                end
            end
            obj.nevoke_current = 0;
        end
        
        function is_done = done(obj)
            is_done = obj.current_index > obj.length;
        end
        
        function current_item = current(obj)
            current_item = obj.id_object;
            n = numel(obj.current_id);
            for i = 1:n
                if obj.is_creator
                    if ~current_item.hasEntry(obj.current_id{i})
                        if i == n
                            current_item.add(IdItem(obj.current_id{i}));
                        else
                            current_item.add(IdList(obj.current_id{i}));
                        end
                    end
                end
                current_item = current_item.entry(obj.current_id{i});
            end
            if obj.nevoke_current > obj.max_evoke
                error('IdIterator.current(): Max number of evoking current() was reached.');
            else
                obj.nevoke_current = obj.nevoke_current + 1;
            end
        end
    end
end