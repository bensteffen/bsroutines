function pxsize = objpixelsize(obj_handle)

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
    % Date: 2013-07-25 11:16:50
    % Packaged: 2017-04-27 17:58:14
fh = get(obj_handle,'Parent');
fsz = get(fh,'Position');
objsz = get(obj_handle,'Position');

switch get(obj_handle,'Units')
    case 'normalized'
        pxsize = floor(fsz .* objsz);
    case 'pixel'
        pxsize = objsz;
end