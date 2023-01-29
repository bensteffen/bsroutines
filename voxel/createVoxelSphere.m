function C = createVoxelSphere(M,R)

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
    % Date: 2013-03-04 18:21:30
    % Packaged: 2017-04-27 17:58:39
d = size(M,2);
S = ones(1,d)*(2*R+1);
C = zeros(S);

C(voxelDistance(index2voxel((1:numel(C))',S),repmat(R+1,[1 d]),ones(1,d)) <= (R - 0.5*sqrt(2))) = 1;
C = volume2voxel(C);
C = C + reprow(C,M(:)' - repmat(R+1,[1 d]));

% T = eye(4);
% T(1:3,4) = M(:)' - repmat(R+1,[1 3]);
% C = transformCoordList(C,T);