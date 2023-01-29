function h = flowHomogeneity(flow_vecs,probeset)

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
    % Date: 2014-03-26 09:57:50
    % Packaged: 2017-04-27 17:58:49
chs = NAps.ChannelWithNeighbours(probeset);
i = IdIterator(chs,AllIdsCollector());

h = 0;
while ~i.done();
    ch = i.current();
    vec = flow_vecs(ch.id,:)';
    nbg_vecs = flow_vecs(ch.value,:)';
    h = h + sum(dot(repmat(vec,[1 size(nbg_vecs,2)]),nbg_vecs));
    i.next();
end