classdef PatchMap < Model.InterpMapping
    
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
    % Date: 2016-04-08 16:05:17
    % Packaged: 2017-04-27 17:58:28
    methods
        function obj = PatchMap()
            obj.addInput(Input.ElementItem('color_map',[],jet(64),Input.Test(@(x) ismatrix(x) && size(x,2) == 3,'Color map must be valid color map')),true);
            obj.addInput(Input.ElementItem('color_limit',[],[],Input.Test(@(x) isempty(x) || isrange(x),'Color limit must be empty or a valid range')));
            obj.addInput(Input.ElementItem('face_color',[0.5 0.5 0.5],[0.5 0.5 0.5],Input.Test(@(x) isnumeric(x) && numel(x) == 3,'Face color must be a valid RGB vector')));

            obj.addOutput(Output.ElementItem('cdata',[0.5 0.5 0.5]));
        end
    end
    
    methods(Access = 'protected')
        function prepareInput(obj)
            obj.setOutput('cdata',repmat(obj.getState('face_color'),[size(obj.getState('voxels'),1) 1]));
        end
        
        function finishOutput(obj)
            cdata = obj.getState('cdata');
            cdata(obj.getState('ipi'),:) = getColorList(obj.getState('yip'),obj.getState('color_map'),obj.getState('color_limit'));
            obj.setOutput('cdata',cdata);
        end
    end
end