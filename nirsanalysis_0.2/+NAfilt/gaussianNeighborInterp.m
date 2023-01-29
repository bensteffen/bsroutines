function X = gaussianNeighborInterp(X,coords,chs2interp)

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
    % Date: 2017-03-01 16:03:28
    % Packaged: 2017-04-27 17:58:47
X0 = X;

n = size(X,1);
d = voxelDistance(coords);
u = min(d(d > 0)); 

chs2interp = chs2interp(:)';
remaining_chs = exclude(1:size(X,2),chs2interp);
for ch2i = chs2interp
    weights = exp(-(voxelDistance(coords,coords(ch2i,:),[1 1])).^2/(2*u^2))';
    weights = weights(remaining_chs);
    weights = weights/sum(weights);
    X(:,ch2i) = sum(X(:,remaining_chs).*repmat(weights,[n 1]),2);
end