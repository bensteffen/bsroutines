classdef NirsEventRelatedAverage < NirsAnalysisObject
    %
    % Object used to calculate event related averages for time series with
    % a trigger.
    %
    % Example:
    % To conduct a event-related averaging:
    %    ERA = NirsEventRelatedAverage();     % create average object
    %    ERA = ERA.setProperties(settings);   % apply predefined settings (stored in structure "settings")
    %    ERA = ERA.createEra(S);              % perfom averaging using the subject data stored
    %                                         % stored in the NirsSubjectData S
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
    % Date: 2017-01-26 11:36:24
    % Packaged: 2017-04-27 17:58:43
    methods
        function obj = NirsEventRelatedAverage(varargin)
            obj = obj@NirsAnalysisObject(varargin);
            obj.param_names_ = {'amplitudes','maxima','maxima_latency','minima','minima_latency'};
        end
        
        function obj = createEra(obj, subject_list)
            % Start averaging process. Event related averages, peaks, and averaged
            % amplitudes will be calculated.
            %
            % Usage:
            % ERA = ERA.createEra(S) calculates the  for NirsSubjectData S. Results are stored in ERA.
            
            T = obj.getProperty('interval');
            pre_T = obj.getProperty('pre_time');
            experiment = obj.getProperty('experiment');
            subjects2skip = experiment.getProperty('subjects2skip');
            events2skip = experiment.getProperty('events2skip');
            events2skip_subs = cell2num(events2skip(:,1));
            events2skip_evs = events2skip(:,2);
            categories = experiment.getProperty('category');
            time_series_info = experiment.getProperty('time_series');
            data_names = time_series_info.tags(1);
            fs = time_series_info.extract({':','sample_rate'}).toArray();
            trigger_names = time_series_info.extract({':','trigger_name'}).toCell();
            subjects = exclude(subject_list.subjects(),subjects2skip);
            linear_detrend_flag = onoff2flag(obj.getProperty('linear_detrend'));
            
            for s = subjects
                e2s_index = find(events2skip_subs == s);
                if isempty(e2s_index)
                    subject_list = subject_list.addSubjectData(s,'__tmp_events_to_skip__',[]);
                else
                    subject_list = subject_list.addSubjectData(s,'__tmp_events_to_skip__',events2skip_evs(e2s_index));
                end
                for d = 1:length(data_names)
                    subject_list = subject_list.addSubjectData(s,['__tmp_' data_names{d} '_sample_rate__'],fs(d));
                end
            end
            
            input_names = unique(trigger_names)';
            input_names(2,:) = repmat({'__tmp_events_to_skip__'},[1 length(input_names)]);
            F = NirsDataFunctor();
            F = F.setProperty('function_handle',@NAev.clearTriggerEvents);
            F = F.setProperty('input_names',input_names);
            subject_list = subject_list.processData(F,subjects);

            F = NirsDataFunctor();
            F = F.setProperty('function_handle',@NAev.averageOverEvents);
            input_names = cell(3,length(data_names));
            output_names = cell(2,length(data_names));
            for d = 1:length(data_names)
                input_names{1,d} = data_names{d};
                input_names{2,d} = ['__tmp_' data_names{d} '_sample_rate__'];
                input_names{3,d} = trigger_names{d};
                output_names{1,d} = ['__tmp_era_mean_' data_names{d} '__'];
                output_names{2,d} = ['__tmp_era_std_' data_names{d} '__'];
            end
            F = F.setProperty('input_names',input_names);
            F = F.setProperty('output_names',output_names);
            
            category_names = categories.tags(1);
            for c = 1:categories.numel()
                F = F.setProperty('parameters',{categories.at(c), pre_T, T,linear_detrend_flag});
                subject_list = subject_list.processData(F,subjects);
                for d = 1:length(data_names)
                    for s = subjects
                        obj = obj.add({'era.avg',data_names{d},category_names{c},s},subject_list.getSubjectData(s,['__tmp_era_mean_' data_names{d} '__']));
                        obj = obj.add({'era.std',data_names{d},category_names{c},s},subject_list.getSubjectData(s,['__tmp_era_std_' data_names{d} '__']));
                    end
                end
            end
            if ~isempty(obj.getProperty('average_window')), obj = obj.getAmplitudes(); end
            if ~isempty(obj.getProperty(   'peak_window')), obj = obj.getPeaks()     ; end
        end
    end
    
    methods(Access = 'protected')        
        function obj = getAmplitudes(obj)
            experiment = obj.getProperty('experiment');
            cat_names = experiment.getProperty('category').tags(1);
            time_series_info = experiment.getProperty('time_series');
            data_names = time_series_info.tags(1);
            fs = time_series_info.extract({':','sample_rate'}).toArray();
            subjects = cell2num(obj.tags(4)');
            interval = obj.getProperty('interval');
            pre_win = obj.getProperty('pre_time');
            amp_wins = obj.getProperty('average_window');
            amp_wins = ifel(iscell(amp_wins),amp_wins,{amp_wins});

            fprintf('Averaging amplitudes... ');
            psh = ProgressStatus([numel(amp_wins) length(data_names) length(cat_names) length(subjects)]);
            for a = 1:numel(amp_wins)
                amp_win = amp_wins{a};
                amp_name = ifel(numel(amp_wins) == 1,'amplitudes',sprintf('amplitudes.win%d',a));
                if amp_win(1) < interval(1) || amp_win(2) > interval(2)
                    error('NirsEventRelatedAverage.getAmplitude: Amplitude window must fit into average window!')              
                end

                for d = 1:length(data_names)
                    startI = round(fs(d)*(amp_win(1) + pre_win - interval(1))) + 1;
                    endI = round(fs(d)*(amp_win(2) + pre_win - interval(1)));
                    for c = 1:length(cat_names)
                        for s = subjects
                            sub_data = obj.get({'era.avg',data_names{d},cat_names{c},s});
                            if all(isnan(sub_data(:)))
                                amps = zeros(1,size(sub_data,2));
                            else
                                amps = mean(sub_data(startI:endI,:));
                            end
                            obj = obj.add({amp_name,data_names{d},cat_names{c},s},amps);
                            psh.update([a d c s]);
                        end
                    end
                end
            end
            psh.finish('Done!\n');
        end
        
        function obj = getPeaks(obj)
            experiment = obj.getProperty('experiment');
            cat_names = experiment.getProperty('category').tags(1);
            time_series_info = experiment.getProperty('time_series');
            data_names = time_series_info.tags(1);
            fs = time_series_info.extract({':','sample_rate'}).toArray();
            subjects = cell2num(obj.tags(4)');
            interval = obj.getProperty('interval');
            pre_win = obj.getProperty('pre_time');
            delta = obj.getProperty('peak_detection_sensitivity');
            
            peak_wins = obj.getProperty('peak_window');
            peak_wins = ifel(iscell(peak_wins),peak_wins,{peak_wins});
            peak_wins = peak_wins(:);
            if any(~cellfun(@(x) withinrange(x(1),interval),peak_wins) | ~cellfun(@(x) withinrange(x(2),interval),peak_wins))
                error('NirsEventRelatedAverage.getAmplitude: Peak window must fit into average window!');
            end           
            wn = length(peak_wins);
            
            win_names = ifel(wn == 1,{''},createNames('.win%d',(1:wn)'));
            
            fprintf('Detecting peaks... ');
            psh = ProgressStatus([length(data_names) length(cat_names) length(subjects)]);

            for d = 1:length(data_names)
                for c = 1:length(cat_names)
                    for s = subjects
                        era = obj.get({'era.avg',data_names{d},cat_names{c},s});
                        t = (0:size(era,1)-1)'/fs(d) - pre_win;
                        for a = 1:wn
                            [max_latency,max_amp,min_latency,min_amp] = deal(zeros(1,size(era,2)));
                            if ~all(isnan(era(:)))
                                pd = peakdetection(t,era,delta,peak_wins{a});
                                for j = 1:size(era,2)
                                    [max_latency(j),max_amp(j)] = maxat(pd(j).max.pos,pd(j).max.val);
                                    [min_latency(j),min_amp(j)] = minat(pd(j).min.pos,pd(j).min.val);
                                end
                            end
                            obj = obj.add({sprintf('maxima%s.value',win_names{a}),data_names{d},cat_names{c},s},max_amp);
                            obj = obj.add({sprintf('maxima%s.latency',win_names{a}),data_names{d},cat_names{c},s},max_latency);
                            obj = obj.add({sprintf('minima%s.value',win_names{a}),data_names{d},cat_names{c},s},min_amp);
                            obj = obj.add({sprintf('minima%s.latency',win_names{a}),data_names{d},cat_names{c},s},min_latency);
                            
                            amps = [min_amp max_amp];
                            lats = [min_latency max_latency];
                            i = maxat(abs(amps));
                            obj = obj.add({sprintf('peaks%s.value',win_names{a}),data_names{d},cat_names{c},s},amps(i));
                            obj = obj.add({sprintf('peaks%s.latency',win_names{a}),data_names{d},cat_names{c},s},lats(i));
                        end
                        psh.update([d c s]);
                    end
                end
            end
            psh.finish('Done!\n');
        end        

        function obj = update(obj,prop_name,prop_value)
        end
    end
    
    methods(Static = true)
        function prop_info = getPropertyInfos()
            fh_2vec = @(x) isnumeric(x) && isvector(x) && length(x) == 2 && x(1) < x(2);
            
            prop_info.interval.test_fcn_handle = @(x) fh_2vec(x);
            prop_info.interval.error_str = 'Interval must be a vector with two ascending elements.';
            
            prop_info.peak_window.test_fcn_handle = @(x) isempty(x) || fh_2vec(x) || (iscell(x) && all(cellfun(fh_2vec,x(:))));
            prop_info.peak_window.error_str = 'Peak window must be a vector with two ascending elements - or a cell with such vectors.';
            
            prop_info.average_window.test_fcn_handle = @(x) isempty(x) || fh_2vec(x) || (iscell(x) && all(cellfun(fh_2vec,x(:))));
            prop_info.average_window.error_str = 'Averag window must be a vector with two ascending elements - or a cell with such vectors.';
            
            prop_info.pre_time.test_fcn_handle = @(x) isnumeric(x) && isscalar(x) && x > 0;
            prop_info.pre_time.error_str = 'Pre time must be a positive scalar.';
            
            prop_info.peak_detection_sensitivity.test_fcn_handle = @(x) isnumeric(x) && isscalar(x) && x > 0;
            prop_info.peak_detection_sensitivity.error_str = 'Peak detection sensitivity must be a positive scalar.';
            
            prop_info.linear_detrend.test_fcn_handle = @(x) ischar(x) && any(strcmp(x,{'on','off'}));
            prop_info.linear_detrend.error_str = 'Linear detrend must be ''on'' or ''off''';
            
            prop_info.experiment.test_fcn_handle = @(x) isa(x,'NirsExperiment');
            prop_info.experiment.error_str = 'Experiment must be a NirsExperiment.';
            
            prop_info = NirsObject.addHelpTexts('event_related_average',prop_info);
        end
    end
    
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'event_related_average';
        end
    end
end

