function showLabelTab(chdata,label_type)

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
    % Date: 2014-06-30 18:24:21
    % Packaged: 2017-04-27 17:57:56
label_cell = groupLabels(chdata,label_type);
group_number = size(label_cell,1);
channel_number = sum(cellfun(@length,label_cell(:,2)));
colors = getColorList(1:group_number);
ps_colors = zeros(1,channel_number);

SP = ScrollGuiElements(group_number,3);
SP = SP.show();
for g = 1:group_number
    ps_colors(label_cell{g,2}) = g;
    set(SP.at(g,1),'Style','text','BackgroundColor',colors(g,:));
    set(SP.at(g,1),'Style','text','String',num2str(sort(label_cell{g,2})));
    set(SP.at(g,2),'Style','text','String',sprintf('%d%% ',round(100*label_cell{g,3})));
    set(SP.at(g,3),'Style','text','String',label_cell{g,1});
    for j = label_cell{g,2}
        chdata.chs(j).radius = 8*chdata.chs(j).anatomic_assignment.(label_type).prob(1);
    end
end
figure; map3d(ps_colors,chdata,'map_type','blobs','show_probeset',true,'show_head',true);