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


classdef NirsEvent < TagMatrix & NirsObject
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
    % Date: 2014-03-07 11:24:18
    % Packaged: 2017-04-27 17:58:43
    methods
        function obj = NirsEvent(varargin)
            obj@NirsObject(varargin);
            obj = obj.setDimension({'subject_id','data_name','event_id','event_data'});
        end
        
        function obj = createEventData(obj,subject_data)
            save_mode = lower(obj.getProperty('save_mode'));
            event_interval = obj.getProperty('event_interval');
            baseline_interval = obj.getProperty('baseline_interval');
            average_interval = obj.getProperty('average_interval');
            peak_interval = obj.getProperty('peak_interval');
            
            experiment = obj.getProperty('experiment');
            subjects2skip = experiment.getProperty('subjects2skip');
            subject_data = obj.addEvents2Skip(subject_data,experiment.getProperty('events2skip'));
            time_series_info = experiment.getProperty('time_series');
            data_names = time_series_info.tags(1);
            fs = time_series_info.extract({':','sample_rate'}).toArray();
            trigger_names = time_series_info.extract({':','trigger_name'}).toCell();
            subjects = subject_data.subjects();
            subjects = exclude(subjects,subjects2skip);
            
            start_end_flag = false;
            if strcmpi(obj.getProperty('trigger_type'),'start_end'); start_end_flag = true; end
            if start_end_flag
                event_interval = [];
            end
            fprintf('Extracting events... ');
            psh = ProgressStatus([length(subjects) length(data_names)], '%d%%%%');
            for i = 1:length(subjects)
                s = subjects(i);
                e2s = subject_data.getSubjectData(s,'__tmp_events_to_skip__');
                for d = 1:length(data_names)
                    data = subject_data.getSubjectData(s,data_names{d});
                    trigger = subject_data.getSubjectData(s,trigger_names{d});
                    if start_end_flag
                        event_number = length(find(trigger))/2;
                    else
                        event_number = length(find(trigger));
                    end
                    event_ids = exclude(1:event_number,e2s);
                    for e = event_ids
                        evd = NAev.extractEvent(data,trigger,e,fs(d),'ev_interval',event_interval,'bl_interval',baseline_interval,'avg_interval',average_interval,'peak_interval',peak_interval);
                        switch save_mode
                            case 'normalized'
                                event = event - repmat(mean(event),[size(event,1) 1]);
                                event = event./repmat(sqrt(sum(event.^2)),[size(event,1) 1]);
                            case 'zscore'
                                event = zscore(event);
                        end
                        obj = obj.add({s,data_names{d},e,'event'},evd.event.time_series);
                        obj = obj.add({s,data_names{d},e,'trigger_token'},evd.event.trigger_token);
                        obj = obj.add({s,data_names{d},e,'baseline'},evd.baseline.avg);
                        obj = obj.add({s,data_names{d},e,'maxima'},evd.peak.max.value);
                        obj = obj.add({s,data_names{d},e,'maxima_latency'},evd.peak.max.time);
                    end
                    psh.update([i d]);
                end
            end
            psh.finish('Done!\n');
        end
    end
    
    methods(Access = 'protected')
        function obj = update(obj,prop_name,prop_value)
        end
    end
    
    methods(Access = 'protected', Static = true)
        function subject_data = addEvents2Skip(subject_data,events2skip)
            events2skip_subs = cell2num(events2skip(:,1));
            events2skip_evs = events2skip(:,2);
            for s = subject_data.subjects()
                e2s_index = find(events2skip_subs == s);
                if isempty(e2s_index)
                    subject_data = subject_data.addSubjectData(s,'__tmp_events_to_skip__',[]);
                else
                    subject_data = subject_data.addSubjectData(s,'__tmp_events_to_skip__',events2skip_evs(e2s_index));
                end
            end
        end
        
        function keyword = getKeyword()
            keyword = 'event';
        end
    end 
    
    methods(Static = true)
        function prop_info = getPropertyInfos()
            prop_info.trigger_type.test_fcn_handle = @(x) any(strcmp(x,{'start_end','start','end'}));
            prop_info.trigger_type.error_str = 'Trigger type must be ''start_end'',''start'' or ''end''.';
            
            prop_info.baseline_interval.test_fcn_handle = @(x) isnumeric(x) && isvector(x) && numel(x) == 2 && x(1) <= x(2);
            prop_info.baseline_interval.error_str = 'Baseline interval must be a numeric vector with two ascending elements.';
            
            prop_info.event_interval.test_fcn_handle = @(x) isnumeric(x) && isvector(x) && numel(x) == 2 && x(1) <= x(2);
            prop_info.event_interval.error_str = 'Event interval must be a numeric vector with two ascending elements.';
            
            prop_info.average_interval.test_fcn_handle = @(x) isnumeric(x) && isvector(x) && numel(x) == 2 && x(1) <= x(2);
            prop_info.average_interval.error_str = 'Average interval must be a numeric vector with two ascending elements.';
            
            prop_info.peak_interval.test_fcn_handle = @(x) isnumeric(x) && isvector(x) && numel(x) == 2 && x(1) <= x(2);
            prop_info.peak_interval.error_str = 'Peak interval must be a numeric vector with two ascending elements.';
            
            prop_info.save_mode.test_fcn_handle = @(x) any(strcmp(x,{'raw','normalized','zscore'}));
            prop_info.save_mode.error_str = 'Trigger type must be ''raw'',''normalized'' or ''zscore''.';
        end
    end
end
