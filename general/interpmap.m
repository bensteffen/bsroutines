function map = interpmap(mapdim,dxy,xy,vals,mu)

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
    % Date: 2014-02-21 22:03:15
    % Packaged: 2017-04-27 17:58:11
[X,Y] = meshgrid(mapdim(1,1):dxy:mapdim(1,2),mapdim(2,1):dxy:mapdim(2,2));
XY = [Y(:) X(:)];

yint = interpolateRbf(XY,fliplr(xy),vals,@(r) exp(-(r/mu).^2));

map = zeros(size(X));
xy = xy + 1
map(voxel2index(xy,size(X))) = vals;

% [i,s] = normvoxels(XY);
% i = voxel2index(i,s);
% map(i) = yint;

imagesc(map); axis xy