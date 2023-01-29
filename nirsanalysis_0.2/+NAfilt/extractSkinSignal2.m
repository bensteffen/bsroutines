function [Yskin,flowdata,max_flow_velocity] = extractSkinSignal2(Y,chs,probeset,vflow_interval,fs)

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
    % Date: 2016-07-08 13:24:45
    % Packaged: 2017-04-27 17:58:47
[n,chn] = size(Y);
[chmx,distmx] = NAps.extractChmxChpos(probeset);
distmx = voxelDistance(distmx,distmx);

Yskin = zeros(size(Y));
flowdata = zeros(chn,16);
max_flow_velocity = NaN(chn,16);

for seedch = chs
    allnbs = NAps.channelNeighbours(chmx,seedch,false)';
    nb_ids = find(~isnan(allnbs));
    nbs = allnbs(nb_ids);
    Yallnbs = NaN(n,8);
    [Yseed,Ynbs] = NAflow.extractSeedChannel(Y,seedch,nbs(~isnan(nbs)));
    Yallnbs(:,nb_ids) = Ynbs;

    for i = nb_ids
        currnb = allnbs(i);
        chdist = distmx(seedch,currnb);
        shift_samples = getSamples(chdist);
        ms = max(shift_samples);
        
        xr = xcorr(Yseed,Yallnbs(:,i),ms,'coeff')';
        xr = xr(shift_samples+ms+1);
        ineg = xr < 0;
        xr(ineg) = [];
        shift_samples(ineg) = [];
        
%         xr(xr < 0.95*max(xr)) = 0;
        
        Yallnbs(:,i) = nansum(lagmx(Yallnbs(:,i),shift_samples) .* repmat(xr,[n 1]),2);
        
        spos = shift_samples(shift_samples > 0);
        sneg = shift_samples(shift_samples < 0);
        xr_spos = xr(shift_samples > 0);
        xr_sneg = xr(shift_samples < 0);
        
        flowdata(seedch,i) = sum(xr_spos);
        flowdata(seedch,i+8) = sum(xr_sneg);
        
        v = maxat(getVelocity(spos,chdist),xr_spos);
        v = ifel(isempty(v),0,v);
        max_flow_velocity(seedch,i) = v;
        
        v = maxat(-getVelocity(sneg,chdist),xr_sneg);
        v = ifel(isempty(v),0,v);
        max_flow_velocity(seedch,i+8) = v;
    end
    Yskin(:,seedch) = nanmean(Yallnbs,2);
end

for j = 1:chn
    b = regress(Y(:,j),Yskin(:,j));
    Yskin(:,j) = b*Yskin(:,j);
end

    function s = getSamples(dx)
        [s1,s2] = deal(round(fs*dx/vflow_interval(2)),round(fs*dx/vflow_interval(1)));
        s = s1:s2;
        s = unique(s);
        s = [-fliplr(s) s];
    end

    function v = getVelocity(s,dx)
        dt = s/fs;
        v = dx./dt;
    end
end