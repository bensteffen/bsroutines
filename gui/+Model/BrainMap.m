classdef BrainMap < Model.Item
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
    % Date: 2016-10-27 14:38:29
    % Packaged: 2017-04-27 17:58:27
    properties
        interp_x = containers.Map();
        interp_y = containers.Map();
        verts2color = containers.Map();
    end
    
    methods
        function obj = BrainMap(id)
            obj@Model.Item(id)
            
            obj.addInput(Input.ElementItem('interp_type','','map',Input.Test(@(x) any(strcmp(x,{'blobs','map'})),'Interpolation type must be ''map'' or ''blobs''')));
            obj.addInput(Input.ElementItem('color_map',[],jet(64),Input.Test(@(x) ismatrix(x) && size(x,2) == 3,'Color map must be valid color map')));
            obj.addInput(Input.ElementItem('color_limit',[],[],Input.Test(@(x) isempty(x) || isrange(x),'Color limit must be empty or a valid range')));
            obj.addInput(Input.ElementItem('show_probeset',true,true,Input.Test(@islogical,'Show probeset must be logical')));
            obj.addInput(Input.ElementItem('show_head',false,false,Input.Test(@islogical,'Show head must be logical')));
            obj.addInput(Input.ElementItem('show_on_head',false,false,Input.Test(@islogical,'Show on head must be logical')));
            obj.addInput(Input.ElementItem('template_name','','Colin27',Input.Test(@ischar,'Template prefix must be a string')));
            
            obj.addInput(Input.ElementList('xyz',Input.ElementItem('dummy',[],[],Input.Test(@(x) isnumeric(x) && size(x,2) == 3,'xyz-coordinate matrix must have 3 columns'))));
            obj.addInput(Input.ElementList('values',Input.ElementItem('dummy',[],[],Input.Test(@isnumeric,'values must be numeric'))));
            
            obj.setDefault('interp_type');
            obj.setDefault('color_map');
            obj.setDefault('color_limit');
            obj.setDefault('show_probeset');
            obj.setDefault('show_head');
            obj.setDefault('show_on_head');
            obj.setDefault('template_name');
            
            obj.addOutput(Output.ElementItem('patch2map',''));
            obj.addOutput(Output.ElementItem('head_patch',struct));
            obj.addOutput(Output.ElementItem('brain_patch',struct));
            obj.setPatch2Map();
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            if obj.stateChanged('show_head') || obj.stateChanged('show_on_head')
                obj.setPatch2Map();
            end
            
            patch2map = obj.getState(obj.getState('patch2map'));
%             [obj.stateOk('patch2map') obj.stateOk('xyz') obj.stateChanged('patch2map') obj.stateChanged('xyz')]
            if (obj.stateOk('patch2map') && obj.stateOk('xyz')) && (obj.stateChanged('patch2map') || obj.stateChanged('xyz'))
%                 coord_type = ifel(obj.getState('show_on_head'),'head','brain');
%                 disp('Calculating interp_x');
                for n = Iter(obj.getState('xyz').ids)
                    xyz = obj.getFromState('xyz',n);
                    
                    x = [];
                    for j = 1:size(xyz,1)
                        x = [x; createVoxelSphere(xyz(j,:),20)];
                    end
                    x = unique(round(x),'rows');

                    [~,x] = voxelOverlap(patch2map.vertices,x);
                    obj.verts2color(n) = findVoxel22(patch2map.vertices,x);
                    obj.interp_x(n) = x;
                end
            end
            
            if (obj.stateOk('patch2map') && obj.stateOk('xyz') && obj.stateOk('values')) && (obj.stateChanged('patch2map') || obj.stateChanged('xyz') || obj.stateChanged('values'))
%             if obj.statesOkAndChanged('patch2map','values','xyz')
%                 disp('interpolating and coloring...');
                for n = Iter(obj.getState('xyz').ids)
                    vals = obj.getFromState('values',n);
                    obj.interp_y(n) = interpolateRbf(obj.interp_x(n),obj.getFromState('xyz',n),vals(:),@(r) exp(-(r/20).^2));
                end
                
                cdata = 0.6*ones(size(patch2map.vertices,1),3);
                for n = Iter(obj.getState('xyz').ids)
                    cdata(obj.verts2color(n),:) = getColorList(obj.interp_y(n),obj.getState('color_map'),obj.getState('color_limit'));
                end
                patch2map.FaceVertexCData = cdata;
                patch2map.FaceColor = 'interp';
            end
            obj.setOutput(obj.getState('patch2map'),patch2map);
        end
        
        function setPatch2Map(obj)
            if obj.stateOk('template_name')
                if obj.getState('show_head') || obj.getState('show_on_head')
                    obj.setOutput('head_patch',obj.loadPatch('head'));
                else
                    obj.setUnset('head_patch');
                end
                
                if obj.getState('show_head')
                    hp = obj.getState('head_patch');
                    hp.FaceAlpha = 0.2;
                    obj.setOutput('head_patch',hp);
                end
                
                if ~obj.getState('show_on_head')
                    obj.setOutput('brain_patch',obj.loadPatch('brain'));
                    patch2map = 'brain_patch';
                else
                    obj.setUnset('brain_patch');
                    patch2map = 'head_patch';
                end

                obj.setOutput('patch2map',patch2map);
            end
        end
        
        function pd = loadPatch(obj,type)
            mfile_path = fileparts(mfilename('fullpath'));
            pd = load(fullfile(mfile_path,'..','..','brainprobeset','templates',sprintf('%s.mat',obj.getState('template_name'))),[type '_patch']);
            pd = pd.([type '_patch']);
            pd.FaceLighting = 'phong';
            pd.EdgeColor = 'none';
            pd.SpecularColorReflectance = 0;
            pd.SpecularExponent = 5;
            pd.SpecularStrength = 0.2;
        end
        
    end
end