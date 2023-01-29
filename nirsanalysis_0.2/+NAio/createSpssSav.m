%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 22-Feb-2012 18:25:42


function createSpssSav(sav_file_name,D,param_names)

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
    % Date: 2012-10-24 15:24:42
    % Packaged: 2017-04-27 17:58:50
data_names = D.tags(2);
category_names = D.tags(3);
subjects = cell2num(D.tags(4))';


dict_channel_str = [];
subject_case_str = [];
for p = 1:length(param_names)
    for d = 1:length(data_names)
        for c = 1:length(category_names)
            ch_number = size(D.get({param_names{p},data_names{d},category_names{c},subjects(1)}),2);
            for j = 1:ch_number
                var_name = sprintf('%s.%s.%s.CH%d',param_names{p},data_names{d},category_names{c},j);
                dict_channel_str = [dict_channel_str sprintf('\t\t<var type="numeric" name="%s" decimals="5" measure="scale"/>\n',var_name)];
            end
        end
    end
end

case_str = [];
for s = subjects
    case_str = [case_str sprintf('\t<case>\n\t\t<val name="id">%d</val>\n',s)];
    for p = 1:length(param_names)
        for d = 1:length(data_names)
            for c = 1:length(category_names)
                values = D.get({param_names{p},data_names{d},category_names{c},s});
                ch_number = size(values,2);
                for j = 1:ch_number
                    var_name = sprintf('%s.%s.%s.CH%d',param_names{p},data_names{d},category_names{c},j);
                    case_str = [case_str sprintf('\t\t<val name="%s">%f</val>\n',var_name,values(j))];
                end
            end
        end
    end
    case_str = [case_str '\t</case>\n'];
end

content = [...
'<?xml version="1.0" encoding="UTF-8"?>\n' ...
'<spss>\n' ...
'  <sav name="example">\n' ...
'    <dict>\n' ...
'      <var type="numeric" name="id" decimals="0" measure="scale"/>\n' ...
dict_channel_str ...
'    </dict>\n' ...
case_str ...
'  </sav>\n' ...
'</spss>\n' ...
];

xml_name = [sav_file_name '.xml'];
matrix2file(content,xml_name);
eval(['!xml2sav /q ' xml_name]);
delete(xml_name)
movefile([sav_file_name '_example.sav'],[sav_file_name '.sav']);