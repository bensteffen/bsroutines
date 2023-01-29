function [edge_mx,edge_index,node_index,node_edgemx_vxs] = edgemx(mx_dim)

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
    % Date: 2015-02-25 17:25:03
    % Packaged: 2017-04-27 17:58:07
edge_dim = 2*mx_dim - 1;
edge_index = (2:2:prod(edge_dim))';
edgen = length(edge_index);
edge_vx = index2voxel(edge_index,edge_dim);

n = volume2voxel(ones(mx_dim)) - 1;
n = 2*n + 1;
node_edgemx_vxs = n;
n = voxel2index(n,edge_dim);



edge_mx = NaN(edge_dim);
edge_mx(edge_index) = 1:edgen;
edge_mx(n) = 1:length(n);

node_index = zeros(edgen,2);
for i = 1:length(edge_index)
    [curr_row,curr_col] = deal(edge_vx(i,1),edge_vx(i,2));
    if mod(curr_col,2) == 1
        node_index(i,1) = edge_mx(curr_row-1,curr_col);
        node_index(i,2) = edge_mx(curr_row+1,curr_col);
    else
        node_index(i,1) = edge_mx(curr_row,curr_col-1);
        node_index(i,2) = edge_mx(curr_row,curr_col+1);
    end
end