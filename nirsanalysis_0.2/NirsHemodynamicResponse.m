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


classdef NirsHemodynamicResponse < NirsObject
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
    % Date: 2013-03-11 16:34:22
    % Packaged: 2017-04-27 17:58:44
    methods
        function obj = NirsHemodynamicResponse(varargin)
            obj = obj@NirsObject(varargin);
        end
        
        function hr = getResponse(obj,fs)
            params = obj.createParamVec();
            t = (0:1/fs:params(7))';
            
            hr_handle = obj.getProperty('hr_handle');
            hr = zeros(length(t),obj.getProperty('derivation_level') + 1);
            hr(:,1) = hr_handle(t,params);
            
            for i = 2:obj.getProperty('derivation_level') + 1
                hr(:,i) = [diff(hr(:,i-1)); 0];
            end  
        end
        
        function hr = getHrFromHandles(obj,handle_cell,fs)
            params = obj.createParamVec();
            t = (0:1/fs:params(7))';
            hr = zeros(length(t),length(handle_cell));
            for j = 1:size(hr,2)
                fcn = handle_cell{j};
                hr(:,j) = fcn(t,params);
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = update(obj,prop_name,prop_value)
            
        end
        
        function params = createParamVec(obj)
            params = [obj.getProperty('peak_time')                 %1
                      obj.getProperty('undershoot_time')           %2
                      obj.getProperty('peak_dispersion')           %3
                      obj.getProperty('undershoot_dispersion')     %4
                      obj.getProperty('ratio_response2undershoot') %5
            	      obj.getProperty('onset')                     %6
                      obj.getProperty('kernel_length')             %7
                      ]; 
        end
    end
    
    methods(Static = true)
        function prop_infos = getPropertyInfos()
            fh_numscalar = @(x) isnumeric(x) && isscalar(x);
            
            prop_infos.hr_handle.test_fcn_handle = @isfunction;
            prop_infos.hr_handle.error_str = 'HR handle must be a handle to a function.';
            
            prop_infos.derivation_level.test_fcn_handle = @(x) fh_numscalar(x) && ~mod(x,1);
            prop_infos.derivation_level.error_str = 'Derivation level must be a scalar integer.';
            
            prop_infos.kernel_length.test_fcn_handle = @(x) fh_numscalar(x) && x > 0;
            prop_infos.kernel_length.error_str = 'Kernel length must be a positiv scalar.';
            
            prop_infos.peak_time.test_fcn_handle = @(x) fh_numscalar(x);
            prop_infos.peak_time.error_str = 'Peak time must be a scalar.';
            
            prop_infos.peak_dispersion.test_fcn_handle = @(x) fh_numscalar(x) && x > 0;
            prop_infos.peak_dispersion.error_str = 'Peak dispersion must be a positiv scalar.';
            
            prop_infos.undershoot_time.test_fcn_handle = @(x) fh_numscalar(x);
            prop_infos.undershoot_time.error_str = 'Undershoot time must be a scalar.';
            
            prop_infos.undershoot_dispersion.test_fcn_handle = @(x) fh_numscalar(x) && x > 0;
            prop_infos.undershoot_dispersion.error_str = 'Undershoot dispersion must be a positiv scalar.';
            
            prop_infos.ratio_response2undershoot.test_fcn_handle = @(x) fh_numscalar(x) && x > 0;
            prop_infos.ratio_response2undershoot.error_str = 'Response to undershoot ratio must be a positiv scalar.';
            
            prop_infos.onset.test_fcn_handle = @(x) fh_numscalar(x);
            prop_infos.onset.error_str = 'Onset must be a scalar.';
        end
    end
    
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'hemodynamic_response';
        end
    end
end