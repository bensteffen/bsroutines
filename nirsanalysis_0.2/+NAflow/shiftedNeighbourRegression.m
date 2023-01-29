function [Yflow,weights] = shiftedNeighbourRegression(Y,ch0,flow_velocities,fs,probeset)

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
    % Date: 2014-07-04 15:48:07
    % Packaged: 2017-04-27 17:58:49
n = size(Y,1);
[chmx,distmx] = NAps.extractChmxChpos(probeset);
distmx = voxelDistance(distmx,distmx);

allnbs = NAps.channelNeighbours(chmx,ch0,false)';
nb_ids = find(~isnan(allnbs));
nbs = allnbs(nb_ids);
nbn = length(nb_ids);

vn = numel(flow_velocities);
flow_velocities = repmat(flow_velocities(:),[1 nbn]);
flow_velocities = flow_velocities';
flow_velocities = flow_velocities(:)';

dx = distmx(ch0,nbs);
dx = repmat(dx(:)',[1 vn]);
shift = round(fs*dx./flow_velocities);

[Yseed,Ynbs] = NAflow.extractSeedChannel(Y,ch0,nbs);
Ynbs = shiftmx(repmat(Ynbs,[1 vn]),shift);

Ynbs = [ones(n,1) Ynbs];
b = regress(Yseed,Ynbs);
Yflow = Ynbs*b;
b = b(2:end);
b(b < 0) = 0;
b = reshape(b,[nbn vn]);
b = mean(b,2)';

weights = zeros(1,8);
weights(nb_ids) = b;
weights(weights < 0) = 0;
% 
% flow_basis = NAflow.flowBasis();
% s = sign(flow_velocity);
% 
% flow_vector = sum(-s*flow_basis.*repmat(weights,[1 2]));