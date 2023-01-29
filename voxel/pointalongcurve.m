function i1 = pointalongcurve(vxs,i0,distance2point,theta_direction)

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
    % Date: 2016-04-28 17:51:07
    % Packaged: 2017-04-27 17:58:41
if nargin < 4
    theta_direction = sign(distance2point);
    distance2point = abs(distance2point);
end

vxs = vxs - repmat(mean(vxs),[size(vxs,1) 1]);
th = cart2pol(vxs(:,1),vxs(:,2));

n = size(vxs,1);
vxs = [vxs th (1:n)'];
vxs = sortrows(vxs,3);

% hold on;
% scatter(vxs(:,1),vxs(:,2),'.')

d = 0;
i = find(vxs(:,4) == i0);
while d < distance2point
    j = i;
    i = circleindex(j+theta_direction,n);
    d = d + norm(vxs(i,1:2) - vxs(j,1:2));
%     scatter(vxs(i,1),vxs(i,2),'o'); pause(0.01)
end

i1 = vxs(i,4);
% scatter(vxs(i1,1),vxs(i1,2),'rx','LineWidth',2);