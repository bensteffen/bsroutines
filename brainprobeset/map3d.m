function ph = map3d(values,chdata,varargin)

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
    % Date: 2016-09-12 13:19:13
    % Packaged: 2017-04-27 17:57:55
values = ifel(iscell(values),values,{values});
chdata = ifel(iscell(chdata),chdata,{chdata});

param_defaults.map_type = 'map';
param_defaults.map_title = '';
param_defaults.color_map = jet(64);
param_defaults.color_limit = [];
param_defaults.show_probeset = false;
param_defaults.show_brain = true;
param_defaults.show_head = false;
param_defaults.show_on_head = false;
param_defaults.axes_handle = [];
param_defaults.significance = 0;
param_defaults.template_name = 'Colin27';
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

if ~iscell(significance)
    significance = ifel(iscell(significance),significance,{significance});
end
if isempty(axes_handle)
    axes_handle = gca;
end
coord_type = ifel(show_on_head,'head','brain');
show_head = ifel(show_on_head,true,show_head);

template_dir = fullfile(fileparts(mfilename('fullpath')),'templates');

if show_head
    load(fullfile(template_dir,[template_name '.mat']),'head_patch');
end

if show_on_head
    patch2map = head_patch;
else
    load(fullfile(template_dir,[template_name '.mat']),'brain_patch');
    patch2map = brain_patch;
end

for p = 1:length(values)
    ids = cell2num(valueat(struct2cell(chdata{p}.chs),1,1));
    values{p} = values{p}(ids);
    vals = values{p};
    mapdata(p).point_number = chdata{p}.ch_number;
    mapdata(p).id = cell(mapdata(p).point_number,1);
    mapdata(p).xyz = zeros(mapdata(p).point_number,3);
    mapdata(p).val = zeros(mapdata(p).point_number,1);
%     mapdata(p).rad = zeros(mapdata(p).point_number,1);
    for j = 1:mapdata(p).point_number
        mapdata(p).id{j} = num2str(chdata{p}.chs(j).id);
        mapdata(p).xyz(j,:) = chdata{p}.chs(j).([coord_type '_coords']);
        mapdata(p).val(j) = vals(j);
%         mapdata(p).rad(j) = chdata{p}.chs(j).radius;
    end
end

switch map_type
    case 'blobs'
        verts2color = blobColorData(patch2map,mapdata);
    case 'map'
        verts2color = mapColorData(patch2map,mapdata);
end

patch2map.FaceVertexCData = 0.6*ones(size(patch2map.vertices,1),3);
if ~isempty(verts2color)
    patch2map.FaceVertexCData(verts2color(:,1),:) = getColorList(verts2color(:,2),color_map,color_limit);
end
patch2map.FaceColor = 'interp';
patch2map.FaceLighting = 'phong';
patch2map.EdgeColor = 'none';
patch2map.SpecularColorReflectance = 0;
patch2map.SpecularExponent = 5;
patch2map.SpecularStrength = 0.2;

if show_on_head && show_brain
    patch2map.SpecularStrength = 0.15;
end

[lim.low,lim.up] = deal(min(patch2map.vertices),max(patch2map.vertices));
ph = patch(patch2map,'Parent',axes_handle);

if ~show_on_head && show_head
    head_patch.FaceColor = [0.3 0.3 0.3];
    head_patch.FaceLighting = 'phong';
    head_patch.SpecularColorReflectance = 0;
    head_patch.EdgeColor = 'none';
    head_patch.FaceAlpha = 0.15;
    patch(head_patch,'Parent',axes_handle);
    [lim.low,lim.up] = deal(min(head_patch.vertices),max(head_patch.vertices));
end



brainlight(axes_handle);
set(gcf,'Renderer','opengl');

if show_probeset
    txtp = [];
    for p = 1:length(mapdata)
        curr_sig = significance{p};
        [sig_i,nonsig_i] = deal([]);
        for i = 1:length(mapdata(p).id)
            chnum = str2num(mapdata(p).id{i});
            if any(chnum == curr_sig)
                sig_i = [sig_i;i];
            else
                nonsig_i = [nonsig_i;i];
            end
        end
        surf_offset = 4;
        if strcmp(coord_type,'head')
            surf_offset = surf_offset + 5;
        end
        
%         txtp = [txtp; writeNumberOnBrain(mapdata(p).xyz(sig_i,:),mapdata(p).id(sig_i),'axes_handle',axes_handle,'text_color',[0 1 0])]; % lila = [0.7 0 1], tuerkis = [0.3 1 1]
        txtp = [txtp; writeNumberOnBrain(mapdata(p).xyz(sig_i,:),mapdata(p).id(sig_i),'axes_handle',axes_handle,'text_color','k','text_scale',0.3,'surface_offset',surf_offset+0.25)];
        
%         txtp = [txtp; writeNumberOnBrain(mapdata(p).xyz(nonsig_i,:),mapdata(p).id(sig_i),'axes_handle',axes_handle,'text_color','k')]; % lila = [0.7 0 1], tuerkis = [0.3 1 1]
        txtp = [txtp; writeNumberOnBrain(mapdata(p).xyz(nonsig_i,:),mapdata(p).id(nonsig_i),'axes_handle',axes_handle,'text_color',[0.8 0.8 0.8],'text_scale',0.25,'surface_offset',surf_offset-0.25)];
    end
    
    lim.low = [lim.low; cell2mat(nonunicfun(@min,get(txtp,'Vertices')))];
    lim.up = [lim.up; cell2mat(nonunicfun(@max,get(txtp,'Vertices')))];
    lims = [min(lim.low)' max(lim.up)'];
else
    lims = [lim.low' lim.up'];
end

% set(axes_handle,'Xlim',[lim.low(1) lim.up(1)],'YLim',[lim.low(2) lim.up(2)],'ZLim',[lim.low(3) lim.up(3)],'DataAspectRatio',[1 1 1],'Visible','off');
set(axes_handle,'Xlim',lims(1,:),'YLim',lims(2,:),'ZLim',lims(3,:),'DataAspectRatio',[1 1 1],'Visible','off');

