function i = findVoxel22(vxs0,vxs1)

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
    % Date: 2015-10-02 11:12:08
    % Packaged: 2017-04-27 17:58:40
[vxs1,s1,vxs0] = normvoxels(vxs1,ones(1,vxd(vxs0)),vxs0);

[m0,m1] = deal(zeros(prod(s1),1));

i1 = voxel2index(vxs1,s1);
m1(i1) = 1:length(i1);

ok = voxeltest(vxs0,s1);
i0 = [(1:vxn(vxs0))' voxel2index(vxs0,s1)];

m0(i0(ok,2)) = i0(ok,1);
p = (m0 > 0) & (m1 > 0);

i = zeros(vxn(vxs1),1);
i(m1(p)) = m0(p);