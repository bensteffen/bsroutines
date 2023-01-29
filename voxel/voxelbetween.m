function vxsbtw = voxelbetween(vxs0,vxs1)

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
    % Date: 2014-06-21 11:21:42
    % Packaged: 2017-04-27 17:58:42
n0 = vxn(vxs0);

switch vxn(vxs1)
    case 1
        vxs1 = repmat(vxs1,[n0 1]);
    case n0
        % ok
    otherwise
        error('voxelbetween: number of vx1 must be 1 or equal to number of vxs2.');
end

vxsbtw = reshape(mean([vxs0(:) vxs1(:)],2),[n0 vxd(vxs1)]);