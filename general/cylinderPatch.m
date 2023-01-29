function cyl = cylinderPatch(r,h,varargin)

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
    % Date: 2015-10-20 15:32:51
    % Packaged: 2017-04-27 17:58:07
dphi = 0.05;
phi = (dphi:dphi:2*pi)';

c = [0 0; r*cos(phi) r*sin(phi)];
n = size(c,1);
cyl.vertices = [c 0*ones(n,1); c h*ones(n,1)];

f = [ones(n-2,1) (2:n-1)' (3:n)'; 1 n 2];
f1 = f;
f2 = f + n;
f3 = [(1:n-1)' (2:n)' (1:n-1)'+n];
f4 = [(1:n-1)'+n (2:n)'+n (1:n-1)'];

cyl.faces = [f1;f2;f3;f4];

for i = 1:2:length(varargin)-1
    cyl.(varargin{i}) = varargin{i+1};
end