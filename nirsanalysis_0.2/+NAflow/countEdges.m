function count_matrix = countEdges(channel_paths,channel_number)

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
    % Date: 2014-02-21 23:43:08
    % Packaged: 2017-04-27 17:58:48
count_matrix = zeros(channel_number);
path_number = size(channel_paths,1);
edge_number = size(channel_paths,2) - 1;

for p = 1:size(channel_paths,1)
    for e = 1:edge_number
        edge_nodes = [channel_paths(p,e) channel_paths(p,e+1)];
        i = voxel2index(edge_nodes,[channel_number channel_number]);
        count_matrix(i) = count_matrix(i) + 1;
    end
end