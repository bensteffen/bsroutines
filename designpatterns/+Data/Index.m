classdef Index
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
    % Date: 2017-02-27 15:23:34
    % Packaged: 2017-04-27 17:58:01
    properties
        field_separator;
    end
    
    properties(SetAccess = 'protected')
        value;
        length;
    end
    
    methods
        function obj = Index(varargin)
            obj.field_separator = '.';
            obj.value = {};
            obj.length = 0;
            obj = obj.setIndex(varargin{:});
        end
        
        function obj = setIndex(obj,varargin)
            obj.value = obj.parseIndex(varargin{:});
            obj.length = numel(obj.value);
        end
        
        function i = asString(obj)
            i = strjoin(obj.value,obj.field_separator);
        end
        
        function i = asCell(obj)
            i = obj.value;
        end
        
        function flag = valid(varargin)
            flag = all(cellfun(@isvarname,Key.asCell(varargin{:})));
        end
        
        function obj = goUp(obj)
            if obj.length > 1
                obj = obj.setIndex(obj.value{1:end-1});
            end
        end
        
        function n = numel(obj)
            n = obj.length();
        end
    end
    
    methods(Access = 'protected')
        function i = parseIndex(obj,varargin)
            i = {};
            for v = Iter(varargin)
                if isempty(v)
                    k = {};
                elseif ischar(v)
                    k = strsplit(v,obj.field_separator);
                elseif iscell(v)
                    k = v;
                    k(cellfun(@isempty,k)) = [];
                    k = obj.parseIndex(k{:});
                elseif isa(v,'Data.Index')
                    k = v.asCell();
                else
                    error('DataIndex: Invalid index format.');
                end
                i = [i k];
            end
        end
    end
end