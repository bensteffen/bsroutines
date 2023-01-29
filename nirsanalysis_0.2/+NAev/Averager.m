classdef Averager < handle
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
    % Date: 2015-07-13 19:06:21
    % Packaged: 2017-04-27 17:58:45
    properties
        data;
        trigger;
        trigger_token = 1;
        sample_rate = 10;
        interval = [-1 30];
        baseline_interval = [-1 1];
    end
    
    methods
        function obj = Averager(data,trigger)
            if nargin > 0
                obj.data = data;
            end
            if nargin > 1
                obj.trigger = trigger;
            end
        end
        
        function [era,era_taxis,baseline] = start(obj)

            events = find(obj.trigger == obj.trigger_token);
            tevents = sample2time(events,obj.sample_rate)';
            
            era = obj.extractEventwise(tevents,obj.interval);
            era_taxis = sample2time(1:tinterval2samplen(obj.interval,obj.sample_rate),obj.sample_rate)' + obj.interval(1);
            
            if isempty(obj.baseline_interval)
                baseline = zeros(size(era));
            else
                baseline = obj.extractEventwise(tevents,obj.baseline_interval);
            end
            
%             era = era - repmat(mean(baseline,1),[size(era,1) 1 1]);
        end
    end
    
    methods(Access = 'protected')
        function cutdata = extractEventwise(obj,event_onsets,cut_interval)
            [n,chn] = size(obj.data);
            t = sample2time(1:n,obj.sample_rate)';
            cut_length = tinterval2samplen(cut_interval,obj.sample_rate);
            evn = length(event_onsets);
            cutdata = zeros(cut_length,chn,evn);
            for evi = 1:evn
                tev = cut_interval + event_onsets(evi);
                toverlay = t >= tev(1) & t <= tev(2);
                cutmx = repmat(toverlay,[1 chn]);
                nov = sum(toverlay);
                if nov == cut_length
                    cutdata(:,:,evi) = reshape(obj.data(cutmx),[cut_length chn]);
                else
                    tadd = cut_length - nov;
                    if tev(1) < t(1)
                        cutdata(:,:,evi) = [repmat(obj.data(1,:),[tadd 1]); reshape(obj.data(cutmx),[nov chn])];
                    else
                        cutdata(:,:,evi) = [reshape(obj.data(cutmx),[nov chn]); repmat(obj.data(end,:),[tadd 1])];
                    end
                end
            end
        end
    end
end