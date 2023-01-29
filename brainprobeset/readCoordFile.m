function [chd,file_template_name] = readCoordFile(fname,varargin)

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
    % Date: 2017-04-24 15:25:07
    % Packaged: 2017-04-27 17:57:56
param_defaults.opt_ch_assignment = false;
param_defaults.default_template_name = 'Colin27';
param_defaults.label_types = {'brodmann'};
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

label_types = ifel(ischar(label_types),{label_types},label_types);

fc = strtrim(linewise(fname));
fc(cellfun(@isempty,fc)) = [];

chd = struct('file_name',fname,'chs',struct('id',[]),'opts',struct('id',-1));
[chc,opc] = deal(0);
template_name = '';

for l = Iter(fc)
    cols = regexp(l,'\s+','split');
    ch_or_op = regexp(cols{1},'^CH[0-9]+$|^OP[0-9]+$','match');
    if ~isempty(ch_or_op)
        ch_or_op = ch_or_op{1};
        key = ch_or_op(1:2);
        id = str2num(ch_or_op(3:end));
        if length(cols) < 2
            error('readCoordFile: Bad text file at "%s"',l);
        end
        x = str2num(strjoin(cols(2:end)));
        switch key
            case 'CH'
                chc = chc + 1;
                chd.chs(chc).id = id;
                if opt_ch_assignment
                    chd.chs(chc).optode_pair = x;
                else
                    chd.chs(chc).coords = x;
                end
            case 'OP'
                opc = opc + 1;
                chd.opts(opc).id = id;
                chd.opts(opc).coords = x;
        end
    elseif strcmp(cols{1},'TEMPLATE')
        if length(cols) > 1
            template_name = cols{2};
        end
    end
end

file_template_name = '';
if isempty(template_name)
    template_name = default_template_name;
else
    file_template_name = template_name;
end

chd.ch_number = chc;
chd.opt_number = opc;
opids = arrayfun(@(x) x.id,chd.opts);


template = load(fullfile(fileparts(mfilename('fullpath')),'templates',[template_name '.mat']));

for j = 1:chd.ch_number
    if opt_ch_assignment
        [op1id,op2id] = deal(chd.chs(j).optode_pair(1),chd.chs(j).optode_pair(2));
        [op1,op2] = deal(chd.opts(opids == op1id).coords,chd.opts(opids == op2id).coords);
        chd.chs(j).coords = op1 + 0.5*(op2 - op1);
    end
    chd.chs(j).head_coords = nearestvoxel(chd.chs(j).coords,template.head_patch.vertices);
    chd.chs(j).brain_coords = nearestvoxel(chd.chs(j).coords,template.brain_patch.vertices);
    for lt = Iter(label_types)
        if ~isfield(template,lt)
            error('Label type "%s" not available for template "%s"',label_type,template_name);
        end
        chd.chs(j).anatomic_assignment.(lt) = anatomicalAssignment(chd.chs(j).coords,template.(lt));
    end
end