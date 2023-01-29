function p = coversBrodmann(baids,probeset,varargin)

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
    % Date: 2017-04-11 13:15:46
    % Packaged: 2017-04-27 17:57:55
param_defaults.show = false;
param_defaults.show_legend = true;
param_defaults.axes_handle = [];
param_defaults.color_map = braincmap2pos(11);
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

baids_cell = createNames('%d',baids);
chd = probeset.coordData();

chids = arrayfun(@(x) x.id,chd.chs);

p = NaN(1,max(chids));

for j = 1:length(chd.chs)
    labels = strsplit(chd.chs(j).anatomic_assignment.brodmann.label,' - ');
    labels = nonunicfun(@(x) x{1},labels);
    p_curr = [];
    for b = Iter(baids_cell)
        bai = strcmp(labels,b);
        if any(bai)
            p_curr = [p_curr chd.chs(j).anatomic_assignment.brodmann.prob(bai)];
        end
    end
    if ~isempty(p_curr)
%         p(chd.chs(j).id) = max(p_curr);
        p(chd.chs(j).id) = sum(p_curr);
    end
end

if show
    if isempty(axes_handle)
        axes_handle = gca;
    end
    
    ph = map3d(p,chd,'significance',find(p >= 0.5),'axes_handle',axes_handle,'show_on_head',true,'color_map',color_map,'color_limit',[0 1],'show_probeset',true,'template_name',probeset.getProperty('template_name'));
    set(ph,'FaceAlpha',0.7);
    showBrodmann(baids,'axes_handle',axes_handle,'color_map',repmat([0 0 0],[numel(baids) 1]),'show_head',false,'template_name',probeset.getProperty('template_name'),'light_on',false,'area_alpha',repmat(0.4,[1 length(baids)]));
    view(180,0);

    if show_legend
        mxa = MatrixAlignment(gcf);
        mxa.addElement(1,1,axes_handle);
        mxa.addElement(2,1,showColorbar(color_map,'color_limit',[0 1],'tag','Probability'));
        mxa.heights = [1 100];
        mxa.realign;
    end
end
p(isnan(p)) = 0;