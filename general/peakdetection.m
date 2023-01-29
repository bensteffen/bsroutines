function [peaks,peaks_extrema] = peakdetection(x,Y,delta,peak_interval)

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
    % Date: 2017-01-25 11:26:20
    % Packaged: 2017-04-27 17:58:15
    if nargin < 3, delta = [];                    end
    if nargin < 4, peak_interval = [x(1) x(end)]; end
    
    J = size(Y,2);
    peaks = struct('min',struct('pos',[],'val',[]),'max',struct('pos',[],'val',[]));
    nans = NaN(1,J);
    peaks_extrema = struct('min',struct('pos',nans,'val',nans),'max',struct('pos',nans,'val',nans));
    win = x >= peak_interval(1) & x <= peak_interval(2);
    xwin = x(win);
    
    for j = 1:J
        if all(isnan(Y(:,j)))
            peaks(j).max = struct('val',NaN,'pos',NaN);
            peaks(j).max = struct('val',NaN,'pos',NaN);
        else
            curr_delta = ifel(isempty(delta),0.5*std(Y(:,j)),delta);
            [max_tab,min_tab] = peakdet(Y(:,j),curr_delta,x);
            peaks(j).max = assignPeaks(max_tab,@max);
            peaks(j).min = assignPeaks(min_tab,@min);
            
            [peaks_extrema.max.pos(j),peaks_extrema.max.val(j)] = maxat(peaks(j).max.pos,peaks(j).max.val);
            [peaks_extrema.min.pos(j),peaks_extrema.min.val(j)] = minat(peaks(j).min.pos,peaks(j).min.val);
        end
    end

    function s = assignPeaks(peak_tab,minmax_handle)
        if isempty(peak_tab)
            [val,pos] = deal([]);
        else
            peaks_within = withinrange(peak_tab(:,1),peak_interval);
            val = peak_tab(peaks_within,2);
            pos = peak_tab(peaks_within,1);
        end
        if isempty(val)
            [val,i] = minmax_handle(Y(win,j));
            pos = xwin(i);
        end
        s.val = val;
        s.pos = pos;
    end
end