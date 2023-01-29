classdef ModelFactory < handle
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
    % Date: 2017-04-26 16:39:35
    % Packaged: 2017-04-27 17:58:23
    methods
        function obj = ModelFactory(constr_handle,varargin)
            obj.constr_handle = constr_handle;
            obj.model_inputs = containers.Map();
            for i = 1:2:numel(varargin)
                obj.model_inputs(varargin{i}) = varargin{i+1};
            end
        end
        
        function m = makeModel(obj,id)
            m = obj.constr_handle(id);
            for n = Iter(obj.model_inputs.keys)
                m.setInput(n,obj.model_inputs(n));
            end
            m = obj.initModel(m);
        end
    end
    
    methods(Access = 'protected')
        function m = initModel(obj,m)
            
        end
    end
    
    properties(Access = 'protected')
        constr_handle;
        model_inputs;
    end
end