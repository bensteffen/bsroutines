function i_area = voxelarea(vxs,nodes,radius,vx_size)

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
    % Date: 2016-04-27 18:25:56
    % Packaged: 2017-04-27 17:58:42
if nargin < 4
    vx_size = ones(1,vxd(vxs));
end

n = vxn(vxs);

[i_bound,i_area] = deal(true(n,1),false(n,1));

b1 = min(nodes) - round(radius./vx_size);
b2 = max(nodes) + round(radius./vx_size);
i_bound(any(vxs < repmat(b1,[n 1]),2)) = false;
i_bound(any(vxs > repmat(b2,[n 1]),2)) = false;

dmx = voxelDistance(nodes,vxs(i_bound,:),vx_size)';

i_area(i_bound) = any(dmx < radius,2);