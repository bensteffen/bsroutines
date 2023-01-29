classdef RefHeadPointSelection < View.Input.AbstractMapSelection
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
    % Date: 2017-03-22 13:09:26
    % Packaged: 2017-04-27 17:58:55
    properties(Access = 'protected')
        head_model_id;
    end
    
    methods
        function obj = RefHeadPointSelection(id,probe_model,head_model_id)
            obj@View.Input.AbstractMapSelection(id,probe_model,'reference_head_point');
            obj.models.add(Model.Empty(head_model_id));
            obj.head_model_id = head_model_id;
        end
    end
    
    methods(Access = 'protected')
        function map = getMap(obj)
            map = obj.model.models.entry(obj.head_model_id).getState('markers');
        end
    end
end