classdef List < handle
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
    % Date: 2017-01-31 16:33:03
    % Packaged: 2017-04-27 17:57:58
    properties(Access = 'protected')
        data = {};
    end
    
    methods
        function obj = List(varargin)
            obj.append(varargin{:});
        end
        
        function c = count(obj)
            c = length(obj.data);
        end
        
        function n = numel(obj)
            n = obj.count();
        end
        
        function append(obj,varargin)
            obj.data = [obj.data; varargin'];
        end
        
        function overwrite(obj,entry)
            i = obj.indexof(entry);
            if i > 0
                obj.add(i,entry);
            else
                obj.append(entry);
            end
        end
        
        function add(obj,index,entry)
            obj.data{index} = entry;
        end
        
        function remove(obj,index)
            obj.data(index) = [];
        end
        
        function entry = at(obj,index)
            entry = obj.data{index};
        end
        
        function entry = first(obj)
            entry = obj.data{1};
        end
        
        function entry = last(obj)
            entry = obj.data{obj.count()};
        end
        
        function i = iter(obj)
            i = obj.data;
        end
        
        function l = toCell(obj)
            l = obj.data;
        end
        
        function i = indexof(obj,entry)
            i = 0;
            f = cellfun(@(x) isequal(x,entry),obj.data);
            if any(f)
                i = find(f);
            end
        end
    end
end