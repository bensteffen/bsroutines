function distance = distanceOnSurface(p1,p2,vertices,voxel_size)

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
    % Date: 2012-01-16 18:24:13
    % Packaged: 2017-04-27 17:58:39
global path
p = p1;
p_last = p;
path = p;
distance = 0;
dir = (p2 - p1).*voxel_size;
dir = dir/norm(dir);
while ~isequal(p,p2)
    p
    p_nbh = voxelNeighbourhood(p)
    i_delete = false(26,1);
    i_delete(findVoxel(p_nbh,p_last)) = 1;
    for i = 1:26
        if isempty(findVoxel(vertices,p_nbh(i,:)))
            i_delete(i) = 1;
        end
    end
    p_nbh(i_delete,:) = [];
    
    [~, projections] = nextVoxel(p,voxel_size,dir);
    projections(i_delete) = [];
    i_max = find(projections == max(projections));
    p_next = p_nbh(i_max(1),:);
    p = p_next;
    path = [path; p];
end