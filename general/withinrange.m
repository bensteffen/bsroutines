function flag = withinrange(x,r,borders,equal_allowed)

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
    % Date: 2016-09-07 11:08:01
    % Packaged: 2017-04-27 17:58:21
if nargin < 3
    borders = '[]';
end

if nargin < 4
    equal_allowed = false;
end

if ~isrange(r,equal_allowed)
    error('r must be a valid range');
end

% x = x(:);

switch borders(1)
    case '['
        flag = x >= r(1);
    case ']'
        flag = x > r(1);
end

switch borders(2)
    case ']'
        flag = flag & x <= r(2);
    case '['
        flag = flag & x < r(2);
end