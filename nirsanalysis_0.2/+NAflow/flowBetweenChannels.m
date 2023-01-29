function [flow_vectors,edge_xyz] = flowBetweenChannels(flowdata,probeset,alpha)

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
    % Date: 2014-07-05 19:06:50
    % Packaged: 2017-04-27 17:58:49
flow_basis = [0 1; 1 1; 1 0; 1 -1];
flow_basis = flow_basis ./ repmat(voxelnorm(flow_basis),[1 2]);
flow_basis = [flow_basis; -flow_basis];
flow_basis = [-flow_basis; flow_basis];

clear btwchs
btwchs = NAps.BetweenChannels(probeset);

sn = size(flowdata,3);
n = btwchs.edges.length();
flow_vectors = zeros(n,2);
edge_xyz = zeros(n,3);

c = 1;
i = IdIterator(btwchs.edges,AllIdsCollector());
while ~i.done()
    edgeid = i.current().id;
    chs = btwchs.edges.getItem(edgeid,'channels').value;
    nbgid = btwchs.edges.getItem(edgeid,'nbgid').value;
    vec = [];
    for j = 1:size(chs,1)
        ch = chs(j,1);
        ni = nbgid(j);
        vec = [vec; repmat(flow_basis(ni,:),[sn 1]).*repmat(squeeze(flowdata(ch,ni,:)),[1 2])];
        vec = [vec; repmat(flow_basis(ni+8,:),[sn 1]).*repmat(squeeze(flowdata(ch,ni+8,:)),[1 2])];
    end
    [tvalvec,pvalvec] = NAstat.getTvalues(vec,0);
    p = 2*tcdf(-abs(sum(tvalvec)), size(vec,1));
    if p < alpha
        flow_vectors(c,:) = tvalvec;
    else
        flow_vectors(c,:) = [NaN NaN];
    end
    edge_xyz(c,:) = btwchs.edges.getItem(edgeid,'xyz').value;
    i.next();
    c = c + 1;
end