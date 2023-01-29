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


function hrf = createHrf(trigger,hr,sample_rate,trigger_token,event_duration,event_related_hrfamps)

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
    % Date: 2015-06-11 17:59:52
    % Packaged: 2017-04-27 17:58:50
if nargin < 6
    event_related_hrfamps = [];
end

nhr = size(hr,2);
hrf = zeros(size(trigger,1),nhr);

evons = find(trigger);
evtok = trigger(evons);
nev = length(evons);

if isempty(event_related_hrfamps)
    event_related_hrfamps = ones(nev,1);
elseif numel(event_related_hrfamps) ~= nev
    error('Number of event-related amplitudes is not equal to the number of events.');
end
event_related_hrfamps = event_related_hrfamps(:);

for j = 1:nhr
    trigger1 = zeros(size(trigger));
    evi = mxor(mxeqmx(evtok,trigger_token{j}),2);
    ons = evons(evi);
    trigger1(ons) = event_related_hrfamps(evi);
    trigger1 = NAev.setTriggerEventDuration(trigger1,sample_rate,event_duration(j));
    tmp = conv(hr(:,j),double(trigger1));
    hrf(:,j) = tmp(1:size(hrf,1));
end

% c = 1;
% for j = 1:length(trigger_token)
%     for h = 1:nhr
%         token = trigger_token(j);
%         for t = 1:length(token)
%             if size(trigger,2) > 1
%                 hrf(trigger(:,h) == token(t),c) = 1;
%             else
%                 hrf(trigger == token(t),c) = 1;
%             end
%         end
%         tmp = conv(hr(:,h),hrf(:,c));
%         hrf(:,c) = tmp(1:size(hrf,1));
%         c = c + 1;
%     end
% end