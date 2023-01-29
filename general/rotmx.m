function rmx = rotmx(alpha,rotax)

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
    % Date: 2014-06-29 14:59:21
    % Packaged: 2017-04-27 17:58:17
ca = cos(alpha);
sa = sin(alpha);
if nargin < 2
        rmx = [ca -sa; sa ca];
else
        rotax = rotax(:);
        rotax = normvec(rotax);
        [n1,n2,n3] = deal(rotax(1),rotax(2),rotax(3));
        rmx = ones(3)*(1-ca);
        rmx = rmx .* (rotax*rotax');
        rmx = rmx + eye(3)*ca + [0 -n3 n2; n3 0 -n1; -n2 n1 0]*sa;
end