function assigned = anatomicalAssignment(x,lable_data)

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
    % Date: 2016-04-05 18:49:45
    % Packaged: 2017-04-27 17:57:54
x =  nearestvoxel(x,lable_data.xyz);
sph = createVoxelSphere(x,10);

overlapping = findVoxel22(lable_data.xyz,sph);
overlapping(overlapping == 0) = [];
vx_number = length(overlapping);

labels_found = unique(lable_data.area(overlapping));

for j = 1:length(labels_found)
    assigned.label{j} = lable_data.labels{labels_found(j)};
    assigned.prob(j) = sum(lable_data.area(overlapping) == labels_found(j))/vx_number;
end
[assigned.prob,i_sort] = sort(assigned.prob,'descend');
assigned.label = assigned.label(i_sort);