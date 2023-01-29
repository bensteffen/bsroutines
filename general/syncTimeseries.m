function [ts1,ts2,trigger] = syncTimeseries(ts1,ts2,trigger1,fs1,fs2)


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
    % Date: 2014-03-10 12:15:36
    % Packaged: 2017-04-27 17:58:20
I1 = find(trigger1);
trigger_times = (I1 - 1)/fs1;
first_event_index2 = floor(fs2*trigger_times(1));
ts2 = [repmat(ts2(first_event_index2,:), [first_event_index2 1]); ts2];

dur1 = size(ts1,1)/fs1;
dur2 = size(ts2,1)/fs2;

if dur1 > dur2
    ts1 = ts1(1:floor(dur2*fs1),:);
elseif dur2 > dur1
    ts2 = ts2(1:floor(dur1*fs2),:);
end

dur1 = size(ts1,1)/fs1;
dur2 = size(ts2,1)/fs2;

if fs1 > fs2
    fs = fs2;
    dur = dur2;
    ts1 = ndownsample(ts1,floor(dur*fs));
elseif fs2 > fs1
    fs = fs1;
    dur = dur1;
    ts2 = ndownsample(ts2,floor(dur*fs));
end

trigger = zeros(size(ts1,1),1);

tsm = trigger_times <= dur;

trigger(floor(trigger_times(tsm)*fs)) = trigger1(I1(tsm));