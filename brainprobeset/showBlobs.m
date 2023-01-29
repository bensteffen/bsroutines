%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 20-Jan-2012 19:38:34


function showBlobs(values,coord_data,varargin)

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
    % Date: 2012-11-16 14:37:17
    % Packaged: 2017-04-27 17:57:56
param_defaults.color_map = jet(64);
param_defaults.color_limit = [];
param_defaults.show_probeset = false;
param_defaults.show_head = false;
param_defaults.radius_scale = 1;
[prop_names prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

if ~iscell(values)
    values = {values};
end

if ~iscell(coord_data)
    coord_data = {coord_data};
end



load('brain_patch_MRIcro_ch2bet.mat');
pb = patch(brain_patch);
set(pb,'FaceColor',[0.5 0.5 0.5],'SpecularColorReflectance',0.3,'EdgeColor','none');
hold on;

if show_head
    load('head_patch_MRIcro_ch2.mat');
    ph = patch(head_patch);
    set(ph,'FaceColor',[0.3 0.3 0.3],'SpecularColorReflectance',0,'EdgeColor','none');
    set(ph,'FaceAlpha',0.15);
end

view(60,15);
lighting phong;
box off;

set(gca,'DataAspectRatio',[1 1 1]);

h = gcf;
set(h,'Renderer','opengl');

val_vec = [];
for n = 1:numel(values)
    val_vec = [val_vec; values{n}(:)];
    vnumber(n) = numel(values{n});
end
colors = getColorList(val_vec,color_map,color_limit);

for n = 1:numel(values)
    if coord_data{n}.ch_number ~= vnumber(n)
        error('showBlobs: Value number (%d) must be be equal to channel number (%d)',vnumber(n),coord_data{n}.ch_number);
    end
    for i = 1:coord_data{n}.ch_number
        markPointOnPatch(pb,coord_data{n}.chs(i).brain_coords,radius_scale*coord_data{n}.chs(i).radius,colors((n-1)*vnumber(n) + i,:));
        if show_probeset
            patch(coord_data{n}.chs(i).text_patch);
        end
    end
end

setCamlightDirection(coord_data);