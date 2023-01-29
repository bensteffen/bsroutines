classdef Line < Model.Item
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
    % Date: 2014-11-07 16:19:01
    % Packaged: 2017-04-27 17:58:28
    methods
        function obj = Line(id)
            obj@Model.Item(id);
            
            x = Input.ElementItem('x',[],[],Input.Test(@isnumeric,'x must be numeric'));
            y = Input.ElementItem('y',[],[],Input.Test(@isnumeric,'y must be numeric'));
            
            xydep = Input.Dependency(Input.Test(@(m) size(m('x'),1) == size(m('y'),1),'y must have the same number of rows as x'));
            xydep.add(x);
            xydep.add(y);
            obj.addInput(x);
            obj.addInput(y);
            obj.addInput(Input.ElementItem('color',[],[0 0 1],Input.Test(@(x) isnumeric(x) && isvector(x) && numel(x) == 3,'Color must be a rgb vector')));
            obj.addInput(Input.ElementItem('style','','-',Input.Test(@ischar,'Style must be a valid line style string')));
            
            obj.addOutput(Output.ElementItem('line',line([],[])));
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            if obj.inputComplete()
                obj.getState('x')
                obj.getState('y')
                obj.setOutput('line',line(...
                                          obj.getState('x')...
                                         ,obj.getState('y')...
                                         ,'Color',obj.getState('color')...
                                         ,'LineStyle',obj.getState('style')...
                                         ));
            end
        end
    end
end