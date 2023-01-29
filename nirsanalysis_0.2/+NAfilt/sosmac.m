function Y = sosmac(Y,skin_mapping_chs,type,probeset)

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
    % Date: 2014-07-07 12:23:30
    % Packaged: 2017-04-27 17:58:47
if nargin < 3
    type = 'simple';
end

switch type
    case 'simple'
        Y = Y - repmat(mean(Y(:,skin_mapping_chs),2),[1 size(Y,2)]);
    case 'shifted'
        x = NAps.probesetxyz(probeset,'head');
        Ysm = repmat(mean(Y(:,skin_mapping_chs),2),[1 size(Y,2)]);
        xsm = mean(x(skin_mapping_chs,:));
        distsm = voxelDistance(x,xsm)';
        shift = -round(10*distsm/8.5);
        Ysm = shiftmx(Ysm,shift);
        Ysm(isnan(Ysm)) = 0;
        Y = Y - Ysm;
end
