function hdr = analyzeNirxHdr(hdr_path)

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
    % Date: 2013-11-25 20:17:01
    % Packaged: 2017-04-27 17:58:50
content = linewise(hdr_path);
content(cellfun(@isempty,content)) = [];

l = 1;
while l <= length(content)
    if strend(content{l},'"#')
        merged_value = '';
        btw_l = 1;
        while ~strcmp(content{l + btw_l},'#"')
            merged_value{btw_l} = content{l + btw_l};
            btw_l = btw_l + 1;
        end
        merged_value = cell2str(merged_value,'; ');
        content(l+1:l+btw_l) = [];
        content{l} = strreplace(content{l},'"#',merged_value);
    end
    l = l + 1;
end

[content,remain] = strtok(content,'[]');

section.lines = find(strcmp(remain,']'));
section.names = content(section.lines);
content(section.lines) = '';

[content,remain] = strtok(content,'=');
parameters.names = content;

remain = strreplace(remain,'=','');
[content,remain] = strtok(remain,'""');

parameters.values = content;
numvals = cellfun(@isempty,remain);
parameters.values(numvals) = cellfun(@str2num,parameters.values(numvals),'UniformOutput',false);

section.lines = diff(section.lines) - 1;
section.lines = [section.lines; length(parameters.names)-sum(section.lines)];

param_line = 1;
for s = 1:length(section.names)
    for p = 1:section.lines(s)
        param_name = parameters.names{param_line};
        param_name = strreplace(param_name,'-','');
        param_name = strreplace(param_name,' ','');
        hdr.(section.names{s}).(param_name) = parameters.values{param_line};
        param_line = param_line + 1;
    end
end
