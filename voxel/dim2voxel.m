function vxs = dim2voxel(dim)

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
    % Date: 2014-06-27 15:48:09
    % Packaged: 2017-04-27 17:58:39
nd = length(dim);
% vxs = ones(prod(dim),nd);

switch nd
    case 0
        vxs = [];
    case 1
        vxs = (1:nd)';
    case 2
        vxs = volume2voxel(ones(dim));
        if all(dim == 1)
            vxs = 1;
        elseif dim(2) == 1
            vxs(:,dim == 1) = [];
        end
    otherwise
        endi = 0;
        for i = length(dim):-1:1
            if dim(i) == 1
                endi = endi + 1;
            else
                break;
            end
        end
        vxs = volume2voxel(ones(dim));
        vxs = [vxs ones(vxn(vxs),endi)];
end
% if nd > 1
%     i1 = dim == 1;
%     i1(1:2) = false;
%     size(ones(dim))
%     size(volume2voxel(ones(dim)))
%     vxs(:,~i1) = volume2voxel(ones(dim));
% else
%     vxs = volume2voxel(ones(dim));
% end
