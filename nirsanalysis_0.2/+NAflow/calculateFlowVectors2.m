function pdata = calculateFlowVectors2(flowdata,probeset,alpha)

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
    % Date: 2014-07-05 18:54:31
    % Packaged: 2017-04-27 17:58:47
flow_basis = [0 1; 1 1; 1 0; 1 -1];
flow_basis = flow_basis ./ repmat(voxelnorm(flow_basis),[1 2]);
flow_basis = [flow_basis; -flow_basis];
flow_basis = [-flow_basis; flow_basis];

Chnb = NAps.ChannelWithNeighbours(probeset,false);
chxy = NAps.probesetxy(probeset.channelMatrix(),30);
NAps.showProbeset(probeset); hold on;

edges = IdList();

chn = size(flowdata,1);
sn = size(flowdata,3);
vecs = IdList();
for ch = 1:chn
    nbs = Chnb.entry(ch).value;
    existing = ~isnan(nbs);
    nbs = nbs(existing);
    vecpos = NaN(8,2);
    vecpos(existing,:) = voxelbetween(chxy(nbs,:),chxy(ch,:));
    vecpos = repmat(vecpos,[2 1]);
    existing = find(existing);
    for i = [existing existing + 8];
%         vec = 0.1*flow_basis(i,:)*mean(flowdata(ch,i,:));
        vec = repmat(flow_basis(i,:),[sn 1]).*repmat(squeeze(flowdata(ch,i,:)),[1 2]);
        p = vecpos(i,:);
        if ~edges.hasEntry(p)
            edges.add(IdItem(p,vec));
        else
            edges.add(IdItem(p,[edges.entry(p).value; vec]));
        end
%         quiver(vecpos(i,1),vecpos(i,2),vec(1),vec(2),'k','LineWidth',5);
    end
end


pdata = zeros(edges.length(),6);

for i = 1:edges.length()
    p = edges.ids{i};
    vecs = edges.entry(p).value;
    [lengthtval,lengthpval] = NAstat.getTvalues(abs(vecs(:),0));
    [tvalvec,pvalvec] = NAstat.getTvalues(vecs,0);
    pdata(i,1:2) = [p(1) p(2)];
    pdata(i,3:4) = tvalvec;
    pdata(i,5) = lengthtval;
    pdata(i,6) = lengthpval;
end

pdata(isnan(pdata)) = 1;
% alpha = 0.2;

sig = bonholm(pdata(:,6),alpha);

% sig = pdata(:,6) < alpha;

% sig = true(size(pdata,1),2);

% vecs = zeros();
pdata(~(sig(:,1)|sig(:,2)),:) = [];



pdata(:,3:4) = 2*pdata(:,3:4);
quiver(pdata(:,1),pdata(:,2),pdata(:,3),pdata(:,4),'k','LineWidth',5);
plot(pdata(:,1),pdata(:,2),'s','MarkerSize',12);
