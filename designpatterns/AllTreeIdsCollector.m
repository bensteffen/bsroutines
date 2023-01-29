classdef AllTreeIdsCollector < IdCollector
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
    % Date: 2014-01-29 16:56:32
    % Packaged: 2017-04-27 17:57:56
    methods
        function ids = collect(obj,tree_branch)
            obj.collectIds(tree_branch);
            ids = obj.collected_ids;
        end
    end
    
    methods(Access = 'protected')
        function collectIds(obj,current_item)
            i = IdIterator(current_item,AllIdsCollector());
            while ~i.done();
                current_item = i.current();
                if current_item.hasBranch();
                    obj.parent_ids = [obj.parent_ids {current_item.id}];
                    obj.collectIds(current_item);
                else
                    obj.collected_ids = [obj.collected_ids; {[obj.parent_ids {current_item.id}]}];
                end
                i.next();
            end
            obj.parent_ids = obj.parent_ids(1:end-1);
        end
    end
    
    properties
        collected_ids = {};
        parent_ids = {};
    end
end