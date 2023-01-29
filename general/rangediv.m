function divs = rangediv(N,div_number)

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
    % Date: 2014-10-08 12:55:08
    % Packaged: 2017-04-27 17:58:16
d = N/div_number;

divs = [floor((0:div_number-1)'*d)+1 ceil((1:div_number)'*d)];
% divs = divs + 1;
divs(end) = N;