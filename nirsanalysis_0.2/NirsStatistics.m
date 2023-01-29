%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 30-Jan-2012 18:48:31


classdef NirsStatistics < TagMatrix & NirsObject    
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
    % Date: 2016-10-31 15:51:52
    % Packaged: 2017-04-27 17:58:44
    properties
    end
    
    methods
        function obj = NirsStatistics(varargin)
            obj = obj@NirsObject(varargin);
            obj = obj.setDimension({'ttest_name','test_data'});
        end
        
        function sig_vec = isSignificant(obj, ttest_name)
            if ~ischar(ttest_name)
                error('NirsStatistics.isSignificant: T-test name must be a string.');
            else
                if ~any(strcmp(ttest_name,obj.tags(1)))
                    error(['NirsStatistics.isSignificant: T-test "' ttest_name '" not found.']);
                end
            end
            
            pvals = obj.get({ttest_name,'p-values'});
            sig_vec = zeros(size(pvals));
            alpha_level = obj.getProperty('alpha_level');
            switch obj.getProperty('correction_method')
                case 'none'
                    sig_vec = pvals <= alpha_level;
                case 'fdr'
                    [~, I] = fdr(pvals, alpha_level);
                    if ~isequal(I,0)
                        sig_vec(I) = 1;
                    end
                case 'bonferroni'
                    sig_vec = pvals <= alpha_level/length(pvals);
                case 'bonferroni-holm'
                    sig_vec = NAstat.bonholm(pvals,alpha_level);
                case 'armitage-parmar'
                    data1 = obj.get({ttest_name,'test_data1'});
                    data2 = obj.get({ttest_name,'test_data2'});
                    switch obj.get({ttest_name,'test_type'})
                        case 'ttest'
                            sig_vec = pvals <= NAstat.armitageParmarCorrection(data1-data2,alpha_level);
                        case 'ttest2'
                            sig_vec = pvals <= NAstat.armitageParmarCorrection([data1; data2],alpha_level);
                    end
            end
            sig_vec = find(sig_vec);
        end
        
        function vals = getStats(obj,test_name,val_type)
            switch val_type
                case {'test_statistic','p-values'}
                    vals = obj.get({test_name,val_type});
                case 'effect_size'
                    vals = obj.get({test_name,'test_statistic'});
                    switch obj.get({test_name,'test_type'})
                        case 'ttest'
                            n = size(obj.get({test_name,'test_data1'}),1);
                            vals = vals/sqrt(n);
                        case 'ttest2'
                            n1 = size(obj.get({test_name,'test_data1'}),1);
                            n2 = size(obj.get({test_name,'test_data2'}),1);
                            df = n1 + n2 - 1;
                            vals = vals*(n1+n2)/sqrt(df*n1*n2);
                        case 'corr'
                            n = size(obj.get({test_name,'test_data1'}),1);
                            vals = vals*sqrt(n-2)./sqrt(1-vals.^2); % transform to t-values
                            vals = vals/sqrt(n);
                        otherwise
                            error('NirsStatistics.getStats: Effect size only available for "ttest","ttest2" and "corr" but not for "%s".',obj.get({ttest_name,'test_type'}));
                    end
                case 'sample_size'
                    switch obj.get({test_name,'test_type'})
                        case 'ttest'
                            vals = size(obj.get({test_name,'test_data1'}),1);
                        case 'ttest2'
                            vals = [size(obj.get({test_name,'test_data1'}),1) size(obj.get({test_name,'test_data2'}),1);];
                    end
            end
        end
        
        function obj = ttest(obj,ttest_name,data1,data2)
            if nargin < 4
                data2 = 0;
            end
            if ~ischar(ttest_name)
                error('NirsStatistics.ttest: T-test name must be a string.');
            end
            if ~isnumeric(data1) || ~isnumeric(data2)
                error('NirsStatistics.ttest: T-test data must be numeric.');
            end

            [T,P] = NAstat.getTvalues(data1,data2);
            obj = obj.add({ttest_name,'test_statistic'},T);
            obj = obj.add({ttest_name,'p-values'},P);
            obj = obj.add({ttest_name,'test_data1'},data1);
            obj = obj.add({ttest_name,'test_data2'},data2);
            obj = obj.add({ttest_name,'test_type'},'ttest');
        end
        
        function obj = ttest2(obj,ttest_name,data1,data2)
            if ~ischar(ttest_name)
                error('NirsStatistics.ttest: T-test name must be a string.');
            end
            if ~(isnumeric(data1) && isnumeric(data2))
                error('NirsStatistics.ttest: T-test data must be numeric.');
            end
            
            var_type = obj.getProperty('ttest2_variance_type');
            if strcmpi(var_type,'levene')
                [T,P] = NAstat.getT2values(data1,data2,obj.getProperty('levene_alpha_level'));
            else
                [T,P] = NAstat.getT2values(data1,data2,var_type);
            end
            obj = obj.add({ttest_name,'test_statistic'},T);
            obj = obj.add({ttest_name,'p-values'},P);
            obj = obj.add({ttest_name,'test_data1'},data1);
            obj = obj.add({ttest_name,'test_data2'},data2);
            obj = obj.add({ttest_name,'test_type'},'ttest2');
        end
        
        function obj = corr(obj,corr_name,data1,data2)
            if isequal(size(data1),size(data2))
                [rho,p] = corrColumnwise(data1,data2);
            elseif size(data1,1) == numel(data2)
                [rho,p] = corr(data1,data2(:));
                rho = rho'; p = p';
            else
%                 rho = []
%                 p = []
            end
            obj = obj.add({corr_name,'test_statistic'},rho);
            obj = obj.add({corr_name,'p-values'},p);
            obj = obj.add({corr_name,'test_data1'},data1);
            obj = obj.add({corr_name,'test_data2'},data2);
            obj = obj.add({corr_name,'test_type'},'corr');
        end

        function obj = automaticTtesting(obj,results,varargin)
            allnames = allcellcombos(varargin);
            n = size(allnames,1);
            fprintf('Testing... ');
            psh = ProgressStatus(n);
            for i = 1:n
               names = allnames(i,:);
               names(cellfun(@isempty,names)) = [];
               ttest_name = cell2str(names,'.');
               grouptest = cellfun(@(x) ~isempty(strfind(x,'VS')),names);
               if sum(grouptest) == 0
                   [val,flag] = structvalue(results,names);
                   if flag
                       obj = obj.ttest(ttest_name,val);
                   end
               elseif sum(grouptest) == 1
                    testname = names{grouptest};
                    n = findNumberByKeyword(testname,'VS');
                    if isempty(n)
                        vs = 'VS';
                    elseif n == 2
                        vs = 'VS2';
                    else
                        throw(NirsException('NirsStatistics','automaticTtesting','Invalid VS-syntax, use "VS" or "VS2" for group testing.'));
                    end
                    testnames = strsplit(testname,vs);
                    tindex = find(grouptest);
                    names{tindex} = testnames{1};
                    [val1,f1] = structvalue(results,names);
                    names{tindex} = testnames{2};
                    [val2,f2] = structvalue(results,names);
                    if f1 && f2
                        switch vs
                            case 'VS'
                                obj = obj.ttest(ttest_name,val1,val2);
                            case 'VS2'
                                obj = obj.ttest2(ttest_name,val1,val2);
                        end
                    end
               end
               psh.update(i);
            end
            psh.finish('Done!\n');
        end
    end
        
    methods(Access = 'protected')
        function obj = update(obj,prop_name,prop_value)
        end
    end
    
    methods(Static = true)
        function prop_info = getPropertyInfos()
            corr_methods = {'none','fdr','bonferroni','bonferroni-holm','armitage-parmar'};
            prop_info.correction_method.test_fcn_handle = @(x) any(strcmp(x,corr_methods));
            prop_info.correction_method.error_str = ['Correction method must be a string ("' cell2str(corr_methods,'", "') '").'];
            
            prop_info.alpha_level.test_fcn_handle = @(x) isnumeric(x) && isscalar(x) && x >= 0 && x <= 1;
            prop_info.alpha_level.error_str = 'Alpha level must be a scalar between 0 and 1.';
            
            prop_info.levene_alpha_level.test_fcn_handle = @(x) isnumeric(x) && isscalar(x) && x >= 0 && x <= 1;
            prop_info.levene_alpha_level.error_str = 'Alpha level for Levene test must be a scalar between 0 and 1.';
            
            var_types = {'levene','equal','unequal'};
            prop_info.ttest2_variance_type.test_fcn_handle = @(x) any(strcmp(x,var_types));
            prop_info.ttest2_variance_type.error_str = ['Variance type for two-sample t-test must a string ("' cell2str(corr_methods,'", "') '").'];
            
            prop_info.experiment.test_fcn_handle = @(x) isa(x,'NirsExperiment');
            prop_info.experiment.error_str = 'Experiment must be a NirsExperiment.';
        end
    end
    
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'statistics';
        end
    end
    
end