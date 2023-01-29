function spikes = findspikes(Y,f,x)

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
    % Date: 2013-05-14 15:05:55
    % Packaged: 2017-04-27 17:58:09
if nargin < 3
    x = 1:size(Y,1);
    x = x';
end
if nargin < 2
    f = 3.5;
end

medH = median(Y);
meanH = mean(Y); 

last_med_mean_param = 10*abs(meanH - medH)/medH;

spikes = [];
c = 0;
while true
    medH = nanmedian(Y);
    median_dev = nansum(abs(Y - medH))/length(Y);
    meanH = nanmean(Y);
    med_mean_param = abs(meanH - medH)/medH;
    
    N = Y/medH - 1;
    N = N/median_dev;
    std_eps = f*nanstd(N);
    % eps = 0.1;
    if med_mean_param == last_med_mean_param
        break;
    else     
%         figure; plot(N,'k');
%         hold on;
%         plot(zeros(size(N)),'r');
%         plot(-std_eps*ones(size(N)),'r--');
%         plot(std_eps*ones(size(N)),'r--');
%         plot(mean(N)*ones(size(N)),'g');
        last_med_mean_param = med_mean_param;
    end
    
    
    I = [find(N < -std_eps); find(N > std_eps)];
    spikes = [spikes; [I Y(I)]];
    Y(I) = NaN;
    N = Y/medH;
    c = c + 1;
end

spikes = sortrows(spikes,1);
if ~isempty(spikes)
    spikes = mergespikes(spikes);
    spikes(:,1) = x(spikes(:,1));
end