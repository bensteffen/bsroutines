classdef BrainMapModel < Model.Item
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
    % Date: 2016-11-02 15:50:15
    % Packaged: 2017-04-27 17:57:53
    properties
        ipm = Model.InterpMapping;
        face_color;
    end
    
    methods
        function obj = BrainMapModel(id)
            obj@Model.Item(id);
            obj.addInput(Input.ElementItem('values2map',{},{},Input.Test(@iscell,'Values must be a cell array')));
            obj.addInput(Input.ElementItem('template_name','','Colin27(570mm)',Input.Test(@ischar,'Template name must be a string')));
            obj.addInput(Input.Options('map_type',{'brain_map','head_map'}));
            obj.addInput(Input.ElementItem('color_limit',[],[-1 1],Input.Test(@isrange,'Color limit must be a valid range')));
            
            p = Input.ElementList('probesets' ... 
                                  ,Input.ElementItem('dummy',[],[] ...
                                  ,Input.Test(@(x) isa(x,'NirsProbeset') ...
                                  ,'Probe set must be a NirsProbeset') ...
                                  ) ...
                );
            obj.addInput(p);
            
            obj.setDefault('template_name');
            obj.setDefault('color_limit');
            
%             load(fullfile(fileparts(mfilename('fullpath')),'templates',[obj.getState('template_name') '.mat']));
            obj.addOutput(Output.ElementItem('patch',[]));
%             obj.setOutput('patch',brain_patch);
            obj.createOutput();
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            map_type = obj.getState('map_type');
            if obj.stateChanged('template_name') || obj.stateChanged('map_type')
                load(fullfile(fileparts(mfilename('fullpath')),'templates',[obj.getState('template_name') '.mat']));
                switch map_type
                    case 'brain_map'
                        patch2map = brain_patch;
                    case 'head_map'
                        patch2map = head_patch;
                end
                obj.face_color = patch2map.FaceColor;
                cdata = repmat(obj.face_color,[size(patch2map.vertices,1) 1]);
                patch2map.FaceColor = 'interp';
                patch2map.FaceVertexCData = cdata;
                obj.setOutput('patch',patch2map);
            else
                patch2map = obj.getState('patch');
            end

            if obj.stateOk('values2map')
                probes = Iter(obj.getState('probesets'));
                values = obj.getState('values2map');
                XYZ = [];
                VALS = [];
                for p = probes
                    chids = cell2mat(field2cell(p.value.coordData().chs,'id')');
                    xyz = cell2mat(field2cell(p.value.coordData().chs,[map_type(1:end-4) '_coords'])');
                    v = values{probes.i};
                    XYZ = [XYZ;xyz];
                    VALS = [VALS;v(chids)];
                end
                obj.ipm.setInput('voxels',patch2map.vertices);
                obj.ipm.setInput('x_distance',20);
                obj.ipm.setInput('x',XYZ);
                obj.ipm.setInput('y',VALS);
                obj.ipm.updateOutput();

                patch2map.FaceVertexCData(obj.ipm.getState('ipi'),:) = getColorList(obj.ipm.getState('yip'),braincmap2,obj.getState('color_limit'));
            end
            obj.setOutput('patch',patch2map);
        end
    end
end