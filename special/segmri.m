function cmap = segmri(type,n)

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
    % Date: 2012-11-21 11:19:36
    % Packaged: 2017-04-27 17:58:37
switch type
    case 'color'
        clrmx = [120 120 255; 255 174 54; 255 255 255; 180 120 180; 100 100 100; 150 150 150]/255;
    case 'gray'
        clrmx = [1 1 1; 0.2 0.2 0.2; 0.6 0.6 0.6; 0.8 0.8 0.8; 0 0 0; 0.4 0.4 0.4];
end

cmap = createColormap(clrmx,n);