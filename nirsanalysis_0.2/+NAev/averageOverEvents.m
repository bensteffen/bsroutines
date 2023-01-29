%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 20-Jan-2012 19:40:16


function [era_mean,era_std] = averageOverEvents(X,sample_rate,trigger,trigger_token,pre_interval,interval,linear_detrend_flag)

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
    % Date: 2017-01-24 12:59:14
    % Packaged: 2017-04-27 17:58:46
if nargin < 7
    linear_detrend_flag = false;
end

interval_length = interval(2) - interval(1);

N = size(X,1);
originI = [];
for c = 1:length(trigger_token)
    originI = [originI; find(trigger == trigger_token(c))];
end
originI = sort(originI);
originI = originI + floor(interval(1)*sample_rate);
startI = originI - floor(pre_interval*sample_rate);
endI = originI + ceil(interval_length*sample_rate);

negI = [find(startI < 1); find(endI < 1)];
highI = [find(startI > N); find(endI > N)];

if ~isempty(negI) || ~isempty(highI)
%     warning('Average window out of Data');
    remove_flag = true;
else
    remove_flag = false;
end

excludeI = [negI; highI];

startI(excludeI) = [];
originI(excludeI) = [];
endI(excludeI) = [];


channel_number = size(X,2);
event_number = length(startI);


if isempty(startI) || isempty(endI)
    if remove_flag
%         throw(NirsException('Tools','averageOverEvents',sprintf('Trigger token %s found, but was completely removed (out of window).',stringify(trigger_token))));
        warning('Trigger token %s found, but was completely removed (out of window).',stringify(trigger_token));
    else
%         throw(NirsException('Tools','averageOverEvents',sprintf('Trigger token %s not found in this trigger.',stringify(trigger_token))));
        warning('Trigger token %s not found in this trigger.',stringify(trigger_token))
    end
    era_mean = NaN(1,channel_number);
    era_std = NaN(1,channel_number);
else
    era_length = length(startI(1):endI(1));
    era_mean = zeros(era_length,channel_number);
    era_std = zeros(era_length,channel_number);
    for j = 1:channel_number
        snippets = zeros(era_length,event_number);
        for i = 1:event_number
            event = X(startI(i):endI(i),j);
            if linear_detrend_flag
                event = detrend(event,'linear');
            end
            baseline = mean(event(1:originI(i)-startI(i)+1));
    %         baseline = mean(X(startI(i):originI(i),j));
            snippets(:,i) = event - baseline;
        end
        era_mean(:,j) = mean(snippets  ,2);
        era_std (:,j) =  std(snippets,0,2);
    end
end
