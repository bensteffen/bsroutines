function mx = connectNeighbours(mx)

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
    % Date: 2013-04-04 18:15:41
    % Packaged: 2017-04-27 17:58:38
dim = size(mx);
[i,j] = find(mx);
[i,j] = deal(i',j');
ni = [i-1 i+1]; ni = ni(:);
nj = [j-1 j+1]; nj = nj(:);
[i,j] = deal([i i]',[j j]');

vxs = [ni j];
vxs = vxs(voxeltest(vxs,dim),:);
idx = voxel2index(vxs,dim);
tmp = zeros(dim);
for v = 1:length(idx)
    tmp(idx(v)) = tmp(idx(v)) + 0.5;
end
mx(tmp == 1) = 1;

vxs = [i nj];
vxs = vxs(voxeltest(vxs,dim),:);
idx = voxel2index(vxs,dim);
tmp = zeros(dim);
for v = 1:length(idx)
    tmp(idx(v)) = tmp(idx(v)) + 0.5;
end
mx(tmp == 1) = 1;