function [slice_vxs,slice_basis,slice_space_vxs] = slicevoxels(vxs,slice_offset,slice_basis,eps)

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
    % Date: 2015-09-11 16:14:16
    % Packaged: 2017-04-27 17:58:41
vxs = vxs - repmat(slice_offset,[size(vxs,1) 1]);
normal_vec = normvec(cross(slice_basis(1,:),slice_basis(2,:)));
p = sum(vxs.*repmat(normal_vec,[size(vxs,1) 1]),2);

slice_vxs = vxs(abs(p) < eps,:);
slice_vxs = slice_vxs + repmat(slice_offset,[size(slice_vxs,1) 1]);

slice_basis(2,:) = normvec(cross(slice_basis(1,:),normal_vec));
slice_basis = [slice_basis; normal_vec];

slice_space_vxs = slice_vxs*slice_basis';
% slice_space_vxs = slice_space_vxs(:,1:2);
% slice_space_vxs = slice_space_vxs(abs(p) < eps,:);