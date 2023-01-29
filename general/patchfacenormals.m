function [n,x] = patchfacenormals(p,i_faces)

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
    % Date: 2015-01-09 17:52:44
    % Packaged: 2017-04-27 17:58:15
if nargin < 2
    i_faces = (1:size(p.faces,1))';
end

% only for triangular represented patches

[n,x] = deal(zeros(length(i_faces),3));

for i = 1:length(i_faces)
    [f1,f2,f3] = deal(p.faces(i_faces(i),1),p.faces(i_faces(i),2),p.faces(i_faces(i),3));
    [v1,v2,v3] = deal(p.vertices(f1,:),p.vertices(f2,:),p.vertices(f3,:));
    n(i,:) = normvec(cross(v2-v1,v3-v1));
    x(i,:) = mean([v1;v2;v3]);
    if dot(x(i,:),n(i,:)) < 0
        n(i,:) = -n(i,:);
    end
end
