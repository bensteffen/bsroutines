function pos = rasterPositions(dim,margin)

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
    % Date: 2014-05-26 17:34:47
    % Packaged: 2017-04-27 17:58:26
if nargin < 2
    margin = [0 0];
end

[n,m] = deal(dim(1),dim(2));

w = (1 - 2*margin(2))/m;
h = (1 - 2*margin(1))/n;

y = 1 - (1:n)*h - margin(1);
x = (0:m-1)*w + margin(2);

[x,y] = meshgrid(x,y);

pos = [x(:) y(:) repmat(w,[prod(dim) 1]) repmat(h,[prod(dim) 1])];
