function [s,b,s2] = shortestSurfaceConnection(vxs,p1,p2,direction)

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
    % Date: 2015-09-14 14:46:24
    % Packaged: 2017-04-27 17:58:41
v = normvec(p2-p1);
w = normvec(cross(p1,v));

f = @(alpha) calcDist(w*rotmx(alpha,v));
% a = fminsearch(f,0);

alpha = 0:0.1:2*pi;
y = zeros(length(alpha),1);
for i = 1:length(alpha)
    y(i) = f(alpha(i));
end
abest = minat(alpha,y);

[s,b,s2] = slicevoxels(vxs,p1,[v; w*rotmx(abest,v)],0.5);

    function d = calcDist(u)
        [~,bb,ss2] = slicevoxels(vxs,v,[v;u],0.5);
        i1 = find2di(p1,ss2(:,1:2),bb);
        i2 = find2di(p2,ss2(:,1:2),bb);
        d = distalongcurve(ss2(:,1:2),i1,i2,direction,false);
    end
end