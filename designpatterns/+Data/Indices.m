classdef Indices < List & PropertyObject
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
    % Date: 2017-04-04 17:04:04
    % Packaged: 2017-04-27 17:58:01
    methods
        function obj = Indices(index_cell)
            if nargin < 1
                index_cell = {};
            end
            if iscellstr(index_cell)
                for l = 1:size(index_cell,1)
                    obj.addIndex(index_cell(l,:));
                end 
            else
                for i = Iter(index_cell)
                    obj.addIndex(i);
                end 
            end
            
            obj.addProperty(Input.Options('selection_type',{'regexp','wildcard'}));
        end
        
        function indices = select(obj,varargin)
            if nargin == 2
                switch class(varargin{1})
                    case 'Data.Indices'
                        indices = varargin{1};
                        return;
                    case 'Data.Index'
                        varargin = varargin{1}.asCell;
                end
            end
            if strcmp(obj.getProperty('selection_type'),'wildcard')
                varargin = regexptranslate('wildcard',varargin);
                varargin = nonunicfun(@(x) sprintf('^%s$',x),varargin);
            end
            tab = obj.asTable();
            hit = true(size(tab,1),1);
            n = min(length(varargin),size(tab,2));
            for j = 1:n
                hit = hit & regexpfind(tab(:,j),varargin{j},'hits');
            end
            indices = Data.Indices(tab(hit,:));
        end

        function addIndex(obj,varargin)
            obj.append(Data.Index(varargin{:}));
        end
        
        function simple_list = simplify(obj)
            tab = obj.asTable();
            if size(tab,1) < 2
                simple_list = obj;
            else
                all_equal = false(1,size(tab,2));
                for j = 1:size(tab,2)
                    all_equal(j) = length(unique(tab(:,j))) == 1;
                end
                simple_list = Data.Indices(tab(:,~all_equal));
            end
        end
        
        function tab = asTable(obj)
            ml = max(cellfun(@(x) x.length,obj.data));
            tab = cell(obj.count(),ml);
            tab(:) = {''};
            it = Iter(obj);
            for i = it
                tab(it.i,1:i.length) = i.asCell();
            end
        end
        
        function l = asCellList(obj)
            l = cell(obj.count(),1);
            it = Iter(obj);
            for i = it
                l{it.i} = i.asCell();
            end
        end
        
        function l = asStringList(obj)
            l = cell(obj.count(),1);
            it = Iter(obj);
            for i = it
                l{it.i} = i.asString();
            end
        end
    end
end