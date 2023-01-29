function str = multistrreplace(str,replace_cell)

    % multistrreplace(str,replace_cell)
    %
    % Replaces multiple strings - given in replace_cell(:,1) - with the strings replace_cell(:,2)
    % - maximum number of replcements is 26)
    % - Don't use the $-token in string.
    %
    % WikiReplacements: {'strings','[[matlab:basic:string|strings]]'}
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
    % Date: 2016-09-26 14:57:13
    % Packaged: 2017-04-27 17:58:13

r = containers.Map();
n = size(replace_cell,1);
for i = 1:n
    c = char(96+i);
    str = strreplace(str,replace_cell{i,1},['$' c]);
    r(c) = replace_cell{i,2};
end
str = sprintTemplate(str,r);