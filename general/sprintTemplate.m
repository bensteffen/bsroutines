function result_str = sprintTemplate(str_template,str_map)

    % str_template = strinsert(str_template,regexp(str_template,'%'),'%');
    % dollar_i = regexp(str_template,'\$\w');
    % result_str = str_template;
    % for i = dollar_i
    %     tplstr = str_template([i i+1]);
    %     rplstr = str_map(str_template(i+1));
    %     result_str = strreplace(result_str,tplstr,rplstr);
    % end
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
    % Date: 2017-04-06 15:17:15
    % Packaged: 2017-04-27 17:58:19

result_str = str_template;
for k = Iter(str_map.keys)
    result_str = regexprep(result_str,['\$' k],str_map(k));
end