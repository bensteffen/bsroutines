function [edge_xy,edge_values] = mapChannelEdges(edge_matrix,channel_matrix,optode_distance)

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
    % Date: 2014-02-26 17:48:24
    % Packaged: 2017-04-27 17:58:49
chxy = showProbeset(channel_matrix,optode_distance);

edge_vxs = trimxindices(size(edge_matrix,1),'lower');
edgeids = voxel2index(edge_vxs,size(edge_matrix));
edge_handles = zeros(length(edgeids));
edge_values = edge_matrix(edgeids);
edge_colors = getColorList(edge_values);

for e = 1:length(edgeids)
    edge_nodes = edge_vxs(e,:);
    exy = [chxy(edge_nodes(1),:) chxy(edge_nodes(2),:)];
    if edge_values(e) ~= 0
        edge_handles(e) = line(exy([1 3]),exy([2 4]),'LineWidth',3,'Color',edge_colors(e,:));
    end
end