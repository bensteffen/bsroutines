function mx = rmdiag(mx,dim2reduce)

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
    % Date: 2016-06-21 16:13:16
    % Packaged: 2017-04-27 17:58:17
n = size(mx,1);
mx = mx(:);

switch dim2reduce
    case 1
        mx(diagIndices(n)) = [];
        mx = reshape(mx,[n-1 n]);
    case 2
        vxs = index2voxel((1:n^2)',[n n]);
        vxs(diagIndices(n),:) = [];
        mx = mx(voxel2index(fliplr(vxs),[n n]));
        mx = reshape(mx,[n-1 n])';
end
