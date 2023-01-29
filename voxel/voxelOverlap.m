function [vx_index,vx_overlap] = voxelOverlap(vx1,vx2)

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
    % Date: 2016-04-06 10:30:16
    % Packaged: 2017-04-27 17:58:42
dim = findDimension(vx1);
min_vx1 = minVoxel(vx1);
vx1 = transformToOrigin(vx1) + 1;
vx1 = voxelList2volume(vx1,dim);
% vx1 = voxel2volume(vx1);

vx2 = vx2 - repmat(min_vx1,[size(vx2,1) 1]) + 1;
% vx2 = vx2(volumeIndexTest(vx2,dim),:);
vx2 = vx2(voxeltest(vx2,dim),:);
if ~isempty(vx2)
    min_vx2 = minVoxel(vx2);
    max_vx2 = maxVoxel(vx2);
    dim_vx2 = findDimension(vx2);
    vx2 = transformToOrigin(vx2) + 1;
    vx2 = voxelList2volume(vx2,dim_vx2);
    
    vx_overlap = find(vx1(min_vx2(1):max_vx2(1),min_vx2(2):max_vx2(2),min_vx2(3):max_vx2(3)).*vx2);
    if isempty(vx_overlap)
        vx_index = [];
        return;
    end
    vx_overlap = listIndex2voxel(vx_overlap,dim_vx2);
    vx_overlap = vx_overlap + repmat(min_vx2,[size(vx_overlap,1) 1]) - 1;
    vx_index = voxel2listIndex(vx_overlap,dim);
    vx_overlap = vx_overlap + repmat(min_vx1,[size(vx_overlap,1) 1]) - 1;
else
    vx_index = [];
    vx_overlap = [];
end