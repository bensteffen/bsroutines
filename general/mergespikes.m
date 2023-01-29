function spikes_merged = mergespikes(spikes)

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
    % Date: 2012-09-12 15:51:19
    % Packaged: 2017-04-27 17:58:13
dspike_i = [1; diff(spikes(:,1))];

spike_n = 0;
spike_j = [];
spikes_merged = [];
for i = 1:size(spikes,1)
    if dspike_i(i) > 1
        [~,mi] = max(spike_j(:,2));
        spikes_merged = [spikes_merged; spike_j(mi,:)];
        spike_j = spikes(i,:);
    else
        spike_j = [spike_j; spikes(i,:)];
    end
end

[~,mi] = max(spike_j(:,2));
spikes_merged = [spikes_merged; spike_j(mi,:)];