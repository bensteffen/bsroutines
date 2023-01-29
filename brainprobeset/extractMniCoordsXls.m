function probeset_mnidata = extractMniCoordsXls(fname,varargin)

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
    % Date: 2017-04-10 18:21:02
    % Packaged: 2017-04-27 17:57:55
param_defaults.label_column = [];
param_defaults.label_prob_column = [];
param_defaults.opt_ch_assignment = false;
param_defaults.template_name = 'Colin27';
param_defaults.label_types = {'brodmann'};
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

label_types = ifel(ischar(label_types),{label_types},label_types);

p = fulldir(fname);
[~,n,e] = fileparts(fname);
probeset_mnidata.file_name = fullfile(p,[n e]);

fprintf('Reading and analyzing channel coordinates from "%s"... ',probeset_mnidata.file_name);

switch e
    case '.xls'
        [~,~,data] = xlsread(fname);
    otherwise
        data = file2cell(fname);
end

if isempty(label_column)
    label_available = false;
else
    label_available = true;
    if isempty(label_prob_column)
        label_prob_column = label_column + 1;
    end
end

probeset_mnidata.chs = struct;
probeset_mnidata.opts = struct;
curr_key = 'HEADER';
counter.aal = 0;
counter.ch = 0;
counter.op = 0;
for i = 1:size(data,1)
    str = data{i,1};
    if ~isnan(str)
        counter.aal = 1;
        if strstart(str,'CH')
            curr_key = 'CH';
            counter.ch = counter.ch + 1;
            probeset_mnidata.chs(counter.ch,1).id = findNumberByKeyword(str,'CH');
            if opt_ch_assignment
                probeset_mnidata.chs(counter.ch,1).optode_pair = [data{i,2} data{i,3}];
            else
                probeset_mnidata.chs(counter.ch,1).coords = brainpatch2colin27([data{i,2} data{i,3} data{i,4}]);
            end
            if size(data,2) < 5 || isnan(data{i,5})
                probeset_mnidata.chs(counter.ch,1).radius = 5;
            else
                probeset_mnidata.chs(counter.ch,1).radius = data{i,5};
            end
            if label_available
                probeset_mnidata.chs(counter.ch,1).anatomic_assignment.(label_types{1}).label{counter.aal,1} = data{i,label_column};
                probeset_mnidata.chs(counter.ch,1).anatomic_assignment.(label_types{1}).prob(counter.aal,1) = data{i,label_prob_column};
                counter.aal = counter.aal + 1;
            end
        elseif strstart(str,'OP')
            curr_key = 'OP';
            counter.op = counter.op + 1;
            probeset_mnidata.opts(counter.op,1).id = findNumberByKeyword(str,'OP');
            probeset_mnidata.opts(counter.op,1).coords = brainpatch2colin27([data{i,2} data{i,3} data{i,4}]);
            if size(data,2) < 5 || isnan(data{i,5})
                probeset_mnidata.opts(counter.op,1).radius = 5;
            else
                probeset_mnidata.opts(counter.op,1).radius = data{i,5};
            end
            if label_available
                probeset_mnidata.opts(counter.op,1).anatomic_assignment.(label_types{1}).label{counter.aal,1} = data{i,label_column};
                probeset_mnidata.opts(counter.op,1).anatomic_assignment.(label_types{1}).prob(counter.aal,1) = data{i,label_prob_column};
                counter.aal = counter.aal + 1;
            end
        end
    else
        if label_available
            switch curr_key
                case 'CH'
                    probeset_mnidata.chs(counter.ch,1).anatomic_assignment.(label_types{1}).label{counter.aal,1} = data{i,label_column};
                    probeset_mnidata.chs(counter.ch,1).anatomic_assignment.(label_types{1}).prob(counter.aal,1) = data{i,label_prob_column};
                    counter.aal = counter.aal + 1;
                case 'OP'
                    probeset_mnidata.opts(counter.op,1).anatomic_assignment.(label_types{1}).label{counter.aal,1} = data{i,label_column};
                    probeset_mnidata.opts(counter.op,1).anatomic_assignment.(label_types{1}).prob(counter.aal,1) = data{i,label_prob_column};
                    counter.aal = counter.aal + 1;
            end
        end
    end
end

probeset_mnidata.ch_number = length(probeset_mnidata.chs);
probeset_mnidata.opt_number = length(probeset_mnidata.opts);

template = load(fullfile(fileparts(mfilename('fullpath')),'templates',[template_name '.mat']));

% probeset_mnidata.ch_normal = zeros(probeset_mnidata.ch_number,3);

for j = 1:probeset_mnidata.ch_number
    if opt_ch_assignment
        op1id = probeset_mnidata.chs(j).optode_pair(1);
        op2id = probeset_mnidata.chs(j).optode_pair(2);
        opids = arrayfun(@(x) x.id,probeset_mnidata.opts);
        op1 = probeset_mnidata.opts(opids == op1id).coords;
        op2 = probeset_mnidata.opts(opids == op2id).coords;
        probeset_mnidata.chs(j).coords = op1 + 0.5*(op2 - op1);
    end
    p = probeset_mnidata.chs(j).coords;
%     p = [p(2) -p(1) p(3)];
    probeset_mnidata.chs(j).brain_coords = findNearestPointOnPatch(template.brain_patch.vertices,p);
    probeset_mnidata.chs(j).head_coords = findNearestPointOnPatch(template.head_patch.vertices,p);
    if ~label_available
        for lt = Iter(label_types)
            if ~isfield(template,lt)
                error('Label type "%s" not available for template "%s"',label_type,template_name);
            end
            probeset_mnidata.chs(j).anatomic_assignment.(lt) = anatomicalAssignment(probeset_mnidata.chs(j).coords,template.(lt));
        end
    end
    
    t = getBrainTangentials(probeset_mnidata.chs(j).head_coords);
    probeset_mnidata.ch_normal(j,:) = t(:,3)';
end

fprintf('Done!\n')