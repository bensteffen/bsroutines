function [p,delta0,deltas] = randgrouptest(x1,x2,nruns)

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
    % Date: 2017-04-04 17:56:05
    % Packaged: 2017-04-27 17:58:53
[x1,x2] = deal(x1(:),x2(:));
[n1,n2] = deal(numel(x1),numel(x2));
n = n1 + n2;
delta0 = calculateDelta(x1,x2);
deltas = NaN(nruns,1);

x = [x1;x2];
for r = 1:nruns
    x = x(randperm(n));
    deltas(r) = calculateDelta(x(1:n1),x(n1+1:end));
end

p = sum(deltas > delta0)/nruns;

    function delta_ = calculateDelta(x1_,x2_)
        delta_ = mean(x1_) - mean(x2_);
    end

end