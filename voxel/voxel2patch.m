function p = voxel2patch(vxs,smooth_k,varargin)

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
    % Date: 2016-04-06 10:51:27
    % Packaged: 2017-04-27 17:58:41
if nargin < 2
    smooth_k = [];
end

vxs = [vxs(:,2) vxs(:,1) vxs(:,3)];

m = min(vxs) - 2;
M = max(vxs) + 2;

[X,Y,Z] = meshgrid(m(2):M(2),m(1):M(1),m(3):M(3));
vxs = [m; vxs; M];
V = voxel2volume(vxs);
V([1 end]) = 0;

if isempty(smooth_k)
    p = isosurface(X,Y,Z,V,0);
else
    V = smooth3(V,'gaussian',ones(1,3)*smooth_k);
    p = isosurface(X,Y,Z,V,0.1);
end

for j = 1:2:numel(varargin)
    p.(varargin{j}) = varargin{j+1};
end