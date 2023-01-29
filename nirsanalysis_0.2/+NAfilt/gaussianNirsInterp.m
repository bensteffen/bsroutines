function X = gaussianNirsInterp(X,probeset_matrix,chs2interp,opt_distance)

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
    % Date: 2014-10-07 10:43:00
    % Packaged: 2017-04-27 17:58:47
u = 0.5*opt_distance;
n = size(X,1);
chn = sum(~isnan(probeset_matrix(:)));
Lx = size(probeset_matrix,2);
Ly = size(probeset_matrix,1);
[x,y] = meshgrid(0:Lx-1,0:Ly-1);
x = u*x;
y = u*y;

chdata = zeros(chn,2);
for ch = 1:chn
    [i,j] = find(probeset_matrix == ch);
    chdata(ch,:) = [x(i,j) y(i,j)];
end

chs2interp = chs2interp(:)';
remaining_chs = exclude(1:size(X,2),chs2interp);
for ch2i = chs2interp
    [i,j] = find(probeset_matrix == ch2i);
    weights = exp(-(voxelDistance(chdata,[x(i,j) y(i,j)],[1 1])).^2/(2*u^2))';
    weights = weights(remaining_chs);
    weights = weights/sum(weights);
    X(:,ch2i) = sum(X(:,remaining_chs).*repmat(weights,[n 1]),2);
end