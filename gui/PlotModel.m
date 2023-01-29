classdef PlotModel < Model
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
    % Date: 2014-10-02 18:06:55
    % Packaged: 2017-04-27 17:58:23
    methods
        function obj = PlotModel()
            obj@Model('plotmodel');
            x = Input.ElementItem('x',[],[],Input.Test(@isnumeric,'x must be numeric'));
            y = Input.ElementItem('y',[],[],Input.Test(@isnumeric,'y must be numeric'));
            xydep = Input.Dependency(Input.Test(@(m) size(m('x'),1) == size(m('y'),1),'y must have the same number of rows as x'));
            xydep.add(x);
            xydep.add(y);
            obj.addInput(x);
            obj.addInput(y);
            
            obj.addInput(Input.ElementItem('x-limit',[],[0 1],Input.Test(@isrange,'x-limit must be a valid range')));
            obj.addInput(Input.ElementItem('y-limit',[],[0 1],Input.Test(@isrange,'y-limit must be a valid range')));
            
            obj.addOutput(Output.ElementItem('plotx',[]));
            obj.addOutput(Output.ElementItem('ploty',[]));
        end
        
        function updateOutput(obj)
            obj.setOutput('plotx',obj.getState('x'));
            obj.setOutput('ploty',obj.getState('y'));
            obj.in.entry('x').setUnset();
            obj.in.entry('y').setUnset();
        end
    end
end