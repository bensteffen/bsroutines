function vecs = calculateFlowVectors(flowdata,type)

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
    % Date: 2015-08-24 10:26:32
    % Packaged: 2017-04-27 17:58:47
flow_basis = [0 1; 1 1; 1 0; 1 -1];
flow_basis = flow_basis ./ repmat(voxelnorm(flow_basis),[1 2]);
flow_basis = [flow_basis; -flow_basis];

chn = size(flowdata,1);
sn = size(flowdata,3);

switch type
    case 'mean'
        flowdata = flowdata(:,9:16,:) - flowdata(:,1:8,:);
        vecs = zeros(chn,2,sn);
        for s = 1:sn
            for ch = 1:chn
                d = zeros(8,2);
                for i = 1:8
                    d(i,:) = flow_basis(i,:)*flowdata(ch,i,s);
                end
                d = mean(d);
                vecs(ch,:,s) = d;
            end
        end
        vecs = mean(vecs,3);
    case 'stat'
        flow_basis = [-flow_basis; flow_basis];
        vecs = zeros(chn,2);
        for ch = 1:chn
            d = [];
            for i = 1:16
                d = [d; repmat(flow_basis(i,:),[sn 1]).*repmat(squeeze(flowdata(ch,i,:)),[1 2])];
            end
            d(d(:,1) == 0 & d(:,2) == 0,:) = [];
            vecs(ch,:) = NAstat.getTvalues(d,0);
        end
end