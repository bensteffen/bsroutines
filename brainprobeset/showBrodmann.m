function axes_handle = showBrodmann(baid,varargin)

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
    % Date: 2017-04-10 19:35:09
    % Packaged: 2017-04-27 17:57:56
param_defaults.probeset = [];
param_defaults.channel_style = 'ids';
param_defaults.color_map = autumn(numel(baid));
param_defaults.brain_alpha = 1.0;
param_defaults.area_alpha = ones(numel(baid),1);
param_defaults.template_name = 'Colin27(570mm)';
param_defaults.show_legend = true;
param_defaults.show_head = true;
param_defaults.show1020 = false;
param_defaults.light_on = true;
param_defaults.view_angles = [180 0];
param_defaults.axes_handle = [];
param_defaults.hide_channels = [];
param_defaults.mark_channels = [];
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

if ~isempty(probeset)
    template_name = probeset.getProperty('template_name');
end

load(fullfile(fileparts(mfilename('fullpath')),'templates',[template_name '.mat']));

if isempty(axes_handle)
    axes_handle = gca;
end
axes(axes_handle);
set(axes_handle,'DataAspectRatio',[1 1 1],'Visible','off');
brain_patch.FaceAlpha = brain_alpha;
patch(brain_patch);

if show_head
    head_patch.FaceAlpha = 0.15;
%     head_patch.FaceAlpha = 1;
    hp = patch(head_patch);
end

ban = numel(baid);
if ban > 0
    bacolors = getColorList(1:ban,color_map);
    for i = 1:ban
        bap = parcelPatch(brodmann,baid(i));
        bap.FaceColor = bacolors(i,:);
        bap.EdgeColor = 'none';
        bap.FaceAlpha = area_alpha(i);
        patch(bap);
    end
end

if ~isempty(probeset)
    if isa(probeset,'NirsProbeset')
        cdat = probeset.coordData();
    else
        cdat = probeset;
    end
    chn = numel(cdat.chs);
    for i = 1:chn
        switch channel_style
            case 'markers'
                marker = 'O';
            case 'ids'
                marker = num2str(cdat.chs(i).id);
            otherwise
                error('showBrodmann: Unknown channel style "%s"',channel_style);
        end
        if ~any(cdat.chs(i).id == hide_channels)
            text_color = ifel(any(cdat.chs(i).id == mark_channels),'g','k')
            writeNumberOnBrain(cdat.chs(i).head_coords,{marker},'surface_offset',5,'text_scale',0.25,'text_color',text_color);
        end
    end
end

if light_on
    brainlight;
end
axis off;
view(view_angles(1),view_angles(2));

if show1020
    showMarkers(markers);
end

if show_legend
    mxa = MatrixAlignment(get(axes_handle,'Parent'));
    mxa.addElement(1,1,axes_handle);
%     legend_ax = panelaxes;
%     imagesc(1:ban); set(gcf,'Colormap',color_map);
%     axis off; title('Brodmann area','FontWeight','Bold','FontSize',16); set(gcf,'Color','w'); hold on;
%     for i = 1:ban
%         text(i,1,num2str(baid(i)),'HorizontalAlignment','center','FontSize',12);
%     end
    mxa.addElement(2,1,showColorbar(color_map,'tag','Brodmann area','color_tags',createNames('%d',baid)));
    mxa.heights = [1 100];
    mxa.realign;
end