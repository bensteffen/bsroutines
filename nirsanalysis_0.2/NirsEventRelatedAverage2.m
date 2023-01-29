classdef NirsEventRelatedAverage2 < NirsAnalysisObject
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
    % Date: 2017-01-24 13:46:17
    % Packaged: 2017-04-27 17:58:43
    methods
        function obj = NirsEventRelatedAverage2(varargin)
            obj = obj@NirsAnalysisObject(varargin);
            obj.param_names_ = {'amplitudes','maxima','maxima_latency','minima','minima_latency'};
        end
        
        function obj = createEra(obj, subject_list)
            % Start averaging process. Event related averages, peaks, and averaged
            % amplitudes will be calculated.
            %
            % Usage:
            % ERA = ERA.createEra(S) calculates the  for NirsSubjectData S. Results are stored in ERA.
            
            subjects2skip = experiment.getProperty('subjects2skip');
            subj_it = Iter(exclude(subject_list.subjects(),subjects2skip));
            
            categories = experiment.getProperty('category');
            cat_it = Iter(categories.tags(1));
            tokens = categories.extract({':','trigger_token'}).toArray();
            
            time_series_info = experiment.getProperty('time_series');
            dat_it = Iter(time_series_info.tags(1));
            sample_rates = time_series_info.extract({':','sample_rate'}).toArray();
            
            interval = obj.getProperty('interval');
            baseline_interval = obj.getProperty('baseline_interval');
            baseline_method = obj.getProperty('baseline_method');
            linear_detrend_flag = onoff2flag(obj.getProperty('linear_detrend'));
            
            fprintf('Event related averaging...\n');            
            psh = ProgressStatus([subj_it.n,dat_it.n,cat_it.n]);
            for s = subj_it
                for d = dat_it
                    fs = sample_rates(dat_it.i);
                    x = subject_list.getSubjectData(s,d);
                    tr = subject_list.getSubjectData(s,time_series_info.get({d,'trigger_name'}));
                    evs = tr(tr ~= 0);
                    b = blocks(x,find(tr),round(interval*fs) ...
                              ,'baseline_interval',round(baseline_interval*fs) ...
                              ,'baseline_method',baseline_method ...
                              );
                    t = linspace(interval(1),interval(2),size(b,1));
                    for c = cat_it
                        b_cat = b(:,:,evs == tokens(cat_it.i));
                        mb_cat = mean(b_cat,3);
                        if linear_detrend_flag
                            mb_cat = detrend(mb_cat,'linear');
                        end
                        obj = obj.add({'era.raw',d,c,s},b_cat,3);
                        obj = obj.add({'era.avg',d,c,s},t,mb_cat);
                        obj = obj.add({'era.std',d,c,s},std(b_cat,[],3));
                        obj = obj.add({'era.tax',d,c,s},t);
                        psh.update([subj_it.i dat_it.i cat_it.i]);
                    end
                end
            end
            psh.finish('Done!\n');
            
%             if ~isempty(obj.getProperty('average_window')), obj = obj.getAmplitudes(); end
%             if ~isempty(obj.getProperty(   'peak_window')), obj = obj.getPeaks()     ; end
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
            
            prop_info.baseline_interval.test_fcn_handle = @(x) fh_2vec(x);
            prop_info.baseline_interval.error_str = 'Baseline interval must be a vector with two ascending elements.';
            
            prop_info.baseline_method.test_fcn_handle = @(x) isfunction(x);
            prop_info.baseline_method.error_str = 'Baseline method must be a function handle';
            
            prop_info.peak_detection_sensitivity.test_fcn_handle = @(x) isnumeric(x) && ( isempty(x) || (isscalar(x) && x > 0) );
            prop_info.peak_detection_sensitivity.error_str = 'Peak detection sensitivity must be empty or a positive scalar.';
            
            prop_info.linear_detrend.test_fcn_handle = @(x) ischar(x) && any(strcmp(x,{'on','off'}));
            prop_info.linear_detrend.error_str = 'Linear detrend must be ''on'' or ''off''';
            
            prop_info.experiment.test_fcn_handle = @(x) isa(x,'NirsExperiment');
            prop_info.experiment.error_str = 'Experiment must be a NirsExperiment.';
            
            prop_info = NirsObject.addHelpTexts('event_related_average',prop_info);
        end
    end
    
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'event_related_average2';
        end
    end
end

