function n = patchvertnormals(p,i_verts)

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
    % Date: 2015-01-09 14:40:58
    % Packaged: 2017-04-27 17:58:15
if nargin < 2
    i_verts = (1:size(p.faces,1))';
end

% only for triangular represented patches

n = deal(zeros(length(i_verts),3));

for i = 1:length(i_verts)
    iv = i_verts(i);
    v1 = p.vertices(iv,:);
    i_faces = find(any(p.faces == iv,2));
    nf = length(i_faces);
    curr_normals = zeros(nf,3);
    if nf > 0
        for f = 1:nf
            curr_face = p.faces(i_faces(f),:);
            curr_face(curr_face == iv) = [];
            [v2,v3] = deal(p.vertices(curr_face(1),:),p.vertices(curr_face(2),:));
            curr_normals(f,:) = cross(v2-v1,v3-v1);
        end
        n(i,:) = normvec(mean(curr_normals,1));
        if dot(v1,n(i,:)) < 0
            n(i,:) = -n(i,:);
        end
    end
end