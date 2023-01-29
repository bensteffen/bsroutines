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


classdef NirsEventAverager < NirsAnalysisObject
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
    % Date: 2017-01-23 17:10:06
    % Packaged: 2017-04-27 17:58:43
    methods
        function obj = NirsEventAverager(varargin)
            obj = obj@NirsAnalysisObject(varargin);
        end
        
        function obj = start(obj, subject_list)
            experiment = obj.getProperty('experiment');
            
            subjects2skip = experiment.getProperty('subjects2skip');
            subj_it = Iter(exclude(subject_list.subjects(),subjects2skip));
            
            categories = experiment.getProperty('category');
            cat_it = Iter(categories.tags(1));
            
            time_series_info = experiment.getProperty('time_series');
            dat_it = Iter(time_series_info.tags(1));
            
            interval = obj.getProperty('interval');
            baseline_interval = obj.getProperty('baseline_interval');
            
            fprintf('Event related averaging...\n');            
            psh = ProgressStatus([subj_it.n,dat_it.n,cat_it.n],['\t' d ' (%d%%%%) ']);
            for s = subj_it
                for d = dat_it
                    fs = time_series_info.get({d,'sample_rate'});
                    x = subject_list.getSubjectData(s,d);
                    tr = subject_list.getSubjectData(s,time_series_info.get({d,'trigger_name'}));
                    b = blocks(x,find(tr),round(interval*fs) ...
                              ,'baseline_interval',round(baseline_interval*fs) ...
                              );
                    t = linspace(interval(1),interval(2),size(b,1));
                    for c = cat_it
                        b_cat = b(:,:,find(tr == categories.get({c,'trigger_token'})));
                        mb_cat = mean(b_cat,3);
                        obj = obj.add({'era.raw',d,c,s},b_cat,3);
                        obj = obj.add({'era.avg',d,c,s},t,mb_cat);
                        obj = obj.add({'era.std',d,c,s},std(b_cat,[],3));
                        obj = obj.add({'era.tax',d,c,s},t);
                        psh.update([subj_it.i dat_it.i cat_it.i]);
                    end
                end
            end
            psh.finish('Done!\n');
        end
    end
    
    methods(Access = 'protected')
        function obj = getPeaks(obj,t,x)
            delta = obj.getProperty('peak_detection_sensitivity');
            peak_wins = obj.getProperty('peak_window');
            peak_wins = ifel(iscell(peak_wins),peak_wins,{peak_wins});
            peak_wins = peak_wins(:);
            if any(~cellfun(@(x) withinrange(x(1),interval),peak_wins) | ~cellfun(@(x) withinrange(x(2),interval),peak_wins))
                error('NirsEventAverager.getPeaks: Peak window must fit into average window!');
            end
            
            pd = peakdetection(t,x,delta,peak_wins{a});
        end
        
        function obj = update(obj,prop_name,prop_value)
        end
    end
    
    methods(Static = true)
        function prop_info = getPropertyInfos()
            fh_2vec = @(x) isnumeric(x) && isvector(x) && length(x) == 2 && x(1) < x(2);
            
            prop_info.interval.test_fcn_handle = @(x) fh_2vec(x);
            prop_info.interval.error_str = 'Interval must be a vector with two ascending elements.';
            
            prop_info.baseline_interval.test_fcn_handle = @(x) fh_2vec(x);
            prop_info.interval.error_str = 'Baseline interval must be a vector with two ascending elements.';
            
            prop_info.experiment.test_fcn_handle = @(x) isa(x,'NirsExperiment');
            prop_info.experiment.error_str = 'Experiment must be a NirsExperiment.';
        end
    end
    
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'event_averager';
        end
    end
end

