%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 23-Apr-2012 18:12:50


classdef NirsAnalysisObject < TagMatrix & NirsObject
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
    % Date: 2016-09-28 19:06:15
    % Packaged: 2017-04-27 17:58:43
    properties(Access = 'protected')
        param_names_;
    end
    
    methods
        function data = getParameter(obj,varargin)
            data = [];
            names_needed = {'parameter','data','contrast','group','roi'};
            
            contrast_data = obj.getProperty('experiment').getProperty('contrast');
            contrast_names = contrast_data.tags(1);
            group_data = obj.getProperty('experiment').getProperty('group');
            group_names = group_data.tags(1);
            roi_data = obj.getProperty('experiment').getProperty('roi');
            roi_names = roi_data.tags(1);
            
            test_info(1).test_fcn_handle = @(x) any(strcmp(x,obj.tags(1)));
            test_info(1).error_str = 'Bad parameter name.';
            test_info(2).test_fcn_handle = @(x) any(strcmp(x,obj.tags(2)));
            test_info(2).error_str = 'Bad data name ''%s''.';
            test_info(3).test_fcn_handle = @(x) any(strcmp(x,contrast_names));
            test_info(3).error_str = 'Bad contrast name.';
            test_info(4).test_fcn_handle = @(x) ischar(x);
            test_info(4).error_str = 'Group must be a string.';
            test_info(5).test_fcn_handle = @(x) ischar(x);
            test_info(5).error_str = 'ROI must be a string.';
            [~,values,error_str] = parsePropertyCell(varargin,names_needed,test_info);
            
            if ~isempty(error_str)
                throw(NirsException('NirsAnalysisObject','getParameter',error_str));
            end
                
            names = {group_names roi_names; 'group' 'ROI'};
            flag = {'' ''};
            for i = [1 2]
                value = strsplit(values{i+3},'.');
                if length(value) > 1
                    flag{i} = value{2};
                elseif length(value) == 1
                    flag{i} = '';
                else
                    error('Bad %s string.',names{2,i});
                end
                value = value{1};
                if ~any(strcmp(value,names{1,i}))
                    value = str2num(value);
                    if ~(all(isint(value)) && all(value > 0))
                        error('Bad %s string.',names{2,i});
                    end
                end
                values{i+3} = value;
            end
            contrast_vector = contrast_data.get({values{3},'vector'});
            if isnumeric(values{4})
                exp_group_subjects = values{4};
            else
                exp_group_subjects = group_data.get({values{4},'subjects'});
            end
            obj_group_subjects = cell2num(obj.tags(4)');
            obj_cat_names = obj.tags(3);
            cat_names = obj_cat_names;
            if length(contrast_vector) == length(cat_names)
                data = [];
                cdat = obj.get({values{1},values{2},cat_names{1},obj_group_subjects(1)});
                [n,chn] = size(cdat);
                for s = 1:max([max(obj_group_subjects) max(exp_group_subjects)])
                    if any(exp_group_subjects == s)
                        cat_data = [];
                        for c = 1:length(cat_names)
                            cdat = obj.get({values{1},values{2},cat_names{c},s});
                            cat_data = [cat_data cdat(:)];
                        end
                        sdata = sum(cat_data .* repmat(contrast_vector,[size(cat_data,1) 1]),2)';
                        data = [data; sdata];
                    else
                        data = [data; NaN(1,n*chn)];
                    end
                end
                switch flag{1}
                    case {'','select'}
                        data = data(exp_group_subjects,:);
                    case 'average'
                        data = data(exp_group_subjects,:);
                        data = mean(data,1);
                    case 'std'
                        data = data(exp_group_subjects,:);
                        data = std(data,[],1);
                    case 'ste'
                        data = data(exp_group_subjects,:);
                        data = std(data,[],1)/sqrt(length(exp_group_subjects));
                end
                if n > 1
                    sn = size(data,1);
                    d = data;
                    data = [];
                    for s = 1:sn
                        data = [data; reshape(d(s,:),[n chn])];
                    end
                end
                if isnumeric(values{5})
                    roi_channels = values{5};
                else
                    roi_channels = roi_data.get({values{5},'channels'});
                end
                switch flag{2}
                    case {'','select'}
                        data = data(:,roi_channels);
                    case 'mask'
                        data(:,exclude(1:size(data,2),roi_channels)) = NaN;
                    case 'average'
                        data = mean(data(:,roi_channels),2);
                    otherwise
                        error('NirasAnalysisObject.getParameter: Unknown modifier "%s"',flag{2});
                end
            else
                error(['NirasAnalysisObject.getParameter: Bad contrast vector for categories "' cell2str(cat_names,'", "') '"']);
            end
        end
        
        function rlt = results(obj,rlt,varargin)
            names_needed = {'parameters','data','contrasts','groups','rois'};
            
            test_info(1).test_fcn_handle = @(x) iscellstr(x);
            test_info(1).error_str = 'Parameter names must be a string cell.';
            test_info(2).test_fcn_handle = @(x) iscellstr(x);
            test_info(2).error_str = 'Data names must be a string cell.';
            test_info(3).test_fcn_handle = @(x) iscellstr(x);
            test_info(3).error_str = 'Contrast names must be a string cell.';
            test_info(4).test_fcn_handle = @(x) iscellstr(x);
            test_info(4).error_str = 'Group names must be a string cell.';
            test_info(5).test_fcn_handle = @(x) iscellstr(x);
            test_info(5).error_str = 'ROI names must be a string cell.';
            [~,values,error_str] = parsePropertyCell(varargin,names_needed,test_info);
            if isempty(error_str)
                combos = allcellcombos(values);
                fprintf('Extracting results... ');
                n = size(combos,1);
                psh = ProgressStatus(n);
                for i = 1:n
                    value = obj.getParameter('parameter',combos{i,1},'data',combos{i,2},'contrast',combos{i,3},'group',combos{i,4},'roi',combos{i,5});
                    psh.update(i);
                    rlt = asgnstruct(rlt,combos(i,:),value);
                end
                psh.finish('Done!\n');
            else
                error(['NirasAnalysisObject.results: ' error_str]);
            end
        end
        
        function ids = subjectIds(obj,group_name)
                if isnumeric(group_name)
                    exp_group_subjects = group_name;
                else
                    exp_group_subjects = obj.getProperty('experiment').getProperty('group').get({group_name,'subjects'});
                end
                obj_group_subjects = obj.tags('subject_number');
                obj_group_subjects = cell2mat(obj_group_subjects(cellfun(@isnumeric,obj_group_subjects,'UniformOutput',true)))';
                ids = [];
                for s = 1:max([max(obj_group_subjects) max(exp_group_subjects)])
                    if any(exp_group_subjects == s)
                        ids = [ids; s];
                    end
                end
        end
        
        function toSpss(obj,sav_file_name)
            if ischar(sav_file_name)
                disp(['Writing sav-file to "' [fulldir(sav_file_name) sav_file_name '.sav'] '"...'])
                NAio.createSpssSav(sav_file_name,obj,obj.param_names_);
                disp('... Done!');
            else
                error('NirsObject.toSpss: Sav-file name must be a string.');
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = NirsAnalysisObject(object_id,varargin)
            obj = obj@NirsObject(object_id,varargin{:});
            obj = obj.setDimension({'string','string','string','numeric'});
        end
    end
end