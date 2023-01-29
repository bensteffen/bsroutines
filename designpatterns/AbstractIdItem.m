classdef AbstractIdItem < Id
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
    % Date: 2014-09-26 14:30:15
    % Packaged: 2017-04-27 17:57:56
    properties
        value;
    end
    
    properties(Access = 'protected')
        parent_handle;
        root_handle;
    end
    
    methods
        function flag = hasParent(obj)
            flag = ~isempty(obj.parent_handle);
        end
        
        function parent_handle = parent(obj)
            parent_handle = obj.parent_handle;
        end
        
        function root_handle = root(obj)
            root_handle = obj.root_handle;
        end
        
        function ids = ids2root(obj)
            ids = {};
            current_entry = obj;
            while current_entry.hasParent()
                current_entry = current_entry.parent();
                ids = [{current_entry.id} ids];
            end
            if all(cellfun(@isnumscalar,ids))
                ids = cell2num(ids);
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = AbstractIdItem(id,value)
            obj@Id(id);
            if nargin > 1
                obj.value = value;
            end
            obj.root_handle = obj;
        end
        
        function setParent(obj,parent_handle)
            obj.parent_handle = parent_handle;
        end
        
        function setRoot(obj,root_handle)
            obj.root_handle = root_handle;
        end
    end
        
    methods(Abstract = true)
        value = entry(obj);
        flag = hasEntry(obj,id);
        flag = hasBranch(obj);
    end
    
    methods(Access = 'protected',Abstract = true)
        
    end
end