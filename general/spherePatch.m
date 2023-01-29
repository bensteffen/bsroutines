function sph = spherePatch(radius,center,varargin)

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
    % Date: 2017-01-06 16:53:09
    % Packaged: 2017-04-27 17:58:19
r = 20;
vxs = createVoxelSphere(r*ones(1,3)+1,r);

sph = voxel2patch(vxs,[]);

% s = (2*r + 2)*ones(1,3);
% vol = zeros(s);
% vol(voxel2index(vxs,s)) = 1;
% 
% sph = isosurface(vol,0);
% sph.vertices = [-sph.vertices(:,2) sph.vertices(:,1) sph.vertices(:,3)];
sph.vertices = sph.vertices - repmat(mean(sph.vertices),[size(sph.vertices,1) 1]);
sph.vertices = radius*sph.vertices/r;
sph.vertices = sph.vertices + repmat(center,[size(sph.vertices,1) 1]);
sph.EdgeColor = 'none';

for i = 1:2:numel(varargin)
    sph.(varargin{i}) = varargin{i+1};
end