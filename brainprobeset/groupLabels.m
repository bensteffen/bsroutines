function varargout = groupLabels(chdata,label_type)

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
    % Date: 2016-04-18 10:47:55
    % Packaged: 2017-04-27 17:57:55
ch_cell = {};
ch_number = length(chdata.chs);
labels = {};

t = 1;
for j = 1:ch_number
    chlabels = chdata.chs(j).anatomic_assignment.(label_type).label;
    chlabels = chlabels(:);
    chprob = chdata.chs(j).anatomic_assignment.(label_type).prob;
    chprob = chprob(:);
    
    labels = [labels; chlabels];

    ch_cell{t,1} = sprintf('CH%d',chdata.chs(j).id);
    ch_cell(t,2:length(chlabels)+1) =  chlabels;
    t = t + 1;
    for p = 1:length(chprob)
        ch_cell{t,p+1} = chprob(p);
    end
    t = t + 1;
end

labels = unique(labels);
label_number = length(labels);
labels{label_number,3} = [];

for l = 1:label_number
    for j = 1:ch_number
        label_index = find(strcmp(labels{l,1},chdata.chs(j).anatomic_assignment.(label_type).label));
        if ~isempty(label_index) && label_index(1) == 1
            labels{l,2} = [labels{l,2} chdata.chs(j).id];
            labels{l,3} = [labels{l,3} valueat(chdata.chs(j).anatomic_assignment.(label_type).prob,1)];
        end
    end
end

l_delete = [];
for l = 1:label_number
    if isempty(labels{l,2})
        l_delete = [l_delete; l];
    end
end
labels(l_delete,:) = [];

label_number = size(labels,1);
label_ch_number = zeros(label_number,1);
for l = 1:label_number
    label_ch_number(l) = length(labels{l,2});
end
[~, l_sort] = sort(label_ch_number);
labels = labels(l_sort,:);

if nargout == 0
    label_print_data = cell(size(labels));
    label_print_data(:,1) = labels(:,1);
    label_print_data(:,2) = cellfun(@num2str,labels(:,2),'UniformOutput',false);
    fprintf('%s assignments for "%s"\n\n',upper(label_type),chdata.file_name);
    printCenteredStringTab(label_print_data,': ');
    varargout = {};
else
    varargout{1} = labels;
end
