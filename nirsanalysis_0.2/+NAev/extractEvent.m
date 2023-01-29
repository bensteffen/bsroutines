%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 09-Aug-2012 15:29:24


function evd = extractEvent(X,trigger,event_id,fs,varargin)


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
    % Date: 2016-01-12 18:17:42
    % Packaged: 2017-04-27 17:58:46
param_defaults.bl_interval = [-2 0];
param_defaults.ev_interval = [];
param_defaults.avg_interval = [];
param_defaults.peak_interval = [];
param_defaults.peak_delta = 0.001;
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);


evd.event.id = event_id;
n = size(X,1);

if isempty(ev_interval)
    start_I = NAev.getStartTrigger(trigger);
    end_I = NAev.getEndTrigger(trigger);
    evd.event.trigger_token = trigger(start_I(evd.event.id));
    start_sample = start_I(evd.event.id);
    end_sample = end_I(evd.event.id);    
    evd.event.start = adaptvoxel(start_sample,n);
    evd.event.end = adaptvoxel(end_sample,n);
else
    I = find(trigger);
    start_sample = I(evd.event.id);
    evd.event.trigger_token = trigger(start_sample);
    evd.event.start = adaptvoxel(start_sample + ev_interval(1)*fs,n);
    evd.event.end = adaptvoxel(start_sample + ev_interval(2)*fs,n);
end


evd.event.time_series = X(evd.event.start:evd.event.end,:);
evd.event.time_axis = sample2time(evd.event.start:evd.event.end,fs)';
evd.event.avg = mean(evd.event.time_series,1);

bl1 = adaptvoxel(start_sample - bl_interval(1)*fs,n);
bl2 = adaptvoxel(start_sample - bl_interval(2)*fs,n);
bl = sort([bl1 bl2]);
evd.baseline.time_series = X(bl(1):bl(2),:);
evd.baseline.time_axis = sample2time(bl(1):bl(2),fs)';
evd.baseline.avg = mean(evd.baseline.time_series,1);

if ~isempty(avg_interval)
    evd.avgamp.start = adaptvoxel(evd.event.start - 1 + time2sample(avg_interval(1),fs),n);
    evd.avgamp.end = adaptvoxel(evd.event.start - 1 + time2sample(avg_interval(2),fs),n);
    evd.avgamp.value = mean(X(evd.avgamp.start:evd.avgamp.end,:),1);
end

if ~isempty(peak_interval)
    peak_start = adaptvoxel(evd.event.start - 1 + time2sample(peak_interval(1),fs),n);
    peak_end = adaptvoxel(evd.event.start - 1 + time2sample(peak_interval(2),fs),n);
    evd.peak = intervalPeakDetection(X,[peak_start peak_end],peak_delta);
    evd.peak.max.time = sample2time(evd.peak.max.index,fs);
end