function [sdch_id_topo,sdch_id_mes] = channelAssignment(sdmask,topo_layout_path)

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
    % Date: 2017-04-03 16:42:37
    % Packaged: 2017-04-27 17:58:51
sn = size(sdmask,1);
dn = size(sdmask,2);

topo_layout = NAio.nirx.analyzeTopoLayout(topo_layout_path);
chn = size(topo_layout,1);
[d,s] = find(sdmask');
sdch_id_mes = sortrows([sub2ind([sn dn],s,d) (1:chn)'],1);
sdch_id_topo = sortrows([sub2ind([sn dn],topo_layout(:,1),topo_layout(:,2)) (1:chn)'],1);