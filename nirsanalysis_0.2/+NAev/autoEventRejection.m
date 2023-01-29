function evs2rej = autoEventRejection(xoxy,xdeoxy,tr,fs,event_dur,crit_amp,crit_grad,crit_corr)

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
    % Date: 2016-03-10 10:55:44
    % Packaged: 2017-04-27 17:58:46
ons = find(tr);
boxy = blocks(xoxy,ons,[0 round(event_dur*fs)]);
bdeoxy = blocks(xdeoxy,ons,[0 round(event_dur*fs)]);

evs2rej = [];
for e = 1:size(boxy,3)
    for ch = 1:size(xoxy,2)
        r = minmax(boxy(:,ch,e));
        if  any(abs(r) > crit_amp)
            evs2rej = [evs2rej; e];
        end
        g = abs(diff(r));
        if g > crit_grad
            evs2rej = [evs2rej; e];
        end
        c = corr(boxy(:,ch,e),bdeoxy(:,ch,e));
        if c > crit_corr
            evs2rej = [evs2rej; e];
        end
    end
end

evs2rej = unique(evs2rej);