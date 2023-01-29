classdef BoundingBox < Model.Item
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
    % Date: 2017-02-02 15:40:08
    % Packaged: 2017-04-27 17:58:27
    methods
        function obj = BoundingBox()
            obj.addInput(Input.ElementItem('x1',[],-1,Input.Test(@isnumsclar,'x1 must be a numeric scalar')));
            obj.addInput(Input.ElementItem('x2',[] ,1,Input.Test(@isnumsclar,'x2 right must be a numeric scalar')));
            obj.addInput(Input.ElementItem('y1',[],-1,Input.Test(@isnumsclar,'y1 left must be a numeric scalar')));
            obj.addInput(Input.ElementItem('y2',[] ,1,Input.Test(@isnumsclar,'y2 right must be a numeric scalar')));
            
            obj.addOutput(Output.ElementItem('box',[]));
            obj.addOutput(Output.ElementItem('xlim',[]));
            obj.addOutput(Output.ElementItem('ylim',[]));
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            x1 = obj.getState('x1');
            x2 = obj.getState('x2');
            y1 = obj.getState('y1');
            y2 = obj.getState('y2');
            
            obj.setOutput('box',[x1 x2; y1 y2]);
            obj.setOutput('xlim',[x1 x2]);
            obj.setOutput('ylim',[y1 y2]);
        end
    end
end