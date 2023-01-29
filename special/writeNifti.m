function writeNifti(scan,fname)

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
    % Date: 2015-10-05 16:55:25
    % Packaged: 2017-04-27 17:58:38
if isfield(scan,'img')
    img_name = 'img';
elseif isfield(scan,'dat')
    img_name = 'dat';
else
    error('writeNifti: No image data found.');
end

if isfield(scan,'hdr')
    hdr = scan.hdr;
else
    hdr = scan;
    hdr = rmfield(hdr,img_name);
end

if nargin > 1
    hdr.fname = fname;
end

spm_write_vol(hdr,scan.(img_name));