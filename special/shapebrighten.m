function rgbmx = shapebrighten(rgbmx,shapemx)

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
    % Date: 2013-02-26 18:53:35
    % Packaged: 2017-04-27 17:58:37
[ni,nj] = size(shapemx);
n = ni*nj;

shapemx = shapemx(:);
i2brighten = ~isnan(shapemx);

rgbmx = reshape(rgbmx,[n 3]);
shapemx = repmat(shapemx(i2brighten),[1 3]);
rgbmx(i2brighten) = rgbmx(i2brighten) + shapemx;
rgbmx(rgbmx > 1) = 1;
rgbmx = reshape(rgbmx,[ni nj 3]);