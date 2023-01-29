function varargout = barwebplot(y,yerr,varargin)

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
    % Date: 2016-10-06 16:31:38
    % Packaged: 2017-04-27 17:58:04
param_defaults.color_map = lines;
param_defaults.bar_distance = [0.1 0.3];
param_defaults.brace_pairs = {};
param_defaults.axes_handle = [];
param_defaults.show_baseline = true;
param_defaults.bar_line_styles = {};
param_defaults.data_cloud = {};
param_defaults.bar_offset = 0;
param_defaults.group_names = {};
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

if isempty(axes_handle)
    axes_handle = gca;
end

condn = size(y,1);
groupn = size(y,2);
bar_colors = getColorList(1:groupn,color_map);

bar_width = 1 - (groupn - 1)*bar_distance(1) - bar_distance(2);
condl = bar_distance(2) + (groupn - 1)*bar_distance(1) + groupn*bar_width;

x = [0 0];
for c = 1:condn
    for g = 1:groupn
        x(1) = 0.5*bar_distance(2) + (g - 1)*(bar_width + bar_distance(1));
        x(2) = x(1) + bar_width;
        x = c + x/condl - 0.5;
        bar_data(c,g).x = mean(x);
        bar_data(c,g).y = y(c,g);
        bar_data(c,g).barpatch.Vertices = [x(1) 0; x(2) 0; x(2) y(c,g); x(1) y(c,g)];
        bar_data(c,g).barpatch.Faces = [1 2 3 4];
        bar_data(c,g).barpatch.FaceColor = bar_colors(g,:);
        bar_data(c,g).barpatch.LineWidth = 2;
        [xm,yn,yp] = deal(mean(x),-yerr(c,g),yerr(c,g));
        [xn,xp] = deal(xm-0.1*bar_width/condl,xm+0.1*bar_width/condl);
        bar_data(c,g).errbar(1).x = [xm xm];
        bar_data(c,g).errbar(1).y = y(c,g) + [yn yp];
        bar_data(c,g).errbar(2).x = [xn xp];
        bar_data(c,g).errbar(2).y = y(c,g) + [yn yn];
        bar_data(c,g).errbar(3).x = [xn xp];
        bar_data(c,g).errbar(3).y = y(c,g) + [yp yp];
        if ~isempty(bar_line_styles)
            if ischar(bar_line_styles)
                bar_data(c,g).barpatch.LineStyle = bar_line_styles;
            else
                bar_data(c,g).barpatch.LineStyle = bar_line_styles{c,g};
            end 
        end
        if ~isempty(data_cloud)
            bar_data(c,g).cloud_data = data_cloud{c,g};
        end
    end
end

for b = 1:numel(bar_data)
    patch(bar_data(b).barpatch,'Parent',axes_handle); hold on;
    if isfield(bar_data(b),'cloud_data')
        x0 = mean(bar_data(b).barpatch.Vertices(1:2,1));
        s = diff(bar_data(b).barpatch.Vertices(1:2,1));
        axes(axes_handle);
        plot(0.1*s*randn(numel(bar_data(b).cloud_data),1) + x0,bar_data(b).cloud_data(:),'.','Color',[1 1 1]*0.0,'MarkerSize',12);
    end
    for e = 1:3
        line(bar_data(b).errbar(e).x,bar_data(b).errbar(e).y,'Parent',axes_handle,'Color','k','LineWidth',2);
    end
end

set(axes_handle,'XColor','w','XTick',[]);
if show_baseline
    set(get(axes_handle,'Parent'),'ResizeFcn',@(h,evd) line(get(axes_handle,'XLim'),[0 0],'Parent',axes_handle,'Color','k','LineWidth',2));
end

psiz = getpixelposition(axes_handle);
ysiz = diff(get(axes_handle,'Ylim'));
offset = 5*ysiz/psiz(4);
bar_offset = bar_offset*ysiz/psiz(4);

if ~isempty(brace_pairs)
    bar_data = bar_data';
    bn = size(brace_pairs,1);
    height = y' + yerr'; 
    height = height(:);
    max_height = max(0,max(height));
    brace_height = max_height + offset;
%     brace_dist = max_height + offset;
    
%     [brace_y,brace_max_i] = deal(zeros(1,bn));
%     for b = 1:bn
%         pair = sort(brace_pairs{b,1});
%         brace_y(b) = max(height(pair(1):pair(2)));
%         brace_max_i(b) = find(brace_y(b) == height);
%     end
    
%     start_bars = unique(brace_max_i);
%     for s = 1:length(start_bars)
%         bc = 1;
%         for b = find(brace_max_i == start_bars(s))
%             pair = sort(brace_pairs{b,1});
%             by = brace_y(b) + bc*brace_dist; bc = bc + 1;
%             x1 = bar_data(pair(1)).x;
%             x2 = bar_data(pair(2)).x;
%             lx = [x1 x1 x2 x2];
%             ly = [by-0.3*brace_dist by by by-0.5*brace_dist];
%             line(lx,ly,'LineWidth',2,'Color',[0 0 0],'Parent',axes_handle);
%             text(mean([x1 x2]),by,brace_pairs{b,2},'Parent',axes_handle,'FontSize',12,'Color','k','FontWeight','bold','HorizontalAlignment','center','VerticalAlignment','bottom');
%         end
%     end

    for b = 1:size(brace_pairs,1)
        [pair_ids,pair_str] = deal(brace_pairs{b,:});
        by = brace_height + (abs(diff(pair_ids)) - 1)*4*offset + bar_offset;
        x1 = bar_data(pair_ids(1)).x;
        x2 = bar_data(pair_ids(2)).x;
        lx = [x1 x1 x2 x2];
        ly = [by-offset/2 by by by-offset/2];
        line(lx,ly,'LineWidth',2,'Color',[0 0 0],'Parent',axes_handle);
        text(mean([x1 x2]),by,pair_str,'Parent',axes_handle,'FontSize',12,'Color','k','FontWeight','bold','HorizontalAlignment','center','VerticalAlignment','bottom');
    end

end

if iscellstr(group_names)
    ylims = get(axes_handle,'YLim');
    set(axes_handle,'Clipping','off');
    gr_it = Iter(group_names);
    for g = gr_it
        text(gr_it.i,ylims(1),g,'Parent',axes_handle,'HorizontalAlignment','center');
    end
end


if nargout > 0
    varargout{1} = axes_handle;
end