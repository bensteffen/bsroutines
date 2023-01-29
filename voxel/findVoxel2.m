function [I,C] = findVoxel2(C,vxs2find)

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
    % Date: 2012-11-19 19:01:23
    % Packaged: 2017-04-27 17:58:40
n = size(vxs2find,1);
m = min(C);
C = C - repmat(m,[size(C,1) 1]) + 1;
d = findDimension(C);
vxs2find = vxs2find - repmat(m,[n 1]) + 1;
voxel_test = voxeltest(vxs2find,d);


C = voxel2index(C,d);
vxs2find = voxel2index(vxs2find,d);

I = zeros(n,1);
for i = find(voxel_test)'
    findex = find(C == vxs2find(i,:));
    if ~isempty(findex)
        I(i) = findex;
    end
end