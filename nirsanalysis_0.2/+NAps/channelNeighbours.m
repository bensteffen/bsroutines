function nbs = channelNeighbours(chmx,chid,exclude_borders)

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
    % Date: 2016-07-08 11:21:18
    % Packaged: 2017-04-27 17:58:52
if nargin < 3
    exclude_borders = true;
end

s = size(chmx);
[i,j] = find(chmx == chid);
nbs = hexagonalneighbours([i j]);
nbs = [i-2 j; nbs(1:3,:); i+2 j; nbs(4:6,:)];
if exclude_borders
    nbs = nbs(voxeltest(nbs,s),:);
    nbs = chmx(voxel2index(nbs,s));
else
    nbs_vxs = nbs;
    nbs = NaN(vxn(nbs_vxs),1);
    outof_border = ~voxeltest(nbs_vxs,s);
    nbs(~outof_border,:) = chmx(voxel2index(nbs_vxs(~outof_border,:),s));
end