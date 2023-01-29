function p = vals2patch(x,vals,cmap,ylim,varargin)

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
    % Date: 2015-01-23 14:04:44
    % Packaged: 2017-04-27 17:58:20
vals = vals(:);
nv = 2*(numel(vals)+1);


y = repmat(ylim(:),[1 nv/2]);

x = x(:);
x0 = x(1);

x = x + [diff(x)/2; 0];
x = [x0;x];
x = [x'; x'];

p.Vertices = [x(:) y(:)];
p.Faces = [1:2:nv-3; 3:2:nv-1; 4:2:nv; 2:2:nv-2]';
p.FaceColor = 'flat';
p.FaceVertexCData = getColorList(vals,cmap);
p.EdgeColor = 'none';

for i = 1:2:numel(varargin)
    p.(varargin{i}) = varargin{i+1};
end