function assigned = assignAnatomicalLabels(x,ana_label_data,label_types,label_name_lists)

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
    % Date: 2013-04-04 16:55:51
    % Packaged: 2017-04-27 17:57:54
ana_label_data(:,1:3) = round(ana_label_data(:,1:3));
[brain,ui] = unique(ana_label_data(:,1:3),'rows');
label_ids = ana_label_data(ui,4:6);

[~,imin] = min(voxelDistance(brain,x,[1 1 1]));
x = brain(imin,:);
sph = createVoxelSphere(x,10);


vxs_index = voxelOverlap(brain,sph);
vx_number = length(vxs_index);
for i = 1:length(label_types)
    curr_label_list = label_name_lists{i};
    label_vol = voxel2volume(brain,label_ids(:,i));
    labels_found = unique(label_vol(vxs_index));
    for j = 1:length(labels_found)
        assigned.(label_types{i}).label{j} = curr_label_list{labels_found(j)};
        assigned.(label_types{i}).prob(j) = sum(label_vol(vxs_index) == labels_found(j))/vx_number;
    end
    [assigned.(label_types{i}).prob,i_sort] = sort(assigned.(label_types{i}).prob,'descend');
    assigned.(label_types{i}).label = assigned.(label_types{i}).label(i_sort);
end