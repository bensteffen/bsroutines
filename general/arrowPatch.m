function p = arrowPatch(stem_length,stem_width,head_length,head_width)

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
    % Date: 2014-07-03 16:58:43
    % Packaged: 2017-04-27 17:58:04
stem_length = stem_length - head_length;

p.vertices = [0                         -stem_width/2;
              stem_length               -stem_width/2;
              stem_length                stem_width/2;
              0                          stem_width/2;
              stem_length               -head_width/2;
              stem_length + head_length 0;
              stem_length               head_width/2];
          
p.vertices = [p.vertices zeros(7,1)];
p.faces = [1 2 3; 1 3 4; 5 6 7];
p.EdgeColor = 'none';