%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 31-Jan-2012 18:30:58


classdef TagMatrix
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
    % Date: 2014-07-03 15:59:59
    % Packaged: 2017-04-27 17:58:45
    properties
        dim_;
        dim_names_;
        tags_;
        disk_tags_;
        tmp_buffer_dir_;
        save_data_;
        size_;
        data_;
        numel_;
        id_tab_;
    end
    
    methods
        function obj = TagMatrix(tags)
            if nargin < 1
                tags = {};
            end
            obj = obj.setDimension(tags);
        end
        
        function obj = setDimension(obj,dim_tags)
            if iscellstr(dim_tags)
                obj.dim_ = length(dim_tags);
                obj.dim_names_ = dim_tags;
                obj.tags_ = cell(1,length(dim_tags));
                for i = 1:obj.dim_
                    obj.tags_{i} = cell(1,0);
                end
                obj.disk_tags_ = {};
                obj.tmp_buffer_dir_ = '';
                obj.save_data_.path_ = '';
                obj.save_data_.objname_ = '';
                obj.data_ = {};
                obj.size_ = zeros(1,obj.dim_);
                obj.numel_ = 0;
                obj.id_tab_ = zeros(0,obj.dim_ + 2);
            else
                error('TagMatrix.setDimension: Dimension name list must be a cell string!');
            end
        end
        
        function delete(obj)
            if isdir(obj.tmp_buffer_dir_)
                disp('delete files')
                rmdir(obj.tmp_buffer_dir_,'s');
            end
        end
        
        function clear(obj)
            obj.delete();
        end        
        
        function obj = setHarddiskBuffering(obj,tags)
            if isempty(obj.disk_tags_)
                obj.tmp_buffer_dir_ = obj.createTempDir();
                makeDir(obj.tmp_buffer_dir_);
            end
            obj.disk_tags_(size(obj.disk_tags_,1)+1,:) = tags;
        end
        
        function s = size(obj)
            s = obj.size_;
        end
        
        function n = numel(obj)
            n = obj.numel_;
        end
        
        function id = getId(obj,tags)
            if iscell(tags) && isvector(tags) && length(tags) == obj.dim_
                id = obj.findId(tags);
            else
                error(['TagMatrix.getId: Tag must be a one dimensional cell with length = ' num2str(obj.dim_) '.']);
            end
        end
        
%         function val = subsref(obj,s)
%             if ~any(strcmp(s.subs,':'))
%                 val = obj.get(s.subs);
%             else
%                 val = obj.extract(s.subs);
%             end
%         end
%         
%         function obj = subsasgn(obj,s,val)
%             obj = obj.add(s.subs,val);
%         end
        
        function obj = add(obj, tags, data)
            if iscell(tags) && length(tags) == obj.dim_
                id = obj.findId(tags);
                if isempty(id)
                    [obj,id] = obj.createId(tags);
                end
                obj = obj.addData(id,data);
            else
                tags
                error(['TagMatrix.add: Tags must be a cell with length = ' num2str(obj.dim_) ' .']);
            end
        end
        
        function data = get(obj, tags)
            id = obj.getId(tags);
            if ~isempty(id)
                data = obj.getData(id);
            else
                error('TagMatrix.get: No data found for tags %s!',stringify(tags));
            end
        end
        
        function data = at(obj, id)
            if any(obj.id_tab_(:,1) == id)
                data = obj.getData(id);
            else
                error(['TagMatrix.at: Id = ' num2str(id) ' not found.']);
            end
        end
        
        function obj = remove(obj,tags)
            id = obj.getId(tags);
            if ~isempty(id)
                obj = obj.removeData(id);
            else
                tags
                error('TagMatrix.remove: No data found!')
            end
        end
        
        function ex_data = extract(obj,tags)
            ex_dim = find(strcmp(tags,':'));
            ex_dimn = length(ex_dim);
            ex_dim_names = obj.dim_names_(ex_dim);
            remain_tags = cell(1,obj.dim_);
            for d = 1:obj.dim_
                if d ~= ex_dim
                    t_index = obj.findCellEntry(obj.tags_{d},tags{d});
                    if ~isempty(t_index)
                        remain_tags{d} = obj.tags_{d}{t_index};
                    else
                        tags{d}
                        error(['TagMatrix.extract: Tag not found.']);
                    end
                end
            end

            ex_data = TagMatrix();
            ex_data = ex_data.setDimension(ex_dim_names);
            ex_size = obj.size_(ex_dim);
            
            ex_number = prod(ex_size);
            curr_ex_tags = cell(1,ex_dimn);
            for i = 1:ex_number
                tag_voxel = index2voxel(i,ex_size);
                curr_tags = remain_tags;
                for j = 1:ex_dimn
                    curr_tag = obj.tags_{ex_dim(j)}{tag_voxel(j)};
                    curr_tags{ex_dim(j)} = curr_tag;
                    curr_ex_tags{j} = curr_tag;
                end
                id = obj.findId(curr_tags);
                if ~isempty(id)
                    ex_data = ex_data.add(curr_ex_tags,obj.getData(id));
                end
            end
        end
        
        function dim_names = dimensionNames(obj,columns)
            dim_names = obj.dim_names_;
            if nargin == 2
                dim_names = dim_names(columns);
            end
        end
        
        function tags_out = tags(obj,dim)
            if nargin > 1
                if ischar(dim)
                    dim = obj.findCellEntry(obj.dim_names_,dim);
                end
                tags_out = obj.tags_{dim};
            else
                if obj.dim_ > 1
                    tags_out = obj.tags_;
                else
                    tags_out = obj.tags_{1};
                end
            end
        end
        
        function s = toStruct(obj)
            s = struct;
            fstr = 's';
            for d = 1:obj.dim_
                fstr = [fstr '.(''''%s'''')'];
            end
            for id = 1:obj.numel_
                vx = obj.id_tab_(id,3:3+obj.dim_-1);
                tags = cell(1,obj.dim_);
                for d = 1:obj.dim_
                    tag = obj.tags{d}{vx(d)};
                    if ischar(tag)
                        tags{d} = tag;
                    else
                        error('TagMatrix.toStruct: All tags must be strings');
                    end
                end
                eval(['eval_str = sprintf(''' fstr '''' cell2str(tags,''',''') ''');']);
                eval_str = [eval_str ' = obj.getData(id);'];
                eval(eval_str);
            end
        end
        
        function data = toCell(obj)
            data = cell(obj.numel_,1);
            for i = 1:obj.numel_
                data{i} = obj.getData(obj.id_tab_(i,1));
            end
        end
        
        function array = toArray(obj,dim_flag)
            if nargin < 2
                dim_flag = 'row_wise';
            end
            array = obj.toCell();
            array = cell2num(array,dim_flag);
        end
        
        function save(obj,fname,matrix_name)
            if nargin < 3
                matrix_name = inputname(1);
            end
            obj.save_data_.objname_ = matrix_name;
            [p,n,e] = fileparts(fname);
            if strcmp(e,'.zip')
                matex = '';
            else
                matex = '.zip';
            end
            makeDir(p);
            spath = fullfile(fulldir(n), [n e matex]);
            if isempty(obj.tmp_buffer_dir_)
                tmp_dir = obj.createTempDir();
                makeDir(tmp_dir);
            else
                tmp_dir = obj.tmp_buffer_dir_;
            end
            fprintf('Saving data base "%s" to "%s"...',matrix_name,spath);
            obj.save_data_.path_ = spath;
            obj.save_data_.objname_ = matrix_name;
            eval([matrix_name '= obj;' ]);
            verinfo = ver('MATLAB');
            if str2double(verinfo.Version) >= 7.3
                save([tmp_dir matrix_name '.mat'],matrix_name,'-v7.3');
            else
                save([tmp_dir matrix_name '.mat'],matrix_name);
            end
            zip(spath,[tmp_dir filesep '*.mat']);
            delete([tmp_dir matrix_name '.mat']);
            fprintf(' Done!\n');
        end
    end
    
    methods(Static = true)
        function load(fname)
            fprintf('Loading data base "%s"...',fname);
            load_dir = TagMatrix.createTempDir();
            unzip(fname,load_dir);
            
            files = getNameList(load_dir,'','','.mat');
            for i = 1:length(files)
                file_info = whos('-file',files{i});
                if strcmp(file_info.class,'TagMatrix')
                    break;
                end                
            end
            
            Tname = file_info.name;
            fprintf(' workspace name is "%s"...',Tname);
            T = load(files{i},Tname);
            delete(files{i});
            T = getfield(T,Tname); 
            if isempty(T.disk_tags_)
                rmdir(load_dir);
            else
                T.tmp_buffer_dir_ = load_dir;
            end

            assignin('base',Tname,T);
            fprintf(' Done!\n');
        end
        
%         function tag_matrix = fromStruct(s,dim_names)
%             tag_matrix = TagMatrix(dim_names);
%             evel_str = 's';
%             
%             field_names = fieldnames(s);
%             n = length(field_names);
%             field_data = cell(n,length(dim_names));
%             field_data{:,1} = field_names;
%             for i = 1:n
%                 field_data{i,2} = fieldnames(s.(field_names{i}));
%             end
%         end
    end
    
    methods(Access = 'private')
        
        function obj = addData(obj,id,data)
            data_index = obj.id_tab_(id,2);
            if data_index > 0
                obj.data_{data_index} = data;
            else
                save([obj.tmp_buffer_dir_ num2str(-data_index) '.mat'],'data');
            end
        end
        
        function data = getData(obj,id)
            data_index = obj.id_tab_(id,2);
            if data_index > 0
                data = obj.data_{data_index};
            else
                load([obj.tmp_buffer_dir_ num2str(-data_index) '.mat']);
            end
        end        
        
        function id = findId(obj,tags)
            voxel = zeros(1,obj.dim_);
            for d = 1:obj.dim_
                tag_cell = obj.tags_{d};
                I = obj.findCellEntry(tag_cell,tags{d});
                if isempty(I)
                    voxel(d) = 0;
                else
                    voxel(d) = I;
                end
            end
            t = ones(obj.numel_,1);
            for d = 1:obj.dim_
                t = t & (obj.id_tab_(:,d+2) == voxel(d));
            end
            id = find(t,1);          
        end
        
        function [obj id] = createId(obj,tags)
            voxel = zeros(1,obj.dim_);
            for d = 1:obj.dim_
                I = obj.findCellEntry(obj.tags_{d},tags{d});
                if isempty(I)
                    obj.tags_{d} = obj.appendToCell(obj.tags_{d},tags{d});
                    voxel(d) = length(obj.tags_{d});
                else
                    voxel(d) = I;
                end
            end
            t = ones(obj.numel_,1);
            for d = 1:obj.dim_
                t = t & (obj.id_tab_(:,d+2) == voxel(d));
            end
            I = find(t,1);
            if isempty(I)
                obj.numel_ = size(obj.id_tab_,1) + 1;
                id = obj.numel_;
                obj.id_tab_(id,1) = id;
                if obj.isBufferTag(tags)
                    index_sign = -1;
                else
                    index_sign = 1;
                end
                data_indices = obj.getDataIndices(index_sign);
                if isempty(data_indices)
                    data_index = index_sign;
                else
                    data_index = index_sign*(max(data_indices) + 1);
                end
                obj.id_tab_(id,2) = data_index;
                obj.id_tab_(id,3:end) = voxel;
            else
                id = I;
            end
            obj = obj.updateSize();
        end
        
        function obj = removeData(obj,id)
            data_index = obj.id_tab_(id,2);
            index_sign = sign(data_index);
            data_index = index_sign*data_index;
            [data_indices data_ids] = obj.getDataIndices(index_sign);
            
            higher_indices_pos = data_indices > data_index;
            higher_indices = data_indices(higher_indices_pos) - 1;
            higher_ids = data_ids(higher_indices_pos);
            obj.id_tab_(higher_ids,2) = index_sign*higher_indices;
            
            obj.id_tab_(id,:) = [];
            obj.id_tab_(id:end,1) = obj.id_tab_(id:end,1) - 1;
            obj.numel_ = size(obj.id_tab_,1);
            
            if index_sign > 0
                obj.data_(data_index) = [];
            else
                delete([obj.tmp_buffer_dir_ num2str(data_index) '.mat']);
                for i = data_index:max(higher_indices)
                    java.io.File([obj.tmp_buffer_dir_ num2str(i+1) '.mat']).renameTo(java.io.File([obj.tmp_buffer_dir_ num2str(i) '.mat']));
                end
            end
            
            for d = 1:obj.dim_
                tag_index = sort(unique(obj.id_tab_(:,d+2)));
                old_tags = obj.tags_{d};
                new_tags = obj.tags_{d}(tag_index);
                if ~isequal(old_tags,new_tags)
                    new_tag_index = (1:length(new_tags))';
                    for i = 1:length(new_tags)
                        obj.id_tab_(obj.id_tab_(:,d+2) == tag_index(i),d+2) = new_tag_index(i);
                    end
                    obj.tags_{d} = new_tags;
                end
            end
            obj = obj.updateSize();            
        end
        
        function obj = updateSize(obj)
            for d = 1:obj.dim_
                obj.size_(d) = length(obj.tags_{d});
            end
        end
        
        function flag = isBufferTag(obj,tags)
            if ~isempty(obj.disk_tags_)
                flag = false;
                for b = 1:size(obj.disk_tags_,1)
                    is_buffer_tag = false(1,obj.dim_);
                    for d = 1:obj.dim_
                        is_buffer_tag(d) = isequal(obj.disk_tags_{b,d},tags{d});
                    end
                    is_buffer_tag(strcmp(obj.disk_tags_(b,:),':')) = true;
                    flag = flag | isequal(is_buffer_tag,true(1,obj.dim_));
                end
            else
                flag = false;
            end
        end
        
        function [data_indices data_ids] = getDataIndices(obj,index_sign)
            pos = index_sign*obj.id_tab_(:,2) > 0;
            data_ids = obj.id_tab_(pos,1);
            data_indices = index_sign*obj.id_tab_(pos,2);
        end
        
    end
    methods(Access = 'protected', Static = true) 
        function index = findCellEntry(C,entry)
            index = [];
            for i = 1:length(C)
                if isequal(C{i},entry)
                    index = i;
                    break;
                end
            end
        end
        
        function c = appendToCell(c,v)
            l = length(c);
            if l == 1
                c{l + 1,1} = v;
            else
                c{l + 1} = v;
            end
        end
        
        function temp_dir = createTempDir()
            [tmpd tmpn] = fileparts(tempname);
            temp_dir = [tmpd filesep 'matlab_tagmatrix' filesep tmpn filesep];
        end
    end
end