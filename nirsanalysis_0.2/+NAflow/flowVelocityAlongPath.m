function r = flowVelocityAlongPath(Y,chpaths,vaxis,probeset)

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
    % Date: 2014-07-05 15:58:25
    % Packaged: 2017-04-27 17:58:49
r = [];
for c = 1:numel(chpaths)
    pathchs = chpaths{c};
    [pathchs,vaxis] = deal(pathchs(:)',vaxis(:)');
    chmx = probeset.channelMatrix();
    pl = length(pathchs);
    edgen = pl-1;

    pathnbids = zeros(1,edgen);
    for i = 1:edgen
        nbs = NAps.channelNeighbours(chmx,pathchs(i),false)';
        nbid = find(nbs == pathchs(i+1));
        if isempty(nbid)
            error('NAflow.flowVelocityAlongPath: No correct path. Channels %d and %d are not connected.',pathchs(i),pathchs(i+1));
        else
            pathnbids(i) = nbid;
        end
    end

    curr_r = zeros(length(vaxis),pl-1);
    for vi = 1:length(vaxis)
        v = vaxis(vi);
        for i = 1:edgen
            [~,w] = NAflow.shiftedNeighbourRegression(Y,pathchs(i),v,10,probeset);
            curr_r(vi,i) = w(pathnbids(i));
        end
    end
    r = [r curr_r];
end
% r = smooth2(sum(r,2)',10)';
% 
% vpath = maxat(vaxis(:),r);
