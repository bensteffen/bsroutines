function value_map = extractAssignedValues(names,assign_list,assign_string)

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
    % Date: 2014-09-24 16:26:14
    % Packaged: 2017-04-27 17:58:08
names = ifel(~iscell(names),{names},names);

if nargin < 3
    assign_string = '=';
end

assign_list = regexp(assign_list,['\s*' assign_string '\s*'],'split');
keys = {};
vals = {};

for i = 1:length(names)
    name_i = find(strcmp(names{i},cellfun(@(x) x{1},assign_list,'UniformOutput',false)));
    if ~isempty(name_i)
        name = assign_list{name_i}{1};
        value = assign_list{name_i}{2};
%         n = str2num(value);
%         if ~isempty(n)
%             value = n;
%         end
        keys = [keys {name}];
        vals = [vals {value}];
    end
end

value_map = containers.Map(keys,vals);