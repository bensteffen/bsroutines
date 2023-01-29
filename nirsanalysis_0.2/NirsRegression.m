classdef NirsRegression < NirsAnalysisObject
    %
    % Performing a regression based on a general linear model (GLM). In the
    % default case a hemodynamic response function is modelled for each
    % condition. The conditions and their onsets are defined by the trigger
    % attached to a time series.
    %
    % Example:
    % You may have created a settings strucute defining the time series and
    % conditions. Then perform the regression:
    %   R = NirsRegression();            % create regression object
    %   R = R.setProperties(settings);   % apply predefined settings (stored in structure "settings")
    %   R = R.regress(S);                % perfom regression using the subject data stored
    %                                    % stored in S
    % You can check the GLM by having a look on the design matrix. Use the
    % ''getDesginMatrix'' method for this prupose. You may also have a
    % ''NirsSubjectData''-object with name //'S'// in your workspace. Also you have
    % defined time series with a trigger with name //'trigger'// assigned to those.
    %   S = R.getDesignMatrix(S,'.designmx');
    %   designmx = S.getSubjectData(7,'trigger.designmx'); % get design matrix for subject 7
    %   figure; plot(designmx);
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
    % Date: 2016-11-14 11:23:31
    % Packaged: 2017-04-27 17:58:44
    methods
        function obj = NirsRegression(varargin)
            obj = obj@NirsAnalysisObject(varargin);
            obj.param_names_ = {'betas'};
        end
        
        function obj = regress(obj, subject_list, reg_name)
        % Performs a linear regression. Results are
        % stored with the tags "betas" (beta-values) and "R2"
        % (explained variance).
        %
        % Usage:
        % R = R.regress(S) performs regression on NirsSubjectData S.
        %
        % R = R.regress(S,reg_name)
        % The result tags will be perceeded by the string 'reg_name.'.  This way
        % different regression analysis can be stored simultaneously in
        % one regression object.
        %
            obj.log('\n\n\n### Performing regression...\n');
            obj.log('Regression object Properties:\n');
            obj.log([obj.getPropertyString('\t\t') '\n']);
            
            if nargin < 3
                reg_name = '';
            end
            reg_prefix = ifel(isempty(reg_name),'',[reg_name '.']);
            
            experiment = obj.getProperty('experiment');
            cat_names = experiment.getProperty('category').tags(1);
            
            subjects2skip = experiment.getProperty('subjects2skip');
            subjects = subject_list.subjects();
            subjects = exclude(subjects,subjects2skip);
            
            time_series_info = experiment.getProperty('time_series');
            data_names = time_series_info.tags(1);
            trigger_names = time_series_info.extract({':','trigger_name'}).toCell();
            
            derivation_level = obj.getProperty('hemodynamic_response').getProperty('derivation_level');
            era_reg_names = obj.getProperty('event_related_regressors').tags(1);
            
            subject_list = obj.getDesignMatrix(subject_list, '__design__');
            design_names = addPostfix(time_series_info.extract({':','trigger_name'}).toCell(),'__design__',false);
            
            postfix = cellfun(@(x) sprintf('.div%d',x),num2cell(0:derivation_level)','UniformOutput',false);
            postfix{1} = '';
            postfix = repmat(postfix,[length(cat_names) 1]);
            reg_names = repmat(cat_names',[derivation_level + 1 1]);
            reg_names = addPostfix(reg_names(:),postfix,false);
            reg_names = [reg_names; era_reg_names];
            reg_names = repmat(reg_names,[1 length(trigger_names)]);
            gbl_names = obj.getProperty('global_regressors');
            gbl_names = repmat(gbl_names(:),[1 length(trigger_names)]);
            chw_names = obj.getProperty('channel_wise_regressors');
            chw_names = repmat(chw_names(:),[1 length(trigger_names)]);
            const_names = repmat({'constant'}, [1 length(trigger_names)]);
            reg_names = [reg_names; gbl_names; chw_names; const_names];
            
            F = NirsDataFunctor('function_handle',@NAstat.getBetas,'output_names',{'__beta__';'__R2__'});
            for d = 1:length(data_names)
                if isempty(chw_names)
                    curr_chwname = [];
                else
                    curr_chwname = chw_names(:,d);
                end
                F = F.setProperty('input_names',[data_names(d); design_names(d); curr_chwname]);
                subject_list = subject_list.processData(F,subjects);
                for s = subjects
                    beta = subject_list.getSubjectData(s,'__beta__');
                    R2 = subject_list.getSubjectData(s,'__R2__');
                    for c = 1:size(reg_names,1)
                        obj = obj.add({[reg_prefix 'betas'],data_names{d},reg_names{c,d},s},beta(c,:));
                        obj = obj.add({[reg_prefix 'R2']   ,data_names{d},reg_names{c,d},s},R2(c,:));
                    end
                end
            end
            obj.log('### Regression done!');
        end
        
        function subject_list = getDesignMatrix(obj, subject_list, design_postfix)
            % Calculates the design matrix.
            %
            % Usage:
            % S = R.getDesignMatrix(S,postfix) 
            % calculates the design matrix for the current current settigngs and
            % for each subject in NirsSubjectData S. The design matrices will be stored
            % adds with the tags '<trigger_name>.<postfix>'
            % in the output S.
            
            if isa(subject_list, 'NirsSubjectData') && ischar(design_postfix)

                experiment = obj.getProperty('experiment');
                subjects2skip = experiment.getProperty('subjects2skip');
                events2skip = experiment.getProperty('events2skip');
                e2s.subs = cell2num(events2skip(:,1));
                e2s.evs = events2skip(:,2);
                categories = experiment.getProperty('category');
                cat_token = categories.extract({':','trigger_token'}).toCell()';
                event_duration = obj.getProperty('event_duration');
                time_series_info = experiment.getProperty('time_series');
                [trigger_names,tr_index] = unique(time_series_info.extract({':','trigger_name'}).toCell());
                fs = time_series_info.extract({':','sample_rate'}).toArray();
                fs = fs(tr_index);
                subjects = exclude(subject_list.subjects(),subjects2skip);
                HR = obj.getProperty('hemodynamic_response');
                if ~isempty(obj.getProperty('event_related_regressors').tags(1))
                    era_reg.handles = obj.getProperty('event_related_regressors').extract({':','handle'}).toCell();
                    era_reg.dur = obj.getProperty('event_related_regressors').extract({':','duration'}).toArray()';
                    era_reg.token = obj.getProperty('event_related_regressors').extract({':','trigger_token'}).toCell()';
                else
                    era_reg.handles = {};
                    era_reg.dur = [];
                    era_reg.token = {};
                end
                deriv_level = HR.getProperty('derivation_level');
                hrf_normalize = onoff2flag(obj.getProperty('standardize_hrf'));
                gbl_names = obj.getProperty('global_regressors');
                
                catn = length(cat_token);
                cat_token = [cat_token; repmat(cat_token,[deriv_level 1])];
                cat_token = cat_token(:)';
                trigger_tokens = [cat_token era_reg.token];
                duration = [repmat(event_duration,[1 length(cat_token)]) era_reg.dur];
                for d = 1:length(trigger_names)
                    hr = [repmat(HR.getResponse(fs(d)),[1 catn]) HR.getHrFromHandles(era_reg.handles,fs(d))];
                    for s = subjects
                        trigger = subject_list.getSubjectData(s,trigger_names{d});
                        trigger = NAev.clearTriggerEvents(trigger,[e2s.evs{e2s.subs == s}]);
                        dgnmx = NAhr.createHrf(trigger,hr,fs(d),trigger_tokens,duration);
                        if hrf_normalize
                            dgnmx = dgnmx./reprow(dgnmx,std(dgnmx));
                        end
                        for g = 1:length(gbl_names)
                            dgnmx = [dgnmx subject_list.getSubjectData(s,gbl_names{g})];
                        end
                        subject_list = subject_list.addSubjectData(s,[trigger_names{d} design_postfix],dgnmx);
                    end
                end
            else
                error('NirsRegression.getDesignMatrix: Subject list must be a NirsSubjectData object and design matrix name must be a string!')
            end
        end
    end
        
    methods(Access = 'protected')
        function obj = update(obj,prop_name,prop_value)
        end
    end
    
    methods(Static = true)
        function prop_info = getPropertyInfos()
            prop_info.hemodynamic_response.test_fcn_handle = @(x) isa(x,'NirsHemodynamicResponse');
            prop_info.hemodynamic_response.error_str = 'Hemodynamic response must be a NirsHemodynamicResponse';
            
            prop_info.event_duration.test_fcn_handle = @(x) isnumeric(x) && isscalar(x) && x >= 0;
            prop_info.event_duration.error_str = 'Event duration must be a scalar >= 0.';
            
            prop_info.standardize_hrf.test_fcn_handle = @(x) strcmpi(x,{'on','off'});
            prop_info.standardize_hrf.error_str = 'Standardize HRF must be ''on'' or ''off''.';
            
            prop_info.global_regressors.test_fcn_handle = @(x) iscellstr(x) && (isempty(x) || isvector(x));
            prop_info.global_regressors.error_str = 'Additional regressors must be a cell string (vector or empty)';
            
            prop_info.channel_wise_regressors.test_fcn_handle = @(x) iscellstr(x) && (isempty(x) || isvector(x));
            prop_info.channel_wise_regressors.error_str = 'Additional regressors must be a cell string (vector or empty)';
            
            prop_info.event_related_hrfamps.test_fcn_handle = @(x) ischar(x);
            prop_info.event_related_hrfamps.error_str = 'Event-related HRF amplitudes name must be a string.';
            
            prop_info.event_related_regressors.sub_names = {'name','handle','duration','trigger_token'};
            prop_info.event_related_regressors.test_fcn_handle = {@ischar,@isfunction,@(x) isnumeric(x) && isscalar(x) && x >= 0,@(x) isnumeric(x) && isvector(x)};
            prop_info.event_related_regressors.error_str = {'Name must be a string.' ,'Event related regressors must be a cell of function handles (vector or empty).','Duration must be a scalar >= 0.','Trigger token must be a numeric vector.'};
            
            prop_info.experiment.test_fcn_handle = @(x) isa(x,'NirsExperiment');
            prop_info.experiment.error_str = 'Experiment must be a NirsExperiment';
            
            prop_info = NirsObject.addHelpTexts('regression',prop_info);
        end
    end 
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'regression';
        end
    end
end