function p_cluster = clusterCorrection(channel_matrix,channel_tvals)

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
    % Date: 2013-04-05 15:53:54
    % Packaged: 2017-04-27 17:58:53
overall_threshold = 2.0;
tval_threshold = 1.6;
permutation_number = 5000;

channel_tvals = channel_tvals(:);
chn = sum(~isnan(channel_matrix(:)));
psdim = size(channel_matrix);
channel_matrix(isnan(channel_matrix)) = 0;

ch_index = zeros(chn,1);
for ch = 1:chn
    [i,j] = find(channel_matrix == ch);
    ch_index(ch) = voxel2index([i j],psdim);
end

if chn == length(channel_tvals)
    true_clusters = findClusters(channel_tvals);
    max_cluster_size = zeros(permutation_number,1);
    for prun = 1:permutation_number
        permcluster = findClusters(channel_tvals(randperm(chn)));
        max_cluster_size(prun) = max(permcluster.tval);
    end
    p_cluster = zeros(1,length(true_clusters.tval));
    max_cluster_size
    for cluster_i = 1:length(true_clusters.tval)
        true_clusters.tval(cluster_i)
        p_cluster(cluster_i) = 1 - sum(true_clusters.tval(cluster_i) > max_cluster_size)/permutation_number;
    end
else
    throw(NirsException('NAnaT_functions','clusterCorrection','Channel number and t-value number must be the same.'));
end
    
    function cluster = findClusters(tvals)
        tvals(abs(tvals) < tval_threshold) = 0;
        [ntvals,ptvals] = deal(tvals);
        ntvals(ntvals > 0) = 0; ntvals(ntvals ~= 0) = 1;
        ptvals(ptvals < 0) = 0; ptvals(ptvals ~= 0) = 1;
        [ntmx,ptmx,tmx] = deal(channel_matrix);
        ntmx(ch_index) = ntvals;
        ptmx(ch_index) = ptvals;
        [ntmx,ptmx] = deal(connectNeighbours(ntmx),connectNeighbours(ptmx));
        tmx(ch_index) = tvals;
        cluster.mx = bwlabel(ptmx,8) - bwlabel(ntmx,8);
        cluster.mx(channel_matrix == 0) = 0;
        cluster.id = minmax(cluster.mx);
        cluster.id = exclude(cluster.id(1):cluster.id(2),0);
        cluster.n = length(cluster.id);
        cluster.size = zeros(1,cluster.n);
        cluster.tval = zeros(1,cluster.n);
        for c = 1:cluster.n
            ci = cluster.mx(:) == cluster.id(c);
            cluster.size(c) = sum(ci);
            cluster.tval(c) = sum(tmx(ci));
        end
        
    end
end