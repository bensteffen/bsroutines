function [inside,border_th,border_r] = mriIsInside(slice,border_intens_range,exclude_angles)

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
    % Date: 2015-10-08 11:23:58
    % Packaged: 2017-04-27 17:58:37
s = size(slice);
[slice_i,v] = volume2voxel(slice,false);

within_i = withinrange(v,border_intens_range);
border_i = slice_i(within_i,:);
border_i = border_i - repmat(s/2,[size(border_i,1) 1]);

[border_th,border_r] = cart2pol(border_i(:,1),border_i(:,2));

dphi = 0.01;
angles = [(-1:dphi:1-dphi)'*pi (-1+dphi:dphi:1)'*pi];
[angle_distr,angle_ax] = intervalmean(angles,border_th,border_r);

inan = isnan(angle_distr);
angle_distr(inan) = interp1(angle_ax(~inan),angle_distr(~inan),angle_ax(inan));

rest_i = slice_i(~within_i & v ~= 0,:);
rest_i = rest_i - repmat(s/2,[size(rest_i,1) 1]);

[rest_th,rest_r] = cart2pol(rest_i(:,1),rest_i(:,2));

for e = 1:size(exclude_angles,1)
    ex_i = withinrange(rest_th,exclude_angles(e,:));
    rest_th(ex_i) = [];
    rest_r(ex_i) = [];
    rest_i(ex_i,:) = [];
end

r_interp = interp1(angle_ax,angle_distr,rest_th);
inside_i = rest_i(rest_r < r_interp,:);
inside_i = inside_i + repmat(s/2,[size(inside_i,1) 1]);

inside = false(s);
inside(voxel2index(inside_i,s)) = true;