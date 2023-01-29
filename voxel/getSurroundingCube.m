function C = getSurroundingCube(X,margin)

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
    % Date: 2012-11-19 18:01:15
    % Packaged: 2017-04-27 17:58:40
if nargin < 2
    margin = 0;
end

ctr = mean(X,1);
X = apptrans(X,createTransMat('offset',ctr));


[eig_vecs,eig_vals] = eig(cov(X));

corners = zeros(3,2);

for i = 1:3
    proj = dot(repmat(eig_vecs(:,i)',[size(X,1) 1]),X,2);
    corners(i,:) = [floor(min(proj))-margin ceil(max(proj))+margin];
end

[x,y,z] = meshgrid(corners(1,1):0.8:corners(1,2),corners(2,1):0.8:corners(2,2),corners(3,1):0.8:corners(3,2));
C = apptrans([x(:) y(:) z(:)],createTransMat('offset',-ctr,'rotation',eig_vecs));
C = unique(C,'rows');