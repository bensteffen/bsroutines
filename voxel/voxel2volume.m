function [V,offset] = voxel2volume(vxs,vals,dim)

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
    % Date: 2015-09-28 12:18:43
    % Packaged: 2017-04-27 17:58:41
if nargin < 3
    offset = min(vxs);
    vxs = vxs - repmat(offset,[size(vxs,1) 1]) + 1;
    dim = findDimension(vxs);
else
    offset = zeros(1,numel(dim));
end

if nargin < 2
    vals = [];
end


V = zeros(prod(dim),1);
if isempty(vals)
    V(voxel2index(vxs,dim)) = 1;
else
    V(voxel2index(vxs,dim)) = vals(:);
end
V = reshape(V,dim);