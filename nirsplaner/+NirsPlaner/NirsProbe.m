classdef NirsProbe < NirsPlaner.AbstractProbe
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
    % Date: 2017-04-26 16:58:31
    % Packaged: 2017-04-27 17:58:55
    methods
        function obj = NirsProbe(name,head_model_name)
            obj@NirsPlaner.AbstractProbe(name,head_model_name);
            
            ref_pr = Input.ElementItem('reference_probe_point','','' ...
                ,Input.Test(@ischar ...
                ,'Reference point name must be a string') ...
                );
            ref_hp = Input.ElementItem('reference_head_point',zeros(0,3),zeros(0,3) ...
                            ,Input.Test(@(x) isnumeric(x) && numel(x) == 3 ...
                            ,'Reference point name must be a string') ...
                            );
            ref_hd = Input.ElementItem('reference_head_direction',[1 0 0],[1 0 0] ...
                            ,Input.Test(@(x) isnumeric(x) && numel(x) == 3 ...
                            ,'Reference point name must be a string') ...
                            );
            ra = Input.ElementItem('rotation_angle',0,0 ...
                ,Input.Test(@(x) isnumscalar(x) ...
                ,'Rotation angle [degrees] must be a numeric scalar') ...
                );
            
            obj.addInput(ref_pr);
            obj.addInput(ref_hp);
            obj.addInput(ref_hd);
            obj.addInput(ra);
            
            obj.addOutput(Output.ElementItem('channel_xyz',containers.Map));
            obj.addOutput(Output.ElementItem('channel_xy',containers.Map));
            
            obj.view_factory.addInputView('reference_probe_point',@(id_)NirsPlaner.RefProbeSelection    (id_,obj,'reference_probe_point'));
            obj.view_factory.addInputView('reference_head_point' ,@(id_)NirsPlaner.RefHeadPointSelection(id_,obj,head_model_name));
        end
        
        function readCoordinateFile(obj,fname,dim_str)
%             probe_data = obj.getState('probe_data');
            probe_data = struct;
            fc = Iter(linewise(fname));
            for l = fc
                [~,e] = regexp(l,'^PR\w+');
                if ~isempty(e)
                    prid = l(3:e);
                    probe_data.(prid).(dim_str) = str2num(l(e+1:end));
                    if ~isfield(probe_data.(prid),'xy')
                        probe_data.(prid).xy = [];
                    end
                    if ~isfield(probe_data.(prid),'xyz')
                        probe_data.(prid).xyz = [];
                    end
                end
            end
            for l = fc
                [~,e] = regexp(l,'^CH\w+');
                if ~isempty(e)
                    chid = l(1:e);
                    [chx,optnames] = obj.calculateChannelPosition(probe_data,l(e+1:end),dim_str);
                    probe_data.(chid).(dim_str) = chx;
                    probe_data.(chid).probes = optnames;
                    if ~isfield(probe_data.(chid),'xy')
                        probe_data.(chid).xy = [];
                    end
                    if ~isfield(probe_data.(chid),'xyz')
                        probe_data.(chid).xyz = [];
                    end
                end
            end
            obj.setOutput('probe_data',probe_data);
            probe_names = fieldnames(probe_data);
            if ~any(strcmp(probe_names,obj.getState('reference_probe_point')))
                obj.setInput('reference_probe_point',probe_names{1});
            end
        end
        
        function updateCoordinates(obj)
%             if obj.statesOkAndChanged('probe_data','head_surface','reference_probe_point','reference_head_point','reference_direction','2d_coordinate_transformation')
%                 disp updateCoords
                head_model = obj.models.entry(obj.head_model_name);
                v = head_model.getState('head_patch');
                v = v.vertices;
                refpr = obj.getState('reference_probe_point');
                if isequal(obj.getState('reference_head_point'),zeros(0,3))
                    markers = head_model.getState('markers');
                    obj.setInput('reference_head_point',markers('C3'));
                end
                refhp = obj.getState('reference_head_point');
                refhd = obj.getState('reference_head_direction');
                probe_data = obj.getState('probe_data');
                
                p = nearestvoxel(refhp,v);
                p2d = probe_data.(refpr).xy;
                ra = obj.getState('rotation_angle');
                
                probe_data = obj.findXYZ(probe_data,v,p,p2d,refhd);
%                 probe_data = obj.findXYZ2(probe_data,v,p,p2d,ra);
                obj.setOutput('probe_data',probe_data);
                
                chs = regexpfind(fieldnames(probe_data),'CH','hits');
                d = struct2cell(probe_data); 
                obj.setOutput('channel_xyz',cell2mat(cellfun(@(x) x.xyz,d(chs),'UniformOutput',false)));
                obj.setOutput('channel_xy',cell2mat(cellfun(@(x) x.xy,d(chs),'UniformOutput',false)));
%             end
        end
    end
    
    methods(Access = 'protected',Static = true)
        function [x,opts] = calculateChannelPosition(prdat,s,dim_str)
            opts = regexp(deblank(s),'\s*','split');  opts = opts(2:end);
            x = [];
            for i = 1:length(opts)
                x = [x; prdat.(opts{i}).(dim_str)];
            end
            x = mean(x);
        end
        
        function pd = findXYZ(pd,surface_vxlist,p,p2d,refd1)
            refd2 = normvec(p);
            refd3 = normvec(cross(refd1,refd2));
            
            [~,bA,sA23] = slicevoxels(surface_vxlist,p,[refd1;refd2],0.5); sA2 = sA23(:,1:2);
            i_refx = find2di(p,sA2,bA);

            [xyzok,xyznok] = deal([]);
            
            for id = Iter(fieldnames(pd))
                x2d = pd.(id).xy(1)-p2d(1);
                xyz = (bA'*sA23(pointalongcurve(sA2,i_refx,x2d),:)')';
                
                refd2 = normvec(xyz);
%                 refd3 = normvec(cross(refd1,refd2));r
                
%                 if any(strcmp(id,{'e11','CH01','CH11','d16','CH22','CH32'}))
%                     refd3 = -refd3;
%                 end

                [~,bB,sB23] = slicevoxels(surface_vxlist,xyz,[refd2;refd3],0.5); sB2 = sB23(:,1:2);
                i_refy = find2di(xyz,sB2,bB);

                y2d = pd.(id).xy(2)-p2d(2);
                pd.(id).xyz = (bB'*sB23(pointalongcurve(sB2,i_refy,-y2d),:)')';
            end
        end
        
        function pd = findXYZ2(pd,surface_vxlist,p,p2d,rot_ang)
            b3 = getBrainTangentials(p);
            t = [b3(:,2) -b3(:,1)];
            n = -b3(:,3);
            for id = Iter(fieldnames(pd))
                xy = pd.(id).xy-p2d;
                xy = rotmx(deg2rad(rot_ang))*xy';
%                 delta3d = (b3*[xy;0])';
                delta3d = (t*xy)';
                hold on;
%                 xyz = delta3d + p;
%                 patch(spherePatch(2.5,xyz));
%                 scatt3(xyz);
                l = norm(delta3d);
                if l == 0
                    pd.(id).xyz = p;
                else
%                     d = delta3d/l;
%                     [~,bA,sA23] = slicevoxels(surface_vxlist,p,[d;-n'],0.5); sA2 = sA23(:,1:2);
%                     i_refx = find2di(p,sA2,bA);
%                     pd.(id).xyz = (bA'*sA23(pointalongcurve(sA2,i_refx,l),:)')';
                    [~,bA,sA23] = slicevoxels(surface_vxlist,p,[t(:,1)';-n'],0.5); sA2 = sA23(:,1:2);
                    i = find2di(p,sA2,bA);
                    p_tmp = (bA'*sA23(pointalongcurve(sA2,i,xy(1)),:)')';
                    
                    
                    b3 = getBrainTangentials(p_tmp);
                    t = [b3(:,2) -b3(:,1)];
                    n = -b3(:,3);
                    
                    [~,bA,sA23] = slicevoxels(surface_vxlist,p_tmp,[t(:,2)';-n'],0.5); sA2 = sA23(:,1:2);
                    i = find2di(p_tmp,sA2,bA);
                    pd.(id).xyz = (bA'*sA23(pointalongcurve(sA2,i,xy(2)),:)')';
                end
            end
        end
    end
end