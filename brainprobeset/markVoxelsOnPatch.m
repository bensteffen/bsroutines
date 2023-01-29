function markVoxelsOnPatch(patch_handle,vxs,color)

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
    % Date: 2012-10-18 16:32:35
    % Packaged: 2017-04-27 17:57:55
vertices = get(patch_handle,'Vertices');
vertices_number = size(vertices,1);

i_patch = findVoxel2(vertices,vxs);
i_patch = i_patch(i_patch ~= 0);

color_data = get(patch_handle,'FaceVertexCData');
if isempty(color_data)
    color_data = repmat(get(patch_handle,'FaceColor'),[vertices_number 1]);
end
color_data(i_patch,:) = repmat(color,[length(i_patch) 1]);

set(patch_handle,'FaceColor',[0.5 0.5 0.5],'SpecularColorReflectance',0.3,'EdgeColor','none');
set(patch_handle,'FaceColor','interp');
set(patch_handle,'FaceVertexCData',color_data);