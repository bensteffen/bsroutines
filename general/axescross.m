function axescross(axes_handle,varargin)

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
    % Date: 2016-06-28 16:51:55
    % Packaged: 2017-04-27 17:58:04
cross_width = 2;
label_size = 8;


set(axes_handle,'Visible','off');
parent = get(axes_handle,'Parent');
% if iscell(parent)
%     parent = cell2mat(parent);
% end
if ~iscell(parent)
    parent = {parent};
end
cellfun(@(p) set(p,'ResizeFcn',@updateCross),parent);
handles = [];
% updateCross();

    function updateCross(h,evd)
        rmchildren(handles);
        for axh = axes_handle(:)'
            axsize = getpixelposition(axh);
            xlim = get(axh,'Xlim');
            xlength = diff(xlim);
            dx = 5*xlength/axsize(3);
            xtick = get(axh,'XTick');

            ylim = get(axh,'Ylim');
            ylength = diff(ylim);
            dy = 5*ylength/axsize(4);
            ytick = get(axh,'YTick');

            handles = [handles; line(xlim,[0 0],'Color',[1 1 1]*0.5,'LineWidth',cross_width,'Parent',axh)];
            for x = xtick
                handles = [handles; line([x x],dy*[-1 1],'Color',[1 1 1]*0.5,'LineWidth',cross_width,'Parent',axh)];
            end 
            handles = [handles; line([0 0],ylim,'Color',[1 1 1]*0.5,'LineWidth',cross_width,'Parent',axh)];
            for y = ytick
                handles = [handles; line(dx*[-1 1],[y y],'Color',[1 1 1]*0.5,'LineWidth',cross_width,'Parent',axh)];
            end
            set(axh,'XLim',xlim,'YLim',ylim);
            
            handles = [handles; text(xtick,2*dy*ones(1,length(xtick)),createTickLabels(xtick),...
                       'FontWeight','bold','FontSize',label_size,'HorizontalAlignment','center','Color',[1 1 1]*0.5,'Parent',axh)];
            handles = [handles; text(2*dx*ones(1,length(ytick)),ytick,createTickLabels(ytick),...
                       'FontWeight','bold','FontSize',label_size,'Color',[1 1 1]*0.5,'Parent',axh)];
                  
            set(axh,'Children',flipud(get(axh,'Children')));
        end
    end

    function tick_labels = createTickLabels(ticks)
        i_zero = ticks == 0;
        [~,prec] = countdigits(mean(diff(ticks)));
        tick_labels = num2cellstr(ticks,sprintf('%%.%df',prec));
        if any(i_zero)
            tick_labels{i_zero} = '';
        end
    end
end