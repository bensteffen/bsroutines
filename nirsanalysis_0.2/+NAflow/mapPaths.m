function edge_countmx = mapPaths(path_vals,paths,channel_matrix,optode_distance)

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
    % Date: 2014-03-13 09:22:37
    % Packaged: 2017-04-27 17:58:49
chxy = NAps.showProbeset(channel_matrix,optode_distance);

chn = sum(~isnan(channel_matrix(:)));
pathn = length(path_vals);
edge_countmx = zeros(chn);
edge_valmx = zeros(chn);

for p = 1:size(paths)
    for e = 1:size(paths,2)-1
        nodes = [paths(p,e) paths(p,e+1)];
        edge_countmx(nodes(1),nodes(2)) = edge_countmx(nodes(1),nodes(2)) + 1;
        edge_valmx(nodes(1),nodes(2)) = edge_valmx(nodes(1),nodes(2)) + path_vals(p)/pathn;
    end
end

[edge_nodes,edge_counts] = NAflow.findEdgeMatrix(edge_countmx,'lower');
[~,edge_vals] = NAflow.findEdgeMatrix(edge_valmx,'lower');

line_widths = scale2interval(edge_counts,[1 10]);
line_colors = getColorList(edge_vals,createColormap([0 0 1; 1 1 1; 1 0 0]));

for e = 1:length(edge_nodes)
    edge_xy = [chxy(edge_nodes(e,1),:) chxy(edge_nodes(e,2),:)];
    line(edge_xy([1 3]),edge_xy([2 4]),'LineWidth',line_widths(e),'Color',line_colors(e,:));
end