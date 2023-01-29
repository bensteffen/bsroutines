function [N,NX] = facenormals(p,face_ids)

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
    % Date: 2016-12-12 18:44:35
    % Packaged: 2017-04-27 17:58:08
if nargin < 2
    face_ids = 1:size(p.faces,1);
end
face_ids = face_ids(:)';
face_it = Iter(face_ids);

[N,NX] = deal(zeros(face_it.n,3));
for f = face_it
    i = p.faces(f,:);
    tr = p.vertices(i,:);
    [v0,v1,v2] = deal(tr(1,:),tr(2,:),tr(3,:));
    n = normvec(cross(v1-v0,v2-v0));
    nx = mean(tr);

    N(face_it.i,:) = sign(dot(nx,n))*n;
    NX(face_it.i,:) = nx;
end