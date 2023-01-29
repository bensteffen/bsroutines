function [b2bdist,b2bamp,rr] = beat2beat(X,rois)

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
    % Date: 2015-07-09 19:47:49
    % Packaged: 2017-04-27 17:58:34
if nargin > 1
    Xr = zeros(size(X,1),length(rois));
    for r = 1:length(rois)
        Xr(:,r) = mean(X(:,rois{r}),2);
    end
    X = Xr;
end

[n,chn] = size(X);
[b2bdist,b2bamp] = deal(NaN(n,chn));

for j = 1:chn
    [pmax,pmin] = peakdet(X(:,j),0.5*std(X(:,j)));
    if ~isempty(pmax) && ~any(isnan(X(:,j)))
        if pmax(1,1) < pmin(1,1)
            pmax(1,:) = [];
        end

        if pmin(end,1) > pmax(end,1)
            pmin(end,:) = [];
        end

        if size(pmin,1) ~= size(pmax,1)
            error('Bad peak detection');
        end

%         figure; plot(X(:,j)); hold on; plot(pmax(:,1),pmax(:,2),'ro');

        bt = pmax(:,1);
        amp = pmax(:,2) - pmin(:,2);

        bt = [1; bt; n];
        amp = [amp(1); amp; amp(end)];
        amp = interp1(bt,amp,(1:n)');

        bt = pmax(:,1);
        dist = diff(bt);
        bt = bt(1:end-1);

        bt = [1; bt; n];
        dist = [dist(1); dist; dist(end)];
        dist = interp1(bt,dist,(1:n)');
        
        b2bdist(:,j) = dist;
        b2bamp(:,j) = amp;
        
        rr = bt;
    end
end