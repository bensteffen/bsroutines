function flag = voxeltest(vxs,s)

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
    % Date: 2013-04-05 15:53:40
    % Packaged: 2017-04-27 17:58:43
switch length(s)
    case 1
        flag = vxs > 0 & vxs <= s;
    case 2
        flag = all(vxs > 0,2) & vxs(:,1) <= s(1) & vxs(:,2) <= s(2);
    case 3
        flag = all(vxs > 0,2) & vxs(:,1) <= s(1) & vxs(:,2) <= s(2) & vxs(:,3) <= s(3);
    otherwise
        flag = all(vxs > 0,2) & all(vxs <= repmat(s,[size(vxs,1) 1]),2);
end