function [next_vx,projection] = nextVoxel(vx,vx_size,dir_vec)

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
    % Date: 2015-02-25 13:49:38
    % Packaged: 2017-04-27 17:58:40
dir_vec = dir_vec(:);
dir_vec = dir_vec/norm(dir_vec);

vx_nbh = voxelNeighbourhood(vx).*repmat(vx_size,[26 1]);

directions = vx_nbh - repmat(vx,[26 1]);
for i = 1:26
    n = norm(directions(i,:));
    directions(i,:) = directions(i,:)/n;
end

projection = directions*dir_vec;
next_vx = vx_nbh(projection == max(projection),:);