classdef NirsProbes < Model.Item
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
    % Date: 2016-04-08 15:59:48
    % Packaged: 2017-04-27 17:57:53
    properties(SetAccess = 'protected')
        template;
        brain_mapper;
        head_mapper;
    end
    
    methods
        function obj = NirsProbes(id)
            obj@Model.Item(id);
            p = Input.ElementList('probesets' ... 
                                  ,Input.ElementItem('dummy',[],[] ...
                                  ,Input.Test(@(x) isa(x,'NirsProbeset') ...
                                  ,'Probe set must be a NirsProbeset') ...
                                  ) ...
                );
            
            obj.addInput(p);
            obj.addOutput(Output.ElementItem('chn',[]));
            obj.addOutput(Output.ElementItem('chids',[]));
            obj.addOutput(Output.ElementItem('probe_xyz',[]));
            obj.addOutput(Output.ElementItem('brain_xyz',[]));
            obj.addOutput(Output.ElementItem('head_xyz',[]));
            
            obj.brain_mapper = Model.PatchMap();
            obj.head_mapper = Model.PatchMap();
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            if obj.stateChanged('probesets')
                probes = obj.getState('probesets').toCell('values');
                template_name = unique(nonunicfun(@(x) x.getProperty('template_name'),probes));
                if length(template_name) > 1
                    error('NirsProbes: Probesets must have the same template');
                end
                obj.template = load(fullfile(fileparts(mfilename('fullpath')),'templates',[template_name{1} '.mat']));
                
                coord_data = nonunicfun(@(x) x.coordData,probes);
                obj.setOutput('chids',extractFromProbes(coord_data,'id','cell'));
                obj.setOutput('probe_xyz',extractFromProbes(coord_data,'coords'));
                obj.setOutput('brain_xyz',extractFromProbes(coord_data,'brain_coords'));
                obj.setOutput('head_xyz',extractFromProbes(coord_data,'head_coords'));
                
                obj.brain_mapper.setInput('x_distance',20);
                obj.brain_mapper.setInput('x',obj.getState('brain_xyz'));
                obj.brain_mapper.setInput('voxels',obj.template.brain_patch.vertices);
                obj.brain_mapper.setInput('face_color',[0.6 0.6 0.6]);
                obj.brain_mapper.updateOutput();
                
                obj.head_mapper.setInput('x_distance',20);
                obj.head_mapper.setInput('x',obj.getState('head_xyz'));
                obj.head_mapper.setInput('voxels',obj.template.head_patch.vertices);
                obj.head_mapper.setInput('face_color',[0.6 0.6 0.6]);
                obj.head_mapper.updateOutput();
            end
            
            function x = extractFromProbes(pd,field_name,type)
                if nargin < 3
                    type = 'num';
                end
                x = nonunicfun(@(x) cell2mat(field2cell(x.chs,field_name)'),pd);
                if strcmp(type,'num')
                    x = cell2mat(x);
                end
            end
        end
    end
end