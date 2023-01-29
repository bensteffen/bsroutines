function flowdata = createFlowData(Y,probeset,flow_velocity,fs)

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
    % Date: 2014-03-13 10:05:26
    % Packaged: 2017-04-27 17:58:48
[n,chn] = size(Y);
[chmx,distmx] = NAps.extractChmxChpos(probeset);
distmx = voxelDistance(distmx,distmx);

flowdata = zeros(chn,16);
for seedch = 1:chn
    allnbs = NAps.channelNeighbours(chmx,seedch,false)';
    nb_ids = find(~isnan(allnbs));
    nbs = allnbs(nb_ids);
    Yallnbs = NaN(n,8);

    [Yseed,Ynbs] = NAflow.extractSeedChannel(Y,seedch,nbs(~isnan(nbs)));
    Yallnbs(:,nb_ids) = Ynbs;

    for i = nb_ids
        currnb = allnbs(i);
        shift_samples = round(fs * distmx(seedch,currnb)/flow_velocity);
        flowdata(seedch,i) = NAflow.shiftedCorrelation(Yseed,Yallnbs(:,i),shift_samples);
        flowdata(seedch,i+8) = NAflow.shiftedCorrelation(Yseed,Yallnbs(:,i),-shift_samples);
    end
end