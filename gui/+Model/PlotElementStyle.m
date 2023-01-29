classdef PlotElementStyle < Model.Item
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
    % Date: 2017-02-20 13:33:34
    % Packaged: 2017-04-27 17:58:28
    methods
        function obj = PlotElementStyle(id)
            obj@Model.Item(id);
            
            obj.addInput(Input.Color('color'));
            obj.addInput(Input.ElementItem('style','-','-',Input.Test(@(x) ischar(x),'Line style must be a string')));
            obj.addInput(Input.ElementItem('width',2,2,Input.Test(@(x) isnumscalar(x) && x > 0,'Width must be a numeric scalar')));
            obj.addInput(Input.ElementItem('size',12,12,Input.Test(@(x) isnumscalar(x) && x > 0,'Size width must be a numeric scalar')));
            
            obj.addOutput(Output.ElementItem('line_properties',{}));
            obj.createOutput();
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            line_properties = {};
            s = obj.getState('style');
            switch s
                case {'-','--',':','-.','none'}
                    line_properties = [line_properties {'LineStyle',s}];
                otherwise
                    line_properties = [line_properties {'LineStyle','none','Marker',s}];
            end
            line_properties = [line_properties {'Color' obj.getState('color')}];
            line_properties = [line_properties {'LineWidth' obj.getState('width')}];
            line_properties = [line_properties {'MarkerSize' obj.getState('size')}];
            obj.setOutput('line_properties',line_properties);
        end
    end
end