classdef NirsSubjectData < TagMatrix & NirsObject
    %
    % Stores data per subject. A unique numeric ID is assigned to each
    % subject. Data will be stored using a data name and the subject ID.
    % NirsSubjectData objects are able to read automaticly subject-wise
    % data from a given directory.
    %
    % Example:
    %
    % Assume we have files containing NIRS-data from an ETG-4000 system
    % in the directory "C:\nirsdata" with names
    %   VP05_Oxy.csv
    %   VP05_Deoxy.csv
    %   VP07_Oxy.csv
    %   VP07_Deoxy.csv
    %
    % To automatically the data use following code:
    %   S = NirsSubjectData();
    %   S = S.setProperty('read_directory','C:\nirsdata','subject_keyword','VP');
    %
    %   % read oxy-Hb data
    %   S = S.setProperty('read_type','etg4000');
    %   S = S.setProperty('file_name_filter',{'','_Oxy','.csv'});
    %   S = S.readSubjectData('oxy');
    %   % read trigger
    %   S = S.setProperty('read_type','etg4000_trigger');
    %   % note: the file name filter is not chagned, thus, the trigger
    %   % will be read from the oxy-files in this case.
    %   S = S.readSubjectData('trigger');
    %
    % To plot the trigger for subject 1 stored in subject data S
    % and count the events of condition 2:
    %   tr = S.getSubjectData(1,'trigger');
    %   figure; plot(tr);
    %   number_cond2 = length(find(tr == 2))
    %
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
    % Date: 2017-04-11 15:54:49
    % Packaged: 2017-04-27 17:58:44
    properties
        file_reader_;
    end
    
    methods 
        function obj = NirsSubjectData(varargin)
            obj = obj@NirsObject(varargin);
            obj = obj.setDimension({'numeric','string'});
            obj.file_reader_ = NirsReader();
        end
        
        function data = getSubjectData(obj, subject_number, data_name)
            %
            % Retrieve data from the data base.
            %
            % Usage:
            % x = S.getSubjectData(sid,dname) The data for subject ID sid
            % and the data with name dname will be assigned to x
            %
            if isscalar(subject_number) && ischar(data_name)
                data = obj.get({subject_number, data_name});
            else
                error('NirsSubject.getSubjectData: Subject number must be a scalar and data name must be a string');
            end
        end
        
        function obj = addSubjectData(obj, subject_number, data_name, data)
            if isscalar(subject_number) && ischar(data_name)
                    obj = obj.add({subject_number, data_name}, data);
            else
                error('NirsSubjectList.addSubjectData: Subject number must be a scalar and data name must be a string!');
            end
        end
        
        function obj = readSubjectData(obj,data_name)
            %
            % Subject-assignment is done by scanning 
            % each file name for a user-definable subject-keyword.
            % 
            read_dir = obj.getProperty('read_directory');
            filter = obj.getProperty('file_name_filter');
            read_type = obj.getProperty('read_type');
            
            if ~strcmp(read_type,'var_from_mat')
%                 files = getNameList(read_dir,filter{1},filter{2},filter{3});
                files = fullfile(read_dir,dircontent(read_dir,[filter{1} '*' filter{2} filter{3}]));
            else
                mat_content = whos('-file',read_dir);
                files = cell(length(mat_content),1);
                for i = 1:length(files)
                    files{i} = mat_content(i).name;
                end
                files = applyNameFilter(files,filter{1},filter{2},filter{3});
            end
            
            subject_keyword = obj.getProperty('subject_keyword');
            subject_ids = zeros(length(files),1);
            for i = 1:length(files);
                [~, fname] = fileparts(files{i});
                id = findNumberByKeyword(fname,subject_keyword);
                if isempty(id)
                    error('NirsSubjectList.readSubjectData: Subject key "%s" word not found in "%s"',subject_keyword,files{i});
                end
                subject_ids(i) = id;
            end
            
            [subject_ids,sort_i] = sort(subject_ids);
            files = files(sort_i);
            

            fprintf('Reading data (%s, %d files, %d subjects, ''%s'')... ',read_type,length(files),length(unique(subject_ids)),data_name);
            n = length(subject_ids);
            if ~strcmp(read_type,'var_from_mat')
                obj.file_reader_ = obj.file_reader_.setProperty('read_type',read_type);
                psh = ProgressStatus(n);
                for i = 1:n
                    obj.file_reader_ = obj.file_reader_.setProperty('file_name',files{i});
                    obj = obj.add({subject_ids(i),data_name},obj.file_reader_.read());
                    psh.update(i);
                end                     
            else
                obj.file_reader_ = obj.file_reader_.setProperty('read_type','mat');
                obj.file_reader_ = obj.file_reader_.setProperty('file_name',read_dir);
                psh = ProgressStatus(n);
                for i = 1:n
                    obj.file_reader_ = obj.file_reader_.setProperty('variable_name',files{i});
                    obj = obj.add({subject_ids(i),data_name},obj.file_reader_.read());
                end
            end
            psh.finish('Done!\n');
        end        
        
        function obj = removeSubjectData(obj, data_name)
            subjects = obj.subjects();
            for s = subjects
                if ~isempty(obj.getId({s,data_name}))
                    obj = obj.remove({s,data_name});
                end
            end
        end        
                
        function ids = subjects(obj)
            ids = cell2mat(obj.tags(1)');
        end
        
        function rlt = results(obj,rlt,varargin)            
            if all(cellfun(@iscellstr,varargin))
                names = allcellcombos(varargin);
                for i = 1:size(names,1)
                    curr_names = names(i,:);
                    curr_tag = cell2str(curr_names,'.');
                    if any(strcmp(curr_tag,obj.tags(2)))
                        rlt = asgnstruct(rlt,curr_names,obj.extract({':',curr_tag}).toArray());
                    end
                end
            else
                throw(NirsException('NirsSubjectData','results','Tag names must be string cells.'));
            end
        end
        
        function obj = processData(obj, functor, subject_selection)
            if nargin == 2
                subject_selection = 'no';
            end
            
            fprintf('Processing with function "%s"... ', functor.getFunctionName()); disp(' ')
            [input_names,input_data_number,input_argument_number] = functor.getInputInfo();
            [output_names,output_data_number,output_argument_number] = functor.getOutputInfo();

            if ischar(subject_selection) && strcmp(subject_selection,'no')
                subjects = obj.subjects();
            else
                subjects = subject_selection;
            end
            subjects = exclude(subjects,obj.getProperty('experiment').getProperty('subjects2skip'));
            
            NAlog.INIT;
            LOG.reset();
            if input_data_number == output_data_number
                data_number = input_data_number;
                for d = 1:data_number
                    LOG.setProperty('input_names',cell2str(input_names(:,d),','));
                    LOG.setProperty('output_names',cell2str(output_names(:,d),','));
                    
                    data_str = sprintf('Input/Output: %s/%s',cell2str(input_names(:,d),','), cell2str(output_names(:,d),','));
                    fprintf('\t%s ',data_str);
                    psh = ProgressStatus(length(subjects), '(%d%%%%) ');
                    c = 0;
                    for s = subjects
                        c = c + 1;
                        LOG.setProperty('subject',s);
                        in_data = cell(1,input_argument_number);
                        for ain = 1:input_argument_number
                            in_data{ain} = obj.get({s,input_names{ain,d}});
                        end
                        try
                            out_data = functor.start(in_data);
                        catch errdata
                            if strstart(errdata.identifier,'MATLAB')
                                error(['NirsSubjectData.processData(' functor.getFunctionName() ', subject #' num2str(s) '): ' errdata.message ' In file "' errdata.stack(1).file '", line ' num2str(errdata.stack(1).line) '.']);
                            else
                                psh.finish('(error)');
                                switch errdata.identifier
                                    case 'NANA:function:badInput'
                                        error('NirsSubjectData.processData(%s, subject #%d): Bad input (%s).',functor.getFunctionName(),s,errdata.message);
                                    otherwise
                                        error('NirsSubjectData.processData(%s, subject #%d): %s',functor.getFunctionName(),s,errdata.message);
                                end
                            end
                        end
                        for aout = 1:output_argument_number
                            obj = obj.add({s,output_names{aout,d}},out_data{aout});
                        end
                        psh.update(c);
                    end
                    psh.finish('(100%%)\n');
                end
                LOG.print('current','console',repmat(' ',[1 8]));
                LOG.reset();
            else
                error('NirsSubjectData.processData: input and output string cells must have the same number of columns!');
            end          
            disp('Processing Done!');
        end 
		
        function renameFiles(obj,subject_ids,str2replace,instr,new_subjects_ids)
            if nargin < 5
                new_subjects_ids = [];
            else
                if ~isequal(size(subject_ids),size(new_subjects_ids))
                    error('NirsSubjectData.renameFiles: The vectors containing subject ids must have same length.');
                end
            end
            
			read_dir = obj.getProperty('read_directory');
            filter = obj.getProperty('file_name_filter');
			keyword = obj.getProperty('subject_keyword');
			files = getNameList(read_dir,filter{1},filter{2},filter{3});
			
			fname_new = {};
            for i = 1:length(files)
                [~,fname,ext] = fileparts(files{i});
                [id,id_str] = findNumberByKeyword(fname,keyword);
                if ~isempty(id) && any(subject_ids == id)
                    old = [fname ext];
                    new = fname;
                    if ~isempty(new_subjects_ids)
                        new = strreplace(fname,[keyword id_str],[keyword num2str(new_subjects_ids(subject_ids == id))]);
                    end
                    new = [strreplace(new,str2replace,instr) ext];
                    if ~strcmp(old,new)
                        fname_new = [fname_new; {new old}];
                    end
                end
            end
            fprintf('Renaming files in "%s"...\n',read_dir)
            if ~isempty(fname_new)
                fprintf('\tPlease confirm following changes (string to replace = ''%s'', string to insert ''%s''):\n',str2replace,instr);
                printCenteredStringTab(fliplr(fname_new),' --> ','\t\t');
                choose = input(sprintf('\tApply changes (type "y" to confirm, anything else to abort)?... '),'s');
                if strcmp(choose,'y')
                    fprintf('... Renaming files... ');
                    for i = 1:length(fname_new)
                        java.io.File(fullfile(read_dir,fname_new{i,2})).renameTo(java.io.File(fullfile(read_dir,fname_new{i,1})));
                    end
                    fprintf('Done!\n');
                else
                    fprintf('... Aborted.\n');
                end
            else
                fprintf('... No files found matching file name filter {%s,%s,%s} and subject keyword "%s".\n',filter{1},filter{2},filter{3},keyword);
            end
		end
    end
    
    methods(Access = 'protected')
        function obj = update(obj,prop_name,prop_value)
        end
    end
    
    methods(Static = true)
        function prop_info = getPropertyInfos()
            prop_info.read_directory.test_fcn_handle = @(x) ischar(x);
            prop_info.read_directory.error_str = 'Read directory must be a string.';
            
            prop_info.file_name_filter.test_fcn_handle = @(x) iscellstr(x) && length(x) == 3;
            prop_info.file_name_filter.error_str = 'File name filter must be a cell string with three entries --> {prefix,postfix,extension}!.';
            
            prop_info.subject_keyword.test_fcn_handle = @(x) ischar(x);
            prop_info.subject_keyword.error_str = 'Subject keyword must be a string.';
            
            prop_info.read_type.test_fcn_handle = @(x) ischar(x);
            prop_info.read_type.error_str = 'Read type must be a string';
            
            prop_info = NirsObject.addHelpTexts('subject_data',prop_info);
        end
    end
    
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'subject_data';
        end
    end
end