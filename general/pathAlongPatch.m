function path = pathAlongPatch(patch_struct,x0,start_direction,path_length)


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
    % Date: 2016-12-13 14:50:03
    % Packaged: 2017-04-27 17:58:15
hood = VertexHood(patch_struct);

[x0,curr_vertex_id] = nearestvoxel(x0,patch_struct.vertices);
curr_direction = start_direction;

path = x0;
directions = curr_direction;
step_number = 0;

while path_length > 0
    step_number = step_number + 1;
    
    hood = hood.setVertexId(curr_vertex_id);
    x0 = hood.vertex_x;
    t0 = hood.vertexNormal();

    next_vertex_id = hood.nextNeighbor(curr_direction);
    hood = hood.setVertexId(next_vertex_id);
    x1 = hood.vertex_x;
    t1 = hood.vertexNormal();

    step_length = norm(x1 - x0);
    path_length = path_length - step_length;

    curr_vertex_id = next_vertex_id;
    
    direction_change = t1 - t0;
    if norm(direction_change) > 0.001
        direction_change = [0 0 0];
    end
    next_direction = normvec(curr_direction + direction_change);
    directions = cat(1,directions,next_direction);
    curr_direction = mean(directions(max(1,step_number-100):step_number,:),1);
    
    path = cat(1,path,x1);
end