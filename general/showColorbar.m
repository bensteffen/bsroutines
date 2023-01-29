function [cbh,ax] = showColorbar(color_map,varargin)

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
    % Date: 2017-02-24 15:27:00
    % Packaged: 2017-04-27 17:58:18
param_defaults.tag = '';
param_defaults.color_limit = [-1 1];
param_defaults.color_tags = {};
param_defaults.rotate_bar = false;
param_defaults.width = 0.5;
param_defaults.height = 0.25;
param_defaults.font_size = 20;
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);


cbh = uipanel('Visible','on','BorderType','none');

n = size(color_map,1);
ax = axes('Parent',cbh);
if rotate_bar
    imagesc(fliplr(1:n)');
    ylabel(tag,'FontWeight','Bold','FontSize',font_size);
else
    imagesc(1:n);
    title(tag,'FontWeight','Bold','FontSize',font_size);
end
colormap(ax,color_map);
hold on;
set(cbh,'BackgroundColor','w');

pos = [(1-width)/2 (1-height)/2 width height];
if rotate_bar
    pos = pos([2 1 4 3]);
end
set(ax,'Position',pos);
[xlim,ylim] = deal(get(ax,'Xlim'),get(ax,'Ylim'));
set(ax,'LineWidth',2,'XTick',[],'YTick',[]);

if ~isempty(color_tags)
    tprops = {'HorizontalAlignment','center','VerticalAlignment','top','FontSize',ceil(0.75*font_size)};
    for x = 1:n
        text(x,ylim(2),color_tags{x},tprops{:});
    end
else
    if rotate_bar
        tprops = {'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',font_size};
        x = xlim(2) + 0.15*diff(xlim);
        text(x,ylim(2),num2str(color_limit(1)),tprops{:});
        text(x,ylim(1),num2str(color_limit(2)),tprops{:});
        text(x,mean(ylim),num2str(mean(color_limit)),tprops{:});
    else
        tprops = {'HorizontalAlignment','center','VerticalAlignment','top','FontSize',font_size};
        text(xlim(1),ylim(2),num2str(color_limit(1)),tprops{:});
        text(xlim(2),ylim(2),num2str(color_limit(2)),tprops{:});
        text(mean(xlim),ylim(2),num2str(mean(color_limit)),tprops{:});
    end
end
% if nargout > 1
%     varargout{1} = cbh;
% end
