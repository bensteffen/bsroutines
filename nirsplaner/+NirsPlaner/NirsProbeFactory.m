classdef NirsProbeFactory < ModelFactory
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
    % Date: 2017-04-26 16:36:19
    % Packaged: 2017-04-27 17:58:55
    properties(Access = 'protected')
        head_model_name;
    end
    
    methods
        function obj = NirsProbeFactory(head_model_name)
            obj@View.Item('nirs_probe_factory')
            obj.models.add(Model.Empty(head_model_name));
            obj.head_model_name = head_model_name;
        end
        
        function p = makeModel(obj,id)
            p = NirsPlaner.NirsProbe(id,obj.head_model_name);
            markers = obj.controller.model_list.entry(obj.head_model_name).getState('markers');
            
            p.setInput('reference_head_point',markers('Fpz'));
            p.updateOutput();            
        end
    end
end