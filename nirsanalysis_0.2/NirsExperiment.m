%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 20-Jan-2012 19:40:16


classdef NirsExperiment < NirsObject
    %
    % This object plays a special role; it hold the general properties
    % of the experiment and every other NirsObject hold an instance of
    % this object.
    %
    % Example:
    %
    %    settings.experiment.category = {
    %                                     {'name','oneb','trigger_token',1}
    %                                     {'name','twob','trigger_token',2}
    %                                   };
    %
    %    settings.experiment.contrast = {
    %                                     {'name','oneb' ,'vector',[1 0]}
    %                                     {'name','twob' ,'vector',[0 1]}
    %                                   };
    %
    %    settings.experiment.time_series = {
    %                                        {'name','oxy.bpf','sample_rate',10,'trigger_name','trigger'}
    %                                        {'name','deoxy.bpf','sample_rate',10,'trigger_name','trigger'}
    %                                      };
    %
    %    ERA = NirsEventRelatedAverage();
    %    ERA = ERA.setProperties(settings);
    %    ERA = ERA.createEra(S);
    %
    %    % adding zeros for the regression constant...
    %    settings.experiment.contrast = {
    %                                     {'name','oneb' ,'vector',[1 0 0]}
    %                                     {'name','twob' ,'vector',[0 1 0]}
    %                                   };
    %    R = NirsRegression();
    %    R = R.setProperties(settings);
    %    R = R.regress(S);
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
    % Date: 2017-04-10 16:18:18
    % Packaged: 2017-04-27 17:58:43
    methods
        function obj = NirsExperiment()

        end
    end
    
    methods(Access = 'protected')
        function obj = update(obj,prop_name,prop_value)
        end
    end
    
    methods(Static = true)
        function prop_info = getPropertyInfos()
            
            prop_info.name.test_fcn_handle = @(x) ischar(x);
            prop_info.name.error_str = 'Experiment name must be a string.';
            
            prop_info.subjects2skip.test_fcn_handle = @(x) isnumeric(x) && (isempty(x) || isvector(x));
            prop_info.subjects2skip.error_str = 'Events to skip must be a empty cell or a cell with two columns (first for subject number second for corresponding event numbers).';
            
            prop_info.events2skip.test_fcn_handle = @(x) iscell(x) && (isempty(x) || size(x,2) == 2);
            prop_info.events2skip.error_str = 'Subjects to skip must be a numeric scalar or vector.';
            
            prop_info.time_series.sub_names = {'name','sample_rate','trigger_name'};
            prop_info.time_series.test_fcn_handle = {@(x) ischar(x),@(x) isnumeric(x) && isscalar(x) && x > 0,@(x) ischar(x)};
            prop_info.time_series.error_str = {'Time series name must be a string.','Sample rate must be a numeric positiv scalar.','Time series trigger name must be a string.'};
            
            prop_info.category.sub_names = {'name','trigger_token'};
            prop_info.category.test_fcn_handle = {@(x) ischar(x),@(x) isnumeric(x) && isscalar(x)};
            prop_info.category.error_str = {'Category name must be a string.','Trigger token for a certain category must be a numeric scalar.'};
            
            prop_info.contrast.sub_names = {'name','vector'};
            prop_info.contrast.test_fcn_handle = {@(x) ischar(x),@(x) isnumeric(x) && isvector(x)};
            prop_info.contrast.error_str = {'Contrast name must be a string.','Contrast vector must be a numeric vector.'};
            
            prop_info.group.sub_names = {'name','subjects'};
            prop_info.group.test_fcn_handle = {@(x) ischar(x),@(x) isnumeric(x) && isvector(x)};
            prop_info.group.error_str = {'Contrast name must be a string.','Vector with group subject numbers must be a numeric vector.'};
            
            prop_info.probesets.sub_names = {'name','probeset'};
            prop_info.probesets.test_fcn_handle = {@(x) ischar(x),@(x) isa(x,'NirsProbeset')};
            prop_info.probesets.error_str = {'Probeset name must be a string.','Probeset must be a NirsProbeset'};
            
            prop_info.roi.sub_names = {'name','channels'};
            prop_info.roi.test_fcn_handle = {@(x) ischar(x),@(x) isnumeric(x) && isvector(x) && all(x > 0)};
            prop_info.roi.error_str = {'ROI name must be a string.', 'Channels must be a numeric vector with entries > 0.'};
        end
        
    end
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'experiment';
        end
    end
end