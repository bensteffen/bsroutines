function mybarplot(y,e,varargin)

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
    % Date: 2013-07-19 18:41:52
    % Packaged: 2017-04-27 17:58:14
param_defaults.brace_pairs = {};
param_defaults.axes_handle = gca;
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);


bar(axes_handle,y,'LineWidth',2);
set(axes_handle,'NextPlot','add');
errorbar(1:length(y),y,e,'k.','MarkerSize',0.001,'LineWidth',2,'Parent',axes_handle);

if ~isempty(brace_pairs)
    bn = length(brace_pairs);
    height = y + e;
    max_height = max(height);
    brace_dist = 0.1*max_height;
    
    [brace_y,brace_max_i] = deal(zeros(1,bn));
    for b = 1:bn
        pair = sort(brace_pairs{b});
        brace_y(b) = max(height(pair(1):pair(2)));
        brace_max_i(b) = find(brace_y(b) == height);
    end
    
    start_bars = unique(brace_max_i);
    for s = 1:length(start_bars)
        bc = 1;
        for b = find(brace_max_i == start_bars(s))
            pair = sort(brace_pairs{b});
            by = brace_y(b) + bc*brace_dist; bc = bc + 1;
            lx = [pair(1) pair(1) pair(2) pair(2)];
            ly = [by-0.3*brace_dist by by by-0.3*brace_dist];
            line(lx,ly,'LineWidth',2,'Color',[0 0 0]);
        end
    end
end