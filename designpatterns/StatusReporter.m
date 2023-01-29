classdef StatusReporter < handle
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
    % Date: 2017-04-18 18:13:57
    % Packaged: 2017-04-27 17:57:59
    properties(SetAccess = 'protected')
        status_models;
    end
    
    methods
        function obj = StatusReporter()
            obj.status_models = IdList();
        end
        
        function addStatus(obj,m)
            if isa(m,'Model.Status')
                obj.status_models.add(m);
            else
                error('StatusReporter.addStatus: Status model must be a "Model.Status"');
            end
        end
        
        function initStatus(obj,init_string,nvec,varargin)
            if obj.status_models.length() == 0
                obj.addStatus(Model.Status('model_status'));
            end
            for status_id = Iter(obj.getStautsIds(varargin{:}))
                m = obj.status_models.entry(status_id);
                m.setInput('progress_name',init_string);
                m.setInput('progress_length',nvec);
            end
        end
        
        function updateStatus(obj,varargin)
            for status_id = Iter(obj.getStautsIds(varargin{:}))
                obj.status_models.entry(status_id).updateOutput();
            end
        end
    end
    
    methods(Access = 'protected')
        function status_ids = getStautsIds(obj,varargin)
            if nargin < 2
                status_ids = obj.status_models.ids();
            else
                status_ids = varargin;
            end
        end
    end
end