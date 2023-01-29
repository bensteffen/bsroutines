function d = distalongcurve(vxs,i0,i1,theta_direction,plot_flag)

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
    % Date: 2015-09-11 16:10:22
    % Packaged: 2017-04-27 17:58:39
if nargin < 5
    plot_flag = false;
end

% vxs = vxs - repmat(mean(vxs),[size(vxs,1) 1]);

th = cart2pol(vxs(:,1),vxs(:,2));

n = size(vxs,1);
vxs = [vxs th (1:n)'];
vxs = sortrows(vxs,3);

if plot_flag
    figure; hold on;
    scatter(vxs(:,1),vxs(:,2),'.')
end

i = find(vxs(:,4) == i0);
d = 0;
if i0 == i1
    j = i;
    i = circleindex(i+theta_direction,n);
    d = d + norm(vxs(i,1:2) - vxs(j,1:2));
end

while vxs(i,4) ~= i1
    j = i;
    i = circleindex(j+theta_direction,n);
    d = d + norm(vxs(i,1:2) - vxs(j,1:2));
    if plot_flag
        scatter(vxs(i,1),vxs(i,2),'o'); pause(0.001);
        title(sprintf('d = %d mm',round(d)));
    end
end