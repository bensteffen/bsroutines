function r = mvcorr(X,Y,k)

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
    % Date: 2016-06-30 13:37:04
    % Packaged: 2017-04-27 17:58:13
[X,Y] = deal(X(:),Y(:));

n = numel(X);
r = zeros(n,1);

if isint(k) && mod(k,2) == 0
    error('mvcorr: k must be an uneven integer');
end

h = floor(k/2);
for i = 1:n
    w = max([1 i-h]):min([n i+h]);
%     r(i) = dot(X(w).^2,Y(w).^2);
    r(i) = corr(X(w),Y(w));
end