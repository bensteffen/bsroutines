%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 15-Aug-2012 15:22:19


% function [scd scalp_th skull_th csf_th] = getScdFromSegmentedMRI(mr_path,skin_positions)
function depth = getScdFromSegmentedMRI(mr_path,skin_positions)
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
    % Date: 2013-01-21 18:09:50
    % Packaged: 2017-04-27 17:58:36
mr_path
mr_hdr = spm_vol(mr_path);
mr_img = floor(spm_read_vols(mr_hdr));
voxel_size = getVoxelSize(mr_hdr.mat);

R = 60;
L = repmat(R,[1 3])./voxel_size;

for p = 1:size(skin_positions,1)
    corners = adjustVoxel(reshape(round([skin_positions(p,:) - ceil(L/2) + 1 skin_positions(p,:) + floor(L/2)]'),[3 2])',mr_hdr.dim);

    [X,Y,Z] = meshgrid(corners(1,1):corners(2,1),corners(1,2):corners(2,2),corners(1,3):corners(2,3));
    vxs = [X(:) Y(:) Z(:)];


    depth_data = [voxelDistance(vxs,skin_positions(p,:),voxel_size) mr_img(voxel2listIndex(vxs,mr_hdr.dim))];

    matter_names = {'skull','csf','gray','white'};

    n = 10;
    for i = 1:4
        depth(p).(matter_names{i}) = sort(depth_data(depth_data(:,2) == i+1,1));
        l = length(depth(p).(matter_names{i}));
        if l < n
            if l > 0
                depth(p).(matter_names{i}) = median(depth(p).(matter_names{i})(1:l));
            else
                if i > 1
                    depth(p).(matter_names{i}) = depth(p).(matter_names{i-1});
                else
                    depth(p).(matter_names{i}) = 0;
                end
            end
        else
            depth(p).(matter_names{i}) = median(depth(p).(matter_names{i})(1:5));
        end
    end
end