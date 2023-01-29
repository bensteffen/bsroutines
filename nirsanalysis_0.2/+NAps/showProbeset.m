function chxy = showProbeset(probeset)

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
    % Date: 2016-07-08 13:39:01
    % Packaged: 2017-04-27 17:58:52
chmx = probeset.channelMatrix();
chxy = NAps.probesetxy(chmx,probeset.getProperty('optode_distance'));
% chxy = scalevoxels(chxy,0.1);
chids = chmx(~isnan(chmx))';

figure; set(gca,'Xlim',minmax(chxy(:,1)) + 0.5*[-1 1]*mindiff(chxy(:,1)),'YLim',minmax(chxy(:,2)) + 0.5*[-1 1]*mindiff(chxy(:,2)),'XTick',[],'YTick',[]);
for id = chids'
    text(chxy(id,1),chxy(id,2),num2str(id),'FontSize',12,'FontWeight','bold');
end