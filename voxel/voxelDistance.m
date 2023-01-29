function d = voxelDistance(vx_list,vx,vx_size)

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
    % Date: 2017-02-28 11:52:07
    % Packaged: 2017-04-27 17:58:41
if nargin < 2
    vx = vx_list;
end

if nargin < 3
    vx_size = ones(1,vxd(vx_list));
end

d = zeros(vxn(vx_list),vxn(vx));

nvx = size(vx_list,1);

if all(vx_size == 1)
    for j = 1:vxn(vx)
        delta = (vx_list - repmat(vx(j,:),[nvx 1]));
        d(:,j) = sqrt(sum(delta.^2,2));
    end
else
    for j = 1:vxn(vx)
        delta = (vx_list - repmat(vx(j,:),[nvx 1])).*repmat(vx_size,[nvx 1]);
        d(:,j) = sqrt(sum(delta.^2,2));
    end
end