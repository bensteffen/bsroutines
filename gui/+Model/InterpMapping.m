classdef InterpMapping < Model.Item
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
    % Date: 2016-04-08 09:13:06
    % Packaged: 2017-04-27 17:58:28
    methods
        function obj = InterpMapping()
            obj@Model.Item('ipm')
            obj.addInput(Input.ElementItem('y',[],[],Input.Test(@(x) isnumeric(x),'y must be numeric')));
            obj.addInput(Input.ElementItem('x',[],[],Input.Test(@(x) isnumeric(x),'x must be numeric')));
            obj.addInput(Input.ElementItem('x_distance',1,1,Input.Test(@(x) isnumscalar(x) && x > 0 ,'x distance must be a numeric scalar > 0')));
            obj.addInput(Input.ElementItem('voxels',struct,struct,Input.Test(@(x) isnumeric(x),'Voxels must be numeric')));

            obj.addOutput(Output.ElementItem('xip',[]));
            obj.addOutput(Output.ElementItem('yip',[]));
            obj.addOutput(Output.ElementItem('ipi',[]));
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            obj.prepareInput();
            
            d = obj.getState('x_distance');
            x = obj.getState('x');
            y = obj.getState('y'); y = y(:);
            vxs = obj.getState('voxels');
            i_ok = ~isnan(y);
            
            if obj.stateChanged('x') || obj.stateChanged('voxels') || obj.stateChanged('x_distance')
                ipi = voxelarea(vxs,x,d);
                obj.setOutput('ipi',ipi);
                obj.setOutput('xip',vxs(ipi,:));
            end
            
            if obj.stateChanged('x') || obj.stateChanged('voxels') || obj.stateChanged('x_distance') || obj.stateChanged('y')
                obj.setOutput('yip',interpolateRbf(obj.getState('xip'),x(i_ok,:),y(i_ok),@(r) exp(-(r/d).^2)));
            end
            
            obj.finishOutput();
        end
        
        function prepareInput(obj)
        end
        
        function finishOutput(obj)
        end
    end
end