function [img,val] = createEmptyMrVolume(V)

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
    % Date: 2012-11-15 12:58:20
    % Packaged: 2017-04-27 17:58:35
switch V.dt(1)
    case 2
        val = uint8(2^8);
        type_name = 'uint8';
    case 4
        val = int16(2^16);
        type_name = 'int16';
    case 8
        val = int32(2^32);
        type_name = 'int32';
    case 16
        val = single(1);
        type_name = 'single';
    case 64
        val = double(1);
        type_name = 'double';
    case 256
        val = int8(2^8);
        type_name = 'int8';
    case 512
        val = uint16(2^16);
        type_name = 'uint16';
    case 768
        val = uint32(2^32);
        type_name = 'uint32';
end

img = zeros(V.dim,type_name);