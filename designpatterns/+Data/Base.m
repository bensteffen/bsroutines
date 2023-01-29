classdef Base < Model.Item
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
    % Date: 2017-03-20 16:48:00
    % Packaged: 2017-04-27 17:58:01
    properties(SetAccess = 'protected')
        root;
        changed;
    end
    
    methods
        function obj = Base(id,root)
            if nargin < 2
                root = struct;
            end
            if nargin < 1
                id = 'database';
            end
            obj@Model.Item(id);
            obj.root = root;
            obj.changed = true;
            [obj.collected_ids,obj.parent_ids] = deal({});
        end
        
        function addData(obj,varargin)
            if numel(varargin) == 2 && isa(varargin{1},'Data.Indices') && iscell(varargin{2}) && numel(varargin{1}) == numel(varargin{2})
                it = Iter(varargin{1});
                data = varargin{2};
                for i = it
                    obj.assign(i,data{it.i});
                end
            else
                obj.assign(Data.Index(varargin{1:end-1}),varargin{end});
            end
        end
        
        function appendData(obj,varargin)
            index = Data.Index(varargin{1:end-2});
            if obj.hasData(index)
                obj.addData(index,cat(varargin{end-1},obj.getData(index),varargin{end}));
            else
                obj.addData(index,cat(varargin{end-1},[],varargin{end}));
            end
        end
        
        function data = getData(obj,varargin)
            if numel(varargin) == 1 && isa(varargin{1},'Data.Indices')
                it = Iter(varargin{1});
                data = cell(it.n,1);
                for i = it
                    data{it.i} = obj.fetch(i);
                end
            else
                data = obj.fetch(Data.Index(varargin{:}));
            end
        end
        
        function removeData(obj,varargin)
            if numel(varargin) == 1 && isa(varargin{1},'Data.Indices')
                for i = Iter(varargin{1})
                    obj.remove(i);
                end
            else
                obj.remove(Data.Index(varargin{:}));
            end
        end
        
        function i = indices(obj)
            if obj.changed
                obj.collected_ids = {};
                obj.collectIds(obj.root);
                obj.changed = false;
            end
            i = Data.Indices(obj.collected_ids);
        end
        
        function varargout = iter(obj,varargin)
            if nargin < 2
                varargin = {'.'};
            end
            varargout = {};
            for i = Iter(varargin)
                curr_selection = ifel(iscell(i),i,{i});
                it = Iter(obj.indices.select(curr_selection{:}));
                varargout = cat(2,varargout,{it});
            end
        end
        
        function subdb = extract(obj,varargin)
            subdb = Data.Base();
            i0 = obj.indices.select(varargin{:});
            i1 = i0.simplify();
            it = Iter(i0);
            for i = it
                subdb.addData(i1.at(it.i),obj.getData(i));
            end
        end
        
        function flag = hasData(obj,index)
            if isa(index,'Data.Indices')
                flag = false(index.count(),1);
                it = Iter(index);
                for i = it
                    flag(it.i) = hasfield(obj.root,i);
                end
            else
                flag = hasfield(obj.root,index);
            end
        end
        
        function a = toArray(obj,dim,varargin)
            if nargin < 2
                dim = 1;
            end
            a = [];
            for i = Iter(obj.indices.select(varargin{:}))
                a = cat(dim,a,obj.getData(i));
            end
        end
        
        function toFile(obj,fname)
            if nargin < 2
                fname = [obj.id '.txt'];
            end
            s = '';
            for i = Iter(obj.indices)
                s = [s i.asString '\n' mx2str(obj.getData(i)) '\n'];
            end
            fid = fopen(fname,'w');
            fprintf(fid,s);
            fclose(fid);
        end
        
        function apply(obj,fcn,input_index_list,output_index_suffix)
            for i = Iter(input_index_list)
                if nargin < 4
                    c = i.asCell();
                    output_index_suffix = c{end};
                end
                o = Data.Index(i.goUp(),output_index_suffix);
                obj.addData(o,fcn(obj.getData(i)));
            end
        end
        
%                 function varargout = subsref(obj,s)
% %                     varargout = cell(nargout,1);
%                     switch s(1).type
%                         case '.'
%                             if any(strcmp(s(1).subs,properties(obj))) || any(strcmp(s(1).subs,methods(obj)))
%                                 nargout
%                                 varargout = cell(nargout,1);
%                                 [varargout{:}] = builtin('subsref',obj,s);
%                             else
%                                 keys = squeeze(struct2cell(s(1:end)));
%                                 varargout{1} = obj.fetch(Data.Index(keys(2,:)));
%                             end
%                         case '()'
%                             varargout{1} = obj.fetch(Data.Index(s(1).subs));
%                         otherwise
%                             varargout = builtin('subsref',obj,s);
%                     end
%                 end
    end
    
    properties(Access = 'protected')
        collected_ids;
        parent_ids;
    end
    
    methods(Access = 'protected')
        function createOutput(obj)

        end
        
        function assign(obj,index,data)
            i = Data.Index(index).asCell();
            if all(cellfun(@isvarname,i))
                eval(sprintf('obj.root.(''%s'') = data;',cell2str(i,''').(''')));
            end
            obj.changed = true;
        end
        
        function data = fetch(obj,index)
            if hasfield(obj.root,index)
                eval(sprintf('data = obj.root.(''%s'');',cell2str(Data.Index(index).asCell(),''').(''')));
            else
                error('DataBase.fetch: No data for index "%s" found',index.asString());
            end
        end
        
        function remove(obj,index)
            if hasfield(obj.root,index)
                index = index.asCell();
                sstr = sprintf('obj.root.(''%s'')',cell2str(index(1:end-1),''').('''));
                eval(sprintf('%s = rmfield(%s,''%s'');',sstr,sstr,index{end}));
                obj.changed = true;
            else
                error('DataBase.remove: No data for index "%s" found',index.asString());
            end
        end
        
%         function data = fetchrec(obj,db,index)
%             if isa(index,'Data.Index')
%                 index = index.asCell();
%             end
%             if isa(db,'Data.Base')
%                 db = db.root;
%                 obj.fetchrec(db,index);
%             elseif isstruct(db)
%                 if any(strcmp(index{1},fieldnames(db)))
%                     db = db.(index{1});
%                     if isstruct(db) && length(index) > 1
%                         data = obj.fetchrec(db,index(2:end));
%                     else
%                         data = db;
%                     end
%                 else
%                     error('DataBase.fetchrec(): No data found for %s',strjoin(index,'.'));
%                 end
%             else
%                 error('DataBase.fetchrec(): db must be a Data.Base or a struct');
%             end
%         end
        
        function collectIds(obj,s)
            for f = Iter(fieldnames(s))
                if isstruct(s.(f));
                    obj.parent_ids = [obj.parent_ids {f}];
                    obj.collectIds(s.(f));
                else
                    obj.collected_ids = [obj.collected_ids; {[obj.parent_ids {f}]}];
                end
            end
            obj.parent_ids = obj.parent_ids(1:end-1);
        end
    end
end