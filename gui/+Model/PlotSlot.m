classdef PlotSlot < Model.DataItem
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
    % Date: 2016-09-18 22:45:07
    % Packaged: 2017-04-27 17:58:28
    properties(SetAccess = 'protected')
        plot_model_name;
        style_model_name;
    end
    
    methods
        function obj = PlotSlot(id,plot_model,style_model)
            obj@Model.DataItem(id);
            obj.models.add(plot_model);
            obj.models.add(style_model);
            obj.plot_model_name = plot_model.id;
            obj.style_model_name = style_model.id;
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            obj.setInput('name',obj.models.entry(obj.plot_model_name).getState('data_name'));
            obj.setInput('color',obj.models.entry(obj.style_model_name).getState('color'));
        end
        
        function defineFields(obj)
            obj.setOutput('field_names',{'name','color'});
            obj.addInput(Input.String('name',''));
            obj.addInput(Input.ElementItem('color','k','',Input.Test(@iscolor,'Color must be a color')));
        end
    end
end