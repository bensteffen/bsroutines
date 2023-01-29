%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 30-May-2012 13:47:46


function cmap = gap(gap_vec,n,gap_color)

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
    % Date: 2012-09-20 11:01:50
    % Packaged: 2017-04-27 17:58:10
if nargin < 3
    gap_color = [1 1 1];
end
if nargin < 2
    n = 64;
end
if nargin < 1
    gap_vec = [];
end

r = [1 0 0];
y = [1 1 0];
g = [0 1 0];
b = [0 0 1];

y2r = r - y;
b2g = g - b;

cmap = zeros(n,3);

if ~isempty(gap_vec)
    gi = [round(gap_vec(1)*n)+1 round(gap_vec(2)*n)];
    gi(gi < 0) = 1;
    gi(gi > n) = n;
    cmap(gi(1):gi(2),:) = repmat(gap_color,[gi(2)-gi(1)+1 1]);

    n1 = gi(1) - 1;
    n2 = n - gi(2);

    if n1 > 0
        cmap(1:n1,:) = repmat(b,[n1 1]) + repmat((0:n1-1)'/(n1-1),[1 3]).*repmat(b2g,[n1 1]);
    end
    if n2 > 0
        cmap(gi(2)+1:n,:) = repmat(y,[n2 1]) + repmat((0:n2-1)'/(n2-1),[1 3]).*repmat(y2r,[n2 1]);
    end
else
    q = n/3;
    if mod(q,1) == 0
        n1 = q; n2 = q; n3 = q;
    elseif mod(q,1) < 0.4
        n1 = floor(q); n2 = floor(q); n3 = ceil(q);
    else
        n1 = floor(q); n2 = ceil(q); n3 = ceil(q);
    end
    g2y = y - g;
    cmap(1:n1,:) = repmat(b,[n1 1]) + repmat((0:n1-1)'/n1,[1 3]).*repmat(b2g,[n1 1]);
    cmap(n1+1:n1+n2,:) = repmat(g,[n2 1]) + repmat((0:n2-1)'/n2,[1 3]).*repmat(g2y,[n2 1]);
    cmap(n1+n2+1:n,:) = repmat(y,[n3 1]) + repmat((0:n3-1)'/(n3-1),[1 3]).*repmat(y2r,[n3 1]);
end
