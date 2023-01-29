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

classdef NirsObject
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
    % Date: 2016-12-07 16:12:36
    % Packaged: 2017-04-27 17:58:44
    properties
        defaults_;
        properties_;
    end
    
    methods
        function obj = setProperties(obj,props)
            keyword = obj.getKeyword();
            if isstruct(props)
                if any(strcmp(keyword,fieldnames(props)))
                    default_names = fieldnames(obj.defaults_.(keyword));
                    prop_names = fieldnames(props.(keyword));
                    for i = 1:length(default_names)
                        prop_i = find(strcmp(default_names{i},prop_names),1);
                        if isempty(prop_i)
                            prop_name = default_names{i};
                            prop_value = obj.defaults_.(keyword).(prop_name);
                        else
                            prop_name = prop_names{prop_i};
                            prop_value = props.(keyword).(prop_name);
                        end
                        obj = obj.setProperty(prop_name,prop_value);
                    end
                end
                if ~any(strcmp(keyword,{'experiment','probeset'}))
                    experiment = NirsExperiment();
                    experiment = experiment.setProperties(props);
                    obj.properties_ = obj.properties_.add({'experiment'},experiment);
                end
                switch keyword
                    case 'regression'
                        hr = NirsHemodynamicResponse();
                        hr = hr.setProperties(props);
                        obj = obj.setProperty('hemodynamic_response',hr);
                end
            else
                error('NirsObject.setProperties: Properties must be in a structure.');
            end
        end
        
        function prop_value = getProperty(obj,prop_name)
            if any(strcmp(prop_name,obj.properties_.tags()))
                prop_value = obj.properties_.get({prop_name});
            else
                throw(NirsException('NirsObject','getProperty',sprintf('Property "%s" not found.',prop_name)));
            end
        end
        
        function obj = setProperty(obj,varargin)
            if iscell(varargin) && length(varargin) == 1
                [prop_names,prop_values] = parsePropertyCell(varargin{1});
            else
                [prop_names,prop_values] = parsePropertyCell(varargin);
            end
            for p = 1:length(prop_names)
                prop_name = prop_names{p};
                prop_value = prop_values{p};
                if any(strcmp(prop_name,obj.properties_.tags()))
                    if obj.isMultiProp(prop_name)
                        cellcell_flag = false;
                        if iscell(prop_value) && ~isempty(prop_value)
                            cellcell_flag = true;
                            for i = 1:length(prop_value)
                                cellcell_flag = cellcell_flag & iscell(prop_value{i});
                            end
                        end
                        if cellcell_flag
                            for i = 1:length(prop_value)
                                obj = obj.setProperty(prop_name,prop_value{i});
                            end
                        else
                            [ok,error_str] = obj.testProperty(prop_name,prop_value);
                            if ok
                                if strcmp(prop_value,'<__EMPTY__>')
                                    obj.properties_ = obj.properties_.add({prop_name},TagMatrix({'string','first'}));
                                else
                                    prop = obj.getProperty(prop_name);
                                    [sub_names,sub_values] = parsePropertyCell(prop_value);
                                    name_index = strcmp('name',sub_names);
                                    data_index = find(~name_index);
                                    for v = data_index
                                        prop = prop.add({sub_values{name_index},sub_names{v}},sub_values{v});
                                    end
                                    obj.properties_ = obj.properties_.add({prop_name},prop);
                                end
                                obj = obj.update(prop_name,prop_value);
                            else
                                error(['setProperty(''%s'',...): ' error_str],prop_name);
                            end
                        end
                    else
                        [ok,error_str] = obj.testProperty(prop_name,prop_value);
                        if ok
                            obj.properties_ = obj.properties_.add({prop_name},prop_value);
                            obj = obj.update(prop_name,prop_value);
                        else
                            error(['setProperty: ' error_str]);
                        end
                    end
                else
                    error(['setProperty: Property "' prop_name '" not found!']);
                end
            end
        end
        
        function pstr = getPropertyString(obj,prefix,show_exp_flag)
            if nargin < 3
                show_exp_flag = true;
            end
            if nargin < 2
                prefix = '';
            end
            pstr = '';
            keyword = obj.getKeyword();
            prop_names = obj.properties_.tags(1);
            for i = 1:length(prop_names)
                flag = true;
                if strcmp(prop_names{i},'experiment') && ~show_exp_flag
                    flag = false;
                end
                if flag
                    prop_value = obj.properties_.get({prop_names{i}});
                    if isa(prop_value,'NirsObject')
                        pstr = [pstr prop_value.getPropertyString([prefix '\t'],false)];
                    elseif isa(prop_value,'TagMatrix')
                        t1 = prop_value.tags(1);
                        if prop_value.dim_ == 2
                            t2 = prop_value.tags(2);
                            for a = 1:length(t1)
                                for b = 1:length(t2)
                                    pstr = sprintf([pstr prefix '%s.%s.%s.%s = %s\n'],keyword,prop_names{i},t1{a},t2{b},stringify(prop_value.get({t1{a},t2{b}})));
                                end
                            end
                        else
                            for a = 1:length(t1)
                                pstr = sprintf([pstr prefix '%s.%s.%s = %s\n'],keyword,prop_names{i},t1{a},stringify(prop_value.get({t1{a}})));
                            end
                        end
                    else
                        pstr = sprintf([pstr prefix '%s.%s = %s\n'],keyword,prop_names{i},stringify(prop_value));
                    end
                end
            end
        end
    end
    
    methods(Access = 'public', Static = true)
        function log(log_data)
            global LOGGER;
            if ~isempty(LOGGER)
                LOGGER.log(log_data);
            end
        end
        
        function prop_info = addHelpTexts(keyword,prop_info)
            fname = fullfile(fileparts(mfilename('fullpath')),'nirs_object_help.xml');
            has_help = exist(fname,'file');
            if has_help
                xml_help = xmlread(fname);
            end
            defs = NAnaT_DEFAULTS;
            for prop_name = Iter(exclude(fieldnames(prop_info),{'experiment','hemodynamic_response'}))
                help_str = '';
                if has_help
                    element = xml_help;
                    element = element.getElementsByTagName(keyword); element = element.item(0);
                    if ~isempty(element)
                        element = element.getElementsByTagName(prop_name); element = element.item(0);
                        if ~isempty(element)
                            help_str = element.getFirstChild().getData();
                            prop_info.(prop_name).help = char(help_str);
                        end
                    end
                end
                prop_info.(prop_name).default = defs.(keyword).(prop_name);
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = NirsObject(varargin)
            obj.defaults_ = NAnaT_DEFAULTS();
            obj.properties_ = TagMatrix();
            obj.properties_ = obj.properties_.setDimension({'string'});
            keyword = obj.getKeyword();
            prop_names = fieldnames(obj.defaults_.(keyword));
            for i = 1:length(prop_names)
                obj.properties_ = obj.properties_.add({prop_names{i}},[]);
            end
            if ~any(strcmp(keyword,{'experiment','probeset'}))
                obj.properties_ = obj.properties_.add({'experiment'},[]);
            end
            switch keyword
                case 'regression'
                    obj.properties_ = obj.properties_.add({'hemodynamic_response'},[]);
            end
            obj = obj.setProperties(obj.defaults_);
            if nargin > 0 && iscell(varargin)
                if ~isempty(varargin) && iscell(varargin{1})
                    if ~isempty(varargin{1}) && isstruct(varargin{1}{1})
                        obj = obj.setProperties(varargin{1}{1});
                    else
                        obj = obj.setProperty(varargin{1});
                    end
                end
            end
            NAnaT_CURRENT_SUBJECT = 1;
        end
        
        function [ok error_str] = testProperty(obj,prop_name,prop_value)
            error_str = '';
            ok = true;
            prop_info = obj.getPropertyInfos();
            if isfield(prop_info.(prop_name),'sub_names')
                if strcmp(prop_value,'<__EMPTY__>')
                    ok = true;
                else
                    sub_names_needed = prop_info.(prop_name).sub_names;
                    [sub_name_input,sub_value_input,error_str] = parsePropertyCell(prop_value,sub_names_needed);
                    if isempty(error_str)
                        for s = 1:length(sub_name_input)
                            if ~prop_info.(prop_name).test_fcn_handle{s}(sub_value_input{s})
                                ok = false;
                                error_str = prop_info.(prop_name).error_str{s};
                                break;
                            end
                        end
                    else
                        ok = false;
                    end
                end
            else
                if ~prop_info.(prop_name).test_fcn_handle(prop_value)
                    ok = false;
                    error_str = prop_info.(prop_name).error_str;
                end
            end
        end
        
        function flag = isMultiProp(obj,prop_name)
            prop_info = obj.getPropertyInfos();
            if isfield(prop_info.(prop_name),'sub_names')
                flag = true;
            else
                flag = false;
            end
        end
    end
    
    methods(Access = 'protected', Abstract = true)
        obj = update(obj,prop_name,prop_value);
    end
    
    methods(Access = 'protected', Abstract = true, Static = true)
        keyword = getKeyword();
    end
    
    methods(Abstract = true, Static = true)
        prop_info = getPropertyInfos();
    end
end