function headflow3d(flowvecs,chcoordlist)

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
    % Date: 2015-05-07 11:00:55
    % Packaged: 2017-04-27 17:57:55
l = voxelnorm(flowvecs);
l = normValue(l,[0 5]);

for i = 1:size(chcoordlist,1)
    vec = flowvecs(i,:);
    vec = [-vec(2) vec(1)];
    if ~any(isnan(vec))
        point = chcoordlist(i,:);
        t = getBrainTangentials(point);
        theta = cart2pol(vec(1),vec(2));
        arrow = arrowPatch(15,5*l(i),3,5*l(i));
        tmx = createTransMat('offset',point + 3*t(:,3)','rotation',t*rotmx(theta,[0 0 1]));
        arrow.vertices = transformCoordList(arrow.vertices,tmx);
        arrow.FaceColor = 'g';
        patch(arrow);
    end
end