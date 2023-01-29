function p = interptrifaces(p,faces2interp)

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
    % Date: 2015-01-07 12:46:02
    % Packaged: 2017-04-27 17:58:11
n = length(faces2interp);
vn = size(p.vertices,1);
vip = zeros(n,3);
fip = zeros(3*n,3);
iface = 3*[(0:n-1)' (1:n)'] + repmat([1 0],[n 1]);
for i = 1:n
    vip(i,:) = mean(p.vertices(p.faces(faces2interp(i),:),:),1);
    f = p.faces(faces2interp(i),:);
    fip(iface(i,1):iface(i,2),:) = [f([1 2; 1 3; 2 3]) repmat(vn+i,[3 1])];
end

p.faces(faces2interp,:) = [];

p.vertices = [p.vertices; vip];
p.faces = [p.faces; fip];